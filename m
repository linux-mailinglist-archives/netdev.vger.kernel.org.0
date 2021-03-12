Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317D8339730
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhCLTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhCLTJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:09:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07B7C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 11:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DCkzR8+e85DChyd/6ktWZc41wjVGKK7x0dAqArN8kys=; b=aCkpLJQzRV39KK4/JCPogvBQ7
        u1ew82EcIuQ/odS3zc8tzRW8mkNDRAhwp32RF2eJYX5ASivH0bgsSoDXsKiFsYJabygZPrfzoIT4X
        4C5jNWWDiD2NsE8bqI6IuH2V4ufPsBOPvF4Jfik0JMhGGhoUJPLraPT2iBrIzy6I295hq7ce3pWth
        yZEyUHJ62EM/Wyts/TERA3ykWL5q5PL83EDFqma4XolQtkxOBAMlRxosSJ/+8aGgJS2VsbC32cZG6
        6F1Ol3A4X+y7c1D1mkE3+IkcQByvAp/tPCx+Biffjb4i61KPVoRabduP9luPFnmVZ4PYTCh5rP60K
        hsDafPYaA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50972)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lKnAE-00070F-0G; Fri, 12 Mar 2021 19:09:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lKnAD-0002nG-3U; Fri, 12 Mar 2021 19:09:33 +0000
Date:   Fri, 12 Mar 2021 19:09:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: stmmac driver timeout issue
Message-ID: <20210312190932.GK1463@shell.armlinux.org.uk>
References: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8a996459-fc77-2e98-cc0c-91defffc7f29@gmail.com>
 <DB8PR04MB6795BB20842D377DF285BB5FE6939@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <49fedeb2-b25b-10d0-575f-f9808a537124@gmail.com>
 <DB8PR04MB6795BCB93919DF684CA8DA79E6909@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <5d636daa-b25a-d0f1-dc95-b021cb0f53eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d636daa-b25a-d0f1-dc95-b021cb0f53eb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 10:33:06AM -0800, Florian Fainelli wrote:
> On 3/11/21 4:04 AM, Joakim Zhang wrote:
> > I have a question about PHY framework, please point me if something I misunderstanding.
> > There are many scenarios from PHY framework would trigger auto-nego, such as switch from power down to normal operation, but it never polling the ack of auto-nego (phy_poll_aneg_done), is there any special reasons? Is it possible and reasonable for MAC controller driver to poll this ack, if yes, at least we have a stable RXC at that time.
> 
> Adding Heiner and Russell as well. Usually you do not want, or rather
> cannot know whether auto-negotiation will ever succeed, so waiting for
> it could essentially hog your system for some fairly indefinite amount
> of time.

I think the question being asked is essentially whether checking the
link status bit (1.2) without checking the aneg complete bit (1.5) is
sufficient.

Reading 802.3, it seems to be defined that if autonegotiation is in
use, the link shall be reported as down until autonegotiation has
completed - which is logical. The link can only be up if a valid
data path capable of transferring data has been established, which
implies that autonegotiation must have completed.

However, note that when coming out of power down, there is no guarantee
that there is anything connected to the other side of the media, and
thus there is no guarantee that autonegotiation will complete. Waiting
for autonegotiation to complete in this case would not be feasible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
