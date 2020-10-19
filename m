Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4776D29235D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgJSIGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:06:07 -0400
Received: from mail-am6eur05on2126.outbound.protection.outlook.com ([40.107.22.126]:47094
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728275AbgJSIGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 04:06:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTYV/6DakuoKdn+9oljS9SAzt3SQdmxCMpK/axzPFOY/jUhkKe1mkb8Hwpvv2rxVb47icICLTkybu85sA8RuJnBQAjfuTest50l6XVIjiTiOJxNn87V2cHE5O829bXn99SZ6mkYStL0XhfSKxO6a2UmBr6k9/k5VBbWH2nWNLjADO9zG2ABJtDk3MxsfKTVWyyTPPlv0gxUcWSG5/DOp8vek/E7esTuxo7DJyjXjNLZ44PX7MwIQ2Vu7G/TQEs2TJlJvbwwcYzjkcVQDbH1Wgx8CXpyEEvFhRDTT0r3Ov5Dw62IK882HDyxBo2R3ccza+qV4gqFYZxSAtSWbwRW1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6y4wzDIDQQof8OkQozqxXc4WIuTkpLbgW8xqDDZT+RE=;
 b=SoqIYO/Dv4zCAzefK4UsSxIEb9EK1hnj3woHD57ZeYf3RUPPKWnHcFBt0vhhHb6zl3yPA9p06xm6jE2+E/IAVCvkgUCkovEWBFHQyo6i6jn6eyp7KAe4aCbz6BGa1jkpPy/6SEv+dgw4q5qb5OhYUQobrXD28EgwsRv5OOEGyJRyf2TQEZm0mkXa1W/U4JNigBuLaCYwI96VJRg8t6Cz4+Kv2PWUhe/E1twoWzs2dwvSyyiBO1j3Dr9dgMf/+WUHFyf+V1yPiC3kUGejMMxL8HpYwjY+Ge7mR7IUk3fvPSCsaQfuXQbu2tx3ZCdYuWIW9XinWNJNHWytGg3hiaQv/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6y4wzDIDQQof8OkQozqxXc4WIuTkpLbgW8xqDDZT+RE=;
 b=FPQASAYMHuydtASlT3lVNYiwRrs1lTrvvJsKtM+mbKGPfH6RjQJCq4kXPoturl09Kr1ByihBpW42TSGZ3MeR8OB5crZvipCJD619E6IB4e/PfbNDuQI8vSP87UmCZdyW0fxAkiBEhLwnaFx7Q9i6G0zk3uLOQc2p1z//SvU4HNQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4403.eurprd05.prod.outlook.com (2603:10a6:208:65::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 08:06:00 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 08:06:00 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH net v3 3/6] igb: XDP extack message on error
Date:   Mon, 19 Oct 2020 10:05:50 +0200
Message-Id: <20201019080553.24353-4-sven.auhagen@voleatech.de>
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
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.41) by AM0PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:208:ab::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Mon, 19 Oct 2020 08:05:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43317ad7-9592-48ef-d332-08d87405d0be
X-MS-TrafficTypeDiagnostic: AM0PR05MB4403:
X-Microsoft-Antispam-PRVS: <AM0PR05MB440365A7B395DAFE59DD2E7EEF1E0@AM0PR05MB4403.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QxvYcE2BgXhXoFwR8rMFvbqmYhTpqaN66QX6NC8adwSsT+Vbu/8kiGLczdIMaJ+omsDOfr+hzK8PFf+hSAgJTdCdNvVPAL1RbMGKPrZE+3X4V698BzjoCGIMxV4IHx/sJXcSkOkYZMrTz0MGM0c/snSYIBc7mH9JlxmAqj60db2HhbiTBrN5azlDHTKV9jT6hJ3awIahlmlAQN1DG2QLHwc4GoDISLacU8dpzWMaESE81LzvWlvsvrGkx4rcZ7VsqKXaKUDGxHZIc4KWBwdlVISzEDgUmVURqWbtbn1sPZPmwTdiL9cP3e0nIyiWDuLmEqgmawNGc88010wKNpheBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39830400003)(366004)(396003)(346002)(36756003)(4326008)(186003)(86362001)(66476007)(66556008)(16526019)(8936002)(66946007)(2906002)(83380400001)(6512007)(8676002)(9686003)(2616005)(956004)(316002)(15650500001)(52116002)(5660300002)(6486002)(26005)(6506007)(478600001)(7416002)(1076003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: l9bIIXjqAO9cE0axkW2tBzfwslX0Ui8/YYNp2EBcF4Ll4gOUInrjZcsLU5PvxAdZsfBpBcacoUR/aap7UZvTwPy3En9Kq+Z7R5XeU+O7tXfWnNb2+5OtFdp0UBaP6Ul9ZFyE8vTR4W22qompO8ezNBogtv2ZDsOIDxm8494EYf/bTlcTmlylCC0E8XBsntAcmdfQyNt6GeN8ndnyCin2JV8q+LTDsC4bMPb/tabhsNPGsMXb88qOngvdN4U9Z+Mh1BcmsSV4YULkyCRlSlYek/llnSWdlrrNQA90A5b/ZWzxDJ6DC1iCRdoI9deuXGtvSM9SU6hOVFmQA+k61Ordsf1Z6S+Yd8DNoQdCyO6Pq+vXdKqajU+QSi8OwrIGB6faDKd37B1Bxq9sp+WApap+PQAyl1mzCAI+bdjBLNszxXrnRcRNZWghfpW68fMPeELM+QSpu5BsmF7cMqXGHDG93wFfldBEx4T+zYNhJqWfjx5L3DvWIbImQXk27yj+6CL7hLPrb5cFHc3N4ApLvQRGlxPf8b8NS6cvR6FzSzHDT4oJUKDx5iYb+armPGaygCDdfr4u4Mth+kvr0waZ2lldiSQ2BeHiWJ5Qde3JBs8g5cqKNw+GFm31CM2JqhZeaDCGsNlagRy6eQ6ZlcPzv3bU1g==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 43317ad7-9592-48ef-d332-08d87405d0be
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 08:06:00.2165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9qC0sUMXuR2l3ys2HRK74EB7PnELjGKRPQw81ZSmtr8YJEByXZ8PWhIWrFG17i3ed6tfUmz6Sn3fDVg1yaFp3tCRt2ezWRodbbtsCnnL9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Add an extack error message when the RX buffer size is too small
for the frame size.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

