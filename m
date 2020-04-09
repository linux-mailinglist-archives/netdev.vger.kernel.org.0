Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7511A2ED6
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgDIFlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:41:05 -0400
Received: from mail-vi1eur05on2129.outbound.protection.outlook.com ([40.107.21.129]:11873
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbgDIFlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 01:41:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezet1MOuZI6Tc8JHakIXtmJFkD6fgf9uGn76CUcikNVgSdjbWlCcx5YU6FnFFP0Enc1mcFi3Yiy1MAuLyGZ1o/mdgZjJ+j2ryGeEJORNkXYZCVYRBfzfQXFlhz74D/22Hxpk36qr1KxN9uCryJb0ly+Ox2xu4EsKdyQ8d6NSKRw0mgjrdk5zOdS3fXW+H02/lBjOJZUMHzajArq5qeotnfofWH9BKRCM8MsHmRb0pHiRCPF1S8OHMpBcs7CJkzwManIYEDVw6DQ/tDi1Pc4+9XBy6Ew7yfdAMFZRg/NkXpwALYbRQocHYCYsNo4dZXqjMF5DiSF7p35XoFbBnks50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVTxngOWYC5vJUncDnXBMease+ltDf3/1WaoBijrGEs=;
 b=WducmkblL/bgWltjEmjvRW65edDgHrmNS7k0WHFQ4+7m1AkacbVSGkT2/sYZgBAEvdS6w48BqkHlO7UhnmDtrzOtFFfnvWlOa2RzQkT+qV1vjiGpeDx7oVM+llLl0yg/stwmrMsNWxTQVTRtHTIGV25+YKJP44GCA3ATU0eQIsl6qCrHRA/8EInVEjeyp04XLR1YJ0yGriIyskNC5ZpiQDe/0i1d1NUadEw1J2GynCMsp8lDSkgquMQ8EWCiloyiFdJebNmdf+7l6P+BOXkczhztbfAc18IOaQ27e2ptza/zpFN+MDehKKc/NJ+n4yNUVQJYxI7wAAwB5DYxggFHAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVTxngOWYC5vJUncDnXBMease+ltDf3/1WaoBijrGEs=;
 b=xlZtu2bDMCB3lwNtV9ovVsMat9LcGXILFN5f76BVh2g0fl0DNPfmACDZuCnKYbsYGV5YreRosF4GN39ZAwF8MQ/n6B8BWyG3HrR56lDlrgG8/33oCuY+8N0/mP5LBQ/iucYDp/GzFilD21NRaBbF2ucvDH5OsBCh5fagx/52O3k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0672.EURP190.PROD.OUTLOOK.COM (10.141.34.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Thu, 9 Apr 2020 05:40:24 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 05:40:24 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Madhu Challa <challa@noironetworks.com>,
        linux-kernel@vger.kernel.org,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH net v2] net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin
Date:   Thu,  9 Apr 2020 08:39:32 +0300
Message-Id: <20200409053932.22902-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR01CA0060.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::37) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR01CA0060.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Thu, 9 Apr 2020 05:40:23 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb59ca7f-15f5-4f64-ce7d-08d7dc487fdf
X-MS-TrafficTypeDiagnostic: VI1P190MB0672:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB06722EEE302036E664C61B8B95C10@VI1P190MB0672.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-Forefront-PRVS: 0368E78B5B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39830400003)(376002)(346002)(366004)(136003)(396003)(956004)(186003)(36756003)(54906003)(6506007)(16526019)(52116002)(44832011)(66946007)(6666004)(6486002)(66476007)(26005)(4326008)(81166007)(2616005)(66556008)(316002)(6512007)(86362001)(5660300002)(6916009)(8676002)(81156014)(508600001)(107886003)(8936002)(2906002)(1076003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIprqqqHfeClQEO++V8mNQqQQErecOvLttOgn8JYQgqjuz63muPz2UOenf3AWcDRM4usXeK6yyVyOIf5DuvfjzCFawPc9cxjm/hLyc8Yk15CCG0o0tl31IKGTRgo9dGGjWrYEEwS3zODw+LY+cI32glFLsl/Yh0UebKttP4H9F8UDko1aYRYDUnKbBU6/bu8qXlkeLbH5Hjp+gMAGGHp4hPgnztHTQXZQST9SyEXCdLJWh4jtMDLVH92Z+7rcjxIhflpiTW9kkcmlrmZCFkftDdy+NTw9QcI4RCWlA3CyGDIn22BCUIMK3mLomqZv3LrPVtQ2KYEGZEs3NXbAyTbAzk3LpVgMw3AO0YKVIlDs4pU0hlxBZ5Dz8LDceeikYRvlE2JNAUdQ3+L/cffwtPpeo6g4isRXT802naSphRweu+asl874hcUuQLR4OZdQcxg
X-MS-Exchange-AntiSpam-MessageData: cMyu5971yOPY32zRAw0Kmm7CEu9Z6QZRKk8UvfStsYkHr2h5jhNNnA88M5vfaE5kLTxQlq4QdjZf9Bq4Yc3bxANBu8nYKSjRfm84Sc+fw6RuuOjl7Ee/WERrX3OqWSNg0CZPorrSLJSqgiBRSa1gWw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fb59ca7f-15f5-4f64-ce7d-08d7dc487fdf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2020 05:40:23.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Uxc0jCEd0gTNArm4lI7BYbLgTKyX8nqtxsJLyzFwBTjvFsErLnCp/+sTjtXACZpTY6tYIYUeA20Cka4NEDpqPzSZPcIdR79SNG60QCOvzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0672
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

Fixes: 93a714d (multicast: Extend ip address command to enable multicast group join/leave on)
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---

v2:
    Fixed type "reptoduse" -> "reproduce" in commit message.

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

