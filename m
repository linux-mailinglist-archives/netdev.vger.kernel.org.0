Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604602F932E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbhAQPBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:01:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45147 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729115AbhAQPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:01:05 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 17 Jan 2021 17:00:15 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10HF0F7D029614;
        Sun, 17 Jan 2021 17:00:15 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 2/8] net/bonding: Take IP hash logic into a helper
Date:   Sun, 17 Jan 2021 16:59:43 +0200
Message-Id: <20210117145949.8632-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210117145949.8632-1-tariqt@nvidia.com>
References: <20210117145949.8632-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hash logic on L3 will be used in a downstream patch for one more use
case.
Take it to a function for a better code reuse.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ad5192ee1845..759ad22b7279 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3541,6 +3541,16 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 	return true;
 }
 
+static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
+{
+	hash ^= (__force u32)flow_get_u32_dst(flow) ^
+		(__force u32)flow_get_u32_src(flow);
+	hash ^= (hash >> 16);
+	hash ^= (hash >> 8);
+	/* discard lowest hash bit to deal with the common even ports pattern */
+	return hash >> 1;
+}
+
 /**
  * bond_xmit_hash - generate a hash value based on the xmit policy
  * @bond: bonding device
@@ -3571,12 +3581,8 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 		else
 			memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	}
-	hash ^= (__force u32)flow_get_u32_dst(&flow) ^
-		(__force u32)flow_get_u32_src(&flow);
-	hash ^= (hash >> 16);
-	hash ^= (hash >> 8);
 
-	return hash >> 1;
+	return bond_ip_hash(hash, &flow);
 }
 
 /*-------------------------- Device entry points ----------------------------*/
-- 
2.21.0

