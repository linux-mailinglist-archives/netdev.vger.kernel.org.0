Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73A30657C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhA0U4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:56:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17352 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhA0U4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611780967; x=1643316967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lqPm3w8R6W+6/EKBHQZN4ymXoXRvTekFol5Yx69SaXk=;
  b=izKweRADdm7ibk44TwW8Ve/MOpaHZ5JpR+A3iSU2N8nR/gkgPLLrxFbr
   2giSZpop2acbQoFA/qX95lvNXkrxcTiRF+weyS1bbMJ9L9n1f3/NFzzpK
   HOnJpnJJYeoT5YIAW5VrKbkjkW51fQKJ+2sQlEKpbamK1icM1F5ovV1V4
   VktWJMsoiJhsN9Rl3ZQuwED51MadXYyN7bkglCOTpZwSVq2GV2tgwxv46
   o73py3ONr4kjnwahC9XJ++6VZlSxq1FpmlF54u/ehjxh7HFMZXaDsQ57j
   L6EAGMXPmxuPcASGPZI/vFeivn7TGryFMQrfOdfCl15DymDGi00QFkN+7
   g==;
IronPort-SDR: C8SDGbPGgqNkojSPzdsNfQMQm8AhjxlmUil+dXh4t/XISN3NlGvfo0fNpJiZjxUUHS9qJQyUFK
 7dI7/s5BODfkD35MtRhvavOx9agc6p1YbVreDjMVQ+buXCZUgJyApsXwkn/q++FtuWa2zybz9m
 LIIGx3IkqZ01NOxEiKHNnzl8GMcrqEdn9Q5KgCg+cUOtZ4i9w7QZJ0HWyzlAnBH9bzaxEOAj2C
 p3HGNxFfMcW56HOjnl0lG9s5xPLNJQeR519LFXp6Dxpp2XK5vykhIyHD3PTb/cRywKapGByWfy
 32E=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="107543338"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 13:54:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 13:54:09 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 13:54:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 4/4] bridge: mrp: Update br_mrp to use new return values of br_mrp_switchdev
Date:   Wed, 27 Jan 2021 21:52:41 +0100
Message-ID: <20210127205241.2864728-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the return values of the br_mrp_switchdev function.
In case of:
- BR_MRP_NONE, return the error to userspace,
- BR_MRP_SW, continue with SW implementation,
- BR_MRP_HW, continue without SW implementation,

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index fc0a98874bfc..faa4ccb20f0a 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -636,7 +636,7 @@ int br_mrp_set_ring_role(struct net_bridge *br,
 			 struct br_mrp_ring_role *role)
 {
 	struct br_mrp *mrp = br_mrp_find_id(br, role->ring_id);
-	int err;
+	enum br_mrp_hw_support support;
 
 	if (!mrp)
 		return -EINVAL;
@@ -644,9 +644,9 @@ int br_mrp_set_ring_role(struct net_bridge *br,
 	mrp->ring_role = role->ring_role;
 
 	/* If there is an error just bailed out */
-	err = br_mrp_switchdev_set_ring_role(br, mrp, role->ring_role);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	support = br_mrp_switchdev_set_ring_role(br, mrp, role->ring_role);
+	if (support == BR_MRP_NONE)
+		return -EOPNOTSUPP;
 
 	/* Now detect if the HW actually applied the role or not. If the HW
 	 * applied the role it means that the SW will not to do those operations
@@ -654,7 +654,7 @@ int br_mrp_set_ring_role(struct net_bridge *br,
 	 * SW when ring is open, but if the is not pushed to the HW the SW will
 	 * need to detect when the ring is open
 	 */
-	mrp->ring_role_offloaded = err == -EOPNOTSUPP ? 0 : 1;
+	mrp->ring_role_offloaded = support == BR_MRP_SW ? 0 : 1;
 
 	return 0;
 }
@@ -667,6 +667,7 @@ int br_mrp_start_test(struct net_bridge *br,
 		      struct br_mrp_start_test *test)
 {
 	struct br_mrp *mrp = br_mrp_find_id(br, test->ring_id);
+	enum br_mrp_hw_support support;
 
 	if (!mrp)
 		return -EINVAL;
@@ -674,9 +675,13 @@ int br_mrp_start_test(struct net_bridge *br,
 	/* Try to push it to the HW and if it fails then continue with SW
 	 * implementation and if that also fails then return error.
 	 */
-	if (!br_mrp_switchdev_send_ring_test(br, mrp, test->interval,
-					     test->max_miss, test->period,
-					     test->monitor))
+	support = br_mrp_switchdev_send_ring_test(br, mrp, test->interval,
+						  test->max_miss, test->period,
+						  test->monitor);
+	if (support == BR_MRP_NONE)
+		return -EOPNOTSUPP;
+
+	if (support == BR_MRP_HW)
 		return 0;
 
 	mrp->test_interval = test->interval;
@@ -718,8 +723,8 @@ int br_mrp_set_in_state(struct net_bridge *br, struct br_mrp_in_state *state)
 int br_mrp_set_in_role(struct net_bridge *br, struct br_mrp_in_role *role)
 {
 	struct br_mrp *mrp = br_mrp_find_id(br, role->ring_id);
+	enum br_mrp_hw_support support;
 	struct net_bridge_port *p;
-	int err;
 
 	if (!mrp)
 		return -EINVAL;
@@ -777,10 +782,10 @@ int br_mrp_set_in_role(struct net_bridge *br, struct br_mrp_in_role *role)
 	mrp->in_id = role->in_id;
 
 	/* If there is an error just bailed out */
-	err = br_mrp_switchdev_set_in_role(br, mrp, role->in_id,
-					   role->ring_id, role->in_role);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	support = br_mrp_switchdev_set_in_role(br, mrp, role->in_id,
+					       role->ring_id, role->in_role);
+	if (support == BR_MRP_NONE)
+		return -EOPNOTSUPP;
 
 	/* Now detect if the HW actually applied the role or not. If the HW
 	 * applied the role it means that the SW will not to do those operations
@@ -788,7 +793,7 @@ int br_mrp_set_in_role(struct net_bridge *br, struct br_mrp_in_role *role)
 	 * SW when interconnect ring is open, but if the is not pushed to the HW
 	 * the SW will need to detect when the interconnect ring is open.
 	 */
-	mrp->in_role_offloaded = err == -EOPNOTSUPP ? 0 : 1;
+	mrp->in_role_offloaded = support == BR_MRP_SW ? 0 : 1;
 
 	return 0;
 }
@@ -801,6 +806,7 @@ int br_mrp_start_in_test(struct net_bridge *br,
 			 struct br_mrp_start_in_test *in_test)
 {
 	struct br_mrp *mrp = br_mrp_find_in_id(br, in_test->in_id);
+	enum br_mrp_hw_support support;
 
 	if (!mrp)
 		return -EINVAL;
@@ -811,8 +817,13 @@ int br_mrp_start_in_test(struct net_bridge *br,
 	/* Try to push it to the HW and if it fails then continue with SW
 	 * implementation and if that also fails then return error.
 	 */
-	if (!br_mrp_switchdev_send_in_test(br, mrp, in_test->interval,
-					   in_test->max_miss, in_test->period))
+	support =  br_mrp_switchdev_send_in_test(br, mrp, in_test->interval,
+						 in_test->max_miss,
+						 in_test->period);
+	if (support == BR_MRP_NONE)
+		return -EOPNOTSUPP;
+
+	if (support == BR_MRP_HW)
 		return 0;
 
 	mrp->in_test_interval = in_test->interval;
-- 
2.27.0

