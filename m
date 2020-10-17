Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38547291067
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411559AbgJQHMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:12:54 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410562AbgJQHMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kh18N3KDqdvkR+qM3pQifxCGjP+F/MTZr+8YRgeycefEHexEsaG3PGKxHkn40n/6oPHEXS70FFbFoMw/ji/q+02RtY+LamOaNmU5lGQjrrLlk369bTzDQ3urP5arM6boa4OsPUyKzOj+GKGOrIEWAqDr4LH+Zzq9Yhpk5lU6faRtYdxBB4BIWK/rr0F1X+FOAKi2RnUpuq+41wHTgA75jPWMvxM+w+3LzXrbxeLyYc7v1rK5GMMopy61wtxREBAghABL1YT0MHhUKB46LyyhsAuJlccddfP/N8+yw+OnBjfAmnyAoBWjsTd92prFgvXdC9tOgr0W5NWe9JcsF6qBtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RJUyn3l5KEbyiNpVrWb2MI6BDEnNjHb766LCgzmHRA=;
 b=WWrdOJ5sSi8MKLpY2lfX2rqVx5XzOLn1YQdDO/WiQnzuABMqQqn+GaVdRYguGzEVGDYFtEsoJAIzL/gBN0iIi9TW1MvFhhEkw1NtByMLpRP7kYRgYXdRpkhhAO0/Nee/7y+NxvQREf7Scom2t6TPUeLLm5dYLWreF1odbXo4QFDBeqO9W2qfQIOnDCU3SdnZ2U4NwxZ8UZvaM59PlOFy2U2kRHl6i7/klQ79KGXy8oOwlaaxOdhACrwkaqY8nyOKWzoZ4Zz7o0OGXOVXzqpCETq0Foq6aUGCCo9BccOXEtb8gevMZmWm/3xmkPKrEEVyfaWzN2bjFAA5YB+3KOgGoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RJUyn3l5KEbyiNpVrWb2MI6BDEnNjHb766LCgzmHRA=;
 b=beVcfwfYInRJrp7atcLKmxZQi31/IgpWHXaatCJaR+oqtoh9/WlnFsBIqNMdrUrn+GZIB5YwStp2vUyydyS3QZF2SY/hfQB+UvFhiz7FlotQmXWpEhAGFV/BNoFf7CiOPm0X8DR6UuQw6Olb7qJ2SaEeP1xKBbAb+lD663684bQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB4018.eurprd05.prod.outlook.com (2603:10a6:208:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 07:12:43 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 07:12:43 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH v2 3/6] igb: XDP extack message on error
Date:   Sat, 17 Oct 2020 09:12:35 +0200
Message-Id: <20201017071238.95190-4-sven.auhagen@voleatech.de>
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
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b6bc61-1d02-4ddf-777e-08d8726c0ac5
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB401856AD80FEE05FF665582DEF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xhzkWBshD9KhgZCgg1/7DBHJ6GXtyWV6a5qYW8ba/gUbX4U6aAiRy6RcR/OLpeVyPdCQ8DS60hxxQFpqeHm0sBVmozyC3TPG41Up7ZHQNPAfwrHn/GuNx+xMOkCu4kLLF9XRwfVz+KV61glnLXWvxGOrtTZaYpOVdX3cIDSNAuhyGvmj7c/+ytxLgq+/65gNouZUQQyAn2oCoGdzElhtcXuddNao6dpasdHChu1ZFvp5uAwxD/Zv6Whgy66HS4fv9/BD4xOU3HAF5zHMEcb+qSIWHxzvE9wU4hUHAgMBCaHriO6bEyn8cTu4oLQGKxl3v6btqaXd8Ivrx0ifaj0e0UJsOsno6Mq7Plv0ktIWzWzl/9aXpm+/q+OUe//eJVr/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(15650500001)(6666004)(83380400001)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TWn2hBV9SN04HcdfcS8V1dnUUZ/wtpG5GJuPoUFXMjQ6HMTaSeYCfjagFU6GJ3/VHKa0OKTizXl9O7ChwRQj585sCVMyT86827b5m8NzbcswBFO2W699gnBQ1JnYWRvA6TQxwxTDR6XZ0ingBr+kASIbArrGXOVWb5bbqPiratuLPRvGrDsc3Q5Jeuqz8aTmmv5KAyYBJHd1SvO7iQ6yqtFXrV8KcPMeEjvIhfop7Cl37Ynyl2lEo44tSKBMAhAONvsBrnWfgLOoNY13nxC02fpOXUvgDsNuFC47UecCThH7clWZQ8gd73XoGB2Clwf1dKvj23LwrUaxpqSV9I1sCUUuUpWt+SKg87w2/3ODHIWKmWunl96SvyFlJzCw+kaTSwjDSONdGK6azqnwFUOh0nuS5dKcPKbj2wkJPBWEIc/uePNR5UvOq1AUPO7mNChwQfw1mBQ/k4eXcUB7BsPUJ+QhGRjcerRQGwepdMnTgrndFvFDKGsjeUffSvszXn0dCTRXSF0MQXut63CDBT5e/W9TyQW2lztSjrdfdyl172zzf04918C5BzDMJPd79uARzIYSczIJbzM+8SaAD9TFOYS76qcIP1Zc3S2abtHPrXz1KzD/C16eVvDXE16Us4tPStnVbjvnEaE7oFfm9OOPgQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b6bc61-1d02-4ddf-777e-08d8726c0ac5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:43.7410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9asw0JhIbQ//mw0GQ//JrKmh1OCFzurs+2x7i2ASl4rjVMRjRriV7//nHb2AzCHsVGDa1vVmNg8u/cr6uaTlOwauaE6KIlY17AL39RFKfAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Add an extack error message when the RX buffer size is too small
for the frame size.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 0a9198037b98..088f9ddb0093 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2824,20 +2824,22 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	}
 }
 
-static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
+static int igb_xdp_setup(struct net_device *dev, struct netdev_bpf *bpf)
 {
 	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
 	struct igb_adapter *adapter = netdev_priv(dev);
+	struct bpf_prog *prog = bpf->prog, *old_prog;
 	bool running = netif_running(dev);
-	struct bpf_prog *old_prog;
 	bool need_reset;
 
 	/* verify igb ring attributes are sufficient for XDP */
 	for (i = 0; i < adapter->num_rx_queues; i++) {
 		struct igb_ring *ring = adapter->rx_ring[i];
 
-		if (frame_size > igb_rx_bufsz(ring))
+		if (frame_size > igb_rx_bufsz(ring)) {
+			NL_SET_ERR_MSG_MOD(bpf->extack, "The RX buffer size is too small for the frame size");
 			return -EINVAL;
+		}
 	}
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
@@ -2869,7 +2871,7 @@ static int igb_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return igb_xdp_setup(dev, xdp->prog);
+		return igb_xdp_setup(dev, xdp);
 	default:
 		return -EINVAL;
 	}
@@ -6499,7 +6501,7 @@ static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 			struct igb_ring *ring = adapter->rx_ring[i];
 
 			if (max_frame > igb_rx_bufsz(ring)) {
-				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP\n");
+				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP. Max frame size is %d\n", max_frame);
 				return -EINVAL;
 			}
 		}
-- 
2.20.1

