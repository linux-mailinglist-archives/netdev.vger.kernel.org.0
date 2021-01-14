Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3042F6E34
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbhANW3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:29:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:40978 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbhANW3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 17:29:41 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l0B6w-0004mf-W5; Thu, 14 Jan 2021 23:28:59 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l0B6w-000Gfe-Lz; Thu, 14 Jan 2021 23:28:58 +0100
Subject: Re: [PATCH bpf-next V11 4/7] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
 <161047352084.4003084.16468571234023057969.stgit@firesoul>
 <a14a7490-88c6-9d14-0886-547113242c45@iogearbox.net>
 <20210114153607.6eea9b37@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <776c5832-da48-cc6b-730f-e70aebe73de8@iogearbox.net>
Date:   Thu, 14 Jan 2021 23:28:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210114153607.6eea9b37@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26049/Thu Jan 14 13:41:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 3:36 PM, Jesper Dangaard Brouer wrote:
[...]
>>> +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
>>> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
>>> +{
>>> +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
>>> +	struct net_device *dev = skb->dev;
>>> +	int skb_len, dev_len;
>>> +	int mtu;
>>> +
>>> +	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
>>> +		return -EINVAL;
>>> +
>>> +	dev = __dev_via_ifindex(dev, ifindex);
>>> +	if (unlikely(!dev))
>>> +		return -ENODEV;
>>> +
>>> +	mtu = READ_ONCE(dev->mtu);
>>> +
>>> +	dev_len = mtu + dev->hard_header_len;
>>> +	skb_len = skb->len + len_diff; /* minus result pass check */
>>> +	if (skb_len <= dev_len) {
>>> +		ret = BPF_MTU_CHK_RET_SUCCESS;
>>> +		goto out;
>>> +	}
>>> +	/* At this point, skb->len exceed MTU, but as it include length of all
>>> +	 * segments, it can still be below MTU.  The SKB can possibly get
>>> +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
>>> +	 * must choose if segs are to be MTU checked.  Last SKB "headlen" is
>>> +	 * checked against MTU.
>>> +	 */
>>> +	if (skb_is_gso(skb)) {
>>> +		ret = BPF_MTU_CHK_RET_SUCCESS;
>>> +
>>> +		if (!(flags & BPF_MTU_CHK_SEGS))
>>> +			goto out;
>>> +
>>> +		if (!skb_gso_validate_network_len(skb, mtu)) {
>>> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
>>> +			goto out;
>>> +		}
>>> +
>>> +		skb_len = skb_headlen(skb) + len_diff;
>>> +		if (skb_len > dev_len) {
[...]
>> Do you have a particular use case for the BPF_MTU_CHK_SEGS?
> 
> The complaint from Maze (and others) were that when skb_is_gso then all
> the MTU checks are bypassed.  This flag enables checking the GSO part
> via skb_gso_validate_network_len().  We cannot enable it per default,
> as you say, it is universally correct in all cases.

If there is a desire to have access to the skb_gso_validate_network_len(), I'd
keep that behind the flag then, but would drop the skb_headlen(skb) + len_diff
case given the mentioned case on rx where it would yield misleading results to
users that might be unintuitive & hard to debug.

>> I also don't see the flag being used anywhere in your selftests, so I presume
>> not as otherwise you would have added an example there?
> 
> I'm using the flag in the bpf-examples code[1], this is how I've tested
> the code path.
> 
> I've not found a way to generate GSO packet via the selftests
> infrastructure via bpf_prog_test_run_xattr().  I'm
> 
> [1] https://github.com/xdp-project/bpf-examples/blob/master/MTU-tests/tc_mtu_enforce.c

Haven't checked but likely something as prog_tests/skb_ctx.c might not be sufficient
to pass it into the helper. For real case you might need a netns + veth setup like
some of the other tests are doing and then generating TCP stream from one end to the
other.
