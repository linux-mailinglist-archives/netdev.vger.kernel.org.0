Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401571DCD5A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgEUMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:53:24 -0400
Received: from mail-vi1eur05on2061.outbound.protection.outlook.com ([40.107.21.61]:60377
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729296AbgEUMxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 08:53:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBF+VgeQpVGLJEG1F3U494jKLy0TqqqS9fCtI+TXrPVWuV7HITgBv37fUeaApTqNt9lbe4dDwGfcD1mXh+3+rTAqQNq7l6ymQnrx7F9W1V1rwUoeBd4vIz2xLLWZvaleEgqYdrzkv/opSoLJKcPpX1Z9WGtt40/oHFx2x/RJxeS3uxyTJo7ISJ2Sft04jSOr0r6ZP3CT1yuI7sazxKhQkYBxrXLKqmE3DwXxgtXIcXDvbtMKFCgQx2gqvBPCmVC0SHekNCBaZCAw6DhRe2OZc8B0jUiBL5sg7+hlvBzh2MHopIuyTHHEudHim3yeDLcosEK9GIyE8KCK8Xl2FCQCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzR+SM5Lx9+yNAX25R/nIM0lqOdB2Anylgu2JLBDMQM=;
 b=nWNAJ+smvHyDDv6L5ZxbMd+Z5MItjLSokk+qAFDTP2A6YH8YefrT5IbPxah2E8jvmWSAWFwG3se+9lW7QP6UIXHhRKz5Km2CoydnNTXVNQCMyG/dwhQhek9VQf/JsmYZ7p1/5xldO0hCb+s4575+xjIJTrIiOeEYGxftyzbwqPgKIgqZcUSj/UbAabgXCnMCoc7DsgYxtY0PillbqwZPfh3Cf1nUg3yRVL6WVO3OvCA3ttb1nvGkrcSl78MyKTRV6NHV2Xa0hlausNpd/RCAHFj7WDSyH2yRdfhzYnHJMI9VMgxoPfKCAnfOXFF+daYKlL0+MXRV4PeAecqmdT/YaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzR+SM5Lx9+yNAX25R/nIM0lqOdB2Anylgu2JLBDMQM=;
 b=p7XlRD5c7AWIwyhfx1V2tWFUhhkPXck9RI3TZB5T9J0DaRcZIZtiQXzzRkBgZbduUvZaWpBT+dsjhkNa233fwPBtZH92eBqkjsjDmwAbnqY4Y9ZSPqZDHqRXOO46kfZCNo5kTRI49qM8G8G/deS2mEERoRqGAgxOlXbP7dTzoVs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3911.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:16c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 12:53:18 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3021.024; Thu, 21 May 2020
 12:53:18 +0000
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH net-next] Extending bpf_setsockopt with SO_BINDTODEVICE sockopt
Date:   Thu, 21 May 2020 14:52:47 +0200
Message-Id: <20200521125247.30178-1-fejes@inf.elte.hu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0137.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::35) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.133.95.17) by VI1PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:803:f0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Thu, 21 May 2020 12:53:18 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [89.133.95.17]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ae0342e-4328-4557-2c8b-08d7fd85ef77
X-MS-TrafficTypeDiagnostic: DB8PR10MB3911:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR10MB39116B4F2C53E1E1E479E36CE1B70@DB8PR10MB3911.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/KLKiYUrmz1A+CZhNhgWJ6376qyEuq39uds+wW3tk6uJmFiBFTVNFU0eDZn3ILJCeWdr6+CAF7q0+wJtWFzwnIL5Hv8teUnjeSDg2cLNPjCfMSRdYDJ03y0wtsTXVEGzC6KeJYzrwvHJOLy5T1BuN9gWzyaSI63AEkKKnd0t9Jr3z3ybnSGjJFML6QuQ6OKXw4zpS9TXv9BgdozQXOKsujihSzE9JyRRI39LeuWMCK/e8I2b60pk4WVV1bjYhG3Iti7GVAbP02tK5+4gqzQzUTweC6hgXUhttDu4qENPwwJG2iiF5LOcEaTmZpmI2N5S1e0MEzROwXO6zpKB224XYtdnOzf/hrot+NGj8W4dO/0a9qul3R9qeOmIaaQ8INV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39850400004)(366004)(136003)(376002)(52116002)(2906002)(26005)(16526019)(786003)(8676002)(8936002)(316002)(478600001)(107886003)(86362001)(6512007)(4326008)(6486002)(54906003)(66476007)(5660300002)(1076003)(6666004)(6506007)(2616005)(186003)(956004)(66556008)(6916009)(69590400007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a67dSjW1j464p/Ox0CQL2BHRU9fx3982zGL4rfNrJj5V1fqziAIv5zafy63ibseD16exXHFMUlVd4IQRWo3JF4UBmCJ20GVx1wBNRXS7Q0V+1AnpwQHfieXmfPec122AYgjlDQmqZAJyGJlP7wu1VsefEGnBSKoHcwY9/cDoE5yOEp7FRQsANblcZMaYX4f2cTru+QUOITf493jvjLk5e36WsfbKEXyZUGhVHtXJvi3hN5S/9iOQn/lWgLEV6qz6jtQYXpy+1ICE1bAhufQAwBmnoBHc88h2PJ8/F+HuNEKrx4jAq4odGG8/SAUTzz1VxjQl8yMG28lPsXPGlNq5gx7eqb1o6wvhZDhnSiNJHeWdzI9XBTZjm4/YNs8OvfzErbUkzTuQosgtvH4aNdSe6XU9iPs4Vt5FdCH6lSpzcK1ofSSAvp/IdjYVe55ukYpSacTa5QYyrXuRhnkxN4jSI+v6dqFIAzXqltI3M9UxUQQ=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae0342e-4328-4557-2c8b-08d7fd85ef77
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 12:53:18.7656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YyO8sFlsD88UlyvuQJNyeaLEeGP+CA/jCw2HZNBZnFHTvoie7aSXc00qMKU17hvX4MmbzMUq6vC5hEVZlF9a1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3911
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option makes possible to programatically bind sockets to netdevices.
With the help of this option sockets of VRF unaware applications
could be distributed between multiple VRFs with eBPF sock_ops program.
This let the applications benefit from the multiple possible routes.

Signed-off-by: Ferenc Fejes <fejes@inf.elte.hu>
---
 net/core/filter.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 822d662f97ef..25dac75bfc5d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4248,6 +4248,9 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen, u32 flags)
 {
+	char devname[IFNAMSIZ];
+	struct net *net;
+	int ifindex;
 	int ret = 0;
 	int val;
 
@@ -4257,7 +4260,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 	sock_owned_by_me(sk);
 
 	if (level == SOL_SOCKET) {
-		if (optlen != sizeof(int))
+		if (optlen != sizeof(int) && optname != SO_BINDTODEVICE)
 			return -EINVAL;
 		val = *((int *)optval);
 
@@ -4298,6 +4301,40 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				sk_dst_reset(sk);
 			}
 			break;
+		case SO_BINDTODEVICE:
+			ret = -ENOPROTOOPT;
+#ifdef CONFIG_NETDEVICES
+			net = sock_net(sk);
+			strncpy(devname, optval,
+				min_t(long, optlen, IFNAMSIZ-1));
+			devname[IFNAMSIZ-1] = 0;
+			ifindex = 0;
+			if (devname[0] != '\0') {
+				struct net_device *dev;
+
+				rcu_read_lock();
+				dev = dev_get_by_name_rcu(net, devname);
+				if (dev)
+					ifindex = dev->ifindex;
+				rcu_read_unlock();
+				ret = -ENODEV;
+				if (!dev)
+					break;
+			}
+			ret = -EPERM;
+			if (sk->sk_bound_dev_if &&
+				!ns_capable(net->user_ns, CAP_NET_RAW))
+				break;
+			ret = -EINVAL;
+			if (ifindex < 0)
+				break;
+			sk->sk_bound_dev_if = ifindex;
+			if (sk->sk_prot->rehash)
+				sk->sk_prot->rehash(sk);
+			sk_dst_reset(sk);
+			ret = 0;
+#endif
+			break;
 		default:
 			ret = -EINVAL;
 		}
-- 
2.17.1

