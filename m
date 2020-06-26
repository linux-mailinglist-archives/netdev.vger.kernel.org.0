Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA7020B7B4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgFZR4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:56:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62942 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgFZR4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:56:33 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHsvG2019469
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=oUUV6RasFPK2t9GAgU36nFq/Tl+bil+0+KXK/yh16/M=;
 b=YZqEkMERokuzQvxcQqFKHMcjfzHfiF8/2w71vBNqRUhM77vkwwCjtUMH50u3S5ou3O8P
 XsvhinrNRY/ZsmsRlD+GV4ODst5paqKQI7ktSpzu0E2jX/c93QhMQDlUxMkz3k43sGTf
 lhxSgWg9z7nFd6Owe0fpUUi9Mcw59gGO5CE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1exn6j-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:29 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 48D872942E38; Fri, 26 Jun 2020 10:55:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 08/10] bpf: selftests: tcp header options
Date:   Fri, 26 Jun 2020 10:55:52 -0700
Message-ID: <20200626175552.1462421-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=15 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests for the new bpf tcp header option feature.
It tests header option writing and parsing in 3WHS, normal regular
connection establishment, fastopen, and syncookie.  In syncookie,
the passive side's bpf prog is asking the active side to resend
its bpf header option by specifying a RESEND bit in the outgoing SYNACK.
handle_active_estab() and write_nodata_opt() has some details on its
limitation.
handle_passive_estab() has comments on fastopen.

It also has test for header writing and parsing in FIN packet.

The "max_delack_ms" in bpf_test_option will be used in a latter test.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../bpf/prog_tests/tcp_hdr_options.c          | 520 ++++++++++++++
 .../bpf/progs/test_tcp_hdr_options.c          | 674 ++++++++++++++++++
 .../selftests/bpf/test_tcp_hdr_options.h      |  34 +
 3 files changed, 1228 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
new file mode 100644
index 000000000000..f8daf36783f3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#define _GNU_SOURCE
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
+#include <linux/compiler.h>
+
+#include "test_progs.h"
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+#include "test_tcp_hdr_options.h"
+#include "test_tcp_hdr_options.skel.h"
+
+#define LO_ADDR6 "::eB9F"
+#define CG_NAME "/tcpbpf-hdr-opt-test"
+
+struct bpf_test_option exp_passive_estab_in;
+struct bpf_test_option exp_active_estab_in;
+struct bpf_test_option exp_passive_fin_in;
+struct bpf_test_option exp_active_fin_in;
+struct hdr_stg exp_passive_hdr_stg;
+struct hdr_stg exp_active_hdr_stg =3D { .active =3D true, };
+
+static struct test_tcp_hdr_options *skel;
+static int lport_linum_map_fd =3D -1;
+static int hdr_stg_map_fd =3D -1;
+static int cg_fd =3D -1;
+static __u32 duration;
+
+struct sk_fds {
+	int srv_fd;
+	int passive_fd;
+	int active_fd;
+	int passive_lport;
+	int active_lport;
+};
+
+static int add_lo_addr(int family, const char *addr_str)
+{
+	char ip_addr_cmd[256];
+	int cmdlen;
+
+	if (family =3D=3D AF_INET6)
+		cmdlen =3D snprintf(ip_addr_cmd, sizeof(ip_addr_cmd),
+				  "ip -6 addr add %s/128 dev lo scope host",
+				  addr_str);
+	else
+		cmdlen =3D snprintf(ip_addr_cmd, sizeof(ip_addr_cmd),
+				  "ip addr add %s/32 dev lo",
+				  addr_str);
+
+	if (CHECK(cmdlen >=3D sizeof(ip_addr_cmd), "compile ip cmd",
+		  "failed to add host addr %s to lo. ip cmdlen is too long\n",
+		  addr_str))
+		return -1;
+
+	if (CHECK(system(ip_addr_cmd), "run ip cmd",
+		  "failed to add host addr %s to lo\n", addr_str))
+		return -1;
+
+	return 0;
+}
+
+static int create_netns(void)
+{
+	if (CHECK(unshare(CLONE_NEWNET), "create netns",
+		  "unshare(CLONE_NEWNET): %s (%d)",
+		  strerror(errno), errno))
+		return -1;
+
+	if (CHECK(system("ip link set dev lo up"), "run ip cmd",
+		  "failed to bring lo link up\n"))
+		return -1;
+
+	if (add_lo_addr(AF_INET6, LO_ADDR6))
+		return -1;
+
+	return 0;
+}
+
+static int write_sysctl(const char *sysctl, const char *value)
+{
+	int fd, err, len;
+
+	fd =3D open(sysctl, O_WRONLY);
+	if (CHECK(fd =3D=3D -1, "open sysctl", "open(%s): %s (%d)\n",
+		  sysctl, strerror(errno), errno))
+		return -1;
+
+	len =3D strlen(value);
+	err =3D write(fd, value, len);
+	close(fd);
+	if (CHECK(err !=3D len, "write sysctl",
+		  "write(%s, %s): err:%d %s (%d)\n",
+		  sysctl, value, err, strerror(errno), errno))
+		return -1;
+
+	return 0;
+}
+
+static void print_hdr_stg(const struct hdr_stg *hdr_stg, const char *pre=
fix)
+{
+	fprintf(stderr, "%s{active:%u, resend_syn:%u, syncookie:%u, fastopen:%u=
}\n",
+		prefix ? : "", hdr_stg->active, hdr_stg->resend_syn,
+		hdr_stg->syncookie, hdr_stg->fastopen);
+}
+
+static void print_option(const struct bpf_test_option *opt, const char *=
prefix)
+{
+	fprintf(stderr, "%s{flags:0x%x, max_delack_ms:%u, magic:0x%x}\n",
+		prefix ? : "", opt->flags, opt->max_delack_ms, opt->magic);
+}
+
+static void sk_fds_close(struct sk_fds *sk_fds)
+{
+	close(sk_fds->srv_fd);
+	close(sk_fds->passive_fd);
+	close(sk_fds->active_fd);
+}
+
+static int sk_fds_connect(struct sk_fds *sk_fds, bool fast_open)
+{
+	const char fast[] =3D "FAST!!!";
+	struct sockaddr_storage addr;
+	struct sockaddr_in *addr_in;
+	socklen_t len;
+
+	sk_fds->srv_fd =3D start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
+	if (CHECK(sk_fds->srv_fd =3D=3D -1, "start_server", "%s (%d)\n",
+		  strerror(errno), errno))
+		goto error;
+
+	if (fast_open)
+		sk_fds->active_fd =3D fastopen_connect(sk_fds->srv_fd, fast,
+						     sizeof(fast), 0);
+	else
+		sk_fds->active_fd =3D connect_to_fd(sk_fds->srv_fd, 0);
+
+	if (CHECK_FAIL(sk_fds->active_fd =3D=3D -1)) {
+		close(sk_fds->srv_fd);
+		goto error;
+	}
+
+	addr_in =3D (struct sockaddr_in *)&addr;
+	len =3D sizeof(addr);
+	if (CHECK(getsockname(sk_fds->srv_fd, (struct sockaddr *)&addr,
+			      &len), "getsockname(srv_fd)", "%s (%d)\n",
+		  strerror(errno), errno))
+		goto error_close;
+	sk_fds->passive_lport =3D ntohs(addr_in->sin_port);
+
+	len =3D sizeof(addr);
+	if (CHECK(getsockname(sk_fds->active_fd, (struct sockaddr *)&addr,
+			      &len), "getsockname(active_fd)", "%s (%d)\n",
+		  strerror(errno), errno))
+		goto error_close;
+	sk_fds->active_lport =3D ntohs(addr_in->sin_port);
+
+	sk_fds->passive_fd =3D accept(sk_fds->srv_fd, NULL, 0);
+	if (CHECK(sk_fds->passive_fd =3D=3D -1, "accept(srv_fd)", "%s (%d)\n",
+		  strerror(errno), errno))
+		goto error_close;
+
+	if (fast_open) {
+		char bytes_in[sizeof(fast)];
+		int ret;
+
+		ret =3D read(sk_fds->passive_fd, bytes_in, sizeof(bytes_in));
+		CHECK(ret !=3D sizeof(fast), "read fastopen syn data",
+		      "expected=3D%lu actual=3D%d\n", sizeof(fast), ret);
+		close(sk_fds->passive_fd);
+		goto error_close;
+	}
+
+	return 0;
+
+error_close:
+	close(sk_fds->active_fd);
+	close(sk_fds->srv_fd);
+
+error:
+	memset(sk_fds, -1, sizeof(*sk_fds));
+	return -1;
+}
+
+static int check_hdr_opt(const struct bpf_test_option *exp,
+			 const struct bpf_test_option *act,
+			 const char *hdr_desc)
+{
+	if (CHECK(memcmp(exp, act, sizeof(*exp)),
+		  "expected-vs-actual", "unexpected %s\n", hdr_desc)) {
+		print_option(exp, "expected: ");
+		print_option(act, "  actual: ");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int check_hdr_stg(const struct hdr_stg *exp, int fd,
+			 const char *stg_desc)
+{
+	struct hdr_stg act;
+
+	if (CHECK(bpf_map_lookup_elem(hdr_stg_map_fd, &fd, &act),
+		  "map_lookup(hdr_stg_map_fd)", "%s %s (%d)\n",
+		  stg_desc, strerror(errno), errno))
+		return -1;
+
+	if (CHECK(memcmp(exp, &act, sizeof(*exp)),
+		  "expected-vs-actual", "unexpected %s\n", stg_desc)) {
+		print_hdr_stg(exp, "expected: ");
+		print_hdr_stg(&act, "  actual: ");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int check_error_linum(const struct sk_fds *sk_fds)
+{
+	unsigned int linum, nr_errors =3D 0;
+	int lport =3D -1;
+
+	if (!bpf_map_lookup_elem(lport_linum_map_fd, &lport, &linum)) {
+		fprintf(stderr,
+			"bpf prog error out at lport:<unknown> linum:%u\n",
+			linum);
+		nr_errors++;
+	}
+
+	lport =3D sk_fds->passive_lport;
+	if (!bpf_map_lookup_elem(lport_linum_map_fd, &lport, &linum)) {
+		fprintf(stderr,
+			"bpf prog error out at lport:passive(%d), linum:%u\n",
+			lport, linum);
+		nr_errors++;
+	}
+
+	lport =3D sk_fds->active_lport;
+	if (!bpf_map_lookup_elem(lport_linum_map_fd, &lport, &linum)) {
+		fprintf(stderr,
+			"bpf prog error out at lport:active(%d), linum:%u\n",
+			lport, linum);
+		nr_errors++;
+	}
+
+	return nr_errors;
+}
+
+static void check_exp_and_close_fds(struct sk_fds *sk_fds)
+{
+	int ret, abyte;
+
+	if (check_hdr_stg(&exp_passive_hdr_stg, sk_fds->passive_fd,
+			  "passive_hdr_stg"))
+		goto check_linum;
+
+	if (check_hdr_stg(&exp_active_hdr_stg, sk_fds->active_fd,
+			  "active_hdr_stg"))
+		goto check_linum;
+
+	shutdown(sk_fds->active_fd, SHUT_WR);
+	ret =3D read(sk_fds->passive_fd, &abyte, sizeof(abyte));
+	if (CHECK(ret !=3D 0, "read-after-shutdown(passive_fd):",
+		  "ret:%d %s (%d)\n",
+		  ret, strerror(errno), errno))
+		goto check_linum;
+
+	shutdown(sk_fds->passive_fd, SHUT_WR);
+	ret =3D read(sk_fds->active_fd, &abyte, sizeof(abyte));
+	if (CHECK(ret !=3D 0, "read-after-shutdown(active_fd):",
+		  "ret:%d %s (%d)\n",
+		  ret, strerror(errno), errno))
+		goto check_linum;
+
+	if (check_hdr_opt(&exp_passive_estab_in, &skel->bss->passive_estab_in,
+			  "passive_estab_in"))
+		goto check_linum;
+
+	if (check_hdr_opt(&exp_active_estab_in, &skel->bss->active_estab_in,
+			  "active_estab_in"))
+		goto check_linum;
+
+	if (check_hdr_opt(&exp_passive_fin_in, &skel->bss->passive_fin_in,
+			  "passive_fin_in"))
+		goto check_linum;
+
+	check_hdr_opt(&exp_active_fin_in, &skel->bss->active_fin_in,
+		      "active_fin_in");
+
+check_linum:
+	CHECK_FAIL(check_error_linum(sk_fds));
+	sk_fds_close(sk_fds);
+}
+
+static void prepare_out(void)
+{
+	skel->bss->active_syn_out =3D exp_passive_estab_in;
+	skel->bss->passive_synack_out =3D exp_active_estab_in;
+
+	skel->bss->active_fin_out =3D exp_passive_fin_in;
+	skel->bss->passive_fin_out =3D exp_active_fin_in;
+}
+
+static void reset_test(void)
+{
+	size_t optsize =3D sizeof(struct bpf_test_option);
+	int lport, err;
+
+	memset(&skel->bss->passive_synack_out, 0, optsize);
+	memset(&skel->bss->passive_fin_out, 0, optsize);
+
+	memset(&skel->bss->passive_estab_in, 0, optsize);
+	memset(&skel->bss->passive_fin_in, 0, optsize);
+
+	memset(&skel->bss->active_syn_out, 0, optsize);
+	memset(&skel->bss->active_fin_out, 0, optsize);
+
+	memset(&skel->bss->active_estab_in, 0, optsize);
+	memset(&skel->bss->active_fin_in, 0, optsize);
+
+	memset(&exp_passive_estab_in, 0, optsize);
+	memset(&exp_active_estab_in, 0, optsize);
+	memset(&exp_passive_fin_in, 0, optsize);
+	memset(&exp_active_fin_in, 0, optsize);
+
+	memset(&exp_passive_hdr_stg, 0, sizeof(exp_passive_hdr_stg));
+	memset(&exp_active_hdr_stg, 0, sizeof(exp_active_hdr_stg));
+	exp_active_hdr_stg.active =3D true;
+
+	err =3D bpf_map_get_next_key(lport_linum_map_fd, NULL, &lport);
+	while (!err) {
+		bpf_map_delete_elem(lport_linum_map_fd, &lport);
+		err =3D bpf_map_get_next_key(lport_linum_map_fd, &lport, &lport);
+	}
+}
+
+static void fastopen_estab(void)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	exp_passive_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_passive_estab_in.magic =3D 0xfa;
+
+	exp_active_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_active_estab_in.magic =3D 0xce;
+
+	exp_passive_hdr_stg.fastopen =3D true;
+
+	prepare_out();
+
+	/* Allow fastopen without fastopen cookie */
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_fastopen", "1543"))
+		return;
+
+	link =3D bpf_program__attach_cgroup(skel->progs.estab, cg_fd);
+	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
+		  PTR_ERR(link)))
+		return;
+
+	if (sk_fds_connect(&sk_fds, true)) {
+		bpf_link__destroy(link);
+		return;
+	}
+
+	check_exp_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void syncookie_estab(void)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	exp_passive_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_passive_estab_in.magic =3D 0xfa;
+
+	exp_active_estab_in.flags =3D OPTION_F_MAGIC | OPTION_F_RESEND;
+	exp_active_estab_in.magic =3D 0xce;
+
+	exp_passive_hdr_stg.syncookie =3D true;
+	exp_active_hdr_stg.resend_syn =3D true,
+
+	prepare_out();
+
+	/* Clear the RESEND to ensure the bpf prog can learn
+	 * want_cookie and set the RESEND by itself.
+	 */
+	skel->bss->passive_synack_out.flags &=3D ~OPTION_F_RESEND;
+
+	/* Enforce syncookie mode */
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "2"))
+		return;
+
+	link =3D bpf_program__attach_cgroup(skel->progs.estab, cg_fd);
+	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
+		  PTR_ERR(link)))
+		return;
+
+	if (sk_fds_connect(&sk_fds, false)) {
+		bpf_link__destroy(link);
+		return;
+	}
+
+	check_exp_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void fin(void)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	exp_passive_fin_in.flags =3D OPTION_F_MAGIC;
+	exp_passive_fin_in.magic =3D 0xfa;
+
+	exp_active_fin_in.flags =3D OPTION_F_MAGIC;
+	exp_active_fin_in.magic =3D 0xce;
+
+	prepare_out();
+
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "1"))
+		return;
+
+	link =3D bpf_program__attach_cgroup(skel->progs.estab,
+					  cg_fd);
+	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
+		  PTR_ERR(link)))
+		return;
+
+	if (sk_fds_connect(&sk_fds, false)) {
+		bpf_link__destroy(link);
+		return;
+	}
+
+	check_exp_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void simple_estab(void)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	exp_passive_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_passive_estab_in.magic =3D 0xfa;
+
+	exp_active_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_active_estab_in.magic =3D 0xce;
+
+	prepare_out();
+
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "1"))
+		return;
+
+	link =3D bpf_program__attach_cgroup(skel->progs.estab,
+					  cg_fd);
+	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
+		  PTR_ERR(link)))
+		return;
+
+	if (sk_fds_connect(&sk_fds, false)) {
+		bpf_link__destroy(link);
+		return;
+	}
+
+	check_exp_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+struct test {
+	const char *desc;
+	void (*run)(void);
+};
+
+#define DEF_TEST(name) { #name, name }
+static struct test tests[] =3D {
+	DEF_TEST(simple_estab),
+	DEF_TEST(syncookie_estab),
+	DEF_TEST(fastopen_estab),
+	DEF_TEST(fin),
+};
+
+void test_tcp_hdr_options(void)
+{
+	int i;
+
+	skel =3D test_tcp_hdr_options__open_and_load();
+	if (CHECK(!skel, "open and load skel", "failed"))
+		return;
+
+	hdr_stg_map_fd =3D bpf_map__fd(skel->maps.hdr_stg_map);
+	lport_linum_map_fd =3D bpf_map__fd(skel->maps.lport_linum_map);
+
+	cg_fd =3D test__join_cgroup(CG_NAME);
+	if (CHECK_FAIL(cg_fd < 0)) {
+		test_tcp_hdr_options__destroy(skel);
+		return;
+	}
+
+	for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
+		if (!test__start_subtest(tests[i].desc))
+			continue;
+
+		if (create_netns())
+			break;
+
+		tests[i].run();
+
+		reset_test();
+	}
+
+	close(cg_fd);
+	test_tcp_hdr_options__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
new file mode 100644
index 000000000000..631181bfb4cc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
@@ -0,0 +1,674 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <stddef.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/tcp.h>
+#include <linux/socket.h>
+#include <linux/bpf.h>
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include "test_tcp_hdr_options.h"
+
+#define TCPHDR_FIN 0x01
+#define TCPHDR_SYN 0x02
+#define TCPHDR_RST 0x04
+#define TCPHDR_PSH 0x08
+#define TCPHDR_ACK 0x10
+#define TCPHDR_URG 0x20
+#define TCPHDR_ECE 0x40
+#define TCPHDR_CWR 0x80
+#define TCPHDR_SYNACK (TCPHDR_SYN | TCPHDR_ACK)
+
+#define CG_OK	1
+#define CG_ERR	0
+
+#ifndef SOL_TCP
+#define SOL_TCP 6
+#endif
+
+#define MAX_TCPHDR_SIZE 60
+
+#ifndef sizeof_field
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+#endif
+
+const __u8 option_len[] =3D {
+	[OPTION_RESEND]		=3D 0,
+	[OPTION_MAX_DELACK_MS]	=3D sizeof_field(struct bpf_test_option,
+					       max_delack_ms),
+	[OPTION_MAGIC]		=3D sizeof_field(struct bpf_test_option, magic),
+};
+
+struct tcp_bpf_expopt {
+	__u8 kind;
+	__u8 len;
+	__u16 magic;
+	__u8 data[16];	/* <-- bpf prog can only write into this area */
+};
+
+#define TCP_BPF_EXPOPT_BASE_LEN 4
+
+struct bpf_test_option passive_synack_out =3D {};
+struct bpf_test_option passive_fin_out	=3D {};
+
+struct bpf_test_option passive_estab_in =3D {};
+struct bpf_test_option passive_fin_in	=3D {};
+
+struct bpf_test_option active_syn_out	=3D {};
+struct bpf_test_option active_fin_out	=3D {};
+
+struct bpf_test_option active_estab_in	=3D {};
+struct bpf_test_option active_fin_in	=3D {};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct hdr_stg);
+} hdr_stg_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 3);
+	__type(key, int);
+	__type(value, unsigned int);
+} lport_linum_map SEC(".maps");
+
+#define RET_CG_ERR(skops) ({			\
+	struct bpf_sock *tmp_sk =3D skops->sk;	\
+	__u32 linum =3D __LINE__;			\
+	int lport;				\
+						\
+	if (!skops->sk)	{			\
+		lport =3D -1;			\
+		bpf_map_update_elem(&lport_linum_map, &lport, &linum, BPF_NOEXIST); \
+		clear_hdr_cb_flags(skops);	\
+		return CG_ERR;			\
+	}					\
+									\
+	lport =3D skops->sk->src_port;					\
+	bpf_map_update_elem(&lport_linum_map, &lport, &linum, BPF_NOEXIST); \
+	clear_hdr_cb_flags(skops);					\
+	return CG_ERR;							\
+})
+
+static __always_inline void
+clear_hdr_cb_flags(struct bpf_sock_ops *skops)
+{
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags &
+				  ~(BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG |
+				    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG));
+}
+
+static __always_inline void
+set_hdr_cb_flags(struct bpf_sock_ops *skops)
+{
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags |
+				  BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG |
+				  BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
+}
+
+static __always_inline __u32 skops_avail_len(const struct bpf_sock_ops *=
skops)
+{
+	return skops->args[0];
+}
+
+static __always_inline __u32 skops_want_cookie(const struct bpf_sock_ops=
 *skops)
+{
+	return skops->args[1];
+}
+
+static __always_inline __u8 skops_tcp_flags(const struct bpf_sock_ops *s=
kops)
+{
+	return skops->skb_tcp_flags;
+}
+
+static __always_inline unsigned int tcp_hdrlen(struct tcphdr *th)
+{
+	return th->doff * 4;
+}
+
+static __always_inline __u8 option_total_len(__u8 flags)
+{
+	__u8 i, len =3D sizeof_field(struct bpf_test_option, flags);
+
+	if (!flags)
+		return 0;
+
+	for (i =3D 0; i < __NR_OPTION_FLAGS; i++) {
+		if (TEST_OPTION_FLAGS(flags, i))
+			len +=3D option_len[i];
+	}
+
+	return len;
+}
+
+static __always_inline int write_option(struct bpf_sock_ops *skops,
+					struct bpf_test_option *opt)
+{
+	__u8 flags =3D opt->flags;
+	__u8 offset =3D 0;
+	int err;
+
+	err =3D bpf_store_hdr_opt(skops, 0, &opt->flags, sizeof(opt->flags), 0)=
;
+	if (err)
+		RET_CG_ERR(skops);
+	offset +=3D sizeof(opt->flags);
+
+	if (TEST_OPTION_FLAGS(flags, OPTION_MAX_DELACK_MS)) {
+		err =3D bpf_store_hdr_opt(skops, offset, &opt->max_delack_ms,
+					sizeof(opt->max_delack_ms), 0);
+		if (err)
+			RET_CG_ERR(skops);
+		offset +=3D sizeof(opt->max_delack_ms);
+	}
+
+	if (TEST_OPTION_FLAGS(flags, OPTION_MAGIC)) {
+		err =3D bpf_store_hdr_opt(skops, offset, &opt->magic,
+					sizeof(opt->magic), 0);
+		if (err)
+			RET_CG_ERR(skops);
+		offset +=3D sizeof(opt->magic);
+	}
+
+	return CG_OK;
+}
+
+static __always_inline int parse_option(struct bpf_test_option *opt,
+					__u8 *start, __u8 *hdr_end)
+{
+	__u8 flags;
+
+	if (start + sizeof(opt->flags) > hdr_end)
+		return -EINVAL;
+
+	flags =3D *start;
+	opt->flags =3D flags;
+	start +=3D sizeof(opt->flags);
+
+	if (TEST_OPTION_FLAGS(flags, OPTION_MAX_DELACK_MS)) {
+		if (start + sizeof(opt->max_delack_ms) > hdr_end)
+			return -EINVAL;
+		opt->max_delack_ms =3D *(typeof(opt->max_delack_ms) *)start;
+		start +=3D sizeof(opt->max_delack_ms);
+	}
+
+	if (TEST_OPTION_FLAGS(flags, OPTION_MAGIC)) {
+		if (start + sizeof(opt->magic) > hdr_end)
+			return -EINVAL;
+		opt->magic =3D *(typeof(opt->magic) *)start;
+		start +=3D sizeof(opt->magic);
+	}
+
+	return 0;
+}
+
+static __always_inline int synack_opt_len(struct bpf_sock_ops *skops)
+{
+	__u8 avail =3D skops_avail_len(skops);
+	__u8 exp_kind, flags, optlen;
+	int err;
+
+	if (!passive_synack_out.flags)
+		return CG_OK;
+
+	err =3D bpf_getsockopt(skops, SOL_TCP, TCP_BPF_SYN_HDR_OPT,
+			     &exp_kind, sizeof(exp_kind));
+
+	/* ENOSPC:
+	 * BPF header option is found but not enough
+	 * space to copy everything and it is because
+	 * we intentionally only get the "kind" byte.
+	 *
+	 * All we want to learn here is the SYN pkt contains
+	 * the bpf header option before we proceed to write
+	 * the options in the outgoing SYNACK pkt.
+	 */
+	if (err !=3D -ENOSPC)
+		return CG_OK;
+
+	flags =3D passive_synack_out.flags;
+	if (skops_want_cookie(skops))
+		SET_OPTION_FLAGS(flags, OPTION_RESEND);
+
+	optlen =3D option_total_len(flags);
+	if (optlen > avail)
+		RET_CG_ERR(skops);
+
+	if (optlen && bpf_reserve_hdr_opt(skops, optlen, 0))
+		RET_CG_ERR(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int write_synack_opt(struct bpf_sock_ops *skops)
+{
+	struct bpf_test_option opt;
+	__u8 exp_kind;
+	int err;
+
+	if (!passive_synack_out.flags)
+		/* We should not even be called since no header
+		 * space has been reserved.
+		 */
+		RET_CG_ERR(skops);
+
+	err =3D bpf_getsockopt(skops, SOL_TCP, TCP_BPF_SYN_HDR_OPT,
+			     &exp_kind, sizeof(exp_kind));
+
+	if (err !=3D -ENOSPC)
+		RET_CG_ERR(skops);
+
+	opt =3D passive_synack_out;
+	if (skops_want_cookie(skops))
+		SET_OPTION_FLAGS(opt.flags, OPTION_RESEND);
+
+	return write_option(skops, &opt);
+}
+
+static __always_inline int syn_opt_len(struct bpf_sock_ops *skops)
+{
+	__u8 avail =3D skops_avail_len(skops);
+	__u8 optlen;
+
+	if (!active_syn_out.flags)
+		return CG_OK;
+
+	optlen =3D option_total_len(active_syn_out.flags);
+	if (optlen > avail)
+		RET_CG_ERR(skops);
+
+	if (optlen && bpf_reserve_hdr_opt(skops, optlen, 0))
+		RET_CG_ERR(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int write_syn_opt(struct bpf_sock_ops *skops)
+{
+	if (!active_syn_out.flags)
+		return CG_OK;
+
+	return write_option(skops, &active_syn_out);
+}
+
+static __always_inline int fin_opt_len(struct bpf_sock_ops *skops)
+{
+	__u8 avail =3D skops_avail_len(skops);
+	struct bpf_test_option *opt;
+	struct hdr_stg *hdr_stg;
+	__u8 optlen;
+
+	if (!skops->sk)
+		RET_CG_ERR(skops);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(skops);
+
+	if (hdr_stg->active)
+		opt =3D &active_fin_out;
+	else
+		opt =3D &passive_fin_out;
+
+	optlen =3D option_total_len(opt->flags);
+	if (optlen > avail)
+		RET_CG_ERR(skops);
+
+	if (optlen && bpf_reserve_hdr_opt(skops, optlen, 0))
+		RET_CG_ERR(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int write_fin_opt(struct bpf_sock_ops *skops)
+{
+	struct bpf_test_option *opt;
+	struct hdr_stg *hdr_stg;
+
+	if (!skops->sk)
+		RET_CG_ERR(skops);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(skops);
+
+	return write_option(skops, hdr_stg->active ?
+			    &active_fin_out : &passive_fin_out);
+}
+
+static __always_inline int nodata_opt_len(struct bpf_sock_ops *skops)
+{
+	struct hdr_stg *hdr_stg;
+
+	if (!skops->sk)
+		RET_CG_ERR(skops);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(skops);
+
+	if (hdr_stg->resend_syn)
+		return syn_opt_len(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int write_nodata_opt(struct bpf_sock_ops *skops)
+{
+	struct hdr_stg *hdr_stg;
+
+	if (!skops->sk)
+		RET_CG_ERR(skops);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(skops);
+
+	if (hdr_stg->resend_syn) {
+		int ret =3D write_syn_opt(skops);
+
+		/* Passive server side is in syncookie mode and
+		 * ask us (the active connect side) to resend
+		 * the header option.
+		 *
+		 * We resend it here in the last ack of 3WHS and
+		 * then clear the cb_flags so that we will not
+		 * be called to write the options again.
+		 * This strategy is considered best effort
+		 * because this ack could be lost.
+		 *
+		 * In practice, the active side bpf prog can also
+		 * select to keep sending the options until the
+		 * first data/ack packet is received from the
+		 * passive side.
+		 */
+		clear_hdr_cb_flags(skops);
+
+		return ret;
+	}
+
+	return CG_OK;
+}
+
+static __always_inline int data_opt_len(struct bpf_sock_ops *skops)
+{
+	return CG_OK;
+}
+
+static __always_inline int write_data_opt(struct bpf_sock_ops *skops)
+{
+	return CG_OK;
+}
+
+static __always_inline int current_mss_opt_len(struct bpf_sock_ops *skop=
s)
+{
+	/* Reserve maximum that may be needed */
+	if (bpf_reserve_hdr_opt(skops, sizeof(struct bpf_test_option), 0))
+		RET_CG_ERR(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int handle_hdr_opt_len(struct bpf_sock_ops *skops=
)
+{
+	__u8 tcp_flags =3D skops_tcp_flags(skops);
+
+	if ((tcp_flags & TCPHDR_SYNACK) =3D=3D TCPHDR_SYNACK)
+		return synack_opt_len(skops);
+
+	if (tcp_flags & TCPHDR_SYN)
+		return syn_opt_len(skops);
+
+	if (tcp_flags & TCPHDR_FIN)
+		return fin_opt_len(skops);
+
+	if (!skops->skb_data)
+		/* The kernel is calculating the MSS */
+		return current_mss_opt_len(skops);
+
+	if (skops->skb_len)
+		return data_opt_len(skops);
+
+	return nodata_opt_len(skops);
+}
+
+static __always_inline int handle_write_hdr_opt(struct bpf_sock_ops *sko=
ps)
+{
+	__u8 tcp_flags =3D skops_tcp_flags(skops);
+	struct tcphdr *th;
+	int err;
+
+	if ((tcp_flags & TCPHDR_SYNACK) =3D=3D TCPHDR_SYNACK)
+		return write_synack_opt(skops);
+
+	if (tcp_flags & TCPHDR_SYN)
+		return write_syn_opt(skops);
+
+	if (tcp_flags & TCPHDR_FIN)
+		return write_fin_opt(skops);
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(skops);
+
+	if (skops->skb_len > tcp_hdrlen(th))
+		return write_data_opt(skops);
+
+	return write_nodata_opt(skops);
+}
+
+static __always_inline int handle_active_estab(struct bpf_sock_ops *skop=
s)
+{
+	__u8 bpf_hdr_opt_off =3D skops->skb_bpf_hdr_opt_off;
+	struct hdr_stg *stg, init_stg =3D {
+		.active =3D true,
+	};
+	__u8 *start;
+	int err;
+
+	if (!bpf_hdr_opt_off)
+		goto update_sk_stg;
+
+	/* Bound the "start" reg->umax_value in the verifier */
+	if (bpf_hdr_opt_off >=3D MAX_TCPHDR_SIZE)
+		RET_CG_ERR(skops);
+
+	start =3D skops->skb_data;
+	start +=3D bpf_hdr_opt_off;
+
+	if (start + TCP_BPF_EXPOPT_BASE_LEN > skops->skb_data_end)
+		RET_CG_ERR(skops);
+
+	start +=3D TCP_BPF_EXPOPT_BASE_LEN;
+	err =3D parse_option(&active_estab_in, start, skops->skb_data_end);
+
+	if (err)
+		RET_CG_ERR(skops);
+
+update_sk_stg:
+	init_stg.resend_syn =3D TEST_OPTION_FLAGS(active_estab_in.flags,
+						OPTION_RESEND);
+	if (!skops->sk || !bpf_sk_storage_get(&hdr_stg_map, skops->sk,
+					      &init_stg,
+					      BPF_SK_STORAGE_GET_F_CREATE))
+		RET_CG_ERR(skops);
+
+	if (!init_stg.resend_syn && !active_fin_out.flags)
+		/* No options will be written from now */
+		clear_hdr_cb_flags(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int handle_passive_estab(struct bpf_sock_ops *sko=
ps)
+{
+	struct tcp_bpf_expopt expopt;
+	struct hdr_stg *hdr_stg;
+	bool syncookie =3D false;
+	__u8 *start, *end, len;
+	struct tcphdr *th;
+	int err;
+
+	err =3D bpf_getsockopt(skops, SOL_TCP, TCP_BPF_SYN_HDR_OPT, &expopt,
+			     sizeof(expopt));
+	/* ENOMSG: no bpf hdr opt in the saved syn pkt
+	 * ENOENT: no saved syn (syncookie mode)
+	 */
+	if (err && err !=3D -ENOMSG && err !=3D -ENOENT)
+		RET_CG_ERR(skops);
+
+	if (err) {
+		__u8 bpf_hdr_opt_off =3D skops->skb_bpf_hdr_opt_off;
+
+		/* No bpf hdr option in SYN.  We were in syncookie
+		 * mode, so try to find it in ACK.
+		 */
+
+		/* No bpf hdr option in ACK either */
+		if (!bpf_hdr_opt_off)
+			goto update_sk_stg;
+
+		if (bpf_hdr_opt_off >=3D MAX_TCPHDR_SIZE)
+			RET_CG_ERR(skops);
+
+		start =3D skops->skb_data;
+		start +=3D bpf_hdr_opt_off;
+
+		if (start + TCP_BPF_EXPOPT_BASE_LEN > skops->skb_data_end)
+			RET_CG_ERR(skops);
+
+		len =3D start[1] - TCP_BPF_EXPOPT_BASE_LEN;
+		start +=3D TCP_BPF_EXPOPT_BASE_LEN;
+		end =3D skops->skb_data_end;
+		syncookie =3D true;
+	} else {
+		len =3D expopt.len - TCP_BPF_EXPOPT_BASE_LEN;
+		start =3D expopt.data;
+		end =3D expopt.data + len;
+	}
+
+	if (parse_option(&passive_estab_in, start, end))
+		RET_CG_ERR(skops);
+
+update_sk_stg:
+	if (!skops->sk)
+		RET_CG_ERR(skops);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!hdr_stg)
+		RET_CG_ERR(skops);
+	hdr_stg->syncookie =3D syncookie;
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(skops);
+
+	/* Fastopen */
+	if (skops->skb_len > tcp_hdrlen(th)) {
+		/* Cannot clear cb_flags to stop write_hdr cb.
+		 * synack is not sent yet for fast open.
+		 * Even it was, the synack may need
+		 * to be retransmitted.
+		 *
+		 * The cb_flags will be cleared in
+		 * handle_parse_hdr() later.
+		 */
+		hdr_stg->fastopen =3D true;
+		return CG_OK;
+	}
+
+	if (!passive_fin_out.flags)
+		/* No options will be written from now */
+		clear_hdr_cb_flags(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int handle_parse_hdr(struct bpf_sock_ops *skops)
+{
+	struct hdr_stg *hdr_stg;
+	struct tcphdr *th;
+	__u32 cb_flags;
+
+	if (!skops->sk)
+		RET_CG_ERR(skops);
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(skops);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(skops);
+
+	if (th->fin) {
+		__u32 skb_bpf_hdr_opt_off =3D skops->skb_bpf_hdr_opt_off;
+		struct bpf_test_option *fin_opt;
+		__u8 *kind_start;
+		int ret;
+
+		if (hdr_stg->active)
+			fin_opt =3D &active_fin_in;
+		else
+			fin_opt =3D &passive_fin_in;
+
+		if (!skb_bpf_hdr_opt_off)
+			return CG_OK;
+
+		if (skb_bpf_hdr_opt_off >=3D MAX_TCPHDR_SIZE)
+			RET_CG_ERR(skops);
+
+		kind_start =3D skops->skb_data;
+		kind_start +=3D skb_bpf_hdr_opt_off;
+		if (kind_start + TCP_BPF_EXPOPT_BASE_LEN > skops->skb_data_end)
+			RET_CG_ERR(skops);
+
+		kind_start +=3D TCP_BPF_EXPOPT_BASE_LEN;
+		if (parse_option(fin_opt, kind_start, skops->skb_data_end))
+			RET_CG_ERR(skops);
+
+		return CG_OK;
+	}
+
+	return CG_OK;
+}
+
+SEC("sockops/estab")
+int estab(struct bpf_sock_ops *skops)
+{
+	int op, optlen, true_val =3D 1;
+
+	switch (skops->op) {
+	case BPF_SOCK_OPS_TCP_LISTEN_CB:
+		bpf_setsockopt(skops, SOL_TCP, TCP_SAVE_SYN,
+			       &true_val, sizeof(true_val));
+		set_hdr_cb_flags(skops);
+		break;
+	case BPF_SOCK_OPS_TCP_CONNECT_CB:
+		set_hdr_cb_flags(skops);
+		break;
+	case BPF_SOCK_OPS_PARSE_HDR_OPT_CB:
+		return handle_parse_hdr(skops);
+	case BPF_SOCK_OPS_HDR_OPT_LEN_CB:
+		return handle_hdr_opt_len(skops);
+	case BPF_SOCK_OPS_WRITE_HDR_OPT_CB:
+		return handle_write_hdr_opt(skops);
+	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
+		return handle_passive_estab(skops);
+	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
+		return handle_active_estab(skops);
+	}
+
+	return CG_OK;
+}
+
+char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/test_tcp_hdr_options.h b/tools/t=
esting/selftests/bpf/test_tcp_hdr_options.h
new file mode 100644
index 000000000000..d3a4593c81c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _TEST_TCP_HDR_OPTIONS_H
+#define _TEST_TCP_HDR_OPTIONS_H
+
+struct bpf_test_option {
+	__u8 flags;
+	__u8 max_delack_ms;
+	__u8 magic;
+};
+
+enum {
+	OPTION_RESEND,
+	OPTION_MAX_DELACK_MS,
+	OPTION_MAGIC,
+	__NR_OPTION_FLAGS,
+};
+
+#define OPTION_F_RESEND		(1 << OPTION_RESEND)
+#define OPTION_F_MAX_DELACK_MS	(1 << OPTION_MAX_DELACK_MS)
+#define OPTION_F_MAGIC		(1 << OPTION_MAGIC)
+
+#define TEST_OPTION_FLAGS(flags, option) (1 & ((flags) >> (option)))
+#define SET_OPTION_FLAGS(flags, option)	((flags) |=3D (1 << (option)))
+
+/* Store in bpf_sk_storage */
+struct hdr_stg {
+	bool active;
+	bool resend_syn; /* active side only */
+	bool syncookie;  /* passive side only */
+	bool fastopen;	/* passive side only */
+};
+
+#endif
--=20
2.24.1

