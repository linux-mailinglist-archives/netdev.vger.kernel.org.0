Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A4413D728
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbgAPJo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:44:58 -0500
Received: from mail-am6eur05on2104.outbound.protection.outlook.com ([40.107.22.104]:63136
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbgAPJo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 04:44:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArjJH/+6CpGvOQSQPQ4C4XrNd9QRkRMQuhy2CYZK1xyu7UsupoJ7fofO6VGowXyFTXIiTNTNewhy4c6RcInUyIhlSmAouk0hYi5A3QwTN01oV2CPZRorMm4M12JrjPsC85N6+TZeiM26wBYgbKsQP52ofTe4dhAIoI7LI8vERiC9lnDuQ5Br/1xmDqO8Bzznq2OP20cH/E/AFATeLI0+qvajrJ4YumD3bvkpLHkVKR0AbFImcEcDVLqfA/JnZxsP/icudipCdlRyYe/1GKlnjQoiAVgr3ACVeRgivdMTmZcvGMzyilugJ1HOFbSuwxNT3Zia3E0uFhCaIFrU/vTLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oE5Hj6vN5jkrT1IqFBpIcPrxPKxReVFtXPvgt+yWOHM=;
 b=Y8HG2iyR3QnswkhTiww1vFXhGY/cJJfGclf4F763L5hxqobuEAolb4panD2yYgeZKm3DiFbWS3CoBl9KypjdfkFh8j5J4TGu39ti//21QmGJW8wuRBZRRAgZL6FxKAWdg+x8DLKjSTr/DSF+c2ElunOLMNDmIRkfKerWC7hM810GZl3VHls3s3gFRnLlKZoL7KugxFT7SigAgCSG9Y7wGlVxCICl6QB4bBUIkvBNT36LHxE2q0Rr4VYSqDxdgEsziovuKTz2sxf7va9ff+xNAbFDTMBCgI6nFwwHknfhX8y2WTjdaOPQaF2O9+26hsZv10iBtDn8mQNNG05efgKaAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oE5Hj6vN5jkrT1IqFBpIcPrxPKxReVFtXPvgt+yWOHM=;
 b=nL6S//0qa0jxBQcMhmYv0L2f81T9Ywyy+wH6u/MAVZ0+ulxy9n2aTEfL8ckKE7u7Y2uvX2VRBvnVmYceIIvQe1T+8rCOmfD83zq+NabpBuptvS7OQA55E7GTlTCfZ5KIzWiK0ODqoJiysZdbxmihxaNCKnu/Y0MEeDyrHnQVzAs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=niko.kortstrom@nokia.com; 
Received: from DB7PR07MB6010.eurprd07.prod.outlook.com (20.178.105.146) by
 DB7PR07MB5833.eurprd07.prod.outlook.com (20.178.106.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.5; Thu, 16 Jan 2020 09:44:53 +0000
Received: from DB7PR07MB6010.eurprd07.prod.outlook.com
 ([fe80::181a:aaa0:df96:8bf6]) by DB7PR07MB6010.eurprd07.prod.outlook.com
 ([fe80::181a:aaa0:df96:8bf6%6]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 09:44:53 +0000
From:   Niko Kortstrom <niko.kortstrom@nokia.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, Niko Kortstrom <niko.kortstrom@nokia.com>
Subject: [PATCH] net: ip6_gre: fix moving ip6gre between namespaces
Date:   Thu, 16 Jan 2020 11:43:27 +0200
Message-Id: <20200116094327.11747-1-niko.kortstrom@nokia.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR05CA0157.eurprd05.prod.outlook.com
 (2603:10a6:7:28::44) To DB7PR07MB6010.eurprd07.prod.outlook.com
 (2603:10a6:10:86::18)
MIME-Version: 1.0
Received: from zbook-nokia.emea.nsn-net.net (131.228.2.26) by HE1PR05CA0157.eurprd05.prod.outlook.com (2603:10a6:7:28::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 16 Jan 2020 09:44:53 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [131.228.2.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc4bd2ce-5e47-490d-0b6f-08d79a68bd0a
X-MS-TrafficTypeDiagnostic: DB7PR07MB5833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR07MB58339D54CDC88D6E5880EE268F360@DB7PR07MB5833.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-Forefront-PRVS: 02843AA9E0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(199004)(189003)(6512007)(52116002)(956004)(8936002)(81156014)(81166006)(2616005)(2906002)(8676002)(66946007)(26005)(6666004)(16526019)(186003)(66556008)(66476007)(4326008)(478600001)(107886003)(6486002)(1076003)(6506007)(5660300002)(86362001)(44832011)(36756003)(316002)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR07MB5833;H:DB7PR07MB6010.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufoTddrj/TEDEh2cmw2tz/VsqMX7HxkppvMCw0PFhQxaLMQaZJgKmGUnfINkegmeSeGhJTwbaVVqBd+J+jimRwofBRLtKwT8+3sx+9k89zEUGsqeGXkHMSsGWM5X5sKtMUT1sBGZDVburr7AzX27477CW3v5Rstrwb0ANU8ZhqeI0nZXnfqaQ9Ns1uQXgPPd/ydeYhh44uR7gR2gCZzwOIq4poAM7sk5ZZ69uSEdpzpRydla+JyoiHFRS7GvYMePH5lXrEcQiDmBH6UTcoCF5+Y/OCjRm2M0YTGkOEkrteMzIjBpAHUYkPokmoL9IAplykHHji11JoQ7bwnKxHddryWSHRh2clFyTxF7DPicUWMNNd33tVv9CPsyElQ1vCxv6bonuh3WTV0il6ZwEAYfjLHTt8GKYRdzrcTnUW5cW94gDyU/5KcxH3fzLfDV0g/2Ypw++pH7TUbySH97Car9AMbaKaD94cLMhxKkan1/9f4=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4bd2ce-5e47-490d-0b6f-08d79a68bd0a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 09:44:53.6522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Yru6s+i/YQIvhvc9FCB4QsXp9oHbenqPmPkdl3Ffmsh825Ahk9tqMHt2PoXm2P9AQ+9su3LbRF2CtxkcPGuhkog+bUHPhaEV/bsgrNL0LM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB5833
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for moving IPv4 GRE tunnels between namespaces was added in
commit b57708add314 ("gre: add x-netns support"). The respective change
for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns to
another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag from
ip6gre tunnels to allow moving ip6gre tunnel endpoints between network
namespaces.

Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>
---
 net/ipv6/ip6_gre.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index ee968d980746..55bfc5149d0c 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1466,7 +1466,6 @@ static int ip6gre_tunnel_init_common(struct net_device *dev)
 		dev->mtu -= 8;
 
 	if (tunnel->parms.collect_md) {
-		dev->features |= NETIF_F_NETNS_LOCAL;
 		netif_keep_dst(dev);
 	}
 	ip6gre_tnl_init_features(dev);
@@ -1894,7 +1893,6 @@ static void ip6gre_tap_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
@@ -2197,7 +2195,6 @@ static void ip6erspan_tap_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
-- 
2.24.1

