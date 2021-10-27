Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F106243C600
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhJ0JFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhJ0JFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:05:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66913C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2JfGZJ3Aw7+RGYpzRP7CNmj3cc2BrsyQX7QIFpLUdPE=; b=YTJ7aKpLhNPtcc84utIipHgzQW
        xNw72XIkjM415Oqd6UcA3zg8jFIoAJvIr3NGS0WLzIkid1YEhTqsi5I5MmMybkIXE+lX9D6MdB/qN
        pkTzuSCS+TVtVe0udsW9oDL8A+2bHxo6rkgGh5nkzCcmk+yCSJQMX4Z/Xlcq1BUMIt4d1UtWZwIxE
        dlxDcvd78ea2bdR8XpxGGx3HOyfHwoI5qZESBxZZ7cPiSrbPxJ/jxLnMzAVTWEgMj3SvnVUHisKgG
        x1CD5LQ5zevRN/GYmxq1GXBmmv8hTfQmaDnI4Z5h+rHqFtZF5/s4cKZzswsL5+JY6Qs1uVq0nIpxK
        HIxmRjZg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55332)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfeq0-0006Cj-Fm; Wed, 27 Oct 2021 10:03:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfepz-0007bO-5o; Wed, 27 Oct 2021 10:03:11 +0100
Date:   Wed, 27 Oct 2021 10:03:11 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 0/3] Convert mvneta to phylink supported_interfaces
Message-ID: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series converts mvneta to use phylinks supported_interfaces
bitmap to simplify the validate() implementation. The patches:

1) Add the supported interface modes the supported_interfaces bitmap.
2) Removes the checks for the interface type being supported from
   the validate callback
3) Removes the now unnecessary checks and call to
   phylink_helper_basex_speed() to support switching between
   1000base-X and 2500base-X for SFPs

(3) becomes possible because when asking the MAC for its complete
support, we walk all supported interfaces which will include 1000base-X
and 2500base-X only if the comphy is present.

 drivers/net/ethernet/marvell/mvneta.c | 48 ++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 18 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
