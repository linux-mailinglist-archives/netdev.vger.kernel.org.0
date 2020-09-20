Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24C82711B2
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgITBsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:10 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726781AbgITBsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ek5z/Fzi49j8M172FporMHpKFGCq6mtycTSz8HnjVm/i+/CwA89H3c7tG97oA8J4S90XLZ1JcD8aeHC6uaojYZkH+R1jLX0B7/QQvInSCBQIv7k0ogBxDkMhaEGcRix4EZN5iyMHlZ0VW4StTJRhMiumUdmopggykFwiUgCOWt3Duv6SO+EddQNs+QtEMeAGHveThn5i47plvvkAJbe1rYGs4JVvRmZ7h/f4dooiufe5uOPDMHRxlPVGMRyciAPug1Txzgw6taOFLP9Oj8sAdaAWjCJ3AJrf78bf4VFGB4w13w3s2+1qEUQBSmkSscFuFQlThpSKZxB+r/wgAZUFWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb3jajK0rRUqlQVviPdYU4Y5FZCAHRYs6PYJZpafajA=;
 b=BJ99DtA0bI3bjy8jdZSIslz44shu811tl+T1R3oGHzdvSM45SBs3fXNUI3OXUDprK3dc486jl664LX6O60ojw5SLUIx53Dxtt90sEf6hSix9kURRY7oiYDiF+FcNbyV0fyjK/YUzgETOn9JvR1dSCEByH7Atcno3Ee+E0yo9zbpcgQho/R74zDUgp1wRmDKaOgwpTFJRmkw5EC4owLjdJWEIEHqpRXIh2UeLa8V7P0C/ZZvv8rgrKwefLLuSs3FbK1bHl6UMABCfS/gF0py4058324EYL68imEhIWbHOGZ9JeBRN5bbg2eWIszW/Xw6YL4dtdVLRu6dNKgyaglj+Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb3jajK0rRUqlQVviPdYU4Y5FZCAHRYs6PYJZpafajA=;
 b=Fdw08a2xzMIZJa/MOwPuFOEmNiyRJSDJ7fNXdEDfpFdP/bMaXS+lgaw6e4hFn+WjrjPGJZahIo04Lh4OMQJkITgdzxDowFtNLyO/v4dmNztkt4UxztiqwcfWC3T72OBkTtfo9pMkYuGvD6+NbEB7nf2q1UpdnCMeUomeGBgSQR4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:05 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 1/9] net: dsa: deny enslaving 802.1Q upper to VLAN-aware bridge from PRECHANGEUPPER
Date:   Sun, 20 Sep 2020 04:47:19 +0300
Message-Id: <20200920014727.2754928-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:03 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f5cb90d6-2eb9-48ea-65bc-08d85d073744
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686CBCF1899E9224C0FD132E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BaKZxoR9hCNp+VLqNHuMkbq6pyWC8n4zrpSvByKB3lckHgzPKr4IB58hpI2fCm1wyP1Ts1gdwgMBWyAjTCaQjemb/qhzqqJx7FFUl+LERWaKX3uQVHbq01HFsVmPkYWKJqW2TLmE4qyB+J2HEnDgBoTehebvM51YFXXxe21SKQVf2CnzZHSuU/THt8lzZ6vE0Sv9jgvFasHbBmxjCdqDyy2lDW3N47634Q1kZSkpj7oF/sYu7qsm47Jr85IgXnasW/aRfaN9I1PY6HREoriy1bV4kwJAfsSY0gbocFqOyAIDP1a4d/cPm1qN9S/hj9vFj6LWUvHpTe/IuM+7oEDfgDLWU4vpFWosnfcLwUjDjy2t5tPNMhYqt0DZ0i4oHfGH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JmGoNdTX7ksrUf5lYno0VADSW64KD9MtKWRRGwQC6SvJP9cqw08p4D2MXJoLGCh4J+hC7HTorKP9z+mqbfziApkz4DXuXj9v3bn2xSCB6n2LymhF0k7cEwKkjCb/vKGuKXbz8Brvo+9f968Htfqwkx81ZiP1sHHb1gNYIawaeQ9VgjNbmCJEQ6JoeJH6HFhvJbHg/kv2VRX8CZDLBm+hq7XWvwPX2vhRyYI4Iebv7Wz1ooy8VfDbVYz3Ctr70tOUBfboS0bb9WSqS+EIXSBbjucE1x1iWoe0d93vtxMZzX4gcRo8jYfMBC8MLlezIjLdhb4Ybad9pfZIZ3hmoKqkHVD/LaFYnmplh//UV8MVYR9buBHH/F8znC5pSj3pYinF77ACSYab8NyQEGwQH6uEUwHHwApD+BM1DzMlxGToOdeKoAq6Wqe0xYjmHE/7WVYZYkW1T4xdtg6cgHzdEsIN02Mr3z6DMNcoQblCIrG/SVmnDKL3VuimvtQocktuVoE8DB/joExEc7TotuZSiDhhNM5kdYXr2jfKU+GBm1pRskbZvluTG/PxqsIjM8LqFuUEtqCfG6qHvF1Mr+PNlljFfGfNVLfwKZoUKAztpdRzagfI97QaX6IB/YVwaQWyiqY1MmwW2242Wt3qEhCmggvWAA==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cb90d6-2eb9-48ea-65bc-08d85d073744
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:04.8677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHb3RNA+UW5RmBHAHn8Wak83H4BiG370A6/cGgiNMIwohdMgpMwu9t9T4G41HP74cUlMrst5QMCr3WQhWwjLvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There doesn't seem to be any strong technical reason for doing it this
way, but we'll be adding more checks for invalid upper device
configurations, and it will be easier to have them all grouped under
PRECHANGEUPPER.

Tested that it still works:
ip link set br0 type bridge vlan_filtering 1
ip link add link swp2 name swp2.100 type vlan id 100
ip link set swp2.100 master br0
[   20.321312] br0: port 5(swp2.100) entered blocking state
[   20.326711] br0: port 5(swp2.100) entered disabled state
Error: dsa_core: Cannot enslave VLAN device into VLAN aware bridge.
[   20.346549] br0: port 5(swp2.100) entered blocking state
[   20.351957] br0: port 5(swp2.100) entered disabled state

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d6616c6f643d..a00275cda05f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1946,9 +1946,14 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (event == NETDEV_CHANGEUPPER) {
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
 		if (!dsa_slave_dev_check(dev))
 			return dsa_slave_upper_vlan_check(dev, ptr);
+		break;
+	case NETDEV_CHANGEUPPER:
+		if (!dsa_slave_dev_check(dev))
+			return NOTIFY_DONE;
 
 		return dsa_slave_changeupper(dev, ptr);
 	}
-- 
2.25.1

