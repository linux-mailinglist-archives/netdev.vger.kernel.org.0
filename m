Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E5868B8F3
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjBFJtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBFJtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:49:46 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2081.outbound.protection.outlook.com [40.107.8.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7DF1CADC
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:49:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3YGgxpel9C8YCq3rPh6q9K6Uv9alSBZgRhEzRdwoyTiYA+mWEI8fkEDtH4FXGy74HDKtTV8HMI5Ug0QxOw8Bu1wffYGktAfixUMm6+FOAyeD5FAqxB7tneNpd/497iMvQO5EmGOPsik63Pgz5EVblKDtRu9A2wK2CiZB2bcWaf62aJAdvGKMxb4MQ197NDpEeOIOdtFBt6NTlvOXoyUZEAMdr+BNnSo1PJGWZfFJXYWTdiWyWf9ehIOIrVsNYGq4pIISjSKtLyFY5Sb65/rc59ZRTGtHg8vxF+d6/X81wd8uhhJdvm6ZfKBQ93ZltHW5cw8EhZJMtj/8xucnuXiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1nZ84K7CoeMagWdK6gF0jUagArtSZyZmPgzSJ5fzlI=;
 b=kkQB0A9LNSqowbSYPy/HuUk8FQE/y01AfOirneO0eH6Vr3cU+/2KKVjxbOCKQpqvyo8tY3NksjiuNPb8An5hw8+q3MgegD2zXVXvPl+UtASS2knf0lPcpVzSKhtq9yTa8Nz/ESFQmt2P1YMEKypRQ1310RHW3zy3MCQoOIwaAp8V3KQm7BM15hb+/ryjk6k5Db+DvaQJKQSKELfLI51OnPU8wyor4IZxLLbIVPw1bp2BcjVrFr7uggmUzR3Ih/3VnYIzfl+C9K9VXF3KE9dba2zaUjnlhIYd4VNUkggvah0DgMKBuDjr3Jw5a6qjH1c/kpOMqCNdJt0W7DLV6+2N+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1nZ84K7CoeMagWdK6gF0jUagArtSZyZmPgzSJ5fzlI=;
 b=QOsphSN0yqQgZRmlmfCkuTW1CX+IuoEuiijhRGjowHCDYUTvB3Hg39VnptazqO31ftWPiaYO9gE0nen/TdwclFPeJB8uCo5Jup7wfdRy/ELbgHqLFByVxWEVzw/8vorNgrjsFY6pDxnvivhbWWawHpz3seZh6SN0Daq7a3Xys3I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6892.eurprd04.prod.outlook.com (2603:10a6:10:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Mon, 6 Feb
 2023 09:49:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 09:49:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next] ethtool: mm: fix get_mm() return code not propagating to user space
Date:   Mon,  6 Feb 2023 11:49:32 +0200
Message-Id: <20230206094932.446379-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0027.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6892:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1ac053-2811-446e-3e4d-08db0827789d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpk2UWNmCoGURcOgDxGABEYCuyOkbWGTKQBeICFD1Rzw5KyVI6Wyukzj3tGdl8eVTXi49vMXExFIhHsrMYI3gLChtOLiPfSgzK08xDeIku60q1/BQ7VL4FUh1SZUFInVmVyHodggycQqMyIeMnjNZf3mMnxbe56pabzYJI/YHmMPnGMKf29slCFTo5XtVtRQy4CmNWvl4NCeVvCrkaPbORjhmq4byVzfjj1aK6HjNBDwXAkmEzYP3nXcl/GiPsAIagDq0DxbZk7/erdwSr4jv1OO7kBZi8zDscTOCFb5qwzjbYdT8UwrTkjun0MH4RNt6czFKmobCbF3I98uzGfPuR9mA4l/+I+KSbq6l/d1DZPOI6VTC8rg/56A1DnlWFRPCUanYfkAdan3ie+Hw2omKZSdAVZz+qSP5TnKTOl/1lHpLc66qPKjFvwdgfWknjFij2nZk5z6rE/YTA+MoEU3JQeUoW9FPOZYvixzjJ/WDGFH7GCLT9kbzClg3pXGT+WDP+y6z+sweZt1rw09PLSOhuZBBEgPrfefcXb2ZYDDptAW6ThG2vADQt1reSiv0x7rn7NBBfw3zol/pi0VbhcjQh1WOV9l0nLm5l9ZYDS4eJMu51mGbpWh1rAIemjID497x52PY/xFcdx9eHUCxMosHsF3aPJh0OZ0eCAdZ8Rktz+zLchPFSSxYNtjRX5kNDBAgN5kuO8bHPJh7kDdCuFvMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199018)(316002)(8676002)(6916009)(4326008)(66476007)(66556008)(66946007)(41300700001)(26005)(36756003)(38100700002)(38350700002)(6666004)(44832011)(86362001)(54906003)(5660300002)(2616005)(83380400001)(52116002)(6512007)(4744005)(8936002)(2906002)(6506007)(1076003)(6486002)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yVSO2fhKAK6DtP9JZ3Ra+mhGtfdLSLDyaKqaEdtitb1WSMLy/cJ5Up+TiE8p?=
 =?us-ascii?Q?6J9ITXUYumu3piTtUvi1YIgrVdBlxtxwvl/22El/d0OUOE4pBWollo9prnkG?=
 =?us-ascii?Q?/1FincsOArdriZtvgwCOQGw1Ujy9wxh65MLc0ToiPgMyEbbgkgPFKsZYI4sv?=
 =?us-ascii?Q?EKyOKZpzccjSGpjDXIHFtux5IL5ZBhdgtLUIiF5EV/nmY7f6h7jhe9PB+nDO?=
 =?us-ascii?Q?SQyMgr4X4qCLrqZXlMQd89b3ITMU+4dmftVzeHSHw+pVUHDB0IHBTT9F8pST?=
 =?us-ascii?Q?JSIdvdiXFGmTQUZgkkzLXulemQOR2IO+wsOrDY43kIv7r3UJKLcJ6DkG485D?=
 =?us-ascii?Q?6By2JIX2EkCtYjK3FlmWbJrjwyAKHtFQgR8EFLA2cORoI0Ws6Nw+cFnmENAW?=
 =?us-ascii?Q?uSxGuQvCPe4NgppmkbMSbBY6f6XkNXpPTmd13GI8sIa+PKQsGfUnZB4DScZv?=
 =?us-ascii?Q?UzZzaP2r9jgA2rqpPy9LWC9pTjqYHXb4vdt6VfrejKdMnkp6VLLfVSxrQ7Bs?=
 =?us-ascii?Q?Erx1xYf1D4jzqfilEiJ0VHq8dkt1NhqYJq6BiT5mdBJ9JZsKVp8XKDBiOrK/?=
 =?us-ascii?Q?uXSirXN8an+rRkJyiRUoA1YYmGdFmVzD6zOxd/fhytiT8fkEC18BJ3lFoMr1?=
 =?us-ascii?Q?5j7w215gRwxzBSFBnAvaiMwzlrGdOdqzA44wJYmH3kAjhseCKxYMqfh/EQcV?=
 =?us-ascii?Q?eZ3PuQMQAHFbYPr7XWcI2zVL+/DEFMO8DDgfC1nFu/XJxGk1LVQuBEFcwPXB?=
 =?us-ascii?Q?wwmFFKcoDm6uR7uSrYP1HG+K4NIyQg31dZGVpqYp+c68qFSbtQuT7UP0OxAr?=
 =?us-ascii?Q?IsXq+YzbU0iAQH6oO6prupgM2g5j2PZ4y0MZ9jg+6Qg2CjB7B5LX+YX54nzF?=
 =?us-ascii?Q?CbIIMtfCnd5JgFNPEI88zbWQzSjoKeTUXn4KzcXxdh6Fo6xegSU3C7H7AJ3y?=
 =?us-ascii?Q?4LuRWdMNGNTJ/FP1c64ye4m59i/xSjeNhWUtNVUlVDjy7oqBR3Co+d54w9js?=
 =?us-ascii?Q?refAAGmeD7MJsO+vvVzMGeimyquSHIsy/R9XnpaDrtkw4bKpZCc1Koflk0EK?=
 =?us-ascii?Q?apsezvS7FVgYSgsnOeRFWiBhwguS47mtp8M6CdXq0/NcxO1hUPCFCFt/QBTx?=
 =?us-ascii?Q?Y+rTqKLWkwLO1u4rODziZCFtZFgAtgqFylHy4YgnL9wgsKwvgRftDmi9rAwF?=
 =?us-ascii?Q?7a0wLd4bjKFSOehFmnSuLuJkGtWZqC7DW0g7HAUSNmoop08jJJMMcqcAjHSQ?=
 =?us-ascii?Q?4yNwbUPgnfuoSdELpJlw1dxzTTGIf5WrRuMrCqO07mZFkfkiSozyQQruEczx?=
 =?us-ascii?Q?dS+0eIofyjrT8x3ptTcd/ERV0QKLwukZskfKyrVJZI+eijmOaNoBrdtllArH?=
 =?us-ascii?Q?PwHIF9V93eoaliryLq8krwuCQf5HPB22XJUDTBevo2dYD7BIdbkaBVgkUFaw?=
 =?us-ascii?Q?BN+b0cyjOmNtVQU+xrvkXLXCXD82w+zylGjWke2zwE/vEWqIc2uYZGlJotyI?=
 =?us-ascii?Q?dfWoq+fHXGAsiuHDIxwO5fZIiyQ3zpOMvSdwmdZpjWvWJffqNn/hus+hUl26?=
 =?us-ascii?Q?HuqglagCmTiwEXaYiEqJYjVUQ1Vm07qZudj/BtVOHVidmSxq9ItPs8CcbQZw?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1ac053-2811-446e-3e4d-08db0827789d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 09:49:42.5406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nsJNBvtvBdphmuoxuX6Zl60KdefwWhgPUWWNOSXbb4fF0sRhCuiIP9HpMTbZmKCEMsbSlNwpOdXyeiCtvYB1gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6892
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ops->get_mm() returns a non-zero error code, we goto out_complete,
but there, we return 0. Fix that to propagate the "ret" variable to the
caller. If ops->get_mm() succeeds, it will always return 0.

Fixes: 2b30f8291a30 ("net: ethtool: add support for MAC Merge layer")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index 7e51f7633001..e612856eed8c 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -56,7 +56,7 @@ static int mm_prepare_data(const struct ethnl_req_info *req_base,
 out_complete:
 	ethnl_ops_complete(dev);
 
-	return 0;
+	return ret;
 }
 
 static int mm_reply_size(const struct ethnl_req_info *req_base,
-- 
2.34.1

