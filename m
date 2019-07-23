Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063D47166F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbfGWKpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:45:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34642 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389188AbfGWKpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:45:03 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so20479747plt.1;
        Tue, 23 Jul 2019 03:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tLr9+dN/788cYU44X9e1swSeL2hknE+Vg2zg7+VyNDI=;
        b=J/eG3eqsBHV6rPMWCho+F/vhFO3t+zS6ukU3B76ICvgReFf14ic/ypbZmjkJGQvG6C
         bvZ6EN8q/edMiWVM7GmnNnlGb92YslkGpsJ84m20Oiv+2peeEvTh6X7mRa9IdsRvHw8x
         8jUGThWlUR6TWHS2bTJd/R26LOmRYNw59HTPBTtz1dIiV22UdkMsPOxroXRUQXktJz8O
         sWOwPWRWxYmrkvGb437xmLhTfBoyRWBPPmnl1Ob2xafeLTlZY/fiA9tawLX6dA1XicuY
         /pp/1Wn5Dx8XDyY3luzUVQEYJ6pmVXmhBig+9upD2l1D/cbN8qXSE603upJHm7O5H4YV
         Edzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tLr9+dN/788cYU44X9e1swSeL2hknE+Vg2zg7+VyNDI=;
        b=Z/mTcZZNJ3VblliAaRm0lxSlq4v24Kupo21ua9blW8S+nkHcKL4JtUE7ZAfZsXKNxD
         9CknuXmIuvtxfAC+XJ0735OfI202yj6LM3yr1EmoLfCvYNoHhkvs4mRooDWhWF1L0dwz
         EWCMaIIwroPiUGN0PtkkMwjV6tZdKMgNv3hdhb2q9AHmkt6a9DCGf/BfzQry5fpeYuAK
         uexOuBDUYCdElFV2WpZ/NfEOCZUjcoo+OAgGYqzrx4mpebA+/7TI3pGDRtvDr5mIdEFm
         lWHeHoOsq7cF9LuxZTHs1XfZXx2RRVOcwwWbWfH36z38CDcYRHP7HSzrZaEC0XSfUOpq
         3LDg==
X-Gm-Message-State: APjAAAXluTOEZkjLSZz+hdmBhxEesgWx69t0jxlblNOvFdw75gAXVXcl
        t8h4sMN7xbuLmGkF7jM+mSN7KrbK
X-Google-Smtp-Source: APXvYqwp2NR7lU0gvHB/ueXGroAMNzr/fcJ3cU7HRdWuer3b4zvJ8osGftOmVzjVlHD08+BizdYGwA==
X-Received: by 2002:a17:902:1101:: with SMTP id d1mr35553096pla.212.1563878702598;
        Tue, 23 Jul 2019 03:45:02 -0700 (PDT)
Received: from localhost.localdomain ([122.163.0.39])
        by smtp.gmail.com with ESMTPSA id s5sm16795876pfm.97.2019.07.23.03.44.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 03:45:01 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: dsa: sja1105: sja1105_main: Add of_node_put()
Date:   Tue, 23 Jul 2019 16:14:48 +0530
Message-Id: <20190723104448.8125-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each iteration of for_each_child_of_node puts the previous node, but in
the case of a return from the middle of the loop, there is no put, thus
causing a memory leak. Hence add an of_node_put before the return.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 32bf3a7cc3b6..6ed5f1e35789 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -625,6 +625,7 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 		if (of_property_read_u32(child, "reg", &index) < 0) {
 			dev_err(dev, "Port number not defined in device tree "
 				"(property \"reg\")\n");
+			of_node_put(child);
 			return -ENODEV;
 		}
 
@@ -634,6 +635,7 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			dev_err(dev, "Failed to read phy-mode or "
 				"phy-interface-type property for port %d\n",
 				index);
+			of_node_put(child);
 			return -ENODEV;
 		}
 		ports[index].phy_mode = phy_mode;
@@ -643,6 +645,7 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			if (!of_phy_is_fixed_link(child)) {
 				dev_err(dev, "phy-handle or fixed-link "
 					"properties missing!\n");
+				of_node_put(child);
 				return -ENODEV;
 			}
 			/* phy-handle is missing, but fixed-link isn't.
-- 
2.19.1

