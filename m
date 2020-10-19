Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC39E29235C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgJSIGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:06:05 -0400
Received: from mail-eopbgr40132.outbound.protection.outlook.com ([40.107.4.132]:60982
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728029AbgJSIGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 04:06:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMvUeXQ8uDO/IvosmPpqojJ9C3DdOdKV+VtMRXEM36M3W7Pxn28MtdvjJO9+zv0Yt7sAc8tus2naRrTm1R7vnuNMzD5t2/6hBcvVX4s+2vf0LUyeasL2NGmybEg5Fdi8v0APyRcu5vk6pYkR0cdff4NbRTIEaLZ3wH0M7zOMYHGpB9M49as5bp0C94VBLimM5q3nFSGrSaLnoU7Wgp9auxhy1aw8Fx2V7dl6NWeDK8TbH8IwnGaLGrsHXfdiA97eYil+ZKznpOhuz3IHx7c7lpMH1qkH682poqXI4VOCIliR/dxwFbyqSKBpC/y/icXXz0R9MgEaEwRBjH8nQsCfBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/zjsxodsPWfYciQ7+XzoB5+Pjcy5WwsLEjLEmYqfGQ=;
 b=m5JDTxHW+GiqudMrIj7rohCKTUITuLSgC4CPf/sJT+cwsBPhBvy5tsRrfOhzHhUpG7Kp66Z9BikMrjlsoq/5PGJPoyLr/JoR1nqJCVp2YIiHeTuNwMbuPNHushouckavdT8IZu5yyzVfnbKqWA+b7D9pt1nd/yvVxb9bb/47JLZnmSZPAxll5xYcsMBwwEuFHjosa0qZQfw9RYQ28esABHSj08dQamIrNxPkJi72Lfivw4T1nMfOBrmvk0Qhb17cAYqsFQBLVrvQvWzYN3uIBmWNWGB5lySk0ShjO2624OQj7Z61Obftszr/eE1iFOWhNunkBcRZ66jcOf5XWr3/0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/zjsxodsPWfYciQ7+XzoB5+Pjcy5WwsLEjLEmYqfGQ=;
 b=JhyQT9DBi/IbxJEv63Egf6I6BQqo+QtKaXcic/bTEDDz68SuwK1DSkbhhQ2p+EIjm2sIiZmA3ilA0bmUs8GwwaRhYudOpbrZeyLzE3Goe4Y1KNfUMFnV3g9rGYOC2bSMC9ddjzwRvPi7JqYQZmzrjtJAi/uGwWgf+i1yqNGCFig=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4258.eurprd05.prod.outlook.com (2603:10a6:208:64::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 19 Oct
 2020 08:05:59 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 08:05:59 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH net v3 2/6] igb: take vlan double header into account
Date:   Mon, 19 Oct 2020 10:05:49 +0200
Message-Id: <20201019080553.24353-3-sven.auhagen@voleatech.de>
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
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.41) by AM0PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:208:ab::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Mon, 19 Oct 2020 08:05:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4008e56-3bda-4da6-3688-08d87405d045
X-MS-TrafficTypeDiagnostic: AM0PR05MB4258:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4258E011188E720EFA1F61F8EF1E0@AM0PR05MB4258.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bias4ulpr9/u6ffP8vxlwRprwCCKI2Y9RTi8KZlQjGm0ktqrn5M7jMJZ9Xbkouds6TKut7KgE3VVbjXu54+8iY2lm5e/W0ofgDErIUVPWfXO+DOyct4f75BEet5rLlZPhqFtMpouSBinCpg4fGu+I5BQi4fFgRNn9pcBzxF9izwBwMdlRbSqh+URM5nT2cSfvSXUiOs0QU6crjkBWBhJThJPzo+u7mah7KY8EsvSzcsm8dS4HI5BrIT9QDY9A0Ej2KMme6AA6p2HcqcM7hO7l4PdwSdSDoiszw0lKmW7WMa/NmniL+ezL5+Uta6McZwKgHjlSUKDCTj0OacBNgz6AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39830400003)(366004)(396003)(136003)(956004)(2616005)(6512007)(478600001)(52116002)(316002)(86362001)(8936002)(6506007)(5660300002)(9686003)(1076003)(6666004)(2906002)(66476007)(26005)(4326008)(186003)(66556008)(7416002)(16526019)(66946007)(83380400001)(6486002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6esoqGMOis1s9obhSFhm7tFiaRUEMJmB1cF8bpPuy76zVdvPisMCqtMPWs9hFwgYDHd/ZOjte9jjmpjuWCiWTP7ui8DmcKJPb7c861ctLWHuulsWM4cXlME6e2zGKyqjBSBp6URgKHLGOkxy13WLrD2w1/cCov2YBhMfDqJg0D46+tPlIw9UsFCeqKcEMACtciDuxtlBjkw2pHeIwbiBNwMWG23GYmaPLNG+yMV9ymwxfYrlyjVJFzgql0OUAEfEMxNtTF5/DBA+G4qFYAiBT6Swekdnyb0kFNkaWYLa+yittmk+VIS8/1DkBhm5O/6GZFy6K+SPLjPBU8JwOI3KVScp10G3F00j2MC6H0ljevFnfGwI4STAtoRSkUgiQe57s7wvGDQFsZPeZCoWWeqezRrdCn69tcFilzLmgQeaHUkTxUJzg2F8nTaMbSC7YOxyh+sbxO9ddSdll5geJj8zZm0zBLMZCXdTEYYsf4up2dWE6nhed8HovlKTVs6fAfnUyrTqxaeJYiCA/HHqZCSQBr2z6XemZ4zVFE28aMCV/mdqp7UW31cQaEAIT2x3aDoDnOhFaNA3rGT5DGKlGUgfez9lMBdriZ52fRhymGnWcGaa0wy43gtgRy7svsO8XcIZY7Gc3v1zqWEh9/f6kdtMnA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e4008e56-3bda-4da6-3688-08d87405d045
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 08:05:59.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 37FhHkXjBa0MHaJmq4T2WA/WVgK2HiGo8DjJaKjnTugHeM8WK4ArYgD+Bf3v+0QiO9+tKO6nbESgqB5YqUTnF3qSbfH89h0YPhKSFaB8x6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4258
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Increase the packet header padding to include double VLAN tagging.
This patch uses a macro for this.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
 drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 0286d2fceee4..aaa954aae574 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -138,6 +138,8 @@ struct vf_mac_filter {
 /* this is the size past which hardware will drop packets when setting LPE=0 */
 #define MAXIMUM_ETHERNET_VLAN_SIZE 1522
 
+#define IGB_ETH_PKT_HDR_PAD	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Supported Rx Buffer Sizes */
 #define IGB_RXBUFFER_256	256
 #define IGB_RXBUFFER_1536	1536
@@ -247,6 +249,9 @@ enum igb_tx_flags {
 #define IGB_SFF_ADDRESSING_MODE		0x4
 #define IGB_SFF_8472_UNSUP		0x00
 
+/* TX resources are shared between XDP and netstack
+ * and we need to tag the buffer type to distinguish them
+ */
 enum igb_tx_buf_type {
 	IGB_TYPE_SKB = 0,
 	IGB_TYPE_XDP,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 08cc6f59aa2e..0a9198037b98 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2826,7 +2826,7 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 {
-	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
 	struct igb_adapter *adapter = netdev_priv(dev);
 	bool running = netif_running(dev);
 	struct bpf_prog *old_prog;
@@ -3950,8 +3950,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
 	/* set default work limits */
 	adapter->tx_work_limit = IGB_DEFAULT_TX_WORK;
 
-	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
-				  VLAN_HLEN;
+	adapter->max_frame_size = netdev->mtu + IGB_ETH_PKT_HDR_PAD;
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	spin_lock_init(&adapter->nfc_lock);
@@ -6491,7 +6490,7 @@ static void igb_get_stats64(struct net_device *netdev,
 static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
-	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	int max_frame = new_mtu + IGB_ETH_PKT_HDR_PAD;
 
 	if (adapter->xdp_prog) {
 		int i;
-- 
2.20.1

