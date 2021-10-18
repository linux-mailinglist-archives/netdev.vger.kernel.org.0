Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75636432813
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhJRUBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:01:16 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:57472 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhJRUBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:01:16 -0400
Received: from pop-os.home ([92.140.161.106])
        by smtp.orange.fr with ESMTPA
        id cYmjmZbOF1UGBcYmjmpGaS; Mon, 18 Oct 2021 21:59:03 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 18 Oct 2021 21:59:03 +0200
X-ME-IP: 92.140.161.106
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: dsa: Fix an error handling path in 'dsa_switch_parse_ports_of()'
Date:   Mon, 18 Oct 2021 21:59:00 +0200
Message-Id: <15d5310d1d55ad51c1af80775865306d92432e03.1634587046.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we return before the end of the 'for_each_child_of_node()' iterator, the
reference taken on 'port' must be released.

Add the missing 'of_node_put()' calls.

Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/dsa/dsa2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 691d27498b24..6ffd2928d2a6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1367,12 +1367,15 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 
 	for_each_available_child_of_node(ports, port) {
 		err = of_property_read_u32(port, "reg", &reg);
-		if (err)
+		if (err) {
+			of_node_put(port);
 			goto out_put_node;
+		}
 
 		if (reg >= ds->num_ports) {
 			dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%zu)\n",
 				port, reg, ds->num_ports);
+			of_node_put(port);
 			err = -EINVAL;
 			goto out_put_node;
 		}
@@ -1380,8 +1383,10 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 		dp = dsa_to_port(ds, reg);
 
 		err = dsa_port_parse_of(dp, port);
-		if (err)
+		if (err) {
+			of_node_put(port);
 			goto out_put_node;
+		}
 	}
 
 out_put_node:
-- 
2.30.2

