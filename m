Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040B042849F
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhJKBcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhJKBcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0F9C06161C;
        Sun, 10 Oct 2021 18:30:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z20so60965941edc.13;
        Sun, 10 Oct 2021 18:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jd+0uo7As5z9rHDrDDtYI/guGyme7pdtTuAfg9W+PiM=;
        b=cfcWu+t0weNbQaxLaC3uCQSIsmU+HJuhYGSR48QuE2ow8arpScuqC9Ag7xg6JPcP+N
         XhT6AEq9QpwgmymmH13Qz2ZUCyLqfqGriFzupZI2SQLCiHrIlBCfJu09wf1mN3/6d17J
         Mz70aAvQHYbSkAiSlxN13Lvr1ujppxZsiTZRawuHCfXnkQNue9VOpNkNAO4n60/W0w8Y
         FZ+w2dWiK1IdFiFVWlY7jc7TWbVi1zsOuHQzZc8lgUprxkYsWJ4+Dr/BH9cZkOifvh74
         0s6njTGCd/be1roCgJ+cq2AZ37jhsQSPdTkvgrkHJuesQivyMW27mpfShU+u14bTs/+A
         OUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jd+0uo7As5z9rHDrDDtYI/guGyme7pdtTuAfg9W+PiM=;
        b=E/mY/G/w+9u8Ep5PUoN8Odi3pmaV0wsNPRViYik4+vqpKMw2ZGrGsqVRq04f2rmRI+
         dPEl8InClA1Kgvj8dAuHvywzZIQjY1TwuZSKx0lwABAaudEFg9e1R0ZqLxqw3Yv4caq2
         5CTK0aIeZ2jLH9RW7/uYvBB7Ew+r8KWgqkpoE5JhYV1e42ORkNJz2caI5riW90/5vp+C
         0czsCtVmNdQxJp3SSf0CqHUsNK11RLPtSSfJnFMCjrgzPQcFDp2XGYR0Oz+NJGmiRhb5
         ZHPn2Bt7FfICSZaK4hjPgJQ78q3sx55zg4IfHqRi7xsH10ZFHpsFBohQInU2LD/EMerl
         WOBw==
X-Gm-Message-State: AOAM533393fgna6Xnw1GDHzAV04fAjZtsZ+meJcHPdh1cBvNFqbRP7Ju
        h6gtY6H62L+ifIcURjDvr88=
X-Google-Smtp-Source: ABdhPJwMvWT5zrJlbsL2p3wmLHkiTdsYFc47WxsXnR6m+YE+ty0eLZdcu7B+gIIFfUhQHBffGewt9g==
X-Received: by 2002:a50:dac3:: with SMTP id s3mr37293820edj.322.1633915841751;
        Sun, 10 Oct 2021 18:30:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:41 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 01/14] net: dsa: qca8k: add mac_power_sel support
Date:   Mon, 11 Oct 2021 03:30:11 +0200
Message-Id: <20211011013024.569-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing mac power sel support needed for ipq8064/5 SoC that require
1.8v for the internal regulator port instead of the default 1.5v.
If other device needs this, consider adding a dedicated binding to
support this.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 31 +++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  5 +++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..a892b897cd0d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -950,6 +950,33 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
+{
+	u32 mask = 0;
+	int ret = 0;
+
+	/* SoC specific settings for ipq8064.
+	 * If more device require this consider adding
+	 * a dedicated binding.
+	 */
+	if (of_machine_is_compatible("qcom,ipq8064"))
+		mask |= QCA8K_MAC_PWR_RGMII0_1_8V;
+
+	/* SoC specific settings for ipq8065 */
+	if (of_machine_is_compatible("qcom,ipq8065"))
+		mask |= QCA8K_MAC_PWR_RGMII1_1_8V;
+
+	if (mask) {
+		ret = qca8k_rmw(priv, QCA8K_REG_MAC_PWR_SEL,
+				QCA8K_MAC_PWR_RGMII0_1_8V |
+				QCA8K_MAC_PWR_RGMII1_1_8V,
+				mask);
+	}
+
+	return ret;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -979,6 +1006,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_mac_pwr_sel(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ed3b05ad6745..fc7db94cc0c9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -100,6 +100,11 @@
 #define   QCA8K_SGMII_MODE_CTRL_PHY			(1 << 22)
 #define   QCA8K_SGMII_MODE_CTRL_MAC			(2 << 22)
 
+/* MAC_PWR_SEL registers */
+#define QCA8K_REG_MAC_PWR_SEL				0x0e4
+#define   QCA8K_MAC_PWR_RGMII1_1_8V			BIT(18)
+#define   QCA8K_MAC_PWR_RGMII0_1_8V			BIT(19)
+
 /* EEE control registers */
 #define QCA8K_REG_EEE_CTRL				0x100
 #define  QCA8K_REG_EEE_CTRL_LPI_EN(_i)			((_i + 1) * 2)
-- 
2.32.0

