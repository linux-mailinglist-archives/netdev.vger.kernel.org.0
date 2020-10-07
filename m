Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2B128620D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgJGPZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:25 -0400
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:47836
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbgJGPZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7/BTBjT96P4Hg+3oJ+NGy6NsngU5o6V5YbFxx12tPXaKfWdQzO4jmOgO5ZiWRt4zhZmZqD9ehg1SmOXxmgrhaFIjWm3XLc/7lXov8KKPkM2m3jn7lw6ISPnAeAHcEKDdjPotTd/JT4Kkrh+ovxigtavhVZh0voKR3bv2YWZQ7hCtucBqa+E/+fzSX6LZ+MZgG1tW+giVRDRBSVCSyKGZMlYaKwZjfyacZMHOY4HPAi3bfpd8kam7AIAjylhNRQWW/j/IhaePHHjj+UfzQyL39xRqosrqTciBel2vo04J7uQ5/2+WDI8gkNKr32XR6uqAyTc854ITWe8y7tMkN8ssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBlTQr7fkC6/LIX+h2bx0YjWYamnecKnXvrPEQVYUA0=;
 b=dTBMxd7m+TKMqUnv3Gd1wOJIMKlvNeGUUEIWhemCeN/J29nak2HreramuUgQLDnKTxFcaowgsHmj6Jg8UsR2gColqvBU7xo5khzgyTpDbLGtRHPRfEoSj7T2oaO3gxADTc5S/foWB5fzug7I4Q5/B8oTwCYRSUuTi6AdBVCKuP2qNG22lGh+vtL4BSqBE10HH0v+XpMwuDLLKzDvYDgk5LdKMXbNPcRUFMmaQ1Nu5TmFL0U2KXmcpEMJzEo2BcFzS/FoxVxdhGog/4ft8MSx44JJ7TMPaCghS9PIy2MFgjJ0WaeqJh+nS+JjIAhv/NTRPc0jr2pT2zERDrE8gTVRNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBlTQr7fkC6/LIX+h2bx0YjWYamnecKnXvrPEQVYUA0=;
 b=FPpFrQcul+OSTnGbB1sXtXg+mMG8XH1MpYFeK291OqHi1FwBJ5K6nEr2jAwrM+6TYccZVlnK2ugYIefbAKy7eRhdR7skR3844AUuJBvI8tHnAMtMfAh7BU5HCr0cm8CHnV6lw/mNM0dDdB+rFyUhJ+i/UsCHB2uaTOHX1tWy5tk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:17 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:17 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 3/7] igb: XDP extack message on error
Date:   Wed,  7 Oct 2020 17:25:02 +0200
Message-Id: <20201007152506.66217-4-sven.auhagen@voleatech.de>
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
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76542f3c-fd6a-4f88-ecbb-08d86ad531e7
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB6082979DA1EB60AF8459C700EF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYcZ5CQZeGJaRsWAxWJXH2TH0nixCogs2LTD2U0tCazLaRZ3ZBTgR3G44Tsdhhci3MttTVhabpY0kxomHzeWCZPkmkcKiDnPDo1CIQGTUG1EpnqtZahZ6UAMSjw3TA3vAyBSxQ+YGcfJC2H84ssm8bFOxxIfLycDhT3s/13tv+IuGVa2VCZnYXLdbkhcpUkDsiEqC3Hm2AfLLhzjm7S+L9LiVpX6NBgbQPiELOByDoL8ecWfjOGUFhuTHo3tjmp5PtRzWFD8oqysxmbaLZ0q0uzJRdxt4Xi4V8KSfVxA4/u1r7PgOjCQ6metHQE/2r/MLjrJ+e9uL3hAR10MG0xF6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(15650500001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Lxp1OAp3GlPuFolzdPG9mli1JcX0ZZhNpgttBfw+YHQ8cdsp+sE7g9N6wEtST+JIJpi1kXXwgOKf43hqB8rGKv9L9mkVRlFD16aW17ueNTQFiOXpBCDc9oNOdP177AzVQI4AVrvKnh176E53IdTwehpwoLOdgkuqR6cNuzWFHzSBuXZ3zHCiD0KbEOXa6jSR4voYZ2fGqTWKkrc3kwFyIPZBMZ2NvJTJw23GCKNdfIo2LcoR0M5hrWWNUT686In73Rbdkh8abqE05cHlJBqrSiYz9eNwUBQEypPxGA1PoM+3lk5Y2Ql2Lebhrm4Q09Rt5gs00YPsLYr9k+M/0jRs8OHUxF+BphE1Vh9/u9/AIEaO+AMj3WgoNB63BY+vCJ5mn+z4jPMJNlb7kZBC6SwmluQw9wAKQL7hxwWEI83kfJySVICMRajTMGLIfig1WAxHc3ghoawG7x4Jz4IVxTjypjVT8RA5ttwcGnBTHgkwtSnEQ+ka7zcHOp+GFcR3d6yepCJpOFhaUR4EcxtTiODZ/mau23nLqKrd30r6J3AqljFFMQ0Owxv45kJyZVu5ovg9Pw7WHXZgbQ9VQDDdskEyWuKgBDAoWlocTzv7+DufX4kKvqIw4mZtTTkGSnQfCxxZdaaOUiV3BwmQYuEtuH4guw==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 76542f3c-fd6a-4f88-ecbb-08d86ad531e7
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:17.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fn0VSLntTzGbLNSId0o1vf/2xu2epnfRhw+zUFOVN/4whiXsRLg4hkoVTL34v4N90n9x1C61DGZ5U+Df8MoLGps8qfMHyPdIr7yE4SY2fqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Add an extack error message when the RX buffer size is too small
for the frame size.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
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

