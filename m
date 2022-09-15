Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56275B9920
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIOKvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIOKvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E045184EF4;
        Thu, 15 Sep 2022 03:51:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPgQCL2kkh2jlR4AYjPYEGnlvHL/foUUsPw40Y/pp4iiUpi/i4aoE/vyfJIjdX2hDVaFZOTSwEAQVSZW7xIFvgfd2xSEkRo7xzAGySwWC28O31Fc//5dkIhUR4Z24QMrgk0ztxUtorHzWVbNTr8P1pQfWx6Ny8Qcfmo0ZdGZN7BlVZYNOmrC+E/4Aj3Eg/VX11XJrBHxpO8Hdda37qvhIU8LdkUA4ZCgVOW4XHBDeUh3/NQRURUq0HOOBQFV/6LU5Y9x2rPmmY8Z2Nr+8/0teHns68rJvls0O5v3UhddDbnmhNr++9lfbTJsWnu3zyPrrrpRytnkFxIBy6gkR48rKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7vWmqTyuHABdbHofeJRh9DDAJ9waMiZ4sTIJZGOujo=;
 b=L0xekYPo5N3+ZJ7EwtE3pon2tvcUaZ9rCrwb6ZaaMY0BmKIK8b0OumTS3Bz6UEKog9E6u7sNLrBdDw5lCcyBxH6/SV+PLVI8S7oEZDkgqtcQcXKFFItt3+dzz2AlSYLW3OA7A5jt0SVQWKZDPxg7iub4g9gScGfNnHtvp6l3iLIcueHdxE50WONdoBqeG3DBiBNY31+vSS2yE4L4iwqH56cDg0M+CcssCSCz6ID57KxFfF/v23tfCAGsBEtnIrerTGj6vYjaW+Lz1t3RcegF+Al6eBKIHvsoSwyukSJm7JoROoYRVSCqewOjLT2rcbnP69tXmjSOWXZpCpIeI6X5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7vWmqTyuHABdbHofeJRh9DDAJ9waMiZ4sTIJZGOujo=;
 b=a2XEisNE5cKqRcd/jY21dRQROAIXvyqWigRTFeBxqLTrYRVZYy5YpLa3NYtbEp+aAEcNNWC9Rj146yigrMjGYCh6MxSABd8oH29pQKv28wKsI29wfh6VnNWCv2cLJt8E3lzB6hnEw35T6Ds5nTDOzDd5o8YNCJFIYElFlcov3Dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:51:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:51:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/7] net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in taprio_enqueue
Date:   Thu, 15 Sep 2022 13:50:43 +0300
Message-Id: <20220915105046.2404072-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: e5c8a6c8-95b1-4c40-d837-08da97082d07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTA5ZiqueW6LtFN7mA8gpVvMbo9itloyMon6bN7GxhVTKS7cEP0IyEbDc/VP+oyDRnbz95wsgBCcluoPQXXQCRR/fNmPs1DZ64IqztKlmov5ey325anf6Vovs/TM6/W3eYIqHmAOmaleJaB9mWwIkYAJC3WEXTE8HAjDP4zDx77KUqu6T2M6iZIHwluVPy8M7jCEEYaXFahSzUU0SBM+oSz3cqY9ebwNxY0luivDQmJ5keh6NXBrzGRgnsG+J05yXirUV1DzOc6w9rB/iccLnlPJelV9R6rhCLTtBOIRZUgje+ZIUpiJrLa75jGjxrPhKR7hWv4xuoGUKRbxI0C+W0TXSl8a0sjoPN5tW/LS/BOC47pf/b1k83Ku1QG5PJOZfSxRM9wIxV13e625WgNKLkIlhxShHaw5gdCB7LMz0769Sp5YMqEHmlMb+gBtUbwoBv9G7mSNEddrPXVewdLEyBnvOMtir0/WfJlOI7qGpDuSdpligG0LZ0pz7iBkivmS7VZr2A4zP5zKsr1JnKGSJOLBmSzBVjZh8SxC9y6plIGRjydAWOwjB2+60tf4+yvNVUvNPPslR5cQY0ZUt19mkAgtWVxMLpEWQlF7U1IWxig60TAQts1qfL09vFdM7PF8A7hK0eLP4U9QdNDm7S6jzqVgHOGRUrwLlIicEwRdRwTNieaXjudlwGuvy+xt3+d6ko9exXHsPt+oVnOPWv7/Elgi6Zfe6Vu1EUQSAQQD0HfVvx7LyBvQu9DTsD+90jiGgu/zTNOl0BVSt+o1Eu41zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j/Me1ms+c78cCjObURvKtwK4oOEOWUQYB4lIoFDrFtxdZx5TrPRTFgqKCEnm?=
 =?us-ascii?Q?ak2vATv9ZFNXsdpViMfqWK/VTvuYkxW1RwCDN20bU0vWU94GEjUVwx33x4bF?=
 =?us-ascii?Q?7e8TIHY11fG8pR/mUgONkkHMi1Jqjgvt7sz/RRdRKMEe56Cqe21P0192S7PC?=
 =?us-ascii?Q?z50QGMRrlPcf4boAXiLb2UIfr8vrzwFjTethigfVV7IUPoqr/pCgkQfc41wj?=
 =?us-ascii?Q?wtQZx4U0mxUnYpF2LV0zfCjCUc2dP6+gF4rDuhbvlqqvqHNEMMgzrY8ulB/6?=
 =?us-ascii?Q?SOGA4ci9D4tgR+nzkpyfpWy1Ynd6/DmWnrfARjevTbegfEP8O0tT+wHkbTTG?=
 =?us-ascii?Q?EY3eAxN/NYb8hxWb4WbWgVyHF4yk+9rRxbuJU+HNLBG0Z9vsxoNfJOWRzcce?=
 =?us-ascii?Q?zb/5TrTrNsNs09rV+HHeVz/y0Y/eMlAmmIrHq/AQu8HvssRuAZ5DL/zg0/mw?=
 =?us-ascii?Q?UGg6LvmJJ12/b8+gcHRDjOAY/fZwjbGMDG743fxHgOZd5oV+l181k8iNAvZN?=
 =?us-ascii?Q?Z73UpdRG9fEhgAca8bYuliCNWqjR5mM4gY6yxa7zrf4NtrKLHpT99gEhAWvm?=
 =?us-ascii?Q?daopwiH00wWbMXszuw7IIokQzQv8WeITlHmdnW2a8bnXXSHCC1GIZRJ6x6vX?=
 =?us-ascii?Q?baN5K9a1ywzfsbUMH3My8TgoZwEZGRImXbKYQb+LG7+/xCeVahIu1Ir41VMW?=
 =?us-ascii?Q?VnIhPm4Ungi/fnww/qMX/6GxmHLPo9UN1QDJMyJN7xcG5VHQcXqX6sM7jvNW?=
 =?us-ascii?Q?uCjDxSkECEtAgPigWE6146AnxNwhIAaN3G75A1GLyFSik8OPbocT5APtu+q4?=
 =?us-ascii?Q?w96olS37BYxrQmQrGyUjkW4Ps0kDM6dsLic8QXxzg0fEoZT91pzv58jlKhs4?=
 =?us-ascii?Q?0L+8js6vk5PKn/fnZzkBD+KRRA0Ky6ojr0+JWIz9+NNeg36gxDs6JhnOVoFH?=
 =?us-ascii?Q?5J821ekzGFsbURFTfnIRh5RptKQLrayiLKsOvXeUVo2LCjZPsncKas85hQEA?=
 =?us-ascii?Q?PoHYJjNCou+EJgskv+WvfOT7RJVQlel5ipdpJH2S37xms1rTNLb4SFupNgnl?=
 =?us-ascii?Q?UKEbzvmRMuJTOY22mhLc4tEipIETNxobxnYFF1CyO8YVQbftgHcyhjNBHW1u?=
 =?us-ascii?Q?AVvMWZ0D+Bj35pBIyEIWzkfGnxrs5kpVxZ7vNWMBdUOFOXzZJOSdvMtUZxbk?=
 =?us-ascii?Q?8Sh6dyrm8NGPym64Clp5zL/bHNJ5u7t8IRY+MB7XCYovnZgFHzBmG/iuKG1q?=
 =?us-ascii?Q?CVCsjZpMJb1WQrbH/tWS/0+Jtunvt2kX5M0K+VQ5n1pNbJzewlO+1E3DQaEF?=
 =?us-ascii?Q?Z3xKWVTliF8P/Zlp5TSF4RxyrHs8RHIaH64fQBcBSzi8Jkxt4I6Wm3R/BRhI?=
 =?us-ascii?Q?vrk3k/8azFLeDNjNplxykKuSrLC0nO+XHW6moMUTx/J2PDUpBt6UeENTWk8c?=
 =?us-ascii?Q?DUFc0fw+/8o5QG2L/SEinbU+F79Jb0Zg7sx93dLydhchpWoMSgJc292dlsTt?=
 =?us-ascii?Q?YjA5bmNCTdMdByoNoaKuaUA3NZEOb++WkX1QHFiKyMLacR3BAa9j+ocu1H03?=
 =?us-ascii?Q?p95wfYH9qA8BoWGfP9czU8GPH7DgRnmrd97A7UwOI6YIlKE60qiF+BYpPwT+?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c8a6c8-95b1-4c40-d837-08da97082d07
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:50:59.9086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFoROgOm6UjXggnW8ZWgUkWkfzZ4fVjFAUHayHDJPX4/fpIRv/e03oySmd8k7VYV1tEGVbb4xYrN4o44d9s6ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 13511704f8d7 ("net: taprio offload: enforce qdisc to netdev
queue mapping"), __dev_queue_xmit() will select a txq->qdisc for the
full offload case of taprio which isn't the root taprio qdisc, so
qdisc enqueues will never pass through taprio_enqueue().

That commit already introduced one safety precaution check for
FULL_OFFLOAD_IS_ENABLED(); a second one is really not needed, so
simplify the conditional for entering into the GSO segmentation logic.
Also reword the comment a little, to appear more natural after the code
change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_taprio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6113c6646559..0781fc4a2789 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -455,10 +455,10 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	/* Large packets might not be transmitted when the transmission duration
 	 * exceeds any configured interval. Therefore, segment the skb into
-	 * smaller chunks. Skip it for the full offload case, as the driver
-	 * and/or the hardware is expected to handle this.
+	 * smaller chunks. Drivers with full offload are expected to handle
+	 * this in hardware.
 	 */
-	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+	if (skb_is_gso(skb)) {
 		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
 		netdev_features_t features = netif_skb_features(skb);
 		struct sk_buff *segs, *nskb;
-- 
2.34.1

