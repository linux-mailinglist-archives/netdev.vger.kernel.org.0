Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4D67E7BF
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjA0OII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjA0OII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:08:08 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4269A113C0;
        Fri, 27 Jan 2023 06:08:06 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2AD6724001A;
        Fri, 27 Jan 2023 14:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674828484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1G+fWgGxlEZqWqeYZloKEVDa2fkGlNLxIKDLUbzeuiw=;
        b=lpzK7+cixsBqVsaIWnXw6ZMgR2O+FnYuuCfcrjvAj8aPUewkhpuUvnD2gMqc31AY43UEf2
        KttgGUqT/gNlOIdrwx47pNunh2CLXqIcK54wqmsfN97X1Zebu+nBv2rJHIgfQv69n8dofJ
        6joB/E2rrwBNybFBWINKvoUqrDDFOKMo3nEgDlNTbM/eI8b2YEb0KnwNRtbuyUHVM6/Zlm
        dRiBS0YXeAEh2TnIFUa9EXev1ICL5JerE0v/xjLXY2qiY2HZ0HYJZpWkxOcxcB19iiDLr9
        jy8iAJQ5J7+ZPtCv+jFb5UpMu3gT3Bpy3H/IjXy6SmpVi2JApbKuhiKOESFJvw==
Date:   Fri, 27 Jan 2023 15:07:58 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: pcs: pcs-lynx: remove
 lynx_get_mdio_device() and refactor cleanup
Message-ID: <20230127150758.68eb1d29@pc-7.home>
In-Reply-To: <20230127134351.xlz4wqrubfnvmecd@skbuf>
References: <20230127134031.156143-1-maxime.chevallier@bootlin.com>
        <20230127134351.xlz4wqrubfnvmecd@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Fri, 27 Jan 2023 15:43:51 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Fri, Jan 27, 2023 at 02:40:30PM +0100, Maxime Chevallier wrote:
> > One of the main difference is that the TSE pcs is memory-mapped, and
> > the merge into pcs-lynx would first require a conversion of pcs-lynx
> > to regmap.  
> 
> I suppose sooner or later you'll want to convert stuff like
> phylink_mii_c22_pcs_get_state() to regmap too?

Well that was my next part to tackle indeed...

> Can't you create an MDIO bus for the TSE PCS which translates MDIO
> reads/writes to MMIO accesses?

TBH I haven't considered that, I guess this would definitely make thing
much easier. Since the register layout of the TSE PCS is very very
similar to the C22 layout, that could be indeed justified, as it's
basically a set of standard mdio registers exposed through mmio.

Thanks for the tip.

However this current patch still makes sense though right ?

Maxime
