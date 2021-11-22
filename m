Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE18B4587A2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhKVBHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhKVBHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:13 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17AEC061574;
        Sun, 21 Nov 2021 17:04:07 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w1so69478080edc.6;
        Sun, 21 Nov 2021 17:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/cLPO5f0ot2ycNitQUXP88gu1gvzel2oe71trLRdPc=;
        b=mhooTJZoHHckwbjVOumC3mFhmtcmx7/TquaT7PYTfo4UkhOgEIBHmrTSwO2yYgCGii
         iRK7b+VV4LgVmk9o/0CFJ5pgrAEdwJI5YfoFWRw+Ijb92qr4EcCAL83tr6qt2eQU7PqL
         9087Bpjsrs0IR2t3CytcxApvZX0g88skOgomJSdGyWEMGsg5sO0BCsNBtZP8LM3lrRFa
         D17ycAVpq9LaC5AI6HkfEgFlcesvfODJj3Rvwa4Tq12ahyH3YRnvMaPkeco0iMoDSMvy
         Hh7Y8p/QpRNrsMbzl3WhFfwcHsZ05TzLRLV36ODXOSdlohd+E+Lq4WjRan1y9vtPXKg5
         cktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/cLPO5f0ot2ycNitQUXP88gu1gvzel2oe71trLRdPc=;
        b=YR9SZGPjDC865Zja8WmJJaThZ0p59vpnRF7qE6q7tbh6SrNtzH/ZSj3wwkUorCcEjZ
         1yF/GxoFukpqJxijd+7l6tOaslctNUH0tRBjhgcpIIIGK/hPN9KseegX3/5rMsM6IAjY
         sls+6RD8Zu++hXOvnmu4hhg8HyjUd6vjv+NqXsUxXJGeWvMaPfKuOvOYDAojPV46+YP0
         CixGiFlcwU2Ux0Y7/c+A5+U78nfJ7FeEgxh5KT9wYgEzLtqifWocs74kAGymhGiSY21c
         6B1ierlupn93khlkFG2XIvQ0LPfDpr+VvWPRql/N6dKvQhtwyMgiMC6kG+zOiyZSHCem
         LJqA==
X-Gm-Message-State: AOAM530EhSYiH7p0BxGQAhJDCrM7QvcxqSQCAKFhdlZLFHXSiCwFTBp5
        8aMupHZMtRqL0iYe/blaEIA=
X-Google-Smtp-Source: ABdhPJzCcB4cNM8TLvFbFz2mRD0VKRWTaAniRYXyx3wBa3QrV/+Raxffh+6kFfDsPsjUlzmSgbp+hw==
X-Received: by 2002:a17:906:9bf9:: with SMTP id de57mr35431544ejc.439.1637543046338;
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 8/9] net: dsa: qca8k: add set_ageing_time support
Date:   Mon, 22 Nov 2021 02:03:12 +0100
Message-Id: <20211122010313.24944-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k support setting ageing time in step of 7s. Add support for it and
set the max value accepted of 7645m.
Documentation talks about support for 10000m but that values doesn't
make sense as the value doesn't match the max value in the reg.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1ff951b6fe07..21a7f1ed7a5c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1247,6 +1247,10 @@ qca8k_setup(struct dsa_switch *ds)
 	/* We don't have interrupts for link changes, so we need to poll */
 	ds->pcs_poll = true;
 
+	/* Set min a max ageing value supported */
+	ds->ageing_time_min = 7000;
+	ds->ageing_time_max = 458745000;
+
 	return 0;
 }
 
@@ -1786,6 +1790,26 @@ qca8k_port_fast_age(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct qca8k_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	u32 val;
+
+	/* AGE_TIME reg is set in 7s step */
+	val = secs / 7;
+
+	/* Handle case with 0 as val to NOT disable
+	 * learning
+	 */
+	if (!val)
+		val = 1;
+
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
+				  QCA8K_ATU_AGE_TIME(val));
+}
+
 static int
 qca8k_port_enable(struct dsa_switch *ds, int port,
 		  struct phy_device *phy)
@@ -1985,6 +2009,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_strings		= qca8k_get_strings,
 	.get_ethtool_stats	= qca8k_get_ethtool_stats,
 	.get_sset_count		= qca8k_get_sset_count,
+	.set_ageing_time	= qca8k_set_ageing_time,
 	.get_mac_eee		= qca8k_get_mac_eee,
 	.set_mac_eee		= qca8k_set_mac_eee,
 	.port_enable		= qca8k_port_enable,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index a533b8cf143b..40ec8012622f 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -175,6 +175,9 @@
 #define   QCA8K_VTU_FUNC1_BUSY				BIT(31)
 #define   QCA8K_VTU_FUNC1_VID_MASK			GENMASK(27, 16)
 #define   QCA8K_VTU_FUNC1_FULL				BIT(4)
+#define QCA8K_REG_ATU_CTRL				0x618
+#define   QCA8K_ATU_AGE_TIME_MASK			GENMASK(15, 0)
+#define   QCA8K_ATU_AGE_TIME(x)				FIELD_PREP(QCA8K_ATU_AGE_TIME_MASK, (x))
 #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
 #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
 #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
-- 
2.32.0

