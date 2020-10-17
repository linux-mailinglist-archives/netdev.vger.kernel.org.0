Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD9D291064
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411526AbgJQHMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:12:51 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409917AbgJQHMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9Tg8ZPyID7K9RgCmadWkTOGf92+hhci33NqndJH8+OQXXwKj++ez5QloYuJDSpYQwehB4YFLhQXnQYQ9NHxxHmbooWD+QODJHAxhHrD29ktc/AWCGTUrwkxdeuAxgEeAy6oQ7htHbsF/VSqlQoYQjvkf+iLi7I6xwDmPaozl/Q+0Kdn/3GVN9pZo6rIfpEin/bFHx+wFbUQeJcdWp6M2SlFzz0ifNikZ9jovu7Ceu8t3vbS9Mblyn4lFV1ntKVrlugkhwCkwOdTZPPpL2CVHZTODOYcHOXrvhJ8STv+cdLwyhofOFqxt3lynQTn9hn4acAIL9l3ECLJeT+MO/sKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX7NWAGOiIstq/9Ap+RWNIIwuO9+RNz9GVRejfoc5OA=;
 b=A500nRgNqifrAK10liRDeTmz3Vw54QWl3PBtWVO/fFs1bfP7w9Uj0839xavp6D26jPzg2sY2nVrP+X9HqbrtVnUmiEs1Hrj/T7FGn/Z4+k/mgPHQ483HlX3eOjWbTmNfhBhmnm3wvRNxnKo+aqQOEufaj0wB5TZpz4aw2JAQcIC44RhoQnX+CJ1NUFnGINmzpJpLbVfKHi7SezKMBxGt3xLxpvE6YdoEFKD2QIWYwB/ddgnPaBilS2ZzLr5RcE80Txi2OhiGEBF12dVCZVX6SfbjRjIoG+Q69GHH/0m78pWoHEVaV58+DM+VLq3/w3KQMY2SStprI4GgYvbBg/P6eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX7NWAGOiIstq/9Ap+RWNIIwuO9+RNz9GVRejfoc5OA=;
 b=ODdxhSDr1+jOcUVXNfON7ZvJwcmqvAURQHKrFt9IMOkCYev+9ap8q2L34Uvfz1TBq0LwIb0ug+1j4DRVEBwrwFyKPCxqh42Q6cfFIXaIxXojPPvxL64OipS3DYrJ2AZQd+4OJKWB/YdklBxTUOULFHt8ZGdt4+Ir3s3tUSt74H4=
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
Subject: [PATCH v2 2/6] igb: take vlan double header into account
Date:   Sat, 17 Oct 2020 09:12:34 +0200
Message-Id: <20201017071238.95190-3-sven.auhagen@voleatech.de>
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
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e301915-a3c4-4570-a407-08d8726c0a56
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB401805E9E7F4A8E3BE545E46EF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQjhwb3JDspyFSpR5ubKdBfR+Q+xK5Mw5LqKObnPBj5MHxYXWR+2ICqajws207GKLa4aOLHqnD/nBOV3BXe//Ikevb/uHapIRkJ7qtXS2xo7ke0xB270tRv0H6jNOYeoEmnDEmvpy3eRTiOCDkFDCmH5mPQi2KmDG6kGDDbsg2FcVP3l31mE48/TdfuQXraNjQ1x766z0sl+Uc9AHvai2LL8Loj+BiYSti0bY4xbUz/0TEdsdC0DaFTwXTgSCGevfaqDZrbawxUYY2tDtBycqSg75kDdD5ybiYX2/rKKefnb4X2pzWGOrrQ4nWClP4N1kukAQMvN2h+9ZE0SzFi5sNR2lakDVk7QhNC+ywA1afIn0r5IQaff0gAfpawIHpHX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(6666004)(83380400001)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7tDClaSC3AqHWqdV5PIPAym8cutDCUhqEyajz8usYhenr64RSUzoqsnqpSXVgfzgQYOkOdyl/TCTXnxIui9E+hQ+ZJU7pvIGsjs1iV4CE2d9scLSDSOyc+SFKOTee2/x2o1hEfm5YBodbgXQ819fv+JHQtQHYwpZXGbSP5uqvZDr4j9H2xU6vVDB7hkIWfk91XAgMi8mTH9EZyBG6fCXVa8/UrECqY12URJqX6kBOBUrotGyocVaHkiRLuEQ17kBQXVWOQJV0g5zSteW/a8NaBvRJg+1ouyWsrANzTTkLVFc82WCprZMcbWQ3KlyqdnHBHqXKDLyhAMxBzDODN1BNzNkrrlk5mg01tOVWZIgHWZxoYneauoBlR7B69gwkqt7hAC+be58OzOzOhnRncsiDFG1QOWOdI5OAInaGf5lqAjLQU1czNoBfTV3c4EgL0wWB6sU5/6/OAaNUi9FkLsC8mhIeSLshsXnWPxTVzpMvHf2oc4+djJeUAO2/JAIKuk0NXeZU/hAijDq/jwUo56uUcEcH2KrQ2Lc6AmUDmdScuyT0Cu9u/x1DsrYVVdXInqa4nhHzOWJmcd37rodr1oKYD7HuCU6N5DVVlKHHqICQ9LhvzLGCuWi5qdTkJvfX8JGOi1Xa+YNM9lyV7xXbAMf3w==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e301915-a3c4-4570-a407-08d8726c0a56
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:43.0241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo/IV6Ed/VegAxG45L9D4QjV8QDc9Ve0HwUGAjZyu0qbiBYHEG/lGeN2lHQIZ7McSPN65Atp7kbw/IXEoPXa+l0ANtHN3M51p2G2+DQZbo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Increase the packet header padding to include double VLAN tagging.
This patch uses a macro for this.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

