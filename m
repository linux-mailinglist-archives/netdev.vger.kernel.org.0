Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA266459C3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLGMXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLGMW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:22:59 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24099B1CC;
        Wed,  7 Dec 2022 04:22:58 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id n20so13691565ejh.0;
        Wed, 07 Dec 2022 04:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OjJciw5c5k5i5I8nV9Emm78QGFtozJnpE2rZf+okvEw=;
        b=JX+AyE/Gh4oTLCWh2hYRkz/7d/O0wfCfyBjQCq6ZS+HFtAZ/Q0251B/Q3SQlZ1lyeR
         hnGXo0E9yivOeYYrtHWhbjv6QqQje7FqtcPMlcf6az0iX14ZBeh71+xwZNgoWUxVdumb
         +EvqJML3xt+YoaZLZz5G+QWTNSvq8v+1XikopCSnv+VJpp1uzp7IrbK4IqgbxFRMg2QI
         3GEyNeBD2gu25s/DxgmSZHjdcjEizd3mm+W2r4/Zz1zTGKoPyhaFnlO1lcr76Q2FD2Gs
         W9FK2rXYWyQ9fzakL3LUg8rlK0qFIoPNc3iB28D5bl+oR9iPCaooMIFPvUQ/YJO566Ur
         OJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjJciw5c5k5i5I8nV9Emm78QGFtozJnpE2rZf+okvEw=;
        b=sbmL6hiCGQL89QeEdnU2Q0ZIazs7HDVjfIJgkmE3r9y5RwIjHoIpnlmNYTFWemrzNG
         1PFiPXUpPHGXUKzdyYs5sGgcrEy4DE2ahVfgZWKFnDc+S1+FaSIUvX/M9UvS9pb1Ak7I
         NCwTTgcrKcQASvli49x2+2Ir29Ac2+6XaC2AoApNqFphRHCkOo77sDMgyF2ZS6r8Rguf
         ZIKh0QVYHwicl+IfYe3b0XV3ZhFtxavTZZyKf335L5pxKohmzQCaliHtMYWX+sC86nHE
         FzgpFhICFOzrrI9RhepDXgAtQGJhh+ISAh+LEbL/vMncAdoGi7r2IWh5uLRVIfKK5+uV
         dJaQ==
X-Gm-Message-State: ANoB5pljwg9K84mOpAphS1MWFikUnTjWjxWc0YpMIWXpJa3bwcMw3XvE
        P4qb1XdQoleC2v6ZGSW0ZZU=
X-Google-Smtp-Source: AA0mqf657+cJDewCmsFCvlBxUlOj+AQNbfKwjaC0G10FfBZ9vOyPSMjq2LeMqfyUoqO0T90FTeV6xQ==
X-Received: by 2002:a17:906:2302:b0:7b9:de77:f0ef with SMTP id l2-20020a170906230200b007b9de77f0efmr55702952eja.5.1670415776654;
        Wed, 07 Dec 2022 04:22:56 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id y20-20020a50eb94000000b004589da5e5cesm2144897edr.41.2022.12.07.04.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 04:22:56 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:22:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221207122254.otq7biekqz2nzhgl@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
 <20221207121936.bajyi5igz2kum4v3@skbuf>
 <Y5CFMIGsZmB1TRni@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5CFMIGsZmB1TRni@kadam>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:21:04PM +0300, Dan Carpenter wrote:
> On Wed, Dec 07, 2022 at 02:19:36PM +0200, Vladimir Oltean wrote:
> > On Wed, Dec 07, 2022 at 02:23:28PM +0300, Dan Carpenter wrote:
> > > The bit_reverse() function is clearly supposed to be able to handle
> > > 64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
> > > are not enough to handle more than 32 bits.
> > > 
> > > Fixes: 554aae35007e ("lib: Add support for generic packing operations")
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > ---
> > >  lib/packing.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/lib/packing.c b/lib/packing.c
> > > index 9a72f4bbf0e2..9d7418052f5a 100644
> > > --- a/lib/packing.c
> > > +++ b/lib/packing.c
> > > @@ -32,12 +32,11 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
> > >  static u64 bit_reverse(u64 val, unsigned int width)
> > >  {
> > >  	u64 new_val = 0;
> > > -	unsigned int bit;
> > >  	unsigned int i;
> > >  
> > >  	for (i = 0; i < width; i++) {
> > > -		bit = (val & (1 << i)) != 0;
> > > -		new_val |= (bit << (width - i - 1));
> > > +		if (val & BIT_ULL(1))
> > 
> > hmm, why 1 and not i?
> 
> Because I'm a moron.  Let me resend.

Wait a second, I deliberately wrote the code without conditionals.
Let me look at the code disassembly before and after the patch and see
what they look like.
