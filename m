Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC872AFC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfGXJBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:01:48 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43074 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfGXJBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZYyhu0CztI0FJPxuZyUKp4du/IC82l7s9AKgMf8uV8I=; b=UMBWJQ/JXhBr4MpmgUYRWVnTa
        M/ikQGgCpQ2q2jSYt/8kgEKhZh4m2ml7vvdi7Lli6SPLAAYZtewkjlaPLn+J+0KUv2gT5OIDROhNs
        5Go0hPVt8mo5S5LsViOFy5DeVZWqLI4Iu6g2dO+r8jOk0R+ox8dH/EeAkNt04D+uZkQqrQFiDKtG0
        2W7mdNyw0M6HzmFgUhCh4ZlXlJB9/xtSV1SIW2M6/tg1G/sMOyBTY7w4QAZOP1L6g2Q42r9D5w0Kf
        Je7p3o3BgheJwoNo3uZnaB548ofvnhjvii0yJK11a9xu6slFr2dp14AixyhQ6jFQ+9euvF1p5AucQ
        NOQLoZ6wA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:36986)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hqD9a-0000sw-SZ; Wed, 24 Jul 2019 10:01:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hqD9X-0004ig-ET; Wed, 24 Jul 2019 10:01:39 +0100
Date:   Wed, 24 Jul 2019 10:01:39 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] net: phylink: don't start and stop SGMII PHYs in
 SFP modules twice
Message-ID: <20190724090139.GG1330@shell.armlinux.org.uk>
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
 <20190723151702.14430-3-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723151702.14430-3-asolokha@kb.kras.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:17:02PM +0700, Arseny Solokha wrote:
> SFP modules connected using the SGMII interface have their own PHYs which
> are handled by the struct phylink's phydev field. After commit ce0aa27ff3f6
> ("sfp: add sfp-bus to bridge between network devices and sfp cages") an
> sfp-bus attached to the same phylink also gets control over a PHY in an SFP
> module which is actually the same PHY managed by phylink itself. This
> results in WARNs during network interface bringup and shutdown when a
> copper SFP module is connected, as phy_start() and phy_stop() are called
> twice in a row for the same phy_device:
>...
> So, skip explicit calls to phy_start() and phy_stop() when phylink has just
> enabled or disabled an attached SFP module.

I'd prefer if we re-ordered these so phy_start() happens before
sfp_upstream_start() and the reverse for the stop calls.

pl->phydev won't be set at these points, so the calls will be no-ops.
(The reason is when we support mac--phy--sfp setups, having the
phy_start() and phy_stop() here are still necessary.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
