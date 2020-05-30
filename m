Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E61D1E93E0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgE3VKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:10:02 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:41895
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729290AbgE3VKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:10:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MloMpbscupSaC8y1rVogJtAulUJK6su+dZgX/wcZj1eSMeARW5nR6Iv1A0uCRNgyYSs/WY6l/lhErjTLRwsS/mFTLIOGkGmCcxRlviktaJ8xusvYKhz1u04bNKswVU6G0N6cXw+GB6QYzqhlEfhIyt31sgBumCvNB1SiEl6wLm92uUi7GFhUs5JhXjQjlfgKAunRjACrkQkGiMg6RGUFlzF24cNLxDwBlF3nkgBeJG19ojmc6DpvnYteaxS7aAWyLwF6eiXPTjwDarUM/9zzrjf4Bnm94f7npzaYBLQnlKyOq6QMUQf9b99pdOenp4EXfUXoSnJR9EhrhMAqK+AIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgAHux4ItyJXnEJdLjZbvJwTaNRfRZtiH3aeuWAKj6E=;
 b=G3F7tJ6x0SuURTUOHCqJ7JLGxPI2bLNil1/ggix1KzJMrCpvIEuSKOlWJbynzUKoB8ANCdNPXrsFseuZ1bpQTj3byhP/hV5NAohyYOXAOcI8bqFUxCeX2VNV0pbJYSQAn1gO0fWG6Bisv0TlnzTN+tlsj1M9S/wH8MjFnV4R2QxpGomhwqYy6YFYlhvZUa4LZMdKygEppgo/lgd3hHI4+bBJjmb9DR0KV+RGJ+nq4QkchPrxFwjf3lH3QlHjLhlRxuSK/KFojKF2hyYbN7JnTYQKejohrXHRQxNvB4+/K0tSi6XWH8T9IJspIu2iem70HZyjA67TRkZf/fEfyZF+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgAHux4ItyJXnEJdLjZbvJwTaNRfRZtiH3aeuWAKj6E=;
 b=jzET4ALc4doruzwLx/dTwhGqJGDlJNA1GPK2rzbxDAatxo92qLVg1yh31cCTkX6K84yq8MFNsZmak0pSfGPlwyk8Ft7v8bH8JGmYE3elPp06HAR7WLMWPwOokAkWDWq4KV9hnwBY7shy8l+RMqjxuAIrvJyBwD23+x2dzDCzsUw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:e1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Sat, 30 May
 2020 21:09:18 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 21:09:18 +0000
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v2 net-next  1/3] net: Make locking in sock_bindtoindex optional
Date:   Sat, 30 May 2020 23:09:00 +0200
Message-Id: <bee6355da40d9e991b2f2d12b67d55ebb5f5b207.1590871065.git.fejes@inf.elte.hu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1590871065.git.fejes@inf.elte.hu>
References: <cover.1590871065.git.fejes@inf.elte.hu>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0016.eurprd02.prod.outlook.com
 (2603:10a6:803:14::29) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.133.95.17) by VI1PR0202CA0016.eurprd02.prod.outlook.com (2603:10a6:803:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sat, 30 May 2020 21:09:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [89.133.95.17]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d50ab2be-4529-49e0-d9e3-08d804ddb645
X-MS-TrafficTypeDiagnostic: DB8PR10MB3034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR10MB30341DC0AFFCD70B73FF6874E18C0@DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UWrkDPS8BJ0b/cxV7mTttlVibXlZWcukW/kFOiLN2tHvKLhCSF1+06D5LEvj5AD7ASFKW4kxH60ssZjkaATWcw+GB3Hkdb0R1PXlJd89gVgKOinduITIDtYLs+C4EcddQrBCS2UwomodMbGHN71O9hF2o5tEBVy4yuo+F1T3XU0Exy6Pogq6z2j1Kd6tvKtsBOxIKKzknLXsKEDmKPmAuSBHff22/hPtOGra/VwE8vLfMs7pUpyyNEcBTqNIvbZZ694PdA4PtnzwIrIoGJhVIDnfKtB1FtLF8jcv5ih4qb3hAKj5A7MSy7WSdagaZWk4QjFu0uYRYx6bsN89zqwA4CDSpGcOxfM1GiuH7MggrczwjvZP6J/PMGwZZ3LbpbB5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(396003)(39840400004)(366004)(66556008)(6486002)(69590400007)(66946007)(66476007)(478600001)(83380400001)(107886003)(8936002)(6506007)(8676002)(52116002)(6666004)(5660300002)(26005)(2616005)(6916009)(316002)(956004)(786003)(86362001)(4326008)(2906002)(6512007)(16526019)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Sz+hnWRAiZcQvSYOS+YVoDP8Y7Ue68x+3QaxAfLSKtyhgXiwrcVaSSttAAuK8aAXL5DzXZOvYKfli0AsVR2KH8vYavmexYH6brPPKozNIT2M+rMwdkER5M0gsRSXgb1mjmgIiekCSJEgh11V4TR2jba1e39YRKuazjTrbbm29aWSsmQ9EE2A2ExTDrGy14m50A/NFiFmY2XlfVYAd3UkPMMDu5YaZzuNVo3GKrqgUkr+bmoQ02akKKGKDFRAjbBXenS47mp27snTbF5uHxclufnVBfGOAnzVQ4Bh3OYePX2UVK8lcANxsXhGJ0wHItD6GpiDzKNKB2pKFQ8TsUISqp4R6f2FMYikCiAQpeY+xx+PRJcFo2v4Qdy75HEc1iFTiRIUvoWcHm56Q05JeBpFoqC0Z10uMSlL4ipB9RdT0FpKZ8grLjyZj3H2KCF8DGnvuuVGDph8Jo+AzCoMOoc/xMZeMq6N4qAo4FTTYXIcmB4=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: d50ab2be-4529-49e0-d9e3-08d804ddb645
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 21:09:16.6399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9Je2leKkyNk3I5HyASXOueofSaarxEJeR5TdCSqwdwSZA/aOPA6qeVBfHX5xiYU7BYue6FTIzJzSRBD5/1KDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sock_bindtoindex intended for kernel wide usage however
it will lock the socket regardless of the context. This modification
relax this behavior optionally: locking the socket will be optional
by calling the sock_bindtoindex with lock_sk = true.

The modification applied to all users of the sock_bindtoindex.

Signed-off-by: Ferenc Fejes <fejes@inf.elte.hu>
---
 include/net/sock.h        |  2 +-
 net/core/sock.c           | 10 ++++++----
 net/ipv4/udp_tunnel.c     |  2 +-
 net/ipv6/ip6_udp_tunnel.c |  2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index d994daa418ec..098d97d9fe72 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,7 +2688,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 
 void sock_def_readable(struct sock *sk);
 
-int sock_bindtoindex(struct sock *sk, int ifindex);
+int sock_bindtoindex(struct sock *sk, int ifindex, bool lock_sk);
 void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
 void sock_set_keepalive(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ca3425b519c..c7ee722cfbe9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -594,13 +594,15 @@ static int sock_bindtoindex_locked(struct sock *sk, int ifindex)
 	return ret;
 }
 
-int sock_bindtoindex(struct sock *sk, int ifindex)
+int sock_bindtoindex(struct sock *sk, int ifindex, bool lock_sk)
 {
 	int ret;
 
-	lock_sock(sk);
+	if (lock_sk)
+		lock_sock(sk);
 	ret = sock_bindtoindex_locked(sk, ifindex);
-	release_sock(sk);
+	if (lock_sk)
+		release_sock(sk);
 
 	return ret;
 }
@@ -646,7 +648,7 @@ static int sock_setbindtodevice(struct sock *sk, char __user *optval,
 			goto out;
 	}
 
-	return sock_bindtoindex(sk, index);
+	return sock_bindtoindex(sk, index, true);
 out:
 #endif
 
diff --git a/net/ipv4/udp_tunnel.c b/net/ipv4/udp_tunnel.c
index 2158e8bddf41..3eecba0874aa 100644
--- a/net/ipv4/udp_tunnel.c
+++ b/net/ipv4/udp_tunnel.c
@@ -22,7 +22,7 @@ int udp_sock_create4(struct net *net, struct udp_port_cfg *cfg,
 		goto error;
 
 	if (cfg->bind_ifindex) {
-		err = sock_bindtoindex(sock->sk, cfg->bind_ifindex);
+		err = sock_bindtoindex(sock->sk, cfg->bind_ifindex, true);
 		if (err < 0)
 			goto error;
 	}
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 2e0ad1bc84a8..cdc4d4ee2420 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -30,7 +30,7 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 			goto error;
 	}
 	if (cfg->bind_ifindex) {
-		err = sock_bindtoindex(sock->sk, cfg->bind_ifindex);
+		err = sock_bindtoindex(sock->sk, cfg->bind_ifindex, true);
 		if (err < 0)
 			goto error;
 	}
-- 
2.17.1

