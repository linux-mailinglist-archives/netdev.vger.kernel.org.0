Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571D4171650
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgB0LtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:49:14 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36914 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbgB0LtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:49:13 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so1858749lfc.4
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 03:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1+mwtXP7Acp4rPP10KQIKzHg35JqBTN2HvSJj+dugs4=;
        b=rsGEZQZEUgK2Nr4TC0uZOvwCoFTFG+KhXDqqJ/Ght92e7F8yHGRC7X/SgdHXLMDmyz
         OAP14zWqI+Wp+XYZNBwAmdQopgjPW/K/IjA1OE1jzoMWO8eKAwiJ7vUYDHT4AQoReJ/d
         gx8WSbmnGtlZ9u5MFerMqqUqZGrgD0gBVN/v0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1+mwtXP7Acp4rPP10KQIKzHg35JqBTN2HvSJj+dugs4=;
        b=QaaDtjGkNznxl36KQ8sGjo87WAu7jhY/m10qIhhDgig1EPVtjrZJWgng/FwZ8qN0TX
         YkK5s7ahDEOVTjkxWzPmsOZdvT0CSbIrXOuOt4RhfNR1mZrn2ZpGJwj33BG36K73C8A3
         zGdP8HdCpaxD3ryTskAFOtNYtG7ebEuyT0z9OUY0DbP4mPq1gr1pynKRN/v3HZ+eip+D
         5CD8mxSZ0JlVi1iIThDP6Neyc76m/PEl/KHRyLTStPtz0kPuWpiGMHmm06u8sJdUUr/2
         aEmtbB03oOjTUL0mYWJ4syb+s6KXjaxird5bECpgA00slCiAXGa2V1YHrmvZBpw0NykH
         DRiQ==
X-Gm-Message-State: ANhLgQ1GZ8U0zBhf3Ibfr78mD/dq3EJV1pd4czuchsfZwzAlVnK7MqLT
        kHQCY/bAyxgqZcKJTn+kSgPxLg==
X-Google-Smtp-Source: ADFU+vuALOCRpJ7LYk7zU7ulDkFadaExzGaifT9dm69nNJefE1PewYx9283/gk2MgENZB245KhB1OQ==
X-Received: by 2002:ac2:4467:: with SMTP id y7mr1994051lfl.167.1582804151132;
        Thu, 27 Feb 2020 03:49:11 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q13sm3670741ljj.63.2020.02.27.03.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 03:49:10 -0800 (PST)
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-7-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 6/7] selftests: bpf: add tests for UDP sockets in sockmap
In-reply-to: <20200225135636.5768-7-lmb@cloudflare.com>
Date:   Thu, 27 Feb 2020 12:49:09 +0100
Message-ID: <877e08cksq.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:56 PM CET, Lorenz Bauer wrote:
> Expand the TCP sockmap test suite to also check UDP sockets.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 92 +++++++++++++------
>  1 file changed, 63 insertions(+), 29 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> index 4ba41dd26d6b..72e578a5a5d2 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> @@ -330,7 +330,7 @@ static void test_insert_bound(int family, int sotype, int mapfd)
>  	xclose(s);
>  }
>
> -static void test_insert_listening(int family, int sotype, int mapfd)
> +static void test_insert(int family, int sotype, int mapfd)
>  {
>  	u64 value;
>  	u32 key;
> @@ -467,7 +467,7 @@ static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
>  	xclose(s);
>  }
>
> -static void test_update_listening(int family, int sotype, int mapfd)
> +static void test_update_existing(int family, int sotype, int mapfd)
>  {
>  	int s1, s2;
>  	u64 value;
> @@ -1302,11 +1302,15 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
>  	xclose(s1);
>  }
>
> -#define TEST(fn)                                                               \
> +#define TEST_SOTYPE(fn, sotype)                                                \
>  	{                                                                      \
> -		fn, #fn                                                        \
> +		fn, #fn, sotype                                                \
>  	}
>
> +#define TEST(fn) TEST_SOTYPE(fn, 0)
> +#define TEST_STREAM(fn) TEST_SOTYPE(fn, SOCK_STREAM)
> +#define TEST_DGRAM(fn) TEST_SOTYPE(fn, SOCK_DGRAM)
> +

An alternative would be to use __VA_ARGS__ and designated intializers,
as I did recently in e0360423d020 ("selftests/bpf: Run SYN cookies with
reuseport BPF test only for TCP"). TEST_DGRAM is unused at the moment,
so that's something to consider.

>  static void test_ops_cleanup(const struct bpf_map *map)
>  {
>  	const struct bpf_map_def *def;
> @@ -1353,18 +1357,31 @@ static const char *map_type_str(const struct bpf_map *map)
>  	}
>  }
>
> +static const char *sotype_str(int sotype)
> +{
> +	switch (sotype) {
> +	case SOCK_DGRAM:
> +		return "UDP";
> +	case SOCK_STREAM:
> +		return "TCP";
> +	default:
> +		return "unknown";
> +	}
> +}
> +
>  static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
>  		     int family, int sotype)
>  {
>  	const struct op_test {
>  		void (*fn)(int family, int sotype, int mapfd);
>  		const char *name;
> +		int sotype;
>  	} tests[] = {
>  		/* insert */
>  		TEST(test_insert_invalid),
>  		TEST(test_insert_opened),
> -		TEST(test_insert_bound),
> -		TEST(test_insert_listening),
> +		TEST_STREAM(test_insert_bound),
> +		TEST(test_insert),
>  		/* delete */
>  		TEST(test_delete_after_insert),
>  		TEST(test_delete_after_close),
> @@ -1373,28 +1390,33 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
>  		TEST(test_lookup_after_delete),
>  		TEST(test_lookup_32_bit_value),
>  		/* update */
> -		TEST(test_update_listening),
> +		TEST(test_update_existing),
>  		/* races with insert/delete */
> -		TEST(test_destroy_orphan_child),
> -		TEST(test_syn_recv_insert_delete),
> -		TEST(test_race_insert_listen),
> +		TEST_STREAM(test_destroy_orphan_child),
> +		TEST_STREAM(test_syn_recv_insert_delete),
> +		TEST_STREAM(test_race_insert_listen),
>  		/* child clone */
> -		TEST(test_clone_after_delete),
> -		TEST(test_accept_after_delete),
> -		TEST(test_accept_before_delete),
> +		TEST_STREAM(test_clone_after_delete),
> +		TEST_STREAM(test_accept_after_delete),
> +		TEST_STREAM(test_accept_before_delete),
>  	};
> -	const char *family_name, *map_name;
> +	const char *family_name, *map_name, *sotype_name;
>  	const struct op_test *t;
>  	char s[MAX_TEST_NAME];
>  	int map_fd;
>
>  	family_name = family_str(family);
>  	map_name = map_type_str(map);
> +	sotype_name = sotype_str(sotype);
>  	map_fd = bpf_map__fd(map);
>
> +
>  	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
> -		snprintf(s, sizeof(s), "%s %s %s", map_name, family_name,
> -			 t->name);
> +		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
> +			 sotype_name, t->name);
> +
> +		if (t->sotype != 0 && t->sotype != sotype)
> +			continue;
>
>  		if (!test__start_subtest(s))
>  			continue;
> @@ -1411,22 +1433,28 @@ static void test_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
>  		void (*fn)(struct test_sockmap_listen *skel,
>  			   struct bpf_map *map, int family, int sotype);
>  		const char *name;
> +		int sotype;
>  	} tests[] = {
> -		TEST(test_skb_redir_to_connected),
> -		TEST(test_skb_redir_to_listening),
> -		TEST(test_msg_redir_to_connected),
> -		TEST(test_msg_redir_to_listening),
> +		TEST_STREAM(test_skb_redir_to_connected),
> +		TEST_STREAM(test_skb_redir_to_listening),
> +		TEST_STREAM(test_msg_redir_to_connected),
> +		TEST_STREAM(test_msg_redir_to_listening),
>  	};
> -	const char *family_name, *map_name;
> +	const char *family_name, *map_name, *sotype_name;
>  	const struct redir_test *t;
>  	char s[MAX_TEST_NAME];
>
>  	family_name = family_str(family);
>  	map_name = map_type_str(map);
> +	sotype_name = sotype_str(sotype);
>
>  	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
> -		snprintf(s, sizeof(s), "%s %s %s", map_name, family_name,
> -			 t->name);
> +		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
> +			 sotype_name, t->name);
> +
> +		if (t->sotype != 0 && t->sotype != sotype)
> +			continue;
> +
>  		if (!test__start_subtest(s))
>  			continue;
>

test_redir() doesn't get called with SOCK_DGRAM, because redirection
with sockmap and UDP is not supported yet, so perhaps no need to touch
this function. 

> @@ -1441,26 +1469,31 @@ static void test_reuseport(struct test_sockmap_listen *skel,
>  		void (*fn)(int family, int sotype, int socket_map,
>  			   int verdict_map, int reuseport_prog);
>  		const char *name;
> +		int sotype;
>  	} tests[] = {
> -		TEST(test_reuseport_select_listening),
> -		TEST(test_reuseport_select_connected),
> -		TEST(test_reuseport_mixed_groups),
> +		TEST_STREAM(test_reuseport_select_listening),
> +		TEST_STREAM(test_reuseport_select_connected),
> +		TEST_STREAM(test_reuseport_mixed_groups),
>  	};
>  	int socket_map, verdict_map, reuseport_prog;
> -	const char *family_name, *map_name;
> +	const char *family_name, *map_name, *sotype_name;
>  	const struct reuseport_test *t;
>  	char s[MAX_TEST_NAME];
>
>  	family_name = family_str(family);
>  	map_name = map_type_str(map);
> +	sotype_name = sotype_str(sotype);
>
>  	socket_map = bpf_map__fd(map);
>  	verdict_map = bpf_map__fd(skel->maps.verdict_map);
>  	reuseport_prog = bpf_program__fd(skel->progs.prog_reuseport);
>
>  	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
> -		snprintf(s, sizeof(s), "%s %s %s", map_name, family_name,
> -			 t->name);
> +		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
> +			 sotype_name, t->name);
> +
> +		if (t->sotype != 0 && t->sotype != sotype)
> +			continue;
>
>  		if (!test__start_subtest(s))
>  			continue;
> @@ -1473,6 +1506,7 @@ static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
>  		      int family)
>  {
>  	test_ops(skel, map, family, SOCK_STREAM);
> +	test_ops(skel, map, family, SOCK_DGRAM);
>  	test_redir(skel, map, family, SOCK_STREAM);
>  	test_reuseport(skel, map, family, SOCK_STREAM);
>  }

Looks like we can enable reuseport tests with not too much effort.
I managed to get them working with the changes below.

---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 102 +++++++++++++++---
 1 file changed, 87 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 72e578a5a5d2..6850994fc4d5 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -108,6 +108,22 @@
 		__ret;                                                         \
 	})
 
+#define xsend(fd, buf, len, flags)                                             \
+	({                                                                     \
+		ssize_t __ret = send((fd), (buf), (len), (flags));             \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("send");                                    \
+		__ret;                                                         \
+	})
+
+#define xrecv(fd, buf, len, flags)                                             \
+	({                                                                     \
+		ssize_t __ret = recv((fd), (buf), (len), (flags));             \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("recv");                                    \
+		__ret;                                                         \
+	})
+
 #define xsocket(family, sotype, flags)                                         \
 	({                                                                     \
 		int __ret = socket(family, sotype, flags);                     \
@@ -1116,7 +1132,7 @@ static void test_reuseport_select_listening(int family, int sotype,
 {
 	struct sockaddr_storage addr;
 	unsigned int pass;
-	int s, c, p, err;
+	int s, c, err;
 	socklen_t len;
 	u64 value;
 	u32 key;
@@ -1145,19 +1161,33 @@ static void test_reuseport_select_listening(int family, int sotype,
 	if (err)
 		goto close_cli;
 
-	p = xaccept(s, NULL, NULL);
-	if (p < 0)
-		goto close_cli;
+	if (sotype == SOCK_STREAM) {
+		int p;
+
+		p = xaccept(s, NULL, NULL);
+		if (p < 0)
+			goto close_cli;
+		xclose(p);
+	} else {
+		char b = 'a';
+		ssize_t n;
+
+		n = xsend(c, &b, sizeof(b), 0);
+		if (n == -1)
+			goto close_cli;
+
+		n = xrecv(s, &b, sizeof(b), 0);
+		if (n == -1)
+			goto close_cli;
+	}
 
 	key = SK_PASS;
 	err = xbpf_map_lookup_elem(verd_map, &key, &pass);
 	if (err)
-		goto close_peer;
+		goto close_cli;
 	if (pass != 1)
 		FAIL("want pass count 1, have %d", pass);
 
-close_peer:
-	xclose(p);
 close_cli:
 	xclose(c);
 close_srv:
@@ -1201,9 +1231,24 @@ static void test_reuseport_select_connected(int family, int sotype,
 	if (err)
 		goto close_cli0;
 
-	p0 = xaccept(s, NULL, NULL);
-	if (err)
-		goto close_cli0;
+	if (sotype == SOCK_STREAM) {
+		p0 = xaccept(s, NULL, NULL);
+		if (p0 < 0)
+			goto close_cli0;
+	} else {
+		p0 = xsocket(family, sotype, 0);
+		if (p0 < 0)
+			goto close_cli0;
+
+		len = sizeof(addr);
+		err = xgetsockname(c0, sockaddr(&addr), &len);
+		if (err)
+			goto close_cli0;
+
+		err = xconnect(p0, sockaddr(&addr), len);
+		if (err)
+			goto close_cli0;
+	}
 
 	/* Update sock_map[0] to redirect to a connected socket */
 	key = 0;
@@ -1216,8 +1261,24 @@ static void test_reuseport_select_connected(int family, int sotype,
 	if (c1 < 0)
 		goto close_peer0;
 
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
 	errno = 0;
 	err = connect(c1, sockaddr(&addr), len);
+	if (sotype == SOCK_DGRAM) {
+		char b = 'a';
+		ssize_t n;
+
+		n = xsend(c1, &b, sizeof(b), 0);
+		if (n == -1)
+			goto close_cli1;
+
+		n = recv(c1, &b, sizeof(b), 0);
+		err = n == -1;
+	}
 	if (!err || errno != ECONNREFUSED)
 		FAIL_ERRNO("connect: expected ECONNREFUSED");
 
@@ -1281,7 +1342,18 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 		goto close_srv2;
 
 	err = connect(c, sockaddr(&addr), len);
-	if (err && errno != ECONNREFUSED) {
+	if (sotype == SOCK_DGRAM) {
+		char b = 'a';
+		ssize_t n;
+
+		n = xsend(c, &b, sizeof(b), 0);
+		if (n == -1)
+			goto close_cli;
+
+		n = recv(c, &b, sizeof(b), 0);
+		err = n == -1;
+	}
+	if (!err || errno != ECONNREFUSED) {
 		FAIL_ERRNO("connect: expected ECONNREFUSED");
 		goto close_cli;
 	}
@@ -1410,7 +1482,6 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
 	sotype_name = sotype_str(sotype);
 	map_fd = bpf_map__fd(map);
 
-
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
 		snprintf(s, sizeof(s), "%s %s %s %s", map_name, family_name,
 			 sotype_name, t->name);
@@ -1471,9 +1542,9 @@ static void test_reuseport(struct test_sockmap_listen *skel,
 		const char *name;
 		int sotype;
 	} tests[] = {
-		TEST_STREAM(test_reuseport_select_listening),
-		TEST_STREAM(test_reuseport_select_connected),
-		TEST_STREAM(test_reuseport_mixed_groups),
+		TEST(test_reuseport_select_listening),
+		TEST(test_reuseport_select_connected),
+		TEST(test_reuseport_mixed_groups),
 	};
 	int socket_map, verdict_map, reuseport_prog;
 	const char *family_name, *map_name, *sotype_name;
@@ -1509,6 +1580,7 @@ static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 	test_ops(skel, map, family, SOCK_DGRAM);
 	test_redir(skel, map, family, SOCK_STREAM);
 	test_reuseport(skel, map, family, SOCK_STREAM);
+	test_reuseport(skel, map, family, SOCK_DGRAM);
 }
 
 void test_sockmap_listen(void)
-- 
2.24.1

