Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C0B6D8A5C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbjDEWKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbjDEWJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660F283D0;
        Wed,  5 Apr 2023 15:09:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f22so31620728plr.0;
        Wed, 05 Apr 2023 15:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732561; x=1683324561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TaDLCIXSz9eYXTku+ilKJmltzAIAJaTUBVD0OtqxmY=;
        b=RaF0MHZzlPu4UZnvmnfSfj+4613ZjD+AcIFOqy5Z+8+0pftdTAXIexMYfLKS7csQek
         /7/l99Z3w6T245u0qGen4ziJlalMAtq5kMxU8hGtNgBc5k04gAlsI2Z5q8DVitcVmPQt
         sIKxnr6I1zgEypi96h77iOKjrB7wTj+QIKedgDWcwLRBpGa50uRgXOAR/j7km3RpHiNx
         Jt8S2De49NVHsEo8/4K7MdZNFbHqyASXp6pFUPF4T5WepAtRQGngwH4hHJPHsNJ2k8EF
         Rlip4FIE48p/6mKlNUV8+WNlc5iS9+tLW6Z1KIMgLJSlYU/+bum+5Eceujym9LYDiO90
         MBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732561; x=1683324561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+TaDLCIXSz9eYXTku+ilKJmltzAIAJaTUBVD0OtqxmY=;
        b=RJ/Im0AGldRqVBkuDZuMjCe0c17gSZ0HFvXnNKd5eKNFQVGtpSv+AOnvc6muMTjmYj
         oFw8RvoDiS46Jmvrrv24X2sr1ursSUZIZKm/6OU0UM3IGFN+tc6PndybevlyBvpVlR44
         QJZVUpd3Lj+OAOCFWMzhTRfxvDxLjisVjrPsimcqBoDDcr04fZeNiLLdX/DPN93gC+BG
         NfLXTTs1fTNyHd8BJuvVYd4Gnxaf7h/XIsR4ZXMzcr50zlVbwnArn1LYZu4Oy63J/zZj
         SYtcpXkdj2jy32OIXIyhbVWxC/E9L7KegePZrRyYx8nWVlMi7zN36mKEjZXrzxy7FwNI
         IQgw==
X-Gm-Message-State: AAQBX9cXl6Qf73FpUuxWW7G5K07Sw5AN+ZVqq77G5XyYdVsUsijaMx22
        X+qe9cavknFzG3oKhcecPGY=
X-Google-Smtp-Source: AKy350Z5M3GnU/iE6p374KHgZmMA6usvoDwlMFTaed4FUjJUAnWNaJakLRWYoOeTAxQtdJKZdvw/4A==
X-Received: by 2002:a17:90b:38cc:b0:23d:35c9:bf1c with SMTP id nn12-20020a17090b38cc00b0023d35c9bf1cmr8589254pjb.16.1680732561306;
        Wed, 05 Apr 2023 15:09:21 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:20 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 09/12] bpf: sockmap, build helper to create connected socket pair
Date:   Wed,  5 Apr 2023 15:09:01 -0700
Message-Id: <20230405220904.153149-10-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common operation for testing is to spin up a pair of sockets that are
connected. Then we can use these to run specific tests that need to
send data, check BPF programs and so on.

The sockmap_listen programs already have this logic lets move it into
the new sockmap_helpers header file for general use.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../bpf/prog_tests/sockmap_helpers.h          | 125 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 107 +--------------
 2 files changed, 130 insertions(+), 102 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
index bff56844e745..54e3a019ba72 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -246,4 +246,129 @@ static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
 	return (struct sockaddr *)ss;
 }
 
+static inline int add_to_sockmap(int sock_mapfd, int fd1, int fd2)
+{
+	u64 value;
+	u32 key;
+	int err;
+
+	key = 0;
+	value = fd1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		return err;
+
+	key = 1;
+	value = fd2;
+	return xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+}
+
+static inline int create_socket_pairs(int s, int family, int sotype,
+				      int *c0, int *c1, int *p0, int *p1)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err = 0;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		return err;
+
+	*c0 = xsocket(family, sotype, 0);
+	if (*c0 < 0)
+		return errno;
+	err = xconnect(*c0, sockaddr(&addr), len);
+	if (err) {
+		err = errno;
+		goto close_cli0;
+	}
+
+	*p0 = xaccept_nonblock(s, NULL, NULL);
+	if (*p0 < 0) {
+		err = errno;
+		goto close_cli0;
+	}
+
+	*c1 = xsocket(family, sotype, 0);
+	if (*c1 < 0) {
+		err = errno;
+		goto close_peer0;
+	}
+	err = xconnect(*c1, sockaddr(&addr), len);
+	if (err) {
+		err = errno;
+		goto close_cli1;
+	}
+
+	*p1 = xaccept_nonblock(s, NULL, NULL);
+	if (*p1 < 0) {
+		err = errno;
+		goto close_peer1;
+	}
+	return err;
+close_peer1:
+	close(*p1);
+close_cli1:
+	close(*c1);
+close_peer0:
+	close(*p0);
+close_cli0:
+	close(*c0);
+	return err;
+}
+
+static inline int enable_reuseport(int s, int progfd)
+{
+	int err, one = 1;
+
+	err = xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+	if (err)
+		return -1;
+	err = xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF, &progfd,
+			  sizeof(progfd));
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static inline int socket_loopback_reuseport(int family, int sotype, int progfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err, s;
+
+	init_addr_loopback(family, &addr, &len);
+
+	s = xsocket(family, sotype, 0);
+	if (s == -1)
+		return -1;
+
+	if (progfd >= 0)
+		enable_reuseport(s, progfd);
+
+	err = xbind(s, sockaddr(&addr), len);
+	if (err)
+		goto close;
+
+	if (sotype & SOCK_DGRAM)
+		return s;
+
+	err = xlisten(s, SOMAXCONN);
+	if (err)
+		goto close;
+
+	return s;
+close:
+	xclose(s);
+	return -1;
+}
+
+static inline int socket_loopback(int family, int sotype)
+{
+	return socket_loopback_reuseport(family, sotype, -1);
+}
+
+
 #endif // __SOCKMAP_HELPERS__
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 0f0cddd4e15e..f3913ba9e899 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -28,58 +28,6 @@
 
 #include "sockmap_helpers.h"
 
-static int enable_reuseport(int s, int progfd)
-{
-	int err, one = 1;
-
-	err = xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
-	if (err)
-		return -1;
-	err = xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF, &progfd,
-			  sizeof(progfd));
-	if (err)
-		return -1;
-
-	return 0;
-}
-
-static int socket_loopback_reuseport(int family, int sotype, int progfd)
-{
-	struct sockaddr_storage addr;
-	socklen_t len;
-	int err, s;
-
-	init_addr_loopback(family, &addr, &len);
-
-	s = xsocket(family, sotype, 0);
-	if (s == -1)
-		return -1;
-
-	if (progfd >= 0)
-		enable_reuseport(s, progfd);
-
-	err = xbind(s, sockaddr(&addr), len);
-	if (err)
-		goto close;
-
-	if (sotype & SOCK_DGRAM)
-		return s;
-
-	err = xlisten(s, SOMAXCONN);
-	if (err)
-		goto close;
-
-	return s;
-close:
-	xclose(s);
-	return -1;
-}
-
-static int socket_loopback(int family, int sotype)
-{
-	return socket_loopback_reuseport(family, sotype, -1);
-}
-
 static void test_insert_invalid(struct test_sockmap_listen *skel __always_unused,
 				int family, int sotype, int mapfd)
 {
@@ -722,31 +670,12 @@ static const char *redir_mode_str(enum redir_mode mode)
 	}
 }
 
-static int add_to_sockmap(int sock_mapfd, int fd1, int fd2)
-{
-	u64 value;
-	u32 key;
-	int err;
-
-	key = 0;
-	value = fd1;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		return err;
-
-	key = 1;
-	value = fd2;
-	return xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-}
-
 static void redir_to_connected(int family, int sotype, int sock_mapfd,
 			       int verd_mapfd, enum redir_mode mode)
 {
 	const char *log_prefix = redir_mode_str(mode);
-	struct sockaddr_storage addr;
 	int s, c0, c1, p0, p1;
 	unsigned int pass;
-	socklen_t len;
 	int err, n;
 	u32 key;
 	char b;
@@ -757,36 +686,13 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (s < 0)
 		return;
 
-	len = sizeof(addr);
-	err = xgetsockname(s, sockaddr(&addr), &len);
+	err = create_socket_pairs(s, family, sotype, &c0, &c1, &p0, &p1);
 	if (err)
 		goto close_srv;
 
-	c0 = xsocket(family, sotype, 0);
-	if (c0 < 0)
-		goto close_srv;
-	err = xconnect(c0, sockaddr(&addr), len);
-	if (err)
-		goto close_cli0;
-
-	p0 = xaccept_nonblock(s, NULL, NULL);
-	if (p0 < 0)
-		goto close_cli0;
-
-	c1 = xsocket(family, sotype, 0);
-	if (c1 < 0)
-		goto close_peer0;
-	err = xconnect(c1, sockaddr(&addr), len);
-	if (err)
-		goto close_cli1;
-
-	p1 = xaccept_nonblock(s, NULL, NULL);
-	if (p1 < 0)
-		goto close_cli1;
-
 	err = add_to_sockmap(sock_mapfd, p0, p1);
 	if (err)
-		goto close_peer1;
+		goto close;
 
 	n = write(mode == REDIR_INGRESS ? c1 : p1, "a", 1);
 	if (n < 0)
@@ -794,12 +700,12 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (n == 0)
 		FAIL("%s: incomplete write", log_prefix);
 	if (n < 1)
-		goto close_peer1;
+		goto close;
 
 	key = SK_PASS;
 	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
 	if (err)
-		goto close_peer1;
+		goto close;
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 	n = recv_timeout(c0, &b, 1, 0, IO_TIMEOUT_SEC);
@@ -808,13 +714,10 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (n == 0)
 		FAIL("%s: incomplete recv", log_prefix);
 
-close_peer1:
+close:
 	xclose(p1);
-close_cli1:
 	xclose(c1);
-close_peer0:
 	xclose(p0);
-close_cli0:
 	xclose(c0);
 close_srv:
 	xclose(s);
-- 
2.33.0

