Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2442AF725
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgKKRFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:05:07 -0500
Received: from mail-eopbgr00112.outbound.protection.outlook.com ([40.107.0.112]:45497
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgKKRFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:05:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gURE+wU3D324vRDLsOj22kblQ52WaOYpwNI43C5ChtS9DDgiOe7KSQ14sJAuuFI33wO1Be3ZCQ29Rr/rXJHOoUvx5RNC6aKJDxoXWorkSxH3VDT8dc8KAvT8TTXoYFRPIkTx5rARW5TyWLW4k7DvHpFR87eZzfAAHjg4CJc0XpW5nCl7T+/Cj9LuH0HjjOm9SeiAB8LExZu6pniaCxqUzG94N0a8OzG53cKiS/WZn71dbYLJt14jEUKQ4bnOoSSfW++JAIS5ccN0WmIcPUlHZA79rpodb0vjbcXs5TwEU1TRoM+4SDnjHhgdxyoQd28JHFq8DnLNvycYUO45gRmYWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1PKkugmkABSUzEON3r6GNorCQcjvzYoOPThCR7aXno=;
 b=RTGA0lkyR7GLwM33oUvd0VXp/LxIM6BmUKn6WCs3Dh4v1dq0T1Dgr/FU2LyuIN2A03JYmg30P5CSQCj/Dnrgvc9jAw9xjxDo8yrW6LVDfCoUjTWambA78c7Ij4VcXxyHtBemz2Ct8Zg7MbXyFBT5m0b/05XC8gFhZaqDOjn+5XEEgfTXee+HqWOVPdPQUxpsNpTfyO4VFMGGY3fqFi/+WyMn/WjuMLl36ug9QGS6nmzVdeTxL0jiu/fJwx7wCASLpLLTDPVpHyEQD6umKkDE53HIa4u7dSBOWBbTaVN6Cbt4PO6v1S6RwTAUpB2UvfO/5c0q5TbzePIRXnNnH09fkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1PKkugmkABSUzEON3r6GNorCQcjvzYoOPThCR7aXno=;
 b=fMWmgyPHDSKMtbZWxnNXnsH2d1/2ENLGjfZdk/wU3S2+3pnFNPW7HQ2TVA2APR1pdZlo7YH9xiRxoQ5LZG5a9eY9c7Y6+mS93uk3xp5R6MOdqSAhbuHAdjzYcDQNPXpVHxN8uS/OZhpCV0d0SkoVH125jnOddfW7Y9Y33R4ehYA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB3921.eurprd05.prod.outlook.com (2603:10a6:208:17::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.30; Wed, 11 Nov
 2020 17:04:59 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 17:04:59 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com,
        pmenzel@molgen.mpg.de
Subject: [PATCH v4 3/6] igb: XDP extack message on error
Date:   Wed, 11 Nov 2020 18:04:50 +0100
Message-Id: <20201111170453.32693-4-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201111170453.32693-1-sven.auhagen@voleatech.de>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (37.209.79.82) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 17:04:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 119eb542-ffb6-4b5e-1090-08d88663ebe0
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3921:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB392113001FFD47BA1F4D3882EFE80@AM0PR0502MB3921.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yHeXuLC5vDyS6xu0HZiVT1qKOZRALgEP8S5sRb6WOG6EC/KqMOZM29OHQFLF3m0URquLW4R6KdbFwAFUoxojhVAw5iuDkwLIpgiUNZFo4v5fKyRyT/7Q8gcPz51BTBqivtjc8kCiHSD89mvI+tO+G6aNqkgs5jQIF/6NYhIw25Ugk7Hasar3zZMYLhGSL4dW9liAee0w8Q/2Vd6dhd9qY6kDQOOwGRbr8qBEAEIqbmNf16UbrUJDuhP8OGh1V0kwPjlPSRS4Lv4lOcTu8gJEisHULSCy7MFq8uFlf/cNKvjwK3NVcOTlP0i5dd6Pogu8B4/wRQIyJXLRN1FmNgubGCwQuYPnPHpDR+7CcbdjvToNrqm67o4eH7tbcR5na8T/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39830400003)(376002)(16526019)(186003)(15650500001)(5660300002)(52116002)(69590400008)(316002)(8676002)(4326008)(66556008)(7416002)(86362001)(66476007)(66946007)(478600001)(83380400001)(9686003)(1076003)(6666004)(8936002)(26005)(956004)(6506007)(2906002)(2616005)(36756003)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SSvPVH/VaMSAgcXJNqgLthHTWn+Fj1ZSV7mhADGIgxvIGeUPSRbOHXJag1Q6SP/ogoYF67EYCWkPk06erQREtIff2TKqg3uf1gnOCBZpv5gWFlrk15DtnPBAhCwE2v7+ZqgREVkjxrGsslPI8KkdxDx9MzoiPCElQ8hoaDcwESDxImSkSHpF0AFpapNhysEXgHbazlsj17wjSOeRuR2EdTIPEXQVFfDH10iPCvWFQtslKb2aeI3KjdYka17R0HVVIk3UrRydS7cV9w1WWYYhXktRJNAmkuyQezoEyOc3dZjbTx7HVY0QQtu4h3ncyhBjezepRp8q7bp3mSrp7WWjWkHvRcN500pbP4uQ5TB6YUb7N0zdoOaKfaYehPHFlWFIEmt0E7DEL/aPV10EfATXpHziDI9rT3VJVU5Rw9mUqnQ2Aa+m/tL93ky49QAZhD7rYXhDbe95VH7uPIOVn2yKb/ro3coFuISbq1FCZJHi5oPYSq0n64Lb9r4i/tgI2eQkVXE8O7wKl2Y45KYXzgOa6YfHsZ7yQnFubpg7JQ0GNxkfpX9QP04/TPys2BXjS/mm2D0kgqpb84CHuAdcaPsSTIQW5YIHwDJwzJ7UtVITkZcen912PrEczD0pR80X/iLd5kxdXFKr2CepAtl2ZMeQOg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 119eb542-ffb6-4b5e-1090-08d88663ebe0
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 17:04:59.1364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HX/rhfyhjBY6k4Dv9RRLd4sANoCTzUtu/MBgTNvQznghzOlfxWhmbl/wsSF1YJ8tqedoJLEJhfar3GSNsjml+3CVvsE+YuO6M5iSkswf9Co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3921
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Add an extack error message when the RX buffer size is too small
for the frame size.

Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 0a9198037b98..a0a310a75cc5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2824,20 +2824,25 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
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
+			NL_SET_ERR_MSG_MOD(bpf->extack,
+					   "The RX buffer size is too small for the frame size");
+			netdev_warn(dev, "XDP RX buffer size %d is too small for the frame size %d\n",
+				    igb_rx_bufsz(ring), frame_size);
 			return -EINVAL;
+		}
 	}
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
@@ -2869,7 +2874,7 @@ static int igb_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return igb_xdp_setup(dev, xdp->prog);
+		return igb_xdp_setup(dev, xdp);
 	default:
 		return -EINVAL;
 	}
@@ -6499,7 +6504,9 @@ static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 			struct igb_ring *ring = adapter->rx_ring[i];
 
 			if (max_frame > igb_rx_bufsz(ring)) {
-				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP\n");
+				netdev_warn(adapter->netdev,
+					    "Requested MTU size is not supported with XDP. Max frame size is %d\n",
+					    max_frame);
 				return -EINVAL;
 			}
 		}
-- 
2.20.1

