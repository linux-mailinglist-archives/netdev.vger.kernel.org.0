Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D42146BE92
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhLGPDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbhLGPDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:03:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F163C0617A1;
        Tue,  7 Dec 2021 07:00:04 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r11so57794206edd.9;
        Tue, 07 Dec 2021 07:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fn8KnA/llYwqXsiL6Q1/l2Tp5yDFYZmOjaTdrAUpvsE=;
        b=J+3jyvCHsVTRr7ZIFrgRwip1RSFWK6pkFaX4vjByn38jDh0H6PxKl2t53lvpcNyplB
         H9BHqDehFuZTk1kqZ1XdEfBQJ/ftge1K8imp6zCXIC4zXWKbFvmGNbILMekyls1+bfF9
         wLoEOXzQgEJ7G3j/7accaC078p9Sx4DVMtUGsLA9prwJ6JyEUimIFDgt392Z7HPD2jAt
         kt65lINWKJXuJypQzohGV0KY9ya9WzrBbvrPxT+NPcm7rnEEKww4va86RGZRLn4zo9PQ
         bfq6ZM5JjsEjaEPKtpfup9NA1+ftaj41RXR/J6JmYW+LfJV22QFTdSrgw/0EFEGZhsDf
         aXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fn8KnA/llYwqXsiL6Q1/l2Tp5yDFYZmOjaTdrAUpvsE=;
        b=7mMtoJMNukxG95gCRIIgHkiVcdw7glFIBaXs1thL0dOFUC1JVxUJEHFpiCuMg2zAXZ
         duIkc5lb5wSvJ11fPbkTxqWe/PsJx5PLlWhA497JVBNFHnagmH5cfapQU0lAQOgm2Xsl
         6XF9GTsX4gLbvXghSWX+bcrVIm79ovnTOpbgcxfYqtoE0z9m5/qtd9CtqXlND46cp4i5
         nOvOhdZHGUuikltQuVbNhIs0pkIXpVr3PQups6KuSyGZj3XX6jJcJ7FTkIAqLsovTAFF
         7lo2GDpL6jBAc08qEJ6jMFlriN5HCOSK8OapRv0SWDIgY46rBADLEW95nS1e9crHCIeg
         NaYA==
X-Gm-Message-State: AOAM530F6xC0+R4bo/UNXCy+9G1y/nxxJ9/hqZhlap4YSmJT1vgrf+uU
        QC6MJeYBmtKNYQEa5IMUm0Y=
X-Google-Smtp-Source: ABdhPJzkRqh4jR7yH+Nb3fvZhcu+e27U/39w6GmoxNOm6L6ZJJl5irOJZqafS9C79RJq7AgnZHbRWg==
X-Received: by 2002:a17:906:168e:: with SMTP id s14mr52618218ejd.340.1638889202045;
        Tue, 07 Dec 2021 07:00:02 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id i10sm9131821ejw.48.2021.12.07.07.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 07:00:01 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 6/6] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Tue,  7 Dec 2021 15:59:42 +0100
Message-Id: <20211207145942.7444-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation, we can cache lo and hi the same way we do with the
page. This massively reduce the mdio write as 3/4 of the time we only
require to write the lo or hi part for a mdio write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 49 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d2c6139be9ac..64643f1e2f16 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -94,6 +94,48 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
+static u16 qca8k_current_lo = 0xffff;
+
+static int
+qca8k_set_lo(struct mii_bus *bus, int phy_id, u32 regnum, u16 lo)
+{
+	int ret;
+
+	if (lo == qca8k_current_lo) {
+		// pr_info("SAME LOW");
+		return 0;
+	}
+
+	ret = bus->write(bus, phy_id, regnum, lo);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit lo register\n");
+
+	qca8k_current_lo = lo;
+	return 0;
+}
+
+static u16 qca8k_current_hi = 0xffff;
+
+static int
+qca8k_set_hi(struct mii_bus *bus, int phy_id, u32 regnum, u16 hi)
+{
+	int ret;
+
+	if (hi == qca8k_current_hi) {
+		// pr_info("SAME HI");
+		return 0;
+	}
+
+	ret = bus->write(bus, phy_id, regnum, hi);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit hi register\n");
+
+	qca8k_current_hi = hi;
+	return 0;
+}
+
 static int
 qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
@@ -125,12 +167,9 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = bus->write(bus, phy_id, regnum, lo);
+	ret = qca8k_set_lo(bus, phy_id, regnum, lo);
 	if (ret >= 0)
-		ret = bus->write(bus, phy_id, regnum + 1, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit register\n");
+		ret = qca8k_set_hi(bus, phy_id, regnum + 1, hi);
 }
 
 static int
-- 
2.32.0

