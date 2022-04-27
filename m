Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5B75117D6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbiD0MJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiD0MJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:09:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2115.outbound.protection.outlook.com [40.107.20.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1C5554A1;
        Wed, 27 Apr 2022 05:06:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVmPsIYR5OSYqHnusPT+0Jqme1BRw1HZElKUDOdwc+gcoV1ez1akG8WAecT9Vsw+0t2mq0JpuDR0vrRGJmBGfSXh5yOr754XHbNiG7wV3GZa1ghEbtne4ZsUsXSuA0QQI/QTqcGyS60sZXMmiGU9IpjuiHw+S5SLi04XxIToAB/5A0LRb/4wOJhigyM8ibecBZCWCVi1aQSNcLY7hoXOQ4GxJv6WBjscXdFBSqmUCebE1hZYO0ZRvhk/VD6HQIBTlK3tZJpMPv/AVK6r7S7cO8LKwg0Ivd7+/ugsioeGUNQN9+wuCrzWlnzRP5cvmL6/n4Av0QfMqvAF++vOyYDjmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLA6yXwkPvczoUuDNMRK20ZGnPRcJNnx+c/KNsh52Os=;
 b=g/KmAjsJ/OCUVnVenkBzn7WXfGRmMWr6FVEPVxbAFoUYCsyvcDzKVzZc8fBAiSZ5/J6BUIzM9zTYiFjZbwzrrNLu/edRT6U122CbTwY6z1uSrGoC92tYGf5rtzpCujWD/ASNziwNkukBRdOiv2uagTAQHlLGW+YUArRuiAthyDPSjuPdTTpKC4CKZ1iQfqwMLtBj2b1SN2vAf2/a9MhSisllQGkITx9YGm7n5dLJaFX2RE3zG+3VqWSs93kHpBnuuB4IkZ5RHh9vCqrl0kMXVGMhkQuLt3X+z9IkvzGUrkJFRRN6rU30Mzsh335gWrihDNCoUJwccQ2n4KqSLTYssQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLA6yXwkPvczoUuDNMRK20ZGnPRcJNnx+c/KNsh52Os=;
 b=VvmWB3aO3yqbD8BY0GxPCcWaj3sGQPjgA8GupgsuGVVwM7SMEkHr2CShgacMjBDCJjrOdnEshPBFJKlDvE1aQaB0yC9ykZvemRXw0S6m5SN0PeofbzyapM1sHMuab3dfd51bKXyrXZGQ5I10zaQYDc+G+xQiTrr7/zEXRs4XI3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from DB9P190MB1963.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:397::18)
 by DB9P190MB1306.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:22d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 12:06:04 +0000
Received: from DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
 ([fe80::2186:244e:8f91:a5ea]) by DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
 ([fe80::2186:244e:8f91:a5ea%8]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 12:06:04 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: add police action support
Date:   Wed, 27 Apr 2022 15:05:48 +0300
Message-Id: <1651061148-21321-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::16) To DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:397::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcfc51ce-9d70-4314-497d-08da28464de1
X-MS-TrafficTypeDiagnostic: DB9P190MB1306:EE_
X-Microsoft-Antispam-PRVS: <DB9P190MB1306C4D812E6E8DE3B46E3D08FFA9@DB9P190MB1306.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YI+1RW9Noem1GQ5HHhWzZo5eV1V6i4EECrlSJ92U1zoeXx9nXICjFbIpAgvB2J6bjgSj2b4QtnjiJHiDQToX31a1f75zqzIre+1LODifwQyrr81CreMZX6hpVaM+2/bzX17KAVgDBHfBokxtJZjKpB1BjPXrfwuUpXgZzU75wWKta35sLysBlYQK2cuE/TOvIsChWiZQZjXTLVWZZBY367Y196UvMH1pAi0MjsRLUCIR3jSK7rFjdZ283Lr6/Hf7ikh/Sbnlt5e8b9aTRKRtp6JaM4ctYLZvSz5A7Zb7EdRBzc1ddO3oH20/qhuJc9ppFQEKGXIwXiNXSUJKAfTTduF+Ef1nRGVRrXJwBPYA24JIwuyylOEmwMk3T+Af1ldk2JHuCY+gXtsa7ymdzrH4HSMRClkayXN4kJsXhkYxkofdQjLLG+sNV8mp1fsVIU2ZdCx81Bh88R/509zfETtsyu4twpYXOBfGnNFnvdfTE6lYx8isOxMzUFMhE0b6pG1VQZNKcklrSxREll1qR7Uzd3apAjLJ9xYblJok2FLKPYk9PToxMXFKKeTXgu3uzd6ztp5zjpCQlZXLhHtxv/1pQPNgyFb6811zJIl+E6lufMyMirjjcfegrphRBZlyxxs18hlpE31gZCTJb49imOjyCG0GYlKqeBou0crbqTKPcyXx7aRcfHOfRDny+o9qJh44JfLeF82xrMuZgAWB+s+lkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P190MB1963.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(376002)(39830400003)(366004)(346002)(396003)(136003)(5660300002)(316002)(44832011)(6512007)(26005)(83380400001)(54906003)(86362001)(8936002)(52116002)(6666004)(6916009)(6506007)(186003)(2616005)(36756003)(508600001)(38100700002)(2906002)(38350700002)(6486002)(4326008)(8676002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W9Qq0l+4UpSKPqqekB/ThlO5hGA8ywGJdABkbC5RGzg7wW3D0NXmY3JWBNSD?=
 =?us-ascii?Q?kPusdGivensLI/kC5Ncfud6KLsI9crS4shISSwPr5XvepHWp3rs2LZm+geNT?=
 =?us-ascii?Q?pFSVrzGax714uFHhOcr3pDhCQdO4Ruv+6HfasJAYZQss3Slryhxodj5Z4kg7?=
 =?us-ascii?Q?fCpvfanjs9XrRToU1EfAwtmlCbgHSwoN8hbAM5cWYXSc0zKWiLfTCjTV9X8/?=
 =?us-ascii?Q?hXZxwU3+FKdXu4zotDHgZ5YmSYFKuAklbsrlhR4lD3m5CFjk0sE1CrI+dYA7?=
 =?us-ascii?Q?6oISEX8m54eDSz8Mx9lEp0FwN5bq/r+MlVXwS+FWBh3qrMHJZTa9BwLtzMCd?=
 =?us-ascii?Q?J6CiFLUGTjgRBf2fda6epyvQJimUUOmvHNlZeHIWiIuzHuHAmae/4EPssO3r?=
 =?us-ascii?Q?3zb06fHQVLI7tAJv+AGalyfq+UnUBnczl3SF3pbpyvpqh36a+OTfr4Bmt2Z/?=
 =?us-ascii?Q?jJNtFXGIKL4kY2qgXEk3hq0o87IAdxsv787nf6qH/zW/PUcmxn7o8MNwqzhW?=
 =?us-ascii?Q?Y2UaCeBGEHAeM/yfvX4D40KjUKMKmUwJGLxMIjmJzD/G3FMFKAhquXO/Ne0x?=
 =?us-ascii?Q?/2ffWt712wnhrVPZCYRr3P5hxClP8dofD1ONCQUMGtu6ba+vT3ajpUa3zy1S?=
 =?us-ascii?Q?u7AWdLagVwwzixNRgWRtvES/AW7CgGdqhUr6oa/RHKYeqa6lahgRNYHI5qII?=
 =?us-ascii?Q?8a7uwuysJ5ghqwnQY13F66W1x4jPV7G5Q26cUI6PBnBql+j6Vq3mfJZ7iVub?=
 =?us-ascii?Q?ms/sQdROY6Nsi1kkJaFBkUUSFUxtPgX1uWl0qKrXsg3cmpzt5sa9ZXM3PiRX?=
 =?us-ascii?Q?q2YSVWEwT7cuvWCdsfVdsrRkM/Xcad7uWDMQI55sJbFM4xrj07D8ZueSewM6?=
 =?us-ascii?Q?YWlIg83E/wL4Hfw+F4VSmXI1cpMqjY4xsIL0nWC3QCH6mXl0MelQYiQfOOKL?=
 =?us-ascii?Q?Q9K3mRls1mFIqR5+xrEqhYNUiKSMiFjLzhxrgQACKke7N9zj65p9fqJm9LmH?=
 =?us-ascii?Q?aT43D4A1TR4nP4KflqDdNKY36lfj4SAQbSaLvxoAJi/7+bj2D5Z4tM9ncI2E?=
 =?us-ascii?Q?0yhuNqmmhbwwrzYbZG8wG8LTVcT3TFL1CUZHtZSHAeC1yZb/VJkxKXTucxSd?=
 =?us-ascii?Q?AERbBrLfb4OrUliPISxIrnzVNAlZFrDEPCVl3QhU0aRQb+8kx6sYL8sgkWYy?=
 =?us-ascii?Q?Fo/BSKE6CaZdEPhUlKKD1tA5ddDQfqCEbAJreoATSjSPRnW5inM5V+f48XpO?=
 =?us-ascii?Q?8eO5vYg6nI7URP1sA1vF97DIbRtCTuiUlHhJK1BmxVWoZ19lhy0+Y39DEkYD?=
 =?us-ascii?Q?q9Mbm/5/ovWuosFsl7DGHW/vsHhtaGM4jSVCnxg2ev36/cYo+l97Ad9/0u4T?=
 =?us-ascii?Q?bYUfMsJ07+DwDlYb+nbH0gDlRYYF8N8YCxapBFIjOPgVndSXmS2f2fKj5IP4?=
 =?us-ascii?Q?SkQADq7hWHhmzPMGJBxc1u9fvdzCK5Bamvlgd8k4yrUDfI5zBzvSzfOjF9yd?=
 =?us-ascii?Q?Bc8YKWCV/rMLI8WgRyiDBBRsWSU3wKKNeqJ0DlpOamviR95JFf4eERCak0l9?=
 =?us-ascii?Q?p0bYsBed8PLsjT31vpi+gh1sAvIbCh+yxqNwLOjxdIkf1kABZTmX2OVrzqK+?=
 =?us-ascii?Q?6kAHjljHQhMkrzn04ghPRbAGJ6HIVSFasBA27X6P6kAOxyGta5nupdimEo3m?=
 =?us-ascii?Q?0dKWjzblk8I2jnQ1n9LHcEOWMDWglFT1/80mntVCINdwTBAe91YB5xAsbBTC?=
 =?us-ascii?Q?9713EjRkyTYkSOT3mYz3/qT4ROkQIdmZpb1Q2pze4b5rHJ9Xwcaw?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfc51ce-9d70-4314-497d-08da28464de1
X-MS-Exchange-CrossTenant-AuthSource: DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 12:06:04.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bus+GocOuoEE+Gz87G0h/Rj86fLx/5/v8UbVrGY2YCC2Ih4ypF90B2pZP3qWkJ4lV84pG7UF2I2WgAjyXnqhdIvIWIw0dXfkeIVhj4uTIE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1306
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Add HW api to configure policer:
  - SR TCM policer mode is only supported for now.
  - Policer ingress/egress direction support.
- Add police action support into flower

Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera_acl.c   | 35 +++++++++-
 .../net/ethernet/marvell/prestera/prestera_acl.h   | 12 ++++
 .../ethernet/marvell/prestera/prestera_flower.c    | 10 +++
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 81 ++++++++++++++++++++++
 .../net/ethernet/marvell/prestera/prestera_hw.h    | 13 ++++
 5 files changed, 149 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index e5627782fac6..3a141f2db812 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -35,6 +35,10 @@ struct prestera_acl_rule_entry {
 			u8 valid:1;
 		} accept, drop, trap;
 		struct {
+			u8 valid:1;
+			struct prestera_acl_action_police i;
+		} police;
+		struct {
 			struct prestera_acl_action_jump i;
 			u8 valid:1;
 		} jump;
@@ -533,6 +537,12 @@ static int __prestera_acl_rule_entry2hw_add(struct prestera_switch *sw,
 		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_TRAP;
 		act_num++;
 	}
+	/* police */
+	if (e->police.valid) {
+		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_POLICE;
+		act_hw[act_num].police = e->police.i;
+		act_num++;
+	}
 	/* jump */
 	if (e->jump.valid) {
 		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_JUMP;
@@ -557,6 +567,9 @@ __prestera_acl_rule_entry_act_destruct(struct prestera_switch *sw,
 {
 	/* counter */
 	prestera_counter_put(sw->counter, e->counter.block, e->counter.id);
+	/* police */
+	if (e->police.valid)
+		prestera_hw_policer_release(sw, e->police.i.id);
 }
 
 void prestera_acl_rule_entry_destroy(struct prestera_acl *acl,
@@ -579,6 +592,8 @@ __prestera_acl_rule_entry_act_construct(struct prestera_switch *sw,
 					struct prestera_acl_rule_entry *e,
 					struct prestera_acl_rule_entry_arg *arg)
 {
+	int err;
+
 	/* accept */
 	e->accept.valid = arg->accept.valid;
 	/* drop */
@@ -588,10 +603,26 @@ __prestera_acl_rule_entry_act_construct(struct prestera_switch *sw,
 	/* jump */
 	e->jump.valid = arg->jump.valid;
 	e->jump.i = arg->jump.i;
+	/* police */
+	if (arg->police.valid) {
+		u8 type = arg->police.ingress ? PRESTERA_POLICER_TYPE_INGRESS :
+						PRESTERA_POLICER_TYPE_EGRESS;
+
+		err = prestera_hw_policer_create(sw, type, &e->police.i.id);
+		if (err)
+			goto err_out;
+
+		err = prestera_hw_policer_sr_tcm_set(sw, e->police.i.id,
+						     arg->police.rate,
+						     arg->police.burst);
+		if (err) {
+			prestera_hw_policer_release(sw, e->police.i.id);
+			goto err_out;
+		}
+		e->police.valid = arg->police.valid;
+	}
 	/* counter */
 	if (arg->count.valid) {
-		int err;
-
 		err = prestera_counter_get(sw->counter, arg->count.client,
 					   &e->counter.block,
 					   &e->counter.id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 6d2ad27682d1..f963e1e0c0f0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -56,6 +56,7 @@ enum prestera_acl_rule_action {
 	PRESTERA_ACL_RULE_ACTION_TRAP = 2,
 	PRESTERA_ACL_RULE_ACTION_JUMP = 5,
 	PRESTERA_ACL_RULE_ACTION_COUNT = 7,
+	PRESTERA_ACL_RULE_ACTION_POLICE = 8,
 
 	PRESTERA_ACL_RULE_ACTION_MAX
 };
@@ -74,6 +75,10 @@ struct prestera_acl_action_jump {
 	u32 index;
 };
 
+struct prestera_acl_action_police {
+	u32 id;
+};
+
 struct prestera_acl_action_count {
 	u32 id;
 };
@@ -86,6 +91,7 @@ struct prestera_acl_rule_entry_key {
 struct prestera_acl_hw_action_info {
 	enum prestera_acl_rule_action id;
 	union {
+		struct prestera_acl_action_police police;
 		struct prestera_acl_action_count count;
 		struct prestera_acl_action_jump jump;
 	};
@@ -107,6 +113,12 @@ struct prestera_acl_rule_entry_arg {
 		} jump;
 		struct {
 			u8 valid:1;
+			u64 rate;
+			u64 burst;
+			bool ingress;
+		} police;
+		struct {
+			u8 valid:1;
 			u32 client;
 		} count;
 	};
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index c12b09ac6559..d43e503c644f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -108,6 +108,16 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 
 			rule->re_arg.trap.valid = 1;
 			break;
+		case FLOW_ACTION_POLICE:
+			if (rule->re_arg.police.valid)
+				return -EEXIST;
+
+			rule->re_arg.police.valid = 1;
+			rule->re_arg.police.rate =
+				act->police.rate_bytes_ps;
+			rule->re_arg.police.burst = act->police.burst;
+			rule->re_arg.police.ingress = true;
+			break;
 		case FLOW_ACTION_GOTO:
 			err = prestera_flower_parse_goto_action(block, rule,
 								chain_index,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index c66cc929c820..79fd3cac539d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -74,6 +74,10 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_SPAN_UNBIND = 0x1102,
 	PRESTERA_CMD_TYPE_SPAN_RELEASE = 0x1103,
 
+	PRESTERA_CMD_TYPE_POLICER_CREATE = 0x1500,
+	PRESTERA_CMD_TYPE_POLICER_RELEASE = 0x1501,
+	PRESTERA_CMD_TYPE_POLICER_SET = 0x1502,
+
 	PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET = 0x2000,
 
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
@@ -164,6 +168,10 @@ enum {
 };
 
 enum {
+	PRESTERA_POLICER_MODE_SR_TCM
+};
+
+enum {
 	PRESTERA_HW_FDB_ENTRY_TYPE_REG_PORT = 0,
 	PRESTERA_HW_FDB_ENTRY_TYPE_LAG = 1,
 	PRESTERA_HW_FDB_ENTRY_TYPE_MAX = 2,
@@ -430,6 +438,9 @@ struct prestera_msg_acl_action {
 		} jump;
 		struct {
 			__le32 id;
+		} police;
+		struct {
+			__le32 id;
 		} count;
 		__le32 reserved[6];
 	};
@@ -570,6 +581,26 @@ struct mvsw_msg_cpu_code_counter_ret {
 	__le64 packet_count;
 };
 
+struct prestera_msg_policer_req {
+	struct prestera_msg_cmd cmd;
+	__le32 id;
+	union {
+		struct {
+			__le64 cir;
+			__le32 cbs;
+		} __packed sr_tcm; /* make sure always 12 bytes size */
+		__le32 reserved[6];
+	};
+	u8 mode;
+	u8 type;
+	u8 pad[2];
+};
+
+struct prestera_msg_policer_resp {
+	struct prestera_msg_ret ret;
+	__le32 id;
+};
+
 struct prestera_msg_event {
 	__le16 type;
 	__le16 id;
@@ -622,6 +653,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_lpm_req) != 36);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_req) != 36);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
@@ -640,6 +672,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_resp) != 12);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -1192,6 +1225,9 @@ prestera_acl_rule_add_put_action(struct prestera_msg_acl_action *action,
 	case PRESTERA_ACL_RULE_ACTION_JUMP:
 		action->jump.index = __cpu_to_le32(info->jump.index);
 		break;
+	case PRESTERA_ACL_RULE_ACTION_POLICE:
+		action->police.id = __cpu_to_le32(info->police.id);
+		break;
 	case PRESTERA_ACL_RULE_ACTION_COUNT:
 		action->count.id = __cpu_to_le32(info->count.id);
 		break;
@@ -2163,3 +2199,48 @@ int prestera_hw_counter_clear(struct prestera_switch *sw, u32 block_id,
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_COUNTER_CLEAR,
 			    &req.cmd, sizeof(req));
 }
+
+int prestera_hw_policer_create(struct prestera_switch *sw, u8 type,
+			       u32 *policer_id)
+{
+	struct prestera_msg_policer_resp resp;
+	struct prestera_msg_policer_req req = {
+		.type = type
+	};
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_POLICER_CREATE,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*policer_id = __le32_to_cpu(resp.id);
+	return 0;
+}
+
+int prestera_hw_policer_release(struct prestera_switch *sw,
+				u32 policer_id)
+{
+	struct prestera_msg_policer_req req = {
+		.id = __cpu_to_le32(policer_id)
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_POLICER_RELEASE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
+				   u32 policer_id, u64 cir, u32 cbs)
+{
+	struct prestera_msg_policer_req req = {
+		.mode = PRESTERA_POLICER_MODE_SR_TCM,
+		.id = __cpu_to_le32(policer_id),
+		.sr_tcm = {
+			.cir = __cpu_to_le64(cir),
+			.cbs = __cpu_to_le32(cbs)
+		}
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_POLICER_SET,
+			    &req.cmd, sizeof(req));
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index fd896a8838bb..579d9ba23ffc 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -107,6 +107,11 @@ enum {
 	PRESTERA_STP_FORWARD,
 };
 
+enum {
+	PRESTERA_POLICER_TYPE_INGRESS,
+	PRESTERA_POLICER_TYPE_EGRESS
+};
+
 enum prestera_hw_cpu_code_cnt_t {
 	PRESTERA_HW_CPU_CODE_CNT_TYPE_DROP = 0,
 	PRESTERA_HW_CPU_CODE_CNT_TYPE_TRAP = 1,
@@ -288,4 +293,12 @@ prestera_hw_cpu_code_counters_get(struct prestera_switch *sw, u8 code,
 				  enum prestera_hw_cpu_code_cnt_t counter_type,
 				  u64 *packet_count);
 
+/* Policer API */
+int prestera_hw_policer_create(struct prestera_switch *sw, u8 type,
+			       u32 *policer_id);
+int prestera_hw_policer_release(struct prestera_switch *sw,
+				u32 policer_id);
+int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
+				   u32 policer_id, u64 cir, u32 cbs);
+
 #endif /* _PRESTERA_HW_H_ */
-- 
2.7.4

