Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909E816A6F7
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgBXNJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34949 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBXNJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id w12so10323390wrt.2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Uz/eEXKpHtFspqpag++UbAN6+IZHU4paQXO5ZhiOoO8=;
        b=rSkCBZKrM8QcOsFN9AyJu04yQtbO/J+1AbQ6mRYQnMZ8MVYfyAp1T50PK7viE6fEnW
         dITsxxVg5OL1n6MnPlOHNTE4jayb4e1aPZzhrYSjz8PNNIQYQMCTPeY2BjOSBdfUOY5x
         Lb49IyllWuRuZAwxldP0/2ILMhbU4C9Q2wMvVFl6PVgWcJDG6JEypvkeH6b5LVthJtqi
         66gtyFF9BZAd5QChF+uPxkOTH2K2VxcFMSIUYl7Anl93yz3gRzChYfAJGjbszDWNP36F
         z7bt2Bf/7QCeEPWpYeWGxOAGPynZ6Xz6vt0e0oblb5aajUiCA7PFGABfe4jZh59Z+tJA
         DhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Uz/eEXKpHtFspqpag++UbAN6+IZHU4paQXO5ZhiOoO8=;
        b=uKzJFfiNUkkFJpIvdJn76SVYPxTOdm4pbGKtgokwHKCKf/zL55Q5sYwMzCLLn9WdmU
         4fFN0c3NMKV4NAiwjRqX7LVJ4dkUgheudVjqkeH50TO8Rto7lukbB6GU1Gmf/OuvhCk1
         CABeXJpxbLfZXvdHOYnSkA8Jx7/jlH/F3Dmn9A2wTt+S4BwEwAanHv67XRP5UV6LmtKz
         9CPpNTMTcpxZvXeWGW2h03R7+x8HdgIbIVHZ6VsYu/1Wdx3cHmwuCVJllQC2tleJJ987
         i80aA6oN3BWgJJJ6j++O+/bzVatZm/YeztLAFlC4TNehJgkGafxQKct6fUy+oWjV3zXe
         JN5w==
X-Gm-Message-State: APjAAAWdOVlpzBReoW2bUZgYjAplh9NzCp3A46Jd0TagXaETQB/hp9lu
        SMctSsxJbmi9LKaKgsaa1UxO/ZZ7/tA=
X-Google-Smtp-Source: APXvYqwmHiZb0zA2jSqvoe7zPxLFXHOLs9vEl7/9z6E/e9ZByHy5+lwOiq3MEEhHx5P93w7oxbBAuw==
X-Received: by 2002:a5d:4709:: with SMTP id y9mr66838128wrq.412.1582549761397;
        Mon, 24 Feb 2020 05:09:21 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 04/10] net: mscc: ocelot: return directly in ocelot_cls_flower_{replace,destroy}
Date:   Mon, 24 Feb 2020 15:08:25 +0200
Message-Id: <20200224130831.25347-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no need to check the "ret" variable, one can just return the
function result back to the caller.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 698e9fee6b1a..8993dadf063c 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -192,11 +192,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return ret;
 	}
 
-	ret = ocelot_ace_rule_offload_add(ocelot, ace);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ocelot_ace_rule_offload_add(ocelot, ace);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
@@ -204,16 +200,11 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule ace;
-	int ret;
 
 	ace.prio = f->common.prio;
 	ace.id = f->cookie;
 
-	ret = ocelot_ace_rule_offload_del(ocelot, &ace);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ocelot_ace_rule_offload_del(ocelot, &ace);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
-- 
2.17.1

