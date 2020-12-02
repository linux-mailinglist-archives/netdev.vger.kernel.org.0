Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5F2CCA7A
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgLBXX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:23:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:55064 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgLBXX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:23:57 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkbSt-0004Um-KL; Thu, 03 Dec 2020 00:23:15 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkbSt-000VED-Ag; Thu, 03 Dec 2020 00:23:15 +0100
Subject: Re: [PATCH bpf-next V8 4/8] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
 <160650039783.2890576.1174164236647947165.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e5d7ade3-6648-5934-ede1-956e379834a2@iogearbox.net>
Date:   Thu, 3 Dec 2020 00:23:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160650039783.2890576.1174164236647947165.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26006/Wed Dec  2 14:14:18 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 7:06 PM, Jesper Dangaard Brouer wrote:
[...]
> +static struct net_device *__dev_via_ifindex(struct net_device *dev_curr,
> +					    u32 ifindex)
> +{
> +	struct net *netns = dev_net(dev_curr);
> +
> +	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
> +	if (ifindex == 0)
> +		return dev_curr;
> +
> +	return dev_get_by_index_rcu(netns, ifindex);
> +}
> +
> +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> +{
> +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +	struct net_device *dev = skb->dev;
> +	int len;
> +	int mtu;
> +
> +	if (flags & ~(BPF_MTU_CHK_SEGS))

nit: unlikely() (similar for XDP case)

> +		return -EINVAL;
> +
> +	dev = __dev_via_ifindex(dev, ifindex);
> +	if (!dev)

nit: unlikely() (ditto XDP)

> +		return -ENODEV;
> +
> +	mtu = READ_ONCE(dev->mtu);
> +
> +	/* TC len is L2, remove L2-header as dev MTU is L3 size */
> +	len = skb->len - ETH_HLEN;

s/ETH_HLEN/dev->hard_header_len/ ?

> +	len += len_diff; /* len_diff can be negative, minus result pass check */
> +	if (len <= mtu) {
> +		ret = BPF_MTU_CHK_RET_SUCCESS;

Wouldn't it be more intuitive to do ...

    len_dev = READ_ONCE(dev->mtu) + dev->hard_header_len + VLAN_HLEN;
    len_skb = skb->len + len_diff;
    if (len_skb <= len_dev) {
       ret = BPF_MTU_CHK_RET_SUCCESS;
       got out;
    }

> +		goto out;
> +	}
> +	/* At this point, skb->len exceed MTU, but as it include length of all
> +	 * segments, it can still be below MTU.  The SKB can possibly get
> +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> +	 * must choose if segs are to be MTU checked.  Last SKB "headlen" is
> +	 * checked against MTU.
> +	 */
> +	if (skb_is_gso(skb)) {
> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> +
> +		if (flags & BPF_MTU_CHK_SEGS &&
> +		    skb_gso_validate_network_len(skb, mtu)) {
> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
> +			goto out;

Maybe my lack of coffe, but looking at ip_exceeds_mtu() for example, shouldn't
the above test be on !skb_gso_validate_network_len() instead?

skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu) would indicate that
it does /not/ exceed mtu.

> +		}
> +
> +		len = skb_headlen(skb) - ETH_HLEN + len_diff;

How does this work with GRO when we invoke this helper at tc ingress, e.g. when
there is still non-linear data in skb_shinfo(skb)->frags[]?

> +		if (len > mtu) {
> +			ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +			goto out;
> +		}
> +	}
> +out:
> +	/* BPF verifier guarantees valid pointer */
> +	*mtu_len = mtu;
> +
> +	return ret;
> +}
> +
> +BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> +{
> +	struct net_device *dev = xdp->rxq->dev;
> +	int len = xdp->data_end - xdp->data;
> +	int ret = BPF_MTU_CHK_RET_SUCCESS;
> +	int mtu;
> +
> +	/* XDP variant doesn't support multi-buffer segment check (yet) */
> +	if (flags)
> +		return -EINVAL;
> +
> +	dev = __dev_via_ifindex(dev, ifindex);
> +	if (!dev)
> +		return -ENODEV;
> +
> +	mtu = READ_ONCE(dev->mtu);
> +
> +	/* XDP len is L2, remove L2-header as dev MTU is L3 size */
> +	len -= ETH_HLEN;
> +
> +	len += len_diff; /* len_diff can be negative, minus result pass check */
> +	if (len > mtu)
> +		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +
> +	/* BPF verifier guarantees valid pointer */
> +	*mtu_len = mtu;
> +
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_skb_check_mtu_proto = {
> +	.func		= bpf_skb_check_mtu,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type      = ARG_PTR_TO_CTX,
> +	.arg2_type      = ARG_ANYTHING,
> +	.arg3_type      = ARG_PTR_TO_INT,
> +	.arg4_type      = ARG_ANYTHING,
> +	.arg5_type      = ARG_ANYTHING,
> +};
> +
> +static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
> +	.func		= bpf_xdp_check_mtu,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type      = ARG_PTR_TO_CTX,
> +	.arg2_type      = ARG_ANYTHING,
> +	.arg3_type      = ARG_PTR_TO_INT,
> +	.arg4_type      = ARG_ANYTHING,
> +	.arg5_type      = ARG_ANYTHING,
> +};
[...]
