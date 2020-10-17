Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E829106E
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437428AbgJQHNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:13:01 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2411544AbgJQHM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqLGIlcuDopHLOjWeKRIgSdLkDhD039xAMYrPvlK8HWYTx5cpZlshIRDsQndWMxYKyuFrP0iDASDOuZcX216H+qnmQizdPt+eS9BlIenLCASfcgJ26qOiINnuBY/yYJf1NnSiX7lQJW+C3j7xpzs/WiUWdJNY5MB8kw+pE3+NgjIguOPk1WnzZqFQQrqRoDqbOmDukpH9W2BPRa9H1ERvmJQy//65D/8YyjLJLcCPX8i9JrRXstWwxITB5J2dhKHY0axAEJSlybtzGr+knRguix03wtdMEQyRBAfUH/9kW2fjow+pDccWUYRxaWcyroJxp0MPMc4df/mzpL18MKTyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DLiyNdhGj0+0KgnlM3fZ7TuIWFyC4SHOMOr9MEo2OE=;
 b=RryVBfc5TmGtysBbk3rpf66HXcrewaORm2z9Vvfod5TK0rJsB/Rb3L5eeE4wne56/gKes/i8+B4gGuflikdpWr8nGSMm9qspH4TU8w3PFt93w5R3RBJV5lkpTbxSRVId9kXOchY0nSC4p9FVsyG3w6FdCdMP+t3pNmIik+X5OaxFR647V+hzmKMo3jgl/VPjBFXr2LtkyGHz7u3ayiLA2tvk8nXc+R9roxO/EG3DSxQOLN65oiHfrza16qf8UsxxDkO9HzFltvfgPxHnUmHGc32EZSdIhulrrTkeB41fXb6gQEXYRS5PWWQlFjrg5s4xLiCrrahmEee92NVG9W2PRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DLiyNdhGj0+0KgnlM3fZ7TuIWFyC4SHOMOr9MEo2OE=;
 b=XCWMTaWDZsyjqx6ryLTYDUn/yT+SdRZK3FksIIiRGJPOtN612jBANdzOhim9+H0CBCarCtPXGvvhfgruB5+OLpBfTuSdbMjqNAjzBkL1E80JYWuW9K11QBK/ae+uE5I03wEMevIzkMuBZFDXH5ryF4TFayKwajf9ru/QnMlOSaw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB4018.eurprd05.prod.outlook.com (2603:10a6:208:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 07:12:45 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 07:12:45 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH v2 6/6] igb: avoid transmit queue timeout in xdp path
Date:   Sat, 17 Oct 2020 09:12:38 +0200
Message-Id: <20201017071238.95190-7-sven.auhagen@voleatech.de>
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
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beaa3a79-b386-4348-622c-08d8726c0bf5
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4018B91CF644A605398F5BEBEF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkdrgSLp/D4nOKnb3z7sZUTr36bxJTnjXw72j/TxydyQhSEs/VhCNqeo82kRQQEB2Ovf4wRtMAo8NTT8lVMu0QQc74feyCc1CE6ENalnlZvfhuoFxYCkbVAwGz7kRLHM8i3JCFa1kUJZjsGo2rmko5ExE/HqNbQNXMuFCBrsPd7myeQtUyJM6FLXeAF4IirhExmfTefdjzgq0BLyUSxx3w5ohAVZBaQJ9CURRW9vAboGv/45mi56Vsr4s9W9OPGhpH5q6y5mdhZtIxLCf9R2OgFMWXBGHV2jhHu0V25C32+Oq2cUxd/vq+1LFOKX8SebdvYJ7DQ70NBz2A59pT3DKsIaEFDoEarOSS38/Z3Gw9HHpyNpfCXF4hCrqd4kOOh/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(6666004)(83380400001)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QUXhR0+fTVmGNDabeiWPS6vRk1l4PHg+9LvB+p2tT3obY11bxopqla7k/Xvkr/mqLliwgKjdA3EtzG8lIS6BidlV9SuSw1E89XVAgGvEki3WIq3oulXdqtQzHrCjafw4kqrkmHiQv5Pmg/fLECjKyc46BNUCmQgo5XygYcULvHgM/bIAb84vmFUogiQ6K7pAK3sIvOQLQY7Mab9aXu4KtRXmgdsC58yAcqGiOmHrH//vjAolM0jhNb8S/qjfLQf08W67r7/hnuFmd5jouhTIK24bld6meHUXWGYlCEBBGgXDm2F8EqsO/DuFG0wRZbefMJE9MIMCIcCfmoT3dEkT+Ow3SIpc1aVuP5JjRvzB/yn7qLQjTDJ8HyZPhApzXS6Q7rJNHP6nf6gkaSpuhhJyG2UDcqyrZk4c0ZyK3Atqooa/9fkdb1QIk7C2W3+EM1s1i//eGlUktSXrBbJEFuijf/mKDk3BbH4cR7Yr0FnlLb45J2srXssyEe+WoElx4JUqkQSaSMyUBMf4ppkaGe00Vdx2h26XzcoT4dgD1AYKkU6SAh0zQDsn4pZNmuyn69JNMfJziXQ9q2G2SBoj6n5lL3p4fkEh1N8je3c6jLTeGJhsx77Xrr8fSdpiqQsbgf+brcMGOA0A8ZM7u8DCV9IBAA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: beaa3a79-b386-4348-622c-08d8726c0bf5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:45.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbBAAnV4fJvtHUS3PZxDH3aw7ZQwRcJOGYM7TCboszVl1XIUB2hFuQH5xDEL8K6ARG7DNwF7jgo7do1q7Am9C1ByAWGkWr+5phVRMhYFwUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since we share the transmit queue with the slow path,
it is possible that we run into a transmit queue timeout.
This will reset the queue.
This happens under high load when the fast path is using the
transmit queue pretty much exclusively.

By setting the transmit queues trans_start variable to jiffies
in the two xdp xmit functions we avoid the timeout.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 55e708f75187..4a082c06f48d 100644
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

