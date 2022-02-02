Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4C94A6E62
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiBBKJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:09:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235476AbiBBKJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643796586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+qf0s6BykmtRIsqLWmSprlndxm0M5jf/4U7O4auQ8Y=;
        b=RzaEM8qCOQy3zNVY2sAn/Y8NSxJHv3SRb0wGdTR17ab5qLpCRwGNN3CfGa28akZbC8Sroq
        oZvhPTNTsNVBCWBmfU/uoA/SURTwCfFmHvO2dk6eO3u5fmuiwAzYtkdeJNgdxJawyQsrr8
        00kYgnWgCJhDTUHnsGEY4WTeum8h4JA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-K7Idx4URPT-ZAXtb4FpJ3A-1; Wed, 02 Feb 2022 05:09:45 -0500
X-MC-Unique: K7Idx4URPT-ZAXtb4FpJ3A-1
Received: by mail-wm1-f71.google.com with SMTP id l20-20020a05600c1d1400b0035153bf34c3so3584049wms.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 02:09:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=S+qf0s6BykmtRIsqLWmSprlndxm0M5jf/4U7O4auQ8Y=;
        b=7XxJoH/9NZAQ1ZtDb914EAwHBIDpGE3TY2phPwhAnzF3J+BNK+QQNOqJbMpesiqJPl
         0ISBnyCZrDroxFvjW9gRlgUhBS1KQwqdutVk21h0Gxn14a4xms8uppV6txIXnHcOrZE6
         +mQvFakOLGU/Dj/KE4m2Wtj3OP5DqMtXcnnGtcvhj5hkyBDVA40khNpV8H86SqP3oPYL
         n1kj2d57RamQQPVIWGZIMD2uIvGN7G/2pJxw4o2eqiUCy8PVFpo7R7c6eQl+c4wwNhkJ
         TS52KnYBv/uvPO6W2A8uMf5UwUV3dR5s1OCrxOfVTAC1d1YGJ5TwFHT9+lmnEKucFvMZ
         kGrg==
X-Gm-Message-State: AOAM5332xtYcZfcYi+YgaFRiGSg+2c4xQntMpPWF7zb21QwFgLbx0E1u
        AIHeD6eFBcQj/crXkBgi3xL+Lk7E335cBBwMmxnqMMi4e/5bt3L+tQu0/RE1vjbi15iy6w3MGZf
        vayaMQG1qWCEUf0En
X-Received: by 2002:a05:6000:178d:: with SMTP id e13mr25190489wrg.199.1643796583790;
        Wed, 02 Feb 2022 02:09:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6WeB91CKnHm4tGH2FbuPsNKEjdEYYm7pcXGZVFkwEhwIrqs2nbCL8veCx03WHZr3RnAUfow==
X-Received: by 2002:a05:6000:178d:: with SMTP id e13mr25190475wrg.199.1643796583539;
        Wed, 02 Feb 2022 02:09:43 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id j15sm5209860wmq.19.2022.02.02.02.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 02:09:43 -0800 (PST)
Message-ID: <7bbab59c6d6cd2eb4e6d2fb7b2c2636b7d03445d.camel@redhat.com>
Subject: Re: [RFC PATCH 2/3] net: gro: minor optimization for
 dev_gro_receive()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
Date:   Wed, 02 Feb 2022 11:09:41 +0100
In-Reply-To: <20220118173903.31823-1-alexandr.lobakin@intel.com>
References: <cover.1642519257.git.pabeni@redhat.com>
         <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com>
         <20220118155620.27706-1-alexandr.lobakin@intel.com>
         <c262125543e39d6b869e522da0ed59044eb07722.camel@redhat.com>
         <20220118173903.31823-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-01-18 at 18:39 +0100, Alexander Lobakin wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Tue, 18 Jan 2022 17:31:00 +0100
> 
> > On Tue, 2022-01-18 at 16:56 +0100, Alexander Lobakin wrote:
> > > From: Paolo Abeni <pabeni@redhat.com>
> > > Date: Tue, 18 Jan 2022 16:24:19 +0100
> > > 
> > > > While inspecting some perf report, I noticed that the compiler
> > > > emits suboptimal code for the napi CB initialization, fetching
> > > > and storing multiple times the memory for flags bitfield.
> > > > This is with gcc 10.3.1, but I observed the same with older compiler
> > > > versions.
> > > > 
> > > > We can help the compiler to do a nicer work e.g. initially setting
> > > > all the bitfield to 0 using an u16 alias. The generated code is quite
> > > > smaller, with the same number of conditional
> > > > 
> > > > Before:
> > > > objdump -t net/core/gro.o | grep " F .text"
> > > > 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> > > > 
> > > > After:
> > > > 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> > > > 
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  include/net/gro.h | 13 +++++++++----
> > > >  net/core/gro.c    | 16 +++++-----------
> > > >  2 files changed, 14 insertions(+), 15 deletions(-)
> > > > 
> > > > diff --git a/include/net/gro.h b/include/net/gro.h
> > > > index 8f75802d50fd..a068b27d341f 100644
> > > > --- a/include/net/gro.h
> > > > +++ b/include/net/gro.h
> > > > @@ -29,14 +29,17 @@ struct napi_gro_cb {
> > > >  	/* Number of segments aggregated. */
> > > >  	u16	count;
> > > >  
> > > > -	/* Start offset for remote checksum offload */
> > > > -	u16	gro_remcsum_start;
> > > > +	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > > +	u16	proto;
> > > >  
> > > >  	/* jiffies when first packet was created/queued */
> > > >  	unsigned long age;
> > > >  
> > > > -	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > > -	u16	proto;
> > > > +	/* portion of the cb set to zero at every gro iteration */
> > > > +	u32	zeroed_start[0];
> > > > +
> > > > +	/* Start offset for remote checksum offload */
> > > > +	u16	gro_remcsum_start;
> > > >  
> > > >  	/* This is non-zero if the packet may be of the same flow. */
> > > >  	u8	same_flow:1;
> > > > @@ -70,6 +73,8 @@ struct napi_gro_cb {
> > > >  	/* GRO is done by frag_list pointer chaining. */
> > > >  	u8	is_flist:1;
> > > >  
> > > > +	u32	zeroed_end[0];
> > > 
> > > This should be wrapped in struct_group() I believe, or compilers
> > > will start complaining soon. See [0] for the details.
> > > Adding Kees to the CCs.
> > 
> > Thank you for the reference. That really slipped-off my mind.
> > 
> > This patch does not use memcpy() or similar, just a single direct
> > assignement. Would that still require struct_group()?
> 
> Oof, sorry, I saw start/end and overlooked that it's only for
> a single assignment.
> Then it shouldn't cause warnings, but maybe use an anonymous
> union instead?
> 
> 	union {
> 		u32 zeroed;
> 		struct {
> 			u16 gro_remcsum_start;
> 			...
> 		};
> 	};
> 	__wsum csum;
> 
> Use can still use a BUILD_BUG_ON() in this case, like
> sizeof(zeroed) != offsetof(csum) - offsetof(zeroed).

Please forgive me for the very long delay. I'm looking again at this
stuff for formal non-rfc submission.

I like the anonymous union less, because it will move around much more
code - making the patch less readable - and will be more fragile e.g.
some comment alike "please don't move around 'csum'" would be needed.

No strong opinion anyway, so if you really prefer that way I can adapt.
Please let me know.

Thanks!

Paolo

