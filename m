Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD87DDC04
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfJTDU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39973 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfJTDUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id o49so7425434qta.7;
        Sat, 19 Oct 2019 20:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=26k3vUGxc4Dmo2A3RVIp5XpAiCxIydcEFhiw0cNY70Y=;
        b=N2tHpXkb2yZcMhGzIzl/9PMRKxEij56DvVhSap2AgHGLygrun4APPzk7yz4aCTopRh
         0AWhfvmEVwsgTvnetHx7zBW/kUp4Gijr3d4vkrpj82/26qM+NEH0q7Ryr0TxDebmL35L
         27twtzIiN2IqCkTIrHE7PEjEVfH8ayi20pQhthwfk36cWD5muNtBfbQUmr10OKGbITJQ
         +BFrfX9xWBds4gdT5hWR/6UdsLtHX9YcGmDURoZu/kEwTXJi2BCMjr6GsuBSP9+Y6n2g
         Oc/WS5nTdxStHu+E8XLhKTxDqKOVpY7sZyOxlrQ0VimdlLL+hCvRDdoSpYprArKFZBPS
         xYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=26k3vUGxc4Dmo2A3RVIp5XpAiCxIydcEFhiw0cNY70Y=;
        b=R35dJ94jZY4/gwStRvnWZX8WASReRdCF/691uh1jT5aY2IOWVttpcJgmiiQI0+vcl1
         FRViToh3HI9OZ18HH6MsjDnA1Ji/ANIkW7w48Wd2vunsdiOhOhjoywYzv5bjOSTMxmiY
         Bq3BpTLoU/0X5ehTUW+fyY5/e8iFDFQi2goc3BKS0wkwFP9TA7CHfP9FnEaQpErtLelH
         S22YSo2FubJZWhwMLdEkwPG4Si9IQ1N3SAx6pXEA97RoLxw0iNv4SIUovfZnaapnQxnD
         uF50Vsvn7kyioaQ9z6UT/DG/aehwUu5JeSUIRPLm5J5RlT1JhNo5sV3BPTZKnk/JnZzQ
         NhDw==
X-Gm-Message-State: APjAAAXWMgR470SWWAv+uIxRUYrm7jTiclKsfwCAAc9FuBKeI4Ln9diy
        aBxuXVcQopuvAQCNC/BOWwRLTsc9
X-Google-Smtp-Source: APXvYqzHGRmoYJ6mIiATOEdNj+mUTr3dysbIg52zyzPn9YK0tYZnQQLP5w8F2qeC8RDTgN1NX9ubAw==
X-Received: by 2002:ac8:28e3:: with SMTP id j32mr13450297qtj.212.1571541623952;
        Sat, 19 Oct 2019 20:20:23 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q25sm4904054qtr.25.2019.10.19.20.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:23 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 12/16] net: dsa: mv88e6xxx: use ports list to map port VLAN
Date:   Sat, 19 Oct 2019 23:19:37 -0400
Message-Id: <20191020031941.3805884-13-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of digging into the other dsa_switch structures of the fabric
and relying too much on the dsa_to_port helper, use the new list of
switch fabric ports to define the mask of the local ports allowed to
receive frames from another port of the fabric.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 510ccdc2d03c..af8943142053 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1057,35 +1057,43 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+/* Mask of the local ports allowed to receive frames from a given fabric port */
 static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
-	struct dsa_switch *ds = NULL;
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_switch_tree *dst = ds->dst;
 	struct net_device *br;
+	struct dsa_port *dp;
+	bool found = false;
 	u16 pvlan;
-	int i;
 
-	if (dev < DSA_MAX_SWITCHES)
-		ds = chip->ds->dst->ds[dev];
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->index == dev && dp->index == port) {
+			found = true;
+			break;
+		}
+	}
 
 	/* Prevent frames from unknown switch or port */
-	if (!ds || port >= ds->num_ports)
+	if (!found)
 		return 0;
 
 	/* Frames from DSA links and CPU ports can egress any local port */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
 		return mv88e6xxx_port_mask(chip);
 
-	br = dsa_to_port(ds, port)->bridge_dev;
+	br = dp->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
 	 * as well as any local member of their bridge group.
 	 */
-	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
-		if (dsa_is_cpu_port(chip->ds, i) ||
-		    dsa_is_dsa_port(chip->ds, i) ||
-		    (br && dsa_to_port(chip->ds, i)->bridge_dev == br))
-			pvlan |= BIT(i);
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds == ds &&
+		    (dp->type == DSA_PORT_TYPE_CPU ||
+		     dp->type == DSA_PORT_TYPE_DSA ||
+		     (br && dp->bridge_dev == br)))
+			pvlan |= BIT(dp->index);
 
 	return pvlan;
 }
-- 
2.23.0

