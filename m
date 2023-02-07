Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63EF68D9C8
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjBGNzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjBGNzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:55:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2081.outbound.protection.outlook.com [40.107.7.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D7737B57;
        Tue,  7 Feb 2023 05:55:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/kxGlbpXNMdcQTuJ6M3Ja68UO2/dx8Ux42gBBfIeVLILUIuZu/I9fHp1eP8WbmnCYz5yYksJMsAU+V/YjiUJbs5NXkOoP/Gju3m3bSg2RzWVoNwoT+HRRNceA9bZ8zPzVEJTOTap4yjXDUVaSdJXAdbsqEX2GXtSJYFJxlWc2f6K5Y6cJBQGBfN1Q4/y3Z8gBPA+ipK3n3UqoRyRnR28QU4A4+lkJ1FyEPks+7DCyCnTzsJPQDisxovDsX/ahXCh3IdSYa7xu99iGA9kBpQJTsJyquCgwyHC7vNcXyTcqzSx19bpwdu8aZWojOCGD97gJbfyCnQgS3IKhZann06eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGPCc0HrFlOBWwNUYy9zVP6x9GjYLQMVOZ6bc3/woHA=;
 b=cX0vogpp/Im+QL2fq4TXxT5/GBvLjMPoxD6M93YgFVGpDv3gqwKY/0IkirJU652DlpC1Tlxw2zrqmHQn0EFZ1WA4rp9jWKsS08osQCRbVbkpbVFfmqWR6K8ZzzPBXICLpJBTShiWz5yG24GLQ8rdp1sjG9tcDRCl17Sk9lkXeoWY6aU3mtZedeSWF4QYIDYCNCmiiivxXeVKHbBun/jHOeOLAly3Z+/4HDOLa4YzDxUMAqPdBQgNqNC+E+47wS+kNcuHPuvdFsar870ELvmEidQWjS8zxHUVh9F1djom8kVRF/uKoyaMhZkpaVFKZCWk8un5f+g3YSqaZ9Y1b9y9NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGPCc0HrFlOBWwNUYy9zVP6x9GjYLQMVOZ6bc3/woHA=;
 b=cuaKGE/0KtexwpY7GpruTJ13cQmHqRFs039SK9A83Pau8DOAzv1N4dbLqhK/86lkbP9kr3nQ/Crqmfg/FcTfTDLbIMCDBbmDdthGaO6WkiMWR0XIpyVh/SViZ+EGWHzxFsccRKezjzKe9+eed/ZTQJD9quKPYsAu6xdIoERZMko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 04/15] net/sched: taprio: avoid calling child->ops->dequeue(child) twice
Date:   Tue,  7 Feb 2023 15:54:29 +0200
Message-Id: <20230207135440.1482856-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: c5aa62ae-90ed-4b21-613a-08db0912eda4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: igXzlynyrJ5FhF9x16TyzzzKc2DDbIvoLLuWCn+I4B5D8AwLhC3fKIX4fTorlgdVivuBrwGeZp7yloezR71VT7N5FEaZHgtF42MOWViu5MtEczM6+qJ/72CeRAE9jtxshWhTleYh6gBRilMf8p39WIyxL5KypOZVxsp0IwtK7Q4wUbDVHrPpDBrHRtwxawZmhCYRpPmqnEf5dmoDxCFQv71uZ+VLyau6rSwc0tldGJbQdGfafo7DWCDZuEbDTo5w7hGw4xxywNWVaPeH+uvx6n5d4ptqUbfXkTPrRQCqgw5mr2yco4u2DwSq9TqcpxnxB7Lb+4L1dNZAdwHwlV+qUjyFGzJAjJW/4piPwYHdfCV+tMM6M9OANGEXVeqtRRt+Hk1+h63o+jxqH2dcrJ+vil9wtf/JS3b/UJc1Eq28xDjBeXO0KJbKIwjPYJ2pO/zH4XmNrDACSHmtlm6aE07XNXC4RJQ4WABHyIsR5o28JphQE8nWzzCVrcRqTOcgLH9H61QInoeMpK0hCHYhQLCVQFiX7kZvFOM/hfgmcGKp+sWkAx4/p0O6mJqwsB/JAazmQKFRljn8vaE04KmP+RGfLrcw3cFVrIiwCZLmVHFK8UeSLtxG8WcpozdrmMaYrKtPH9RwSaDe43z8QKh0vqyVIofVh38t6bfyYHCw/wuC0jq8Mrd+SM7nGunwU5CdritKb3eaDT1rzM/dBo8CxRDWHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69Pp796jHKetVYRB8SjFEqOcfTahwcRze0v4hXE8liLfFgJOUvfy/5gkBA/5?=
 =?us-ascii?Q?f3JoVtth48dAIVBnoxg3G7Y4eulfWVtAoQMuBXspltK6NFR9x3y3LhzN9LSX?=
 =?us-ascii?Q?08/2A8GDOEL5t1sAaIeNRNhq6BpG/i6iJFFhce8rRZ4rtsKxGdvfhnstIEii?=
 =?us-ascii?Q?lohMBJL1XllRklgCIgz7nluVIDFeikXHL7yJ0VBJyxtbEpn+TQ8YaHPcFtIe?=
 =?us-ascii?Q?J3Y4x+PEliRDNwWXaLZKxKqbKHuUdSOP0QqI0g9KtbUSk3epmcNyVY4o8t65?=
 =?us-ascii?Q?Pdi8Uati3/pQn/G9K7UAGWXUolmPdOUXl0DmMHcwmOHjQq4tmFjR5uOtha8j?=
 =?us-ascii?Q?+CTEF5zvlkWSAE2K/pPt0F+dIEeC4y+S5CkI/m0rKV+YbF+qPHoe1q+PQmBH?=
 =?us-ascii?Q?S1hc544cwOON2kYuTNbsa02EFKEHDkSZVk+FfVFj0LhACF51jAc27LMP+9EV?=
 =?us-ascii?Q?VYuatn5/H8YfmOD8QpSA3GyN/SwCowxfOEMA/81Z+PRBSbaB0eIxVoumTkyu?=
 =?us-ascii?Q?QvYA5HRcax0GnmFwMaEJtoRYReBvZAslxrMuoAnknAksVBLK8m4QPRuWwEf7?=
 =?us-ascii?Q?50mp6z/z69DQz0yTK5kan5YU2TYQs1jQSgwYH8MYhsz4uDyDGlcZGscTNjaf?=
 =?us-ascii?Q?gVEcKZ6cqX3tRw7+L9WkmK8xbB4ABzes2UnBCzUcIJsD2nvTRCBey2Nm3sGn?=
 =?us-ascii?Q?a1BRmHG3mzdBjGLWM+w/gvJRlBjee0pp0jFV0hlzW3VMZP4sdUqCn62j3Ku2?=
 =?us-ascii?Q?Q6/b9rw37P97btdqry9PwnSDfhvFe7drYC7aOardI+ey/5Lu+0Q/ClEgrzX8?=
 =?us-ascii?Q?W8ZAGZScJ3OAn5ribP4xI1z8XZQ6x0Nrk7EKzrQcVqsO97aW5XXJqIseHjlF?=
 =?us-ascii?Q?+ceCN7s0ZbXuOnDmGurQ6ZA4xvDt5NdL2Ae37si//yvrXgBZyhPUldoAvdVP?=
 =?us-ascii?Q?bRbOjE6GEsfXoCfpDe1TsNQjkFAuHpEX/9lvo5hx22MZsTJFuJbth2g2j4KZ?=
 =?us-ascii?Q?z72fWtiUj7FjTRV7NeyC6/WaWu7BvmCNPfJhZHxVeKDFdscD+fqGb4WujCuC?=
 =?us-ascii?Q?0xDRTKmR4i2+sbHKuvZJrzEFjc0ipzFFUi5EaUlLjGhiXXpF3jqRtC5/ytpr?=
 =?us-ascii?Q?EpiO168CDALP6MhuN80ZZklB8FBKkDTLa+2p5sVuZ0Y1x7cRqqJmOJCdYr1B?=
 =?us-ascii?Q?uyv6lM71LJiG6cAKNwa87IRXTFM6q9NnyQ0Gd6spB+DRYbBY+O5yTWI4DVc8?=
 =?us-ascii?Q?5bkJr1I+dKhSoxIG3gzeoLa9gcktgLfckbPZHGu2OQEMHvgpRvccCg5AKILm?=
 =?us-ascii?Q?C0nbk6VYZzr+k+xFBIYs0wOAqaGMwVChZkDcCi1xCJxuKkhwFoNDWzqVvxYN?=
 =?us-ascii?Q?rje/SIqCsf90rMUTZX4UiHsqJo0pndpaf0BT3GHk8mHAcwDFcSX3VnNFTnul?=
 =?us-ascii?Q?TqGcsMhoNOTh7JDfDBBUt8FZLdssBqiO+IxOD3v4X2fh28wN/iA521bz5+qZ?=
 =?us-ascii?Q?XmLiE7P5L1NN3Ixj0JeTBZw5EDbS8MbvmXpQ3Qtjoko+RCOFn71rgR5wRjpT?=
 =?us-ascii?Q?bjA1fa4MQRGpEiSD8CCQ1Ih/MhbpjMMYTPFi35cl427P9ESZ71Xhz+BpYTQ6?=
 =?us-ascii?Q?gQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5aa62ae-90ed-4b21-613a-08db0912eda4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:10.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlUnC3V7+OEF51OieHrwdJ8BndOTEQNMdXOzcvQEKvQlx5r6JvDTrvMJjKXjIsReSxCHOL3uiF6GGTVVM5AlKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify taprio_dequeue_from_txq() by noticing that we can goto one call
earlier than the previous skb_found label. This is possible because
we've unified the treatment of the child->ops->dequeue(child) return
call, we always try other TXQs now, instead of abandoning the root
dequeue completely if we failed in the peek() case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: none

 net/sched/sch_taprio.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 272a8b7c0f9f..a3770d599a84 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -528,12 +528,8 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	if (unlikely(!child))
 		return NULL;
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		skb = child->ops->dequeue(child);
-		if (!skb)
-			return NULL;
-		goto skb_found;
-	}
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags))
+		goto skip_peek_checks;
 
 	skb = child->ops->peek(child);
 	if (!skb)
@@ -560,11 +556,11 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	    atomic_sub_return(len, &entry->budget) < 0)
 		return NULL;
 
+skip_peek_checks:
 	skb = child->ops->dequeue(child);
 	if (unlikely(!skb))
 		return NULL;
 
-skb_found:
 	qdisc_bstats_update(sch, skb);
 	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;
-- 
2.34.1

