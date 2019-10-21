Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8ADF71B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfJUUwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:52:13 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39604 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbfJUUv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so14145684qki.6;
        Mon, 21 Oct 2019 13:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6L5GXEQf2TmKkQqvOj5hVJ0JGfsrXHOwa855xP48opA=;
        b=W7Lw1zOWXT7nvlXOKFEfx4L6fOq2WSefuu2Vmo/rRv+SIvmqUDrofJrkYsgzRMcS7L
         2kQnhEa/oKVpNw1PN1nUaZ12h1ZCSBBZHaPp7jprEnA0vNzp31fH02dSp4A92AuMRzV2
         +LrCrA7PmYW/gL/+leoXJUygmtqvDohvw6OC/k2QyamWX4nUUivplmbuANwGRR9A3Gtq
         zViRqPhmptpR7ESB1E1mXL915k71vGRA2YUk4YjBzYb5TJpt+ZJpnEDBlsHoo3s5vG+p
         oZ+yWkPWOEiUk8ZQduJuzVrBRrbH38GBlfegiCmozWs86xGeCiTmfbZgNh3ZPreRlfqu
         iRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6L5GXEQf2TmKkQqvOj5hVJ0JGfsrXHOwa855xP48opA=;
        b=LLovtj8E62rXZkYMEUMMF1Q830BzzyN9JBy4STA1ASAOr9yaO/h9U+dVZYiUJag7Ft
         q9ZwXr9jeK4UX64bGt1i3ll8q19WpvIsRkU9qaEXRcgDoCzcnfYpPCU3L0FSIHnUUFzs
         4FHgH/z6jbfC7mtRO1O7gf4rvKW0TDCVrsKm2hx0H8YLh4GZ/pD8wKr82fsxrHfuAsU/
         H94el7o215+NNcxrgsOorIXoFHXbs2u5koq9VK3NbTU+Su9seytjEgrrCRP6Up6cWqOr
         kA6jtq5POJqUJJWUNZ6tpzw/sarhKSFioIjO9Ed9snnSIzgOcU48RCg1+3OH7kaiFsVV
         CaOA==
X-Gm-Message-State: APjAAAWmyEQd+PXEiaKz4uWFs8IhA8wuYa1Dr0cwXWFikD3M/PZCLF3M
        GY6ozPFTGn1PDkr3wHosZ+Q=
X-Google-Smtp-Source: APXvYqyn6XVtwMcqk3Z1yU0pkzQMVEIJGlawlzuzotpkSNpoIxQjpG2D/30sPjURjAcsNcEkicDySg==
X-Received: by 2002:a37:48c4:: with SMTP id v187mr15970438qka.188.1571691117823;
        Mon, 21 Oct 2019 13:51:57 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f37sm7597023qtb.65.2019.10.21.13.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:57 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 14/16] net: dsa: sja1105: register switch before assigning port private data
Date:   Mon, 21 Oct 2019 16:51:28 -0400
Message-Id: <20191021205130.304149-15-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like the dsa_switch_tree structures, the dsa_port structures will be
allocated on switch registration.

The SJA1105 driver is the only one accessing the dsa_port structure
after the switch allocation and before the switch registration.
For that reason, move switch registration prior to assigning the priv
member of the dsa_port structures.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4b0cb779f187..0ebbda5ca665 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2057,6 +2057,15 @@ static int sja1105_probe(struct spi_device *spi)
 
 	tagger_data = &priv->tagger_data;
 
+	mutex_init(&priv->ptp_data.lock);
+	mutex_init(&priv->mgmt_lock);
+
+	sja1105_tas_setup(ds);
+
+	rc = dsa_register_switch(priv->ds);
+	if (rc)
+		return rc;
+
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		struct sja1105_port *sp = &priv->ports[i];
@@ -2065,12 +2074,8 @@ static int sja1105_probe(struct spi_device *spi)
 		sp->dp = dsa_to_port(ds, i);
 		sp->data = tagger_data;
 	}
-	mutex_init(&priv->ptp_data.lock);
-	mutex_init(&priv->mgmt_lock);
 
-	sja1105_tas_setup(ds);
-
-	return dsa_register_switch(priv->ds);
+	return 0;
 }
 
 static int sja1105_remove(struct spi_device *spi)
-- 
2.23.0

