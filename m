Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C0E516438
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346538AbiEALiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbiEALiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:38:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1DD1CFFA
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ndT2OoohNBLkRvLz+mc8gCuPExVVovgCugEML5NODZ4=; b=N/L3YjuSkn/XUX0i54JxnXc8PA
        lIeOEs7feWZYdP1/QqjZY/zKNjt3tWRSxATbaw5Nu4pRiqzCm2djquKHT/gfpAzVUi/TusT4umfJZ
        36WqCrHaXxIc/qSBo+kFKOcNHhXgaEgUAgegvEdbcw3L+yv0dzHfSp27M6lqXV241Ecx1G20TpfbT
        p9i+BdqfA6IlsnkWISysRu9tO6GF50wlRQN5gm8OPng7ef2mZU9AM00uAgbncRhRfWoGf4QhSzcCd
        7KTRZGFDgEdbisKLiISKpn5zDixZMUInFqP1GqBG41vT6rNMpm1n9o7mqBkQclPD/XKa/lZwvHvLt
        3g4if8PQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58476)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nl7qg-0006DW-5U; Sun, 01 May 2022 12:34:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nl7qe-0003qp-Sl; Sun, 01 May 2022 12:34:44 +0100
Date:   Sun, 1 May 2022 12:34:44 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Baruch Siach <baruch@tkos.co.il>, netdev <netdev@vger.kernel.org>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Message-ID: <Ym5wVDVcNe3kOjX9@shell.armlinux.org.uk>
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 10:59:59AM +0200, Marcin Wojtas wrote:
> Hi Baruch,
> 
> Thank you for the patch and debug effort, however at first glance it
> seems that adding delay may be a work-around and cover an actual root
> cause (maybe Russell will have more input here).

Please note I'm on a boat suffering diesel bug (means I'm running off
limited battery power which has to last until Wednesday for more vital
services, so I'm only around sporadically as the situation permits.
It's basically exactly an Apollo 13 situation - everything's turned
off except when absolutely required!)

Early revisions of the 88x3310 firmware have problems when switching
between the different MAC-side link modes. When this occurs, the PHY
firmware flashes one (iirc yellow) LED rapidly and refuses to link.

The answer is not to add random delays to the MAC driver, but get
the firmware of the MAC updated to something way less buggy - and
those early firmwares do contain a lot of bugs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
