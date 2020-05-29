Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70A1E8928
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgE2UrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:47:05 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728342AbgE2UrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:47:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+h71+NB3mfO00edKLMQY42BSONQVAyzIXgRFEX79T1sVMVUNhTGlaiVx4lR4TwdX5UiqepVJ4NxVRPqAjaLT1cKE49h2UrOkvWNNND8/AaKWBe26u91XaCLvlidyV6eBSQQePgfqLLNgTI1OZ2crT3LY7qh1GBQaOHIHXKZFEAHeekSSdqGRsBwU/iEL32kK+h2WyNjeqKMXZtUyIiY6Er9cvwmKoRLGwuD2gkcC1a8Rc0g863OJwIAGi4BdenGuPkRSQhI3teHxvmceDe3Q2v4RIfoKOODtrNNMsvcWRpURVgbSEJG834gX6WOz6/WyEgYqqxk416ac5qlVXwUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSxTSEdmDcRUmTvr6UWLAfN0MYATb+ublykUwGyE7IA=;
 b=Kqi26P155/nJ2WFrZN7xtTwR/UVxWDSb3o0rQXYI9tDg6NhhOEONaQnHTPcDJ8+pkrKxQC2Pul/EEi3qjZZVX++1lCuXDbJTZsY6ZYQ0Q/f47WhJz70ONyc1VsfTfAWFp8PYzPHtFYz0yYwGIMVlTUL6hApVQ7VoN1dYjFjMr3Ppf0/yyy+iOgbp0zVXy55qWhIqAkV4ogQcRZvCaLB9PKJG7A5mFlIHND1+nmoAnkqJ/ex4ZoovrWk19JVPJny0HCpmUu7+eyNDgsTqZjRgfhzjMS0uRBA9KzOL9fyIGKaXkHcRk3knA7WvebJ1+swttEkMa+l21y3Mx8t7PTrRsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSxTSEdmDcRUmTvr6UWLAfN0MYATb+ublykUwGyE7IA=;
 b=GYtD4PeQFiei8Z8fW3+K6Bgj6zQ3DtE8i+ZshrNnQVDtBnuKL6Gmnq4bLzITjabAo3xC+EVHXl7LqPuorRxozzNAGnkfG+Fq8knJnlHwlQl5xXc9N1CGWKC0pj5of7gO8IrGf47QkcdW2eX9amXFb3w5yFSPas0HgsGgyaldRK4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 7/7] net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()
Date:   Fri, 29 May 2020 13:46:10 -0700
Message-Id: <20200529204610.253456-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:54 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cdb4c70b-9c89-4849-74ba-08d804116ce0
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3359995FF7611F283724EFFABE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u62ac+9B+x/milL0ZiHOc+zTH6MXtnUIE+mBiN/0mrhiO3SVcp6nXs4+FawxBGvZHCRAZwpk+n8/T12l8/7tzquIn3ARgAHQtOj0yC8d7XpIZS/1mfP7Le6ok1pgYHp6dtPCG5ukThOQ5NRX+TagEKMAaVgnbVwj6owm9lmzOiP/wQO8NKkIi/mKiORtRxMmp0M6xMNHFZD4z9fT1+CmjY0JyjV+3MsZg7TtIspjRH4gZchlPOrmT55MksQ9gN8HcYnYRyNLd98du/WAf+fjrtxzznWmNSfMntNLVBYposffxrquigFkGQ1JNTy85ZMgHOSSNijldRMv+w+acr855vY5GOmBO+Yl/iBdOW0okxSZ4bSQxOCcE15eCO89cqqx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SeQZxR+ZOtmVnZ8Es0m61Mqi4V6EG9JFwvU6Mo7Vl2VJqvL9AxwPfoj6z29EvLUOv+GAeetjjhLwMyV32QZ1hS+0Vlc7sNsEpNWDv2ld/Ta8cnT8i9CH0xNPYD9jnI+z9BINiOPXrDU55GMBTbNGJveoQfY79FXEW7JTy6SJcbcs7X0cLofdGOvVMtOuzjmzzbvbrrZKlrN/Y8613Me7l5iDpjyknGX5kaTWtA0RXMG7Z5aCNGcjrm6cLbSkHXeIftMZDwzA38PScyyf8mBmV/P93nH901Cf5pnBKGskDjRg+jtY/UglZKwtbgjAUUegHLGzqONmSSeTnmidjACUmbHFVfMOQHeaK5vrBtyuw/i2jdRIZol19wCXpDPl1SZVMo5PL3eQjW9nmA/Cph5Aj7Qt4YMAo870y7cGiuvzZf3mDZwH/gBTgLJUsqq5ookSqVcmpcwr/a/fLzpONkNe0tlhi4LNCDcBxw1kT95YSOU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb4c70b-9c89-4849-74ba-08d804116ce0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:56.3667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6uMZzSn2Wfa7Kv92tErAJQFUKVRnQ2MMzNjmLS6ZATa+TXarc6jiZd6gCZhYw2phba2oo6FU4thZ1H33NxZRmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

The drivers reports EINVAL to userspace through netlink on invalid meta
match. This is confusing since EINVAL is usually reserved for malformed
netlink messages. Replace it by more meaningful codes.

Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6e7b2ce29d411..10f705761666b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2068,7 +2068,7 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 	flow_rule_match_meta(rule, &match);
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	ingress_dev = __dev_get_by_index(dev_net(filter_dev),
@@ -2076,13 +2076,13 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 	if (!ingress_dev) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't find the ingress port to match on");
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	if (ingress_dev != filter_dev) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't match on the ingress filter port");
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
-- 
2.26.2

