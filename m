Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C52E2718BC
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgIUAK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:10:57 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:51024
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgIUAK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:10:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nf5hxFw/jREwbiU5Qo43kLWogwQPJocaDvXz0KTzVTvvqqmPevbm6k2Evz3DsrloBsxEZMhVwgt9WRhThOB3ZP3IAozRxJbVQL99s1OOPXKSS0kraCuDadpE3BfI5bocAWS6ASWvIvR1VP2WJ1Q6N5rGEaONTBdPVNR4Srov/MwAhHu9Rfwt3vCoqF/VSvLwwUfg8XvobSlYXVIJtNMaa5y9mzS1mb4yZnXKQXEmTL0sXXlvErke2gs9jx/I3v5+YfWFksEIWu1vTyA0Kmw0akifoExOIsj6p33GE71veTMTcq7I/XQfyoEwT9DYiNZR4jtrNrbGpH9oHVKdhbwesA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3fEGUNBUx1Qz2pORbYp8upoyrK8jhfI8dluqkvYID4=;
 b=OTucHFGuQAFAQyWCXsycqTfljTBewZdOFnzJPaRLdWvWQ9cmzEYI+YZ2WBh3LbTyXG0kJLBZzBNoxse8nSa8vF6RCplRvoCZm0WYOGpcXtPxaAt3lre7R2edJ6zbrOyoieZP8FcBpHaqdqjyeRU4HfhaJfwKz48ztb23PV661rcBXUg4UPj2Tg5ixXmXsq9pdwSSFvjB1nafYej+d2uqzqA8KdtcYTgLkLoPAc/ZkcO7HMxek6cUqkkTnuK8sbHr/NN8TqDYQB3PJMbvtm+rZ2eqeE/diGia18AP0SuPlmJlx3Ze20/xRbC+8BVewou09T62xHz7z/5hPGJBh/EVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3fEGUNBUx1Qz2pORbYp8upoyrK8jhfI8dluqkvYID4=;
 b=ZmJkVnStLDkxDMVp/MH5fZ56vbELsIRpww1bzdahquicZZGQ2bdkanvlaHoD2osxNSutvAfp8woHIsqqMqlDnz+bGC4etC5INTgG7ZwaOJyIGlCif4cuFPcKbr+ECeRGY8e45RzoYKgGgecQ4YzZ5G2l09QEg85DynnHR1lfbjs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:49 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 1/9] net: dsa: deny enslaving 802.1Q upper to VLAN-aware bridge from PRECHANGEUPPER
Date:   Mon, 21 Sep 2020 03:10:23 +0300
Message-Id: <20200921001031.3650456-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:48 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a3e46744-cb28-444b-0c3b-08d85dc2cb03
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB55014606D6DCA17F30A08697E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJDCg2VQESbzMzfjPg0U8bidQsgOv49UkancIoSKUx4MDSWY9zjhbk/ppM8kUCefQU0lqw9T7ycWWwELujyUu+ew3zWgODlpt/fQAMVkI9H39wjPBBFphkOFrUKZYd50u9/AogNpj9CnT+6FGG8FUqikK1OhtPw3bexOGJkZpNefCEgHLupMiJDuUMXsflfngucWzMLJrriBK1+6PWlYXUesDF7nDhbu+GzJCw0VMCDYyUTnPl31PqJlQaalqeIXjFSUY+hukRIKZ64PRe/dacgqGXU41ghQU3cEx/bEcb1nDJahefO4ftzJkrLPdaBHKA8oDAz7RVvtXTy8kzqYBWJfei+Tn9jnKnumJSw7pMhaku3Fsgth8WUZlDPusNYP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8PrjchbnEg4+LszGCpAFOzSA6v+TXRSpWGCsFsgKvxz2Zf7w6MC8zDj/hlSYx/hJ2Xn4E75pQ6ef3HcnhHBYOjJYQNp7SXgm4MTTk9A6rEz413k45NdBq0yOiXSZnHInbCyUhqnncNjkXr17oqxg2JT0o00vYb+rZng7yrfIFBTRNFW7RIXWLKT6xaYsG2BNppXXOLPGBmdSVrzxuOvDjpSj6hAxYAlAzyjn3n7YjWYxH0DZ7YkVKGu9MaHX2ljOwPy2wkIma8YrF16soKKlb8K51zTx7OThxSIFlwjGdizUW6zP8lod8sz4mvcGOx1RQ7f3YXW5q+UYyqFqEHsGobiVElXg4+kaRMR/WJawxBxFCZCVYMsY59/iS9OPZrfuNe5Kw0rpToclXuqvosNLPdAPilZ7gycsuyUIEvO751djxGzASKdMo8U5c2vJ/Qt+5PbhbP++BTl4KuCR2KBWCUu8hn4w1beHlnotR+EAHdPbG8W1jyxzLQ12VRRL0ynTjKalnloxxfPUbJs07oI8RvbxkQwEfYJ30BUAeVVuJqcTl9v/fav8PvwhgTdcf8SIzFYxR4Q7JzX2iEGI4GNiV6SyIzgVd2oSpTSudkn7/UBOPJMhSiYXX7Css7RDcW8WfgUQzfa/jjK0C4fSBB/dng==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e46744-cb28-444b-0c3b-08d85dc2cb03
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:48.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB3OThzugJMbB4Jo2c0JxrtYkLUmnzMPCUL4ETxCbiSLsl/hhB/jGji5wY9UiqkSztnJYVl+BTseqfvoSl3QIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

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

