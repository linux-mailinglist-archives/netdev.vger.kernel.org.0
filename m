Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B185C3D9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGATwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:52:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39190 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfGATwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:52:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so6508541pgc.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+jQsg9MU51amGGS/kxUo2BKmC95rhUWFBTRFO2FxxaM=;
        b=Mv9+1dyMHuh0MroVoMV4O4cKgAzSJhfv5V1BLa6TY7gokr3jnlQNicp6nL1QVoZLn5
         07+1zLyZ3YER/8Xwq6pWry1VTFUWYLJ1ALF3KXR+xmUGIzxaEMbmFnMpqf1dBbFWd+Qm
         AePbX73zyAjzAdnpAbW7ySwX12axoJdH8xcg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+jQsg9MU51amGGS/kxUo2BKmC95rhUWFBTRFO2FxxaM=;
        b=oOhWJ1OooaK9ohL55jRGJxxVhWFMrgD7lVKpPhMMlVatRWLvs+33XO8uZyDKcKxPYl
         KtLldxwhNZo19LtLoHWs893tnnM/Jwz5pNgd94Rnk76U0PcRxy6nkc+YTX9ltys4Ejw1
         JaboDkXqdXQ5T6MgU+ZatKr4j25pm8//quvqq9QwfSj7bs3Fzqp1+TKA+QQUa1YXnZP4
         w0lBXClkTbHMAuepKwnL4/XjkiwDFTDPFStN5Pz3XooMfLSsIw9wH7AzcWn2pR8l1o21
         gMhv59GFCXrU96RIr/RKYtvoqnAdJXjODF2tWetACBa5lqa9pe2ME0k+jCWiHw1zrdBy
         baQg==
X-Gm-Message-State: APjAAAWTPIX7C5rH1GsYvWb74bLi8DwmTon3QpY3q/tQsm9VFnnzZ7mC
        KGe2wwkpAeTanF6wm7mEdt/YMA==
X-Google-Smtp-Source: APXvYqzuALJgZGNQlRvYTcL6uK9tRgXF+DHaNInWiePUvRU/llYH4ZpSOEnJv8Pvs3Yu+QLAGKU/5A==
X-Received: by 2002:a17:90a:cb15:: with SMTP id z21mr1086167pjt.87.1562010752079;
        Mon, 01 Jul 2019 12:52:32 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id v5sm11207301pgq.66.2019.07.01.12.52.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 12:52:31 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E extension pages
Date:   Mon,  1 Jul 2019 12:52:24 -0700
Message-Id: <20190701195225.120808-2-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190701195225.120808-1-mka@chromium.org>
References: <20190701195225.120808-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8211E has extension pages, which can be accessed after
selecting a page through a custom method. Add a function to
modify bits in a register of an extension page and a few
helpers for dealing with ext pages.

rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
inspired by their counterparts phy_modify_paged() and
phy_restore_page().

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
This code might be applicable to other Realtek PHYs, but I don't
have access to the datasheets to confirm it, so for now it's just
for the RTL8211E.

 drivers/net/phy/realtek.c | 61 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb829..dfc2e20ef335 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -26,6 +26,9 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+#define RTL8211E_EXT_PAGE			7
+#define RTL8211E_EPAGSR				0x1e
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -53,6 +56,64 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+static int rtl821e_select_ext_page(struct phy_device *phydev, int page)
+{
+	int rc;
+
+	rc = phy_write(phydev, RTL821x_PAGE_SELECT, RTL8211E_EXT_PAGE);
+	if (rc)
+		return rc;
+
+	return phy_write(phydev, RTL8211E_EPAGSR, page);
+}
+
+static int rtl821e_restore_page(struct phy_device *phydev, int oldpage, int ret)
+{
+	int r;
+
+	if (oldpage >= 0) {
+		r = phy_write(phydev, RTL821x_PAGE_SELECT, oldpage);
+
+		/* Propagate the operation return code if the page write
+		 * was successful.
+		 */
+		if (ret >= 0 && r < 0)
+			ret = r;
+	} else {
+		/* Propagate the page selection error code */
+		ret = oldpage;
+	}
+
+	return ret;
+}
+
+static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
+				    int page, u32 regnum, u16 mask, u16 set)
+{
+	int ret = 0;
+	int oldpage;
+	int new;
+
+	oldpage = phy_read(phydev, RTL821x_PAGE_SELECT);
+	if (oldpage < 0)
+		goto out;
+
+	ret = rtl821e_select_ext_page(phydev, page);
+	if (ret)
+		goto out;
+
+	ret = phy_read(phydev, regnum);
+	if (ret < 0)
+		goto out;
+
+	new = (ret & ~mask) | set;
+	if (new != ret)
+		ret = phy_write(phydev, regnum, new);
+
+out:
+	return rtl821e_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
-- 
2.22.0.410.gd8fdbe21b5-goog

