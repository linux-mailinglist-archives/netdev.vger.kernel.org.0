Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A7F2F68CB
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbhANSCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:02:47 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57103 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729676AbhANSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:02:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 14 Jan 2021 20:01:51 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EI1pYK001704;
        Thu, 14 Jan 2021 20:01:51 +0200
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
Subject: [PATCH net-next V2 2/8] net/bonding: Take IP hash logic into a helper
Date:   Thu, 14 Jan 2021 20:01:29 +0200
Message-Id: <20210114180135.11556-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210114180135.11556-1-tariqt@nvidia.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
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
index 5fe5232cc3f3..8bc7629a2805 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3539,6 +3539,16 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
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
@@ -3569,12 +3579,8 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
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

