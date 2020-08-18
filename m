Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176792480F1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHRIwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:52:25 -0400
Received: from mail-eopbgr60128.outbound.protection.outlook.com ([40.107.6.128]:57198
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbgHRIwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 04:52:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhUQ0kRytVS2ljh/DXohnCz5OsWKZAW4RuXOo9npQTrFgRSEk1Y6M8z+uG5XUVaFgTcNN/yA4EZgHNSwWVcMSX1fiYzxTtwzuNodS4jZ8wDr6+MHIm1nsKg+f5m0bh5KWqke7r6gJcyBNQ/LLuRNIoP1cdy9OqMJlXMWYTFiPNm8+xqZZty3voKdFjWDnafO9SEoGNMc9OAXUseziW9k+o8UbSy90BOspa5Q1UkCckbrRIQlaMYBhCOWipgdrech/F+lepXvndk1ieTbS+KSWb4nZFJ88jM7f3sZL6q2tmCCqpCW/JXws4kP6gYdBohy8u9cgO9KdBER5ZOriRB6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWM2cH60e5dTFQpm3avc/X5OkdzzKA8PA8QDpT5oY0Q=;
 b=Yc+NSk/OHwHVdA7e75R0T+A74XtYohtTcrcEfGnoqY6/r/fhEM1xqGXnuZDHUxIcvuDa4d6WPNy8Px8cbpPet79w+Zc58vAmpCpZ5XTdf57PJIA26aI5XQW8DxOeViK42FVKPhnXswMor7luazGALdlgvupYcQRjN0YVr5YVdHCH+xZ3HCMbBgS+ZopdmsmV/OnnCLtDBRfScmNxxMz2CrBt12WoJTkeYjCG5MyhVGEPzpjkMDBJduKYVva0mPOh0wWotHG/PpDiziQssIovkhyN0WjIqsR7mJgvaMXA6/vg1ZSLA1VDZmAgna1PO6d1iSSyx3P17a1WCSPWYmoAWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWM2cH60e5dTFQpm3avc/X5OkdzzKA8PA8QDpT5oY0Q=;
 b=elWna59UYzOW6TzLRGlzdb0JRq8TqgO2pWewN2EQ55vAojKvlDB3P2pjBloOmgTuTYe8Jov5ff4xJcGRQlOdBvezEfpd/yBSlCB1sVDLmxvD9r9em7GYI6HyPGS2OayHbvaxaC/PK7/Aq4D6ZZdOZtXQg0fnMmknQ65cPbGQYU4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=bang-olufsen.dk;
Received: from VI1PR03MB3166.eurprd03.prod.outlook.com (2603:10a6:802:32::30)
 by VI1PR03MB4911.eurprd03.prod.outlook.com (2603:10a6:803:bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Tue, 18 Aug
 2020 08:52:20 +0000
Received: from VI1PR03MB3166.eurprd03.prod.outlook.com
 ([fe80::4b3:262a:b605:14ba]) by VI1PR03MB3166.eurprd03.prod.outlook.com
 ([fe80::4b3:262a:b605:14ba%5]) with mapi id 15.20.3283.027; Tue, 18 Aug 2020
 08:52:20 +0000
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next] macvlan: validate setting of multiple remote source MAC addresses
Date:   Tue, 18 Aug 2020 10:51:34 +0200
Message-Id: <20200818085134.3228896-1-alsi@bang-olufsen.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817.145542.1273892481485714633.davem@davemloft.net>
References: <20200817.145542.1273892481485714633.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::35) To VI1PR03MB3166.eurprd03.prod.outlook.com
 (2603:10a6:802:32::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from capella.localdomain (193.89.194.27) by AM6PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Tue, 18 Aug 2020 08:52:20 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [193.89.194.27]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7ad3e3-9efb-4ca9-30a1-08d843540489
X-MS-TrafficTypeDiagnostic: VI1PR03MB4911:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR03MB491198A3B0E5D860619D0958835C0@VI1PR03MB4911.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JilklCXf+hLl34CmD6i0yBd84AxsUSMt5LKNgO1v+io3A3Q8xJPlCsfuMVFJgI4NTBQ2BFDN3W1iY24XpAdnq9fjEQqHPpwELK3zyxFidbSbK2YLr1ijxkUs6aT5mRI8clZQJGfLKkzuDMB4xjwmubwsGtyH+MzWxaNyawLO8321LbpMEyLr78T6P8zxrpR2NW0EE8dmaR+MHRcZTv2SKf9RqaPxHQIGgRugaGaP8E7XeX9JWuvUa5xeKNlwtL6P26piWwgAyZFK41dkpPOfRNvWdywahyJaYMr7b0HPTaggaeiNSBqlGTLIKsYZN2Ln
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3166.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(346002)(396003)(376002)(8976002)(8676002)(8936002)(6916009)(6506007)(186003)(2906002)(86362001)(52116002)(36756003)(6512007)(66574015)(6486002)(956004)(2616005)(508600001)(5660300002)(4326008)(83380400001)(316002)(16526019)(1076003)(26005)(66476007)(66556008)(66946007)(6666004)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BOCl7oeObupQKqLZGyG2uslWZdvMZir4jE4xlNXCH4Ni+mHSAkTQhYw/RxTyQ6VszbxqCi0JQ0S7ZN/ITtcmZIzEcWUNcoeQADzTMSaNbnwhn3sIkBSRGxna8DimIIhNZ3/0TY6PuUy0v/AxfP1PWBBKXv9+h4v9QilazDy8LnobI0zKeSvAhI6PCQCOB6Ln893ZWmwPfwaBMCkM0E0QRAyWKMKVP7SiOogWphw/jdv6xnwIlDtpBt5Fu8X+veYtYBd7d6Vpy60ZV57EGtdypNqufW3WTgWB2w8HZy+UI8lUfUYThm9jKxa6Rk7VWxjgjWZmyqzmTIF8CP0D0E2oe52s7Xo2P6W5KYqK4pTpZnkmCvPnbw0PAvZOWQn1+2ZLMXsz+CwbYqEJ8kc6tgB6dW3WzwMuwJH6U52x2FtN+OEB9ADfqT3x7XTPgEA9Zw5OrKizfbrG/ojkHmWWk0EDFuVTFgrleKNtRJJhew9kuPSjouTlnwpCrWAnpnby6G3olEncVjfoMrEnFfOtCn9rBIBf9uJ+LURjL/IGPle0LVioklD9xJ5itUTfF93rS78cbcZlLczGaEwEJ7zOC8LrnYlEKcRKHSlobAbylRyE2jd/rt6VeAGc3hKXTjuJLrmIacrFcoFAkesVt4++6JF5Vg==
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7ad3e3-9efb-4ca9-30a1-08d843540489
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3166.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 08:52:20.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YsQAINWHDBQjSjoGRS6kkaV2/+HDmDJoymGXCzyqFMMyJiZ5AvHFwfXtR7gc5AhvdEYuxllXzRWWd2ZEqnmBKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4911
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remote source MAC addresses can be set on a 'source mode' macvlan
interface via the IFLA_MACVLAN_MACADDR_DATA attribute. This commit
tightens the validation of these MAC addresses to match the validation
already performed when setting or adding a single MAC address via the
IFLA_MACVLAN_MACADDR attribute.

iproute2 uses IFLA_MACVLAN_MACADDR_DATA for its 'macvlan macaddr set'
command, and IFLA_MACVLAN_MACADDR for its 'macvlan macaddr add' command,
which demonstrates the inconsistent behaviour that this commit
addresses:

 # ip link add link eth0 name macvlan0 type macvlan mode source
 # ip link set link dev macvlan0 type macvlan macaddr add 01:00:00:00:00:00
 RTNETLINK answers: Cannot assign requested address
 # ip link set link dev macvlan0 type macvlan macaddr set 01:00:00:00:00:00
 # ip -d link show macvlan0
 5: macvlan0@eth0: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER_UP> mtu 1500 ...
     link/ether 2e:ac:fd:2d:69:f8 brd ff:ff:ff:ff:ff:ff promiscuity 0
     macvlan mode source remotes (1) 01:00:00:00:00:00 numtxqueues 1 ...

With this change, the 'set' command will (rightly) fail in the same way
as the 'add' command.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v1 -> v2: reverse christmas tree ordering of local variables

 drivers/net/macvlan.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4942f6112e51..5da04e997989 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1269,6 +1269,9 @@ static void macvlan_port_destroy(struct net_device *dev)
 static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			    struct netlink_ext_ack *extack)
 {
+	struct nlattr *nla, *head;
+	int rem, len;
+
 	if (tb[IFLA_ADDRESS]) {
 		if (nla_len(tb[IFLA_ADDRESS]) != ETH_ALEN)
 			return -EINVAL;
@@ -1316,6 +1319,20 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			return -EADDRNOTAVAIL;
 	}
 
+	if (data[IFLA_MACVLAN_MACADDR_DATA]) {
+		head = nla_data(data[IFLA_MACVLAN_MACADDR_DATA]);
+		len = nla_len(data[IFLA_MACVLAN_MACADDR_DATA]);
+
+		nla_for_each_attr(nla, head, len, rem) {
+			if (nla_type(nla) != IFLA_MACVLAN_MACADDR ||
+			    nla_len(nla) != ETH_ALEN)
+				return -EINVAL;
+
+			if (!is_valid_ether_addr(nla_data(nla)))
+				return -EADDRNOTAVAIL;
+		}
+	}
+
 	if (data[IFLA_MACVLAN_MACADDR_COUNT])
 		return -EINVAL;
 
@@ -1372,10 +1389,6 @@ static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,
 		len = nla_len(data[IFLA_MACVLAN_MACADDR_DATA]);
 
 		nla_for_each_attr(nla, head, len, rem) {
-			if (nla_type(nla) != IFLA_MACVLAN_MACADDR ||
-			    nla_len(nla) != ETH_ALEN)
-				continue;
-
 			addr = nla_data(nla);
 			ret = macvlan_hash_add_source(vlan, addr);
 			if (ret)
-- 
2.28.0

