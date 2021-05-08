Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B8637744B
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhEHWK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhEHWKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:22 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A357C061574;
        Sat,  8 May 2021 15:09:20 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id n22so9300436qtk.9;
        Sat, 08 May 2021 15:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLt69FAUdQ5bTjcW1qMZRDUzZdTqyuja2OTZzrCIJKA=;
        b=QH77ESMXTdvcN9H101MLsSEAlop+4jYyFNEkWpeRSqUDU8149qOcELR1L2OkvzPpui
         XqR3Zo1IhWPZBVNDeX/KxmnvNJXWRx5osCZHFbNbsZ7ImZKMs9tu6pPDLUYt5Odn/+TB
         +55WnYZW5CZY0sROUKw54j43vXd1+NvX1AK6hgC4ys4XCnMhbhzVDdqRxx/LZ+jLdV3v
         7KwcpXKoiYRgF9yZTLdPJQQffF1Udz93HLSfeScyoVewsVglnICCdjFnmIMLIZ6jy0Ik
         Q6IDmXZ7B/7TVL2lOO8cUuQ14fDdC+Gc+4uhF3v3rNc0M5dNsx+vJoolGzCWXD0jkZyE
         2DmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLt69FAUdQ5bTjcW1qMZRDUzZdTqyuja2OTZzrCIJKA=;
        b=QwQeXDd9vR7umsiH5fBUULXnf9ugprIKvNl1rfvoWb7hZJF1jrfr318+5qTOxp3fyf
         16PXWtZP/jbyGcrg5G9Z8j2rrFutkYI8+rEwGRVMR8Yq9XwS0+T2WRfHllLkEpFuQyvn
         dZFXiFPILYnCVqumFuuh/onLfHAbpw7p6qOwfEveLZRH+vpJaOwj8qqY/HDjVhLAnzLs
         dM/TiF9m7sCgrkQ9eaBp1yX5Gj8XtmTjWxvy/za9Bh858OzimtvUeTMCo1VSx1yReAWz
         E9m68fss/OTnpCYXn8vcdJ6DQskw5A+HgVrkWRHrh0hrW/pEy5wMdKIN0HmwfzZClsf1
         vGow==
X-Gm-Message-State: AOAM533qdzgmfIsdR+kiqAGhW1gsKUYLisEkOJbXY5PJVMDODZAojO0S
        9E5RLblJTuCKvBkbLNqMeth4ALD0VUmMXA==
X-Google-Smtp-Source: ABdhPJwf7a0MyLfe84FJIHQwSjidnK3XFfNcVqeeljTjm7SAvphCba6pUhOXtl+EGHOmB0Q7y/HqKg==
X-Received: by 2002:ac8:4c8f:: with SMTP id j15mr10354430qtv.328.1620511759259;
        Sat, 08 May 2021 15:09:19 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:18 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 09/12] selftests/bpf: factor out udp_socketpair()
Date:   Sat,  8 May 2021 15:08:32 -0700
Message-Id: <20210508220835.53801-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Factor out a common helper udp_socketpair() which creates
a pair of connected UDP sockets.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 76 ++++++++++---------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 648d9ae898d2..3d9907bcf132 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1603,32 +1603,27 @@ static void test_reuseport(struct test_sockmap_listen *skel,
 	}
 }
 
-static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
-				   int verd_mapfd, enum redir_mode mode)
+static int udp_socketpair(int family, int *s, int *c)
 {
-	const char *log_prefix = redir_mode_str(mode);
 	struct sockaddr_storage addr;
-	int c0, c1, p0, p1;
-	unsigned int pass;
 	socklen_t len;
-	int err, n;
-	u64 value;
-	u32 key;
-	char b;
-
-	zero_verdict_count(verd_mapfd);
+	int p0, c0;
+	int err;
 
-	p0 = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	p0 = socket_loopback(family, SOCK_DGRAM | SOCK_NONBLOCK);
 	if (p0 < 0)
-		return;
+		return p0;
+
 	len = sizeof(addr);
 	err = xgetsockname(p0, sockaddr(&addr), &len);
 	if (err)
 		goto close_peer0;
 
-	c0 = xsocket(family, sotype | SOCK_NONBLOCK, 0);
-	if (c0 < 0)
+	c0 = xsocket(family, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	if (c0 < 0) {
+		err = c0;
 		goto close_peer0;
+	}
 	err = xconnect(c0, sockaddr(&addr), len);
 	if (err)
 		goto close_cli0;
@@ -1639,25 +1634,36 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (err)
 		goto close_cli0;
 
-	p1 = socket_loopback(family, sotype | SOCK_NONBLOCK);
-	if (p1 < 0)
-		goto close_cli0;
-	err = xgetsockname(p1, sockaddr(&addr), &len);
-	if (err)
-		goto close_cli0;
+	*s = p0;
+	*c = c0;
+	return 0;
 
-	c1 = xsocket(family, sotype | SOCK_NONBLOCK, 0);
-	if (c1 < 0)
-		goto close_peer1;
-	err = xconnect(c1, sockaddr(&addr), len);
-	if (err)
-		goto close_cli1;
-	err = xgetsockname(c1, sockaddr(&addr), &len);
+close_cli0:
+	xclose(c0);
+close_peer0:
+	xclose(p0);
+	return err;
+}
+
+static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
+				   enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	int err, n;
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	err = udp_socketpair(family, &p0, &c0);
 	if (err)
-		goto close_cli1;
-	err = xconnect(p1, sockaddr(&addr), len);
+		return;
+	err = udp_socketpair(family, &p1, &c1);
 	if (err)
-		goto close_cli1;
+		goto close_cli0;
 
 	key = 0;
 	value = p0;
@@ -1694,11 +1700,9 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 
 close_cli1:
 	xclose(c1);
-close_peer1:
 	xclose(p1);
 close_cli0:
 	xclose(c0);
-close_peer0:
 	xclose(p0);
 }
 
@@ -1715,11 +1719,9 @@ static void udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
 		return;
 
 	skel->bss->test_ingress = false;
-	udp_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
-			       REDIR_EGRESS);
+	udp_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
 	skel->bss->test_ingress = true;
-	udp_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
-			       REDIR_INGRESS);
+	udp_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
-- 
2.25.1

