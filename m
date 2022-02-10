Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877A54B0454
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 05:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiBJEPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 23:15:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiBJEPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 23:15:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAC05591;
        Wed,  9 Feb 2022 20:15:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goBu0WqNtqRpRZIg53BYFwrETO5LgbvwHbSU1cDmvUSPgRjtKYtyo7Ifscd7i4j83Q+yFOi6EwwR6AXvgRHs2IT1R6wnICLfvlpER3wJot7gN78i5yPnR8b3L2dFoh/hnxnDBou2Pkq+eCv27sQw6TDInazzu0oRdU+Xxef0EV6sMx7q4eWhl9xXe9lV+euwZGPCW/IOk8PkjunDTTGk1VeG+I35laQyQ96/jWhduT/I06sjNarlAdVa1wYLR8P/tBPq4mRRJJbraBtS0fbqmCaQw+jjfALVMi6h2mAUYAywu/l3y2gTSBYlHp9eDfdC8CqDZVoTl1ZkUuav9x7oeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4aG2oIUQ/mI7G40At3g+APWfeyXJe5mF7JaV+F+KQ6s=;
 b=kqNgkw1/7cacLN1DITOT0NBIcXm4pjOJuMLV2jBQQ2dzSh2kZSyH+zUMbtgx3n4g5cYTpfDav+aJ92D8ok1nX1VImTLqa+VFtpp19+kkJDWrSy4ujiG0DI5WGCOGYms1v2nOyCh/IwAfQe30xycN74g/0h0AxU+/t6yaZnoCRw4K59pgQvfrUZdC61kD56CAf1N0rVNLFzrJCTzVCwVY4MuGY4x5KhgK/R6kV89lH5+v2qJsi5LkjyX6zwt/4wb754xS7vG2H7TLwHKQCmLvKVFv3EGRwejMU8pxvb3XxWZL2J66HreND6IKoLWjsiOsh/UvIYodMWHYp134H+1vdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aG2oIUQ/mI7G40At3g+APWfeyXJe5mF7JaV+F+KQ6s=;
 b=NsxGzcsNUT7nBJJHQrD9GhqdpajgXcq9Kl/9Ev0OSeZRroweuh4l/q2O45qmXMhxn/pnHZoD7z/rxYr1Ffha3t9KPsgGhB9ceTWw92oSPObLuA3U3fbBezz7/cm+V2++B1cJK6pthakInewnaUxOIc5x2+Wt08NKQkcosJScUJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN7PR10MB2564.namprd10.prod.outlook.com (2603:10b6:406:c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 04:15:34 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4%3]) with mapi id 15.20.4951.017; Thu, 10 Feb 2022
 04:15:34 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v6 net-next 1/5] net: mscc: ocelot: fix mutex lock error during ethtool stats read
Date:   Wed,  9 Feb 2022 20:13:41 -0800
Message-Id: <20220210041345.321216-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210041345.321216-1-colin.foster@in-advantage.com>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b184d77-46e9-4dcf-bdc1-08d9ec4bfbc6
X-MS-TrafficTypeDiagnostic: BN7PR10MB2564:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2564A5234609696C08BF385BA42F9@BN7PR10MB2564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lm0nirG4HIOyP0crUpvJ7KsZb/k8KCQ/64J5RHIA/YCy5BN1UKrscBHo6bhEUXAx0slPl4bLId5xBmsEBpW9C1rQZ4ZHnp9rNg0EuXpDd2bpx+nTkn4nLu+VUT8MdcaEOK+rbDogEnIeAr46yQ9wMNjxanm+oY5YHJmNKj+QPE29jpSAZSYCYmCN3Wh+5N6xUrRWkA+aVUSDnU+AgDYJ7qHtYAl4FZyupEXFKHYGV1E2dOp80j0J5nszFGhOuG4CfgnW8L8sB8crhWfimqp8WveMtO9oymgMX4Pn0DiBg+f9Ywf0cj+anBLXGNdqZ+U1o9reZ/rq44tL2A8EE2wJhVNJL2u7VxofmXoJE+vQCxaz2up9X69M3/uJbRSFRuambnrrxGH+mFOEgWnXdJsg0WHFvyYPsbcuEMWwLUHjJpwz9su0hUGsQvowaTVGZA/jgjcb2YA2TLNOHJiT+5zo1+nAD5II1/toaL3jh1AmDKqy/B1o4gdORFwxfTxnY+NPmUQjd3OKllIhASLFoIMkskyz36+9yjsJx6fDFTdl6rDVPvX5nwNmdChqaEQ5zWekEFTqQ2B6yDYSl7ER20fIABUeUi8Yfm77kegDZzcivoZ/NEc3E9UOC8NudBTiG2HvEEQ6e/7dxg6+Q4GI9KA8YpQtfeGKop7TmEq/HOAl11t/5swPUUl2deqER1JQof3fi3mKIwgiRJ5ILwA0h8Ldjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(42606007)(366004)(39830400003)(396003)(376002)(136003)(316002)(66946007)(86362001)(508600001)(8676002)(38350700002)(8936002)(4326008)(38100700002)(2616005)(54906003)(66476007)(66556008)(5660300002)(26005)(44832011)(6486002)(6512007)(2906002)(6506007)(6666004)(83380400001)(36756003)(52116002)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aVeDfyUUkcTkHkLUVkrijv6Nt98EHQUhUL8PjoMhRCqVxXSCP4LVAecYIWey?=
 =?us-ascii?Q?kXn1ONT8Sc88swK/UYLGiOydF+RGCY6+KDLF8kctTii+efca2xhPCw/+pC1B?=
 =?us-ascii?Q?Z9wNv/onzfYtQevmEXLKuzmLy0v5gJrVlI3Fpz95sygxJRVLx+6NgpU0ll3C?=
 =?us-ascii?Q?Bju8tK05Bz2fxU5NzK+Iu46AjAPP9Ae06eSusUtLtAcuKpHXG2DgHhV9JLHF?=
 =?us-ascii?Q?lZ72FcHQWTQF0wF1wQUlYNbR+s1uBozRmUnChrx/bsh0haQuOoMqLvqVNVqA?=
 =?us-ascii?Q?BB/Z3NNHh94UEqtSM1aJsQsHkWJoFRNo4l+URazDWTNY7aE00wwvz5IyuJJg?=
 =?us-ascii?Q?ucO9t1zVEzMkhRGi9D4u25VUQMM6tyc2iMGple5kuom5bhh9vsUOYA08yCxH?=
 =?us-ascii?Q?hxLs5LBdL2OtPO3awwHM6bP6Pg9mJ4rWjbBLwr+yqRAj07n41gX+WEwMRmZ/?=
 =?us-ascii?Q?bkMdOeqL/SBVUbxDebfMgN2EI7kXBLIw5JJvw4FVAb1t6UtKZk5bmgd50wHe?=
 =?us-ascii?Q?5usjSMf3coVob6ZSz2nOv7A3lRslbteibfGARTwszwwWjJuk0dynQFit0CG1?=
 =?us-ascii?Q?lAXCLaPtfg2ltfK1rATN4UCM5lDk3kie65eMtLSHKAwLNKEQeNLLkhhp4zHS?=
 =?us-ascii?Q?OXGA1nJ3AQ5BTBWgHkPOuEBza+OBzKwXYLiPyWvENNHKdqOoPVtI9LmF/nlG?=
 =?us-ascii?Q?6KMYdUn8yDuQ7WbrAvguahkM1GL0vA2Cfzf3s9vtMQ5mjhTvLTdrhROw3YdK?=
 =?us-ascii?Q?BjP3qv6LZySVEyZBwwH886yqMf6qp4yvNhIVSqVuQ542PY3gDNT2BtcUlAir?=
 =?us-ascii?Q?YzLuSXAUyGq3eFrqMktPlN4G9FsQwwkO++KEGT7tlw81zSZWd5YxhjtOR86e?=
 =?us-ascii?Q?INqoX4eb9eN7Hl44kPLIkbSeuObIBptGA287Em1A1W5+lGR71FOXpvC8UrC+?=
 =?us-ascii?Q?XolLc2XfMkLv5jKX/Y1Z0eH0adPLPqssZ/aAlotxRpxjWA5IwmZL3rFfCoLX?=
 =?us-ascii?Q?cJuqyIQ5LWWN7uPMZ0arfueZR/isPAEo6o1/YolM2ZtovSE/vs/EQIqAjxdR?=
 =?us-ascii?Q?NIcSVPiq8eDO+0WE42wjDNhfrsjYM/UqiS2HLBzm09efsTQjJjXNShLUjq2l?=
 =?us-ascii?Q?B5lWhsaN9wZKg9jgUHOYqaqYIHX21dmHrlUWI/O/OPBiH4PY1YkPvPU3gb5T?=
 =?us-ascii?Q?6wmOX3gCb4LBN4/wYGejMMjwEYoiar+vcOgcQICB8Brq1xPdm/BAlGMHRc/Z?=
 =?us-ascii?Q?33Fvps/aCqI/GXsMLoXLadrpOP4Er7karRPjGbLKsWyT4VcYMjNs5pEhwMGu?=
 =?us-ascii?Q?IlRIgvAi+igWtXdxVTQ8Y/J028eeYDwNhNW2qwOJaO2CXseeGQKZqg5sJeVt?=
 =?us-ascii?Q?tG6ns52W3t40v2eWgOSljb+9VylcGpUkdZDh5KPzXkYSehjbg+5bMQblkcVz?=
 =?us-ascii?Q?zCqF6zdrtHY3li8woXMxk6F8O5BAUuLpfovj27pk/E6Op1lxJCXnZXWlgz2A?=
 =?us-ascii?Q?inuJV4yWpoOJL0/YLmITg6J1DJ5zQP2oeG6pfMHGfXEDSqzs/S39f0ocU5tJ?=
 =?us-ascii?Q?Y3JhELEX8lFOXBWHuMNNkTcCE4tvdChNeMe+wFmu0D4dufRbOwJJCoYVuNIF?=
 =?us-ascii?Q?g4HdleeNN1a4ojbPRnVKOkBjYltemKCkZolIbYWVvSAWMdFwNveq+XzqeHQR?=
 =?us-ascii?Q?CaVbngZa6pr3+575qQ8wtjyshYQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b184d77-46e9-4dcf-bdc1-08d9ec4bfbc6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:15:34.3100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eegGckG9wKtdC4q6HJSw8wB0zEC3IPlVWSYojEtp/NQ2SgNj9CnkuDY6dNmBAv/jNVzKaApihLYyD2Hkqc5Ukqj5/KzCOhOdxQ/Y4VDk7pQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2564
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ongoing workqueue populates the stats buffer. At the same time, a user
might query the statistics. While writing to the buffer is mutex-locked,
reading from the buffer wasn't. This could lead to buggy reads by ethtool.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Fixes: a556c76adc052 ("net: mscc: Add initial Ocelot switch support")
Reported-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 455293aa6343..6933dff1dd37 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1737,12 +1737,11 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
+/* Caller must hold &ocelot->stats_lock */
 static void ocelot_update_stats(struct ocelot *ocelot)
 {
 	int i, j;
 
-	mutex_lock(&ocelot->stats_lock);
-
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		/* Configure the port to read the stats from */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
@@ -1761,8 +1760,6 @@ static void ocelot_update_stats(struct ocelot *ocelot)
 					      ~(u64)U32_MAX) + val;
 		}
 	}
-
-	mutex_unlock(&ocelot->stats_lock);
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1771,7 +1768,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
 
+	mutex_lock(&ocelot->stats_lock);
 	ocelot_update_stats(ocelot);
+	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
@@ -1781,12 +1780,16 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i;
 
+	mutex_lock(&ocelot->stats_lock);
+
 	/* check and update now */
 	ocelot_update_stats(ocelot);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
+
+	mutex_unlock(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
-- 
2.25.1

