Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396FF30120C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbhAWBgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:36:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:59462 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbhAWBgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 20:36:25 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l37q2-00040d-D8; Sat, 23 Jan 2021 02:35:42 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l37q2-000SRn-3o; Sat, 23 Jan 2021 02:35:42 +0100
Subject: Re: [PATCH bpf-next V12 4/7] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
 <161098887018.108067.13643446976934084937.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6772a12b-2a60-bb3b-93df-1d6d6c7c7fd7@iogearbox.net>
Date:   Sat, 23 Jan 2021 02:35:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <161098887018.108067.13643446976934084937.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26057/Fri Jan 22 13:30:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 5:54 PM, Jesper Dangaard Brouer wrote:
> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> 
> The SKB object is complex and the skb->len value (accessible from
> BPF-prog) also include the length of any extra GRO/GSO segments, but
> without taking into account that these GRO/GSO segments get added
> transport (L4) and network (L3) headers before being transmitted. Thus,
> this BPF-helper is created such that the BPF-programmer don't need to
> handle these details in the BPF-prog.
> 
> The API is designed to help the BPF-programmer, that want to do packet
> context size changes, which involves other helpers. These other helpers
> usually does a delta size adjustment. This helper also support a delta
> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> these other helpers, and perform the MTU check prior to doing any actual
> size adjustment of the packet context.
> 
> It is on purpose, that we allow the len adjustment to become a negative
> result, that will pass the MTU check. This might seem weird, but it's not
> this helpers responsibility to "catch" wrong len_diff adjustments. Other
> helpers will take care of these checks, if BPF-programmer chooses to do
> actual size adjustment.
> 
> V12:
>   - Simplify segment check that calls skb_gso_validate_network_len.
>   - Helpers should return long
> 
> V9:
> - Use dev->hard_header_len (instead of ETH_HLEN)
> - Annotate with unlikely req from Daniel
> - Fix logic error using skb_gso_validate_network_len from Daniel
> 
> V6:
> - Took John's advice and dropped BPF_MTU_CHK_RELAX
> - Returned MTU is kept at L3-level (like fib_lookup)
> 
> V4: Lot of changes
>   - ifindex 0 now use current netdev for MTU lookup
>   - rename helper from bpf_mtu_check to bpf_check_mtu
>   - fix bug for GSO pkt length (as skb->len is total len)
>   - remove __bpf_len_adj_positive, simply allow negative len adj
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++++
>   net/core/filter.c              |  111 ++++++++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++++
>   3 files changed, 245 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 05bfc8c843dc..f17381a337ec 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3839,6 +3839,61 @@ union bpf_attr {
>    *	Return
>    *		A pointer to a struct socket on success or NULL if the file is
>    *		not a socket.
> + *
> + * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
> + *	Description
> + *		Check ctx packet size against MTU of net device (based on
> + *		*ifindex*).  This helper will likely be used in combination with
> + *		helpers that adjust/change the packet size.  The argument
> + *		*len_diff* can be used for querying with a planned size
> + *		change. This allows to check MTU prior to changing packet ctx.
> + *
> + *		Specifying *ifindex* zero means the MTU check is performed
> + *		against the current net device.  This is practical if this isn't
> + *		used prior to redirect.
> + *
> + *		The Linux kernel route table can configure MTUs on a more
> + *		specific per route level, which is not provided by this helper.
> + *		For route level MTU checks use the **bpf_fib_lookup**\ ()
> + *		helper.
> + *
> + *		*ctx* is either **struct xdp_md** for XDP programs or
> + *		**struct sk_buff** for tc cls_act programs.
> + *
> + *		The *flags* argument can be a combination of one or more of the
> + *		following values:
> + *
> + *		**BPF_MTU_CHK_SEGS**
> + *			This flag will only works for *ctx* **struct sk_buff**.
> + *			If packet context contains extra packet segment buffers
> + *			(often knows as GSO skb), then MTU check is harder to
> + *			check at this point, because in transmit path it is
> + *			possible for the skb packet to get re-segmented
> + *			(depending on net device features).  This could still be
> + *			a MTU violation, so this flag enables performing MTU
> + *			check against segments, with a different violation
> + *			return code to tell it apart. Check cannot use len_diff.
> + *
> + *		On return *mtu_len* pointer contains the MTU value of the net
> + *		device.  Remember the net device configured MTU is the L3 size,
> + *		which is returned here and XDP and TX length operate at L2.
> + *		Helper take this into account for you, but remember when using
> + *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
> + *		pointer and be initialized (to zero), else verifier will reject
> + *		BPF program.
> + *
> + *	Return
> + *		* 0 on success, and populate MTU value in *mtu_len* pointer.
> + *
> + *		* < 0 if any input argument is invalid (*mtu_len* not updated)
> + *
> + *		MTU violations return positive values, but also populate MTU
> + *		value in *mtu_len* pointer, as this can be needed for
> + *		implementing PMTU handing:
> + *
> + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
> + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
> + *
>    */
[...]
> +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> +{
> +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +	struct net_device *dev = skb->dev;
> +	int skb_len, dev_len;
> +	int mtu;
> +
> +	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
> +		return -EINVAL;
> +
> +	dev = __dev_via_ifindex(dev, ifindex);
> +	if (unlikely(!dev))
> +		return -ENODEV;
> +
> +	mtu = READ_ONCE(dev->mtu);
> +
> +	dev_len = mtu + dev->hard_header_len;
> +	skb_len = skb->len + len_diff; /* minus result pass check */
> +	if (skb_len <= dev_len) {
> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> +		goto out;
> +	}
> +	/* At this point, skb->len exceed MTU, but as it include length of all
> +	 * segments, it can still be below MTU.  The SKB can possibly get
> +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> +	 * must choose if segs are to be MTU checked.
> +	 */
> +	if (skb_is_gso(skb)) {
> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> +
> +		if (flags & BPF_MTU_CHK_SEGS &&
> +		    !skb_gso_validate_network_len(skb, mtu))
> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;

I think that looks okay overall now. One thing that will easily slip through
is that in the helper description you mentioned 'Check cannot use len_diff.'
for BPF_MTU_CHK_SEGS flag. So right now for non-zero len_diff the user
will still get BPF_MTU_CHK_RET_SUCCESS if the current length check via
skb_gso_validate_network_len(skb, mtu) passes. If it cannot be checked,
maybe enforce len_diff == 0 for gso skbs on BPF_MTU_CHK_SEGS?

> +	}
> +out:
> +	/* BPF verifier guarantees valid pointer */
> +	*mtu_len = mtu;
> +
> +	return ret;
> +}
