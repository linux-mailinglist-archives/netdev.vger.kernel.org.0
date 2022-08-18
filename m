Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F675989E6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343873AbiHRRD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345327AbiHRRCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:02:02 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094CFC12C3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:01:00 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id s23so1125872wmj.4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vGJ3kSV/z/TY65CJkdoX1ty3nkbmUWg0sp73bEAPcbA=;
        b=PAKnbCxzEPjKKW8rQZu8e88trGKV/fqMnjKHbjjMMqV3BcNsDJXiKH2AXuI8XOFruU
         iRCafCjXQxnb0+POUBqsDg63j21LCUIfjyUij2EiD45SlF5IcZZAwvzzcrBIYZZIgvTc
         AalNfgI5T7J9WSZ2sbEqK5iW/qjLM28JisLtLK4VgHjR2tHgkUdZ0tm+moXKCMg3Te4c
         X7VTqIyCgZP5GHTO63jHjyjfzVh9AJIdBM+bhLiMRbXDUh/PXdawezqqJ+FxtqW6lvo9
         mrsVrMg1x448DKOsyNdFRqL/bIEIMGbeQhOZ8ZtxW6j4uO6+Tz2cQCSBF/WlEAjRzmd4
         WJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vGJ3kSV/z/TY65CJkdoX1ty3nkbmUWg0sp73bEAPcbA=;
        b=aPf5IUrJucoI4wS/01Yfx98aApOmuqaToturuWL6rTlmiBwsBCPf1aTwbtE/5O6cmo
         0c1lKJXWNaAHrBps8vCJFtjowj6EH74BCh1wYVXl4RzNAUdMmTsIbw2/N93JJDpsObzm
         KjAT+2qhc3fIsP5mUg2zEYvbZYXYrCJDFyzlcWbd1AAei0aDoml68IdbZprA6iW6vD+k
         rTyyhsIRjyEjuqSmNq6ldiFH4rTi4N49X0Oh/LmYkVUveDCZk/31POeaLmYf1/RfG+nP
         T9Aae2IZjIa6Z6t6wuqdJ3c1oKwkimZBjEUKEeqRiK/0rucNj0GnnXqnePQnvF/fXUod
         BlCA==
X-Gm-Message-State: ACgBeo2KcCU7ASZHN1Cm4C25Xcx7JAd7LSVvsEKLbx44W7iqAjbFWvl8
        oZU0uqmHrmLlAr/uZXh9yf4nzQ==
X-Google-Smtp-Source: AA6agR5JSdaI9bPTfugpkhEIC8ftyWaZ99ZRXRF7BxYWMWvNsktzFJ24qQazTIKhwI6axSPP7UqgFQ==
X-Received: by 2002:a1c:a187:0:b0:3a5:e055:715b with SMTP id k129-20020a1ca187000000b003a5e055715bmr2516003wme.171.1660842059332;
        Thu, 18 Aug 2022 10:00:59 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:58 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 31/31] selftests/aolib: Add test/benchmark for removing MKTs
Date:   Thu, 18 Aug 2022 18:00:05 +0100
Message-Id: <20220818170005.747015-32-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sample output:
> 1..36
> # 1106[lib/setup.c:207] rand seed 1660754406
> TAP version 13
> ok 1   Worst case connect       512 keys: min=0ms max=1ms mean=0.583329ms stddev=0.076376
> ok 2 Connect random-search      512 keys: min=0ms max=1ms mean=0.53412ms stddev=0.0516779
> ok 3    Worst case delete       512 keys: min=2ms max=11ms mean=6.04139ms stddev=0.245792
> ok 4        Add a new key       512 keys: min=0ms max=13ms mean=0.673415ms stddev=0.0820618
> ok 5 Remove random-search       512 keys: min=5ms max=9ms mean=6.65969ms stddev=0.258064
> ok 6         Remove async       512 keys: min=0ms max=0ms mean=0.041825ms stddev=0.0204512
> ok 7   Worst case connect       1024 keys: min=0ms max=2ms mean=0.520357ms stddev=0.0721358
> ok 8 Connect random-search      1024 keys: min=0ms max=2ms mean=0.535312ms stddev=0.0517355
> ok 9    Worst case delete       1024 keys: min=5ms max=9ms mean=8.27219ms stddev=0.287614
> ok 10        Add a new key      1024 keys: min=0ms max=1ms mean=0.688121ms stddev=0.0829531
> ok 11 Remove random-search      1024 keys: min=5ms max=9ms mean=8.37649ms stddev=0.289422
> ok 12         Remove async      1024 keys: min=0ms max=0ms mean=0.0457096ms stddev=0.0213798
> ok 13   Worst case connect      2048 keys: min=0ms max=2ms mean=0.748804ms stddev=0.0865335
> ok 14 Connect random-search     2048 keys: min=0ms max=2ms mean=0.782993ms stddev=0.0625697
> ok 15    Worst case delete      2048 keys: min=5ms max=10ms mean=8.23106ms stddev=0.286898
> ok 16        Add a new key      2048 keys: min=0ms max=1ms mean=0.812988ms stddev=0.0901658
> ok 17 Remove random-search      2048 keys: min=8ms max=9ms mean=8.84949ms stddev=0.297481
> ok 18         Remove async      2048 keys: min=0ms max=0ms mean=0.0297223ms stddev=0.0172402
> ok 19   Worst case connect      4096 keys: min=1ms max=5ms mean=1.53352ms stddev=0.123836
> ok 20 Connect random-search     4096 keys: min=1ms max=5ms mean=1.52226ms stddev=0.0872429
> ok 21    Worst case delete      4096 keys: min=5ms max=9ms mean=8.25874ms stddev=0.28738
> ok 22        Add a new key      4096 keys: min=0ms max=3ms mean=1.67382ms stddev=0.129376
> ok 23 Remove random-search      4096 keys: min=5ms max=10ms mean=8.26178ms stddev=0.287433
> ok 24         Remove async      4096 keys: min=0ms max=0ms mean=0.0340009ms stddev=0.0184393
> ok 25   Worst case connect      8192 keys: min=2ms max=4ms mean=2.86208ms stddev=0.169177
> ok 26 Connect random-search     8192 keys: min=2ms max=4ms mean=2.87592ms stddev=0.119915
> ok 27    Worst case delete      8192 keys: min=6ms max=11ms mean=7.55291ms stddev=0.274826
> ok 28        Add a new key      8192 keys: min=1ms max=5ms mean=2.56797ms stddev=0.160249
> ok 29 Remove random-search      8192 keys: min=5ms max=10ms mean=7.14002ms stddev=0.267208
> ok 30         Remove async      8192 keys: min=0ms max=0ms mean=0.0320066ms stddev=0.0178904
> ok 31   Worst case connect      16384 keys: min=5ms max=6ms mean=5.55334ms stddev=0.235655
> ok 32 Connect random-search     16384 keys: min=5ms max=6ms mean=5.52614ms stddev=0.166225
> ok 33    Worst case delete      16384 keys: min=5ms max=11ms mean=7.39109ms stddev=0.271866
> ok 34        Add a new key      16384 keys: min=2ms max=4ms mean=3.35799ms stddev=0.183248
> ok 35 Remove random-search      16384 keys: min=5ms max=8ms mean=6.86078ms stddev=0.261931
> ok 36         Remove async      16384 keys: min=0ms max=0ms mean=0.0302384ms stddev=0.0173892
> # Totals: pass:36 fail:0 xfail:0 xpass:0 skip:0 error:0

From it it's visible that the current simplified approach with
linked-list of MKTs scales quite fine even for thousands of keys.
And that also means that the majority of the time for delete is eaten by
synchronize_rcu() [which I can confirm separately by tracing].

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/tcp_ao/Makefile   |   4 +-
 .../selftests/net/tcp_ao/bench-lookups.c      | 403 ++++++++++++++++++
 2 files changed, 406 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_ao/bench-lookups.c

diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index da44966f3687..a4af7d4da169 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_BOTH_AF := connect icmps-discard icmps-accept connect-deny \
-		setsockopt-closed unsigned-md5
+		setsockopt-closed unsigned-md5 bench-lookups
 
 TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
 TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
@@ -46,3 +46,5 @@ $(OUTPUT)/%_ipv6: %.c
 
 $(OUTPUT)/icmps-accept_ipv4: CFLAGS+= -DTEST_ICMPS_ACCEPT
 $(OUTPUT)/icmps-accept_ipv6: CFLAGS+= -DTEST_ICMPS_ACCEPT
+$(OUTPUT)/bench-lookups_ipv4: LDFLAGS+= -lm
+$(OUTPUT)/bench-lookups_ipv6: LDFLAGS+= -lm
diff --git a/tools/testing/selftests/net/tcp_ao/bench-lookups.c b/tools/testing/selftests/net/tcp_ao/bench-lookups.c
new file mode 100644
index 000000000000..41456d85e06a
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/bench-lookups.c
@@ -0,0 +1,403 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dmitry Safonov <dima@arista.com> */
+#include <arpa/inet.h>
+#include <inttypes.h>
+#include <math.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <time.h>
+
+#include "../../../../include/linux/bits.h"
+#include "../../../../include/linux/kernel.h"
+#include "aolib.h"
+
+#define AO_KEY_SZ	300 /* ~= sizeof(struct tcp_ao_key) */
+#define NR_ITERS	100 /* number of times to run gathering statistics */
+
+#ifdef IPV6_TEST
+typedef struct in6_addr ipaddr_t;
+static ipaddr_t get_ipaddr_t(ipaddr_t net, size_t n)
+{
+	ipaddr_t ret = net;
+
+	ret.s6_addr32[3] = htonl(n & (BIT(32) - 1));
+	ret.s6_addr32[2] = htonl((n >> 32) & (BIT(32) - 1));
+
+	return ret;
+}
+#else
+typedef struct in_addr ipaddr_t;
+static ipaddr_t get_ipaddr_t(ipaddr_t net, size_t n)
+{
+	ipaddr_t ret;
+
+	ret.s_addr = htonl(ntohl(net.s_addr) + n);
+	return ret;
+}
+#endif
+
+static void gen_test_ips(ipaddr_t *ips, size_t ips_nr, bool use_rand)
+{
+	ipaddr_t net;
+	size_t i, j;
+
+	if (inet_pton(TEST_FAMILY, TEST_NETWORK, &net) != 1)
+		test_error("Can't convert ip address %s", TEST_NETWORK);
+
+	if (!use_rand) {
+		for (i = 0; i < ips_nr; i++)
+			ips[i] = get_ipaddr_t(net, 2 * i + 1);
+		return;
+	}
+	for (i = 0; i < ips_nr; i++) {
+		size_t r = (size_t)random() | 0x1;
+
+		ips[i] = get_ipaddr_t(net, r);
+
+		for (j = i - 1; j > 0 && i > 0; j--) {
+			if (!memcmp(&ips[i], &ips[j], sizeof(ipaddr_t))) {
+				i--; /* collision */
+				break;
+			}
+		}
+	}
+}
+
+static void test_add_routes(ipaddr_t *ips, size_t ips_nr)
+{
+	size_t i;
+
+	for (i = 0; i < ips_nr; i++) {
+		union tcp_addr *p = (union tcp_addr *)&ips[i];
+
+		if (ip_route_add(veth_name, TEST_FAMILY, this_ip_addr, *p))
+			test_error("Failed to add route");
+	}
+}
+
+static void server_apply_keys(int lsk, ipaddr_t *ips, size_t ips_nr)
+{
+	size_t i;
+
+	for (i = 0; i < ips_nr; i++) {
+		union tcp_addr *p = (union tcp_addr *)&ips[i];
+
+		if (test_set_ao(lsk, "password", 0, *p, -1, 100, 100))
+			test_error("setsockopt(TCP_AO)");
+	}
+}
+
+static const size_t nr_keys[] = { 512, 1024, 2048, 4096, 8192, 16384 };
+static ipaddr_t *test_ips;
+
+struct bench_stats {
+	uint64_t min;
+	uint64_t max;
+	uint64_t nr;
+	double mean;
+	double s2;
+};
+
+static struct bench_tests {
+	struct bench_stats delete_last_key;
+	struct bench_stats add_key;
+	struct bench_stats delete_rand_key;
+	struct bench_stats connect_last_key;
+	struct bench_stats connect_rand_key;
+	struct bench_stats delete_async;
+} bench_results[ARRAY_SIZE(nr_keys)];
+
+#define NSEC_PER_SEC 1000000000ULL
+
+static void measure_call(struct bench_stats *st,
+			 void (*f)(int, void *), int sk, void *arg)
+{
+	struct timespec start = {}, end = {};
+	double delta;
+	uint64_t nsec;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &start))
+		test_error("clock_gettime()");
+
+	f(sk, arg);
+
+	if (clock_gettime(CLOCK_MONOTONIC, &end))
+		test_error("clock_gettime()");
+
+	nsec = (end.tv_sec - start.tv_sec) * NSEC_PER_SEC;
+	if (end.tv_nsec >= start.tv_nsec)
+		nsec += end.tv_nsec - start.tv_nsec;
+	else
+		nsec -= start.tv_nsec - end.tv_nsec;
+
+	if (st->nr == 0) {
+		st->min = st->max = nsec;
+	} else {
+		if (st->min > nsec)
+			st->min = nsec;
+		if (st->max < nsec)
+			st->max = nsec;
+	}
+
+	/* Welford-Knuth algorithm */
+	st->nr++;
+	delta = (double)nsec - st->mean;
+	st->mean += delta / st->nr;
+	st->s2 += delta * ((double)nsec - st->mean);
+}
+
+static void delete_mkt(int sk, void *arg)
+{
+	struct tcp_ao_del *ao = arg;
+
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO_DEL, ao, sizeof(*ao)))
+		test_error("setsockopt(TCP_AO_DEL)");
+}
+
+static void add_back_mkt(int sk, void *arg)
+{
+	union tcp_addr *p = arg;
+
+	if (test_set_ao(sk, "password", 0, *p, -1, 100, 100))
+		test_error("setsockopt(TCP_AO)");
+}
+
+static void memcpy_sockaddr(void *dest, union tcp_addr *in_addr)
+{
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= 0,
+		.sin6_addr	= in_addr->a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= 0,
+		.sin_addr	= in_addr->a4,
+	};
+#endif
+
+	memcpy(dest, &addr, sizeof(addr));
+}
+
+static void bench_delete(int lsk, struct bench_stats *add,
+			 struct bench_stats *del,
+			 ipaddr_t *ips, size_t ips_nr,
+			 bool rand_order, bool async)
+{
+	struct tcp_ao_del ao_del = {};
+	union tcp_addr *p;
+	size_t i;
+
+	ao_del.tcpa_sndid = 100;
+	ao_del.tcpa_rcvid = 100;
+	if (async)
+		ao_del.tcpa_flags = TCP_AO_CMDF_DEL_ASYNC;
+	ao_del.tcpa_prefix = DEFAULT_TEST_PREFIX;
+
+	/* Remove the first added */
+	p = (union tcp_addr *)&ips[0];
+	memcpy_sockaddr(&ao_del.tcpa_addr, p);
+
+	for (i = 0; i < NR_ITERS; i++) {
+		measure_call(del, delete_mkt, lsk, (void *)&ao_del);
+
+		/* Restore it back */
+		measure_call(add, add_back_mkt, lsk, (void *)p);
+
+		/*
+		 * Slowest for FILO-linked-list:
+		 * on (i) iteration removing ips[i] element. When it gets
+		 * added to the list back - it becomes first to fetch, so
+		 * on (i + 1) iteration go to ips[i + 1] element.
+		 */
+		if (rand_order)
+			p = (union tcp_addr *)&ips[rand() % ips_nr];
+		else
+			p = (union tcp_addr *)&ips[i % ips_nr];
+		memcpy_sockaddr(&ao_del.tcpa_addr, p);
+	}
+}
+
+static void bench_connect_srv(int lsk, ipaddr_t *ips, size_t ips_nr)
+{
+	size_t i;
+
+	for (i = 0; i < NR_ITERS; i++) {
+		int err, sk;
+
+		synchronize_threads();
+
+		err = test_wait_fd(lsk, TEST_TIMEOUT_SEC, 0);
+		if (!err)
+			test_error("timeouted for accept()");
+		else if (err < 0)
+			test_error("test_wait_fd()");
+
+		sk = accept(lsk, NULL, NULL);
+		if (sk < 0)
+			test_error("accept()");
+
+		close(sk);
+	}
+}
+
+static void test_print_stats(const char *desc, size_t nr, struct bench_stats *bs)
+{
+	test_ok("%20s\t%zu keys: min=%" PRIu64 "ms max=%" PRIu64 "ms mean=%gms stddev=%g",
+		desc, nr, bs->min / 1000000, bs->max / 1000000,
+		bs->mean / 1000000, sqrt((bs->mean / 1000000) / bs->nr));
+}
+
+static void *server_fn(void *arg)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(nr_keys); i++) {
+		struct bench_tests *bt = &bench_results[i];
+		int lsk;
+
+		test_ips = malloc(nr_keys[i] * sizeof(ipaddr_t));
+		if (!test_ips)
+			test_error("malloc()");
+
+		lsk = test_listen_socket(this_ip_addr, test_server_port + i, 1);
+
+		gen_test_ips(test_ips, nr_keys[i], false);
+		test_add_routes(test_ips, nr_keys[i]);
+		test_set_optmem(AO_KEY_SZ * nr_keys[i]);
+		server_apply_keys(lsk, test_ips, nr_keys[i]);
+
+		synchronize_threads();
+		bench_connect_srv(lsk, test_ips, nr_keys[i]);
+		bench_connect_srv(lsk, test_ips, nr_keys[i]);
+
+		/* The worst case for FILO-list */
+		bench_delete(lsk, &bt->add_key, &bt->delete_last_key,
+			     test_ips, nr_keys[i], false, false);
+		test_print_stats("Worst case delete",
+				nr_keys[i], &bt->delete_last_key);
+		test_print_stats("Add a new key",
+				nr_keys[i], &bt->add_key);
+
+		bench_delete(lsk, &bt->add_key, &bt->delete_rand_key,
+			     test_ips, nr_keys[i], true, false);
+		test_print_stats("Remove random-search",
+				nr_keys[i], &bt->delete_rand_key);
+
+		bench_delete(lsk, &bt->add_key, &bt->delete_async,
+			     test_ips, nr_keys[i], false, true);
+		test_print_stats("Remove async", nr_keys[i], &bt->delete_async);
+
+		free(test_ips);
+		close(lsk);
+	}
+
+	return NULL;
+}
+
+static void connect_client(int sk, void *arg)
+{
+	size_t *p = arg;
+
+	if (test_connect_socket(sk, this_ip_dest, test_server_port + *p) <= 0)
+		test_error("failed to connect()");
+}
+
+static void client_addr_setup(int sk, union tcp_addr taddr)
+{
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= 0,
+		.sin6_addr	= taddr.a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= 0,
+		.sin_addr	= taddr.a4,
+	};
+#endif
+	int ret;
+
+	ret = ip_addr_add(veth_name, TEST_FAMILY, taddr, TEST_PREFIX);
+	if (ret && ret != -EEXIST)
+		test_error("Failed to add ip address");
+	ret = ip_route_add(veth_name, TEST_FAMILY, taddr, this_ip_dest);
+	if (ret && ret != -EEXIST)
+		test_error("Failed to add route");
+
+	if (bind(sk, &addr, sizeof(addr)))
+		test_error("bind()");
+}
+
+static void bench_connect_client(size_t port_off, struct bench_tests *bt,
+		ipaddr_t *ips, size_t ips_nr, bool rand_order)
+{
+	struct bench_stats *con;
+	union tcp_addr *p;
+	size_t i;
+
+	if (rand_order)
+		con = &bt->connect_rand_key;
+	else
+		con = &bt->connect_last_key;
+
+	p = (union tcp_addr *)&ips[0];
+
+	for (i = 0; i < NR_ITERS; i++) {
+		int sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+
+		if (sk < 0)
+			test_error("socket()");
+
+		client_addr_setup(sk, *p);
+		if (test_set_ao(sk, "password", 0, this_ip_dest, -1, 100, 100))
+			test_error("setsockopt(TCP_AO)");
+
+		synchronize_threads();
+
+		measure_call(con, connect_client, sk, (void *)&port_off);
+
+		close(sk);
+
+		/*
+		 * Slowest for FILO-linked-list:
+		 * on (i) iteration removing ips[i] element. When it gets
+		 * added to the list back - it becomes first to fetch, so
+		 * on (i + 1) iteration go to ips[i + 1] element.
+		 */
+		if (rand_order)
+			p = (union tcp_addr *)&ips[rand() % ips_nr];
+		else
+			p = (union tcp_addr *)&ips[i % ips_nr];
+	}
+}
+
+static void *client_fn(void *arg)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(nr_keys); i++) {
+		struct bench_tests *bt = &bench_results[i];
+
+		synchronize_threads();
+		bench_connect_client(i, bt, test_ips, nr_keys[i], false);
+		test_print_stats("Worst case connect",
+				nr_keys[i], &bt->connect_last_key);
+
+		bench_connect_client(i, bt, test_ips, nr_keys[i], false);
+		test_print_stats("Connect random-search",
+				nr_keys[i], &bt->connect_last_key);
+	}
+	synchronize_threads();
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	test_init(36, server_fn, client_fn);
+	return 0;
+}
-- 
2.37.2

