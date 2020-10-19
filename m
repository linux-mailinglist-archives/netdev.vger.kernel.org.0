Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B635292361
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgJSIGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:06:17 -0400
Received: from mail-eopbgr40132.outbound.protection.outlook.com ([40.107.4.132]:60982
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728785AbgJSIGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 04:06:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijmlYWvxUHv6bssj/Q64DTZmEg466NROL6Hj4nWlSZPI0XyqmjMjjU6utfntdA7yHJr3ol7h0/XeM6h84P5Hddkr558AnDqYuTg2K4IAG8Qc/TMXRpTWF6KWDPuDpUNbxH+BcOlazjrYaUsqwT56ROln5Y1njVu0EThgHi7DsEbtVzcb2B0iWKmXX+SsAXrnyek5LlYomOihtz3Gyl7BEbl4S0T04qSlazba7uFuvY0uJYZO175JmYa0PxPiavT7IYjwAwdl8AlkjX59yosd58ASWyVPcXZQ7+0T0TYlyoHTsApwlU8/uB/wq/gB9IEWz95VMWyC2RdIbOtR8QgaJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDvxKoMOb6EC+yBMHdl/g2gkdbFEmd+gnSjACuJZsLQ=;
 b=mPOKSK2ja1Nljo0Y6tA6bJ9ByOqyerfxrUyV1mi9TNteRZrFAbgUw0r0BRC3/UllHakm8/F63j5zr1+EqhjBSxe1eQXxPk9l2XpJJ2G3owQbwuTNjfjW+PDIS7QIZmFBBxfRoHnAI+HqYO3H5Xk04zR1O9ljAMqx121ftKoCbFdKY0SYkilh/1U2/+aMqrBsAQQNr1wqeAMPjcKGtbkIcOFitRFnRmdQSXFBW702Ax44Gyq3AlFikmRpOcANYYd2ympFRHBXEuTfiZ2mVOWg0/JjR14o0cs4xdlTpdts44fWU+9elmHCS3/jWHZwK33cDLuktwqN64Dy49Qh7Nmx5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDvxKoMOb6EC+yBMHdl/g2gkdbFEmd+gnSjACuJZsLQ=;
 b=keBSGDCmq+3pw2mYvaUewm39spOJTAGkhbcIa1YsDeErDEIto2+yf6HFtCwcjob2wnAmfMyx7EveI/ELwdeEhlWcLcH4o9Cbxra7Hud8N5ECpZEr/uJSocPZDfIfQFiV/cxFHRqh3FXrGJ9WetGn4U05hQ0uNqfnmqTj8Zoc9KI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4258.eurprd05.prod.outlook.com (2603:10a6:208:64::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 19 Oct
 2020 08:06:02 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 08:06:02 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH net v3 5/6] igb: use xdp_do_flush
Date:   Mon, 19 Oct 2020 10:05:52 +0200
Message-Id: <20201019080553.24353-6-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201019080553.24353-1-sven.auhagen@voleatech.de>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM0PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::43) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.41) by AM0PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:208:ab::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Mon, 19 Oct 2020 08:06:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b43ba51-8fdb-48db-8253-08d87405d1d0
X-MS-TrafficTypeDiagnostic: AM0PR05MB4258:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4258332A9AE34EB93F88EAC9EF1E0@AM0PR05MB4258.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +st5tC9WrOd2QsVDwmRtvzSv0+4fH2o951QuFZCP6m7bAWpACV0e4p4n6vdT56WRJJxsimRsaP0A/JjQHwCFCRZ/Xybu6ivSBT6VN6dlfvL/C1g4XXk/7hVI1kT4v+tMNpXrk8vX26lBTmZTdfCSYo8HbiEtQqOswLVTTojbVdVYCaGl7pISXK7v74XfAvWmurXnqktYwXUBlx9xNgGA2mn2g4z6B95KSbnFTNji8823id13RyxHV/0xkdtg/t0jo4EIqt+HeOLdhzJal8Y+zaTEeLED4ng6mVYRCkhf8KUnIavG45KXND1x36gv31h/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39830400003)(366004)(396003)(136003)(956004)(2616005)(6512007)(478600001)(52116002)(316002)(86362001)(8936002)(6506007)(5660300002)(9686003)(1076003)(6666004)(2906002)(66476007)(26005)(4326008)(186003)(66556008)(4744005)(7416002)(16526019)(66946007)(83380400001)(6486002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Dd9gvpkHOfb2UVIdLvw0VonzrFv0g5mmu4IHOB4F4RnzsqjbYIW0kwxWyYqMZ+4+qqoK5IyI2uVLmSQfb2xFb0BC/kQurvo2GP/sXIpo5x6ukGUbcxTrINASP8lqOwiNiORxRau9SV/ANHwqC1iBylMix8fEmXfaPO5jsdGq+svaulLiookbiu6Lj9wr4FubVc3MAX8oR7F1f4Rr7EtLjneCZbVE/+TwI464nc6yH0eAnFVmnK7N3HbQTy7l9px5/q6C+xHK2ss0LEJ7thayGrDx6AQJbmp8R3CGVxA64q1zPedJ69wfkmVZ9yYYkwPlcYzvjA8rivTS8N1Tu9SBNQYcyUASo0l0dfYlTK872fhzq4/ZmmwzUuiskaeCjqNXfiXM+LkVpJ/8evVJRSQ4RFRcGor3Jy0nqK8wlxgoWcWi74SzsVjleFGkeeJncQasysdt3Ar0aEemFO9tGsRZJAZdyS5Ei+lUkWrUBEx00TURaLUQ3Quu/w6txQIaoi+ZiPCJoGhe3oJxfyWB2Y7U37dp+t8Vj+sSXYcbwLWGI78SalWMdN9/NRO1ILaE98lif0OETcfX3I6zlmMlcb8XGdqwkPZXPq3Q9MhfcaeNLQAO7Rb3wKFta91lBNwDRjr0cs30ANB9tJSd2QQiH8P2cQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b43ba51-8fdb-48db-8253-08d87405d1d0
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 08:06:01.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8KsSBwMzK3IVtH9h/wqTK6723HLduVu0nNlLXWY0N29Qk5i7i41ZLXKEo4UmKVIohBmNWGFvD2rJ1bFDOGnEMa9ljRNRoXMmqkshhISsYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4258
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since it is a new XDP implementation change xdp_do_flush_map
to xdp_do_flush.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 36ff8725fdaf..55e708f75187 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8776,7 +8776,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	rx_ring->skb = skb;
 
 	if (xdp_xmit & IGB_XDP_REDIR)
-		xdp_do_flush_map();
+		xdp_do_flush();
 
 	if (xdp_xmit & IGB_XDP_TX) {
 		struct igb_ring *tx_ring = igb_xdp_tx_queue_mapping(adapter);
-- 
2.20.1

