Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF5C48394A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiACXvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiACXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:51:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D1C061761;
        Mon,  3 Jan 2022 15:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mzVJNLidJMwiuNwAQnvaepZtdZawbBfDZJjbCmMxrP8=; b=KNm3bRtoBO3ezqXVT9Boe5AtBf
        bd/cYJbyQUDZQzQ3MRLdvaeh7+5KuthK7e+aXOceQSwAB2RM9JmQ/hvixPb48XBzR6raPyIDLGStb
        Po0GUmBQtDX6VNzdML+sEgJR1Klcn2hm3qlXmlpsttdh680wMI+jfUxgJWcm07kUWQP6H5247U/g4
        B4xErGxn++g8Beg6f8d7pNpR46dJ0ZNb7tX15gfcHvTjz1yCdFffhwr+o1kEwXDY58MRM+5ipkhTJ
        9IhdkI9FS75Nj8J+ofZ2b3ehR1ZpQWLc3jyxogc7YKzZPAEfOS8YxVWhBvcb/zZIDlUgOz+j7lsdM
        nrU6lAOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56538)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4X6V-0006UX-0J; Mon, 03 Jan 2022 23:51:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4X6S-0006g3-8Q; Mon, 03 Jan 2022 23:51:00 +0000
Date:   Mon, 3 Jan 2022 23:51:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC V1 net-next 2/4] net: Expose available time stamping
 layers to user space.
Message-ID: <YdOL5Dc19lSAGTuj@shell.armlinux.org.uk>
References: <20220103232555.19791-3-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103232555.19791-3-richardcochran@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 03:25:53PM -0800, Richard Cochran wrote:
> Time stamping on network packets may happen either in the MAC or in
> the PHY, but not both.  In preparation for making the choice
> selectable, expose both the current and available layers via sysfs.
> 
> In accordance with the kernel implementation as it stands, the current
> layer will always read as "phy" when a PHY time stamping device is
> present.  Future patches will allow changing the current layer
> administratively.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Did you mean to introduce "selected_timestamping_layer" in this patch -
it appears to be a write only variable.

As it stands, it gets set to indicate PHY mode just by a network driver
binding to a PHY. If this gets used based on that decision to direct
where get_ts_info() goes, then this will break mvpp2 PTP.

I suggest that the introduction of "selected_timestamping_layer" is
moved to the patch where it's actually used for a better review.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
