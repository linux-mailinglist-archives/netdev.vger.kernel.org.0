Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902771428E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfEEViR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:38:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56681 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEViR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:38:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hNOpq-0008GD-Hz; Sun, 05 May 2019 21:38:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: mvpp2: cls: fix less than zero check on a u32 variable
Date:   Sun,  5 May 2019 22:38:14 +0100
Message-Id: <20190505213814.4220-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The signed return from the call to mvpp2_cls_c2_port_flow_index is being
assigned to the u32 variable c2.index and then checked for a negative
error condition which is always going to be false. Fix this by assigning
the return to the int variable index and checking this instead.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 4989fb13244f..c10bc257f571 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1029,12 +1029,14 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 	struct flow_action_entry *act;
 	struct mvpp2_cls_c2_entry c2;
 	u8 qh, ql, pmap;
+	int index;
 
 	memset(&c2, 0, sizeof(c2));
 
-	c2.index = mvpp2_cls_c2_port_flow_index(port, rule->loc);
-	if (c2.index < 0)
+	index = mvpp2_cls_c2_port_flow_index(port, rule->loc);
+	if (index < 0)
 		return -EINVAL;
+	c2.index = index;
 
 	act = &rule->flow->action.entries[0];
 
-- 
2.20.1

