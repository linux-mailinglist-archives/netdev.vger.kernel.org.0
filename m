Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3C343C6C9
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhJ0JvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241271AbhJ0JvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:51:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248F2C061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VJxp2t60UDkheB/zRcIKB+dF6EfD/xKILQbhWKoAfmQ=; b=Jo/2YL4XBVDMKNlNla3IrbIEC3
        RUCZZakUDer+S5VV9WJC32aL8GaF85ypRODuwBKN5xsdUx6BjOVcwuLzG9c/wzJe5yX6hH4qXxOzB
        pDaL5l7MoDhuHFhtDlU7tCUAErGy9B9/fjhkYqRELDUWPbtqmrtBT9MDd3aNRqupzCE0wweML+q1/
        IiaL9qQAZ8YR/yiPX+Z7mAjA4Sx8u6VkyRXweWi36/CaonS7zN3n7772IkAgX0KVweZ26qrHSjw7G
        FBzvkXY8i5wGUeDXgDfaBaIjhIcXl5sh+LVy+QDkduyVaWZyQUpTce3UyUTX6zlt8uK659zhh4iyG
        gG/jPXeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55338)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mffXz-0006FF-5J; Wed, 27 Oct 2021 10:48:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mffXy-0007dX-7U; Wed, 27 Oct 2021 10:48:38 +0100
Date:   Wed, 27 Oct 2021 10:48:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] Convert mvpp2 to phylink supported_interfaces
Message-ID: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series converts mvpp2 to use phylinks supported_interfaces
bitmap to simplify the validate() implementation. The patches:

1) Add the supported interface modes the supported_interfaces bitmap.
2) Removes the checks for the interface type being supported from
   the validate callback
3) Removes the now unnecessary checks and call to
   phylink_helper_basex_speed() to support switching between
   1000base-X and 2500base-X for SFPs
4) Cleans up the resulting validate() code.

(3) becomes possible because when asking the MAC for its complete
support, we walk all supported interfaces which will include 1000base-X
and 2500base-X only if the comphy is present.

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 95 +++++++++++++------------
 1 file changed, 50 insertions(+), 45 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
