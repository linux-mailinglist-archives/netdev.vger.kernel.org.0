Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDA662EA02
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbiKRAES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiKRADl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:03:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C09BD3;
        Thu, 17 Nov 2022 16:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WaULKejZt+35jAOfOtVnAcClVJpXKCwVJ0JC4+/Un9s=; b=HhDunirGrzcsSeWJBbUj1pexEr
        5fFwpOKn9fMYE265/AIRk0Y/bKpRGVAM8MWetRzIKRrCEUQUE1o0e7xj2U3lbF8r8qZx8lK0xoH2j
        +Km1+X5Vd9fOnuxpNl7JSyAwzuq12emIIJP2luHWZF5ogJD7kOn+FHLNWZXMJkU1JhPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovopx-002k78-If; Fri, 18 Nov 2022 01:02:29 +0100
Date:   Fri, 18 Nov 2022 01:02:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <Y3bLlUk1wxzAqKmj@lunn.ch>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Well, part of my goal in sending out this patch is to get some feedback
> on the right thing to do here. As I see it, there are three ways of
> configuring this phy:
> 
> - Always rate adapt to whatever the initial phy interface mode is
> - Switch phy interfaces depending on the link speed
> - Do whatever the firmware sets up

My understanding of the aQuantia firmware is that it is split into two
parts. The first is the actual firmware that runs on the PHY. The
second is provisioning, which seems to be a bunch of instructions to
put value X in register Y. It seems like aQuantia, now Marvell, give
different provisioning to different customers.

What this means is, you cannot really trust any register contains what
you want, that your devices does the same as somebody elses' device in
its reset state.

So i would say, "Do whatever the firmware sets up" is the worst
choice. Assume nothing, set every register which is important to the
correct value.

	Andrew
