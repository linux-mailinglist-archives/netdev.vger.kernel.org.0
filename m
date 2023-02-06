Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189F268B973
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjBFKJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBFKJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:03 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2073.outbound.protection.outlook.com [40.107.21.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC101043F;
        Mon,  6 Feb 2023 02:09:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n153ZOIKmtn4mnxsonP9uvBhq65N1P63PfPPUW9cn17Nud+SOxQLuotz9OBVb+0j6awtXlZ6X199WDVcNYi4M9PpYKoRicGCJlE1VYUzmWoX6YUFCHig2eeqHfN5WnTBISvmwjpWebEaSrNRx22U8bmjdk+L0jzRBKlvbtvvTFhvsflleCz0WUXnBx+H8D5BeRYIohLhMICMLzm6QlU0O1FzDC+nfoJ8OddHSAsfp3RNdPDnGlvH1ZhiWB7rz5xqg6FXWxsuJAW5engvop4BWRDC8NvU0Wr97yiuFZdDIdGO3PYsUfTo9zaJTzNt86bR3pITTwCxnWEZZ0nlGuzl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPq59rGGC+c3Ifsws733MDs1xtBkSxK0aDJ8bvKbcG0=;
 b=ObFcwBaxciJNPCDaPlhSd9JK399XqWuO17/Xe0/cLqji8OiE5tNTcRLzac3e2AhQy7FT8Hc4bCujHvIsOhiyvF6NS+DhKNznk/6UhDdat51pD4l3f/QQn30vHACrtyBK9Ittm3YDh0dBIgiXS7rL6d1405GA8lWhBjpZnN1KGftiLc7X6tIPXdEVGpPbZz28Q+Fnn3TK3d/t58z93qbGoi1c2SnOxfS1FqxZOgMRW7v9wSn0TJXQ63KyX4VZj4CHjQQvaICcOlAS+IIbbXTqxz8CL1ly3xNkOeEqr06Jc2wmq6A5/DJtAD/oL7pN0oI2pX7npkZ9MWFCD5UuQgc9Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPq59rGGC+c3Ifsws733MDs1xtBkSxK0aDJ8bvKbcG0=;
 b=TO2WAdJd75gDT0UHjskI/cpW8hz1Uw3UWXJVAlYMqp4V2d7gFwJQWmTrpZ3AjxS3UmQlKpWQxp9TOsFgXkXFzlC8ULzDVASTUPq8aRvFFTAuhdkpUuunSXKGoVxYbP+0YmXxSbt8DqchnHzfmBMcNmXaxumjca1tVKI52Ta7lG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8421.eurprd04.prod.outlook.com (2603:10a6:20b:3ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:08:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:08:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 01/11] net: enetc: optimize struct enetc_rx_swbd layout
Date:   Mon,  6 Feb 2023 12:08:27 +0200
Message-Id: <20230206100837.451300-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: 7262d67a-d98c-4aee-c057-08db082a29d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crxutald9Bwaaw8J4DP0wPY1yxMBZF+k2UySCeFu83uW83hCWxGgC5/5/IqHAj10pmv8iLcWQwvXSrDEBuvYzB5Gt10aEQtk/pFU8NJIGAnGHL4fgVrZWqsr8dFrEhOAnes9Q7UlkcqlFoy4iaPB7mpS0GLTIGWRwOZVLcHC21+CJJwH9z93Hx5TatZQDlK7Enn51Rva9L8ku5I+qg906PEh6VqM80/8cT8V7yYj5PLsylZWrmUe4rpGDojtuR7y1zm5R5gevC5qbyYWJxrhp1gvIZunAiq1FK2VeZFLGeM4G57lyAUB2LyW8YsYKReEcojTuhey81aAinDJ/EuLq4QWPiSnY630i/Npc9ZUbseCEtgD0ySHTTqMM3nOpwcTfEKow+2SFi5vJSOxJtnYHGK/NoCe+Gr4LQg7tKr5+020eUp1EGLW2PdEHlfS1bgxOthGyMeiA/LTtqAdPWjdKyLzjFi9tttlB8IBYqYWqQ7md9/6znbfg/DeM7QJtZp2smTFCxBMXl1gfxc/QIb0Ffnig7aOWujB39tIMzPpCefSbYN2c6UdaPdAlAS/mTYPoT+gFy5GN5lURHt1/jtRy07y4WWLU3o8QXX05HTxIRdXaV2zQN6ztyyxD2CKRhWAUvi4eK2J8Oq2YPE3egtuhrbUFHIYL8cVTcRTJoRYlrTN4g0qZFbsPjdtoRghPFMNa33L3WhuF2DHRF0Pn9b/x+KmI0X/c9TKM+3Zp1XjQYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199018)(86362001)(2906002)(36756003)(8676002)(66556008)(83380400001)(52116002)(1076003)(6512007)(6506007)(186003)(26005)(6666004)(2616005)(5660300002)(6486002)(8936002)(38100700002)(7416002)(38350700002)(41300700001)(478600001)(44832011)(54906003)(6916009)(66476007)(66946007)(4326008)(316002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZ/N7eaAcxFxcDocd85xFPpMLiDqGBrCL3RAf/6KRG4l76o0Rz+YfyqOFHIw?=
 =?us-ascii?Q?oqHyEOzrCC+VRCx73A7BeI65QiBBJ36phU8ZfRVQso9+LaKQnxstz3jbfESV?=
 =?us-ascii?Q?ua8gpZMIx0nlU0RQzuehzgkNQxcxgnzfWk9XAdE413mN3HCc1xv9CaLlgnEx?=
 =?us-ascii?Q?1SYTnjdgjah0RjGlRtCctQTeo0nS2VbJf6VcG50pKdsZGNLK8AHvLhmlZsLK?=
 =?us-ascii?Q?vr659kWocAfcOYGFar4PpfLw5fCSkQHD8zshRWakBjEkth+QiZllIPR+XGyb?=
 =?us-ascii?Q?iHpatkBTuIPF57b7alFzshf9IPBAh0qye0NoPZkE/ZdxlKEYhi5U/jTS6a5x?=
 =?us-ascii?Q?MF4kNLHtKNUPve1ChAhoGoFQ05M2AaR8jtSlk3EZQZV4RJSk2wcdnPk9BF3+?=
 =?us-ascii?Q?qL1OpvwJZd6iS55KZz5k8H/CjGSQnXQZ6mJV1j25lxuVogCXCu+v/cZq9+zQ?=
 =?us-ascii?Q?31fdT3nZj1/HIS1Ttyq63FHAfiKyJp7PWSSzgVN3DI5mKzE8am4FI8PERw7h?=
 =?us-ascii?Q?3hqYa0McDY2vfkbsZiMn4MyLwgBU0lbpeeFNGCZJUsdoSEDw6qk3zD9HshuN?=
 =?us-ascii?Q?/gZtsmBV4mkGvcdRqjti/oIC/Z38ZOgXgmF+/EzBZp6Ywxivqd0tUwxl8iRK?=
 =?us-ascii?Q?JWbmt+mmnsahVAvlgZdno81CFEo28Bu5BQaftr8+wBXajQ62NqEPr5oql4e/?=
 =?us-ascii?Q?d2dg37Gg9C8TMtk6dgLrdIZvr0bF5tD3vcZHXarlA3PwDfdxSjnyFHtSfzLh?=
 =?us-ascii?Q?vmglZDJQ5l5Oe4+qE5Woc3eN2htp5jjTSlamH3ICoDLHfMnJPa3P9gWwCHQI?=
 =?us-ascii?Q?DjIpeY2qG4a3qWK+sMOfXKjvobHuFcOEJlO5Hrb+iISO8kOuAYbS2KYbqbt6?=
 =?us-ascii?Q?GoAt4l1TwMZF1acz5O1Au6/ojtwkCWDBHuGmH8ax/Pxa+Bh9BAxA0PcbTYQH?=
 =?us-ascii?Q?cYIlf1Vad1SRJL7hcvvbfiJPe0JVN/ymRFR8fdKZtqmYkveqGnSnjNa2ZCWs?=
 =?us-ascii?Q?wkTRrOWF9HWNam4N2eGt9ekDnakBN9EyFEskCPcm/WSHR2sC7QaeERYQHsv5?=
 =?us-ascii?Q?VXBxGs9ojdjlQ62aGQv4ZU0og9dxKGIbDu9Bl79+AZBkc/Vvp6TATLYXRqBc?=
 =?us-ascii?Q?Ih3rZ7b0Z9kjc7iqCrO0Tjbh5AXtPMYWKaeBu3CUBZG0WrGzQKvQwJ1hrv8r?=
 =?us-ascii?Q?3DULpLgvWYh1KuW5piHJDP5EExF4FphdRl0/isgNa/q/mU2Bs8U8tBN/hyNm?=
 =?us-ascii?Q?xoI7wc5baUJd+dNXlZD+ePbWvFR13YOr7kE6myRnx7M3Cma1q/nsjAnn8tsD?=
 =?us-ascii?Q?RaVO6oZx4Wu02eQn90MuIeqxw/8A1/rmW6BGF5jyRQgyY3QC57/yCC0NrF98?=
 =?us-ascii?Q?0w6yM/0TYfmYkFpK4RF6SK1MA9v9Ag5vET3x+6faBTOC33jsdb0kwOz2p1NU?=
 =?us-ascii?Q?Qxo9zKVsC5MrUHT8CuQpLCBzVfQdzLYo2enceTrRfU5QgCkpnK47S/Lowgbn?=
 =?us-ascii?Q?whyiQBJrCbTxZMj3wJ7DY2cgktAcDnMefJLlqRKQQCVVIz388qzU0fGeVxkh?=
 =?us-ascii?Q?//VID/f1S8DiRGI7PJRMUqlA9QMPwMRoTvjuf4oCYn6R3xlNarF3m/zFZDYZ?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7262d67a-d98c-4aee-c057-08db082a29d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:08:58.9276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPg8DqD8JMLb0Nyrci37s6UUX/A62B2uiOBpfrVf3XKPaOzDa9qFY0WLf4ZyIMXdIsFKriO80KyxkQAe0LN8/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8421
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate a 4 byte hole on arm64, to be able to introduce a new member
to this structure in a future patch without increasing the overall
structure size.

Before:

struct enetc_rx_swbd {
        struct page *              page;                 /*     0     8 */
        enum dma_data_direction    dir;                  /*     8     4 */

        /* XXX 4 bytes hole, try to pack */

        dma_addr_t                 dma;                  /*    16     8 */
        u16                        page_offset;          /*    24     2 */
        u16                        len;                  /*    26     2 */

        /* size: 32, cachelines: 1, members: 5 */
        /* sum members: 24, holes: 1, sum holes: 4 */
        /* padding: 4 */
        /* last cacheline: 32 bytes */
};

After:

struct enetc_rx_swbd {
        struct page *              page;                 /*     0     8 */
        dma_addr_t                 dma;                  /*     8     8 */
        enum dma_data_direction    dir;                  /*    16     4 */
        u16                        page_offset;          /*    20     2 */
        u16                        len;                  /*    22     2 */

        /* size: 24, cachelines: 1, members: 5 */
        /* last cacheline: 24 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index e21d096c5a90..704aa1f9dfa3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -48,10 +48,10 @@ struct enetc_tx_swbd {
 	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - XDP_PACKET_HEADROOM)
 
 struct enetc_rx_swbd {
-	dma_addr_t dma;
 	struct page *page;
-	u16 page_offset;
+	dma_addr_t dma;
 	enum dma_data_direction dir;
+	u16 page_offset;
 	u16 len;
 };
 
-- 
2.34.1

