Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54717276AD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEWHE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:04:27 -0400
Received: from david.siemens.de ([192.35.17.14]:53130 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfEWHE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 03:04:27 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id x4N74DYI003735
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 09:04:13 +0200
Received: from pluscontrol-debian-server.ppmd.SIEMENS.NET (pluscontrol-debian-server.ppmd.siemens.net [146.254.63.6])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id x4N74A5C013555;
        Thu, 23 May 2019 09:04:10 +0200
From:   Andreas Oetken <andreas.oetken@siemens.com>
Cc:     andreas@oetken.name, m-karicheri2@ti.com, a-kramer@ti.com,
        Andreas Oetken <andreas.oetken@siemens.com>,
        Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3] hsr: fix don't prune the master node from the node_db
Date:   Thu, 23 May 2019 09:02:37 +0200
Message-Id: <20190523070238.17560-1-andreas.oetken@siemens.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't prune master node in the hsr_prune_nodes function.
Neither time_in[HSR_PT_SLAVE_A], nor time_in[HSR_PT_SLAVE_B],
will ever be updated by hsr_register_frame_in for the master port.
Thus the master node will be repeatedly pruned leading to
repeated packet loss.
This bug never appeared because the hsr_prune_nodes function
was only called once. Since commit 5150b45fd355
("net: hsr: Fix node prune function for forget time expiry") this issue
is fixed unvealing the issue described above.

Fixes: 5150b45fd355 ("net: hsr: Fix node prune function for forget time expiry")
Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
Tested-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_framereg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 9fa9abd83018..2d7a19750436 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -365,6 +365,14 @@ void hsr_prune_nodes(struct timer_list *t)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(node, &hsr->node_db, mac_list) {
+		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
+		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
+		 * the master port. Thus the master node will be repeatedly
+		 * pruned leading to packet loss.
+		 */
+		if (hsr_addr_is_self(hsr, node->macaddress_A))
+			continue;
+
 		/* Shorthand */
 		time_a = node->time_in[HSR_PT_SLAVE_A];
 		time_b = node->time_in[HSR_PT_SLAVE_B];
-- 
2.20.1

