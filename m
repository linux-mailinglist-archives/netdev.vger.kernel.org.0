Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B260F523045
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbiEKKHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiEKKHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:07:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6742366A5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njv1S+Lx0AzVnnlYhpkPTsGeSKK/BpY4yDmO2lbll2ncGA+O4rJmuKpLuLV4+DgO9V3XQE9bQASrokDwrxf/SxHkBkjH3SUiAQFtGodt6B+Ue59+SGbk+TIQBNNAqqYifdNzHivarq6/TbjWa2y3t5BQJh08tdcyC30nfRx/E/Tf2GhrHaVUfutKuIz+c4evsBAHYML/OLR9pK5p3nVdfeHEwkjiDoiOt6cKRI8udejvcVgPzY3jQSCsLyC9eqAjk63/h6GXHnzJrSQslMYKesNKilkYd/A7h8pl81j0YZI9bG4tiCmAbuxV6JAmIDBRDbWNHysVDswQ5BmUaNnNCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfAkI5kFwtcx4NuIJlElhVu3eAW2OZOAW/pD+dpyk3g=;
 b=MPR71p0TZS8cXkCzeMO5pkFAwTW+68rBXhuB/SRedfZ3je/GTC1IwSFfAmS/t8b1WiDkgNGGP7c6GCvmgZvCPKwB5Yi7KBDYmwvpx99sGrGseL3VT5K/9s2WPudbRF8RTlt7bGYTfbW0/TshbeNqj7EXVfJHGXbuLTtp3dEth4cNgs9T89lGZw8HOmfABPDvjeKHkBLY+n/9YlBIRFJzc3zUfUwwVNAFBQiDhbwnKZ+d+klRtBJVyutMP6lw7Wa5luQpob9oUnSmF0CAj0Hw71wKb1MWFsPprEZDbMibzN0xOYAM99vn96ajSMlI9PAbV+lNVy1278G+KcxbUaw5YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfAkI5kFwtcx4NuIJlElhVu3eAW2OZOAW/pD+dpyk3g=;
 b=RaF7eI8x7NoaPWYaPE11HYX4I9AmS2xaKYsaOWNvtM1D9lWukGsaqaGOkhHEmwpfcQrNZBuu0Jub7KycbzJ5DQxN0YT5TuNKQx6cEST3RaEeGko5E5f7O6+m7H9u9aF79slScCI+3SsMXtWq5lrIzjuU8PbO/Tji1gAwk37rwew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4501.eurprd04.prod.outlook.com (2603:10a6:20b:23::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 10:06:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 10:06:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 1/3] net: mscc: ocelot: delete ocelot_port :: xmit_template
Date:   Wed, 11 May 2022 13:06:35 +0300
Message-Id: <20220511100637.568950-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511100637.568950-1-vladimir.oltean@nxp.com>
References: <20220511100637.568950-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0005.eurprd08.prod.outlook.com
 (2603:10a6:803:104::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e98289e5-eec9-410f-43c6-08da3335f658
X-MS-TrafficTypeDiagnostic: AM6PR04MB4501:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB4501A1B212E7E48F4156CF9AE0C89@AM6PR04MB4501.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wI5EayACMLV8UOaGlNQTkWrueVu++O6GSeNzxeFRLhMpphPrS9dlYKG2cOG+Ii8kxyL8P8xtynHcHFPR8RSnr/H778ZmHTqWOjHjq/23LAqU5nn1+lqDaxZqruTfbVxCUMeYemV7E3+GM1I7mdoECd12bTlbD0yKpNaapRh78ZtG1yulRzeqVnTcBbD6LJ+QTVMUpqUnepHFrrrOyLAWJHRa8A5N8HVcc/pG1DfGe41SounCoylvr8lRS7NIb/jRwAp3DjfWwqHvxM0Qr213T1azSSJEMQ0XXR/QtHGvVlV/rdVfMELHAixTpDLknfjTLrnTVhTp2BEiDXrkrGipJkypMiARm5MOVFiBpuRlFG17EXhBCX6PGN5mxaqNk4RVteypkRdSKPPnZSI+qDakeXTj6OXFfq2po+XMp5CF0+0ZHP63e0mpy+CBj6/aGjplz4dzk7IOr3uHVkguTy7mezQ0qFY8EhHC4crvpk8U/xJhX9FuIErzWuSx0dlZUOsZ1k2uQn4fZo2sfnf23pWvaS7olwij7jVUXIRpIiCTa4fVBx3O5pz+EO5U4xjrNRhBlUTbtSoDkDFxGKlX6xBA7IaLnx8JqR++AJkTdzZgeRQpfuywx/uHHHZ7HMujFPzS+pW/f2GW3e1BPPU0teDG+g56g2QdNBHlM8/tHZ9TZVtOYnf1zYRFOCy+3cxHSeF2KAlgivUfcaUWiEaSosU33w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38100700002)(1076003)(508600001)(38350700002)(83380400001)(6916009)(54906003)(316002)(186003)(7416002)(36756003)(52116002)(4326008)(6666004)(6506007)(8676002)(6512007)(2906002)(66556008)(66476007)(44832011)(26005)(2616005)(66946007)(4744005)(5660300002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TwPtxhSI0CiRPexmnznfU1L6yA/Xngpas3RzsbuhGU+cC2ocTNw2A+b8rziP?=
 =?us-ascii?Q?KpMbRmi3HAU7j4QiFOJbRvEiPGbIHZQHdYlOUqxJ63TguNn9xRGVETuxP0gY?=
 =?us-ascii?Q?Do1VQ7jOMRmPTE+VzfpyHaOlVJlUSz779XLLeZY80Xs94SHylCcD+cPrTvP5?=
 =?us-ascii?Q?MHvgYXuQIJgsKNnNziyy7mKk/e8cnDLdJ1QClZmGxJc9BPazYzGRvrohJF9W?=
 =?us-ascii?Q?gHs5Fd6i5jovTi708vK7C0GqYXoEOs4qPxYYAEjBo4lco2uYXiVlsB5CNPDR?=
 =?us-ascii?Q?Hv20v/dl542jkOeV9nKPeeLKPTpUWe04FPZFBN3NeLOG/8AEMgapNoWH6oQb?=
 =?us-ascii?Q?9bPTNWweLncyiqLJH5hVvx8Ldqy/h/MD7ktRZwwYWVghF+kBUh5rLrKiktt8?=
 =?us-ascii?Q?/JVzzz2657GcgBySlhSXi/iAO2DoYPkyXf5PtawDTbcL5bISO3n8gzDruAc+?=
 =?us-ascii?Q?Cg/Xvpdh5C5iAHIrM1Szw3VSRJAyPj9cONS15LtS9taI3WK90CwAYBK5Q6RY?=
 =?us-ascii?Q?6tifIOKGWBTe+5+bEA9owcRXFUnTfnG3TZG2IEaPYB035qJVlpxCtxi9UXFC?=
 =?us-ascii?Q?WzghEl/1Y/ZsXdSGlNdFZFnHbUpkiw3zNtLN0SMmrzuOimXZTqtaz+rwwdtV?=
 =?us-ascii?Q?EA68SVX6OoctAdJ/++a4U7Hg5S1ZcOtW01jqFaCHZoUqQVq+p/4ZzWSFEskw?=
 =?us-ascii?Q?u3PXI60HTo6L/VKZgCJG9aUwB/5xFwAnViRgO5VsBjMh5RaSBY0g5i98IDT6?=
 =?us-ascii?Q?p1sxlZYHiR9Qv/la8gC+hRgABqRVVa5pNYWiHw4RRwjKfEg+nzs5ZmCubYb+?=
 =?us-ascii?Q?+IbajmdD3zT39qGR5IWY1Jc/7e9ycAPJ86mLkdL3tj3UYeQnrtgm/4LePghA?=
 =?us-ascii?Q?6C6onlvBi+4M/T2WZz47otTLWb+IDHruU3YJrncw+q++yae6ZNcYA92DHyzw?=
 =?us-ascii?Q?WikAV01QaD4T+X4SfmzyB4uD9YbfZoi7Yx+MH7osdWcqsVtx2RlQaVswQz4Y?=
 =?us-ascii?Q?XpaSAITdajPnWhKAvfkCbShbMg+TpB6yPkmwT8Bgg4+G2N0QxxrBSu3r2QCz?=
 =?us-ascii?Q?RcPPmSb3Aoe3IjoaPue/SLmzCw++adZoPt7AL0FH8XBRxtrEsX8qg59JoLiU?=
 =?us-ascii?Q?3gwbFX5kZyWh/lEJCTfoPEpHzmOQ6ftC/l6GFQYEJU++cFeVQ9wC+SUV7GBk?=
 =?us-ascii?Q?JlRjJsKRHinRpRQlq5Rchv2LZnruEWEaId+QXBu2MkAU5Cf09rqeFSCNTAm7?=
 =?us-ascii?Q?JOUn/3AU7vOgDNAF/gRS4OzyVhUll+KNgeRPrBisGjIiBHY25nBis8ijGnrr?=
 =?us-ascii?Q?YeibZaQ2vWhWrtJEcTIbY9rnaVTZzxiilFJrCXPPLbD8jwNKyAxK6d4CjsxY?=
 =?us-ascii?Q?0XuFdXRid6kUWTMIeOnwgmQNVciwlfZR8n0OUXft7tZKLVdp0uaXcisYfftH?=
 =?us-ascii?Q?aiQQSZxub5Mrz+j5kf3s5XfqYDqKmYHVpwzs5b5FXcNWv1uz0C/PQEwabWu1?=
 =?us-ascii?Q?KF2pNQl9QTMCZNA4y/fwzU2uhVanUSYMr/FbkO4y70eRkd3MdJhMYCrBp4iD?=
 =?us-ascii?Q?AGqId5/5lu6J5BzEoYS4AZ3TXKOxadMMduxEOzmoZ23P9P+5Jaw0swoDLS1C?=
 =?us-ascii?Q?eU4M4Ss/KrAKOtXZkCXF44n4LJSJUok3RwPbnWID+zlkkL3pUSSVvP8pN4QX?=
 =?us-ascii?Q?dCOV1fxLtm0lPhxwtwomgNStFnbZy6Oxb7NWWo01uBk7mrrNuikAomba05MC?=
 =?us-ascii?Q?rlPPdEhqpMXrOf4AutuKFNrbOab7lW4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98289e5-eec9-410f-43c6-08da3335f658
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 10:06:48.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4uOYUN3+V8Ai7NY4Dwg1y/OU5zgCC7K2SxR0oIqQVezsx5j+u4fbXHv83SCF+pc13zGnQPfowl32LELv2UR6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4501
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is no longer used since commit 7c4bb540e917 ("net: dsa: tag_ocelot:
create separate tagger for Seville").

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/soc/mscc/ocelot.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e88bcfe4b2cd..919be1989c7c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -670,7 +670,6 @@ struct ocelot_port {
 
 	phy_interface_t			phy_mode;
 
-	u8				*xmit_template;
 	bool				is_dsa_8021q_cpu;
 	bool				learn_ena;
 
-- 
2.25.1

