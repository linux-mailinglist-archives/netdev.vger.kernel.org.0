Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9054D7CA
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345815AbiFPCGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiFPCGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:06:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4B377CE
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 19:06:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h1so110757plf.11
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 19:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LQi02tRnUqApBnTheS1YF43fPG5WcRCgQQsbI1TxVfc=;
        b=Fh4hmZEL9ZDAD7NzsO1fCwlOGL0+pTUkdWdiD/i02mlR+unUH5/jxQOcsIarx/FLKe
         9l4gRxmEvdbQj1UQUPG8wHGFNb8FJXHxWTLg0CUNUJ5Aj2pYwZ4d81bFXSIinJpddmWY
         nvhUrGOXPTGhb9AqSNFgkKLaep6Ueyttfu28T23zJHlEEGebWaaVgW1DmctEqkxppLM3
         /wyi+yElFVXu4cB1VrHNgn2bd9VYi/0uu8+vfyXpwSOK3mta+tHR4ecxOSDEbpOBCyB0
         5OVoQxx6XCBXNwV/TMqgeNRuvw9sNXzTesF7C37ciMYxWc2wkr3/dUxwyR/tOWsAlZLK
         0uvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LQi02tRnUqApBnTheS1YF43fPG5WcRCgQQsbI1TxVfc=;
        b=WUHoptQjuZPLFSelmZJAFVLL6LdN4iZY3U4g/PnTdC/8JD75PZKAgB8X7a6I09vVK8
         tBfHSzz2Zj7gasJEY8pLzfHVUf+WL82FEslPKTgGjXv61PJmmpJehVeS8hUBUCukiW69
         eE6gp0krv8BbJGQ4RxMvjOb1+IkQVtDmdCIjrwaHGxpHg6FqhwfW0DWwXJby9/KkaY9l
         myO3Jk59ds0dW4zadX/deZ7FSf+rCaS3A4LGTxKiBwjaWAlvOlGz7uDg3QbXQBnMnCsh
         40FsU6zIGqcawFafjzdgUOrR2iCSKZdGL+K2o+jOtAOvlyLevpr2CAOY6oetEVdbWhu8
         Oc8g==
X-Gm-Message-State: AJIora8S3nuqa13O7lAKWbzFfU3Envk2Wfpi2pkbC4zMBgOXCWNqtLgG
        PWL95d0mXwW6UtCXA3BE5KGIPNP0L10=
X-Google-Smtp-Source: AGRyM1ugES2IfVlQ6GGw6BN358NSPcbx9n+yqbKhCqqtmq+k1iizTvlCjYeiO6U0eMUSn6pDArwCuQ==
X-Received: by 2002:a17:902:ce8f:b0:163:cc85:ba89 with SMTP id f15-20020a170902ce8f00b00163cc85ba89mr2178149plg.79.1655345174542;
        Wed, 15 Jun 2022 19:06:14 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902784100b00163b02822bdsm299917pln.160.2022.06.15.19.06.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jun 2022 19:06:13 -0700 (PDT)
Date:   Thu, 16 Jun 2022 10:04:53 +0800
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: don't check skb_count twice
Message-ID: <20220616020453.GA39@DESKTOP-8REGVGF.localdomain>
References: <20220615032426.17214-1-liew.s.piaw@gmail.com>
 <20220615153525.1270806-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615153525.1270806-1-alexandr.lobakin@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 05:35:25PM +0200, Alexander Lobakin wrote:
> From: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> Date: Wed, 15 Jun 2022 11:24:26 +0800
> 
> > NAPI cache skb_count is being checked twice without condition. Change to
> > checking the second time only if the first check is run.
> > 
> > Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> > ---
> >  net/core/skbuff.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 5b3559cb1d82..c426adff6d96 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -172,13 +172,14 @@ static struct sk_buff *napi_skb_cache_get(void)
> >  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> >  	struct sk_buff *skb;
> >  
> > -	if (unlikely(!nc->skb_count))
> > +	if (unlikely(!nc->skb_count)) {
> >  		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
> >  						      GFP_ATOMIC,
> >  						      NAPI_SKB_CACHE_BULK,
> >  						      nc->skb_cache);
> > -	if (unlikely(!nc->skb_count))
> > -		return NULL;
> > +		if (unlikely(!nc->skb_count))
> > +			return NULL;
> > +	}
> 
> I was sure the compilers are able to see that if the condition is
> false first time, it will be the second as well. Just curious, have
> you consulted objdump/objdiff to look whether anything changed?

I'm a total noob at this. Thanks for the guidance.
Here is the diff I just generated:

< before patch
> after patch

619,620c619,620
<   14: 24630000        addiu   v1,v1,0
<   18: 00021080        sll     v0,v0,0x2
---
>   14: 00021080        sll     v0,v0,0x2
>   18: 24630000        addiu   v1,v1,0
626,635c626,635
<   30: 8e030010        lw      v1,16(s0)
<   34: 1060000b        beqz    v1,64 <napi_skb_cache_get+0x64>
<   38: 3c020000        lui     v0,0x0
<   3c: 24620003        addiu   v0,v1,3
<   40: 2463ffff        addiu   v1,v1,-1
<   44: ae030010        sw      v1,16(s0)
<   48: 8fbf0014        lw      ra,20(sp)
<   4c: 00021080        sll     v0,v0,0x2
<   50: 02028021        addu    s0,s0,v0
<   54: 8e020004        lw      v0,4(s0)
---
>   30: 8e020010        lw      v0,16(s0)
>   34: 1040000b        beqz    v0,64 <napi_skb_cache_get+0x64>
>   38: 26070014        addiu   a3,s0,20
>   3c: 24430003        addiu   v1,v0,3
>   40: 00031880        sll     v1,v1,0x2
>   44: 2442ffff        addiu   v0,v0,-1
>   48: ae020010        sw      v0,16(s0)
>   4c: 02038021        addu    s0,s0,v1
>   50: 8e020004        lw      v0,4(s0)
>   54: 8fbf0014        lw      ra,20(sp)
639,640c639,640
<   64: 8c440000        lw      a0,0(v0)
<   68: 26070014        addiu   a3,s0,20
---
>   64: 3c020000        lui     v0,0x0
>   68: 8c440000        lw      a0,0(v0)
644c644
<   78: 00401825        move    v1,v0
---
>   78: 1440fff0        bnez    v0,3c <napi_skb_cache_get+0x3c>
646c646
<   80: 1460ffee        bnez    v1,3c <napi_skb_cache_get+0x3c>
---
>   80: 1000fff4        b       54 <napi_skb_cache_get+0x54>
648,651d647
<   88: 8fbf0014        lw      ra,20(sp)
<   8c: 8fb00010        lw      s0,16(sp)
<   90: 03e00008        jr      ra
<   94: 27bd0018        addiu   sp,sp,24
1736c1732
<  244: 24050ae8        li      a1,2792
---
>  244: 24050ae9        li      a1,2793

...(More similar li instruction diffs)
I think there are slightly more instructions before patch.

> 
> Also, please use scripts/get_maintainers.pl or at least git blame
> and add the original authors to Ccs next time, so that they won't
> miss your changes and will be able to review them in time. E.g. I
> noticed this patch only when it did hit the net-next tree already,
> as I don't monitor LKML 24/7 (but I do that with my mailbox).
> 

Thanks for the tip.

> >  
> >  	skb = nc->skb_cache[--nc->skb_count];
> >  	kasan_unpoison_object_data(skbuff_head_cache, skb);
> > -- 
> > 2.17.1
> 
> Thanks,
> Olek
