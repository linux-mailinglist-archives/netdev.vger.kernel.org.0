Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451885B8C7D
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiINQJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiINQJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:09:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2127.outbound.protection.outlook.com [40.107.94.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A8173309
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZW9T+bIh1Sn0RdtnVeQHQg5rK9KIhuRWGeGo8DANsm+dGOSrCaKZC0vN2jUF2Spsm2+G7yrau4bE2QhZZ60VlSRBRw5eAAjq3Cu95iI/nSnirT7s7I7i95q/GoxX+PtTaiZ85o6WQZHl6J1jEmi1kcXqJf3teLs3u0k9ZgFIiX53TdaAMvTwGmRK2jCLnKUWVKd7aXTjBk/F50R18goyhNlkFGLycwWO/JwiRvp7VGepNF7ukbDClX95adQ5PVyGa3p/1iyu52V5J3WUhgENE9KRWC4WUw7U/K7IexzlOGMeLBS738JqyUSb1rGJYZQsR6UZ0/varoLEoKylPi+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhAhpQubq5qNBrVm4I0jAcrGfDPmHtuGUD2lNxE5KTE=;
 b=XNkBnrI/eQ8lGIpmnEvVNZygkl3g8e0YZo1ZV7KAGGhu0IQdksMtlGBmrbBHvaka9TjFn12Egl0wzm23xL5S8FZH2haTKS0GHmdWBK3W2ahXILYpgdUpaphflxrljxgBFeGmh6NxtFQQEGHDS2euyqUpgv9JfWVReqr32Y+fmqtnS5ut96I6P68T3IL2dnXjaDuHvZMU3AY4hsN1R6mSxkLqyMsOxC6BoiWp/g94Yh15O73GfMMdhMymiK1uRwGXwaG3zANDMPX/Y5QP/pHjH417VpWggO2ccmvSafXu/J9XfuJvmnJ1Y+vsxR0pcxV8rloZeWny0bj9u51kk9987g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhAhpQubq5qNBrVm4I0jAcrGfDPmHtuGUD2lNxE5KTE=;
 b=lX5r87Pda8g0X2WWmk5GrTBsPFhyWRrnL6cRweP+AYAb/qSkr8DOLrKdDIhATMqv0T7gPjxbdNds7e2U+qMfIJZmv/JOxRsbkBG64WVwYhZgy/MKiDGsZHo/tRqKelUEPZSRtXnkY4HKXRzbuhzlMLCelwottxQgJn5Pomp5uTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5462.namprd13.prod.outlook.com (2603:10b6:303:195::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12; Wed, 14 Sep
 2022 16:09:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5632.012; Wed, 14 Sep 2022
 16:09:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Hui Zhou <hui.zhou@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: [PATCH net-next 1/3] nfp: flower: add validation of for police actions which are independent of flows
Date:   Wed, 14 Sep 2022 17:06:02 +0100
Message-Id: <20220914160604.1740282-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220914160604.1740282-1-simon.horman@corigine.com>
References: <20220914160604.1740282-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: e47006aa-fae2-4d9c-12e8-08da966b7057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaLOQ271YSkayFjRxsciDWoV0KosoVNkPw7cU7Amdyerx1Ex6t2iEoPu7luASg0rTQlSqkbx1uhWHQ80jbJfjpU03oTyNpoJBm4t5CAzv/RsHGAsaNzRfELhCG+voR8sqPCLGsz/DjtEsNZWiDg4T2tGRqt+8s6r7I7+epUG6XPPzmdyQzK0s3wzUNW1Oz8t7DRDbUulN+bneCGbFqNd4qa/O7m43dnhiVsqzF0WTtN9n5U9GJC5ULZ4VepKsoVUZ4tmScwYmHi31WfM+1e9EpTkBL1q6H54LAfG7lTn84whEAVSlI5EEiwEJBg527nv4ghlDSJgYtrUNSuG6RhyKXm5MVHu3qhqvElf4WBl7KZcykxHEJU/Duj9IaonuhSjYba3TryZwLLQzYvRcBLv8axUPSN1Sb68rkNyNggESGDdBwyxv8tBgsbz2hQCQHrq1DkCAwH61M5N5tlrs6jkueE/fniNzdTBh1CaJco6zJ0A+YFufbpWBQsfUt/46Zqshv6Gs+QNkCqzYiLxGBxv2wzhCf/ABD0ZaOPyR9uny/FSz8tk+pvccPh1NU68TbVcCjc0FUpkPwiNQlIm9f7VEl4LmTvvxyllMqRzHWnxBSbtROOT6ytogh1S4bl8gpZi46driRw+jh6wFjs+mr6GFZNxKGA9rzvR55ZKvaezzN+9VrJPOvzDQ3pIGKKfWrTL75R0GYGqrOFt935ds41jiX3QOSGJV9MPCqG/4saTgXo3yqZkhyQ3oYqr9SVjwBWuYPVVYes74f29+TjD2SQsoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39840400004)(366004)(396003)(346002)(451199015)(6512007)(41300700001)(478600001)(83380400001)(38350700002)(316002)(6486002)(54906003)(36756003)(110136005)(2906002)(38100700002)(107886003)(52116002)(26005)(6506007)(86362001)(2616005)(1076003)(186003)(44832011)(8676002)(4326008)(8936002)(66556008)(66476007)(66946007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krZbfmkRFeaEjcJKy2lGFv0fpw7JCdKnCsPbAZmWbav0nQQ3Ss5PTVYo3AJv?=
 =?us-ascii?Q?CfGfGXXk0BqLkxnsEw5JOEDl8Hn7Vkwb1RfXSaWnjWIOMlMMGYoAgPh4IYbN?=
 =?us-ascii?Q?R3fnnu6ScTIUY3FmiSe5AFuFA6OtKuwV+gjfmqBjK3euYchl3r4XC9M3s4ZN?=
 =?us-ascii?Q?7HTuBVjzrOZVCjaMeO4O0Q95SFMUrTnRta0i6ONnfWdE+Mjyw90KHzZ46aA0?=
 =?us-ascii?Q?xcuq1VWbzqWTZbVidUbMMcL0vCHRGvYbU+1gcIAIrcr2iRMzJVlDlVUSGGQD?=
 =?us-ascii?Q?NJqETGxC4XKyL2yfqdR5rOFLFFpiJsZ6glae7PINhDiDBnwLKz5jvrj8cB84?=
 =?us-ascii?Q?5B33yPpica/j+fgSKBhjKJP9WLWrYlJ9ADiq7hAYoBvg2zR9OdJVyPRgfsEx?=
 =?us-ascii?Q?og7Hm+H4gDVpY7Fbw/S/KHc3sVrTAcLPePHTcmNQuUalb25fgZjN2XeII2Hy?=
 =?us-ascii?Q?ucHGrAu7pDT6iHd35Bf8DtpeRXXte/IOe164OufNn1XumAX8f7iyXsXwH1EW?=
 =?us-ascii?Q?suBkAmAQqRXcJnQ+rTTtIT93JXPhL8kN0RGkXpjPCpNePuGNgL8wbLzSn6nV?=
 =?us-ascii?Q?PTb1C3Fzq9E9b69lj8Wa2z2IcvOXPbiYWMBqQyNEmP3rfAlkDlyEf2+4ja34?=
 =?us-ascii?Q?OCCXVFB8ZLzCCZExpktT0bZ0PgA/qa5DoPEyPIJiN7qpluXEJONPIhbKd03+?=
 =?us-ascii?Q?jLZAH4TYDH7ylp+PpgxQS7LAA4N2nSfIpp9LMwk8l5DxVQxCJ1/XnQhOSGUV?=
 =?us-ascii?Q?mTmPJhned5jRscAUpkmF8os6WQ81hizkrbA4pcl1wI9zCt5MHNo0eQZ0bYrr?=
 =?us-ascii?Q?2QcjsIqIaCL5A3xV73b59+rdQi7dALZ6QX6W9GfEMb6KJDtSxo3dH12BoFzQ?=
 =?us-ascii?Q?GjmELHbc5yNgP9xwHHUT/46CvlT71PQkChhvWTWHKNwi6xbS+9cZr5bqa3V1?=
 =?us-ascii?Q?dXjQLxMyzz5gAWD//srX3NrEus77X0m7fQxG3gp+HZnV1FlQkNYv3Hut00Oy?=
 =?us-ascii?Q?aDqpVflncPX8U9/2KqPbwQgwr6I9CEQCr3N9bPD1Y7XJ7U++H8aZn1n0vqI2?=
 =?us-ascii?Q?uR6+vIR9goiy0pD77IyPaTrGdKuV1ljBKA1mapAIG5tx7W5s+JnZuYcLbuyr?=
 =?us-ascii?Q?dlKkTyXedLPJeYpDijOfHORlxLKIPwSRAeSzkPPzsjS8hmpRvU+ll8ktvQZE?=
 =?us-ascii?Q?oHjxHHx0NSu+3NOHa8EKkfRvgaVYv+qoP/Y+iPZO12EqjQRSBAGbT3rvztIv?=
 =?us-ascii?Q?CdKC2CKFaC89PgBbeNnzT5mW0qubmm7yEYxcchddRVqwr7iH4wk1OA9o0xqw?=
 =?us-ascii?Q?b0s8NLXJDuikz+3DDW0vyj8v6OSXmHR852tThlwHlVj4NqfSALM8Z6mZR2AJ?=
 =?us-ascii?Q?B5QAjftuU9RTp5SF8Ypl6B6HwUhLX0xSX+CCWoWq5EVAbA4TmhSTI7Bv5sYs?=
 =?us-ascii?Q?QYwugJzncOLESMjvAHJb6L8GzFXOA5jr4oveWoGRyNhRE0hhsIV6YglvFMg/?=
 =?us-ascii?Q?Gc/MMcvhaa3ygEwu4fP0pkPrR8wxVf+DJi1n/PZrDtza81edTysRu+D28UYU?=
 =?us-ascii?Q?67dx+js3cQJZDPW7Q8qgK+wpr+FvBGHw9T40rA+3EK/3ESLaI/zmE2UkeS0I?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5462
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Chen <ziyang.chen@corigine.com>

Validation of police actions was added to offload drivers in
commit d97b4b105ce7 ("flow_offload: reject offload for all drivers with
invalid police parameters")

This patch extends that validation in the nfp driver to include
police actions which are created independently of flows.

Signed-off-by: Ziyang Chen <ziyang.chen@corigine.com>
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 31 ++++++++++++++-----
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 7b92026e1a6f..99052a925d9e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -119,7 +119,8 @@ int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
 
 static int nfp_policer_validate(const struct flow_action *action,
 				const struct flow_action_entry *act,
-				struct netlink_ext_ack *extack)
+				struct netlink_ext_ack *extack,
+				bool ingress)
 {
 	if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -127,12 +128,20 @@ static int nfp_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE &&
-	    act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
-	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Offload not supported when conform action is not continue, pipe or ok");
-		return -EOPNOTSUPP;
+	if (ingress) {
+		if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE &&
+		    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Offload not supported when conform action is not continue or ok");
+			return -EOPNOTSUPP;
+		}
+	} else {
+		if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+		    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Offload not supported when conform action is not pipe or ok");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
@@ -218,7 +227,7 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 			return -EOPNOTSUPP;
 		}
 
-		err = nfp_policer_validate(&flow->rule->action, action, extack);
+		err = nfp_policer_validate(&flow->rule->action, action, extack, true);
 		if (err)
 			return err;
 
@@ -687,6 +696,7 @@ nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	bool pps_support, pps;
 	bool add = false;
 	u64 rate;
+	int err;
 
 	pps_support = !!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_PPS);
 
@@ -698,6 +708,11 @@ nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 					   "unsupported offload: qos rate limit offload requires police action");
 			continue;
 		}
+
+		err = nfp_policer_validate(&fl_act->action, action, extack, false);
+		if (err)
+			return err;
+
 		if (action->police.rate_bytes_ps > 0) {
 			rate = action->police.rate_bytes_ps;
 			burst = action->police.burst;
-- 
2.30.2

