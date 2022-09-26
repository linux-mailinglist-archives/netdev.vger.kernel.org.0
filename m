Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA885E9785
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiIZAla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiIZAl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:41:29 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29582DAB0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 17:41:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c24so4825399plo.3
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 17:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=Ee6jY7viFUfMjAsx1AOZFi9ykD0TZlKjDDVt7+BAWpA=;
        b=Tymc3mQ6yYtKo/fUwb0pntTGEsuDmA3KGe5ZainSrzJcqfvTUXGD6g4AS/QDrdEz1m
         IPp9Tld0kqL2gFrY1NTkahNxDsLTe8rCfVZ7Sf6Yy58l+LrHh3LtaZFzBUsKT5oECTI8
         ASxk03BGu9JGtTcAH5Y41r1unU3COw5iwE/sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ee6jY7viFUfMjAsx1AOZFi9ykD0TZlKjDDVt7+BAWpA=;
        b=4zukuTUKiw6tqMJHymGokPaGqUjiWgcidc+fXx306DiBUmThUZbe94YE04R2kqXuAX
         X61X5TXz78jymc3A00zzJL+GntBF85o7WH1udw2pmCaUUdDQ+s4AkORvVT+pk+m8f+/j
         cFvE18vd2ExnEKg7s0qBuvp5uf9jY/EKLDZhAlRoeBIQMY773k+EusJU500cREMFCsnf
         yroi2ZO727opdbeA5dUG6HHc6i6nkDcV4AMFhwpzs5d7K4DSfPlVvo3BHBIORDHkS2e9
         2AXygZJONnqxlfK9MrHshZjGWDwFgWBD3C8MTY7z8FcwmhI5dd2sk+W4bJbM9sDd8oXN
         ihIA==
X-Gm-Message-State: ACrzQf3dyCWLRh/OvLgcHN0PNq56j+lTqnv8l7R7bjiGHaV21HUyITM2
        7+Ul6qtv/cxD5AjGrMD5aJr9RQ==
X-Google-Smtp-Source: AMsMyM5VpMx54A01n2IxbeNYegjZcGYyyX6uNC/69UJfyYAh5+QLjokwGVSlu1kDsKsMHY6BwDZQuA==
X-Received: by 2002:a17:902:ea0e:b0:178:3d49:45ad with SMTP id s14-20020a170902ea0e00b001783d4945admr19810833plg.103.1664152885590;
        Sun, 25 Sep 2022 17:41:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l7-20020a622507000000b0053ebafa7c42sm10576331pfl.79.2022.09.25.17.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 17:41:24 -0700 (PDT)
Date:   Sun, 25 Sep 2022 17:41:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 04/16] skbuff: Phase out ksize() fallback for frag_size
Message-ID: <202209251738.2E6B9C29D@keescook>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-5-keescook@chromium.org>
 <e340d993bce8e1b2742fba52ac6383771cfaddae.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e340d993bce8e1b2742fba52ac6383771cfaddae.camel@redhat.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 09:17:40AM +0200, Paolo Abeni wrote:
> On Fri, 2022-09-23 at 13:28 -0700, Kees Cook wrote:
> > All callers of APIs that allowed a 0-sized frag_size appear to be
> > passing actual size information already
> 
> AFAICS, not yet:
> 
> drivers/net/ethernet/qlogic/qed/qed_ll2.c:
> 	skb = build_skb(buffer->data, 0); // -> __build_skb(..., 0) 
> 		// ->  __build_skb_around()
> 
> drivers/net/ethernet/broadcom/bnx2.c:
> 	skb = build_skb(data, 0);
> 
> I guess some more drivers have calls leading to 
> 
> 	__build_skb_around(...,  0)
> 
> there are several call path to checks...

Ah-ha! Thank you. I will try to hunt these down -- I think we can't
remove the "secret resizing" effect of ksize() without fixing these.

> > [...]
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 0b30fbdbd0d0..84ca89c781cd 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -195,7 +195,11 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
> >  			       unsigned int frag_size)
> >  {
> >  	struct skb_shared_info *shinfo;
> > -	unsigned int size = frag_size ? : ksize(data);
> > +	unsigned int size = frag_size;
> > +
> > +	/* All callers should be setting frag size now? */
> > +	if (WARN_ON_ONCE(size == 0))
> > +		size = ksize(data);
> 
> At some point in the future, I guess we could even drop this check,
> right?

Alternatively, we might be able to ask the slab if "data" came from
kmalloc or a kmem_cache, and if the former, do:

	data = krealloc(kmalloc_size_roundup(ksize(data), ...)

But that seems ugly...

-- 
Kees Cook
