Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5B02467E2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgHQN7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:59:42 -0400
Received: from mail-am6eur05on2132.outbound.protection.outlook.com ([40.107.22.132]:21281
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728636AbgHQN7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 09:59:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQpMydbGgMqE3AX1tra6QwJThl3rKB6i+6RT+BiH+UjdgLO6zgkFu7+T+7Wwu3URa7Yao2rWnE/JwgEYsSVvvAlntkpoDXhAcOheVJvmBCcsjgQyMtis+QK7p93XkmNGnTZ99Aj8D4Z5nI7Xa6HPHSHMyj+6bwOk0h0FK5Guq1gCZ5dD7Ez7mqHt+h4FuY+rR6/6NJW7mVq40lm9TUesGXzu0ZAXAqmanZOk5YQaq49cOND4rfT7sXm074z2eK+s90qrNq1pYY50IvcGMuw0pfkBGO1kogPkLDhbscJ1I195fhcLupGxJ4hO5JehU5y47UyFb21Xp0J0J9nXHMOZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HK569+HS4mABFQeM80Gjjeurw4PijEf0kpPvHccE94k=;
 b=mHt8nZ2zjXX5SFvPsAeeHqolw0FitHVp8ab751FV2OBWFCtv6VIOTcAL/+J1jd86K9dG3qCZ7x0FXBU+eN+8vzSPB45+p0LPRarkQVNq8eDVgaD2Wl2P2If2p1lzr7sJI0am9p9xLPy5vugvrPB8jMpZ0wFsOqRPYjL4+O6mm2UCcHhvqv52Rvvx1mbfMtoda0v2T0n2lZIVXK1nfWRK4o/u+B2PAps6XqhFEYPl3SpNFlCnul/9tA+3ixu4U1AXfR87RsglvdTWdCEdKu6+tDsjcnv2D2niGGV4R6TR7WDShiDVH00a1sH43uDkkP13eX9wnsOAB+QRUYfNp0TKNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HK569+HS4mABFQeM80Gjjeurw4PijEf0kpPvHccE94k=;
 b=RkKoerfou3qYovMfcYdRlrdVYv8qEe4GGgZ/He4seXXpmgxsllzy2mZ35O65FVovyi87hhD0Qi19zWwTRORzbnRKqeDz0FuaaycmiLTK2bvDp8eorv1JnNP5rRbcwMm14+OIpHrgMglOlY5jtkyPU+JOA3OBi0hVfZHi+XfPwns=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=bang-olufsen.dk;
Received: from VI1PR03MB3166.eurprd03.prod.outlook.com (2603:10a6:802:32::30)
 by VI1PR03MB3776.eurprd03.prod.outlook.com (2603:10a6:803:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Mon, 17 Aug
 2020 13:59:32 +0000
Received: from VI1PR03MB3166.eurprd03.prod.outlook.com
 ([fe80::4b3:262a:b605:14ba]) by VI1PR03MB3166.eurprd03.prod.outlook.com
 ([fe80::4b3:262a:b605:14ba%5]) with mapi id 15.20.3283.027; Mon, 17 Aug 2020
 13:59:32 +0000
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next] macvlan: validate setting of multiple remote source MAC addresses
Date:   Mon, 17 Aug 2020 15:58:59 +0200
Message-Id: <20200817135858.2661316-1-alsi@bang-olufsen.dk>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P192CA0057.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::34) To VI1PR03MB3166.eurprd03.prod.outlook.com
 (2603:10a6:802:32::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from capella.localdomain (193.89.194.27) by AM6P192CA0057.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Mon, 17 Aug 2020 13:59:32 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [193.89.194.27]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96bc817a-87ba-45f4-6bc4-08d842b5c458
X-MS-TrafficTypeDiagnostic: VI1PR03MB3776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR03MB37769E087F66694DABBAD855835F0@VI1PR03MB3776.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WikszWIa4tdyDvjhHPXlf3gH3600pgYDY0S8HoFFYMSinpHr8z5cjCOAvhK5dY9CEXlqhAfIFSfFvo6lA/pGa6j1UulUb9+EFvsnIOB/ShB85suWxrwcVmlAyD2bHZKtcO+z0JK/tFE1Cn4ISXlGPJSDHRDqbHnNq+8P04gudItAhPsG1axjva/+viZkkyc/frtvOwzWnCFJF7izmPWiNcuo6N6NAn5pl20QicoIKNTLjg9JNQtil/duHmdVDVHBhM9XaJMsDZD4pRNEDA6riryF0w+6KWGC6JzL7X81aKlztz8QuRZZ1L0cnIF5pAeN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3166.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39850400004)(396003)(66574015)(316002)(6506007)(52116002)(36756003)(83380400001)(5660300002)(26005)(107886003)(16526019)(86362001)(186003)(8976002)(6916009)(66556008)(66476007)(478600001)(66946007)(6512007)(8936002)(6666004)(956004)(2906002)(2616005)(4326008)(8676002)(6486002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +eeJSZsbGnU6PosZ/8+2LoTocz9HHL9k6b3nin7/OSXcM42f6/FZq3fkzcXhc8sghSXjjKkP4ZJAvYBaIZ6+mTPVKWANGF8b0ry9beQ5Eo2ewWtGJeLsP6rtAKcPYdy3lZJc1OIgS+qdhCcfZaraiuuJHZTUegfWtJ/ASDd8TwPulzR5WL3MXsXWDlp4sTTJUF0Zotqh9YlUzlQ/tWCtqm0BB1zSpQbu4RlNnLHcipgWxeT/2tDjPSLB4OGxF3R7k7jFKckD80VAQxgBA1rUFDNscX6Lh/2yOKs8hSMFwZvUKGvTMT6VdH7FXSU83iB5TxiKwWM6X67Sgq7BEv3paiPjUnX6eWRQNiYoIKXEWpFrwi6fW21QloPAN2vulbrSGlP7C0mVeIrG8LISt62kzNP/sImDuFRPd7rLaZJBOb0vVUUTgeXmQRSHC6F9iZQu4aDfNJjfGVv0L/3TnEtEV/a6duJSL9IMp6oTQjY09qFzyGaPLrfhOU6XIfxLV8I3UUdNScJH1R68OuZWogr1+TyfxLmipj/0OeJuK2+Hku2WV6LZGVuH3zUWCqJ7LdIm0+5dqT5mpJPR3YAwdwIPMaOVu67X6AE1wKyhdVzCR1SJ5rC5VvQstWoLCurIaI2odSwy5uFMmj1XSYnPJgWgUA==
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 96bc817a-87ba-45f4-6bc4-08d842b5c458
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3166.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 13:59:32.5626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxCT5dOGHNH/1R+GL5lCQ13m7l6a1jNeYMkKKG1RjowmAJGNYON2hEkgsTpMPMxulZVUJ07TszlzJeIJ1fq2mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3776
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
 drivers/net/macvlan.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4942f6112e51..2fb1fcea94fa 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1269,6 +1269,9 @@ static void macvlan_port_destroy(struct net_device *dev)
 static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			    struct netlink_ext_ack *extack)
 {
+	int rem, len;
+	struct nlattr *nla, *head;
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

