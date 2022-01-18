Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD9492B37
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiARQbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:31:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233718AbiARQbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642523466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PCnRWZJso60qg765aYX/C/XaqfbWnpmzYKHCdm92GA=;
        b=Kt/jHQ2zO8QZp8GBErhnNq4mwUrKcMKUGqmrQNc1HrVmdssTSeTNLUYwpVT7vWLypI2lDB
        /LrFmkWIS0bWVQImFP/DoN6+bYq9jB9zbMAfWn+avwT2g5Wd21LumQl0xkqgsempe5kGmS
        oqN6PHuMlIfasTudGKwbXBfPiOo9DkI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-sXEyMGkxNBuw27nqElF8yQ-1; Tue, 18 Jan 2022 11:31:04 -0500
X-MC-Unique: sXEyMGkxNBuw27nqElF8yQ-1
Received: by mail-qv1-f69.google.com with SMTP id g2-20020a0562141cc200b004123b0abe18so19000324qvd.2
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 08:31:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9PCnRWZJso60qg765aYX/C/XaqfbWnpmzYKHCdm92GA=;
        b=as5uGYOkqCZcB9taTojSMJZWDCuryncZvgrVUmw9mflzymEpVA09fl+X4WPFOZz9v3
         jBnT+7ai2eAxLmGx1g3M7N6Y615/a+8FgU6/mdGql+wpFGQSyoonWjz39jEIwWcG9xHd
         JQzdf7SskyHN8CuCfAFwL0hUG3pry9O2/vRrhW3QCvvqXxkXIBbmpc0+a594HyGu6n4K
         1kLSdSCVxD5KR9uRlyFBYENMYEDuOlV0q6eQuaOJZeIk7e7R6fZ5ji+KNuAj090r0bS5
         KyeLjZ7S2fFS22vrZCUMio+VU79quVqPnftO0S0XvMjuxDgrXV6Lq2LNI+99JrWvYigJ
         6DMQ==
X-Gm-Message-State: AOAM532+YG5A/tN4p0ftncDfcPG+8gujd1R6z4hjfh8GiZXA4N6ygq50
        gYLUrqEP+7BcgaCM3Vb81kvDcYazjeV9QklJGdx4M3iAUtcS0SyooURiN5qpRkct/7033lKWaA3
        4kBVuu+Dyc92LALLF
X-Received: by 2002:ac8:7fce:: with SMTP id b14mr3414547qtk.517.1642523464175;
        Tue, 18 Jan 2022 08:31:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1db5iEChQoOUWy+9u6H+mmHUeQXWM3EVqKA9JrTyEl+W0cnlUcXhGG6BDUE1HlSuyBGktZw==
X-Received: by 2002:ac8:7fce:: with SMTP id b14mr3414523qtk.517.1642523463935;
        Tue, 18 Jan 2022 08:31:03 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id j8sm629272qtj.91.2022.01.18.08.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:31:03 -0800 (PST)
Message-ID: <c262125543e39d6b869e522da0ed59044eb07722.camel@redhat.com>
Subject: Re: [RFC PATCH 2/3] net: gro: minor optimization for
 dev_gro_receive()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
Date:   Tue, 18 Jan 2022 17:31:00 +0100
In-Reply-To: <20220118155620.27706-1-alexandr.lobakin@intel.com>
References: <cover.1642519257.git.pabeni@redhat.com>
         <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com>
         <20220118155620.27706-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-01-18 at 16:56 +0100, Alexander Lobakin wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Tue, 18 Jan 2022 16:24:19 +0100
> 
> > While inspecting some perf report, I noticed that the compiler
> > emits suboptimal code for the napi CB initialization, fetching
> > and storing multiple times the memory for flags bitfield.
> > This is with gcc 10.3.1, but I observed the same with older compiler
> > versions.
> > 
> > We can help the compiler to do a nicer work e.g. initially setting
> > all the bitfield to 0 using an u16 alias. The generated code is quite
> > smaller, with the same number of conditional
> > 
> > Before:
> > objdump -t net/core/gro.o | grep " F .text"
> > 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> > 
> > After:
> > 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/net/gro.h | 13 +++++++++----
> >  net/core/gro.c    | 16 +++++-----------
> >  2 files changed, 14 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/net/gro.h b/include/net/gro.h
> > index 8f75802d50fd..a068b27d341f 100644
> > --- a/include/net/gro.h
> > +++ b/include/net/gro.h
> > @@ -29,14 +29,17 @@ struct napi_gro_cb {
> >  	/* Number of segments aggregated. */
> >  	u16	count;
> >  
> > -	/* Start offset for remote checksum offload */
> > -	u16	gro_remcsum_start;
> > +	/* Used in ipv6_gro_receive() and foo-over-udp */
> > +	u16	proto;
> >  
> >  	/* jiffies when first packet was created/queued */
> >  	unsigned long age;
> >  
> > -	/* Used in ipv6_gro_receive() and foo-over-udp */
> > -	u16	proto;
> > +	/* portion of the cb set to zero at every gro iteration */
> > +	u32	zeroed_start[0];
> > +
> > +	/* Start offset for remote checksum offload */
> > +	u16	gro_remcsum_start;
> >  
> >  	/* This is non-zero if the packet may be of the same flow. */
> >  	u8	same_flow:1;
> > @@ -70,6 +73,8 @@ struct napi_gro_cb {
> >  	/* GRO is done by frag_list pointer chaining. */
> >  	u8	is_flist:1;
> >  
> > +	u32	zeroed_end[0];
> 
> This should be wrapped in struct_group() I believe, or compilers
> will start complaining soon. See [0] for the details.
> Adding Kees to the CCs.

Thank you for the reference. That really slipped-off my mind. 

This patch does not use memcpy() or similar, just a single direct
assignement. Would that still require struct_group()?

Thanks!

Paolo

