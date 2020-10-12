Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EEA28BEA0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403948AbgJLRFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403931AbgJLRFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 13:05:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6BA2072D;
        Mon, 12 Oct 2020 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602522304;
        bh=+36ST4U99P+UWwG8debn0zuuiSGn1LQmo1LY2w8xF6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CBGaB1Yj6IT7WRAhzb2OO5M2uCdl52HAvaF/Y8yEI5FSBU9p3bg0XmkxGuisRBgvl
         MAed/+WXCvR1iNT+459iyKcSLe0qcOG/JkoTgJWzm88K5O1zICbf83BmBKPoaZkDgt
         hH3KAg2T7U/inJ3mBhm3wt+0pC2OCqIrXfYqC5E0=
Date:   Mon, 12 Oct 2020 10:05:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        George McCollister <george.mccollister@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net v4] net: dsa: microchip: fix race condition
Message-ID: <20201012100501.33a41d8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012083942.12722-1-ceggers@arri.de>
References: <20201012083942.12722-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 10:39:42 +0200 Christian Eggers wrote:
> Between queuing the delayed work and finishing the setup of the dsa
> ports, the process may sleep in request_module() (via
> phy_device_create()) and the queued work may be executed prior to the
> switch net devices being registered. In ksz_mib_read_work(), a NULL
> dereference will happen within netof_carrier_ok(dp->slave).
> 
> Not queuing the delayed work in ksz_init_mib_timer() makes things even
> worse because the work will now be queued for immediate execution
> (instead of 2000 ms) in ksz_mac_link_down() via
> dsa_port_link_register_of().

> 
> Solution:
> 1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
> 2. Only queue delayed work in ksz_mac_link_down() if init is completed.
> 3. Queue work once in ksz_switch_register(), after dsa_register_switch()
> has completed.
> 
> Fixes: 7c6ff470aa86 ("net: dsa: microchip: add MIB counter reading support")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Now you went too far in the opposite direction, I never gave you my
explicit tag :) So I'll drop it.

Applied and queued for stable, thanks!
