Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A72D6C3D11
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCUVw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCUVwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4BB4AFF0;
        Tue, 21 Mar 2023 14:52:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so17334956pjb.0;
        Tue, 21 Mar 2023 14:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6bFJnafED6Q9SZ4mvXold+p94/0Uyx0b8mGj4R6+no=;
        b=cGabqS+qbZGH+f7IqHAUAbMcDGZ1KZh7LuuQ6xYf+/5Y4yuLl7ciWcbGGVzq8tk8a0
         cqU1FRD7aeoVOKT079F1HVTVMfrEMEPoxPCX4k1G04OeS0DQJ5v+kWjN6eEYRCuZR6Pn
         imHepfc8uURuRXDZDVmrJ6/dyzgApdsV7Py+7tqqTw9X1az+4eMU6LdUwf08c3BFVfH1
         zkJ6d36APVbZVl8b7soQZxP7SeC0dlX8T5kJvRBB0bLoYJier3KBYpodRliGx4hOcEfc
         aCLYlvqW0xPdiberHy1Hmysp0WQPa3Q3a0dtDMLUMBlSjr01hp7UKwJzhoef10nVzMlP
         iLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a6bFJnafED6Q9SZ4mvXold+p94/0Uyx0b8mGj4R6+no=;
        b=QxBWiMun5t57aEUAFTV5GJT7kHPJpk1+9GLkdfZCJJZltwrwEkP/xEgAP/d8NMMRxe
         7oS2BoDlM73JLsXA0YvP0K6AuutUyjssmp5kwErk76CGDUYl7K0h5feWTMtWFD6CZA0L
         qPflmaLx3eXKhM10zXTusVsEX+oq4nHFjG2r5LkgoMPqiFIBwlOz8O9vGLqHmLW75lH0
         W7xrxLS8vLPxuRIJA+L3lxiHdfLcLNIDwVTESmBl/Kn8pa+SEbogFY0T8NXo16qbVBIs
         rxfBENsgwyMBwI9AaTbk/CKAI6YK7TWsc69VHMBHQbe3OLXETv1jzbZRfMRBf8TfpeGZ
         OkUw==
X-Gm-Message-State: AO0yUKXIpkvmJnHwWkvPc0bXPVvffnXsCyzAYYbm+k3pnFmpIiW4cYbg
        rgZsV1lqDi/QmB3286JuqHE=
X-Google-Smtp-Source: AK7set9oro4/CVE6yt0zqiLBmlzZrsPoryMrOXODycjOXKFLRBV8dBoM7VSYzWg8ABVGtf0L0wz36g==
X-Received: by 2002:a05:6a20:4c29:b0:d7:4339:fac6 with SMTP id fm41-20020a056a204c2900b000d74339fac6mr2912784pzb.5.1679435552377;
        Tue, 21 Mar 2023 14:52:32 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:31 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 08/11] bpf: sockmap, pull socket helpers out of listen test for general use
Date:   Tue, 21 Mar 2023 14:52:09 -0700
Message-Id: <20230321215212.525630-9-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
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
index 000000000000..bff56844e745
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -0,0 +1,249 @@
+#ifndef __SOCKAMP_HELPERS__
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

