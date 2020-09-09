Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7E4262CD0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgIIKEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIIKEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:04:36 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E4C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 03:04:36 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s12so2248580wrw.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 03:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bST50jPUwwDbLj27TviEZuypDFBCzjiM5n9VtcnbuZM=;
        b=UHT9gTAgpBxTv3X6pgQVeGk+imoZE95jfZsjtisjtSpTfnVQoNE41s3zQUMjkG68HG
         YXu5brpRIMCOOJNGHZ9aF2xfjR8P+TMrhAmWzD9BWpnmA9jfgdktLtTvo+dWm81fImGv
         l2AdpwnNK1ecOpbRuOt02/qOe69SLhfvTByTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bST50jPUwwDbLj27TviEZuypDFBCzjiM5n9VtcnbuZM=;
        b=r5h8w7kT/zH41EIXfrR7wLYsKDNP5qrdpqvu3Wm89At+c32zCwOc0b2CZV7XbHumIw
         0y18MwPi0Lhk+/s8BZ74LzYNINkEx5FXzOfBas9TF762DWNQwBVWoL4arqaSb4xMsxWa
         Zd5GKJekKnB8NlCiFqkQdzZ6nd7aDAB5sq4kYPhGNNSrTLV+wMBm8PZmR891+GRgiJL/
         Jn1lGLGsD5OafHoygyBeDyXVDVHkFFReTqnDU0XkoP2ReZNxb0K8626o5DSDBfMo88D1
         ZL0ZUg8qtW6WSByIFEW+mr/utiL4OTlwJ7soTNkmQCIJ456JncnqkPYg2KkfcrqqSpDZ
         46CQ==
X-Gm-Message-State: AOAM532rpkBkWe5V1vBq/GkzAI4UnY9YyjY/bVHXaBfnTozewjPhbYlJ
        EX1KIr5PXMbzrYXVE7P+XoeZ+g==
X-Google-Smtp-Source: ABdhPJys3pAB4tPYiZdEm8+rygJLQR60Yww4bsCJ7vS0G5oCcUokF7jYzM423STnuq8saYzv5p1fpg==
X-Received: by 2002:adf:f0c3:: with SMTP id x3mr2968847wro.163.1599645875045;
        Wed, 09 Sep 2020 03:04:35 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id l16sm3828237wrb.70.2020.09.09.03.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:04:34 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v3 2/4] net: dsa: microchip: Improve phy mode message
Date:   Wed,  9 Sep 2020 11:04:15 +0100
Message-Id: <20200909100417.380011-3-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909100417.380011-1-pbarker@konsulko.com>
References: <20200909100417.380011-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always print the selected phy mode for the CPU port when using the
ksz9477 driver. If the phy mode was changed, also print the previous
mode to aid in debugging.

To make the message more clear, prefix it with the port number which it
applies to and improve the language a little.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index df5ecd0261fa..d9030820f406 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1265,6 +1265,8 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	for (i = 0; i < dev->port_cnt; i++) {
 		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
 			phy_interface_t interface;
+			const char *prev_msg;
+			const char *prev_mode;
 
 			dev->cpu_port = i;
 			dev->host_mask = (1 << dev->cpu_port);
@@ -1277,11 +1279,19 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			interface = ksz9477_get_interface(dev, i);
 			if (!dev->interface)
 				dev->interface = interface;
-			if (interface && interface != dev->interface)
-				dev_info(dev->dev,
-					 "use %s instead of %s\n",
-					  phy_modes(dev->interface),
-					  phy_modes(interface));
+			if (interface && interface != dev->interface) {
+				prev_msg = " instead of ";
+				prev_mode = phy_modes(interface);
+			} else {
+				prev_msg = "";
+				prev_mode = "";
+			}
+			dev_info(dev->dev,
+				 "Port%d: using phy mode %s%s%s\n",
+				 i,
+				 phy_modes(dev->interface),
+				 prev_msg,
+				 prev_mode);
 
 			/* enable cpu port */
 			ksz9477_port_setup(dev, i, true);
-- 
2.28.0

