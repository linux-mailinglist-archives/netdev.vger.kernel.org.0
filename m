Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AFE5ACEB9
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiIEJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbiIEJUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:20:34 -0400
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564963CBE7;
        Mon,  5 Sep 2022 02:20:27 -0700 (PDT)
Received: from localhost (7of9.are-b.org [127.0.0.1])
        by 7of9.schinagl.nl (Postfix) with ESMTP id 3DCA0186D1DD;
        Mon,  5 Sep 2022 11:20:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662369626; bh=TXY8AK2KX6KdV4YDAf6gZv3LILVU/MMo1Yis53F5F0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Lacy7sjlUvAPyWCfOHqdlMuyLRTVPKzSPy/xIyKfZgNFFdYNR9Mc5wn4d7UPG0ude
         B4SidhQlNNRTUizfiKpwNiM92xqfsAe6u58KV44Z0SeoXPeY3771Fu1+kvTOGusX6k
         aPytC+JkkRa/aPFXCY6zWDtbDN34a1kiN3ov+l54=
X-Virus-Scanned: amavisd-new at schinagl.nl
Received: from 7of9.schinagl.nl ([127.0.0.1])
        by localhost (7of9.schinagl.nl [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Hq-PAFgQOPQT; Mon,  5 Sep 2022 11:20:25 +0200 (CEST)
Received: from valexia.are-b.org (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id 7BAF6186D1D8;
        Mon,  5 Sep 2022 11:20:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662369625; bh=TXY8AK2KX6KdV4YDAf6gZv3LILVU/MMo1Yis53F5F0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tcnBbbwOBeK+Vq09NShJskYp4kfR/VRy+muxil+aov++8Jgdk0AraF64hvdD4Rvjn
         sdXUWE0v/ooLwDO6a1Qbv0HcMIuQ+rUW2y3/igi+skoNkRypDqTrRGw51/jiNR9DDL
         T9g+v/Nl4ZU/3qQ7gCiAbRWniNci55FL0zozswnc=
From:   Olliver Schinagl <oliver@schinagl.nl>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     inux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Olliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 2/2] phy: Add helpers for setting/clearing bits in paged registers
Date:   Mon,  5 Sep 2022 11:20:07 +0200
Message-Id: <20220905092007.1999943-3-oliver@schinagl.nl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220905092007.1999943-1-oliver@schinagl.nl>
References: <20220905092007.1999943-1-oliver@schinagl.nl>
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
index 7a2332615b8b..c9be4e6c676b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1272,6 +1272,32 @@ static inline int phy_clear_bits_mmd(struct phy_device *phydev, int devad,
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

