Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE35E7FDC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiIWQeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiIWQdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:35 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD6013F2A3;
        Fri, 23 Sep 2022 09:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIC+anRx86GJXY1TzD+7g8IofpyJcxpuWPwACEl4dqkR/IYf27iBgSvTjwKkt2UY5bLaqAXxeN/i1ZSG69JDPLnvRO+5pxY8bIZTnxPXTCGV5wvFjvn+QJHP/D1UXNiKn/63XPlqnNHXKj7TVQrxSSaiwVUrdC/ecTXgajl5/BioU4HVWFJJwrQnug0GMLrdvkLIvOFDcR9O9OVpZfOJY8E71qv4D5/e6BIUPuOEJs7jkPtWQElmOh1eGZLfVdkzV6bZygOqq3SylfYJTXvTpaA5+PpVoexMFdp/F7kqjJuSiKLi1bnzsdoIWZyGZUIr54+fmAOp6VNZDCb62uzjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUjX/LuUdguQ+awPauiylJgRCMwFHy6EX+2eWNmipac=;
 b=PN7FP2g+6XH1CdyN9a48VWtv0RpAz4FNtttZCbceCFjCQwo3uJwC1e/34k0UDEXJ8t8z3q/rpGy2Kou76Ycv7HRmn0ntJJET6+86YdEbZOXZNyNavxFtDOMJuLmitKrnlGMk9/E9WaOHwc+CqvhtwEctEuGa/9cY/9gpr8bAL3H6/0p6PsdJhvrC1XYe08G+idqESPysx82Ea2SbdX1Xx4/XVhFY4JiqPee5QQt10p+9erKN2r+B5VI0cK2fq1qbJL32GdXsXMq8cyKQzlg1p7JffglE3858Y13xQmw8ZzNQMCx/M3pbrDGOoFj1k7G4tihNL7hXk9onYWgeR+Fk0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUjX/LuUdguQ+awPauiylJgRCMwFHy6EX+2eWNmipac=;
 b=hLfbnoxZop4B19zXUb8kpl1lxpJu/rbYBAsN5XuimCBk9/kzSrf1A9egFTwF2kovXrJtZRlSPT16JUs+0l4GBeRTE/M6TXuRHcRnSp0H1qmdxdJflqbw0iALUWvFC6RxNV01UQ3q0ckZ+TQW0rpsmilMWqgK7d7QNwDOXy1qhSc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 03/12] igc: deny tc-taprio changes to per-tc max SDU
Date:   Fri, 23 Sep 2022 19:33:01 +0300
Message-Id: <20220923163310.3192733-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: c7e6b287-e209-4f5a-f0ab-08da9d815a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YbEuYPVjZT2/zun0SqGqg/StOpP8ojpzteLRL4O3ffJDUJ3bybHSRfaMT7mzmPaaL1WUFr3wk+yqqOB7JU9b6sQhNd8pnXJbuJxfDnYFB3tjl4/TsJGpUVaopkF0HRHsCwLuqQw8oqAecqgRyiM460Ymcn5IRYYzHQ3wb3vTbWeeza7WE4ATu5pOPPaLaRX3NlLok9SsPW26rKCNfnW12lqLhiZAScwRBpgyodJtJHd8xfbLSDqdKuEj8JvGkUgkA/XTEsfMMDzRoAjELU1VEywb3AoWWKn6SxvmHay6tCpEK1vuZ7Ae427/TOq1DQZSgK62go5ETk2ar8RtIWQ4fDfswGaJr5lHmPlMG9CG4vp9fEdoJTdngLvUYZCPEY7sdv52IKyWyxti4olS8jE/wC3jsm9rK/WOBGajNQTjVDoHi+wrQKNZIE0NsmSG03iDCN6eSLXQToCkr8UBoAjRg2D/kFg7nzvHsC5724oLIV2H16IMYfbimN5+1HuEPXiw2V2rJP0BM025JZaaFpVlKGUWQWvi5iUnGQNFuj6r4cfm18bL/eFJLYFpUEvF4BEBTp1IWhG7xn06uMTBBATl/14oFmtjq3OYbTXqy4IdjMRGSdGwGZPrKToEPs30vbSJEZjXFUCEPS/cw6BOh1XTSCl2Mlp3wyUoPN9kE44VDQpkazzHhzvF3PM0Aacnm6/9q6vztBNAA2Sx/Axn2ZCW0szwnEHuGA9YYM91C7h/cphXaj6Ny86r2ASy22HhQe+/fOlSphvi+TbAaJ+c45siMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a7kLhEP8n4ApgQnUTUCkoRSUsma9liiE2JJ959kD6rvekXI31V+v905QpcaZ?=
 =?us-ascii?Q?9xS0Qy+PT4X/wNxuDcpGN7Nq0CxLw3eDDKMaKZwO3nLlh3vtlGdtjCXAt/qH?=
 =?us-ascii?Q?gJMi+/S5Xh/vCgLAct/wz6zKFpWYDpHifjOe8BSXg8XCYuZbWwAteEGcCJ+m?=
 =?us-ascii?Q?QRWkW0SnhmVYz1amXg2tFZRj44g6uBn1tfr6Q2orjoQMkx4klGT8wH177Aad?=
 =?us-ascii?Q?5UTkDXR33xHj28af4E2X3rLvFER9zCwTQTEC122XR9+w9sOvn7aQ/m7c7LRN?=
 =?us-ascii?Q?qotMko7MlWj+I5Wx2YpyiS6bMoOQ9sRzMcY2FfRMfwVnKaGwnziHIH+Mkbfq?=
 =?us-ascii?Q?xO5H8onht/BKCx+gEqICfOSmyps0cMYWPlYMUdMjeqp+aUUZtTMHvwGcTuJj?=
 =?us-ascii?Q?7T+8+YvsJSy4xG/ad3hKhUO1hEC/c5tmrUApBnNh1Y+YZyTZ3OTTmSV5E2Br?=
 =?us-ascii?Q?lOLRjInB2ypL0/e2JAMnEGkr51PpAFHN6CgTeVIUBwl/U1fB0JE4NeWpT7zV?=
 =?us-ascii?Q?xr19iFY3A8tL5RLBHLUGsxyfvSTW25CoeeTT79rGTtAC/W39gHhfix1GL4p6?=
 =?us-ascii?Q?V/gRRhDdfkx3u4uzgzSOGg5L3tRJEisUB8ymiOPWfqcHF+io9XC5MwNOtxSx?=
 =?us-ascii?Q?X7j2ehfr/dsHX5uU8S5MUScGAN61J1DhXo+F/RSlYVE1+NDFLSTFI4G2+yAH?=
 =?us-ascii?Q?jA/mwK0ZtXavwNMbrmoQsRMptX30eQBBvv3+2Zu4/Ie0BjlMBnxpavR+Qk3c?=
 =?us-ascii?Q?5HlogcndUEm0kmRGm7SaKv4kpjFr1vTJ9QO32eSMFbpsSoHd4TWB8wIVe7Lw?=
 =?us-ascii?Q?+7sTeML+o80KD175uEYYs/+5dCg8geUkYL6MEJGXaBvtW6+nHOtVObnYyw8a?=
 =?us-ascii?Q?46ElHdeVfinYSCdbzHKDEYvFggha0+tiKGyH3NEd5o+UEgENpxJp03opMAyb?=
 =?us-ascii?Q?FNWVKupT3Fex0KiOQ1Dlg0DU9JOEigAkZNtwdEt0wOoyJ6Tsqj+TzT4R6QqS?=
 =?us-ascii?Q?WX53CzyKL8mpUskN2hVeQt5qJBT/G7QakcWLz9BJxNA6MWlAco9T0NDn6T+1?=
 =?us-ascii?Q?lMG+8i+vrSmhH8k+G4EYLwIx1nyofpK0l93BONvDfzcfx+628XIzIExvo4zP?=
 =?us-ascii?Q?x8m3c189qDB4Bj4MeB9D+hHBpdYrvYAuRCKn43W8XuW6P9q0oviPsKAOPITA?=
 =?us-ascii?Q?c01Z4ZE9Ucu2NFDxturERB6JEarb/tVYhZfbqjyOd61IYpaeDSZKo8fGVMA0?=
 =?us-ascii?Q?IlYdO22ozGDhskjtVq14tgTLIveWutOOBcSjs3YS3LbthzwIuSK1NEwe9PR9?=
 =?us-ascii?Q?vIzXX2aSby3kxUq8qdobNs76AkJXdQHsTHbKprw1tm6WxHRfhDhQqsgB+253?=
 =?us-ascii?Q?hxGY2kNEYfuzlm9JrACo+BdrW+Z5NZ98hM/CVfFArQfz+dp+cA4V3f1K0Gr6?=
 =?us-ascii?Q?kU0R662O63L5CyU4f4MCcV9GN/spPTsbk3zHObCpUq+p8ksKMmaLsCO+eSf+?=
 =?us-ascii?Q?BFJ91uU1hA+H36mjAmMJjvEqCmytjIw2Tx5yw5F2RfgRNPlL3OED/hcAgSTN?=
 =?us-ascii?Q?6FE/qv/FqznK3J8B4t2Lp6mmqMQghvHsxNA1Z9QiWQu4QfiGVr33HJxAIk0/?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e6b287-e209-4f5a-f0ab-08da9d815a07
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:31.5189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Z2jsUWFg4ulAByrPRNd0zYBHiCISEoxwLUkVQZEzoZBI3WbovDmkXN/8uzkcPLIvaWD4z3uD3UIPmktz43Mcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/intel/igc/igc_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index bf6c461e1a2a..47fae443066c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5965,11 +5965,15 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 					 struct tc_taprio_qopt_offload *qopt)
 {
 	struct igc_hw *hw = &adapter->hw;
-	int err;
+	int tc, err;
 
 	if (hw->mac.type != igc_i225)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	err = igc_save_qbv_schedule(adapter, qopt);
 	if (err)
 		return err;
-- 
2.34.1

