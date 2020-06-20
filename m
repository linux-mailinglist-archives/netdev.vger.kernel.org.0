Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01272024D8
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgFTPlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:41:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgFTPlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 11:41:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmfcK-001PRr-Mj; Sat, 20 Jun 2020 17:41:16 +0200
Date:   Sat, 20 Jun 2020 17:41:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH net v3] net: phy: smsc: fix printing too many logs
Message-ID: <20200620154116.GP304147@lunn.ch>
References: <20200620145534.10475-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620145534.10475-1-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 10:55:34PM +0800, Dejin Zheng wrote:
> Commit 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout()
> to simplify the code") will print a lot of logs as follows when Ethernet
> cable is not connected:
> 
> [    4.473105] SMSC LAN8710/LAN8720 2188000.ethernet-1:00: lan87xx_read_status failed: -110
> 
> When wait 640 ms for check ENERGYON bit, the timeout should not be
> regarded as an actual error and an error message also should not be
> printed. due to a hardware bug in LAN87XX device, it leads to unstable
> detection of plugging in Ethernet cable when LAN87xx is in Energy Detect
> Power-Down mode. the workaround for it involves, when the link is down,
> and at each read_status() call:
> 
> - disable EDPD mode, forcing the PHY out of low-power mode
> - waiting 640ms to see if we have any energy detected from the media
> - re-enable entry to EDPD mode
> 
> This is presumably enough to allow the PHY to notice that a cable is
> connected, and resume normal operations to negotiate with the partner.
> The problem is that when no media is detected, the 640ms wait times
> out and this commit was modified to prints an error message. it is an
> inappropriate conversion by used phy_read_poll_timeout() to introduce
> this bug. so fix this issue by use read_poll_timeout() to replace
> phy_read_poll_timeout().
> 
> Fixes: 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout() to simplify the code")
> Reported-by: Kevin Groeneveld <kgroeneveld@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
