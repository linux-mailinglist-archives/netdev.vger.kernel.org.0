Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0749578894
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiGRRi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiGRRiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:38:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C63D2D1E1;
        Mon, 18 Jul 2022 10:38:22 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g1so16290096edb.12;
        Mon, 18 Jul 2022 10:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sbQJ0XYgd4Fju13bZpHJM3Cfx2n2pGjKfZbYwwIjfc0=;
        b=beXN+Gr2KknBQ7VYMM/2ZEDykFmTMc2q9G7M/sDCIati5P6Etc8BXKj5J6ia+oSmI/
         1XWuqC6SzEx3ZcttxCGg/pZ++f1nSk6MoNilxO90ocFWmKGelhJBCHYqGQXe3cdNGd9v
         HsP7WNYYF9n72jD78rrLN+yX+P5WJksQDKnJbgnrxoYwA/kU7zYjmnzMqS9sQbxpHcag
         exyZiINobXyw/J7IiifPraZvZIjk0uK3m6p39GsrmRyCnO0ONQ2MeSwaG4xBHDW5KrUu
         sHe/FDtfeL8A01b7eqvLOa4vnE37ZJEvy5nQwmFuBOpPVKskQ5S0ZSxyRZoZly40rNF6
         YzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sbQJ0XYgd4Fju13bZpHJM3Cfx2n2pGjKfZbYwwIjfc0=;
        b=qxQ4NJKTyVyHuUyAKOdx0Z9Rn2NNxjd+8vclc/dpni6qyekZi0VmP/xpmB5vnFKuuK
         F+0xCHVAkiYdededsIvLCEjRQn3eHJG4yUiHO+ByRtOKvRBLTcLyokisA0Q/NY5+/nV2
         dI6AnBauSTIx2lzoWtbNV0G9qpNccBF3fjGuvsiST+a1HQBawbCYyDsGrT0TThHlHXOL
         R/Yx1kkztvXA3aGObq96OQsgGJdz69RXDWKhcvO2EA1D6Kjzhv+FC0KYaVZMvByVdzRm
         GSq4ik7++3whGOp5wcwv5VzRGlSKcsr0FPWNSVfK1uQelFxXYNoyDdsHgigr7ne3ktM+
         Z+AA==
X-Gm-Message-State: AJIora+F8AhkpxH9QuQ1SAIHLT9vOJ9tAjVjTjVdIVAeUA4Fd7LWpfEn
        wpgNfPoSt2mCNgOz/4zjw7E=
X-Google-Smtp-Source: AGRyM1u+iid2ornQHESqWujRsjFiQfj5PFwbE/bUHO7D5cJL/FeGazCR1TOnBjvKWajIuRYWKSI+9Q==
X-Received: by 2002:a05:6402:35d4:b0:43a:df89:94e2 with SMTP id z20-20020a05640235d400b0043adf8994e2mr39384361edc.149.1658165900637;
        Mon, 18 Jul 2022 10:38:20 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id 24-20020a170906329800b006fecf74395bsm5780190ejw.8.2022.07.18.10.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:38:20 -0700 (PDT)
Date:   Mon, 18 Jul 2022 20:38:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 4/4] net: dsa: qca8k: split qca8k in common
 and 8xxx specific code
Message-ID: <20220718173817.btv2vxcazhioa7pv@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-5-ansuelsmth@gmail.com>
 <20220718172135.2fpojugpmoyekcn7@skbuf>
 <62d5981f.1c69fb81.35e7.2434@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5981f.1c69fb81.35e7.2434@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 07:10:52PM +0200, Christian Marangi wrote:
> On Mon, Jul 18, 2022 at 08:21:35PM +0300, Vladimir Oltean wrote:
> > On Sat, Jul 16, 2022 at 07:49:58PM +0200, Christian Marangi wrote:
> > > The qca8k family reg structure is also used in the internal ipq40xx
> > > switch. Split qca8k common code from specific code for future
> > > implementation of ipq40xx internal switch based on qca8k.
> > > 
> > > While at it also fix minor wrong format for comments and reallign
> > > function as we had to drop static declaration.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > >  drivers/net/dsa/qca/Makefile                  |    1 +
> > >  drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1210 +----------------
> > >  drivers/net/dsa/qca/qca8k-common.c            | 1174 ++++++++++++++++
> > >  drivers/net/dsa/qca/qca8k.h                   |   58 +
> > >  4 files changed, 1245 insertions(+), 1198 deletions(-)
> > >  rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (64%)
> > >  create mode 100644 drivers/net/dsa/qca/qca8k-common.c
> > 
> > Sorry, this patch is very difficult to review for correctness.
> > Could you try to split it to multiple individual function movements?
> 
> You are right.
> Can I split them in category function (bridge function, vlan function,
> ATU...) Or you want them even more split? 

Yes, I think splitting by category is OK as long as the number of
functions being moved at once is trackable by a human being (I'd say at
most 5 functions or so). Use your own judgement while looking at the
output of git format-patch (essentially what a reviewer is looking at).
