Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D693D5ACEB5
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiIEJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiIEJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:20:25 -0400
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE552FFDB;
        Mon,  5 Sep 2022 02:20:22 -0700 (PDT)
Received: from localhost (7of9.are-b.org [127.0.0.1])
        by 7of9.schinagl.nl (Postfix) with ESMTP id 4DD40186D1D6;
        Mon,  5 Sep 2022 11:20:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662369621; bh=peCe62t0v4jpWqfV/YXdEwf+cC5lObeTxGA/V5js+bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BexAbPaK+h2evk8O1EtV+0WGMdKkPhi8vhePU36c2RdAAQCvigP9kXbVok99EIgYg
         D7IH5HO9JrEELQZC6KLjvxyqavNzBykc6IJZ8A5SzZ6HS0/hQx4yjTw/uk4+xSUQR1
         PI7X8o9u6NRU4HJMHZnRxGS7iLDulLCpWL/i0UHc=
X-Virus-Scanned: amavisd-new at schinagl.nl
Received: from 7of9.schinagl.nl ([127.0.0.1])
        by localhost (7of9.schinagl.nl [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id H80znQZqk0eH; Mon,  5 Sep 2022 11:20:20 +0200 (CEST)
Received: from valexia.are-b.org (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id 7ECB6186D1D1;
        Mon,  5 Sep 2022 11:20:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662369620; bh=peCe62t0v4jpWqfV/YXdEwf+cC5lObeTxGA/V5js+bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Cwv7mJXDB9NhD9fiAdBSQ2QpaJSNGghlXBUNP0bM7wbDrrIfefoFMaJbmWZJTf1km
         h48bEurn7w5eAAFvAVtI7jHFfGYeuIB9j4LIusMDHIoA0B2wk8xNZWPYuflCNwavp4
         vw20HIEjXShX05xBG75tYvjOb3W25udlngc5aEPw=
From:   Olliver Schinagl <oliver@schinagl.nl>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     inux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Olliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 1/2] phy: Move page(d) functions up higher
Date:   Mon,  5 Sep 2022 11:20:06 +0200
Message-Id: <20220905092007.1999943-2-oliver@schinagl.nl>
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

The page(d) phy function's ought to be close to their non-paged and mmd
variants, as it somewhat logically makes more sense and allows for
future expansion with regards to `phy_*_bits_paged` variants.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 include/linux/phy.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..7a2332615b8b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1153,6 +1153,16 @@ int __phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 		   u16 mask, u16 set);
 
+int phy_save_page(struct phy_device *phydev);
+int phy_select_page(struct phy_device *phydev, int page);
+int phy_restore_page(struct phy_device *phydev, int oldpage, int ret);
+int phy_read_paged(struct phy_device *phydev, int page, u32 regnum);
+int phy_write_paged(struct phy_device *phydev, int page, u32 regnum, u16 val);
+int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
+			     u16 mask, u16 set);
+int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
+		     u16 mask, u16 set);
+
 /**
  * __phy_set_bits - Convenience function for setting bits in a PHY register
  * @phydev: the phy_device struct
@@ -1411,16 +1421,6 @@ static inline bool phy_is_pseudo_fixed_link(struct phy_device *phydev)
 	return phydev->is_pseudo_fixed_link;
 }
 
-int phy_save_page(struct phy_device *phydev);
-int phy_select_page(struct phy_device *phydev, int page);
-int phy_restore_page(struct phy_device *phydev, int oldpage, int ret);
-int phy_read_paged(struct phy_device *phydev, int page, u32 regnum);
-int phy_write_paged(struct phy_device *phydev, int page, u32 regnum, u16 val);
-int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
-			     u16 mask, u16 set);
-int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
-		     u16 mask, u16 set);
-
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
-- 
2.37.2

