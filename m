Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5D14CC1CD
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiCCPoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiCCPoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:44:00 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2072.outbound.protection.outlook.com [40.107.20.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55847154D34
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 07:43:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwwLSdrgwCb1ooFqmSqepF+DsU6xXuUwsvjhBtkdAssP+7GQXr/p+eoirVemScHYC41C9EJ32F8oB/2c5uKlTFMT8XwkKojpvGKpQzM5li0yYCogJaqHMxw5+enCkdMNTUAX8C71gc1Jg7xtU/6zmFgXEtUXrdZ1KEzChGHX0yD/FqD3d9M8IQ3h4Zd8qvuO3uqMxahOb07am7xhwtxyROsXtxtA8jwiXGlfXa5dBQbjNnGvOVFXbi/wnM7k8Yx3kN+Q8kftfmU94w3rICsopqk1DC5orDo8y1OpZYXgehCeclnsd6qzJrK+CBFJEB6j/fm1s9LoPRQkd96hCkvPJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/y18r1o6f7N0kHdOtvgNJdUKyHC5LLDWzj5dC7IDQk=;
 b=WD5Ods0CYa+Pfl60f6+4CJpykqr4xSu7jQ3/SikEAQnyZ4dvHnMfaxOPGA9V0m8BGF1PQ6ocjlA4wPYFjKccbOXU09CHtIDOVeYlWiDKykoD9bJcbKEPbi5lp57LS5fwpviKVOeeUXz+VJaK5xjblzP5hJrSg7jVpehFiIWGlprQkMb+KN/j+jPA6TIN0wNSJebV5V+MVi00GgRT7SKhNrGfgFW1CSnFyOyQuB7XBuFZki2I+35r0xSW5SZeeCGao7ER5tvXYguGkGOGz8EpTFeya7UPUaC8ySw48Hmq46O0vu6kFaMNU59ms9KM0IEgZt9Je6W3IFiyypt0i9bbLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/y18r1o6f7N0kHdOtvgNJdUKyHC5LLDWzj5dC7IDQk=;
 b=ULKYSq+OHXkNpweTgCn2vrISYVlrCIfP/Y1J8xkKlEOFIFyf7E9Cmc5cXE+MrPbGie0oJbPeQYUdbJpuhr9V721B4LK6RQ6sW3BA49b+pFvMtRc96WVCeQf883VAletNZQrQxSFVUyNVczPX50FS0JMafU0dJRLdqL0eqct5M1M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 AM7PR04MB6886.eurprd04.prod.outlook.com (10.141.172.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Thu, 3 Mar 2022 15:43:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 15:43:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: make dsa_tree_change_tag_proto actually unwind the tag proto change
Date:   Thu,  3 Mar 2022 17:42:49 +0200
Message-Id: <20220303154249.1854436-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0077.eurprd09.prod.outlook.com
 (2603:10a6:802:29::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a20ca956-2a60-46f6-7206-08d9fd2c801e
X-MS-TrafficTypeDiagnostic: AM7PR04MB6886:EE_
X-Microsoft-Antispam-PRVS: <AM7PR04MB6886E8F3429E927BAA24CD12E0049@AM7PR04MB6886.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BnwDK4GEU32zH2+0XJyBGLfh0Y0gIgpqsbZGTGBOnaGRL+w4T80einvxVZOyyz924U0F8GAoFxouArLLdkf9AlEXGMgHAK2xa/zxbE4Mj8IEQ6JA50f4hRPIVaaevSsAqE6FODKqSZq9wW3wPzPUCwxXUFFuK4Fe8Ngbkucmo6o17ZFT5ozXLn7kok0GjBk9Lc5LEoPEKbnJ9L4RP4+FC70o1J9xleKWetfFFZr8lxvt4SoFBnqfEiVdQ6gEGKDHcSj6zj7StFP6IshAy0pLNGsPKb4kibZQuAHVDuIZbg9ld5KYSs4eB7znsdCbhpwLJ+Z29lKwWd5JNSDXPZ/gwA3EEgcdm4v0DyBCZ+TvcaUV6H1FCDgvLXzFaQiRbloFw0ClTaPgKcXGDjj9+/pkib6MyRphg2UVbGJAT34Q9UXpJRsQJNEB53FRKLmwlrPMN08aWVntMReWf9KwM6fay1bXw+hUQs/HpQIorgCABmIQaPPq4uULvh3MxWRgBT40gWIwjhce5VD6CBFC0sakGq+R/R7nlmaeAMN1DmzPe5NqgIk+Q+nqbaqjdoJJQXIBJNkAn1jx7NCjwQFXaI54TddXYirsv9EjXBVIup7xQbNOzP3vytqIxoRpUr25W+VzFfACh9QX4u3EunGrSoZTTKyPMNu4WERSp7lEn+suN4ojh3XORoKCu6gIAIJKxmQe+QJLUBcjju1Fq6miXNgPlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(498600001)(6486002)(5660300002)(36756003)(6512007)(6506007)(44832011)(86362001)(52116002)(2906002)(6666004)(8936002)(66556008)(66946007)(66476007)(83380400001)(8676002)(4326008)(6916009)(1076003)(38100700002)(38350700002)(2616005)(4744005)(54906003)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yOh8oWpxeiyRhf8GETpJxKbVn+d3la/laBfDibvWcAzsaCsiBe4YQl17S3f2?=
 =?us-ascii?Q?+nooy33CzW6u3mVHAXvTVFlhY7kJuCnNWTXhXgI6u79yq+1RIHnU8NhnuQMM?=
 =?us-ascii?Q?mZIVxHYy6hr7JwbCYPavn5ILvegg4Fi7NBGVttXMfUE2aDGXOkC7DLHWNyAV?=
 =?us-ascii?Q?tDL+6DI+CbMq+XOK+xNHmNdcn6z/+QvXo5X1kjMSZLW7x2umXehaWBSr99OZ?=
 =?us-ascii?Q?xkrOCYV9ZXULUizsRWvcc/aBLS8a9L3LPlrDXwIXGX+yKliIW5Hk/iX4aGRI?=
 =?us-ascii?Q?OrUO9qVhZormhtJt45HQA3E46wo8iqZSFkBOmzC6SYY72loIjQd2YIyPplre?=
 =?us-ascii?Q?mgN3Fy93b0R2TBpol8rVGUjHDldnhesqqKNKdtPnNkWSSt0XwRvLPka8utFz?=
 =?us-ascii?Q?dSTcnoSmH3MDrgdIusMhjwbB5UcM4YHsyCyM/A0rEeif89HB7R1C503yqEMm?=
 =?us-ascii?Q?mwn3GMRmTLJRPcPaQledCTEe79imsIh87Fvi3+Nc1rUMAIYcDt1TU5weAyXw?=
 =?us-ascii?Q?N6coNSAO3j3ByW4TmwGNfjxEpPWzh1m1lVCm40x1VveLF6wwJfXrPnJY7aJj?=
 =?us-ascii?Q?yccd/m10Z3XLK6rDrL6ljaGSrPtOg3DfxbmBzLY8vgmhte8yZdZleU8hFPjx?=
 =?us-ascii?Q?7arUc/UPKrQ+EVPMrDOg/7G4E0u4bWbdI6edB7gZcdr6KgVWhIKJUUZ40BO8?=
 =?us-ascii?Q?AffA/Nvhxb/D5inUmNrAlJEWVs0Gaj75jyuDMLTs7/aM5TctsEJWRI9R4nWf?=
 =?us-ascii?Q?dqzqA1DaB2QlB10Vkax/dFz3yqN7xMUL8m46zsCJrd3rQ9m96kF7li/jTW0I?=
 =?us-ascii?Q?YiE4kbgR4+/EgLT8cOF+mZIF8GBIdo1Wp4XRiThlCLSoOfJX42VW4m6czCJP?=
 =?us-ascii?Q?1PbG4gLeLmsEeFD/VDvP+6hH0J+Gu4C73KTI4dTtzC8+JqzE/Aq6D8VP4t5R?=
 =?us-ascii?Q?QIyfFlcGprDuNPl2wlodvZrW2Xsup1mthB2rXtbD3ddNrBpRCZ00pCTv8ImJ?=
 =?us-ascii?Q?HmawBTz4rXKdnBOKx84c/PXA0jcNFG+qrdUe7Bz8JtRwFl8de0kLE/WG5DYe?=
 =?us-ascii?Q?/PkgVRR5d/xVhrABVhbPHO1GEvy4cnSg/2NqngLNpJ1FsLodk6/QUic0npKL?=
 =?us-ascii?Q?0hmhQoZegXht92by5HjPMU4aAKjrhxUXN2njs0gmuPu3P9IJV7W9jpicHcDo?=
 =?us-ascii?Q?LrRW67rzO5fK9F6A8ae1puoTydQL4yhI4HV9pnMew33cn0tupCWuOuLFbVfO?=
 =?us-ascii?Q?um3owU1ZiWnnYwnLqRWdjsmneRnxbnp2BZR6Ci8Nlws24+FARkvmTofAtgSE?=
 =?us-ascii?Q?5jDtPVIr3z8pMYUaiyQs7IlmjzQEe9/IzBEraG7ACcHixyILvkmLKe77MxoR?=
 =?us-ascii?Q?n2L+3qB0LYKCtk1nSVbf0WQSvPccGPq58wMpij5DAQPukzbqblZMd6637J63?=
 =?us-ascii?Q?9qok+EsNnrFNwxR/GzT94OU6GhOwUMDTQn9PpLnMkoCuB/iZF+OfTA4EudVr?=
 =?us-ascii?Q?Kwu67tJ+/WMFAsSM1MTGzugr2ea6YcrWWRiXPuEBU9MX0lK9oj89PWUfif1S?=
 =?us-ascii?Q?G+juDnXzDNX64E2Qw3XGU/rSm0PdSmENC3Ilc/ThlByI8r2RXgmI3vLf+8vV?=
 =?us-ascii?Q?llZfW4m2uJen2zk5JSDGotk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a20ca956-2a60-46f6-7206-08d9fd2c801e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 15:43:02.2471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiWekZNhvaB9k0id3ZuHO+kj8qWFVBDMwnvOC1NiOEd+Lde0zwWdmZ5B7RLhMS0j5ZSPyE2rGfYmKdev3N90hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6886
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit said one thing but did another. It explains that we
should restore the "return err" to the original "goto out_unwind_tagger",
but instead it replaced it with "goto out_unlock".

When DSA_NOTIFIER_TAG_PROTO fails after the first switch of a
multi-switch tree, the switches would end up not using the same tagging
protocol.

Fixes: 0b0e2ff10356 ("net: dsa: restore error path of dsa_tree_change_tag_proto")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 209496996cdf..b4e67758e104 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1261,7 +1261,7 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	info.tag_ops = tag_ops;
 	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 	if (err)
-		goto out_unlock;
+		goto out_unwind_tagger;
 
 	err = dsa_tree_bind_tag_proto(dst, tag_ops);
 	if (err)
-- 
2.25.1

