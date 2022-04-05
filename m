Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F04B4F43DD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383277AbiDEUFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389041AbiDEOm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:42:29 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80137.outbound.protection.outlook.com [40.107.8.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42D313F2C;
        Tue,  5 Apr 2022 06:20:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RryM/jp6PB3QNn70/oEkKJQUZXGUCYm3W/9UgPwUAwXoL36WLcfA+RmXlyFlAmn3OGRavptJ4Zt0eQiDWiaFQkE2Fb1sWBhM9Zb/PpFoNBRDgLPHRVtjT7vAIXu/YAm6+yGuHMIPc9syiJDxxKsSydzoZdFQmJTOwsy/QguaC9DChbgfm9ZYObZXgjDZA77IuT9KogANPKnsrjC6tSD5iMZJk6CgYPfwUrbphrVNAC5jRAgq6L5LCVHG3SWd9po+KVM6Sg+T/KrNa20uIUDtlkXR76nhypdOqO5pGj3wik7zPPHDVN1uOnFQEtkbSwrJb5VffhBLaBZHFsjur7h2dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AqiyLJ4FfVt8HKeE9E6l5cX8iHUCIS2409tRiE+lZMQ=;
 b=I3giLR/qn8xS/cAh0hryCteEFC+xmw5bKjEqGbz2LjBfeEo+52rq7tRs0+1aP4c83kCxuChXZifjVSaPw24YZDuwdOq7q+7GyQTrbW+ULl1Y4/8UWBZWHxPB6PtOrCy6/GTe+J8NfpOaMV/D2YOIs6/lGuqggXraSGdVO349uA4RzBwo8+0jsJM/a8CtXcMIE7Mdrrv/32fmRbZ9eCvLvkIIvvV1aXc2j9mrrVFUte3AxwmnaFAW7pt8MqpQOWCUI+Z0692yLsukq99fdeeNHkHcAHswA+2Tk4QVRMyhlELFhXEVeD5a6JVGvGgP2CG5ex+cpG9AOEdpOYAn/VP5/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqiyLJ4FfVt8HKeE9E6l5cX8iHUCIS2409tRiE+lZMQ=;
 b=fm5RlxpHW+3EELN6vPCeJmRy2UYRfuKtK/eQvz++FRwHpno4TASfoH3M0+JOrzl2rmyT5VGmYxWfnk+boTfA76rUv2ppikQwcwkihv012cpsoXt9j4XyPoJF4jEbY/vxCsq5C91dvpbvSXbIxhGOZdKIqCna/t3AWRBpWmg/twk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by HE1P190MB0380.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.30; Tue, 5 Apr 2022 13:20:24 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f50a:467e:d704:784]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f50a:467e:d704:784%4]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 13:20:24 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] prestera: acl: add action hw_stats support
Date:   Tue,  5 Apr 2022 16:20:14 +0300
Message-Id: <1649164814-18731-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0088.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::29) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b58e01cd-3295-4c54-2df5-08da17070ab0
X-MS-TrafficTypeDiagnostic: HE1P190MB0380:EE_
X-Microsoft-Antispam-PRVS: <HE1P190MB038072C960AF11D58D628A4B8FE49@HE1P190MB0380.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 752+mi4iI1+z7Fw08KTghJgwr/NbyTLQ522X4raoilj0YfuKXy0UsxnnaoI2AJD1r8uZlTS12zjCwthXjjBzq/JKIuwXQYj434/jc5b+bISqR31cidXdZJ0QN2UjnEJLrl8GuzWM6AjR3fIwCnj2gtVAborenfqP+TkNipxDvcVotuFfbA3rU/RHX8zebFYRN/MqGX5u0+HoxK69354X5MzMguqJDzKnmjSe5x7hq4+Sr4UbdAMs8oQjv+Khjf2kC0s3TbensPJpuIG7btgatzvGwIE05P2LT20MvbyG51i/rIDLuKmI+721FUdlNHhSXVqOFVPDmfcJ37yDz3pflRRqD3JtPPuXtkCutNXSpNApd/83OLtyydxryTxv4Ff2hI08mwZ5OPk0r33jS9XXywfMaYFsMbiwazyIu2cqyEeBtk0CRjQd+OMofQ7pkhahozcXiOAp7ixh2oGb1E6daSIxfvCKRCJI9hURkaDtPWlFLLSECq8jbN1jtI+77f2hE+QYxQxTjSnZikU/xNVu6ANMyjBaVIvde/tkzSmeLRU1QY3ZgkMo+krCLIRaUIYFi3AFwXXP7j1jEx2PeDQKfG8Xmvwfy3fvyyVrQ8dFBuZwXCdaz1E7xliXL+n1Dp171o4I5KQFowF12t90hPfVWSJ5rbPHGtiQatWOfS3ZZLyeflzndSVVmWfdJbmWq1pa3IqisLEqYQvlfH0hJDxQtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(136003)(39830400003)(376002)(346002)(66476007)(66946007)(508600001)(4326008)(66556008)(8676002)(52116002)(6486002)(6666004)(2616005)(2906002)(6512007)(83380400001)(8936002)(6506007)(86362001)(44832011)(26005)(186003)(38350700002)(5660300002)(36756003)(316002)(38100700002)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OPKSOPV+yIm64t3KIawzJzC9WWLdUZWyJc+8ainBL/7fO21L8vGZJPg0Ov1t?=
 =?us-ascii?Q?NtvSeVtMCwl8rBYTvxv6Kxz9oKVnFl/2LwIMfQyr9wXyuUDdPZ51ZyXNt6j0?=
 =?us-ascii?Q?nVbak5T4axCcZzk3Zfyut7qD+kj3ZaZpoVddzieZSdmrlu60XBVX7hxDNXHK?=
 =?us-ascii?Q?ngtNp+v9RKdGbqrqROF9CqfGlymiAoEjacy///cMEiFciiij+lw2uR+BS2eR?=
 =?us-ascii?Q?PjSzF8c2jIy8Bcjo62PXF8XOJqmURR5dLYPxZ7ktGcT8kjCSr3AhKw2yCI3w?=
 =?us-ascii?Q?OsRbfbAAanRTSK/oFaHnA2Cx3W5+D8n1Nmnsh56YcKlwua0xmHYSPCuK7EuX?=
 =?us-ascii?Q?R4gkH3+hdY1MuiqGOP0WXZjs7Dd60ssM9So1C4mfEoSi7mvIelD5raQDULnr?=
 =?us-ascii?Q?Gz7tJ16IZeZGFLkNBe9AsTZpEU+qrIoIHSxO3LZQ8Fj5QjEclxgIQdy55cMe?=
 =?us-ascii?Q?sOzAI10Gif/Rpo0PX5FMz8hfLsMpdn07FMQhs5VpcxZ/8H/B0PVEvT11bg5t?=
 =?us-ascii?Q?3gywBwl7XRhDaYihBLNxxPgjlnJrb+PST++NfIZ9dF8CPH5W1h3IezTD//Td?=
 =?us-ascii?Q?3/z7lEd2BIAIgrKyD0hA7cwAdXXa95LlEYDZ3fAatYPQb4M0Fepg7Ob20Bv1?=
 =?us-ascii?Q?PMjCELlYExDQecQA50+LNFTlWQeJ8ykAXa7wWbme3rhebAL9L4Ax0hdQxMrR?=
 =?us-ascii?Q?VSXV4fQLR13hovfJ9vXzD5I3r8h+KYVQvZn5vEyrvynQRBifetcStb9+UxPQ?=
 =?us-ascii?Q?xASaYWpZS7HPjTOFJy7gtvGkuEcvJxiqEvCp93HKorFdLqnUGDDJVZABQAVZ?=
 =?us-ascii?Q?iIUCDQ1md4KpTjQMdOn4w3nsCvV0kGJFXN6RwNBz5MpLOWwo6OVsDGN7fnuz?=
 =?us-ascii?Q?xsgfRlpjKQI5awVG3sBgWsZ49LBmGiSodAoFRpvenZayhnhSn+kn88Kh3E8J?=
 =?us-ascii?Q?mCfYbYi1E9IS2vRTn1zt4qRGrnVTo20PIpBlh3aCD8rMOw478UrNC0b8gtP4?=
 =?us-ascii?Q?Fyp5qI/2CxsFc66QvgeIxE2G6xrE3+JgF2sVlToaw/FMQ8Ghk6us2MKZSdxS?=
 =?us-ascii?Q?xPuYAQFqVefISDi18PYTrVGEvyjRcYmI7UUU/5CNWjhE+x3iHg61GqswdaVe?=
 =?us-ascii?Q?U8EBIM6tidowm2B1lG4CRHXDNLd8ayOuSOXGVbVLr7A4uqNs9cZWc+uOg6E8?=
 =?us-ascii?Q?8VDAF+Fom360+W8tRnTSkXdgxfqLkgvRCkYY2QETKptgytIzn9oSmEkABLzx?=
 =?us-ascii?Q?j8jPS2CQS2iKagwOx/K/Rhg0NjWvKKZp6GTkTKyCOdbNj7bwR42yVW9kH3BA?=
 =?us-ascii?Q?kdZjSpQn6WOEkX1HtJk5eiX3csUnAZJFxk2YzKM9R+aElMAvXYOJEVq0V7We?=
 =?us-ascii?Q?frSpGKQrq3bqsG26gpY4GY9HpZlW9HiQnR6hCYECpSORqch7PxsX7oG2vh2D?=
 =?us-ascii?Q?eaQpu/29kk/95haH/SfQ7N44woFGJ1HtHHCov8FlHtjgUP8lihUGBZenF74A?=
 =?us-ascii?Q?h1dJyPDKylpCf5gyWFo2V/aRcHPaD9whCFaY3aPPlAoP/m29AwGInhKCapfC?=
 =?us-ascii?Q?NSOJ3HB35cNQDyxWm1Oc6zJIHW7YaIqya0/vCwgmOUrh0kNSS9cALAs/+JSM?=
 =?us-ascii?Q?UgZ3jEb3FRMr1iM1VScEn5nnvZSKdcyIOg+Dmbp+IPBmJgffB55BpiaGWn8p?=
 =?us-ascii?Q?mx2WGBGhz52k/NiQs2ur/fIO+uJ8Xz7kYukkv3FS/AKdl2B+7gAtIfXVM3j3?=
 =?us-ascii?Q?JygFRE5YHkGtUav3xE8VphudeSDxs4s=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b58e01cd-3295-4c54-2df5-08da17070ab0
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 13:20:23.9280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: stP3ck4wIhZPEMha06yfYC1vlrsyyO/o1klK/MFPLI2kn0nDuIgmtQnpPRF5jAY4wZP7/plXun9CoCh5kSdEkU0YnDag99Nw4k1CkwaVLaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Currently, when user adds a tc action and the action gets offloaded,
the user expects the HW stats to be counted also. This limits the
amount of supported offloaded filters, as HW counter resources may
be quite limited. Without counter assigned, the HW is capable to
carry much more filters.

To resolve the issue above, the following types of HW stats are
offloaded and supported by the driver:

any       - current default, user does not care about the type.
delayed   - polled from HW periodically.
disabled  - no HW stats needed.
immediate - not supported.

Example:
  tc filter add dev PORT ingress proto ip flower skip_sw ip_proto 0x11 \
    action drop
  tc filter add dev PORT ingress proto ip flower skip_sw ip_proto 0x12 \
    action drop hw_stats disabled
  tc filter add dev sw1p1 ingress proto ip flower skip_sw ip_proto 0x14 \
    action drop hw_stats delayed

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_acl.c   |  7 -------
 .../net/ethernet/marvell/prestera/prestera_flower.c    | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 47c899c08951..e5627782fac6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -421,13 +421,6 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 	rule->re_arg.vtcam_id = ruleset->vtcam_id;
 	rule->re_key.prio = rule->priority;
 
-	/* setup counter */
-	rule->re_arg.count.valid = true;
-	err = prestera_acl_chain_to_client(ruleset->ht_key.chain_index,
-					   &rule->re_arg.count.client);
-	if (err)
-		goto err_rule_add;
-
 	rule->re = prestera_acl_rule_entry_find(sw->acl, &rule->re_key);
 	err = WARN_ON(rule->re) ? -EEXIST : 0;
 	if (err)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 921959a980ee..c12b09ac6559 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -70,6 +70,24 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 	if (!flow_action_has_entries(flow_action))
 		return 0;
 
+	if (!flow_action_mixed_hw_stats_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
+	act = flow_action_first_entry_get(flow_action);
+	if (act->hw_stats & FLOW_ACTION_HW_STATS_DISABLED) {
+		/* Nothing to do */
+	} else if (act->hw_stats & FLOW_ACTION_HW_STATS_DELAYED) {
+		/* setup counter first */
+		rule->re_arg.count.valid = true;
+		err = prestera_acl_chain_to_client(chain_index,
+						   &rule->re_arg.count.client);
+		if (err)
+			return err;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
+		return -EOPNOTSUPP;
+	}
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
-- 
2.7.4

