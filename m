Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEC64435A0
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhKBSeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhKBSeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:34:02 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15108C061714;
        Tue,  2 Nov 2021 11:31:27 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f4so668515edx.12;
        Tue, 02 Nov 2021 11:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UzE3aFC5YcLdwkQ6Vy4Gt1qU86BWbr4tVYewcSG66nQ=;
        b=jZ+w9TtW2uv87SbXr3TddnD2SSetbQayCuEm6ka7K8/V7gpObyBSBxmGR7Sllz4DY5
         PP0pRHFxhmzDcF71DK2qdBrV4bDY5FMRPeQCcJNgaMDxuZteVJTqc+CMwY0VUQtX6nQt
         2PhAsswt6XnQZSQdeQC5biGIi3EFCYtARHvVtDBvD2Q+tOZRF/O75+bq29NcLuhbbusX
         eLp8QxsKcGL8HBqmpiUDb8JogaYKZdE7vPRHLYRy3J39fp4BR7jFvjS0ArCGEUC+C09N
         Er/XjDsxsV864wcdipNLvpJo2abfuVwXVjZ/ydW9lugxj1q23u9zqn7kHJskPJ2xne/w
         E9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UzE3aFC5YcLdwkQ6Vy4Gt1qU86BWbr4tVYewcSG66nQ=;
        b=Y7jl7rnrR39K/V1C/S/g9u1YqKxJjgDKCGdXTlxfjXkEtVWv28eGA0WUP2ILIzmi/t
         bWsgU9a19rZQRVG7/u++hdULNuPrs7P5Im3QTXhU/JxrrzgA6/OvoKHXP9LTkd5JUO3k
         YOq6TQG81P21RiALAEAO9+sF0KqPu//NWEUtS+9zNsqsonvEiJlY3hJJf/iKLNQPsTNz
         QoCDKsJcvWzTzmYyq1W1LTux55FCvcYK/d5rmzm/xgWMiQ8+qCLs8vQH224HcqAC76iS
         NeLW8LAmr4NNIt0OVdiD/X2Tblr1PLLaYXq+cSllk9bktAOwP8OA3vcH5JoIyo7jyb0U
         GvLg==
X-Gm-Message-State: AOAM532PEuAXOcn/PhN3D9u6Jgn/3ZjhOI7fW7CT8qgRx0n63p9BESE5
        Qh3scIojAraYU7ootmfOg0Y=
X-Google-Smtp-Source: ABdhPJy3gs9aUIGtc/eD8JPwWjgxRafNwE8jBy+EsImIlIRjoHJWFpz72i+bk43z9qcfiXth0XaBCA==
X-Received: by 2002:a17:907:7fa8:: with SMTP id qk40mr19728228ejc.497.1635877885506;
        Tue, 02 Nov 2021 11:31:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id h7sm10802362edt.37.2021.11.02.11.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 11:31:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net PATCH] net: dsa: qca8k: make sure PAD0 MAC06 exchange is disabled
Date:   Tue,  2 Nov 2021 19:30:41 +0100
Message-Id: <20211102183041.27429-1-ansuelsmth@gmail.com>
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
Fixes: 3fcf734aa482 ("net: dsa: qca8k: add support for cpu port 6")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
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

