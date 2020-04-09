Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD99F1A38DB
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDIR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:26:28 -0400
Received: from mail-eopbgr20113.outbound.protection.outlook.com ([40.107.2.113]:51118
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbgDIR02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 13:26:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0YU6pdCRVYrs/zC2cNq8K+VWaOw8UzphkCVU+NsGGlTHXgRwrSnH4OxP9UHxyinGq2ZAYdEohAXFXGZQedAui2ojyDzUdO6UWVQ+v6aWjBQlfDpU+guiZ2sstq3IDUoiCJQcd97/BV9y7s5fJ0eVOEmzxK+IEZcELhr5dEaFZtafL1dsR4VEV/6g4afW3xgBYQp27DM7A77/x2o9xR8H+WzZVUASS7Ke0iRTnWJlliUCx9Z3oU9sfxzodkPi4lrB5l0OPLBjOZkOrOLX7Gv3IVIw0n+Ty85VrzC3cQuKDOUN+gXTKAJvp9wkfJU8r/ICFOKopIS3EruuoCVb1JN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4cuHkc40d9Mzz+m+Xsqh2mEg/2+xcZh/daAxPRtS9Y=;
 b=Ao9pC2BdDnlOt7aWnslSHEh2J0+7DRukWT76epCBnZznronILxsZ91FWYbqU90Bv39xhoMp/Z9eHnH0gwln1/kuVG/9O9P8mjlLZdv3WaO9TrHaqJ0JA9Su1o7TPRQB96S6A4tqAcVaCg9Aqq/4lalRB99KpH3NINSCdqTNhRj037nDGJyeIZKZa+UTi3cgSItX/yfyFN8VgV4/FIvaaa2L4G09861NVyEMOQe1riaL5Y3E7J6JPmNnC49sKiVrwbgF7FNtwW1Kw675ynl0T4v96chw9xmzNiwwDUCmjlxGd/0nB1yfFzuiBlnfrhcVtXxveW+4TZzTTKvptC6/AcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4cuHkc40d9Mzz+m+Xsqh2mEg/2+xcZh/daAxPRtS9Y=;
 b=XjG3cr8oBfWpqdi2Fjnef8Zlmb5ydcBh+pOz7AOKBnqN1SyRau8nKNgVL+lDB7rM57gAEV+ggJ/C4VJ0ML4qBKwc29ZoEHkPTmU0e1acYknA5AkGcxYEXO0rVGYx9l6RbvGHJFRjt1KawtDpYGd6+nLVMyJ17U8K49Gh+rXPwmA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0702.EURP190.PROD.OUTLOOK.COM (10.186.159.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.15; Thu, 9 Apr 2020 17:26:22 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 17:26:21 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Madhu Challa <challa@noironetworks.com>,
        linux-kernel@vger.kernel.org,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH net v3] net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin
Date:   Thu,  9 Apr 2020 20:25:24 +0300
Message-Id: <20200409172524.26385-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0024.eurprd05.prod.outlook.com
 (2603:10a6:203:91::34) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0502CA0024.eurprd05.prod.outlook.com (2603:10a6:203:91::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17 via Frontend Transport; Thu, 9 Apr 2020 17:26:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34c20bdb-a2ce-463b-203e-08d7dcab1f09
X-MS-TrafficTypeDiagnostic: VI1P190MB0702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB07024146AEAE50A9570A6FB595C10@VI1P190MB0702.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-Forefront-PRVS: 0368E78B5B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(366004)(39830400003)(136003)(376002)(346002)(6916009)(956004)(8676002)(4326008)(6486002)(2906002)(2616005)(186003)(5660300002)(26005)(44832011)(107886003)(6512007)(86362001)(16526019)(52116002)(66946007)(316002)(81156014)(1076003)(508600001)(66476007)(36756003)(6506007)(81166007)(8936002)(54906003)(66556008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KCsYRnMZZAkK/WJRizMy1WbbrpgHQ9n+7PynvZVOHcv6tGhCRS6Ss4sEwAR1fSYY6XhVFmP+l8uWh2+HpicI/h2yyAWXhOY+Ycq+qtEoUqv5PyU6lNdWkP7Xzo74Oy9uAjLev0k+MFzuuN2SM/Cvl8423L46vjAOds7ZdExhJTJslB8S9NasAr08fB72f44bChPXhGSJgV5osvTJbgJ1gDeeb6l3Ad+Am0pdsLlfwygwSNWQL12bIU3sII6MKI2FbyI8qpOz1FoypcCp++LW7kN+GUHuvfIN7O93QeL13FXqbVZl0Ewevfe74xRENTMal4gqzmSPxZbyqYHzEhgnUbec8vPrELoeCYhpYwIpzWWiwYBGNh8X0uBQCodQwtCGL61ldJ3TenAb6jDIeY6FjxwFB+TLQzVXmo8+Mv8DINf4LrOzgAzsjqVRcmZn3amj
X-MS-Exchange-AntiSpam-MessageData: 1K05dTBDgCPFnMN23fFlWq/9VWAMyTRYT+tM5K+8e0a4jrEmdpwIES5s39XqHPMHv3FbNRHGS7LkXiYB+wWw5gCycsSbLBl0FCWOEMqH4Cle+/3BEZ68Qw/wKOSbiPl/DpEF43Ze8RmwlvOIX2hPmQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c20bdb-a2ce-463b-203e-08d7dcab1f09
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2020 17:26:21.7272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75qVxm5OXEAbE+OGUR0PTsnuLihu2qkxp9dWMFfVMHAVQDjxaOIl5NCAYkrQJI0aZLD5V3PAnMrm9tbWcXgufybfN3OXFIDE6tETYkyTm14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0702
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taras Chornyi <taras.chornyi@plvision.eu>

When CONFIG_IP_MULTICAST is not set and multicast ip is added to the device
with autojoin flag or when multicast ip is deleted kernel will crash.

steps to reproduce:

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

Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---

v3:
    Use proper format for the "Fixes" tag.

v2:
    Fixed typo "reptoduse" -> "reproduce" in commit message.

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

