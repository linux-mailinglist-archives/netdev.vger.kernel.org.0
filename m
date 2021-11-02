Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A313A4434F2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhKBR70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKBR7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:59:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30232C061714;
        Tue,  2 Nov 2021 10:56:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r12so468976edt.6;
        Tue, 02 Nov 2021 10:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9bd83yuruHjj+fu1F27HPhAOmF56C6bAf6m3550FiM=;
        b=Oy5Jx0E1p3Hfx9l+d8D/run2J7J9dJ7IL28U++wBfaZlAfsMPxOt33Q6Q/USpyTmm4
         m0QaHcmU+IxPbtHwYScdzfUFUfgs+xw2YBbw3FNbVYM/EJYT/5PdpS5kmUJcALC6t1is
         yvzYvbvK8oILlPZXWMK4ZQoJhBG7Is7AHCEyNqGO4cuHKyRVs5F6noPCa6ThT46nqvIO
         TNrgzHreqVzoBPs4IOvZUiF6swrK3wK9wc+LYyQdvsm2DUaXtldB4UGshjhf2eWEdq0A
         49IkT+yA0W/6+z5nTo+fIBDV2y17PRxCXc/7J+x5GnIFhur2E4O5yl6f+Ghx+Kytdzzn
         eKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9bd83yuruHjj+fu1F27HPhAOmF56C6bAf6m3550FiM=;
        b=q9MLR+tGZZF6izn9NS3orzQrJT+1BJEzwKtOiTFFJXfgyRCiBVYqSqZ/vk/1EJFd4w
         rK/bVs81gMLuiS2/ZkxJVQNSfqrGf3A3mgkRCSxvUPips3NRmV5wUcnNCuXbCESzvvbC
         33YOcV6zMkiLR5iKljD233SU/Xn1knx0b3lrcJSd4gWn69bLi/+qWUnUSoyfgAP+MuJv
         r9UsB28lbJNBhQ9G5cWyxGY+UbqBTbF+TyTlMHqZhS0FAsEwfQBjWKbLUgrh6L+6jdm4
         kzSOax24LKQoVJ7nwlZSb61S1xCOCvHu491Wcf9ePZPifetgnwUvaLASWpAzq66ICrVR
         fIfA==
X-Gm-Message-State: AOAM533ZRibaLOv8qJa02NLHHZzDdfSZVZclJa0u1QK52Dsc7mpRlM+r
        bhWy8IPAsneuL3n0YTUfRmY=
X-Google-Smtp-Source: ABdhPJxn3oQoKHQgAcgpVUZRtcQ3KhAsliWpS8y0Wfesw5f/tE87t/zv7JNYT8Oie0zbrlnAGXJx4g==
X-Received: by 2002:a17:906:2f10:: with SMTP id v16mr46526849eji.434.1635875808597;
        Tue, 02 Nov 2021 10:56:48 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ne33sm2303277ejc.6.2021.11.02.10.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 10:56:48 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH] net: dsa: qca8k: make sure PAD0 MAC06 exchange is disabled
Date:   Tue,  2 Nov 2021 18:56:29 +0100
Message-Id: <20211102175629.24102-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some device set MAC06 exchange in the bootloader. This cause some
problem as we don't support this strange mode and we just set the port6
as the primary CPU port. With MAC06 exchange, PAD0 reg configure port6
instead of port0. Add an extra check and explicitly disable MAC06 exchange
to correctly configure the port PAD config.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 8 ++++++++
 drivers/net/dsa/qca8k.h | 1 +
 2 files changed, 9 insertions(+)

Some comments here:
Resetting the switch using the sw reg doesn't reset the port PAD
configuration. I was thinking if it would be better to clear all the
pad configuration but considering that the entire reg is set by phylink
mac config, I think it's not necessary as the PAD related to the port will
be reset anyway with the new values. Have a dirty configuration on PAD6
doesn't cause any problem as we have that port disabled and it would be
reset and configured anyway if defined.

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ea7f12778922..a429c9750add 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1109,6 +1109,14 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Make sure MAC06 is disabled */
+	ret = qca8k_reg_clear(priv, QCA8K_REG_PORT0_PAD_CTRL,
+			      QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
+	if (ret) {
+		dev_err(priv->dev, "failed disabling MAC06 exchange");
+		return ret;
+	}
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index e10571a398c9..128b8cf85e08 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -34,6 +34,7 @@
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
 #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN		BIT(31)
 #define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
 #define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
-- 
2.32.0

