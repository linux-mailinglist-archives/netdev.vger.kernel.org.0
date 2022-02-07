Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C324B4AB41E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiBGFrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbiBGCxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 21:53:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F285C061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 18:53:47 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so12025288pjl.2
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 18:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ON6wKi2JZhFM9QoIxStW/3o6E+AlirJLBp5dj83vpTs=;
        b=KSf0LfIBfxtLhuDk7AFp1Q8kqGEVBG8q4kZinuVo9haXQrY3ehkGg1sIHExnVn1FSL
         OR8qlPutU6bVUN2Kf1Ibu7299ylhlruAV0FGkzLNKtVrxUShNX5/3FtnCIJ39OBuTbFw
         kzSzQO9D+hTQWP0SHyin15KCIVDM/oePIXscM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ON6wKi2JZhFM9QoIxStW/3o6E+AlirJLBp5dj83vpTs=;
        b=xo2wPiDbOoBCGjVyHyD6OIhH/lDEnM2Q9rxJMp+kjV1Fd/e8DRwWENaAut7bOceM3d
         nYHqdkTpvf53lzFrmQK4ur5jg144Ik8ZL6CUWsK9Lk/4Y4iHCT8WUsG5rEV9h90VZaFB
         +jIssUpPwejq0YgipshLuFJUA0+HG7mWmXGdU2Bo2MxBOnFJj9El3737IjlCC/HNLw/3
         yPGORhnwFwDQVn+QQESRUBePp93zyGdS2h1CMfeShoJt3x3k24COTqUKzqY0veVYE0Yz
         og8WZ2f3Mjljx7E/F4irFf/PqMl36pAMd08Wj6EjloBVfYwJJLxUmNwtlcwat3rr0j8I
         3TcA==
X-Gm-Message-State: AOAM5330N7BE6M7oWd/XLJUtE83OtbEBeIaTh1Ezuj5zLn/Biiu19FlQ
        /bxa74GrfS3FUOaXxjK9GKeNZw==
X-Google-Smtp-Source: ABdhPJz9k9DZi9V8DEhE6qdfqvfw7rCkgh+XP5oOqs+AgdR4s/c33C+xyoXyCwEjd4oQ63Daq0QohQ==
X-Received: by 2002:a17:903:2093:: with SMTP id d19mr14279688plc.29.1644202426331;
        Sun, 06 Feb 2022 18:53:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j3sm7030042pgs.0.2022.02.06.18.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 18:53:45 -0800 (PST)
Date:   Sun, 6 Feb 2022 18:53:44 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [RFC PATCH 2/3] net: gro: minor optimization for
 dev_gro_receive()
Message-ID: <202202061826.50506BF8@keescook>
References: <cover.1642519257.git.pabeni@redhat.com>
 <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com>
 <20220118155620.27706-1-alexandr.lobakin@intel.com>
 <c262125543e39d6b869e522da0ed59044eb07722.camel@redhat.com>
 <20220118173903.31823-1-alexandr.lobakin@intel.com>
 <7bbab59c6d6cd2eb4e6d2fb7b2c2636b7d03445d.camel@redhat.com>
 <20220202120827.23716-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202120827.23716-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 01:08:27PM +0100, Alexander Lobakin wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Wed, 02 Feb 2022 11:09:41 +0100
> 
> > Hello,
> 
> Hi!
> 
> > 
> > On Tue, 2022-01-18 at 18:39 +0100, Alexander Lobakin wrote:
> > > From: Paolo Abeni <pabeni@redhat.com>
> > > Date: Tue, 18 Jan 2022 17:31:00 +0100
> > > 
> > > > On Tue, 2022-01-18 at 16:56 +0100, Alexander Lobakin wrote:
> > > > > From: Paolo Abeni <pabeni@redhat.com>
> > > > > Date: Tue, 18 Jan 2022 16:24:19 +0100
> > > > > 
> > > > > > While inspecting some perf report, I noticed that the compiler
> > > > > > emits suboptimal code for the napi CB initialization, fetching
> > > > > > and storing multiple times the memory for flags bitfield.
> > > > > > This is with gcc 10.3.1, but I observed the same with older compiler
> > > > > > versions.
> > > > > > 
> > > > > > We can help the compiler to do a nicer work e.g. initially setting
> > > > > > all the bitfield to 0 using an u16 alias. The generated code is quite
> > > > > > smaller, with the same number of conditional
> > > > > > 
> > > > > > Before:
> > > > > > objdump -t net/core/gro.o | grep " F .text"
> > > > > > 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> > > > > > 
> > > > > > After:
> > > > > > 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> > > > > > 
> > > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > ---
> > > > > >  include/net/gro.h | 13 +++++++++----
> > > > > >  net/core/gro.c    | 16 +++++-----------
> > > > > >  2 files changed, 14 insertions(+), 15 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/net/gro.h b/include/net/gro.h
> > > > > > index 8f75802d50fd..a068b27d341f 100644
> > > > > > --- a/include/net/gro.h
> > > > > > +++ b/include/net/gro.h
> > > > > > @@ -29,14 +29,17 @@ struct napi_gro_cb {
> > > > > >  	/* Number of segments aggregated. */
> > > > > >  	u16	count;
> > > > > >  
> > > > > > -	/* Start offset for remote checksum offload */
> > > > > > -	u16	gro_remcsum_start;
> > > > > > +	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > > > > +	u16	proto;
> > > > > >  
> > > > > >  	/* jiffies when first packet was created/queued */
> > > > > >  	unsigned long age;
> > > > > >  
> > > > > > -	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > > > > -	u16	proto;
> > > > > > +	/* portion of the cb set to zero at every gro iteration */
> > > > > > +	u32	zeroed_start[0];
> > > > > > +
> > > > > > +	/* Start offset for remote checksum offload */
> > > > > > +	u16	gro_remcsum_start;
> > > > > >  
> > > > > >  	/* This is non-zero if the packet may be of the same flow. */
> > > > > >  	u8	same_flow:1;
> > > > > > @@ -70,6 +73,8 @@ struct napi_gro_cb {
> > > > > >  	/* GRO is done by frag_list pointer chaining. */
> > > > > >  	u8	is_flist:1;
> > > > > >  
> > > > > > +	u32	zeroed_end[0];
> > > > > 
> > > > > This should be wrapped in struct_group() I believe, or compilers
> > > > > will start complaining soon. See [0] for the details.
> > > > > Adding Kees to the CCs.

Hi! Sorry I missed the original email sent my way. :)

> > > > 
> > > > Thank you for the reference. That really slipped-off my mind.
> > > > 
> > > > This patch does not use memcpy() or similar, just a single direct
> > > > assignement. Would that still require struct_group()?
> > > 
> > > Oof, sorry, I saw start/end and overlooked that it's only for
> > > a single assignment.
> > > Then it shouldn't cause warnings, but maybe use an anonymous
> > > union instead?
> > > 
> > > 	union {
> > > 		u32 zeroed;
> > > 		struct {
> > > 			u16 gro_remcsum_start;
> > > 			...
> > > 		};
> > > 	};
> > > 	__wsum csum;
> > > 
> > > Use can still use a BUILD_BUG_ON() in this case, like
> > > sizeof(zeroed) != offsetof(csum) - offsetof(zeroed).
> > 
> > Please forgive me for the very long delay. I'm looking again at this
> > stuff for formal non-rfc submission.
> 
> Sure, not a problem at all (:
> 
> > 
> > I like the anonymous union less, because it will move around much more
> > code - making the patch less readable - and will be more fragile e.g.
> > some comment alike "please don't move around 'csum'" would be needed.
> 
> We still need comments around zeroed_{start,end}[0] for now.
> I used offsetof(csum) as offsetofend(is_flist) which I'd prefer here
> unfortunately expands to offsetof(is_flist) + sizeof(is_flist), and
> the latter causes an error of using sizeof() against a bitfield.
> 
> > 
> > No strong opinion anyway, so if you really prefer that way I can adapt.
> > Please let me know.
> 
> I don't really have a strong preference here, I just suspect that
> zero-length array will produce or already produce -Warray-bounds
> warnings, and empty-struct constructs like

Yes, -Warray-bounds would yell very loudly about an 0-element array
having its first element assigned. :)

> 
> 	struct { } zeroed_start;
> 	u16 gro_remcsum_start;
> 	...
> 	struct { } zeroed_end;
> 
> 	memset(NAPI_GRO_CB(skb)->zeroed_start, 0,
> 	       offsetofend(zeroed_end) - offsetsof(zeroed_start));
> 
> will trigger Fortify compile-time errors from Kees' KSPP tree.
> 
> I think we could use
> 
> 	__struct_group(/* no tag */, zeroed, /* no attrs */,

Since this isn't UAPI, you can just do:

	struct_group(zeroed,

> 		u16 gro_remcsum_start;
> 		...
> 		u8 is_flist:1;
> 	);
> 	__wsum csum;
> 
> 	BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
> 	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
> 				 sizeof(u32))); /* Avoid slow unaligned acc */
> 
> 	*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
> 
> This doesn't depend on `csum`, doesn't need `struct { }` or
> `struct zero[0]` markers and still uses a direct assignment.

Given the kernel's -O2 use, a constant-sized u32 memcpy() and a direct
assignment will resolve to the same machine code:

https://godbolt.org/z/b9qKexx6q

void zero_var(struct object *p)
{
    p->zero_var = 0;
}

void zero_group(struct object *p)
{
    memset(&p->zero_group, 0, sizeof(p->zero_group));
}

zero_var:
  movl $0, (%rdi)
  ret
zero_group:
  movl $0, (%rdi)
  ret

And assigning them individually results in careful "and"ing to avoid the
padding:

zero_each:
  andl $-134217728, (%rdi)
  ret

I would have recommended struct_group() + memset() here, just because
you don't need the casts. But since you're doing BUILD_BUG_ON() size
verification, it's fine either way.

If you want to avoid the cast and avoid the memset(), you could use the
earlier suggestion of anonymous union and anonymous struct. It's
basically an open-coded struct_group, but you get to pick the type of
the overlapping variable. :)

-Kees

> Also adding Gustavo, maybe he'd like to leave a comment here.
> 
> > 
> > Thanks!
> > 
> > Paolo
> 
> Thanks,
> Al

-- 
Kees Cook
