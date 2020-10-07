Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC86E286215
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgJGPZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:38 -0400
Received: from mail-eopbgr00116.outbound.protection.outlook.com ([40.107.0.116]:11397
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728430AbgJGPZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIF2zRh/heJhqdDojH0Oxr05Mk61jgMoYxICvy14RQv01i/qkFrjQUPw0SDt+bwjeVr3ml8ViH/Fq42aJyfl0In87XkmzirXzgLwS2gKP5mqlBBYA14HNO4QfhQNsyARuyjnb+BYukLi7tK7HcJuFh1GLs7KYDl32GT1kdTh19yYPK9HP0TTBF/dry1qv+1bfqREIlfvrZB+a7YXangL2zUMnpRO4Yc4CHiT3ceAS0n7zgS/Rj9OOO3QhIr/oz843fzycSz0a0wdLQcp8kVVSNYEmz9LWv6BbX/S89/sCORkvV2GNrnB8zlXxER6iaMm8Z32/F1d3u5fROQsqcqC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhxQloRrrqx68ZSJ5Q291n9pvxp1ZLPavwTFanwPuUs=;
 b=GvfvgzaDDXB0o0C0iLHyTWRhfTjRwkoJKYVo7xrKk3ZnOIpEOuBGWcfhRS/01UOfUKokTQhADEaDhtWUjd5hYpty/WJpUAhTH0sepI+HF9MzqAk9QHhlSDsSMK/Fv9oUpv3cT1r80Z/jxz4U/tVKnxO7D1OwiKAjsZ420CRKz2RDzNOxMAOfNtYBaKhCywLSamlGWy9dWsyZUuJct8zq2JLkb4SGWPYiSjcprTxeRrH831PA3zHzHO3ZB5gDDeTJUh9PnzGbSpuXKzNSRFk/OKmFdthYqvbH5MI2PcW8+w76jBPsktviuMvznpgdq4nXWckPigN/KDgVX19nLKcHtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhxQloRrrqx68ZSJ5Q291n9pvxp1ZLPavwTFanwPuUs=;
 b=I9jbVGcoCTChPLtWWtIA/G7R4NlSE70teUD1Xl25FZmtoIcXciMD2vPq0/x3PsHDRQQ+7sPc33sXimD0vLLfTYV9nb9Ukw1qhHZfZDYNUWGj001zPG6rxuNok5TT358D74PKQ+tU29Krb7HV6tMddt9f+ocf9ky9Cs5SOUIhCCI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:20 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:20 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 7/7] igb: avoid transmit queue timeout in xdp path
Date:   Wed,  7 Oct 2020 17:25:06 +0200
Message-Id: <20201007152506.66217-8-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201007152506.66217-1-sven.auhagen@voleatech.de>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR05CA0077.eurprd05.prod.outlook.com
 (2603:10a6:208:136::17) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d7d8398-181b-48b0-63ed-08d86ad53390
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB608283532C863235C6BADFC3EF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WVDlHj0C0dfJd8luxIC5Klhk4P8+96oK7Xpupz2glJbeNs/AygISCTxmB9V1ZWko+T+nb1YcGAG1N80tZzd0dTMijP2z53XcFNHlhIwGzYogz1og16O9aPwGWs0ppFrByKjMcr0Tf9i5d1UypSMqpYh3VYlhPLVT5M0p/KktdLqPStDZKg6WdBAmBXOPDppKjPaGIr0vQ5r163GJWea027DLgbne0rJDazSmlAeou3OwBFoSutJydZpp09HDYsO9luo46QZNh4mbvkZF0C4FHuFwWcbR8v+uCc/R8omt88QGXKeDr57QK8nlL1WvzeId
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ojIty6b8AlG/QXXjXoBVkXkur0rnuyWBzmcWmOc/K/n3v7q+EF3pDXd4UX7PNF90njQ5ImlFjDU2KPn4KE+1qswbXpmfMvUmM1x37mEAOtXGCk6/nPv2zMkzgL9IfyLALZ5zJ3Ya3n30kByNa1vRGtV2n6x10mk+FrElmBjp2tElKW6C4RHlwWBIn8K+BNZpfok94tPKIM19+7evC8dB6EJN54eOsw0NRQYXJehNdVpiwcdE33cjCtdzn9TUJo0pzs2+DcW5x+D1/Ch3nUz9gYxSTGS78Xc5eU/uXp37iysHtSr9Gblr03kNktWmRJj9Pdb9ZIg2zFTRCcqYRnSxQsTmMEHMHW4CQivlcbm11bXukP5vq1RbfaUuutxyOxLvCWrRf6yYOXXr/vByCTIf0yU6cr3bUKoWQvP2rfaY96uw+ZS5OKDW1ph0erLXSKh+cIKjJYyB2d1BeHjCL3y+BwtFDeWmKCS5Ldo+6uaRTRRlQrIc4eHjEAAS7OosTehlFiGVt/T1+gbI7bUgP+aIxUgRHyOfcB99nvfspIJDOqX2Kvgd0bB1qWAfiPIV2Qyx5015I91Bxm3iPgfiAzGWJX+NjYzTy4Pcvxk5N3zAZt0DXPu+YqrMksKs1cA/O6gt9/z/i7H/FoGRHvf8pq2Ngg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7d8398-181b-48b0-63ed-08d86ad53390
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:20.0784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7DInmPGWGrt6hvuW7+pXe8aUfUpb4xebFpXa+/GXeTtxC3pQtvP+trOnH9xuRe6AzKSoOO/OK8AognpSwjd7t1Z/rYLKrkERU3a7pSSR0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since we share the transmit queue with the slow path,
it is possible that we run into a transmit queue timeout.
This will reset the queue.
This happens under high load when the fast path is using the
transmit queue pretty much exclusively.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 6a2828b96eef..d84a99359e95 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2916,6 +2916,8 @@ static int igb_xdp_xmit_back(struct igb_adapter *adapter, struct xdp_buff *xdp)
 
 	nq = txring_txq(tx_ring);
 	__netif_tx_lock(nq, cpu);
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	nq->trans_start = jiffies;
 	ret = igb_xmit_xdp_ring(adapter, tx_ring, xdpf);
 	__netif_tx_unlock(nq);
 
@@ -2948,6 +2950,9 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 	nq = txring_txq(tx_ring);
 	__netif_tx_lock(nq, cpu);
 
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	nq->trans_start = jiffies;
+
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
 		int err;
-- 
2.20.1

