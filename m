Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BFB5AC813
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 01:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiIDXB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 19:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiIDXBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 19:01:54 -0400
X-Greylist: delayed 342 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 04 Sep 2022 16:01:52 PDT
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D582CDD8;
        Sun,  4 Sep 2022 16:01:52 -0700 (PDT)
Received: from localhost (7of9.are-b.org [127.0.0.1])
        by 7of9.schinagl.nl (Postfix) with ESMTP id B1A11186CF67;
        Mon,  5 Sep 2022 00:56:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662332168; bh=phA1KDNGpHpv+f9x5R/STb/SPozqbuTHV7NLvQ1f8PY=;
        h=From:To:Cc:Subject:Date;
        b=R87eR7MpBXwdGi0JqXtn2cbnS+2lRuvHnEJH11WUTM4T+Sgtx9zqIy1w5KlgCqV/0
         WMAHz709Q/Leom28gwdIlcp0y5SkWb1VkfgRIaunnfQ21hCfuI4ni6Vf43VqsGV90j
         9dzJXmGRI+WAkYrzTWz7o/OZQdfxX0quXAGDGHns=
X-Virus-Scanned: amavisd-new at schinagl.nl
Received: from 7of9.schinagl.nl ([127.0.0.1])
        by localhost (7of9.schinagl.nl [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id cL2gxblWpbqr; Mon,  5 Sep 2022 00:56:00 +0200 (CEST)
Received: from valexia.are-b.org (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id B6282186CF62;
        Mon,  5 Sep 2022 00:56:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662332160; bh=phA1KDNGpHpv+f9x5R/STb/SPozqbuTHV7NLvQ1f8PY=;
        h=From:To:Cc:Subject:Date;
        b=CJQd91rUdNmr9+/Sg0QrZg85JRb2YoSyrSUA5vjQgG2g/DmpOxCb+ztCN2Fe5Laz6
         md89y51MPwJw7MqMASlLQ9jc4iuKawRIYx+4m2++CEXUe+z+2JcV83vsQHGJxnQ0cw
         wdoHSWK5hA9eudX7K5PQr0r1Jh+RNipL8xEeIV34=
From:   Olliver Schinagl <oliver@schinagl.nl>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     inux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Olliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH] phy: Add helpers for setting/clearing bits in paged registers
Date:   Mon,  5 Sep 2022 00:55:55 +0200
Message-Id: <20220904225555.1994290-1-oliver@schinagl.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we have helpers for setting/clearing bits in PHY registers and MMD
registers, add also helpers to do the same with paged registers.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 include/linux/phy.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..6f13dc9b4fe5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1262,6 +1262,32 @@ static inline int phy_clear_bits_mmd(struct phy_device *phydev, int devad,
 	return phy_modify_mmd(phydev, devad, regnum, val, 0);
 }
 
+/**
+ * phy_set_bits_paged - Convenience function for setting bits in a paged register
+ * @phydev: the phy_device struct
+ * @page: the page for the phy
+ * @regnum: register number to write
+ * @val: bits to set
+ */
+static inline int phy_set_bits_paged(struct phy_device *phydev, int page,
+				     u32 regnum, u16 val)
+{
+	return phy_modify_paged(phydev, page, regnum, 0, val);
+}
+
+/**
+ * phy_clear_bits_paged - Convenience function for clearing bits in a paged register
+ * @phydev: the phy_device struct
+ * @page: the page for the phy
+ * @regnum: register number to write
+ * @val: bits to clear
+ */
+static inline int phy_clear_bits_paged(struct phy_device *phydev, int page,
+				       u32 regnum, u16 val)
+{
+	return phy_modify_paged(phydev, page, regnum, val, 0);
+}
+
 /**
  * phy_interrupt_is_valid - Convenience function for testing a given PHY irq
  * @phydev: the phy_device struct
-- 
2.37.2

