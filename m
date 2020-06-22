Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A5F20444A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgFVXKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgFVXKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:10:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C220CC061573;
        Mon, 22 Jun 2020 16:10:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3E831296FB73;
        Mon, 22 Jun 2020 16:10:00 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:09:59 -0700 (PDT)
Message-Id: <20200622.160959.832115149084246410.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgroeneveld@gmail.com
Subject: Re: [PATCH net v3] net: phy: smsc: fix printing too many logs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620145534.10475-1-zhengdejin5@gmail.com>
References: <20200620145534.10475-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:10:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Sat, 20 Jun 2020 22:55:34 +0800

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

Applied and queued up for -stable, thanks.
