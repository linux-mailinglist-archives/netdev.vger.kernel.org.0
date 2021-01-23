Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13173016C2
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbhAWQVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:21:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24607 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbhAWQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611418891; x=1642954891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fIQDl2lqrznWxU4zPJMR/Sa1BQ5hWGWeH15FBPjjRa4=;
  b=Od3rgEbZTBDqFzyuaSwMeI3azXMFQB5Ln4cqjL4Ju4EMdtrOMmEl7BAg
   NFJAlWeiQ+2A18BKMQuvC7ZZhoE4Ch/UO1h9CVakMXlV+ResTpPAZFTeY
   PLMvomwEjAy0ZrW+9uqi/I8k4uBV1oYbd6pxnR26JtTss/qK31xKXHIx/
   BQuG0yhEbXsQaBpHPGtKJGJD71h8J4gry0KARYxNNNBzg1J5TsNtP7O0S
   L0mvA8io3DrpP59izFsmSqSO0Tw+hV953WjFvLb2HhcPsFNreWKPRDYxH
   rVEKdA592xuj9VmvfAulDYa/ThJARHJw2ERJkQthExikOYKk95aT91MSm
   w==;
IronPort-SDR: hu1S7pmrmQQQo4gKcabhAGrK/cKnS9BOqhRyVzg+guND5/5TeHjBOMTndMF46abR26B/dszAJq
 e3wgqiyFx3aLiaa4qC3+0furu7O7k9pFCBF/7TQ5/Gppy30QnYbI781wL90GSNA094fGqfq2/I
 /5DiaflnWeYbCz3rfKCLcisUBpeIQbWcy+cZ7Or09nLrysTCRJisdbq342mGJmIEdq984IJOO+
 OoOcf3abrksdVhQTTe6lW/mGsvHAbdKASMba8Nvp4dTDO3RP9i9jAc29qNkR/wfHItmPay/sVt
 j18=
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="101164379"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2021 09:19:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 23 Jan 2021 09:19:59 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 23 Jan 2021 09:19:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/4] bridge: mrp: Update br_mrp to use new return values of br_mrp_switchdev
Date:   Sat, 23 Jan 2021 17:18:12 +0100
Message-ID: <20210123161812.1043345-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
References: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the return values of the br_mrp_switchdev function.
In case of:
- BR_MRP_NONE, return the error to userspace,
- BR_MRP_SW, continue with SW implemtation
- BR_MRP_HW, continue without SW implemtation.

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

