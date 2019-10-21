Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C42DF71D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfJUUwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:52:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43973 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730512AbfJUUv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:57 -0400
Received: by mail-qt1-f196.google.com with SMTP id t20so23303748qtr.10;
        Mon, 21 Oct 2019 13:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OoBa2UuF6l2BUY5eIYmAWMJW5SOqVBTZrftuRAjOzXg=;
        b=O7X+H/aZzciqsx8EG54Z0p6tYDqNZ2zoM+OiWgiiC6qUyt/8gf/IV4ZbEGKUT2nHJ5
         igMOMgs/pSheaukxYRum/rH1yjjNWP5yst9ChhHs/VivfhThce0gKObEf0Ou5N+fjbVp
         d1R0h/4V50WmrjanO8D6bYdSueqK5JaDC/RN3M9xhQclWE3SJTXrZYpi4FvLfISuX/A1
         b3QPSdUXr8Lc+dCI2FrxfGGpA3ONEHQtO0WqiYI22cqr50pUieFq59ITz3sFSuMhZrem
         mIOn/I1/3mubDsL6D7ZJL52mR4CWkfFyrQawdyb6d3leXZrn8BiwGRHljY4nRNoxM8LU
         VWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OoBa2UuF6l2BUY5eIYmAWMJW5SOqVBTZrftuRAjOzXg=;
        b=P3lkHjpQ643V/SpF5nzxzkZ0Rj1tgpV9BJHTFQkZ7iFrOo/sEwhwRY4x5e2P+kU021
         lnhfoIrEJfZzLfvcrq/8IjqFG3aIdYl1P8umDz7zlJBuApnlr7EFMwK+WFOlywTMuJV5
         a67o4bbRpMlu+wVebKIc6g34o9aYqCphjtP3RcUg5lhvLX3qYFRcgIF7qWKj/Qly0koZ
         bCVitJvlATxW2ZLmNwxEBwNQDp59fEDwmZthI6btV6eT8ivn9XwkXTg/mhuOzPYJmBN8
         e5TgWfJu+ftBdPyGwOgg5PPYGVNfEEPYyu8aoxfaBzV20vbsPGqXVXeJB4L6gfXWWzh/
         7cJw==
X-Gm-Message-State: APjAAAUsoYwrKLcZn3tBTlVX+uM9V9j7sN4wcBOshOodPPlI85uEcuB8
        uG1Xdv/H8RitD9KbplaZT14=
X-Google-Smtp-Source: APXvYqwe+0z/2FkXkcb/57bpm7dlyAGJ9kC2R2KQtnBIrbqjhzO/JhOxUzJ6fVOiseXvXhpemJ9R1w==
X-Received: by 2002:aed:29c7:: with SMTP id o65mr3484303qtd.266.1571691116267;
        Mon, 21 Oct 2019 13:51:56 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t65sm8172592qkh.23.2019.10.21.13.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:55 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 13/16] net: dsa: mv88e6xxx: use ports list to map bridge
Date:   Mon, 21 Oct 2019 16:51:27 -0400
Message-Id: <20191021205130.304149-14-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of digging into the other dsa_switch structures of the fabric
and relying too much on the dsa_to_port helper, use the new list
of switch fabric ports to remap the Port VLAN Map of local bridge
group members or remap the Port VLAN Table entry of external bridge
group members.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 39 +++++++++++++++-----------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index af8943142053..826ae82ed727 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2043,29 +2043,26 @@ static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
 static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 				struct net_device *br)
 {
-	struct dsa_switch *ds;
-	int port;
-	int dev;
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
 	int err;
 
-	/* Remap the Port VLAN of each local bridge group member */
-	for (port = 0; port < mv88e6xxx_num_ports(chip); ++port) {
-		if (dsa_to_port(chip->ds, port)->bridge_dev == br) {
-			err = mv88e6xxx_port_vlan_map(chip, port);
-			if (err)
-				return err;
-		}
-	}
-
-	/* Remap the Port VLAN of each cross-chip bridge group member */
-	for (dev = 0; dev < DSA_MAX_SWITCHES; ++dev) {
-		ds = chip->ds->dst->ds[dev];
-		if (!ds)
-			break;
-
-		for (port = 0; port < ds->num_ports; ++port) {
-			if (dsa_to_port(ds, port)->bridge_dev == br) {
-				err = mv88e6xxx_pvt_map(chip, dev, port);
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->bridge_dev == br) {
+			if (dp->ds == ds) {
+				/* This is a local bridge group member,
+				 * remap its Port VLAN Map.
+				 */
+				err = mv88e6xxx_port_vlan_map(chip, dp->index);
+				if (err)
+					return err;
+			} else {
+				/* This is an external bridge group member,
+				 * remap its cross-chip Port VLAN Table entry.
+				 */
+				err = mv88e6xxx_pvt_map(chip, dp->ds->index,
+							dp->index);
 				if (err)
 					return err;
 			}
-- 
2.23.0

