Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6875E46D57B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhLHOVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:20 -0500
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:36577
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234854AbhLHOVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvI9EzDtsmSWrdVVyHhOny55Bc8nQQ8dkeWATgrbj9jOJ9Oimi79riT3ANPHIfwBXVx2bjHN+n51AjO+w5FA7oCGNmd5x224Eqf0OOaWy+WllzfM2QxrIo/xiCN6xQtXW7LmWOtjMgZiohI9iSmv8deILcLS9Dyr8KyldvRdC6ggKLAc935LyKM7ygXJ4vAJ/m30T8pi/n+l6okp/OOjNQBc3EZubBMP7mnPS3I2qxKMkAqQ6prkI0Qb1KZ4vvYHds0db5VuD79BkkNHfLKE1mC23ABWW8JssyGBjCk0TauwCTtX+XwFSLbyAqXt36EoK1buKsiRVL6x7tnmilvwOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90aVpqkTbFJMsC31yGZI3UUVH9eqJVH5bfuuBYGoWGw=;
 b=oGQ5idlqJPRD2IEGvdsJoVBRvVreWtjEweSdatj1duK6nB0QW1Q0FtqR9aQ4h14ovtRk58A96ePLQg+iG+C7+SuqqdjyhjHlFC2zF8RJNtaXhn5xYxgStRQnkncOWQXLzpgbmjHJ2eOKdl30DOe3LXQUVPtchHOjGBfPmwkagcxQ2fJyCMsvtYTnDqvZudc8APjbbQvXtS5qu8EChfi6xWRUBUH5AkfNYHzhn7I3E8wIZa7cf8PeRFthManpV4NYFW2LzzYkE2Bl4AEpDvs8N73UNvlG5hanAMfg5loN9tKqFog5kIK1eHz0shjpQw0/KETSkjBQU1M/PxOhXH3miw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90aVpqkTbFJMsC31yGZI3UUVH9eqJVH5bfuuBYGoWGw=;
 b=SAjspHmfk/XRzotFjHHE1NLJ7c+ngY8PcJ2bAdNS7+DRLcoidDnEELJ7SYC1G6ZDZaQON/lJAOjNTy0innn+LECP+U4GcVtex8Gd5hfGUq/1xQgKL/rzzFlli+iinr7M21UIYB2prrkiHkFjHV1h75JYlB2rxum5YMrKW8T8hTGceBfQXCeXl/Dgm1yY/5yvgrWgWM9VPMwRNYq7zI1GdJmlnXlL9GU+JdRECt4x+DiGsRW4ZoPUPsoarj8tkXuaNMZ/+AIHbQ1jBnPO4psn/3Wf7U/05Cqbz2ojkZfwGOcl9U3F4mOGv/hNPzD5nFEM4Uk3mO2J4uqa4+kyHZe+jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5117.namprd12.prod.outlook.com (2603:10b6:5:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 14:17:44 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:44 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v3 1/7] net/mlx5: Introduce log_max_current_uc_list_wr_supported bit
Date:   Wed,  8 Dec 2021 16:17:16 +0200
Message-Id: <20211208141722.13646-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7130b6b7-cb5a-49f4-8aa5-08d9ba5580ab
X-MS-TrafficTypeDiagnostic: DM4PR12MB5117:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5117267BA61B17BBB8B7F866CF6F9@DM4PR12MB5117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LO/lY2joI6EtwirwzR1W2Sx4qjB2ARPYGtm1ouXSRe/jzWI34jE17L2ENNBOJtqTiwv4huK1CKzck8JrUbiozpQSgMJ6sWguo9XhEWXce8cesjb3oCYCFSMet5s0EttldCtNorjAPINpSEhmpSH3DBruh8KsuG56PTzh0VotUEB+JtvulW2SZyNCI+jmZustGuMWPwanN1+sv7IW2G0NGhXTXdwUdkjrAMZNINfsakvYZsscB2Kf5JgDBG/VxkPozprOr87EcBpIgEnW9LnnDtPoyAXmGlP+1puWLardxQ5VRWPRghIEs7w93e5lchIWsGjJ5euzsgIBZchC38y07uvCxstPwGn+z0JGGGGaRsQyjausaoPqSmClg3Zn+BSMTvz57/e52McuBzMyu8TWgNFGyZO8IJ2PpbpcgUAEQmUSZD+zXgOR6P4ejJS52yaP9a0Tb4Mu2KmlhGmNt9wQROthGpY05ctw+XMqYsn4OXr3R669WCCD4kCqmDuhFmGNl0483+HNdYRR2KEU9mlrR4q0f5bv5A0hu1A5B4FExAY+T3cPmw0v5DegS7UG2UJU0p4GCjwC8HPvM3YU6RqjkQCIluzN/hKEsxgvdP8GiPc85IYT7XUlZiP/Vg97HJtLUB5D8fLJAB6LZ7+9CBU0O/h9Cu9yEFUc26PTLKUhJNi3LFqwTagz/t4oIpYdguzU9qqI+Ldznlp7i66S79iYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(316002)(83380400001)(52116002)(4326008)(107886003)(86362001)(54906003)(6486002)(110136005)(6506007)(26005)(66946007)(66476007)(66556008)(4744005)(6666004)(186003)(36756003)(8676002)(6512007)(8936002)(508600001)(1076003)(2906002)(2616005)(956004)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PE49YcUKzsCEL7WAqneSrjonRQE1JRYORadr4JB0GrMLa6P/rPRHYYj8BKUR?=
 =?us-ascii?Q?ev6SwXILqbIGvXUZ5kUlKhhdzGXjStpN14Cvm4LozVBldbdxkO071Qeo5+0z?=
 =?us-ascii?Q?YKAoaDP0DL13eR/Tdx0v1E7CIi5z/TO27aIDg8BT1C5V+ZAH8cr+poY8uYhD?=
 =?us-ascii?Q?dnQY049mHPSt7tpKkPJquryX5oNzdqVdfoYvtm6Tbz6A4Fs3QvTlA9shjRUh?=
 =?us-ascii?Q?XCcgFGP56v7OFovLNvyLlHDYfIff7f2HE3B/oXrAUZ30gz6AkkdDpmdPYnbu?=
 =?us-ascii?Q?psBGw4rPDOCzVozf81gAy197+KvMRI7819X/LI1Q6djHoQOpWQr5/L4ukGIy?=
 =?us-ascii?Q?n22KlRl19xuQXk1N2Pp6IAkdJFXeUBwWzVSiZvVQWcWSotNKGG0JRGjQ4RBM?=
 =?us-ascii?Q?JztQn1XnEcZnMG3Dl4zhKqsNoy3fVXD4q9KUkEWMYtbc0EZxq6RSDZ0MbV2r?=
 =?us-ascii?Q?nm/0E5dtWlwyFG9kU7bAStYHKl3gDW8pSBvQb/5o9Ma9RE3QYmIJfiPcouT2?=
 =?us-ascii?Q?BYHgXynh/vu0wgpqAlWPGNadjJ/pV5o8y0h3XgYI641D/yCoXEZEfurgjgK4?=
 =?us-ascii?Q?Eti0BqAjzW756S9Qin63FBO3me9e71S/mn0RvSqV4365Z14t96t4vVXzM+d7?=
 =?us-ascii?Q?F/LRevewIA9OhG81+83ibvZ10G06Bl+OsVjCAV7Yn8yYMi1fr4XNCCpGWFZ5?=
 =?us-ascii?Q?R7IL7lZd3PkIi/UVSX+RsRbYWbL7JZXnOXEfbtRAfiULsZzdEgtARlrR+h31?=
 =?us-ascii?Q?rCWUdaRIe/bSgpZYnC3bQT8cvQbxbdfVr9KCr2WXVChRTEvSNiPuxPaVomIi?=
 =?us-ascii?Q?qzCayG8Zw/vD/iKTEapknmVhbOn6t+4RDf9VZFSdgqOteVk0qVn/TTobXR0+?=
 =?us-ascii?Q?/kmxXkz7kv91mwNHBUksEQMWHx5ZD4NhSQk1F5z63lnxcnPGG7DS5TWpMLN1?=
 =?us-ascii?Q?52W+pwbGE2KKhFezH9v9TS4rw0ec6B5u7UFL2DWZuR3LYL0owk21KbaU1D3Q?=
 =?us-ascii?Q?C9PLQULYi9gzwOUH8xni/cu585ITQ8gkYShfDYex5ejv2Ezkyg17Y9m3WAYZ?=
 =?us-ascii?Q?EQVbsOEqlgENQM9uvBTEtQQmXHuh2vTnrSbxIopdIoE8nQJR8Ww0zE9ObTMF?=
 =?us-ascii?Q?/vVlRHrN6DG1Kkz4QKGGfPOabN6eyqFyvhELp6FetiFEJNUVeEMgUmUJboEc?=
 =?us-ascii?Q?tyJ9o7xVXQhQhfDjeM0PCQLHiFrYFBBBfUTsQf1pLr7Anmi3cceeFo7+Ub6Z?=
 =?us-ascii?Q?PmDsOxHOgO68C3VlsgFTCjLFxo/P9ChwDWXN6Z2O56QPdBwi2TB933sMtmaE?=
 =?us-ascii?Q?AjCqv6CGpX7TKbrgbq4zV+uPPHk1y4SWH0DylOwJoWiu5IRfJ5dmNQQSNzLl?=
 =?us-ascii?Q?yzRkVf2jJi+2/edLEQjNz2UULyZ+5bsqAN0+dRDiUEUbiVSTb+93SaHupZiu?=
 =?us-ascii?Q?XkIFhMjTOmrYrzpQOdKNpvIxq4q3Rwj9tbTkXnTMbJNRj3IePHf+P7EkRILf?=
 =?us-ascii?Q?Jii8Uw9V7MbOLFlobtQuEMVNOejoW1FFO91r4btGaDibrcn/y/qYMnxJtqBU?=
 =?us-ascii?Q?taFbcdd4W4FGucdWu9lnxLTWCtkAa5ImVDvse4Otm2xZixtBhbl8dr0CYbec?=
 =?us-ascii?Q?Y0fdFF27wAeLTXxGcREJrFM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7130b6b7-cb5a-49f4-8aa5-08d9ba5580ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:44.5996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIgPDjJm1tXeE52jYSQA936yKYsTPEFPjh83Q8K3iE2xG+ehOPxdm5rvqIMCCe1QLMUMpD+Q7/EkAFYGTzBZQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Downstream patch will use this bit in order to know whether the device
supports changing of max_uc_list.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fbaab440a484..e9db12aae8f9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1621,7 +1621,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         ext_stride_num_range[0x1];
 	u8         roce_rw_supported[0x1];
-	u8         reserved_at_3a2[0x1];
+	u8         log_max_current_uc_list_wr_supported[0x1];
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-- 
2.21.3

