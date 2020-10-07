Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F3F28620B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgJGPZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:22 -0400
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:47836
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbgJGPZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ek3kxNhydQoTzhZhzpHvVYY8Qc/fIUT2I81HWE5cSAtxK81qKCz0wiQzUlfmwEd+iTXlzE6Thx2OuzXkbnB+Tx5QoCBoFKju/amgbWLCf6/LQXLRbdy0bFt6oLlQ6P/rO7Ksn+FPpSsncPgYiBXJu7rTmrg3FTeH0z3CtTKt2+wnJdyyzE1alqyoo7UKDQnuJ+m8a9Vu1GHNJF1IY8UyHpPadYg+RC8LPRlRrFwSnQmG0VsAyN8oPdO4J0KQNqXEPsF05BVnzXu4uHdWLxDMNlmPoDeBCNR8yBhXqkQXzrjNLpfDJV8OWzu1e+QYhpO1QWvl6THv6IwjasCScolvAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r96DcCPBDm2rnnESfjL5FjoP85qsoYT27usAggSNawk=;
 b=HKA4PL1CizfYdWsIm0chhLJig3YE8uCEW2HDPKnDh5khA8vRKLZepHu8KuZD5uOMg9l94GMRDX+wov9kvgI2M15MFgCBGKuK7kUNIyQaYtQQVAh9lVOxSYh/DtuoJpEv1t2Rqr3s8vqZVFDwwLL8kVOkr8Z25ZgX7w6fzCYwCgZR8NSgmeFqXmRs6Q+M1bTx1PwrbHQVuvlMHIj2DQvBWiGSoZ5lxdmEb1QRFQe+NnAy4ovXDVKa3LDANMxsEyd5PY9YTmUOfxrA6VA4eJpvtY15nluMvOyyf14rv9B26c5saBgB9F1uEXcI56gvNZIcfWzz9Pyvn3QMszsK+rdEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r96DcCPBDm2rnnESfjL5FjoP85qsoYT27usAggSNawk=;
 b=eBs6xMmHC7UIc/M7sNHC3N3xAqpxU1Fw3KZCnxCjMy1MnUjPaeqTQ+I61wV84SFUEUSxDgP+l3oUmecFgEWNa8n0gVJK/RCF2axKynJDm4bB7uIzD5XJjdcoN+w7l4TNtHO1kU7mweC15uAJgZYqZs0+y6mK12XDi2Z7XBR9lKI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:16 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:15 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 1/7] igb: XDP xmit back fix error code
Date:   Wed,  7 Oct 2020 17:25:00 +0200
Message-Id: <20201007152506.66217-2-sven.auhagen@voleatech.de>
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
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9545a86a-7a9b-45a9-cdbd-08d86ad53104
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB60824409FB57D6796886AE9FEF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3PzDKi935cPANcfoKvNBt657F/pQVILNAaQYb8FgGKsMkDc619dHLRed4j7pOoTwzmuvBEFLlblzL3KlUer/8uV1bvuCnLP0h8ff2cUazcQ/cQ1ws19diKkvW06SW8G5rrHJ3TdX405BUq8x1b5XfDJOgAUJO0dIg6iV6NlWoK53yAlas7ETc90h19GojnPbhmZEUxv7lr5H/ZW6kozZa5df5/5qSGb5pmI7CW/toBVtqQj0X8MuuzArxtqNfLT+pmi9uPcoL7G7OGlfooOiLWct2g9t9ypme/raRiXZkTfd+7IVV15R0eHa68nwZn3k0khZ2RUeVy1ydLRhs6SXZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(4744005)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2h4/7wJm9dVbd+jHXe3YfcXexdcOTTONAAeFOy706VJOv0C3JSVt6aQRDIKWjIHrB2crVVLqoXgix+r+UvGS/zg9NF7Dvlr0HZwTyfRnfivGROWLZG+PvYiznxvP6/pqr9EY360EwUl3Osz6kisVg4Bzg1yy3BfXpA5EYhJp+5VgbSrAFD5dOl73mEhdreYadqd8cV4t/PSVsPkluzU18w0pImrZXEYGUPBiAX5kf20bTDF2kPcfCwVzReoaZ6jaNBn30y9oRJV5HLsxK2x+9SeXQLGGcamEzkHMVpnZjMuyoYLYSgk7MuY5b2WHtGAkcfjBuSXLkMqn86yLaPSdstWia7/vpvCq2keOKMuJSpnFtUwwRmTUmFTAUNyub7ntg7mSodmPSmaqDfidYuN+7I6N6Hm+Uo/bB+/WqrdQc8xmt4BUhcPaxJctoKJLDcfJMCqdAdsNktlwUF5T3UmqIbaVF0TDxunCwsreW8H6OTApivw+imhLET1jSVsbZGFqT0UPN8uJjS7SXUE96LjXrmPD0DMxyHmEYPlWRoL4Bf+3g3YbBnKWcQomTfYO0EZPN1ixEFB0846edLwFZieX5+Vm9asa+liAfUb+OtceNyNdc+D0RlRtGLiPqPQQz55A1XQOfqZs/csOq/5LUlA8UQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9545a86a-7a9b-45a9-cdbd-08d86ad53104
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:15.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GmE53lkMnZ9zTkY5seSWeXI3G6LuKFJgyU8nPPCz2lskTghJJxLMBe3lvVHB07eOkPrMiJocLzd1gJ6TQm7vTBG3UoXHPJyB1KPLiHXVG3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

The igb XDP xmit back function should only return
defined error codes.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..08cc6f59aa2e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2910,7 +2910,7 @@ static int igb_xdp_xmit_back(struct igb_adapter *adapter, struct xdp_buff *xdp)
 	 */
 	tx_ring = adapter->xdp_prog ? igb_xdp_tx_queue_mapping(adapter) : NULL;
 	if (unlikely(!tx_ring))
-		return -ENXIO;
+		return IGB_XDP_CONSUMED;
 
 	nq = txring_txq(tx_ring);
 	__netif_tx_lock(nq, cpu);
-- 
2.20.1

