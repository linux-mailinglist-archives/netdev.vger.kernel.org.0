Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C4344956
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfFMRQb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 13:16:31 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43249 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfFLVdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 17:33:21 -0400
Received: by mail-ed1-f65.google.com with SMTP id w33so27858317edb.10
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 14:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=s22gOY5LtmHR8QEuhEI3LaHImnMs/xPnvsDRhgjEC6g=;
        b=cqDB5a1/ZXZP7G3LpECLq7AtdRnHnlQIxAgTQLuBw8qm1HFAEtNGj3BQxHzWwS7JEZ
         Kh7Vg13TONX63vpp1vX+qwxwv5JrZasZJBv2BsQROgAqCe/OMnAxxeBbx5CVjfpeE+V6
         euMZUnzOPmZst1OrEFjFbyKbGvGXMpvfxZz2cTfnhP6fk2DSvZIvCn6vK/JNW6Asunxz
         gxUIoUObvgU9+o8PcSR8FeaxYxORnWNcV1ne0HHxGWjyBjQRXOscxzAUpsVQwlMpTTbi
         Skdy6BqE9taAuYeDEggSMjCvLvaQuKoCVrd0jtdjkaNeRaiJ0jPT1fgOfuaM6K0QZWKE
         mFoA==
X-Gm-Message-State: APjAAAW2b34nPLswiFjypM90mxCXOz8aFvIr52bPF4E9W4gr14FJx3B4
        SJ2gukun1gXfhEmQ5ySEvnv7FA==
X-Google-Smtp-Source: APXvYqyoZoV3Kmo0HXSUaROgsUeAf75u0UsWYAuszGGIcRzLNdut9KNrgLPsKNWClEdtQHu+FfSPNA==
X-Received: by 2002:a50:b617:: with SMTP id b23mr21507847ede.135.1560375198813;
        Wed, 12 Jun 2019 14:33:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z22sm296540edz.6.2019.06.12.14.33.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 14:33:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 73A80180092; Wed, 12 Jun 2019 23:33:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <20190612220105.00000d39@gmail.com>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1> <156026784011.26748.7290735899755011809.stgit@alrua-x1> <20190611200021.473138bc@carbon> <87y328f0m9.fsf@toke.dk> <20190612220105.00000d39@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 12 Jun 2019 23:33:17 +0200
Message-ID: <8736kefq02.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciejromanfijalkowski@gmail.com> writes:

> On Tue, 11 Jun 2019 20:17:02 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> 
>> > On Tue, 11 Jun 2019 17:44:00 +0200
>> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >  
>> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> 
>> >> The bpf_redirect_map() helper used by XDP programs doesn't return any
>> >> indication of whether it can successfully redirect to the map index it was
>> >> given. Instead, BPF programs have to track this themselves, leading to
>> >> programs using duplicate maps to track which entries are populated in the
>> >> devmap.
>> >> 
>> >> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>> >> helper, which makes it possible to return failure to the eBPF program. The
>> >> lower bits of the flags argument is used as the return code, which means
>> >> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>> >> 
>> >> With this, a BPF program can check the return code from the helper call and
>> >> react by, for instance, substituting a different redirect. This works for
>> >> any type of map used for redirect.
>> >> 
>> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> ---
>> >>  include/linux/filter.h   |    1 +
>> >>  include/uapi/linux/bpf.h |    8 ++++++++
>> >>  net/core/filter.c        |   26 ++++++++++++--------------
>> >>  3 files changed, 21 insertions(+), 14 deletions(-)
>> >> 
>> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> >> index 43b45d6db36d..f31ae8b9035a 100644
>> >> --- a/include/linux/filter.h
>> >> +++ b/include/linux/filter.h
>> >> @@ -580,6 +580,7 @@ struct bpf_skb_data_end {
>> >>  struct bpf_redirect_info {
>> >>  	u32 ifindex;
>> >>  	u32 flags;
>> >> +	void *item;
>> >>  	struct bpf_map *map;
>> >>  	struct bpf_map *map_to_flush;
>> >>  	u32 kern_flags;
>> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> >> index 7c6aef253173..9931cf02de19 100644
>> >> --- a/include/uapi/linux/bpf.h
>> >> +++ b/include/uapi/linux/bpf.h
>> >> @@ -3098,6 +3098,14 @@ enum xdp_action {
>> >>  	XDP_REDIRECT,
>> >>  };
>> >>  
>> >> +/* Flags for bpf_xdp_redirect_map helper */
>> >> +
>> >> +/* The lower flag bits will be the return code of bpf_xdp_redirect_map() helper
>> >> + * if the map lookup fails.
>> >> + */
>> >> +#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
>> >> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_INVALID_MASK
>> >> +  
>> >
>> > Slightly confused about the naming of the define, see later.
>> >  
>> >>  /* user accessible metadata for XDP packet hook
>> >>   * new fields must be added to the end of this structure
>> >>   */
>> >> diff --git a/net/core/filter.c b/net/core/filter.c
>> >> index 7a996887c500..dd43be497480 100644
>> >> --- a/net/core/filter.c
>> >> +++ b/net/core/filter.c
>> >> @@ -3608,17 +3608,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
>> >>  			       struct bpf_redirect_info *ri)
>> >>  {
>> >>  	u32 index = ri->ifindex;
>> >> -	void *fwd = NULL;
>> >> +	void *fwd = ri->item;
>> >>  	int err;
>> >>  
>> >>  	ri->ifindex = 0;
>> >> +	ri->item = NULL;
>> >>  	WRITE_ONCE(ri->map, NULL);
>> >>  
>> >> -	fwd = __xdp_map_lookup_elem(map, index);
>> >> -	if (unlikely(!fwd)) {
>> >> -		err = -EINVAL;
>> >> -		goto err;
>> >> -	}
>> >>  	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
>> >>  		xdp_do_flush_map();
>> >>  
>> >> @@ -3655,18 +3651,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
>> >>  {
>> >>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>> >>  	u32 index = ri->ifindex;
>> >> -	void *fwd = NULL;
>> >> +	void *fwd = ri->item;
>> >>  	int err = 0;
>> >>  
>> >>  	ri->ifindex = 0;
>> >> +	ri->item = NULL;
>> >>  	WRITE_ONCE(ri->map, NULL);
>> >>  
>> >> -	fwd = __xdp_map_lookup_elem(map, index);
>> >> -	if (unlikely(!fwd)) {
>> >> -		err = -EINVAL;
>> >> -		goto err;
>> >> -	}
>> >> -
>> >>  	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>> >>  		struct bpf_dtab_netdev *dst = fwd;
>> >>  
>> >> @@ -3735,6 +3726,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
>> >>  
>> >>  	ri->ifindex = ifindex;
>> >>  	ri->flags = flags;
>> >> +	ri->item = NULL;
>> >>  	WRITE_ONCE(ri->map, NULL);
>> >>  
>> >>  	return XDP_REDIRECT;
>> >> @@ -3753,9 +3745,15 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>> >>  {
>> >>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>> >>  
>> >> -	if (unlikely(flags))
>> >> +	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>> >>  		return XDP_ABORTED;
>> >>  
>
> Here you don't allow the flags to get different value than
> XDP_REDIRECT_ALL_FLAGS.
>
>> >> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
>> >> +	if (unlikely(!ri->item)) {
>> >> +		WRITE_ONCE(ri->map, NULL);
>> >> +		return (flags & XDP_REDIRECT_INVALID_MASK);  
>
> So here you could just return flags? Don't we know that the flags
> value is legit here? Am I missing something?

No, you're right. I was just worried that we would forget to change this
when we add another flag later on, so I thought I'd mask it from the
get-go. Can't the compiler figure out that the second mask is unnecessary?

> TBH the v2 was more clear to me.

Clearer how? As in, you prefer just always returning XDP_PASS on error?

-Toke

>> > Maybe I'm reading it wrong, but shouldn't the mask be called the "valid" mask?  
>> 
>> It's the mask that is applied when the index looked up is invalid (i.e.,
>> the entry doesn't exist)? But yeah, can see how the name can be
>> confusing; maybe it should just be "RETURN_MASK" or something like that?
>
> Maybe something along ALLOWED_RETVAL_MASK?

Yeah, good idea! :)

-Toke
