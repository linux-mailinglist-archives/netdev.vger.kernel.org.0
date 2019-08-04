Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F3E80B75
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfHDPad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:30:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43710 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDPad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:30:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so28461037pld.10
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kswpq4oRjXHEwG4tmBWysxjOdQd+zi6OboQ/D2k4nU=;
        b=PausHQcDuRzpVpp9w4S0tlMtFbnTbHbB3x1tdxN5ywiyu+mb5RMRjlDmiT6U2ElHYF
         rm57QrBO+BZbKwnpLEmZyoXzVn2OvdfSvkEF1+PFeT6Vqjwv7WvL0HdLXBc+2emM+6e7
         LU/vr6ylfndok1pAiozZIF+7p725au1w/wDRVGoOfUMOZ7HXjRkxf5Xx7iXzP8mzTkEf
         Px9XDsTJry+1DdnjWfH1YTRCDlH6sKgzNLT00eHkfiewx1D5b71rJP6U6iPfYw+xbWk8
         mijjQMGtEoz1qbI+Kmq5ClQN/NDpBjN45c1srsK8lkX8p0mSb6WCTNV7Lzn3/IOb/nJR
         JEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kswpq4oRjXHEwG4tmBWysxjOdQd+zi6OboQ/D2k4nU=;
        b=VEPcm22xSiP4+FhMBvyWD00z46BOSzDXVWourxgk+LsxvDeH0CMLI4eyKSP7UBsJ+3
         cPcYFXMvNe+X6NEAbEd1WXAgJiKWYctT7h1RucNqB5mzGOhtcPVSdptOnZ4I+GZNnF3C
         RPnAGe7rbhE1RQm6YETA/OPnQhhZ4KlrP9AfxTA7uI+bZpGhujh5b3XmbFfowfOxFbDc
         GLcGj55/UgknFGyW/2FfQh+Phf4c7kYoKWGWxbsU4gGkIGeMSOhikP+3hhT3OAARnxQy
         AtGcbgc9UTWtsvc+dkFMCfTSwEXYxdjE9f0umxTJNqJTAPKqESy+e1YuNXjg/cstz2nh
         qkfw==
X-Gm-Message-State: APjAAAU793qEe1dodIYarywYbLqL5rJtwIT4yRWeVZYKOPjBgmDsZxjS
        +qgKmUSHVhqcVDD5r8207C8=
X-Google-Smtp-Source: APXvYqwLd11YvZJmySuRNU4QnVCkeEmnzkIdGN2ALcmOodzxJ9UvMuF2/XoR7NdMZrcXHGkmYoLDPw==
X-Received: by 2002:a17:902:1125:: with SMTP id d34mr140581260pla.40.1564932632896;
        Sun, 04 Aug 2019 08:30:32 -0700 (PDT)
Received: from localhost.localdomain ([122.163.105.8])
        by smtp.gmail.com with ESMTPSA id q21sm12200724pgm.39.2019.08.04.08.30.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 08:30:32 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: dsa: qca8k: Add of_node_put() in qca8k_setup_mdio_bus()
Date:   Sun,  4 Aug 2019 21:00:18 +0530
Message-Id: <20190804153019.2317-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each iteration of for_each_available_child_of_node() puts the previous
node, but in the case of a return from the middle of the loop, there
is no put, thus causing a memory leak. Hence add an of_node_put() before
the return.
Additionally, the local variable ports in the function 
qca8k_setup_mdio_bus() takes the return value of of_get_child_by_name(),
which gets a node but does not put it. If the function returns without
putting ports, it may cause a memory leak. Hence put ports before the
mid-loop return statement, and also outside the loop after its last usage
in this function.
Issues found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/dsa/qca8k.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 232e8cc96f6d..87753e4423aa 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -583,8 +583,11 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 
 	for_each_available_child_of_node(ports, port) {
 		err = of_property_read_u32(port, "reg", &reg);
-		if (err)
+		if (err) {
+			of_node_put(port);
+			of_node_put(ports);
 			return err;
+		}
 
 		if (!dsa_is_user_port(priv->ds, reg))
 			continue;
@@ -595,6 +598,7 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 			internal_mdio_mask |= BIT(reg);
 	}
 
+	of_node_put(ports);
 	if (!external_mdio_mask && !internal_mdio_mask) {
 		dev_err(priv->dev, "no PHYs are defined.\n");
 		return -EINVAL;
-- 
2.19.1

