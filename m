Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8727A302F07
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732441AbhAYW2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:28:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:59376 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732127AbhAYW2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:28:08 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4AKR-0004gm-Qi; Mon, 25 Jan 2021 23:27:23 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4AKR-0009UD-Gr; Mon, 25 Jan 2021 23:27:23 +0100
Subject: Re: [PATCH bpf-next V12 4/7] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
 <161098887018.108067.13643446976934084937.stgit@firesoul>
 <6772a12b-2a60-bb3b-93df-1d6d6c7c7fd7@iogearbox.net>
 <20210125094148.2b3bb128@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3c542e42-2033-aca6-ba0e-4854c24980c2@iogearbox.net>
Date:   Mon, 25 Jan 2021 23:27:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210125094148.2b3bb128@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26060/Mon Jan 25 13:28:03 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 9:41 AM, Jesper Dangaard Brouer wrote:
> On Sat, 23 Jan 2021 02:35:41 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>>> + *		The *flags* argument can be a combination of one or more of the
>>> + *		following values:
>>> + *
>>> + *		**BPF_MTU_CHK_SEGS**
>>> + *			This flag will only works for *ctx* **struct sk_buff**.
>>> + *			If packet context contains extra packet segment buffers
>>> + *			(often knows as GSO skb), then MTU check is harder to
>>> + *			check at this point, because in transmit path it is
>>> + *			possible for the skb packet to get re-segmented
>>> + *			(depending on net device features).  This could still be
>>> + *			a MTU violation, so this flag enables performing MTU
>>> + *			check against segments, with a different violation
>>> + *			return code to tell it apart. Check cannot use len_diff.
>>> + *
>>> + *		On return *mtu_len* pointer contains the MTU value of the net
>>> + *		device.  Remember the net device configured MTU is the L3 size,
>>> + *		which is returned here and XDP and TX length operate at L2.
>>> + *		Helper take this into account for you, but remember when using
>>> + *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
>>> + *		pointer and be initialized (to zero), else verifier will reject
>>> + *		BPF program.
>>> + *
>>> + *	Return
>>> + *		* 0 on success, and populate MTU value in *mtu_len* pointer.
>>> + *
>>> + *		* < 0 if any input argument is invalid (*mtu_len* not updated)
>>> + *
>>> + *		MTU violations return positive values, but also populate MTU
>>> + *		value in *mtu_len* pointer, as this can be needed for
>>> + *		implementing PMTU handing:
>>> + *
>>> + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
>>> + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
>>> + *
>>>     */
>> [...]
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
>>> +	 * must choose if segs are to be MTU checked.
>>> +	 */
>>> +	if (skb_is_gso(skb)) {
>>> +		ret = BPF_MTU_CHK_RET_SUCCESS;
>>> +
>>> +		if (flags & BPF_MTU_CHK_SEGS &&
>>> +		    !skb_gso_validate_network_len(skb, mtu))
>>> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
>>
>> I think that looks okay overall now. One thing that will easily slip through
>> is that in the helper description you mentioned 'Check cannot use len_diff.'
>> for BPF_MTU_CHK_SEGS flag. So right now for non-zero len_diff the user
>> will still get BPF_MTU_CHK_RET_SUCCESS if the current length check via
>> skb_gso_validate_network_len(skb, mtu) passes. If it cannot be checked,
>> maybe enforce len_diff == 0 for gso skbs on BPF_MTU_CHK_SEGS?
> 
> Ok. Do you want/think this can be enforced by the verifier or are you
> simply requesting that the helper will return -EINVAL (or another errno)?

Simple -EINVAL should be fine in this case. Generally, we can detect this from
verifier side but I don't think the extra complexity is worth it especially given
this is dependent on BPF_MTU_CHK_SEGS and otherwise can be non-zero.

Thanks,
Daniel
