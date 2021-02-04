Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DE730F898
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbhBDQxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:53:10 -0500
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:15142
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237972AbhBDQvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:51:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J71zhvIU2GPc6u5YVV3T4+iAxBlSjwkV99bPSEczeH4IFn6zul81hj7jUQLbJ9//6nY5F9GRYDBOU0I/sNWWEhFur4fK+TaC0JwW8A7Pnopxr6bQGD9JBxZ3xM/bKGePDzK8/G0YeXoWXt1TNagfzjnD0A40qsvuoF7WJBoARCJlNm2z5ZiZfO4hHLb+fYa1XJAc8yw5i8prNZJNqmhlLCJOeKr++s/jbXbQiyGpVlps6IG4LdToqKCUv/tG+8Dmb42syT08QtXm9ErKPqfgPFJjhNkPG6VPg9LTCfk5MW5rsEZ8B/xacoLpjJ+EW4u/hUxCtxQ5+U7lWVC5GDXQyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlSFdVxF65blLSJjmAt2GnWzbPP5XYHraLn4Zi3bjE8=;
 b=HkGg6nK/hf8MCruuR0s+ZCNmJyTVHCwLLsKNE2QFWglzUHnDlsVCfD69IFbTJ9I0HsDGJKT7OCt5AcXoWu/nGxpJIIIq2nzSOGZ6wYSlOyNPRtXgp2/Ot+moZb/y869BiOEwVw76N7plCYUStCnFSAFLwE05jG4ZWT7IysHBsTrzqQdouqdrbaeTSoOq+FPJNC2EtD+Q3q6gj9gdVKtZXDNmgQw5oxtVBGyE3AJGp/75gen3nNdqooZFz35mNsMVHKBuQG6LWrHwADtmxI/rhOJfEmm35f0ajeUFHNOpyUAxKkfgjf+2PJSbpLjZMGf/laJrcvnl/ZiFmVTGFW0z0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlSFdVxF65blLSJjmAt2GnWzbPP5XYHraLn4Zi3bjE8=;
 b=gzHYlqMEL7hvY2QUr0cnmJ/DJ6ne3vb9EWrMlGf5xnlt4FvFFpB6G3kEIaDCu1PzPKwCTJYvZWHGlKAWr1dj5OYeMNE6sOpVgMLezMgLTc5Oarj2PrZf3zZDQcMvssA2yBtLa5IREyyLPStFsva2rVxpKE+xW1o4NipiBJNsYfQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3454.eurprd04.prod.outlook.com (2603:10a6:803:a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Thu, 4 Feb
 2021 16:50:41 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 16:50:41 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 2/3] dpaa_eth: reduce data alignment requirements for the A050385 erratum
Date:   Thu,  4 Feb 2021 18:49:27 +0200
Message-Id: <07da2fe94891ddaeed1140544a7c6ffa156a6711.1612456902.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612456902.git.camelia.groza@nxp.com>
References: <cover.1612456902.git.camelia.groza@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::13) To VI1PR04MB5807.eurprd04.prod.outlook.com
 (2603:10a6:803:ec::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.10 via Frontend Transport; Thu, 4 Feb 2021 16:50:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 511bc067-c0d0-408f-1573-08d8c92d01af
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB345411137E6F382A4E372E4CF2B39@VI1PR0402MB3454.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yw5emyRe7EWyCczNlyrZCyzIsFehHAyiJ1Op2JtGJwXTyCTwgwlEhvmUtlkMLo62pGMcPBwwWdrttUXpel+rQzEkFe5uIHqJVDK34yXHsGDmYZL9xdz29SvRUZAcG2TXOebKz85wALXzPajqBiyMwT7LXOfob2PXLBC3NdP8sqyVMz2W40r5BR/x3gJerj/3Wx0W8kX2hVpGLoccMERaH0vBxtmk9HLLHHXf99E8t3yi1a5DlqP+srODce5xcDZmVlD1pApLVKmGe2R+UBOhfdvdmYVVT5172yKa2cHOzvamwFC6G/LkY/9aSL91YcYJd338LgLyYnK3a5ozx43ywUjbKERPICbq4rnnSRlwx7FxK11jhpeEWU8XbC/FgrCIkzhGASN7LjRFLzb1+uBkxjbj128yEbx5Z2D1LCn4q3iJezt66Pa4N8VsvodAOwGKmkyQcVNcv/SG1Uw21uGdi6FkYvFzcNQQ5nuoTSIfJTrJwj8dZX4+O2pv9IWSxEMXrDtopXbC09gTjZWPRHhI/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(66476007)(956004)(4326008)(66556008)(6666004)(2616005)(6486002)(2906002)(52116002)(66946007)(44832011)(5660300002)(478600001)(36756003)(26005)(16526019)(186003)(8936002)(8676002)(316002)(7696005)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?btixqCOftbzWw7Gv0291tuotE3Swi/s9iq4t1rTiq+A+ooGXuKcBiPNAtyGB?=
 =?us-ascii?Q?AF2WcsiMZ4i5ibBmVgp1UZed9J0Hw3sieLQSar6eOnKW/hsij4Bz7DbDJ75Y?=
 =?us-ascii?Q?ynjgv6sGwb+BooodTZSk81cli8E7zn7PgIjDzOX7pXzKUlGHH7Y9lBBf/66x?=
 =?us-ascii?Q?OCk6UsB9MBJDByxslyY7xP575qFuaad/tTL9nzEXpjYCJMsKIurZAer4hPi3?=
 =?us-ascii?Q?vRAKskL3EuWBKXAQ2UdhquGUqLiJuaBxHp82t293FwKs7Jlpo6XGc78RUVRk?=
 =?us-ascii?Q?hOCYU88DqYHuwJQyOAwiLF4bTUd9Do3rH/KI0EA8nH1ETQ4lsLvt9m5FwQfo?=
 =?us-ascii?Q?L58B9V2JOuJOwBpaxIcrm7zfyQebGwk0xRkBBh45cTKLlSqHGwKpSDPcLQIs?=
 =?us-ascii?Q?lqwIMyxccSr7Ur6SNDZIxHt7xDt8Y0aGs2jmaYbGyoEeqrs95kd1khVJd3jN?=
 =?us-ascii?Q?7yp2ZHnc4KDnwyJQUE4q4H60c7nY1qlPgT9zpHdKrcVyXyWwtpHoD1xqmuA6?=
 =?us-ascii?Q?MTofMRd4CAlF1mnm8FrghB+MgEEL7/BGWrPSHiQcHXu6GWU1hrlJb/zxPIKW?=
 =?us-ascii?Q?4h7DPVFYq7YZEpIgvBBPxPGd/2aTEfxATTvv86Mb7A2sLjPuT/g/Vn9bllPg?=
 =?us-ascii?Q?ua86PyoA04IRmGfaMksRDxYsWJpV3OMU2AjaI4kxxg2rRDpruEUxlMvWb7h8?=
 =?us-ascii?Q?XkwjWmnQzz1hhCK4dwQZTt8IVR1E9IohrPKwrRe93zfwmQ7Dk/hTtUX8zfth?=
 =?us-ascii?Q?uRGvZoQhBvsS3HTSUqFDtkyMs1Gn2sGKwODjnX8GCN5m5UtckxUHEtzwjCkk?=
 =?us-ascii?Q?zy/pnrSgw631PzDrZRainAG7yHbM/ei1WB8fHITzDPQ6RO0gxj6DdQwC/LhX?=
 =?us-ascii?Q?QUeWUPkvwT3R54n441OwM6YrLvUqS4JOSJ0QkLqcUwXqikBEjSuw/jz9J4Wa?=
 =?us-ascii?Q?1sL0066+TIV0rCVccQICM6X3W2XWAe7s9UWiKBC5BcM05HfZW5KFBUA/6/w6?=
 =?us-ascii?Q?/irmpdkZViZ8LPnPy6+TqyGe7QHu67LNVnILgSdjl2gNgUSJTYndCu9Co8Zf?=
 =?us-ascii?Q?Okg49VREUj/gOTvC0Fjw8FxkosX3wwD27x2lQ3GnA73WZ24Hz91r0nsclahw?=
 =?us-ascii?Q?+Ju9QVHMJ2N/CmEr0SgkwryLWbI+H49uBdZSccgVJqhYdAng0/OaVsBZU+ac?=
 =?us-ascii?Q?sHW+LT01Nfd3ZYlzcHZrkqRjpNj/pXbTN9YmciVerZ7o/eO/ThY5AhjoC4FZ?=
 =?us-ascii?Q?xLDRwlgJTD9FV/zZgCo6Xp6QDUtGXc7P2QG8uGmxznImWkA3UYQ0cGREeqM7?=
 =?us-ascii?Q?8r1jhX+3/xFBEDqNhMizgQ3+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511bc067-c0d0-408f-1573-08d8c92d01af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:50:41.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYVDJrvlLAV+ZYmuXUhOjEp0T3llfLz6ZgnFTTMSDSNgalbcdrQgRqNG0tQXibXWAh9d9jLnYTsMN4WaGeorEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 256 byte data alignment is required for preventing DMA transaction
splits when crossing 4K page boundaries. Since XDP deals only with page
sized buffers or less, this restriction isn't needed. Instead, the data
only needs to be aligned to 64 bytes to prevent DMA transaction splits.

These lessened restrictions can increase performance by widening the pool
of permitted data alignments and preventing unnecessary realignments.

Fixes: ae680bcbd06a ("dpaa_eth: implement the A050385 erratum workaround for XDP")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index f3a879937d8d..2a2c7db23407 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2192,7 +2192,7 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 	 * byte frame headroom. If the XDP program uses all of it, copy the
 	 * data to a new buffer and make room for storing the backpointer.
 	 */
-	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
+	if (PTR_IS_ALIGNED(xdpf->data, DPAA_FD_DATA_ALIGNMENT) &&
 	    xdpf->headroom >= priv->tx_headroom) {
 		xdpf->headroom = priv->tx_headroom;
 		return 0;
-- 
2.17.1

