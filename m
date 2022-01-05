Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB69C48537C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbiAENWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:22:24 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240296AbiAENWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:22:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6c4TTTOpZ+oGKcO0TtX0NdqGxjVsLVrL6uGzJLSLpE69Uy4NoKnvF8grCK+2acDk59AE6Nr20pzyPtznnbs24wsNc24eV9DfwL67a6N4eBvwbSxA1j8co1cZjC7CriCY0S+bgetQux8n2fMrkRqgYqOqDq6m+6+z8aSJjlPngyOfHFfXznRwJCGLybm5TJ5RDvMVmRzufHY3LlkdYwbabwT65ivz/YjMBpiP/YQNBVOojY+vOlw2GqmMxFqDqMN+sic0q2cOQyRVtW7Egl/WRN8t7zy7WX5KshFLtKXlWG0fG14dI7Hz+CJdJx2dx9Ft30yiGedsFJeJB6HzNp9Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mavQUYFYXwhcIFmdkles8ujxVOHZYvjvkNhUq/6aKME=;
 b=mUo5IziB9/cgzVYmmU7AcQ7EuCwidQogz4e8xBjmdG0eK9UudPXNb2b0Yv23OqN56kUt31kTYhorbGFv1cUxTSeENVoJNnz/JX34iBr9jjki8GBGcCkCrK+YgZ6dKOYTmZkDRAr3eYglbmcdy37qVUv8OX7OVJLIhLP/17dGCwF/cFr085XztmYw+fBwE03IWfR1vrDyE/U3ADF1a7J/iFbyhMzSjdOvwcYBD799SnfJDeV9/rC80qBXg2BHp4f/CLdo7jqND4pMpS4f1xkbIuxwaUvl/0Prb4UmI3nJUXGhQ1X0cmb1c0FikmtmXwc1OtUfgRiIexIHQJbojxi96A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mavQUYFYXwhcIFmdkles8ujxVOHZYvjvkNhUq/6aKME=;
 b=MBNtUMpPvefCm99PIgPt3B8fNd/U1+w60U2LSghaR9b5yR/qqSmItb4cBqR+aPFPwMRj531fD3lOcAtGy+gVZPcSISM8iy9F3X+82dBBNWbtY2BIxgH2BVCjbwqemAS5uBr6OcEVJI+x4TWVNOm8vBwKcuknXLhrj1gTZBxLyGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 7/7] net: dsa: combine two holes in struct dsa_switch_tree
Date:   Wed,  5 Jan 2022 15:21:41 +0200
Message-Id: <20220105132141.2648876-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0150.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5979138e-a47c-4951-16d7-08d9d04e59a0
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408D069A5D62E4EE1985D8CE04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B370eCpC29spFidJ8zv67Guw00/lofCC2b3YoxjYYtCazPShRwl7xOXe27Hr0mb74EPqIT9wTHLIT3iN9nOauP0MoLXkKWMRmxf7BDF/zB0LaKuVu2HF0KyHuYXPwq/nnNsKfxuOXrL5Inef28gT3uThissiTzusThGz79Q8+Drg6cY9UQmqpxgKM6r4jLrlWpsPMjk6Yxdd8oMd19ShrY9TEW3prTT0RinrhEoIwDut5R1vMoByU0tx2h1AMFTfwxvf168YmYxP1U3oCjnxlND1We72Gy0nCLwBHGq/tLA0C79fEEgPCXaer6SZNTzsp7l98CuUOy5knXk1OQrBAhAsytvZuEsCOstZGVAgi9idL3fpLjZhtp3tdZ5axwHL0dsTV5OfCt/cigBLL0fHf5TerIECMNwkLsdRiT1GRNRf7vqtaDb4LnRP9YsvjuOSUxAF+Gb2qvCcEdSBt4ilWa42T1h7AEEjsfnLHu0vt2BG5ia46xoUVyMzoq1qH+ixFSiGW8Kgy0VilKMxQKfnstSNbSUKK58qnEgO6DjlbTvgtLevUiNdJHjvfKdf1tRxJz31u3b78Xw+hDCVVt0PS6VKsRHN9z8Skqy6sxfC3AY2ZKq482h3ZkaJ9a1sDBSK32Oi9+wpzJywTlk2/ifU6Ae3HtQ4bOhYYMCsBsEdeUIuMBAK5jQu+mb5HInycYUovkTrj5BsbG02ZFwWyi6aiJmwZwCsSik/mCdZJqr9KrY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A6nTh91pxXI0H/48mQ7Qf3cwhicCVbIE/JyOsyQXyQLBzS9RVGmezqOQCcF0?=
 =?us-ascii?Q?2lvogcKeZ+e0eCuIkwBHlqGZEXYMO+WaO+uFe2GMiRJmDFCAqlx70/a1ohh0?=
 =?us-ascii?Q?XexNzJ36Or/Po8xY/RAqrAIgxWSlSGjv/DQWclXo4a3FV5EHBzBPnin1MfLY?=
 =?us-ascii?Q?V52rGISWr8GjoUMsN0Jo9JJ09uf3VUmPRZNGLbD40e9BPExRCLG0pOauBX7j?=
 =?us-ascii?Q?qySAZeuhdzAFZevTu3mRJUyXydYZDC/JdHri3o/qUYvDgVKhbtewyR97JJjx?=
 =?us-ascii?Q?jrcy69M9v8JkGjRG7oyGRMvZXXf5Z31YWIw1rGh5fFPxZhoMZQBb8nzezp/g?=
 =?us-ascii?Q?qem2SMdE8bNz5lIsULv550on8ZCEVW2rkO/xFm2UcQL+nw6Wiee/39B5kowA?=
 =?us-ascii?Q?/nrFqsm2uc9sMDltKa8+ST7sIpf6UuWzXgMGIrReCZ7ml041kZpugzCIWurs?=
 =?us-ascii?Q?lFiUf3l3nGnH9MJ/RkuuEqNCENc+PZ8nGg5ymVsYfKRdF+3hYP+crRWr8hqn?=
 =?us-ascii?Q?hHJqDrAVCwZf8yVO6gHpN7zIc1YzdcuGJa/kIdoZ0POeaJH3XJwbj0ZDjOFn?=
 =?us-ascii?Q?3M8IHhDPTWiv5TnE0CqhAJ+RL6jlEv3B2/p5gy6xg6ZGXCnacAJEziY5TUE0?=
 =?us-ascii?Q?5nsNo6nlBsysDEu914a2YpM0yk9ed1wS7IaWYPr/sMkCnYQOagpF5vUglFZ6?=
 =?us-ascii?Q?pGwk6ALIrH+ARM/74EuwZJquamzPVhGpDdjBc65upm/Sa67nNmGwANwns8UD?=
 =?us-ascii?Q?vXjDZwJQWj9jyREADU564jTjRi08CD6R8e8Fe0DwIGpC5oRhl7r9uO6oFkXF?=
 =?us-ascii?Q?ehxkeagBjCOyWS0EtmlRjVywcIksODiYmkR16gnaHWAZISWveIueJ7R/VMFe?=
 =?us-ascii?Q?NDRYjNnKF+hk5Oq9Mt5FUAxqV/QgbxZ7GBeATGYdBZsWYA4OC5LANrDKmwNm?=
 =?us-ascii?Q?o4f/hWOMBOEUj3ASuR2a7+PTHKjHxN4UYLjaNiIV7/4B7Me80M0Y8lT3bZwa?=
 =?us-ascii?Q?Lo7yyxBc3jSwq5+rcNl9bvamEHkhoPekbfsC5x3taKM3/pXQFzehoaDLZZgK?=
 =?us-ascii?Q?ZEgHknE1r9v4kROk6vh6DT/Y00xe2ERAZsJeGZY0TG9GffbWsMBHKhOvEr//?=
 =?us-ascii?Q?hurkrEHOKtqdqEb8V2Cj4EQ14hBTopD6Mbgf0d7M88Ln5fUhvJInV3eg/GtY?=
 =?us-ascii?Q?sPpDauEb6fT9Tus3e/Ku03WLowY+NebsDu75mPQJA9i+uWCZ5dQ6PO+xHyDF?=
 =?us-ascii?Q?LdN596byxHEGT9G/4psPvU7h+6eEzkBl/F3cNUXnWUxH32hXnYqXp/2I4pIq?=
 =?us-ascii?Q?45Z3EC5849gl3ACDyQLTQtO+v4eE/u3VqeaRGfZyQ4yf/jfodoVXrTK3MU7u?=
 =?us-ascii?Q?VWtt25XJApCoCRvou1cQo9VS7jQSz/VmItierDaRoDgYcAmwyz0K4gLdjEP3?=
 =?us-ascii?Q?ze+9I0ol95FipuwgKTJvTKfy33dKSinGG8S6hBjvXjHWyZvwIFY6RcywX696?=
 =?us-ascii?Q?XkPiKKbdLx8mLDcLGhy/19VNahHE9huwXIou5zOx4lY/UdauAtkOL5mcIcQr?=
 =?us-ascii?Q?uuTfEnbFGF1ZfcqyPQzTMcZXzGrTjQvI7R93Wb8BwPW+UDD1TsP3tpPD9Xuh?=
 =?us-ascii?Q?0qmQoPkh8yJCIze58XnchMc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5979138e-a47c-4951-16d7-08d9d04e59a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:58.1357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zs+zscVjYLCIRyfgYGdysqrJR+7kx1TvYGUVFtXBlYL2z23vuE/g4zY3nF7oE4TkkrNZMlpMfOxtjnglwLwLuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a 7 byte hole after dst->setup and a 4 byte hole after
dst->default_proto. Combining them, we have a single hole of just 3
bytes on 64 bit machines.

Before:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct list_head           ports;                /*    16    16 */
        struct raw_notifier_head   nh;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        struct kref                refcount;             /*    44     4 */
        struct net_device * *      lags;                 /*    48     8 */
        bool                       setup;                /*    56     1 */

        /* XXX 7 bytes hole, try to pack */

        /* --- cacheline 1 boundary (64 bytes) --- */
        const struct dsa_device_ops  * tag_ops;          /*    64     8 */
        enum dsa_tag_protocol      default_proto;        /*    72     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    80     8 */
        struct list_head           rtable;               /*    88    16 */
        unsigned int               lags_len;             /*   104     4 */
        unsigned int               last_switch;          /*   108     4 */

        /* size: 112, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 2, sum holes: 11 */
        /* last cacheline: 48 bytes */
};

After:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct list_head           ports;                /*    16    16 */
        struct raw_notifier_head   nh;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        struct kref                refcount;             /*    44     4 */
        struct net_device * *      lags;                 /*    48     8 */
        const struct dsa_device_ops  * tag_ops;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        enum dsa_tag_protocol      default_proto;        /*    64     4 */
        bool                       setup;                /*    68     1 */

        /* XXX 3 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    72     8 */
        struct list_head           rtable;               /*    80    16 */
        unsigned int               lags_len;             /*    96     4 */
        unsigned int               last_switch;          /*   100     4 */

        /* size: 104, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 1, sum holes: 3 */
        /* last cacheline: 40 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index cbbac75138d9..5d0fec6db3ae 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -136,9 +136,6 @@ struct dsa_switch_tree {
 	 */
 	struct net_device **lags;
 
-	/* Has this tree been applied to the hardware? */
-	bool setup;
-
 	/* Tagging protocol operations */
 	const struct dsa_device_ops *tag_ops;
 
@@ -147,6 +144,9 @@ struct dsa_switch_tree {
 	 */
 	enum dsa_tag_protocol default_proto;
 
+	/* Has this tree been applied to the hardware? */
+	bool setup;
+
 	/*
 	 * Configuration data for the platform device that owns
 	 * this dsa switch tree instance.
-- 
2.25.1

