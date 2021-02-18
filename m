Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF71131ED60
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhBRRd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:33:28 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:50834 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhBRPDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 10:03:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id C7799380537;
        Thu, 18 Feb 2021 16:01:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mYqigv7O4NS2; Thu, 18 Feb 2021 16:01:46 +0100 (CET)
Received: from localhost.localdomain (unknown [188.194.194.169])
        (Authenticated sender: marco.wenzel@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPA;
        Thu, 18 Feb 2021 16:01:46 +0100 (CET)
From:   Marco Wenzel <marco.wenzel@a-eberle.de>
To:     george.mccollister@gmail.com
Cc:     Marco Wenzel <marco.wenzel@a-eberle.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Amol Grover <frextrite@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Arvid Brodin <Arvid.Brodin@xdin.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: hsr: add support for EntryForgetTime
Date:   Thu, 18 Feb 2021 16:01:12 +0100
Message-Id: <20210218150116.1521-1-marco.wenzel@a-eberle.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <CAFSKS=Ncr-9s1Oi0GTqQ74sUaDjoHR-1P-yM+rNqjF-Hb+cPCA@mail.gmail.com>
References: <CAFSKS=Ncr-9s1Oi0GTqQ74sUaDjoHR-1P-yM+rNqjF-Hb+cPCA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
node does not send any frame within this time, the sequence number check
for can be ignored. This solves communication issues with Cisco IE 2000
in Redbox mode.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
---
 net/hsr/hsr_framereg.c | 9 +++++++--
 net/hsr/hsr_framereg.h | 1 +
 net/hsr/hsr_main.h     | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 5c97de459905..805f974923b9 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 	 * as initialization. (0 could trigger an spurious ring error warning).
 	 */
 	now = jiffies;
-	for (i = 0; i < HSR_PT_PORTS; i++)
+	for (i = 0; i < HSR_PT_PORTS; i++) {
 		new_node->time_in[i] = now;
+		new_node->time_out[i] = now;
+	}
 	for (i = 0; i < HSR_PT_PORTS; i++)
 		new_node->seq_out[i] = seq_out;
 
@@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 			   u16 sequence_nr)
 {
-	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
+	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
+	    time_is_after_jiffies(node->time_out[port->type] +
+	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
 		return 1;
 
+	node->time_out[port->type] = jiffies;
 	node->seq_out[port->type] = sequence_nr;
 	return 0;
 }
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index 86b43f539f2c..d9628e7a5f05 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -75,6 +75,7 @@ struct hsr_node {
 	enum hsr_port_type	addr_B_port;
 	unsigned long		time_in[HSR_PT_PORTS];
 	bool			time_in_stale[HSR_PT_PORTS];
+	unsigned long		time_out[HSR_PT_PORTS];
 	/* if the node is a SAN */
 	bool			san_a;
 	bool			san_b;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 7dc92ce5a134..f79ca55d6986 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -21,6 +21,7 @@
 #define HSR_LIFE_CHECK_INTERVAL		 2000 /* ms */
 #define HSR_NODE_FORGET_TIME		60000 /* ms */
 #define HSR_ANNOUNCE_INTERVAL		  100 /* ms */
+#define HSR_ENTRY_FORGET_TIME		  400 /* ms */
 
 /* By how much may slave1 and slave2 timestamps of latest received frame from
  * each node differ before we notify of communication problem?
-- 
2.30.0

