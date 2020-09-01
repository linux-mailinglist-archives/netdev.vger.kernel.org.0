Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3AB258F6A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIANs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgIANsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D3AC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oIulLmq4z0zyHAUa0tOY2fOqAH8mjZp/smv+/lQzwo0=; b=x9dSDRCfkBSFw4sAIskvJZOlo
        0+pmYbvMS0qZE18qjckUGdeQ92NKz+5bxga0h6E583TtpVvXH3gwCR0Fm6fhGVNxfU+fXApMGhcFp
        BfB5JJIdjD4cLW5cT4OkLh6z8WCH95Q+0CtqoPWNaxytuaiuijJg1gHH+hIiVk2K4Nn/6UM4X53K3
        4t1O9QhvVu/E+3TfRAU/fcxZxIw4GoYcCYHM0AzZwsR39v8SgNNz4GahOjWqGEK6yTOKQbFg7SNpm
        A41uhfOQwDlARUW6GV4YiybLKVyGc0GVcll2nlLpp6sPu54Au+vFtarhVmRZbOEIh3C7Uur4bbL5x
        oFGrLgRZg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59814)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kD6da-0002Xw-HR; Tue, 01 Sep 2020 14:47:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kD6dW-0007Gv-LE; Tue, 01 Sep 2020 14:47:46 +0100
Date:   Tue, 1 Sep 2020 14:47:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next 0/6] Convert mvpp2 to split PCS support
Message-ID: <20200901134746.GM1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts the mvpp2 driver to use the split PCS support
that has been merged into phylink last time around. I've been running
this for some time here and, apart from the recent bug fix sent to
net-next, have not seen any issues on DT based systems. I have not
tested ACPI setups, although I've tried to preserve the workaround.

Patch 1 formalises the ACPI workaround.
Patch 2 moves some of mac_config() to the mac_prepare() and
  mac_finish() callbacks so we can keep the ordering when we split
  the PCS bits out.
Patch 3 ensures that the port is forced down while changing the
  interface mode - when in in-band mode, doing this in mac_prepare()
  and mac_finish().
Patch 4 moves the reset handling to mac_prepare() and mac_finish()
Patch 5 does a straight conversion to use PCS operations.
Patch 6 splits the PCS operations into a GMAC PCS operations and
  XLG PCS operations, selecting the appropriate set during
  mac_prepare().  This eliminates a bunch of conditionals from the
  code.

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 466 ++++++++++++++----------
 2 files changed, 284 insertions(+), 183 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
