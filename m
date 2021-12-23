Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B614C47DDB7
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 03:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345847AbhLWCYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 21:24:47 -0500
Received: from mail-eopbgr1300117.outbound.protection.outlook.com ([40.107.130.117]:8096
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345806AbhLWCYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 21:24:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+7pbOLWMnkSoIoX6Un4mJhAnRgaUAMpWWY2ek4BglVInigE/7nSt4HShg5QxC0MnoAfUM1iMkUhIL8UK+QoLKKOPN1W/g6axG/QPEhstc81rAc8P9rbM5k4tlBSJTz5+F5ih6c8FFSTEGtG7DIex6WpTXRNPXhA87WVVI9KFb8zEW7FDxTo9npQiaGCxB5XaX9isA+NF6eJublqmhX3u0/zQm+9fyhH4faeagT03vj7QVqzArSuT2bPS5enj6Ik2jeMV6PJStO6hKo8wxWvOrdfrt24dI7w6/ZXwkKoQI5QTXmqFk1JYOLJh0UvBBu4OpU3rZBYUUb6NAEKiJ5C6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLyLZnCgaHysdygcsINr9tYVu9qmhhUsUa+HfFb+OAY=;
 b=l7m6t9fcMLQYsIxl4q0PCjDHRzFUIpe63Kupk4s8+0ng+40LN34Tc3a+xiSgYmL+XVbDIRV/krXc46W+/+bfgRCiYGMYsXh4RJ3XDxOwJdMq5WPIi+LrKk+93YYYbpvJqYx8Z19FHk6VTPgikHAOwDwwPhO08I+26Ijoboyw4X+kKjMoMvo2S3H56uHqMLE7XuRfaAJyU5Ffy6lcI0e2PXq8du9HexqnD9a6IsJiKbF+PJvCIn2gU8iliA4vmIifz/MfqXyDYRx/rfe/mBYl0HQFuTVInjNvKsjM5eG7jcix361bzWtkBit7OGawxUCiz1k1l+Pv1EUtEdLsOIIpDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLyLZnCgaHysdygcsINr9tYVu9qmhhUsUa+HfFb+OAY=;
 b=oqumK3ipH5BAg/bVhuj84weX5qrZ7sW4QpFCAXavBa0CXYO9BL1XVLuO5aUg9dx1tcTJsxG9BkIqGGx+BAaMx9mfxfDI12aKWqq/1lSIbnDuuExetjTpUEbUe3EriXbbpziTKizcVCa23luRWRY4CDTcUf5qjaAXGO75G/yX9IA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3388.apcprd06.prod.outlook.com (2603:1096:100:3c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 02:24:44 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4d34:9df8:fabe:fdb2]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4d34:9df8:fabe:fdb2%6]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 02:24:44 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: ethernet: mellanox: return errno instead of 1
Date:   Wed, 22 Dec 2021 18:24:36 -0800
Message-Id: <1640226277-32786-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0005.apcprd06.prod.outlook.com
 (2603:1096:202:2e::17) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da445d2c-e2c5-4497-b9e2-08d9c5bb61ca
X-MS-TrafficTypeDiagnostic: SL2PR06MB3388:EE_
X-Microsoft-Antispam-PRVS: <SL2PR06MB3388791ADE54080395052F34BD7E9@SL2PR06MB3388.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsROJrRJNDiv6WGJ+TEHeRr0rtiv4NexscAtazxXmb2FcftK8X6cxsW5rFpfR2QYa+Yr+8Kk3DEEA9tAvgIKedFt/33jAcgLpQKNFcbiFFK9CiczGcruhETjXrpD0kGRNS+u/sBZPWypHw8wABAvjOV84MTABa5u9mzXsaYMpHBsp00Xiwo1M/uupEyS1QJgrb3sCvIgA0bWB5d0kww9ALtkmD/4oMzJh3FlGsRImCWk/lirfZX/O5/GXM/rHfPqQ2j+nZEXv1kdGJM8cETeme7W835Ldz6TEMo6BfmNOb7Fg5U+yoIivwKXZTxXwmhyNyKg4GFPCZejKbIczZO/WT8KY4REk25HcuWyCAqmaIBJCAOs8Ehx8RmOPY+LVHC8kVlA4JaHG2sbczHn5IZZiDG8dS7hrRjz/gOlGnTNzP2u4C2prG9vAnXf+Bam0Z9Wly5jtR1ZrkbFmTaRvcqpBmcR1ri7OKuRZCOsOLM1RnY4RruTjSv1FSfPemkB9PtGMv70U2/qq3kfCbvZrq1mZI2IW/jnd8wg6snNfJLz70qW/ZgA6QwG5mjI6OQUkes98tXIdHwZ7XlxTQqRZUcd29kbaJYVyLV+Vs65RwAqY05uwpK1YbO2vznJ/XamQGFc9rFczitfa99MuVjJ6GR3fjJxuocSeOd1JbhDuT2bzWPFb3l1XPIh3aVxav8HLOUvSuVgnH2VLkNEkI1UncVPdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(8676002)(4326008)(36756003)(52116002)(6512007)(26005)(2616005)(66946007)(66476007)(6666004)(8936002)(508600001)(6506007)(86362001)(83380400001)(107886003)(110136005)(2906002)(38100700002)(38350700002)(5660300002)(316002)(186003)(6486002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sDKkeF9tMrL/9FEVRtXEEPatYfSA2mYswjzrZXKqa3n/jpV8sxo74dt8M2mf?=
 =?us-ascii?Q?oSx0ewmRUETUCsQqU2PCZhqonfsb3PZc/eV9nLhvLVrs5BMGOgfdPGnhZ/F+?=
 =?us-ascii?Q?UxEfzK9FrGNz2t0J7mZDh8C6Z0xRUUt9B1UZPuPxSMVIhr5x/rjG7GOEkrZ2?=
 =?us-ascii?Q?9XUhrMJXaZSuiFlsVWuQCZvC40raHY8Rnx5FAAl+ZHMhdC0DlhgW/DV63XUK?=
 =?us-ascii?Q?CSY02xeIpOJ7p3WDMiyZMuTVmrtg7QDWT/oQbsoRDdXV675n5xV6XYJEKnJ+?=
 =?us-ascii?Q?/VidsUv2P749UehKh0TN9XtzEJ2T64YedlfCSuteekcQmviRfGKpqe4DRRVw?=
 =?us-ascii?Q?/a6927eZTBC2OAkFVAl6qgu0ucnEYfcdZDhoXc6QvA37g/02rnQLhiUO3jq5?=
 =?us-ascii?Q?Essdi/LGSk0qIiDCcFPaWhjUUgGgNdxJk9PpLU+HVlvPzW3jnnngAAEFzaOK?=
 =?us-ascii?Q?LTWCxJz+0iV2ek9YvnymDAq2mVv2AnQmoMHFuLrAtPbxmlPnchumuNrxt/gK?=
 =?us-ascii?Q?cD50+BHZHMzsCwa4XIKTDsDobsQAjezaeZbXBWiXJPebsMA0LKTtz1GDe5Zp?=
 =?us-ascii?Q?6HGx6VO6KpKxgGeMrXD5oatVn5dhK5f8EInT4M/OkWegWd08GQ074owKCX2w?=
 =?us-ascii?Q?fIdbzt4oe2WIiN4T+EKYZNhLK6mUqdqnXh8Rf0QFhSzP3uds+wNSdXd29yCY?=
 =?us-ascii?Q?0++s0UDbFVKYl5w80apnPyh1d/PRZg8vr94M/Si9BRgRR+0N3NCWE8khT2jX?=
 =?us-ascii?Q?N6N6Z5u+BZob0YeV/N18Hvz6c46BpHAIJlQHzpw9BPu/+XFPH5abMq9AiyqZ?=
 =?us-ascii?Q?PDTJhIaawfYgEUxJ+13vStfHZlx4pcvstMcU03v93LMb+kVSnq1iiFmZT4/Z?=
 =?us-ascii?Q?2fu50fqfgULwIKfdZSRTHgUlUQ/nF/9/QroyGkROMxF+CHoWAM3WptwCcYV5?=
 =?us-ascii?Q?F8Tz2WWS/lQ8483hSnX54n0erqKCNyJejH5+2hwhL1zdgoa1q0QDPgvNGZiM?=
 =?us-ascii?Q?MLZFEYcXOgfwivwM2cLZSJ5Qqnfm/4TZdouG4NcXukuuuwR0w17NeE1a8kkS?=
 =?us-ascii?Q?IQ/nmqLTiGiSVSTYY4CvTXYbG0TzKDYLgRSPnL35/H/G2ldaMVHfu96acDH8?=
 =?us-ascii?Q?TNm4V84J//ciFLbWQ4c9RnAi47unKMUvMaHvuYi4WRiHE1MzCWAccQ0XyqZJ?=
 =?us-ascii?Q?eA2UG6aMY7JnAXH94Rn5VYbZIsT9rCFY4eVtidh7CD44JMB+TYp3h8osD4rS?=
 =?us-ascii?Q?AZi+GPWpYqjnEN3TFjNC2JnR5VAwGmlpfmZBIkZv5/bJEGL1mJgrBYfdwgoP?=
 =?us-ascii?Q?UQkb7WdafY6bAkYz4k0sLtMGW/YB+kxqXwIrFeYbPpdRubQ9qO5GjHzuqI3N?=
 =?us-ascii?Q?g3lqBH5wbYaoRn/ZeLiQYyYilbDLA5AWc9I3IC9TGjvrYllZf9G5cqoMGmDw?=
 =?us-ascii?Q?r6YZpJ3zQz2B8l75S3NzZRekVst8U0VKYOxudSQmvmShwy+NCUQyX7U5XJ+r?=
 =?us-ascii?Q?tF0p5n9avhBB6iLZbfbwqCbb+BU2ZZoy4cUSp0hfzTdIP/VtB5VJzcqJVxVX?=
 =?us-ascii?Q?O0Opbi8ezw//kEknAGHL8BzIbxA1B+0E8Hrvzy7BnMK1vgt8YaxXzJc8xf/z?=
 =?us-ascii?Q?Lqj9AZD1u0opE1AvkeO0enM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da445d2c-e2c5-4497-b9e2-08d9c5bb61ca
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 02:24:44.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODdvqYG0ML6O0lka8ZoQJ+C3Ek5cljjB78CLxFnVZMQ2qAKAJfSGmIbrEenSKCn/lfd85TGKXSSiQYcAyCK2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3388
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

mlx5e_hv_vhca_stats_create() better return specific error than 1

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index d290d72..04cda3d
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -142,7 +142,7 @@ int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 				    PTR_ERR(agent));
 
 		kvfree(priv->stats_agent.buf);
-		return IS_ERR_OR_NULL(agent);
+		return agent ? PTR_ERR(agent) : -ENODEV;
 	}
 
 	priv->stats_agent.agent = agent;
-- 
2.7.4

