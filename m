Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4A291062
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411423AbgJQHMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:12:46 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409917AbgJQHMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAi3rRw+PI61EG++iYCpSMnnrvvTWEJfZXtSzpXsBe5P8K1xyddSp5whOxFl9v5wsLKooeAT4/Kxp1+76/cgAR90JRpZS4nXaKSmAAX8vbi4Xbspi2gg4nWEdUuUsKzUtredmVnjf0KkfFE2ROnSfiOeHKCHf8X5KhM4ML6WSPXk6v/CS51Zaye2L0LkTtives8d+3glglVMDegcXtX4ZB/p4wcbeU940QDzmwwHNqEDOTCK/H3RwQmXHoxsLFVlHq4X8TlB419VTpm5NAJj1nvjV/T4ZXf8TSo2AwplEjJaqSjWAWbAITMMizc3nViA4gwnh3+fWSK/k4yrKlB78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r96DcCPBDm2rnnESfjL5FjoP85qsoYT27usAggSNawk=;
 b=XYHZ8GT5UCpwEXCec26ajCLravhfDM3igc1ORp2/W9zUAgzbiFtkCZIsVwy5M4/vFc8jNj/kNkGX+RSxQObOzEX27GTQ+HxW74PRtXp0ZShhkKjAHPUm3Cvs0d9iyKVeWzEUVGmUQSBeIgAAUhUSsAvlVx9J6mKOXVow11zxlMTYvMkLQRfx8jbIKe2lz2Vw2L7gsNe9xt2z0/SitYVRcmkNg1BuWlSnwJwcxIY2F6kL2hep1lxl3AMd+jdDWMlS9h8+DSxIc5fSZdHTIZA2j8Z19e+jlL3jbUmwomdOvubQsXNHYpTEQ72P1LnaSE7MFpRVrlrmqsVXTvMeWHOZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r96DcCPBDm2rnnESfjL5FjoP85qsoYT27usAggSNawk=;
 b=E3kCdtN9pMJKGJP4aSiGP5Jy0MmRcUfRZxdOxBUcS9HDPmCYFdCEgA1wNdk3b/f8dk1DgiZQc9BqIknVuFRzP7bk3iECLkMhEIoaHBB1q2o+qpo0tFkDr0aZk+y39m331yw8jWSaxmAPbFsT/nb6F4TW7TVm110YWUNOf2p7gcU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB4018.eurprd05.prod.outlook.com (2603:10a6:208:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 07:12:42 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 07:12:42 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH v2 1/6] igb: XDP xmit back fix error code
Date:   Sat, 17 Oct 2020 09:12:33 +0200
Message-Id: <20201017071238.95190-2-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201017071238.95190-1-sven.auhagen@voleatech.de>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM3PR05CA0087.eurprd05.prod.outlook.com
 (2603:10a6:207:1::13) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1e260a0-6069-48c6-1af7-08d8726c09e3
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4018B89F634A4E832D402227EF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xm99dOg24Hc8/sBpurj+tIbFW52Qn1zI1IfUnO2UeNzPvqRIvr/jo7JBmEulfp2DIkF+CTM2RigH0uFNtzZXdxIDstGHfAWgQMczYq3bMkM1HI1U5dNSl2U9P7ISczhbw7uN8904cRJjtKhTtBMU476WYFD3MUNW4obbrJWz3I1WCxeKN9n3RvTBraX8hEEhSu9q2gk6fEz71KeKchH25/0Ij3/2I9JeNRwEvOyIRtVWFuL11FWYutgxNrPj6qbzgsU2JA9/1ohvorBXPSHTvBwDtA2mDTeEgYMjiZi0BYdywGuOSy1zlMOFt9ASJfzb1VqTLf1VJ7f+/etxcFx3gEXQlwUTLraPuIYeoEdQWLcSwAgSAVUOEOvG0KoRzgBc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(6666004)(83380400001)(4744005)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bAMrIoMEn7TUEsI0mN3EKajVRzwsWRt67EqYGanimFcwQ1GwrtXxlNmTicL1DusG05LujH1/maGA8hsckRrF3bDogGIFdBhd4v6fJlTFcP7gaLpvU1bbObbekNnNnRS8dOwYLVxO1eUjqGp88h0Ulay6OpPcmf+rQ5lUI4FNiVnQYSo/Jfx6Kd7lbxIrZdPHdIgY85XzCEfSMNMUDOlmFV3Oi8j4iJPbPaYFoFxhnW5aqJvP++4zr00qGVf4CIEYz18ytlUTMJAoFSUnPf//R0OZ5swys/m3sxivMN0fgq6M4S9eQS8NdkEyyxTzEaZPn8QBWgcBq4s25PValG9ChkiW7EfbJbOZu7cYkWETdMnhjSPKg3C+9sVQoIrJbFewfyeBIKLC2cbLt4hhf7G8Y8pBLWesiIfyCOfhqnwQjIypmeFT+3S9LLUg2OZaiJr3QPENtT2JqHTgumLMykM+eIUA8oyqLHxSPu4CjYpKb3bxWdU+EEDO/w/R3AlFEvach35vnl7MBiFlm8+jPGBx5YjOpepaZsc9ilFwAa6kDh9cfFtI7MZdxCxnF+mF6JIxLbEYKF2uIiA+DPEeiIAFQ3W2EnkjgvnIJsFGWlvOWJzBe/Gq06ZPBgmfN/mfjRPhsGYO8qqytASJx3Dppnfoww==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e260a0-6069-48c6-1af7-08d8726c09e3
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:42.2834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCiSGAtOLKjh1Zm8YvWnU8G9MPKJcB3HReyyAC2lVhVvZeZqAKpjgIqaD7huudvhLfFgcy83Y0fylrt+bLaqL/R5ORX3JpsTumWyXzLCoAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
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

