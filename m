Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980E13E1EDD
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbhHEWfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbhHEWfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:35:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8CFC06179A
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 15:35:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso13144993pjf.4
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 15:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OmM6Jh2wG8NHNQR7MWK2cVhqAuC5kqvoMNBPLIkIjok=;
        b=gJAwkUIR3vLaGoEbj5fFmUDcmhkcN0MWKUSujiHo+AS2+aHlrN8WZV4nKeV7SQSWNv
         jQyqCdfD0Nh2AiWW8KdOCfx/8CiV4atfUlKAdz3fF5sKqYej8thanA1jkMD4YyaSf70l
         RjyWrK78TLWRDpUTqd637uoLduVvSVVXwgSxQJZrdoMSbmqp0+S26v3UnB4fPUJr8Nv3
         JEZUJ3KoczVbwbErJ1ecG92DyxsmWbDgOcqydu5lU0541fXCo0sIRDFA40FjUHRaP7Xh
         XvL6QiP34L27KljEF0cB3E8kauhOmSPi9MeXRxcrVTBZtIM//BnBnh8tQGHiUoRhcQMt
         WRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OmM6Jh2wG8NHNQR7MWK2cVhqAuC5kqvoMNBPLIkIjok=;
        b=OHbKA6vxajqycp8UESer+F77dRzZO9UzdTQOrRKl0DurQXYakmhKhE9FyWyI0jBnoS
         /i+eJ8wXGyvq0WLk8+7xSgcDj7PYlQ3JJLnTEoyyAcARP2qGPizAmIh0Hg0gBkBqog/k
         fUpcMFSZBuXZcJYESAHPrtNYCDdc4tDXXBBYSZhX4gMgwGCoYajDxDK0RI1LmZ8cH5ih
         LVt2j5SCLDC44Yzal0jYAocyb3VWM8nmDMmEKwQDPUN0+0NYsbqWcTCoO5zhNtOV26Mi
         0RcGTXnbOpeCWzz7x4IOCEfjwke3vNkuJ4pEkCWbI6VIPHd2GE3eQ8EpB0ufVHa2uY9a
         Rbuw==
X-Gm-Message-State: AOAM532RXWk9mVpo1PtuhFhmzX70vsrqRqZL2VFYbs1kvn7DKOjT5AI+
        dtWqssNHBZ4QHQVISPNegKmsVYD/L2eltQ==
X-Google-Smtp-Source: ABdhPJxQzKZmrBsaWAnsfedYD8Twq8bafYy8X8my8eCWcuNmeS5A8lhN3h9wgoTGKknD3D+EuS2J+w==
X-Received: by 2002:a17:902:e806:b029:12c:8220:62fd with SMTP id u6-20020a170902e806b029012c822062fdmr5883027plg.48.1628202924252;
        Thu, 05 Aug 2021 15:35:24 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id z8sm7931638pfa.113.2021.08.05.15.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 15:35:23 -0700 (PDT)
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
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v5 4/5] selftest/bpf: change udp to inet in some function names
Date:   Thu,  5 Aug 2021 22:34:41 +0000
Message-Id: <20210805223445.624330-5-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210805223445.624330-1-jiang.wang@bytedance.com>
References: <20210805223445.624330-1-jiang.wang@bytedance.com>
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
index 7a976d43281a..07ed8081f9ae 100644
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

