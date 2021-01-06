Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400712EB807
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 03:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbhAFCTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 21:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbhAFCTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 21:19:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2528C061387;
        Tue,  5 Jan 2021 18:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=LIaWes6GL5/coUIDfM1TqdIbbzbCTmUwH4VD0Q/gdoE=; b=LI5OpgDBafj/vEhcm8ebq9I1zd
        wX+ikXiec+Q7WQKbnbvd9EzVvxVZI49mL1gDwS7FU7NJbkYd1V/j+NpBaTjI9/zEufqenxYYsacpk
        f1CIZVECMVDBRC1rRO4F1+xDGk23AxqP5d6XrNYHidj8fW0SzsAzS4QiyA/dsSv/fjHBEj2/A18Qs
        F/XjF+Y2fpOZ8J5Pj7pYt/UWp0JrzwJUFji4evPIyEDK7lkjImeBaAxG0YsdE/9g6e+e2dS5hrKIP
        y0iOtcVcUUTxtPxkBR7hra3qcRv2y7AS1DMWT3CiYIvVI1Ztn20h/X3/ivK2wnhWnR4Tx5IkWNYuR
        3gpB1atw==;
Received: from [2601:1c0:6280:3f0::64ea] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kwyOz-001uSQ-9h; Wed, 06 Jan 2021 02:18:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: dsa: fix led_classdev build errors
Date:   Tue,  5 Jan 2021 18:18:15 -0800
Message-Id: <20210106021815.31796-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build errors when LEDS_CLASS=m and NET_DSA_HIRSCHMANN_HELLCREEK=y.
This limits the latter to =m when LEDS_CLASS=m.

microblaze-linux-ld: drivers/net/dsa/hirschmann/hellcreek_ptp.o: in function `hellcreek_ptp_setup':
(.text+0xf80): undefined reference to `led_classdev_register_ext'
microblaze-linux-ld: (.text+0xf94): undefined reference to `led_classdev_register_ext'
microblaze-linux-ld: drivers/net/dsa/hirschmann/hellcreek_ptp.o: in function `hellcreek_ptp_free':
(.text+0x1018): undefined reference to `led_classdev_unregister'
microblaze-linux-ld: (.text+0x1024): undefined reference to `led_classdev_unregister'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202101060655.iUvMJqS2-lkp@intel.com
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/dsa/hirschmann/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-511-rc2.orig/drivers/net/dsa/hirschmann/Kconfig
+++ lnx-511-rc2/drivers/net/dsa/hirschmann/Kconfig
@@ -4,6 +4,7 @@ config NET_DSA_HIRSCHMANN_HELLCREEK
 	depends on HAS_IOMEM
 	depends on NET_DSA
 	depends on PTP_1588_CLOCK
+	depends on LEDS_CLASS
 	select NET_DSA_TAG_HELLCREEK
 	help
 	  This driver adds support for Hirschmann Hellcreek TSN switches.
