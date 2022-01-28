Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E70C49F11A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345445AbiA1ChZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345452AbiA1ChZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:37:25 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F021BC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:24 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id w27-20020a9d5a9b000000b005a17d68ae89so4422359oth.12
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5LlZ9oCa+qe6HqXhfShIgFg5xKjOIO7wD57zX+WYsJ4=;
        b=Jk3rPoY3AzUQigO5zDJOAB86MA5dSQlsohzxwKuZ5XbwC7aRZ0gX4Uage9ysj82QaH
         Jfnf9FrQsDV4dtfFVAnmEGak8H1tg7pgCIHGhl2tRoQrbrLVtPer6QZpuxZDzUKRzruY
         2LI/rjHJBKPLUO3WVL+e2XRn4WR0alOp1tuPoPXj3cABih83Za6K0cQGppWWbQXJAPci
         viBvKcmIpaUKHWHmlfkSxOvcwnlfe2LP4uT7KqSmd3LHq95sllk6ZuqPPl75j/FSqyfg
         TwWtsatUkuMIRFEGK0vFc2mdHfYh46mBpj7OyCXrZEXekAYH3a6dsVtczt4dZdyJ2bPb
         ReWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5LlZ9oCa+qe6HqXhfShIgFg5xKjOIO7wD57zX+WYsJ4=;
        b=KZYLTvmXs1D0lMtN57QRgakho/zKFTk3yATu79kvgM1jK8Ia11xTfeZfzrO6oLGLQa
         LrhVSBzYs+LziP3kDv5I9/BkvE0/vZPpCk8Jnf1vn7HT5YelkO+iFNsup9NERI7D6ydu
         6OqH9Gp88G52V/YmMTlzHV7pHlRh0dGhbSWNTl7CiycD8ehbBnPQnFjG4dgE2fMu9b59
         GY22vPcK06rKzJa4jhBb0//rCWKYjW64hlNVTBNMyyewAev/dbBUvXA/UvFKZCJBkQeZ
         Y5p+CBRQIMzVNcdPyjPcCY4ZgXmCKULOj/tMIVgSov+g07376PFYJte+NeGRgFlo7tfX
         HR0Q==
X-Gm-Message-State: AOAM533ZUJNKEQYXQZgm6ccfaVhRHsrrYS9DufZtOZbwiEFv1eERtla4
        JjsSNWTqL1acZ35AGZm/ygGIoQ3jpR75rg==
X-Google-Smtp-Source: ABdhPJzjxHissXZnNp3rG1vKGHQIGDfU16NwIIj1lM6L+Uq6AqqVAFrUbKBjuDne2Yq60r6cywPCfw==
X-Received: by 2002:a9d:ee1:: with SMTP id 88mr3763125otj.279.1643337443945;
        Thu, 27 Jan 2022 18:37:23 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:37:23 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 11/11] net: dsa: realtek: rtl8365mb: multiple cpu ports, non cpu extint
Date:   Thu, 27 Jan 2022 23:36:11 -0300
Message-Id: <20220128023611.2424-12-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128023611.2424-1-luizluca@gmail.com>
References: <20220128023611.2424-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now CPU port is not limited to a single port. Also, extint can be used
as non-cpu ports, as long as it defines relatek,ext-int. The last cpu
port will be used as trap_port.

The CPU information was dropped from chip data as it was not used
outside setup. The only other place it was used is when it wrongly
checks for CPU port when it should check for extint.

realtek_priv->cpu_port is now only used by rtl8366rb.c

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 53 +++++++++++++++--------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 59e08b192c06..6a00a162b2ac 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -556,7 +556,6 @@ struct rtl8365mb_port {
  * @chip_ver: chip silicon revision
  * @port_mask: mask of all ports
  * @learn_limit_max: maximum number of L2 addresses the chip can learn
- * @cpu: CPU tagging and CPU port configuration for this chip
  * @mib_lock: prevent concurrent reads of MIB counters
  * @ports: per-port data
  * @jam_table: chip-specific initialization jam table
@@ -571,7 +570,6 @@ struct rtl8365mb {
 	u32 chip_ver;
 	u32 port_mask;
 	u32 learn_limit_max;
-	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
 	const struct rtl8365mb_jam_tbl_entry *jam_table;
@@ -769,17 +767,20 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 	u32 val;
 	int ret;
 
-	if (port != priv->cpu_port) {
-		dev_err(priv->dev, "only one EXT interface is currently supported\n");
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
+	if (ext_int == RTL8365MB_NOT_EXT) {
+		dev_err(priv->dev,
+			"Port %d is not identified as extenal interface.\n",
+			port);
 		return -EINVAL;
 	}
 
 	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
-	mb = priv->chip_data;
-	p = &mb->ports[port];
-	ext_int = p->ext_int;
 
 	/* Set the RGMII TX/RX delay
 	 *
@@ -859,15 +860,17 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 	int val;
 	int ret;
 
-	if (port != priv->cpu_port) {
-		dev_err(priv->dev, "only one EXT interface is currently supported\n");
-		return -EINVAL;
-	}
-
 	mb = priv->chip_data;
 	p = &mb->ports[port];
 	ext_int = p->ext_int;
 
+	if (ext_int == RTL8365MB_NOT_EXT) {
+		dev_err(priv->dev,
+			"Port %d is not identified as extenal interface.\n",
+			port);
+		return -EINVAL;
+	}
+
 	if (link) {
 		/* Force the link up with the desired configuration */
 		r_link = 1;
@@ -1734,10 +1737,8 @@ static void rtl8365mb_irq_teardown(struct realtek_priv *priv)
 	}
 }
 
-static int rtl8365mb_cpu_config(struct realtek_priv *priv)
+static int rtl8365mb_cpu_config(struct realtek_priv *priv, struct rtl8365mb_cpu *cpu)
 {
-	struct rtl8365mb *mb = priv->chip_data;
-	struct rtl8365mb_cpu *cpu = &mb->cpu;
 	u32 val;
 	int ret;
 
@@ -1839,11 +1840,17 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
+	cpu.mask = 0;
 	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
-		priv->cpu_port = cpu_dp->index;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
-		ret = rtl8365mb_cpu_config(priv);
+		cpu.enable = 1;
+		cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
+		cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
+		cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
+		cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
+		cpu.trap_port = cpu_dp->index;
+		cpu.mask |= BIT(cpu_dp->index);
+
+		ret = rtl8365mb_cpu_config(priv, &cpu);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -1862,7 +1869,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dn = dsa_to_port(priv->ds, i)->dn;
 
 		/* Forward only to the CPU */
-		ret = rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
+		ret = rtl8365mb_port_set_isolation(priv, i, cpu.mask);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -2003,12 +2010,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-		mb->cpu.enable = 1;
-		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
-		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
-		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-		mb->cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
-
 		break;
 	default:
 		dev_err(priv->dev,
-- 
2.34.1

