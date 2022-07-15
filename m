Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53972576880
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiGOUta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiGOUtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:49:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF114BE28;
        Fri, 15 Jul 2022 13:48:46 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r6so7761507edd.7;
        Fri, 15 Jul 2022 13:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hezb8LC6VHhsVv2dBKdkiaPfHcKVomwV2NQgIck5DiA=;
        b=Tq3ph/DejmAhUdUnV/JlESyMZHwcbbvwsbqDyONdf2PoZYL5sTPOQW3l+3djGe21AW
         exlkz+WqTjsLukDWZ9z5cGKAF9OXPAfu9ZLPsjvPo5IE3yb29+WgnMA4dqZHoLJ7e4Fx
         /UlliBn0U99ltvo523p4f/yZ2C3upzo6XXgczcADPhyokG7g1kZyEzUWMgiUvD8uuAEn
         NwSd7z2ejZiWY+8Zit+20+Pt8ffsv/p4jl2PsJu8EUbPJAbs158z8o2re6XM7n/0m3ml
         DKCRfQ8zxcb2R+Ra3ubr5ZHftWB/fNzWWpduY/MIUQ3WRk2q/WOnE/8Pkv3vEQdA0H7p
         BJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hezb8LC6VHhsVv2dBKdkiaPfHcKVomwV2NQgIck5DiA=;
        b=lw6J8YWYVfaz9ZVe6RVWa5Qdtv0LdXmf/QiITQzeA34Xu6Ov+K5/M43eRnGdxivCZj
         BkgBiPi1QeaFUykFwXWX5HNitS/W4Oo3wvZoyOZ17x94SJJOhauNvadYs4j54KbG5r4k
         swP+eFALusyJBfRXsAOGRtANfoPQwBvDdlxPVlYUFVOcQAOi2RavfayKRiaf0xfZJHcz
         GszsO2VKkvupKNFwvkiwQW4Rk7zwvMR5dtDq/8FusZcDvahhYauDQIU7h+QsZil6vnd5
         kNlqxe09JeCEEaviaNE6NYHSGQPnbUoJ7rR6OySwwvCRMC18TRtW4XVgfL3dWLJpsOvO
         zzzg==
X-Gm-Message-State: AJIora+ksAgEgnoWF8aBTeg2iR7NXisgzQcMZuHiUK7gVy00opflyhi2
        h6uA4eDCCqekH4nFJB2O9+Q=
X-Google-Smtp-Source: AGRyM1s+Y76WXlbBm2G6MIgUB/L/JKHKdvm9y3kQlZgGEy8jIEzPyxJkhr6XpR9Q9VObhdQhKtQt5Q==
X-Received: by 2002:a05:6402:1d97:b0:43a:7b45:8e14 with SMTP id dk23-20020a0564021d9700b0043a7b458e14mr21354226edb.418.1657918125279;
        Fri, 15 Jul 2022 13:48:45 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kw5-20020a170907770500b0072f07213509sm742435ejc.12.2022.07.15.13.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 13:48:44 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:48:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <20220715204841.pwhvnue2atrkc2fx@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:33:40PM +0300, Andy Shevchenko wrote:
> On Fri, Jul 15, 2022 at 11:17:15PM +0300, Vladimir Oltean wrote:
> > On Fri, Jul 15, 2022 at 10:57:55PM +0300, Andy Shevchenko wrote:
> > > On Fri, Jul 15, 2022 at 05:01:32PM +0100, Russell King wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > 
> > > > Allow a named software node to be created, which is needed for software
> > > > nodes for a fixed-link specification for DSA.
> > > 
> > > In general I have no objection, but what's worrying me is a possibility to
> > > collide in namespace. With the current code the name is generated based on
> > > unique IDs, how can we make this one more robust?
> > 
> > Could you be more clear about the exact concern?
> 
> Each software node can be created with a name. The hierarchy should be unique,
> means that there can't be two or more nodes with the same path (like on file
> system or more specifically here, Device Tree). Allowing to pass names we may
> end up with the situation when it will be a path collision. Yet, the static
> names are easier to check, because one may run `git grep ...` or coccinelle
> script to see what's in the kernel.

So won't kobject_init_and_add() fail on namespace collision? Is it the
problem that it's going to fail, or that it's not trivial to statically
determine whether it'll fail?

Sorry, but I don't see something actionable about this.
