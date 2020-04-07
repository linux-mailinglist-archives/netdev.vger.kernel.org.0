Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF41A17DB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDGWPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:15:09 -0400
Received: from mail-eopbgr140107.outbound.protection.outlook.com ([40.107.14.107]:23061
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbgDGWPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 18:15:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kx5gHT+0jbkwmX+b8AOx/2RQq5QQd2iz2JeNf4bfYDsgPCcWW6dvruBhoN6iDnBLovOBpDveYqwc8r/WciX2QsVsoAGAF/zRAXaPBkaPLuQzAgNBC5Hu/YkHad1pjTNaOYibDvMijSVyOb7tRrywUipa4MKDvhnyWKn7OGNRB6ns649g41cdf8I8xqQCIBBB1CL12jQp+IronSnkuWXh5c+eBAqQX57eo17pDPNilZBlf5OPnmAg7p/lkKNTQUw3clp7z1bwFR1U25ZV8haG4Fcf34s8GMPAv0ZrtfPrxh07zpRk0kxf/f5OzqNEXBc58pIxMVUqXoFX2lM1W0C3/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vObIaU106vGPdhOii1gJgdfsj4lAYkLdnDaDSeWPXDw=;
 b=bGqHwnfwDsbuHa+LEz9pRaVUl0ZRfFHQHj5EtTwsYrJIYoJdAowPqgBZmd+SwYQASqI3sUPItImMQ2Dk2z94C+ugcqgEqKn1B087L9hsmTGfI0c5xg27TJ72qnQT/DWM7EpRpHFoMACqhPAdlK6Bt+x9BMklb6waP1hOJxKvR9jhlE562UGw9NrIlp0utoCABXAKZROruBYx2PpLOlBXCdpKpU3h82bxFDMI3smWucgqxcLVKS4boFKq0LPOaPWkieefYkV7kWTbfKNBeFBckWCCLGtRaPXDlBDWkqPvxiwKNQF/ud9wxYzLjCxq9pRBh/vs9L5D2mjjp3c3Jw4itA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vObIaU106vGPdhOii1gJgdfsj4lAYkLdnDaDSeWPXDw=;
 b=k1N1g9ZtcSCnvq++33NRCW7/PklmVlUs5ix8eVl2DAc5e06G9PUuFO9mqs4OELalEuodAVkAkqYXjE5o5BmUFIjQHP+Sq55413anpHjjYY1nYXhFj/+o/tvnk+VxdM3JRvl4Vc4Y84KzZdsi6XoSDP8NsD/PB3tJ7sT+Ru/dH1Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0526.EURP190.PROD.OUTLOOK.COM (10.165.190.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.15; Tue, 7 Apr 2020 22:15:03 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2878.021; Tue, 7 Apr 2020
 22:15:03 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Madhu Challa <challa@noironetworks.com>,
        linux-kernel@vger.kernel.org,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH net] net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin
Date:   Wed,  8 Apr 2020 01:13:28 +0300
Message-Id: <20200407221328.32603-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Tue, 7 Apr 2020 22:15:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a9a4e0b-bfa5-488a-81ec-08d7db411e7e
X-MS-TrafficTypeDiagnostic: VI1P190MB0526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB05262B3DA5F3E235BE6E586095C30@VI1P190MB0526.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(366004)(376002)(346002)(136003)(39830400003)(2906002)(8676002)(6486002)(44832011)(107886003)(4326008)(186003)(52116002)(6916009)(16526019)(6506007)(1076003)(26005)(81156014)(81166006)(8936002)(36756003)(66556008)(6512007)(2616005)(6666004)(508600001)(86362001)(956004)(5660300002)(316002)(66476007)(54906003)(66946007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04BY0BM0GvrCFbJAxUh/Gr8bIv9ii+9m2CzGRQvVat0gF3OAqTSxYUsdbox9bkua7dL7PgZUrodBIxf+nA+HFC0+Cq4cX0JQ/XfA4sgu6sTyY02XOmJlCF5/mqzwvYmctMsdibi+TEupnYEBXbcoNPN/DrpULHYufDCM3cZL8f3Ea7Sm9BJ4pceP3gZalkYqUZcJ5G9jIX6SZlWSHF4+KpDjkPB3YaiRrvu2qBJbTY7agEIex7fjr1Ly9wFvjgab6HtMtW18OTWv8K/PRa9lTBeyrwQ+lGBG0PeqEFLmt1hYognoVQxblDKJG3Pv4fCmmbesC4tfU2yuDvbYDvg/iaNGcsDp2059e54BNKp2BeZwju4gT71T0OGu8GkJJR09/FxkHNe/IYs8NUHYXV4QojKSakk0zz7m3BeH2y2QWjL/7iuHOrLtgv4zYScW2c/b
X-MS-Exchange-AntiSpam-MessageData: TFyIFN12ya3JzRyAXtiYOlL7b+kYqDpwQIO3Dy8mjew05V4TawZ+U1eSdl8lS4rodCZy2hjqOq63kQ0WOL8a4BmoMKQ84XoxQ1nOjA7/+ab7/T5k5yWtuVqRS9Lst4oD2HklAVXD6vfHf0HtbAkePA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9a4e0b-bfa5-488a-81ec-08d7db411e7e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 22:15:02.8897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DqestgH0SVVMbECNDzIvS1S5dI/XG1Pxt321XmNdFBx+i7Ai+V9xbwuyoVmsjDNTGOZscET0iCJaA+FIQHZB6gkLVau/DqEje20daddWfwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0526
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taras Chornyi <taras.chornyi@plvision.eu>

When CONFIG_IP_MULTICAST is not set and multicast ip is added to the device
with autojoin flag or when multicast ip is deleted kernel will crash.

steps to reptoduse:

ip addr add 224.0.0.0/32 dev eth0
ip addr del 224.0.0.0/32 dev eth0

or

ip addr add 224.0.0.0/32 dev eth0 autojoin

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000088
 pc : _raw_write_lock_irqsave+0x1e0/0x2ac
 lr : lock_sock_nested+0x1c/0x60
 Call trace:
  _raw_write_lock_irqsave+0x1e0/0x2ac
  lock_sock_nested+0x1c/0x60
  ip_mc_config.isra.28+0x50/0xe0
  inet_rtm_deladdr+0x1a8/0x1f0
  rtnetlink_rcv_msg+0x120/0x350
  netlink_rcv_skb+0x58/0x120
  rtnetlink_rcv+0x14/0x20
  netlink_unicast+0x1b8/0x270
  netlink_sendmsg+0x1a0/0x3b0
  ____sys_sendmsg+0x248/0x290
  ___sys_sendmsg+0x80/0xc0
  __sys_sendmsg+0x68/0xc0
  __arm64_sys_sendmsg+0x20/0x30
  el0_svc_common.constprop.2+0x88/0x150
  do_el0_svc+0x20/0x80
 el0_sync_handler+0x118/0x190
  el0_sync+0x140/0x180

Fixes: 93a714d (multicast: Extend ip address command to enable multicast group join/leave on)
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 net/ipv4/devinet.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 30fa42f5997d..c0dd561aa190 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -614,12 +614,15 @@ struct in_ifaddr *inet_ifa_byprefix(struct in_device *in_dev, __be32 prefix,
 	return NULL;
 }
 
-static int ip_mc_config(struct sock *sk, bool join, const struct in_ifaddr *ifa)
+static int ip_mc_autojoin_config(struct net *net, bool join,
+				 const struct in_ifaddr *ifa)
 {
+#if defined(CONFIG_IP_MULTICAST)
 	struct ip_mreqn mreq = {
 		.imr_multiaddr.s_addr = ifa->ifa_address,
 		.imr_ifindex = ifa->ifa_dev->dev->ifindex,
 	};
+	struct sock *sk = net->ipv4.mc_autojoin_sk;
 	int ret;
 
 	ASSERT_RTNL();
@@ -632,6 +635,9 @@ static int ip_mc_config(struct sock *sk, bool join, const struct in_ifaddr *ifa)
 	release_sock(sk);
 
 	return ret;
+#else
+	return -EOPNOTSUPP;
+#endif
 }
 
 static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -675,7 +681,7 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			continue;
 
 		if (ipv4_is_multicast(ifa->ifa_address))
-			ip_mc_config(net->ipv4.mc_autojoin_sk, false, ifa);
+			ip_mc_autojoin_config(net, false, ifa);
 		__inet_del_ifa(in_dev, ifap, 1, nlh, NETLINK_CB(skb).portid);
 		return 0;
 	}
@@ -940,8 +946,7 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		 */
 		set_ifa_lifetime(ifa, valid_lft, prefered_lft);
 		if (ifa->ifa_flags & IFA_F_MCAUTOJOIN) {
-			int ret = ip_mc_config(net->ipv4.mc_autojoin_sk,
-					       true, ifa);
+			int ret = ip_mc_autojoin_config(net, true, ifa);
 
 			if (ret < 0) {
 				inet_free_ifa(ifa);
-- 
2.17.1

