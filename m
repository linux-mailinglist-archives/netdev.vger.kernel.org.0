Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1689F6C2C0C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjCUIMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjCUIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:12:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ECF76B4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:12:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j125-20020a25d283000000b008f257b16d71so15434119ybg.15
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679386335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N02MtQpElRjAOVUgTTOXBlF9aZQ2nY+ViAJXGNwfrIo=;
        b=eJTPTYJ+wzWxB72jt9UaCPCC04hgVtuB+eFPHiQzKD1a8O+IbC8c9LF+rtIJIg2K6d
         beIlg4/ZI2NWZOgBII7bGSNyYoXBu18jIIQ6NwZk4IIbdyb8M/dvriNPZQo8DyIsXRTt
         CxaXBej0RTl//hIsAnzhN82tj+h1BHxL2GqUTs+mjl5WPRHRbZ0NmlqHp4YQ62L7zyTE
         2NS2vbXnS7FmRuGoBQbZGuTzTzHYWINGedroQoD4mEo+AgBTiVoAFwpTPBe6qOeVJGOJ
         w+YSjO4cjtSg41GWZZIOh572+E/gve9XSUbMP3lHvkBl6AstZTPPLfY8O3GIMDNMzZ36
         ksDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679386335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N02MtQpElRjAOVUgTTOXBlF9aZQ2nY+ViAJXGNwfrIo=;
        b=DC/9m+Vc9IShVi8Z3wKUvyeDp1uFdNw2dqWBrEraA+ERNQamoj5V4Dt+5G5BlU58oM
         dohceiGwBc57cMMjndslQmFW/QUIIeZYoIRlZVDySvOF2NcwsxJ3NgLDsml8lhRDLOoA
         ZMvipJNu6QGBfTdFUPBld+63aIwHKFdbOX8/jmO3krw2JkU848plxAnw8k05IRpLjGoz
         roITZT9ImYc8knFmL8v4l1WCpZpaDtWwyf6GQ1NvxUZmDEoaM7TNIwAIcwJXy3zpyCEL
         7bv+gQgTE+ZrX9XGNqjs/xKUf8ciy5dEiTjn/68n88sE9+VxJ7UwIncqUKYc8DhINcwE
         WBmQ==
X-Gm-Message-State: AAQBX9fqiVjqqYxb/ynkoCiJQ9sx3C371f4+OymHqjN0uS/d0sr/A+OQ
        DVcc7mdRC6cBI2Ig8eDmDTTtr07ZOjAK0ZI=
X-Google-Smtp-Source: AKy350aVd9+BQsmfwyqDYzq46/d2egfXJ6pneGnEZ6YRLhcZ4HKrl8KXeOwh4gmzDScagT4bssiXoUNSdUcYJ5w=
X-Received: from lixiaoyan1.bej.corp.google.com ([2401:fa00:44:10:da00:4d2e:dae2:452f])
 (user=lixiaoyan job=sendgmr) by 2002:a25:5188:0:b0:b35:91cc:9e29 with SMTP id
 f130-20020a255188000000b00b3591cc9e29mr624803ybb.5.1679386335445; Tue, 21 Mar
 2023 01:12:15 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:12:02 +0800
In-Reply-To: <20230321081202.2370275-1-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20230321081202.2370275-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230321081202.2370275-2-lixiaoyan@google.com>
Subject: [PATCH net-next 2/2] selftests/net: Add SHA256 computation over data
 sent in tcp_mmap
From:   Coco Li <lixiaoyan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Xiaoyan Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoyan Li <lixiaoyan@google.com>

Add option to compute and send SHA256 over data sent (-i).

This is to ensure the correctness of data received.
Data is randomly populated from /dev/urandom.

Tested:
./tcp_mmap -s -z -i
./tcp_mmap -z -H $ADDR -i
SHA256 is correct

./tcp_mmap -s -i
./tcp_mmap -H $ADDR -i
SHA256 is correct

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 tools/testing/selftests/net/Makefile   |   2 +-
 tools/testing/selftests/net/tcp_mmap.c | 102 ++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index e57750e44f71..1de34ec99290 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -89,7 +89,7 @@ TEST_FILES := settings
 include ../lib.mk
 
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
-$(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
+$(OUTPUT)/tcp_mmap: LDLIBS += -lpthread -lcrypto
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
 $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
 
diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 46a02bbd31d0..607cc9ad8d1b 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -66,11 +66,16 @@
 #include <poll.h>
 #include <linux/tcp.h>
 #include <assert.h>
+#include <openssl/pem.h>
 
 #ifndef MSG_ZEROCOPY
 #define MSG_ZEROCOPY    0x4000000
 #endif
 
+#ifndef min
+#define min(a, b)  ((a) < (b) ? (a) : (b))
+#endif
+
 #define FILE_SZ (1ULL << 35)
 static int cfg_family = AF_INET6;
 static socklen_t cfg_alen = sizeof(struct sockaddr_in6);
@@ -81,12 +86,14 @@ static int sndbuf; /* Default: autotuning.  Can be set with -w <integer> option
 static int zflg; /* zero copy option. (MSG_ZEROCOPY for sender, mmap() for receiver */
 static int xflg; /* hash received data (simple xor) (-h option) */
 static int keepflag; /* -k option: receiver shall keep all received file in memory (no munmap() calls) */
+static int integrity; /* -i option: sender and receiver compute sha256 over the data.*/
 
 static size_t chunk_size  = 512*1024;
 
 static size_t map_align;
 
 unsigned long htotal;
+unsigned int digest_len;
 
 static inline void prefetch(const void *x)
 {
@@ -148,12 +155,14 @@ static void *mmap_large_buffer(size_t need, size_t *allocated)
 
 void *child_thread(void *arg)
 {
+	unsigned char digest[SHA256_DIGEST_LENGTH];
 	unsigned long total_mmap = 0, total = 0;
 	struct tcp_zerocopy_receive zc;
+	unsigned char *buffer = NULL;
 	unsigned long delta_usec;
+	EVP_MD_CTX *ctx = NULL;
 	int flags = MAP_SHARED;
 	struct timeval t0, t1;
-	char *buffer = NULL;
 	void *raddr = NULL;
 	void *addr = NULL;
 	double throughput;
@@ -180,6 +189,14 @@ void *child_thread(void *arg)
 			addr = ALIGN_PTR_UP(raddr, map_align);
 		}
 	}
+	if (integrity) {
+		ctx = EVP_MD_CTX_new();
+		if (!ctx) {
+			perror("cannot enable SHA computing");
+			goto error;
+		}
+		EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
+	}
 	while (1) {
 		struct pollfd pfd = { .fd = fd, .events = POLLIN, };
 		int sub;
@@ -191,7 +208,7 @@ void *child_thread(void *arg)
 
 			memset(&zc, 0, sizeof(zc));
 			zc.address = (__u64)((unsigned long)addr);
-			zc.length = chunk_size;
+			zc.length = min(chunk_size, FILE_SZ - lu);
 
 			res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
 					 &zc, &zc_len);
@@ -200,6 +217,8 @@ void *child_thread(void *arg)
 
 			if (zc.length) {
 				assert(zc.length <= chunk_size);
+				if (integrity)
+					EVP_DigestUpdate(ctx, addr, zc.length);
 				total_mmap += zc.length;
 				if (xflg)
 					hash_zone(addr, zc.length);
@@ -211,22 +230,30 @@ void *child_thread(void *arg)
 			}
 			if (zc.recv_skip_hint) {
 				assert(zc.recv_skip_hint <= chunk_size);
-				lu = read(fd, buffer, zc.recv_skip_hint);
+				lu = read(fd, buffer, min(zc.recv_skip_hint,
+							  FILE_SZ - total));
 				if (lu > 0) {
+					if (integrity)
+						EVP_DigestUpdate(ctx, buffer, lu);
 					if (xflg)
 						hash_zone(buffer, lu);
 					total += lu;
 				}
+				if (lu == 0)
+					goto end;
 			}
 			continue;
 		}
 		sub = 0;
 		while (sub < chunk_size) {
-			lu = read(fd, buffer + sub, chunk_size - sub);
+			lu = read(fd, buffer + sub, min(chunk_size - sub,
+							FILE_SZ - total));
 			if (lu == 0)
 				goto end;
 			if (lu < 0)
 				break;
+			if (integrity)
+				EVP_DigestUpdate(ctx, buffer + sub, lu);
 			if (xflg)
 				hash_zone(buffer + sub, lu);
 			total += lu;
@@ -237,6 +264,20 @@ void *child_thread(void *arg)
 	gettimeofday(&t1, NULL);
 	delta_usec = (t1.tv_sec - t0.tv_sec) * 1000000 + t1.tv_usec - t0.tv_usec;
 
+	if (integrity) {
+		fcntl(fd, F_SETFL, 0);
+		EVP_DigestFinal_ex(ctx, digest, &digest_len);
+		lu = read(fd, buffer, SHA256_DIGEST_LENGTH);
+		if (lu != SHA256_DIGEST_LENGTH)
+			perror("Error: Cannot read SHA256\n");
+
+		if (memcmp(digest, buffer,
+			   SHA256_DIGEST_LENGTH))
+			fprintf(stderr, "Error: SHA256 of the data is not right\n");
+		else
+			printf("\nSHA256 is correct\n");
+	}
+
 	throughput = 0;
 	if (delta_usec)
 		throughput = total * 8.0 / (double)delta_usec / 1000.0;
@@ -368,19 +409,38 @@ static unsigned long default_huge_page_size(void)
 	return hps;
 }
 
+static void randomize(void *target, size_t count)
+{
+	static int urandom = -1;
+	ssize_t got;
+
+	urandom = open("/dev/urandom", O_RDONLY);
+	if (urandom < 0) {
+		perror("open /dev/urandom");
+		exit(1);
+	}
+	got = read(urandom, target, count);
+	if (got != count) {
+		perror("read /dev/urandom");
+		exit(1);
+	}
+}
+
 int main(int argc, char *argv[])
 {
+	unsigned char digest[SHA256_DIGEST_LENGTH];
 	struct sockaddr_storage listenaddr, addr;
 	unsigned int max_pacing_rate = 0;
+	EVP_MD_CTX *ctx = NULL;
+	unsigned char *buffer;
 	uint64_t total = 0;
 	char *host = NULL;
 	int fd, c, on = 1;
 	size_t buffer_sz;
-	char *buffer;
 	int sflg = 0;
 	int mss = 0;
 
-	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:")) != -1) {
+	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:i")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
@@ -426,6 +486,9 @@ int main(int argc, char *argv[])
 		case 'a':
 			map_align = atol(optarg);
 			break;
+		case 'i':
+			integrity = 1;
+			break;
 		default:
 			exit(1);
 		}
@@ -468,7 +531,7 @@ int main(int argc, char *argv[])
 	}
 
 	buffer = mmap_large_buffer(chunk_size, &buffer_sz);
-	if (buffer == (char *)-1) {
+	if (buffer == (unsigned char *)-1) {
 		perror("mmap");
 		exit(1);
 	}
@@ -501,17 +564,34 @@ int main(int argc, char *argv[])
 		perror("setsockopt SO_ZEROCOPY, (-z option disabled)");
 		zflg = 0;
 	}
+	if (integrity) {
+		randomize(buffer, buffer_sz);
+		ctx = EVP_MD_CTX_new();
+		if (!ctx) {
+			perror("cannot enable SHA computing");
+			exit(1);
+		}
+		EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
+	}
 	while (total < FILE_SZ) {
+		size_t offset = total % chunk_size;
 		int64_t wr = FILE_SZ - total;
 
-		if (wr > chunk_size)
-			wr = chunk_size;
-		/* Note : we just want to fill the pipe with 0 bytes */
-		wr = send(fd, buffer, (size_t)wr, zflg ? MSG_ZEROCOPY : 0);
+		if (wr > chunk_size - offset)
+			wr = chunk_size - offset;
+		/* Note : we just want to fill the pipe with random bytes */
+		wr = send(fd, buffer + offset,
+			  (size_t)wr, zflg ? MSG_ZEROCOPY : 0);
 		if (wr <= 0)
 			break;
+		if (integrity)
+			EVP_DigestUpdate(ctx, buffer + offset, wr);
 		total += wr;
 	}
+	if (integrity && total == FILE_SZ) {
+		EVP_DigestFinal_ex(ctx, digest, &digest_len);
+		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
+	}
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;
-- 
2.40.0.rc1.284.g88254d51c5-goog

