Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AAD6F134B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345389AbjD1Ian (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345691AbjD1Iaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:30:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AC54483;
        Fri, 28 Apr 2023 01:30:34 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f86ee42669so9206130f8f.2;
        Fri, 28 Apr 2023 01:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682670632; x=1685262632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZKHuNYOMlJBpzk+vOqJBW0xJYSFCiW2cvnQ49ybRjM=;
        b=sfMiG7qgJFlTrpsIA1j5/ngPUvQc6p/A1JeztHSucYEfUyk5nMLqAKSO1cusiwRWIz
         nvCP4OaDJ49fPN8/CnUc+rLfVogKviCQJToh2jC4JcMubmysAP2CM4jQC3sjqgaHAh5B
         LQhv3V/3XZ5Jb3/7JWk0OjygMLvNVDKzxJ/6hx6IU8qzz4uVs3bfRBWk35WUaas9gyoM
         Fyd+sVxuEYGOF3tzL1O89En1l6YU2FlRuLL+EzuSDtWvHzv9Hi2ZwxhhcsIXO3MRBkts
         19hoNpW2NvBDhewK3pFrbnK61rbbsn+0gaWCmZugtswZWgN6a2uRmaqUKKUfRSr8RsnQ
         6Gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682670632; x=1685262632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZKHuNYOMlJBpzk+vOqJBW0xJYSFCiW2cvnQ49ybRjM=;
        b=h0myAc41FOnDKPh+ht7FxtbH//iceBbtU8Hm7A42w7tm15u19ZxwWNbiqQDkfvPjyQ
         SJfqEK9YpFouMi5fJxvorhFSsHHw7OnadYg6h529Q5I1i/3xZYPTOcOPksG9uA5FdjaO
         VL9vWCOLDiMxPKFEm5Ehm0mVrcNuTmJx0C0u6NsX29kVzV2HT8Kfb2V3zv6KzjSFjvTG
         auau4AuEDQTQigZU3LFu7wYUnLkqEgZ3ClXeUZN89MV4zc7LHTGjC6DW26SNH6WYDfXf
         PTfjHYTwCA4wwydxoynuoYCTJTTCB2zeBpkvV4QNqWDwpyeT5y0e5KTq05PjBnEH4plk
         D+5w==
X-Gm-Message-State: AC+VfDwRzPkC/WdweFWxiaCRZu/E0LWkoQVNW2OCDavsLuCu5859rRlx
        /8MxWZUZln4Y2abqosy9TgE=
X-Google-Smtp-Source: ACHHUZ5Vv4LBN84NjF6CPnSxL14MjsAdJWNuIoid67UwRQts+ENzwZmKy66Z2GtHJpHAlJrXMHFBwg==
X-Received: by 2002:a5d:4d10:0:b0:2ce:a6be:2bd with SMTP id z16-20020a5d4d10000000b002cea6be02bdmr2938514wrt.1.1682670632350;
        Fri, 28 Apr 2023 01:30:32 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([2a0d:6fc2:43e5:9b00:5000:8721:8779:7e1])
        by smtp.gmail.com with ESMTPSA id n12-20020a7bc5cc000000b003f17329f7f2sm23540545wmk.38.2023.04.28.01.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 01:30:31 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v4 4/4] selftests/bpf: Add vrf_socket_lookup tests
Date:   Fri, 28 Apr 2023 11:30:07 +0300
Message-Id: <20230428083007.148364-5-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230428083007.148364-1-gilad9366@gmail.com>
References: <20230428083007.148364-1-gilad9366@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that socket lookup via TC/XDP with all BPF APIs is VRF aware.

Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
v4: - Remove SYS and SYS_NOFAIL duplicate definitions

v3: - Added xdp tests as suggested by Daniel Borkmann
    - Use start_server() to avoid duplicate code as suggested by Stanislav Fomichev

v2: Fix build by initializing vars with -1
---
 .../bpf/prog_tests/vrf_socket_lookup.c        | 312 ++++++++++++++++++
 .../selftests/bpf/progs/vrf_socket_lookup.c   |  88 +++++
 2 files changed, 400 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/vrf_socket_lookup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c b/tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c
new file mode 100644
index 000000000000..2f2562fab239
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+/*
+ * Topology:
+ * ---------
+ *     NS0 namespace         |   NS1 namespace
+ *			     |
+ *     +--------------+      |   +--------------+
+ *     |    veth01    |----------|    veth10    |
+ *     | 172.16.1.100 |      |   | 172.16.1.200 |
+ *     |     bpf      |      |   +--------------+
+ *     +--------------+      |
+ *      server(UDP/TCP)      |
+ *  +-------------------+    |
+ *  |        vrf1       |    |
+ *  |  +--------------+ |    |   +--------------+
+ *  |  |    veth02    |----------|    veth20    |
+ *  |  | 172.16.2.100 | |    |   | 172.16.2.200 |
+ *  |  |     bpf      | |    |   +--------------+
+ *  |  +--------------+ |    |
+ *  |   server(UDP/TCP) |    |
+ *  +-------------------+    |
+ *
+ * Test flow
+ * -----------
+ *  The tests verifies that socket lookup via TC is VRF aware:
+ *  1) Creates two veth pairs between NS0 and NS1:
+ *     a) veth01 <-> veth10 outside the VRF
+ *     b) veth02 <-> veth20 in the VRF
+ *  2) Attaches to veth01 and veth02 a program that calls:
+ *     a) bpf_skc_lookup_tcp() with TCP and tcp_skc is true
+ *     b) bpf_sk_lookup_tcp() with TCP and tcp_skc is false
+ *     c) bpf_sk_lookup_udp() with UDP
+ *     The program stores the lookup result in bss->lookup_status.
+ *  3) Creates a socket TCP/UDP server in/outside the VRF.
+ *  4) The test expects lookup_status to be:
+ *     a) 0 from device in VRF to server outside VRF
+ *     b) 0 from device outside VRF to server in VRF
+ *     c) 1 from device in VRF to server in VRF
+ *     d) 1 from device outside VRF to server outside VRF
+ */
+
+#include <net/if.h>
+
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "vrf_socket_lookup.skel.h"
+
+#define NS0 "vrf_socket_lookup_0"
+#define NS1 "vrf_socket_lookup_1"
+
+#define IP4_ADDR_VETH01 "172.16.1.100"
+#define IP4_ADDR_VETH10 "172.16.1.200"
+#define IP4_ADDR_VETH02 "172.16.2.100"
+#define IP4_ADDR_VETH20 "172.16.2.200"
+
+#define NON_VRF_PORT 5000
+#define IN_VRF_PORT 5001
+
+#define TIMEOUT_MS 3000
+
+static int make_socket(int sotype, const char *ip, int port,
+		       struct sockaddr_storage *addr)
+{
+	int err, fd;
+
+	err = make_sockaddr(AF_INET, ip, port, addr, NULL);
+	if (!ASSERT_OK(err, "make_address"))
+		return -1;
+
+	fd = socket(AF_INET, sotype, 0);
+	if (!ASSERT_GE(fd, 0, "socket"))
+		return -1;
+
+	if (!ASSERT_OK(settimeo(fd, TIMEOUT_MS), "settimeo"))
+		goto fail;
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+static int make_server(int sotype, const char *ip, int port, const char *ifname)
+{
+	int err, fd = -1;
+
+	fd = start_server(AF_INET, sotype, ip, port, TIMEOUT_MS);
+	if (!ASSERT_GE(fd, 0, "start_server"))
+		return -1;
+
+	if (ifname) {
+		err = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
+				 ifname, strlen(ifname) + 1);
+		if (!ASSERT_OK(err, "setsockopt(SO_BINDTODEVICE)"))
+			goto fail;
+	}
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+static int attach_progs(char *ifname, int tc_prog_fd, int xdp_prog_fd)
+{
+	LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1,
+		    .prog_fd = tc_prog_fd);
+	LIBBPF_OPTS(bpf_tc_hook, hook, .attach_point = BPF_TC_INGRESS);
+	int ret, ifindex;
+
+	ifindex = if_nametoindex(ifname);
+	if (!ASSERT_NEQ(ifindex, 0, "if_nametoindex"))
+		return -1;
+	hook.ifindex = ifindex;
+
+	ret = bpf_tc_hook_create(&hook);
+	if (!ASSERT_OK(ret, "bpf_tc_hook_create"))
+		return ret;
+
+	ret = bpf_tc_attach(&hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_attach")) {
+		bpf_tc_hook_destroy(&hook);
+		return ret;
+	}
+	ret = bpf_xdp_attach(ifindex, xdp_prog_fd, 0, NULL);
+	if (!ASSERT_OK(ret, "bpf_xdp_attach")) {
+		bpf_tc_hook_destroy(&hook);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void cleanup(void)
+{
+	SYS_NOFAIL("test -f /var/run/netns/" NS0 " && ip netns delete "
+		   NS0);
+	SYS_NOFAIL("test -f /var/run/netns/" NS1 " && ip netns delete "
+		   NS1);
+}
+
+static int setup(struct vrf_socket_lookup *skel)
+{
+	int tc_prog_fd, xdp_prog_fd, ret = 0;
+	struct nstoken *nstoken = NULL;
+
+	SYS(fail, "ip netns add " NS0);
+	SYS(fail, "ip netns add " NS1);
+
+	/* NS0 <-> NS1 [veth01 <-> veth10] */
+	SYS(fail, "ip link add veth01 netns " NS0 " type veth peer name veth10"
+	    " netns " NS1);
+	SYS(fail, "ip -net " NS0 " addr add " IP4_ADDR_VETH01 "/24 dev veth01");
+	SYS(fail, "ip -net " NS0 " link set dev veth01 up");
+	SYS(fail, "ip -net " NS1 " addr add " IP4_ADDR_VETH10 "/24 dev veth10");
+	SYS(fail, "ip -net " NS1 " link set dev veth10 up");
+
+	/* NS0 <-> NS1 [veth02 <-> veth20] */
+	SYS(fail, "ip link add veth02 netns " NS0 " type veth peer name veth20"
+	    " netns " NS1);
+	SYS(fail, "ip -net " NS0 " addr add " IP4_ADDR_VETH02 "/24 dev veth02");
+	SYS(fail, "ip -net " NS0 " link set dev veth02 up");
+	SYS(fail, "ip -net " NS1 " addr add " IP4_ADDR_VETH20 "/24 dev veth20");
+	SYS(fail, "ip -net " NS1 " link set dev veth20 up");
+
+	/* veth02 -> vrf1  */
+	SYS(fail, "ip -net " NS0 " link add vrf1 type vrf table 11");
+	SYS(fail, "ip -net " NS0 " route add vrf vrf1 unreachable default"
+	    " metric 4278198272");
+	SYS(fail, "ip -net " NS0 " link set vrf1 alias vrf");
+	SYS(fail, "ip -net " NS0 " link set vrf1 up");
+	SYS(fail, "ip -net " NS0 " link set veth02 master vrf1");
+
+	/* Attach TC and XDP progs to veth devices in NS0 */
+	nstoken = open_netns(NS0);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS0))
+		goto fail;
+	tc_prog_fd = bpf_program__fd(skel->progs.tc_socket_lookup);
+	if (!ASSERT_GE(tc_prog_fd, 0, "bpf_program__tc_fd"))
+		goto fail;
+	xdp_prog_fd = bpf_program__fd(skel->progs.xdp_socket_lookup);
+	if (!ASSERT_GE(xdp_prog_fd, 0, "bpf_program__xdp_fd"))
+		goto fail;
+
+	if (attach_progs("veth01", tc_prog_fd, xdp_prog_fd))
+		goto fail;
+
+	if (attach_progs("veth02", tc_prog_fd, xdp_prog_fd))
+		goto fail;
+
+	goto close;
+fail:
+	ret = -1;
+close:
+	if (nstoken)
+		close_netns(nstoken);
+	return ret;
+}
+
+static int test_lookup(struct vrf_socket_lookup *skel, int sotype,
+		       const char *ip, int port, bool test_xdp, bool tcp_skc,
+		       int lookup_status_exp)
+{
+	static const char msg[] = "Hello Server";
+	struct sockaddr_storage addr = {};
+	int fd, ret = 0;
+
+	fd = make_socket(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	skel->bss->test_xdp = test_xdp;
+	skel->bss->tcp_skc = tcp_skc;
+	skel->bss->lookup_status = -1;
+
+	if (sotype == SOCK_STREAM)
+		connect(fd, (void *)&addr, sizeof(struct sockaddr_in));
+	else
+		sendto(fd, msg, sizeof(msg), 0, (void *)&addr,
+		       sizeof(struct sockaddr_in));
+
+	if (!ASSERT_EQ(skel->bss->lookup_status, lookup_status_exp,
+		       "lookup_status"))
+		goto fail;
+
+	goto close;
+
+fail:
+	ret = -1;
+close:
+	close(fd);
+	return ret;
+}
+
+static void _test_vrf_socket_lookup(struct vrf_socket_lookup *skel, int sotype,
+				    bool test_xdp, bool tcp_skc)
+{
+	int in_vrf_server = -1, non_vrf_server = -1;
+	struct nstoken *nstoken = NULL;
+
+	nstoken = open_netns(NS0);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS0))
+		goto done;
+
+	/* Open sockets in and outside VRF */
+	non_vrf_server = make_server(sotype, "0.0.0.0", NON_VRF_PORT, NULL);
+	if (!ASSERT_GE(non_vrf_server, 0, "make_server__outside_vrf_fd"))
+		goto done;
+
+	in_vrf_server = make_server(sotype, "0.0.0.0", IN_VRF_PORT, "veth02");
+	if (!ASSERT_GE(in_vrf_server, 0, "make_server__in_vrf_fd"))
+		goto done;
+
+	/* Perform test from NS1 */
+	close_netns(nstoken);
+	nstoken = open_netns(NS1);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS1))
+		goto done;
+
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH02, NON_VRF_PORT,
+				   test_xdp, tcp_skc, 0), "in_to_out"))
+		goto done;
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH02, IN_VRF_PORT,
+				   test_xdp, tcp_skc, 1), "in_to_in"))
+		goto done;
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH01, NON_VRF_PORT,
+				   test_xdp, tcp_skc, 1), "out_to_out"))
+		goto done;
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH01, IN_VRF_PORT,
+				   test_xdp, tcp_skc, 0), "out_to_in"))
+		goto done;
+
+done:
+	if (non_vrf_server >= 0)
+		close(non_vrf_server);
+	if (in_vrf_server >= 0)
+		close(in_vrf_server);
+	if (nstoken)
+		close_netns(nstoken);
+}
+
+void test_vrf_socket_lookup(void)
+{
+	struct vrf_socket_lookup *skel;
+
+	cleanup();
+
+	skel = vrf_socket_lookup__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "vrf_socket_lookup__open_and_load"))
+		return;
+
+	if (!ASSERT_OK(setup(skel), "setup"))
+		goto done;
+
+	if (test__start_subtest("tc_socket_lookup_tcp"))
+		_test_vrf_socket_lookup(skel, SOCK_STREAM, false, false);
+	if (test__start_subtest("tc_socket_lookup_tcp_skc"))
+		_test_vrf_socket_lookup(skel, SOCK_STREAM, false, false);
+	if (test__start_subtest("tc_socket_lookup_udp"))
+		_test_vrf_socket_lookup(skel, SOCK_STREAM, false, false);
+	if (test__start_subtest("xdp_socket_lookup_tcp"))
+		_test_vrf_socket_lookup(skel, SOCK_STREAM, true, false);
+	if (test__start_subtest("xdp_socket_lookup_tcp_skc"))
+		_test_vrf_socket_lookup(skel, SOCK_STREAM, true, false);
+	if (test__start_subtest("xdp_socket_lookup_udp"))
+		_test_vrf_socket_lookup(skel, SOCK_STREAM, true, false);
+
+done:
+	vrf_socket_lookup__destroy(skel);
+	cleanup();
+}
diff --git a/tools/testing/selftests/bpf/progs/vrf_socket_lookup.c b/tools/testing/selftests/bpf/progs/vrf_socket_lookup.c
new file mode 100644
index 000000000000..26e07a252585
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/vrf_socket_lookup.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/ip.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/pkt_cls.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <stdbool.h>
+
+int lookup_status;
+bool test_xdp;
+bool tcp_skc;
+
+#define CUR_NS BPF_F_CURRENT_NETNS
+
+static void socket_lookup(void *ctx, void *data_end, void *data)
+{
+	struct ethhdr *eth = data;
+	struct bpf_sock_tuple *tp;
+	struct bpf_sock *sk;
+	struct iphdr *iph;
+	int tplen;
+
+	if (eth + 1 > data_end)
+		return;
+
+	if (eth->h_proto != bpf_htons(ETH_P_IP))
+		return;
+
+	iph = (struct iphdr *)(eth + 1);
+	if (iph + 1 > data_end)
+		return;
+
+	tp = (struct bpf_sock_tuple *)&iph->saddr;
+	tplen = sizeof(tp->ipv4);
+	if ((void *)tp + tplen > data_end)
+		return;
+
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		if (tcp_skc)
+			sk = bpf_skc_lookup_tcp(ctx, tp, tplen, CUR_NS, 0);
+		else
+			sk = bpf_sk_lookup_tcp(ctx, tp, tplen, CUR_NS, 0);
+		break;
+	case IPPROTO_UDP:
+		sk = bpf_sk_lookup_udp(ctx, tp, tplen, CUR_NS, 0);
+		break;
+	default:
+		return;
+	}
+
+	lookup_status = 0;
+
+	if (sk) {
+		bpf_sk_release(sk);
+		lookup_status = 1;
+	}
+}
+
+SEC("tc")
+int tc_socket_lookup(struct __sk_buff *skb)
+{
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+
+	if (test_xdp)
+		return TC_ACT_UNSPEC;
+
+	socket_lookup(skb, data_end, data);
+	return TC_ACT_UNSPEC;
+}
+
+SEC("xdp")
+int xdp_socket_lookup(struct xdp_md *xdp)
+{
+	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(long)xdp->data;
+
+	if (!test_xdp)
+		return XDP_PASS;
+
+	socket_lookup(xdp, data_end, data);
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

