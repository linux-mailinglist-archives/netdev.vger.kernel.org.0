Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB666990EB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBPKRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjBPKRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:17:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2DB518C1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676542598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k/s3z/K3lmbyo3jKgGFl7HdCfZ2nwsRj+PuGxWblknM=;
        b=Rx/q3UKxNLJgaQRdm6Cayvi97R17v6ELgcO0q9Ut7Avn2OmAiDXJ0OOWdpmiCzVXBc5p+m
        hd4S/4Y057eBtLvT8cs+dPZ870KlYQyT0xoMJjg6okhYF6u69H0XHm1QxUKSm36pzey7eB
        9dF/RZCzSAmtmjIhB0lRqkvaBDWk0cM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-HpSJppBgMYyCN4VJnFrbdg-1; Thu, 16 Feb 2023 05:16:37 -0500
X-MC-Unique: HpSJppBgMYyCN4VJnFrbdg-1
Received: by mail-qv1-f71.google.com with SMTP id ny18-20020a056214399200b0056eb3830243so814533qvb.16
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:16:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/s3z/K3lmbyo3jKgGFl7HdCfZ2nwsRj+PuGxWblknM=;
        b=eUQ0ZR+MWnNtIwBKbCyNQJMPKqpW/3k6zlxa9WmiSH8qiDW4wTh8wgh2CMp1joGxNo
         SWN0eE3OtaXKBEyxd87uNnN2sMhiqOr51vvSzOZsfko8beoKVxsSxhb8bNkQblP722ti
         HPqxzR6Z8AwSmsrcwSdHFc018YMOLzaYvDdfUjCzY7unx+J/cNkZjfS53uHuCHLrZ5c5
         qSQdD+Myhxq7b5BBY+ljNZfOMwFYIF0FWnJLjG+wGc5Rfw9dUulKkbScWrPRtvKoZ7Sa
         oH1H+lmiDfkNLw+Lgvoml1oKd8c0HpgYzvTyXD94ztxOK6s20ZSQvmeRaTuAcp/zyNQB
         BOvA==
X-Gm-Message-State: AO0yUKVDNReURAvteN/CE6ok0jq7AFp6NRnR9RL4x5uApnWmrv/ReOQS
        O3QU7JDhKH1RgE5hgkXQ+16/uDXHiK6q24A/uGl/7YRt2kH0CSFLIVdTVsFdGy9wlOiyyWcfta8
        z3Ih9eqqddprZAISr
X-Received: by 2002:a05:6214:c2f:b0:56e:bfda:a14f with SMTP id a15-20020a0562140c2f00b0056ebfdaa14fmr9539619qvd.9.1676542597078;
        Thu, 16 Feb 2023 02:16:37 -0800 (PST)
X-Google-Smtp-Source: AK7set/7erKu7JlmNSZNtANo2ENIubiFUB6Q9MQmhbJPU7u43h3bSc2LEqwIScpXL3Ip7O3tVadXLA==
X-Received: by 2002:a05:6214:c2f:b0:56e:bfda:a14f with SMTP id a15-20020a0562140c2f00b0056ebfdaa14fmr9539586qvd.9.1676542596758;
        Thu, 16 Feb 2023 02:16:36 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id q4-20020a378e04000000b006ce580c2663sm911676qkd.35.2023.02.16.02.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 02:16:36 -0800 (PST)
Date:   Thu, 16 Feb 2023 11:16:28 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jakub@cloudflare.com, hdanton@sina.com, cong.wang@bytedance.com
Subject: Re: [PATCH RFC net-next v2 3/3] selftests/bpf: Add a test case for
 vsock sockmap
Message-ID: <20230216101628.7z672auaimoauvi7@sgarzare-redhat>
References: <20230118-support-vsock-sockmap-connectible-v2-0-58ffafde0965@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v2-3-58ffafde0965@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v2-3-58ffafde0965@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 08:35:14PM -0800, Bobby Eshleman wrote:
>Add a test case testing the redirection from connectible AF_VSOCK
>sockets to connectible AF_UNIX sockets.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++++
> 1 file changed, 163 insertions(+)

For the vsock part:

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>index 2cf0c7a3fe23..8b5a2e09c9ed 100644
>--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>@@ -18,6 +18,7 @@
> #include <string.h>
> #include <sys/select.h>
> #include <unistd.h>
>+#include <linux/vm_sockets.h>
>
> #include <bpf/bpf.h>
> #include <bpf/libbpf.h>
>@@ -249,6 +250,16 @@ static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
> 	*len = sizeof(*addr6);
> }
>
>+static void init_addr_loopback_vsock(struct sockaddr_storage *ss, socklen_t *len)
>+{
>+	struct sockaddr_vm *addr = memset(ss, 0, sizeof(*ss));
>+
>+	addr->svm_family = AF_VSOCK;
>+	addr->svm_port = VMADDR_PORT_ANY;
>+	addr->svm_cid = VMADDR_CID_LOCAL;
>+	*len = sizeof(*addr);
>+}
>+
> static void init_addr_loopback(int family, struct sockaddr_storage *ss,
> 			       socklen_t *len)
> {
>@@ -259,6 +270,9 @@ static void init_addr_loopback(int family, struct sockaddr_storage *ss,
> 	case AF_INET6:
> 		init_addr_loopback6(ss, len);
> 		return;
>+	case AF_VSOCK:
>+		init_addr_loopback_vsock(ss, len);
>+		return;
> 	default:
> 		FAIL("unsupported address family %d", family);
> 	}
>@@ -1434,6 +1448,8 @@ static const char *family_str(sa_family_t family)
> 		return "IPv6";
> 	case AF_UNIX:
> 		return "Unix";
>+	case AF_VSOCK:
>+		return "VSOCK";
> 	default:
> 		return "unknown";
> 	}
>@@ -1644,6 +1660,151 @@ static void test_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *ma
> 	unix_skb_redir_to_connected(skel, map, sotype);
> }
>
>+/* Returns two connected loopback vsock sockets */
>+static int vsock_socketpair_connectible(int sotype, int *v0, int *v1)
>+{
>+	struct sockaddr_storage addr;
>+	socklen_t len = sizeof(addr);
>+	int s, p, c;
>+
>+	s = socket_loopback(AF_VSOCK, sotype);
>+	if (s < 0)
>+		return -1;
>+
>+	c = xsocket(AF_VSOCK, sotype | SOCK_NONBLOCK, 0);
>+	if (c == -1)
>+		goto close_srv;
>+
>+	if (getsockname(s, sockaddr(&addr), &len) < 0)
>+		goto close_cli;
>+
>+	if (connect(c, sockaddr(&addr), len) < 0 && errno != EINPROGRESS) {
>+		FAIL_ERRNO("connect");
>+		goto close_cli;
>+	}
>+
>+	len = sizeof(addr);
>+	p = accept_timeout(s, sockaddr(&addr), &len, IO_TIMEOUT_SEC);
>+	if (p < 0)
>+		goto close_cli;
>+
>+	*v0 = p;
>+	*v1 = c;
>+
>+	return 0;
>+
>+close_cli:
>+	close(c);
>+close_srv:
>+	close(s);
>+
>+	return -1;
>+}
>+
>+static void vsock_unix_redir_connectible(int sock_mapfd, int verd_mapfd,
>+					 enum redir_mode mode, int sotype)
>+{
>+	const char *log_prefix = redir_mode_str(mode);
>+	char a = 'a', b = 'b';
>+	int u0, u1, v0, v1;
>+	int sfd[2];
>+	unsigned int pass;
>+	int err, n;
>+	u32 key;
>+
>+	zero_verdict_count(verd_mapfd);
>+
>+	if (socketpair(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, 0, sfd))
>+		return;
>+
>+	u0 = sfd[0];
>+	u1 = sfd[1];
>+
>+	err = vsock_socketpair_connectible(sotype, &v0, &v1);
>+	if (err) {
>+		FAIL("vsock_socketpair_connectible() failed");
>+		goto close_uds;
>+	}
>+
>+	err = add_to_sockmap(sock_mapfd, u0, v0);
>+	if (err) {
>+		FAIL("add_to_sockmap failed");
>+		goto close_vsock;
>+	}
>+
>+	n = write(v1, &a, sizeof(a));
>+	if (n < 0)
>+		FAIL_ERRNO("%s: write", log_prefix);
>+	if (n == 0)
>+		FAIL("%s: incomplete write", log_prefix);
>+	if (n < 1)
>+		goto out;
>+
>+	n = recv(mode == REDIR_INGRESS ? u0 : u1, &b, sizeof(b), MSG_DONTWAIT);
>+	if (n < 0)
>+		FAIL("%s: recv() err, errno=%d", log_prefix, errno);
>+	if (n == 0)
>+		FAIL("%s: incomplete recv", log_prefix);
>+	if (b != a)
>+		FAIL("%s: vsock socket map failed, %c != %c", log_prefix, a, b);
>+
>+	key = SK_PASS;
>+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
>+	if (err)
>+		goto out;
>+	if (pass != 1)
>+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
>+out:
>+	key = 0;
>+	bpf_map_delete_elem(sock_mapfd, &key);
>+	key = 1;
>+	bpf_map_delete_elem(sock_mapfd, &key);
>+
>+close_vsock:
>+	close(v0);
>+	close(v1);
>+
>+close_uds:
>+	close(u0);
>+	close(u1);
>+}
>+
>+static void vsock_unix_skb_redir_connectible(struct test_sockmap_listen *skel,
>+					     struct bpf_map *inner_map,
>+					     int sotype)
>+{
>+	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
>+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
>+	int sock_map = bpf_map__fd(inner_map);
>+	int err;
>+
>+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_VERDICT, 0);
>+	if (err)
>+		return;
>+
>+	skel->bss->test_ingress = false;
>+	vsock_unix_redir_connectible(sock_map, verdict_map, REDIR_EGRESS, sotype);
>+	skel->bss->test_ingress = true;
>+	vsock_unix_redir_connectible(sock_map, verdict_map, REDIR_INGRESS, sotype);
>+
>+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
>+}
>+
>+static void test_vsock_redir(struct test_sockmap_listen *skel, struct bpf_map *map)
>+{
>+	const char *family_name, *map_name;
>+	char s[MAX_TEST_NAME];
>+
>+	family_name = family_str(AF_VSOCK);
>+	map_name = map_type_str(map);
>+	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
>+	if (!test__start_subtest(s))
>+		return;
>+
>+	vsock_unix_skb_redir_connectible(skel, map, SOCK_STREAM);
>+	vsock_unix_skb_redir_connectible(skel, map, SOCK_SEQPACKET);
>+}
>+
> static void test_reuseport(struct test_sockmap_listen *skel,
> 			   struct bpf_map *map, int family, int sotype)
> {
>@@ -2015,12 +2176,14 @@ void serial_test_sockmap_listen(void)
> 	run_tests(skel, skel->maps.sock_map, AF_INET6);
> 	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
> 	test_unix_redir(skel, skel->maps.sock_map, SOCK_STREAM);
>+	test_vsock_redir(skel, skel->maps.sock_map);
>
> 	skel->bss->test_sockmap = false;
> 	run_tests(skel, skel->maps.sock_hash, AF_INET);
> 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
> 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
> 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_STREAM);
>+	test_vsock_redir(skel, skel->maps.sock_hash);
>
> 	test_sockmap_listen__destroy(skel);
> }
>
>-- 
>2.35.1
>

