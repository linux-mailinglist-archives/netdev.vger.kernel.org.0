Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317333DAE44
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhG2VYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhG2VYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:24:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B754DC0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:24:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t3so6414602plg.9
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fy4W4kxfm1nEa/wP5BP/bSa5cQo0Af6YA7BT7Ec+mmQ=;
        b=ikgjwzsmkMQPs4IyIvSD237KNGoEwdukJ+CusdSPw/C/XXLTI6THmvcNGR8zzDr6Oa
         HNQlUjK1LiHEVU9GFafVLcaOlh12bbfF7AMFcj1EJK4NhX8PaAS+6aJPa+05A1S5k+LZ
         BM198dvIj8hyJERFEG4M2XS7cEzT44M+HzLsZRXthiHFETPdN2R/dDSQB0Jnb5ry7snM
         Sh6HbA+8oDHU9pjT4LX4fLRrAf6oDOo44smRP4mIf4PXOgw9SeOnAuiQYVsIoJ+wp5P9
         kbWar5u8Mwhl4RCB9KJwRF2cDva83fd+C3p5GMNqxHfNCPa+qKklO88QorKjS9jAzFuJ
         KxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fy4W4kxfm1nEa/wP5BP/bSa5cQo0Af6YA7BT7Ec+mmQ=;
        b=hOUkltnLcHrHYV14cRi7PUqiKs5I+AHCpj2ZxeJShlA58AVsHJtX1UkpqPKdwNGfDk
         y844kSlXKP3j4dbzeJ4OewV6JYDKt8SKfJCBmcogK6fmr8M0DEjYHZ3ZpCZfEiOo6VIM
         pnRTR/ixh75ugU54hd+T0R2LhHHKGlAbrZPLPy2YNOwEHggcAE/DYpzADQoQEdH030X6
         vCV5Kxu5pgyXoSeT/pzTsgvzxSikdjVfwEmHSheRzaRdu5zHkp50WYtkOGBZIh9eqzjb
         /xrW8htg28iSuQ/y/tgdkwb5x0ZNSirdHWDeODNYh6jM0jouZrx95nmowilP62SIo2Nm
         8w1g==
X-Gm-Message-State: AOAM531jhU+qmBtnOHV6/clhzUF6wKlYH8YgWaqXvUWJTA3ovah87FOv
        86DvGgE2bow+7FQrp7Tpd0DNP4qnFk41Jg==
X-Google-Smtp-Source: ABdhPJxFg9UCgV2x5UYpkSdvPrTHGtB7dVmFbfgzEfaHpsMHxz3xc6n0MQoWpO9IlV1oUFp22pxIbQ==
X-Received: by 2002:a17:90a:e7c4:: with SMTP id kb4mr16812257pjb.43.1627593869099;
        Thu, 29 Jul 2021 14:24:29 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id c15sm4686258pfl.181.2021.07.29.14.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:24:28 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 4/5] selftest/bpf: change udp to inet in some function names
Date:   Thu, 29 Jul 2021 21:24:00 +0000
Message-Id: <20210729212402.1043211-5-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210729212402.1043211-1-jiang.wang@bytedance.com>
References: <20210729212402.1043211-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to prepare for adding new unix stream tests.
Mostly renames, also pass the socket types as an argument.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 30 +++++++++++--------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 7a976d432..07ed8081f 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1692,14 +1692,14 @@ static void test_reuseport(struct test_sockmap_listen *skel,
 	}
 }
 
-static int udp_socketpair(int family, int *s, int *c)
+static int inet_socketpair(int family, int type, int *s, int *c)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
 	int p0, c0;
 	int err;
 
-	p0 = socket_loopback(family, SOCK_DGRAM | SOCK_NONBLOCK);
+	p0 = socket_loopback(family, type | SOCK_NONBLOCK);
 	if (p0 < 0)
 		return p0;
 
@@ -1708,7 +1708,7 @@ static int udp_socketpair(int family, int *s, int *c)
 	if (err)
 		goto close_peer0;
 
-	c0 = xsocket(family, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	c0 = xsocket(family, type | SOCK_NONBLOCK, 0);
 	if (c0 < 0) {
 		err = c0;
 		goto close_peer0;
@@ -1747,10 +1747,10 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	err = udp_socketpair(family, &p0, &c0);
+	err = inet_socketpair(family, SOCK_DGRAM, &p0, &c0);
 	if (err)
 		return;
-	err = udp_socketpair(family, &p1, &c1);
+	err = inet_socketpair(family, SOCK_DGRAM, &p1, &c1);
 	if (err)
 		goto close_cli0;
 
@@ -1825,7 +1825,7 @@ static void test_udp_redir(struct test_sockmap_listen *skel, struct bpf_map *map
 	udp_skb_redir_to_connected(skel, map, family);
 }
 
-static void udp_unix_redir_to_connected(int family, int sock_mapfd,
+static void inet_unix_redir_to_connected(int family, int type, int sock_mapfd,
 					int verd_mapfd, enum redir_mode mode)
 {
 	const char *log_prefix = redir_mode_str(mode);
@@ -1843,7 +1843,7 @@ static void udp_unix_redir_to_connected(int family, int sock_mapfd,
 		return;
 	c0 = sfd[0], p0 = sfd[1];
 
-	err = udp_socketpair(family, &p1, &c1);
+	err = inet_socketpair(family, SOCK_DGRAM, &p1, &c1);
 	if (err)
 		goto close;
 
@@ -1897,14 +1897,16 @@ static void udp_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
 		return;
 
 	skel->bss->test_ingress = false;
-	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	inet_unix_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				    REDIR_EGRESS);
 	skel->bss->test_ingress = true;
-	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+	inet_unix_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				    REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
 
-static void unix_udp_redir_to_connected(int family, int sock_mapfd,
+static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 					int verd_mapfd, enum redir_mode mode)
 {
 	const char *log_prefix = redir_mode_str(mode);
@@ -1917,7 +1919,7 @@ static void unix_udp_redir_to_connected(int family, int sock_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	err = udp_socketpair(family, &p0, &c0);
+	err = inet_socketpair(family, SOCK_DGRAM, &p0, &c0);
 	if (err)
 		return;
 
@@ -1972,9 +1974,11 @@ static void unix_udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
 		return;
 
 	skel->bss->test_ingress = false;
-	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	unix_inet_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				     REDIR_EGRESS);
 	skel->bss->test_ingress = true;
-	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+	unix_inet_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				     REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
-- 
2.20.1

