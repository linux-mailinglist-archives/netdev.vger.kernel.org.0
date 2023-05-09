Return-Path: <netdev+bounces-1057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB916FC06D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2B0D281242
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64556AD31;
	Tue,  9 May 2023 07:27:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906813AE1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:27:05 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A2E7AB8;
	Tue,  9 May 2023 00:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683617223; x=1715153223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s3bkE3YNau+vM3HCuNKp78J4YdtiK7cLZ0Se+tibbFY=;
  b=AB++oQdXrz5omROLhwId8e2BxW8szT4xkDEy3YSiwWUFLYDoS1xfu8t5
   tU17H9zw7YeiVFk0I3Ztn7QTAmhzHgO0rs6jqHTIfFfVe0zJdYGsTAoEw
   NKn3tn4xPnl1Q0gPbnAcHsJszOjHPSK4S+65N8d2Ezf5GOS49aNV3rR4j
   oOrb/UR5+CzWQBsH53+JLvhhC996rAu3QWTS1lMwAThhd1SUWLvCMBBP2
   vxQlf6exWlXMFJmwmCMWk8PxO9ncHNzz1RUMN+HRJ+MNYu/vjAw29N7g2
   SGkSJe+ulXmpcvrN6X7GxVw0C+/4uscOaf3aGZAYnaiaEjg8I0yDwJIZW
   g==;
X-IronPort-AV: E=Sophos;i="5.99,261,1677567600"; 
   d="scan'208";a="210306086"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 00:27:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 00:27:01 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 9 May 2023 00:26:59 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lars.povlsen@microchip.com>,
	<Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
	<UNGLinuxDriver@microchip.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/3] net: lan966x: Add TC support for ES0 VCAP
Date: Tue, 9 May 2023 09:26:45 +0200
Message-ID: <20230509072645.3245949-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
References: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Enable the TC command to use the lan966x ES0 VCAP. Currently support
only one action which is vlan pop, other will be added later.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 47b2f7579dd23..96b3def6c4741 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -5,6 +5,8 @@
 #include "vcap_api_client.h"
 #include "vcap_tc.h"
 
+#define LAN966X_FORCE_UNTAGED	3
+
 static bool lan966x_tc_is_known_etype(struct vcap_tc_flower_parse_usage *st,
 				      u16 etype)
 {
@@ -29,6 +31,8 @@ static bool lan966x_tc_is_known_etype(struct vcap_tc_flower_parse_usage *st,
 			return true;
 		}
 		break;
+	case VCAP_TYPE_ES0:
+		return true;
 	default:
 		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
 				   "VCAP type not supported");
@@ -318,6 +322,9 @@ static int lan966x_tc_set_actionset(struct vcap_admin *admin,
 	case VCAP_TYPE_IS2:
 		aset = VCAP_AFS_BASE_TYPE;
 		break;
+	case VCAP_TYPE_ES0:
+		aset = VCAP_AFS_VID;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -353,6 +360,10 @@ static int lan966x_tc_add_rule_link_target(struct vcap_admin *admin,
 		/* Add IS2 specific PAG key (for chaining rules from IS1) */
 		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_PAG,
 					     link_val, ~0);
+	case VCAP_TYPE_ES0:
+		/* Add ES0 specific ISDX key (for chaining rules from IS1) */
+		return vcap_rule_add_key_u32(vrule, VCAP_KF_ISDX_CLS,
+					     link_val, ~0);
 	default:
 		break;
 	}
@@ -389,6 +400,18 @@ static int lan966x_tc_add_rule_link(struct vcap_control *vctrl,
 					       0xff);
 		if (err)
 			return err;
+	} else if (admin->vtype == VCAP_TYPE_IS1 &&
+		   to_admin->vtype == VCAP_TYPE_ES0) {
+		/* This works for IS1->ES0 */
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_ISDX_ADD_VAL,
+					       diff);
+		if (err)
+			return err;
+
+		err = vcap_rule_add_action_bit(vrule, VCAP_AF_ISDX_REPLACE_ENA,
+					       VCAP_BIT_1);
+		if (err)
+			return err;
 	} else {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported chain destination");
@@ -398,6 +421,23 @@ static int lan966x_tc_add_rule_link(struct vcap_control *vctrl,
 	return err;
 }
 
+static int lan966x_tc_add_rule_counter(struct vcap_admin *admin,
+				       struct vcap_rule *vrule)
+{
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_ES0:
+		err = vcap_rule_mod_action_u32(vrule, VCAP_AF_ESDX,
+					       vrule->id);
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
 static int lan966x_tc_flower_add(struct lan966x_port *port,
 				 struct flow_cls_offload *f,
 				 struct vcap_admin *admin,
@@ -465,6 +505,21 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 			if (err)
 				goto out;
 
+			break;
+		case FLOW_ACTION_VLAN_POP:
+			if (admin->vtype != VCAP_TYPE_ES0) {
+				NL_SET_ERR_MSG_MOD(f->common.extack,
+						   "Cannot use vlan pop on non es0");
+				err = -EOPNOTSUPP;
+				goto out;
+			}
+
+			/* Force untag */
+			err = vcap_rule_add_action_u32(vrule, VCAP_AF_PUSH_OUTER_TAG,
+						       LAN966X_FORCE_UNTAGED);
+			if (err)
+				goto out;
+
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(f->common.extack,
@@ -474,6 +529,12 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 		}
 	}
 
+	err = lan966x_tc_add_rule_counter(admin, vrule);
+	if (err) {
+		vcap_set_tc_exterr(f, vrule);
+		goto out;
+	}
+
 	err = vcap_val_rule(vrule, l3_proto);
 	if (err) {
 		vcap_set_tc_exterr(f, vrule);
-- 
2.38.0


