Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515856F47BD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbjEBPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbjEBPwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB52E4D;
        Tue,  2 May 2023 08:52:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a66e7a52d3so29324125ad.0;
        Tue, 02 May 2023 08:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042738; x=1685634738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7gtROIXGJImMpoMgkBcOZvu2qnDKSqHKCFuHuD2bAE=;
        b=PCga2cX3QcF3WiIp1cRni3MmFZiBmtjKqk3pFEIAu/w0tJfsfMv0ArMJIRgcosA1ee
         b4prWoduss6kab5i29vbLLFuRRoeceAoxwim2YuXF3YhyeNtwRXAn1hmzXiKeRbZbxPN
         XpIKB+45bwXAsblQ5Ls9VfcIxYUY9DeWVYx5/yqrJGLxtbF7gqfwq7t75lZ4bqIMyeID
         15847pPTdOWbhpT8YOjt5ToSXUaPDGd1aQBfFSXJ6eRApGL56asuyPLYJgv8U8/nsl9i
         FHcQEdZ/KUQUhl+4KtFH+CUuKqWtldv+wwE6GjyURMLMVESPFDxSRBsCwaAImYv+jK2y
         rNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042738; x=1685634738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7gtROIXGJImMpoMgkBcOZvu2qnDKSqHKCFuHuD2bAE=;
        b=cQaL2GKTa/xe3J8MuRiXIQ0oz20Rz1zqVHvkvF3b2hIPHK3lLWN4y/0AeQMtOpwOGs
         OvG6nNjMuAXA9A0vhnM3shDET1+QzPeFkr5F5RRwU1lpIXEfJd4sEtrAeceGm0fg0oRK
         YomO+EZ14pgJa1W6VeeNppM0eyFt/0Ph7u7AeyDzCT6gUA8nl89by7FT/HtI96dGfr9O
         sysN8T24xKEg+QiiTEiBBqqJFyPFBvyYB3UnU0CD0thmDx3otF6KA3ex14V15Ih+Be6D
         uFg8JgIrN9WHK5WGd0T3e4vYTSdXHVFIPZTEqiQsaJWibZY1CU36qfljxgoyW/nq8GpS
         bRdA==
X-Gm-Message-State: AC+VfDxiz3zNw5UQtkff0Gh86HWFy0HZIVM6jBVuv5PhKWy5POq11e+P
        NIvLXxHo8ITnKv/c3V2hBJ0=
X-Google-Smtp-Source: ACHHUZ4TTcZq42crHLPs6/N+gAvmGxbs4fnAbnWMZmoe4yubkbmjq8r83xRwanOykH8mBu4BGvxPEA==
X-Received: by 2002:a17:902:9347:b0:1a9:20ea:f49b with SMTP id g7-20020a170902934700b001a920eaf49bmr16189736plp.24.1683042737995;
        Tue, 02 May 2023 08:52:17 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:17 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 09/13] bpf: sockmap, pull socket helpers out of listen test for general use
Date:   Tue,  2 May 2023 08:51:55 -0700
Message-Id: <20230502155159.305437-10-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change here we merely pull the helpers in sockmap_listen.c
into a header file so we can use these in other programs. The tests we
are about to add aren't really _listen tests so doesn't make sense
to add them here.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../bpf/prog_tests/sockmap_helpers.h          | 249 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 245 +----------------
 2 files changed, 250 insertions(+), 244 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
new file mode 100644
index 000000000000..08b7b76e4c90
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -0,0 +1,249 @@
+#ifndef __SOCKMAP_HELPERS__
+#define __SOCKMAP_HELPERS__
+
+#define IO_TIMEOUT_SEC 30
+#define MAX_STRERR_LEN 256
+#define MAX_TEST_NAME 80
+
+#define __always_unused	__attribute__((__unused__))
+
+#define _FAIL(errnum, fmt...)                                                  \
+	({                                                                     \
+		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
+		CHECK_FAIL(true);                                              \
+	})
+#define FAIL(fmt...) _FAIL(0, fmt)
+#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
+#define FAIL_LIBBPF(err, msg)                                                  \
+	({                                                                     \
+		char __buf[MAX_STRERR_LEN];                                    \
+		libbpf_strerror((err), __buf, sizeof(__buf));                  \
+		FAIL("%s: %s", (msg), __buf);                                  \
+	})
+
+/* Wrappers that fail the test on error and report it. */
+
+#define xaccept_nonblock(fd, addr, len)                                        \
+	({                                                                     \
+		int __ret =                                                    \
+			accept_timeout((fd), (addr), (len), IO_TIMEOUT_SEC);   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("accept");                                  \
+		__ret;                                                         \
+	})
+
+#define xbind(fd, addr, len)                                                   \
+	({                                                                     \
+		int __ret = bind((fd), (addr), (len));                         \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("bind");                                    \
+		__ret;                                                         \
+	})
+
+#define xclose(fd)                                                             \
+	({                                                                     \
+		int __ret = close((fd));                                       \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("close");                                   \
+		__ret;                                                         \
+	})
+
+#define xconnect(fd, addr, len)                                                \
+	({                                                                     \
+		int __ret = connect((fd), (addr), (len));                      \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("connect");                                 \
+		__ret;                                                         \
+	})
+
+#define xgetsockname(fd, addr, len)                                            \
+	({                                                                     \
+		int __ret = getsockname((fd), (addr), (len));                  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("getsockname");                             \
+		__ret;                                                         \
+	})
+
+#define xgetsockopt(fd, level, name, val, len)                                 \
+	({                                                                     \
+		int __ret = getsockopt((fd), (level), (name), (val), (len));   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("getsockopt(" #name ")");                   \
+		__ret;                                                         \
+	})
+
+#define xlisten(fd, backlog)                                                   \
+	({                                                                     \
+		int __ret = listen((fd), (backlog));                           \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("listen");                                  \
+		__ret;                                                         \
+	})
+
+#define xsetsockopt(fd, level, name, val, len)                                 \
+	({                                                                     \
+		int __ret = setsockopt((fd), (level), (name), (val), (len));   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("setsockopt(" #name ")");                   \
+		__ret;                                                         \
+	})
+
+#define xsend(fd, buf, len, flags)                                             \
+	({                                                                     \
+		ssize_t __ret = send((fd), (buf), (len), (flags));             \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("send");                                    \
+		__ret;                                                         \
+	})
+
+#define xrecv_nonblock(fd, buf, len, flags)                                    \
+	({                                                                     \
+		ssize_t __ret = recv_timeout((fd), (buf), (len), (flags),      \
+					     IO_TIMEOUT_SEC);                  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("recv");                                    \
+		__ret;                                                         \
+	})
+
+#define xsocket(family, sotype, flags)                                         \
+	({                                                                     \
+		int __ret = socket(family, sotype, flags);                     \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("socket");                                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_delete_elem(fd, key)                                          \
+	({                                                                     \
+		int __ret = bpf_map_delete_elem((fd), (key));                  \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("map_delete");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_lookup_elem(fd, key, val)                                     \
+	({                                                                     \
+		int __ret = bpf_map_lookup_elem((fd), (key), (val));           \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("map_lookup");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_update_elem(fd, key, val, flags)                              \
+	({                                                                     \
+		int __ret = bpf_map_update_elem((fd), (key), (val), (flags));  \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("map_update");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_attach(prog, target, type, flags)                            \
+	({                                                                     \
+		int __ret =                                                    \
+			bpf_prog_attach((prog), (target), (type), (flags));    \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("prog_attach(" #type ")");                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_detach2(prog, target, type)                                  \
+	({                                                                     \
+		int __ret = bpf_prog_detach2((prog), (target), (type));        \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("prog_detach2(" #type ")");                 \
+		__ret;                                                         \
+	})
+
+#define xpthread_create(thread, attr, func, arg)                               \
+	({                                                                     \
+		int __ret = pthread_create((thread), (attr), (func), (arg));   \
+		errno = __ret;                                                 \
+		if (__ret)                                                     \
+			FAIL_ERRNO("pthread_create");                          \
+		__ret;                                                         \
+	})
+
+#define xpthread_join(thread, retval)                                          \
+	({                                                                     \
+		int __ret = pthread_join((thread), (retval));                  \
+		errno = __ret;                                                 \
+		if (__ret)                                                     \
+			FAIL_ERRNO("pthread_join");                            \
+		__ret;                                                         \
+	})
+
+static inline int poll_read(int fd, unsigned int timeout_sec)
+{
+	struct timeval timeout = { .tv_sec = timeout_sec };
+	fd_set rfds;
+	int r;
+
+	FD_ZERO(&rfds);
+	FD_SET(fd, &rfds);
+
+	r = select(fd + 1, &rfds, NULL, NULL, &timeout);
+	if (r == 0)
+		errno = ETIME;
+
+	return r == 1 ? 0 : -1;
+}
+
+static inline int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
+				 unsigned int timeout_sec)
+{
+	if (poll_read(fd, timeout_sec))
+		return -1;
+
+	return accept(fd, addr, len);
+}
+
+static inline int recv_timeout(int fd, void *buf, size_t len, int flags,
+			       unsigned int timeout_sec)
+{
+	if (poll_read(fd, timeout_sec))
+		return -1;
+
+	return recv(fd, buf, len, flags);
+}
+
+static inline void init_addr_loopback4(struct sockaddr_storage *ss, socklen_t *len)
+{
+	struct sockaddr_in *addr4 = memset(ss, 0, sizeof(*ss));
+
+	addr4->sin_family = AF_INET;
+	addr4->sin_port = 0;
+	addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	*len = sizeof(*addr4);
+}
+
+static inline void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
+{
+	struct sockaddr_in6 *addr6 = memset(ss, 0, sizeof(*ss));
+
+	addr6->sin6_family = AF_INET6;
+	addr6->sin6_port = 0;
+	addr6->sin6_addr = in6addr_loopback;
+	*len = sizeof(*addr6);
+}
+
+static inline void init_addr_loopback(int family, struct sockaddr_storage *ss,
+			       socklen_t *len)
+{
+	switch (family) {
+	case AF_INET:
+		init_addr_loopback4(ss, len);
+		return;
+	case AF_INET6:
+		init_addr_loopback6(ss, len);
+		return;
+	default:
+		FAIL("unsupported address family %d", family);
+	}
+}
+
+static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
+{
+	return (struct sockaddr *)ss;
+}
+
+#endif // __SOCKMAP_HELPERS__
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 567e07c19ecc..0f0cddd4e15e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -26,250 +26,7 @@
 #include "test_progs.h"
 #include "test_sockmap_listen.skel.h"
 
-#define IO_TIMEOUT_SEC 30
-#define MAX_STRERR_LEN 256
-#define MAX_TEST_NAME 80
-
-#define __always_unused	__attribute__((__unused__))
-
-#define _FAIL(errnum, fmt...)                                                  \
-	({                                                                     \
-		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
-		CHECK_FAIL(true);                                              \
-	})
-#define FAIL(fmt...) _FAIL(0, fmt)
-#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
-#define FAIL_LIBBPF(err, msg)                                                  \
-	({                                                                     \
-		char __buf[MAX_STRERR_LEN];                                    \
-		libbpf_strerror((err), __buf, sizeof(__buf));                  \
-		FAIL("%s: %s", (msg), __buf);                                  \
-	})
-
-/* Wrappers that fail the test on error and report it. */
-
-#define xaccept_nonblock(fd, addr, len)                                        \
-	({                                                                     \
-		int __ret =                                                    \
-			accept_timeout((fd), (addr), (len), IO_TIMEOUT_SEC);   \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("accept");                                  \
-		__ret;                                                         \
-	})
-
-#define xbind(fd, addr, len)                                                   \
-	({                                                                     \
-		int __ret = bind((fd), (addr), (len));                         \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("bind");                                    \
-		__ret;                                                         \
-	})
-
-#define xclose(fd)                                                             \
-	({                                                                     \
-		int __ret = close((fd));                                       \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("close");                                   \
-		__ret;                                                         \
-	})
-
-#define xconnect(fd, addr, len)                                                \
-	({                                                                     \
-		int __ret = connect((fd), (addr), (len));                      \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("connect");                                 \
-		__ret;                                                         \
-	})
-
-#define xgetsockname(fd, addr, len)                                            \
-	({                                                                     \
-		int __ret = getsockname((fd), (addr), (len));                  \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("getsockname");                             \
-		__ret;                                                         \
-	})
-
-#define xgetsockopt(fd, level, name, val, len)                                 \
-	({                                                                     \
-		int __ret = getsockopt((fd), (level), (name), (val), (len));   \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("getsockopt(" #name ")");                   \
-		__ret;                                                         \
-	})
-
-#define xlisten(fd, backlog)                                                   \
-	({                                                                     \
-		int __ret = listen((fd), (backlog));                           \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("listen");                                  \
-		__ret;                                                         \
-	})
-
-#define xsetsockopt(fd, level, name, val, len)                                 \
-	({                                                                     \
-		int __ret = setsockopt((fd), (level), (name), (val), (len));   \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("setsockopt(" #name ")");                   \
-		__ret;                                                         \
-	})
-
-#define xsend(fd, buf, len, flags)                                             \
-	({                                                                     \
-		ssize_t __ret = send((fd), (buf), (len), (flags));             \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("send");                                    \
-		__ret;                                                         \
-	})
-
-#define xrecv_nonblock(fd, buf, len, flags)                                    \
-	({                                                                     \
-		ssize_t __ret = recv_timeout((fd), (buf), (len), (flags),      \
-					     IO_TIMEOUT_SEC);                  \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("recv");                                    \
-		__ret;                                                         \
-	})
-
-#define xsocket(family, sotype, flags)                                         \
-	({                                                                     \
-		int __ret = socket(family, sotype, flags);                     \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("socket");                                  \
-		__ret;                                                         \
-	})
-
-#define xbpf_map_delete_elem(fd, key)                                          \
-	({                                                                     \
-		int __ret = bpf_map_delete_elem((fd), (key));                  \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("map_delete");                              \
-		__ret;                                                         \
-	})
-
-#define xbpf_map_lookup_elem(fd, key, val)                                     \
-	({                                                                     \
-		int __ret = bpf_map_lookup_elem((fd), (key), (val));           \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("map_lookup");                              \
-		__ret;                                                         \
-	})
-
-#define xbpf_map_update_elem(fd, key, val, flags)                              \
-	({                                                                     \
-		int __ret = bpf_map_update_elem((fd), (key), (val), (flags));  \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("map_update");                              \
-		__ret;                                                         \
-	})
-
-#define xbpf_prog_attach(prog, target, type, flags)                            \
-	({                                                                     \
-		int __ret =                                                    \
-			bpf_prog_attach((prog), (target), (type), (flags));    \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("prog_attach(" #type ")");                  \
-		__ret;                                                         \
-	})
-
-#define xbpf_prog_detach2(prog, target, type)                                  \
-	({                                                                     \
-		int __ret = bpf_prog_detach2((prog), (target), (type));        \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("prog_detach2(" #type ")");                 \
-		__ret;                                                         \
-	})
-
-#define xpthread_create(thread, attr, func, arg)                               \
-	({                                                                     \
-		int __ret = pthread_create((thread), (attr), (func), (arg));   \
-		errno = __ret;                                                 \
-		if (__ret)                                                     \
-			FAIL_ERRNO("pthread_create");                          \
-		__ret;                                                         \
-	})
-
-#define xpthread_join(thread, retval)                                          \
-	({                                                                     \
-		int __ret = pthread_join((thread), (retval));                  \
-		errno = __ret;                                                 \
-		if (__ret)                                                     \
-			FAIL_ERRNO("pthread_join");                            \
-		__ret;                                                         \
-	})
-
-static int poll_read(int fd, unsigned int timeout_sec)
-{
-	struct timeval timeout = { .tv_sec = timeout_sec };
-	fd_set rfds;
-	int r;
-
-	FD_ZERO(&rfds);
-	FD_SET(fd, &rfds);
-
-	r = select(fd + 1, &rfds, NULL, NULL, &timeout);
-	if (r == 0)
-		errno = ETIME;
-
-	return r == 1 ? 0 : -1;
-}
-
-static int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
-			  unsigned int timeout_sec)
-{
-	if (poll_read(fd, timeout_sec))
-		return -1;
-
-	return accept(fd, addr, len);
-}
-
-static int recv_timeout(int fd, void *buf, size_t len, int flags,
-			unsigned int timeout_sec)
-{
-	if (poll_read(fd, timeout_sec))
-		return -1;
-
-	return recv(fd, buf, len, flags);
-}
-
-static void init_addr_loopback4(struct sockaddr_storage *ss, socklen_t *len)
-{
-	struct sockaddr_in *addr4 = memset(ss, 0, sizeof(*ss));
-
-	addr4->sin_family = AF_INET;
-	addr4->sin_port = 0;
-	addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
-	*len = sizeof(*addr4);
-}
-
-static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
-{
-	struct sockaddr_in6 *addr6 = memset(ss, 0, sizeof(*ss));
-
-	addr6->sin6_family = AF_INET6;
-	addr6->sin6_port = 0;
-	addr6->sin6_addr = in6addr_loopback;
-	*len = sizeof(*addr6);
-}
-
-static void init_addr_loopback(int family, struct sockaddr_storage *ss,
-			       socklen_t *len)
-{
-	switch (family) {
-	case AF_INET:
-		init_addr_loopback4(ss, len);
-		return;
-	case AF_INET6:
-		init_addr_loopback6(ss, len);
-		return;
-	default:
-		FAIL("unsupported address family %d", family);
-	}
-}
-
-static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
-{
-	return (struct sockaddr *)ss;
-}
+#include "sockmap_helpers.h"
 
 static int enable_reuseport(int s, int progfd)
 {
-- 
2.33.0

