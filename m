Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5A222A443
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgGWBEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:04:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30220 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387537AbgGWBEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:04:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N10ToM028372
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:04:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8X/j7FuHd4D92pwr9XH/T22IoY6DkJ4YxDhCfpYMKlw=;
 b=OoSPIVw/3qgiXPlS03PkwAQev5DEtjQuJL0gYUy/49vhg3OdQigJZaLSKmWwfiHQogmg
 aOxabVe4Gx/ctm7CeBinSKXvvPh9RyuOJlHECXGS9GjAO1iCZJmx4c9X2MY1VKGmFAQo
 H41pZGRF1GLf/xo0OUCvKPbHa+LPhKQsQxs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32etmw9q1f-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:04:29 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 18:04:26 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id BD7A42945AD1; Wed, 22 Jul 2020 18:04:24 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 8/9] bpf: selftests: tcp header options
Date:   Wed, 22 Jul 2020 18:04:24 -0700
Message-ID: <20200723010424.1908864-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723010334.1905574-1-kafai@fb.com>
References: <20200723010334.1905574-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_17:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=15 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests for the new bpf tcp header option feature.

test_tcp_hdr_options.c:
- It tests header option writing and parsing in 3WHS, normal regular
  connection establishment, fastopen, and syncookie.
- In syncookie,   the passive side's bpf prog is asking the active side
  to resend its bpf header option by specifying a RESEND bit in the
  outgoing SYNACK.    handle_active_estab() and write_nodata_opt() has
  some details.
- handle_passive_estab() has comments on fastopen.
- It also has test for header writing and parsing in FIN packet.
- Most of test is writing an experimental option 254 with magic 0xeB9F.
- The no_exprm_estab() subtest also tests writing a regular TCP option
  without any magic.

test_misc_tcp_options.c:
- It is an one directional test.  Active side writes option and
  passive side parses option.  The purpose is to exercise
  the new helpers and API.
- tests the new helper, bpf_load_hdr_opt() and bpf_store_hdr_opt().
- It tests the bpf_getsockopt(TCP_BPF_SYN).
- That includes some negative tests for the above helpers.
- It also tests accessing the sock_ops->skb_data.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../bpf/prog_tests/tcp_hdr_options.c          | 636 +++++++++++++++++
 .../bpf/progs/test_misc_tcp_hdr_options.c     | 314 +++++++++
 .../bpf/progs/test_tcp_hdr_options.c          | 652 ++++++++++++++++++
 .../selftests/bpf/test_tcp_hdr_options.h      | 150 ++++
 4 files changed, 1752 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_o=
ptions.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
new file mode 100644
index 000000000000..c8b5aac1f511
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -0,0 +1,636 @@
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
+#include "test_misc_tcp_hdr_options.skel.h"
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
+static struct test_misc_tcp_hdr_options *misc_skel;
+static struct test_tcp_hdr_options *skel;
+static int lport_linum_map_fd;
+static int hdr_stg_map_fd;
+static __u32 duration;
+static int cg_fd;
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
+	fprintf(stderr, "%s{flags:0x%x, max_delack_ms:%u, rand:0x%x}\n",
+		prefix ? : "", opt->flags, opt->max_delack_ms, opt->rand);
+}
+
+static void sk_fds_close(struct sk_fds *sk_fds)
+{
+	close(sk_fds->srv_fd);
+	close(sk_fds->passive_fd);
+	close(sk_fds->active_fd);
+}
+
+static int sk_fds_shutdown(struct sk_fds *sk_fds)
+{
+	int ret, abyte;
+
+	shutdown(sk_fds->active_fd, SHUT_WR);
+	ret =3D read(sk_fds->passive_fd, &abyte, sizeof(abyte));
+	if (CHECK(ret !=3D 0, "read-after-shutdown(passive_fd):",
+		  "ret:%d %s (%d)\n",
+		  ret, strerror(errno), errno))
+		return -1;
+
+	shutdown(sk_fds->passive_fd, SHUT_WR);
+	ret =3D read(sk_fds->active_fd, &abyte, sizeof(abyte));
+	if (CHECK(ret !=3D 0, "read-after-shutdown(active_fd):",
+		  "ret:%d %s (%d)\n",
+		  ret, strerror(errno), errno))
+		return -1;
+
+	return 0;
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
+		if (CHECK(ret !=3D sizeof(fast), "read fastopen syn data",
+			  "expected=3D%lu actual=3D%d\n", sizeof(fast), ret)) {
+			close(sk_fds->passive_fd);
+			goto error_close;
+		}
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
+	unsigned int nr_errors =3D 0;
+	struct linum_err linum_err;
+	int lport =3D -1;
+
+	if (!bpf_map_lookup_elem(lport_linum_map_fd, &lport, &linum_err)) {
+		fprintf(stderr,
+			"bpf prog error out at lport:<unknown> linum:%u err:%d\n",
+			linum_err.linum, linum_err.err);
+		nr_errors++;
+	}
+
+	lport =3D sk_fds->passive_lport;
+	if (!bpf_map_lookup_elem(lport_linum_map_fd, &lport, &linum_err)) {
+		fprintf(stderr,
+			"bpf prog error out at lport:passive(%d), linum:%u err:%d\n",
+			lport, linum_err.linum, linum_err.err);
+		nr_errors++;
+	}
+
+	lport =3D sk_fds->active_lport;
+	if (!bpf_map_lookup_elem(lport_linum_map_fd, &lport, &linum_err)) {
+		fprintf(stderr,
+			"bpf prog error out at lport:active(%d), linum:%u err:%d\n",
+			lport, linum_err.linum, linum_err.err);
+		nr_errors++;
+	}
+
+	return nr_errors;
+}
+
+static void check_hdr_and_close_fds(struct sk_fds *sk_fds)
+{
+	if (sk_fds_shutdown(sk_fds))
+		goto check_linum;
+
+	if (check_hdr_stg(&exp_passive_hdr_stg, sk_fds->passive_fd,
+			  "passive_hdr_stg"))
+		goto check_linum;
+
+	if (check_hdr_stg(&exp_active_hdr_stg, sk_fds->active_fd,
+			  "active_hdr_stg"))
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
+	skel->data->test_kind =3D TCPOPT_EXP;
+	skel->data->test_magic =3D 0xeB9F;
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
+	hdr_stg_map_fd =3D bpf_map__fd(skel->maps.hdr_stg_map);
+	lport_linum_map_fd =3D bpf_map__fd(skel->maps.lport_linum_map);
+
+	exp_passive_estab_in.flags =3D OPTION_F_RAND | OPTION_F_MAX_DELACK_MS;
+	exp_passive_estab_in.rand =3D 0xfa;
+	exp_passive_estab_in.max_delack_ms =3D 11;
+
+	exp_active_estab_in.flags =3D OPTION_F_RAND | OPTION_F_MAX_DELACK_MS;
+	exp_active_estab_in.rand =3D 0xce;
+	exp_active_estab_in.max_delack_ms =3D 22;
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
+	check_hdr_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void syncookie_estab(void)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	hdr_stg_map_fd =3D bpf_map__fd(skel->maps.hdr_stg_map);
+	lport_linum_map_fd =3D bpf_map__fd(skel->maps.lport_linum_map);
+
+	exp_passive_estab_in.flags =3D OPTION_F_RAND | OPTION_F_MAX_DELACK_MS;
+	exp_passive_estab_in.rand =3D 0xfa;
+	exp_passive_estab_in.max_delack_ms =3D 11;
+
+	exp_active_estab_in.flags =3D OPTION_F_RAND | OPTION_F_MAX_DELACK_MS |
+					OPTION_F_RESEND;
+	exp_active_estab_in.rand =3D 0xce;
+	exp_active_estab_in.max_delack_ms =3D 22;
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
+	check_hdr_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void fin(void)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	hdr_stg_map_fd =3D bpf_map__fd(skel->maps.hdr_stg_map);
+	lport_linum_map_fd =3D bpf_map__fd(skel->maps.lport_linum_map);
+
+	exp_passive_fin_in.flags =3D OPTION_F_RAND;
+	exp_passive_fin_in.rand =3D 0xfa;
+
+	exp_active_fin_in.flags =3D OPTION_F_RAND;
+	exp_active_fin_in.rand =3D 0xce;
+
+	prepare_out();
+
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "1"))
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
+	check_hdr_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void __simple_estab(bool exprm)
+{
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+
+	hdr_stg_map_fd =3D bpf_map__fd(skel->maps.hdr_stg_map);
+	lport_linum_map_fd =3D bpf_map__fd(skel->maps.lport_linum_map);
+
+	exp_passive_estab_in.flags =3D OPTION_F_RAND | OPTION_F_MAX_DELACK_MS;
+	exp_passive_estab_in.rand =3D 0xfa;
+	exp_passive_estab_in.max_delack_ms =3D 11;
+
+	exp_active_estab_in.flags =3D OPTION_F_RAND | OPTION_F_MAX_DELACK_MS;
+	exp_active_estab_in.rand =3D 0xce;
+	exp_active_estab_in.max_delack_ms =3D 22;
+
+	prepare_out();
+
+	if (!exprm) {
+		skel->data->test_kind =3D 0xB9;
+		skel->data->test_magic =3D 0;
+	}
+
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "1"))
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
+	check_hdr_and_close_fds(&sk_fds);
+	bpf_link__destroy(link);
+}
+
+static void no_exprm_estab(void)
+{
+	__simple_estab(false);
+}
+
+static void simple_estab(void)
+{
+	__simple_estab(true);
+}
+
+static void misc(void)
+{
+	const char send_msg[] =3D "MISC!!!";
+	char recv_msg[sizeof(send_msg)];
+	const unsigned int nr_data =3D 2;
+	struct bpf_link *link;
+	struct sk_fds sk_fds;
+	int i, ret;
+
+	lport_linum_map_fd =3D bpf_map__fd(misc_skel->maps.lport_linum_map);
+
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "1"))
+		return;
+
+	link =3D bpf_program__attach_cgroup(misc_skel->progs.misc_estab, cg_fd)=
;
+	if (CHECK(IS_ERR(link), "attach_cgroup(misc_estab)", "err: %ld\n",
+		  PTR_ERR(link)))
+		return;
+
+	if (sk_fds_connect(&sk_fds, false)) {
+		bpf_link__destroy(link);
+		return;
+	}
+
+	for (i =3D 0; i < nr_data; i++) {
+		/* MSG_EOR to ensure skb will not be combined */
+		ret =3D send(sk_fds.active_fd, send_msg, sizeof(send_msg),
+			   MSG_EOR);
+		if (CHECK(ret !=3D sizeof(send_msg), "send(msg)", "ret:%d\n",
+			  ret))
+			goto check_linum;
+
+		ret =3D read(sk_fds.passive_fd, recv_msg, sizeof(recv_msg));
+		if (CHECK(ret !=3D sizeof(send_msg), "recv(msg)", "ret:%d\n",
+			  ret))
+			goto check_linum;
+	}
+
+	if (sk_fds_shutdown(&sk_fds))
+		goto check_linum;
+
+	CHECK(misc_skel->bss->nr_syn !=3D 1, "unexpected nr_syn",
+	      "expected (1) !=3D actual (%u)\n",
+		misc_skel->bss->nr_syn);
+
+	CHECK(misc_skel->bss->nr_data !=3D nr_data, "unexpected nr_data",
+	      "expected (%u) !=3D actual (%u)\n",
+	      nr_data, misc_skel->bss->nr_data);
+
+	/* The last ACK may have been delayed, so it is either 1 or 2. */
+	CHECK(misc_skel->bss->nr_pure_ack !=3D 1 &&
+	      misc_skel->bss->nr_pure_ack !=3D 2,
+	      "unexpected nr_pure_syn",
+	      "expected (1 or 2) !=3D actual (%u)\n",
+		misc_skel->bss->nr_pure_ack);
+
+	CHECK(misc_skel->bss->nr_fin !=3D 1, "unexpected nr_fin",
+	      "expected (1) !=3D actual (%u)\n",
+	      misc_skel->bss->nr_fin);
+
+check_linum:
+	CHECK_FAIL(check_error_linum(&sk_fds));
+	sk_fds_close(&sk_fds);
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
+	DEF_TEST(no_exprm_estab),
+	DEF_TEST(syncookie_estab),
+	DEF_TEST(fastopen_estab),
+	DEF_TEST(fin),
+	DEF_TEST(misc),
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
+	misc_skel =3D test_misc_tcp_hdr_options__open_and_load();
+	if (CHECK(!misc_skel, "open and load misc test skel", "failed"))
+		goto skel_destroy;
+
+	cg_fd =3D test__join_cgroup(CG_NAME);
+	if (CHECK_FAIL(cg_fd < 0))
+		goto skel_destroy;
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
+skel_destroy:
+	test_misc_tcp_hdr_options__destroy(misc_skel);
+	test_tcp_hdr_options__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.=
c b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
new file mode 100644
index 000000000000..2085234b125c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
@@ -0,0 +1,314 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <stddef.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/socket.h>
+#include <linux/bpf.h>
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#define BPF_PROG_TEST_TCP_HDR_OPTIONS
+#include "test_tcp_hdr_options.h"
+
+__u16 last_addr16_n =3D __bpf_htons(0xeB9F);
+__u16 active_lport_n =3D 0;
+__u16 active_lport_h =3D 0;
+__u16 passive_lport_n =3D 0;
+__u16 passive_lport_h =3D 0;
+
+/* options received at passive side */
+unsigned int nr_pure_ack =3D 0;
+unsigned int nr_data =3D 0;
+unsigned int nr_syn =3D 0;
+unsigned int nr_fin =3D 0;
+
+/* Check the header received from the active side */
+static __always_inline int __check_active_hdr_in(struct bpf_sock_ops *sk=
ops,
+						 bool check_syn)
+{
+	union {
+		struct tcphdr th;
+		struct ipv6hdr ip6;
+		struct tcp_exprm_opt exprm_opt;
+		struct tcp_opt reg_opt;
+		__u8 data[100]; /* IPv6 (40) + Max TCP hdr (60) */
+	} syn =3D {};
+	__u64 load_flags =3D check_syn ? BPF_LOAD_HDR_OPT_TCP_SYN : 0;
+	struct tcphdr *pth;
+	int err, ret;
+
+	syn.reg_opt.kind =3D 0xB9;
+
+	/* The option is 4 bytes long instead of 2 bytes */
+	ret =3D bpf_load_hdr_opt(skops, &syn.reg_opt, 2, load_flags);
+	if (ret !=3D -ENOSPC)
+		RET_CG_ERR(ret);
+
+	/* Test searching magic with regular kind */
+	syn.reg_opt.len =3D 4;
+	ret =3D bpf_load_hdr_opt(skops, &syn.reg_opt, sizeof(syn.reg_opt),
+			       load_flags);
+	if (ret !=3D -EINVAL)
+		RET_CG_ERR(ret);
+
+	syn.reg_opt.len =3D 0;
+	ret =3D bpf_load_hdr_opt(skops, &syn.reg_opt, sizeof(syn.reg_opt),
+			       load_flags);
+	if (ret !=3D 4)
+		RET_CG_ERR(ret);
+
+	if (!check_syn)
+		return CG_OK;
+
+	/* Test loading from skops->syn_skb if sk_state =3D=3D TCP_NEW_SYN_RECV
+	 * (i.e. skops->sk is a req. and it means it received a syn
+	 *       and writing synack).
+	 *
+	 * Test loading from tp->saved_syn for other sk_state.
+	 */
+	ret =3D bpf_getsockopt(skops, SOL_TCP, TCP_BPF_SYN_IP, &syn.ip6,
+			     sizeof(syn.ip6));
+	if (ret !=3D -ENOSPC)
+		RET_CG_ERR(ret);
+
+	if (syn.ip6.saddr.s6_addr16[7] !=3D last_addr16_n ||
+	    syn.ip6.daddr.s6_addr16[7] !=3D last_addr16_n)
+		RET_CG_ERR(0);
+
+	ret =3D bpf_getsockopt(skops, SOL_TCP, TCP_BPF_SYN_IP, &syn, sizeof(syn=
));
+	if (ret < 0)
+		RET_CG_ERR(ret);
+
+	pth =3D (struct tcphdr *)(&syn.ip6 + 1);
+	if (pth->dest !=3D passive_lport_n || pth->source !=3D active_lport_n)
+		RET_CG_ERR(0);
+
+	/* Test skops->syn_skb with TCP_BPF_SYN */
+	ret =3D bpf_getsockopt(skops, SOL_TCP, TCP_BPF_SYN, &syn, sizeof(syn));
+	if (ret < 0)
+		RET_CG_ERR(ret);
+
+	if (syn.th.dest !=3D passive_lport_n || syn.th.source !=3D active_lport=
_n)
+		RET_CG_ERR(0);
+
+	return CG_OK;
+}
+
+static __always_inline int check_active_syn_in(struct bpf_sock_ops *skop=
s)
+{
+	return __check_active_hdr_in(skops, true);
+}
+
+static __always_inline int check_active_hdr_in(struct bpf_sock_ops *skop=
s)
+{
+	struct tcphdr *th;
+
+	if (__check_active_hdr_in(skops, false) =3D=3D CG_ERR)
+		return CG_ERR;
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(0);
+
+	if (tcp_hdrlen(th) < skops->skb_len)
+		nr_data++;
+
+	if (th->fin)
+		nr_fin++;
+
+	if (th->ack && !th->fin && tcp_hdrlen(th) =3D=3D skops->skb_len)
+		nr_pure_ack++;
+
+	return CG_OK;
+}
+
+static __always_inline int active_opt_len(struct bpf_sock_ops *skops)
+{
+	int err;
+
+	/* Reserve more than enough to allow the -EEXIST test in
+	 * the write_active_opt().
+	 */
+	err =3D bpf_reserve_hdr_opt(skops, 12, 0);
+	if (err)
+		RET_CG_ERR(err);
+
+	return CG_OK;
+}
+
+static __always_inline int write_active_opt(struct bpf_sock_ops *skops)
+{
+	struct tcp_exprm_opt exprm_opt =3D {};
+	struct tcp_opt win_scale_opt =3D {};
+	struct tcp_opt reg_opt =3D {};
+	struct tcphdr *th;
+	int err, ret;
+
+	exprm_opt.kind =3D TCPOPT_EXP;
+	exprm_opt.len =3D 4;
+	exprm_opt.magic =3D __bpf_htons(0xeB9F);
+
+	reg_opt.kind =3D 0xB9;
+	reg_opt.len =3D 4;
+	reg_opt.data[0] =3D 0xfa;
+	reg_opt.data[1] =3D 0xce;
+
+	win_scale_opt.kind =3D TCPOPT_WINDOW;
+
+	err =3D bpf_store_hdr_opt(skops, &exprm_opt, sizeof(exprm_opt), 0);
+	if (err)
+		RET_CG_ERR(err);
+
+	/* Store the same exprm option */
+	err =3D bpf_store_hdr_opt(skops, &exprm_opt, sizeof(exprm_opt), 0);
+	if (err !=3D -EEXIST)
+		RET_CG_ERR(err);
+
+	err =3D bpf_store_hdr_opt(skops, &reg_opt, sizeof(reg_opt), 0);
+	if (err)
+		RET_CG_ERR(err);
+	err =3D bpf_store_hdr_opt(skops, &reg_opt, sizeof(reg_opt), 0);
+	if (err !=3D -EEXIST)
+		RET_CG_ERR(err);
+
+	/* Check the option has been written and can be searched */
+	ret =3D bpf_load_hdr_opt(skops, &exprm_opt, sizeof(exprm_opt), 0);
+	if (ret !=3D 4 || exprm_opt.len !=3D 4 || exprm_opt.kind !=3D TCPOPT_EX=
P ||
+	    exprm_opt.magic !=3D __bpf_htons(0xeB9F))
+		RET_CG_ERR(ret);
+
+	reg_opt.len =3D 0;
+	ret =3D bpf_load_hdr_opt(skops, &reg_opt, sizeof(reg_opt), 0);
+	if (ret !=3D 4 || reg_opt.len !=3D 4 || reg_opt.kind !=3D 0xB9 ||
+	    reg_opt.data[0] !=3D 0xfa || reg_opt.data[1] !=3D 0xce)
+		RET_CG_ERR(ret);
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(0);
+
+	if (th->syn) {
+		active_lport_h =3D skops->local_port;
+		active_lport_n =3D th->source;
+
+		/* Search the win scale option written by kernel
+		 * in the SYN packet.
+		 */
+		ret =3D bpf_load_hdr_opt(skops, &win_scale_opt,
+				       sizeof(win_scale_opt), 0);
+		if (ret !=3D 3 || win_scale_opt.len !=3D 3 ||
+		    win_scale_opt.kind !=3D TCPOPT_WINDOW)
+			RET_CG_ERR(ret);
+
+		/* Write the win scale option that kernel
+		 * has already written.
+		 */
+		err =3D bpf_store_hdr_opt(skops, &win_scale_opt,
+					sizeof(win_scale_opt), 0);
+		if (err !=3D -EEXIST)
+			RET_CG_ERR(err);
+	}
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
+		/* Check the SYN from bpf_sock_ops_kern->syn_skb */
+		return check_active_syn_in(skops);
+
+	/* Passive side should have cleared the write hdr cb by now */
+	if (skops->local_port =3D=3D passive_lport_h)
+		RET_CG_ERR(0);
+
+	return active_opt_len(skops);
+}
+
+static __always_inline int handle_write_hdr_opt(struct bpf_sock_ops *sko=
ps)
+{
+	__u8 tcp_flags =3D skops_tcp_flags(skops);
+
+	/* Hdr space has not been reserved on passive-side in
+	 * handle_hdr_opt_len(), so we should not have been called.
+	 */
+	if ((tcp_flags & TCPHDR_SYNACK) =3D=3D TCPHDR_SYNACK)
+		RET_CG_ERR(0);
+
+	if (skops->local_port =3D=3D passive_lport_h)
+		RET_CG_ERR(0);
+
+	return write_active_opt(skops);
+}
+
+static __always_inline int handle_parse_hdr(struct bpf_sock_ops *skops)
+{
+	struct bpf_sock *sk =3D skops->sk;
+
+	/* Passive side is not writing any non-standard/unknown
+	 * option, so the active side should never be called.
+	 */
+	if (skops->local_port =3D=3D active_lport_h)
+		RET_CG_ERR(0);
+
+	return check_active_hdr_in(skops);
+}
+
+static __always_inline int handle_passive_estab(struct bpf_sock_ops *sko=
ps)
+{
+	int err;
+
+	/* No more write hdr cb */
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags &
+				  ~BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
+
+	/* Recheck the SYN but check the tp->saved_syn this time */
+	err =3D check_active_syn_in(skops);
+	if (err =3D=3D CG_ERR)
+		return err;
+
+	nr_syn++;
+
+	/* The ack has header option written by the active side also */
+	return check_active_hdr_in(skops);
+}
+
+SEC("sockops/misc_estab")
+int misc_estab(struct bpf_sock_ops *skops)
+{
+	int op, optlen, true_val =3D 1;
+
+	switch (skops->op) {
+	case BPF_SOCK_OPS_TCP_LISTEN_CB:
+		passive_lport_h =3D skops->local_port;
+		passive_lport_n =3D __bpf_htons(passive_lport_h);
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
+	}
+
+	return CG_OK;
+}
+
+char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
new file mode 100644
index 000000000000..9b153973f445
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
@@ -0,0 +1,652 @@
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
+#define BPF_PROG_TEST_TCP_HDR_OPTIONS
+#include "test_tcp_hdr_options.h"
+
+#ifndef sizeof_field
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+#endif
+
+__u8 test_kind =3D TCPOPT_EXP;
+__u16 test_magic =3D 0xeB9F;
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
+static __always_inline __u32 skops_want_cookie(const struct bpf_sock_ops=
 *skops)
+{
+	return skops->args[0];
+}
+
+static __always_inline __u8 option_total_len(__u8 flags)
+{
+	__u8 i, len =3D 1; /* +1 for flags */
+
+	if (!flags)
+		return 0;
+
+	/* RESEND bit does not use a byte */
+	for (i =3D OPTION_RESEND + 1; i < __NR_OPTION_FLAGS; i++)
+		len +=3D !!TEST_OPTION_FLAGS(flags, i);
+
+	if (test_kind =3D=3D TCPOPT_EXP)
+		return len + TCP_BPF_EXPOPT_BASE_LEN;
+	else
+		return len + 2;
+}
+
+static __always_inline
+void write_test_option(const struct bpf_test_option *test_opt,
+		       __u8 *data)
+{
+	__u8 offset =3D 0;
+
+	data[offset++] =3D test_opt->flags;
+	if (TEST_OPTION_FLAGS(test_opt->flags, OPTION_MAX_DELACK_MS))
+		data[offset++] =3D test_opt->max_delack_ms;
+
+	if (TEST_OPTION_FLAGS(test_opt->flags, OPTION_RAND))
+		data[offset++] =3D test_opt->rand;
+}
+
+static __always_inline int store_option(struct bpf_sock_ops *skops,
+					const struct bpf_test_option *test_opt)
+{
+	union {
+		struct tcp_exprm_opt exprm;
+		struct tcp_opt regular;
+	} write_opt;
+	__u8 flags =3D test_opt->flags, offset =3D 0;
+	__u8 *data;
+	int err;
+
+	if (test_kind =3D=3D TCPOPT_EXP) {
+		write_opt.exprm.kind =3D TCPOPT_EXP;
+		write_opt.exprm.len =3D option_total_len(test_opt->flags);
+		write_opt.exprm.magic =3D __bpf_htons(test_magic);
+		write_opt.exprm.data32 =3D 0;
+		write_test_option(test_opt, write_opt.exprm.data);
+		err =3D bpf_store_hdr_opt(skops, &write_opt.exprm,
+					sizeof(write_opt.exprm), 0);
+	} else {
+		write_opt.regular.kind =3D test_kind;
+		write_opt.regular.len =3D option_total_len(test_opt->flags);
+		write_opt.regular.data32 =3D 0;
+		write_test_option(test_opt, write_opt.regular.data);
+		err =3D bpf_store_hdr_opt(skops, &write_opt.regular,
+					sizeof(write_opt.regular), 0);
+	}
+
+	if (err)
+		RET_CG_ERR(err);
+
+	return CG_OK;
+}
+
+static __always_inline int parse_test_option(struct bpf_test_option *opt=
,
+					     const __u8 *start, const __u8 *end)
+{
+	__u8 flags;
+
+	if (start + sizeof(opt->flags) > end)
+		return -EINVAL;
+
+	flags =3D *start;
+	opt->flags =3D flags;
+	start +=3D sizeof(opt->flags);
+
+	if (TEST_OPTION_FLAGS(flags, OPTION_MAX_DELACK_MS)) {
+		if (start + sizeof(opt->max_delack_ms) > end)
+			return -EINVAL;
+		opt->max_delack_ms =3D *(typeof(opt->max_delack_ms) *)start;
+		start +=3D sizeof(opt->max_delack_ms);
+	}
+
+	if (TEST_OPTION_FLAGS(flags, OPTION_RAND)) {
+		if (start + sizeof(opt->rand) > end)
+			return -EINVAL;
+		opt->rand =3D *(typeof(opt->rand) *)start;
+		start +=3D sizeof(opt->rand);
+	}
+
+	return 0;
+}
+
+static __always_inline int load_option(struct bpf_sock_ops *skops,
+				       struct bpf_test_option *test_opt,
+				       bool from_syn)
+{
+	union {
+		struct tcp_exprm_opt exprm;
+		struct tcp_opt regular;
+	} search_opt;
+	int ret, load_flags =3D from_syn ? BPF_LOAD_HDR_OPT_TCP_SYN : 0;
+
+	if (test_kind =3D=3D TCPOPT_EXP) {
+		search_opt.exprm.kind =3D TCPOPT_EXP;
+		search_opt.exprm.len =3D 4;
+		search_opt.exprm.magic =3D __bpf_htons(test_magic);
+		search_opt.exprm.data32 =3D 0;
+		ret =3D bpf_load_hdr_opt(skops, &search_opt.exprm,
+				       sizeof(search_opt.exprm), load_flags);
+		if (ret < 0)
+			return ret;
+		return parse_test_option(test_opt, search_opt.exprm.data,
+					 search_opt.exprm.data +
+					 sizeof(search_opt.exprm.data));
+	} else {
+		search_opt.regular.kind =3D test_kind;
+		search_opt.regular.len =3D 0;
+		search_opt.regular.data32 =3D 0;
+		ret =3D bpf_load_hdr_opt(skops, &search_opt.regular,
+				       sizeof(search_opt.regular), load_flags);
+		if (ret < 0)
+			return ret;
+		return parse_test_option(test_opt, search_opt.regular.data,
+					 search_opt.regular.data +
+					 sizeof(search_opt.regular.data));
+	}
+}
+
+static __always_inline int synack_opt_len(struct bpf_sock_ops *skops)
+{
+	struct bpf_test_option test_opt =3D {};
+	__u8 optlen, flags;
+	int err;
+
+	if (!passive_synack_out.flags)
+		return CG_OK;
+
+	err =3D load_option(skops, &test_opt, true);
+
+	/* bpf_test_option is not found */
+	if (err =3D=3D -ENOMSG)
+		return CG_OK;
+
+	if (err)
+		RET_CG_ERR(err);
+
+	flags =3D passive_synack_out.flags;
+	if (skops_want_cookie(skops))
+		SET_OPTION_FLAGS(flags, OPTION_RESEND);
+
+	optlen =3D option_total_len(flags);
+	if (optlen) {
+		err =3D bpf_reserve_hdr_opt(skops, optlen, 0);
+		if (err)
+			RET_CG_ERR(err);
+	}
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
+		RET_CG_ERR(0);
+
+	opt =3D passive_synack_out;
+	if (skops_want_cookie(skops))
+		SET_OPTION_FLAGS(opt.flags, OPTION_RESEND);
+
+	return store_option(skops, &opt);
+}
+
+static __always_inline int syn_opt_len(struct bpf_sock_ops *skops)
+{
+	__u8 optlen;
+	int err;
+
+	if (!active_syn_out.flags)
+		return CG_OK;
+
+	optlen =3D option_total_len(active_syn_out.flags);
+	if (optlen) {
+		err =3D bpf_reserve_hdr_opt(skops, optlen, 0);
+		if (err)
+			RET_CG_ERR(err);
+	}
+
+	return CG_OK;
+}
+
+static __always_inline int write_syn_opt(struct bpf_sock_ops *skops)
+{
+	if (!active_syn_out.flags)
+		return CG_OK;
+
+	return store_option(skops, &active_syn_out);
+}
+
+static __always_inline int fin_opt_len(struct bpf_sock_ops *skops)
+{
+	struct bpf_test_option *opt;
+	struct hdr_stg *hdr_stg;
+	__u8 optlen;
+	int err;
+
+	if (!skops->sk)
+		RET_CG_ERR(0);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(0);
+
+	if (hdr_stg->active)
+		opt =3D &active_fin_out;
+	else
+		opt =3D &passive_fin_out;
+
+	optlen =3D option_total_len(opt->flags);
+	if (optlen) {
+		err =3D bpf_reserve_hdr_opt(skops, optlen, 0);
+		if (err)
+			RET_CG_ERR(err);
+	}
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
+		RET_CG_ERR(0);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(0);
+
+	return store_option(skops, hdr_stg->active ?
+			    &active_fin_out : &passive_fin_out);
+}
+
+static __always_inline int resend_in_ack(struct bpf_sock_ops *skops)
+{
+	struct hdr_stg *hdr_stg;
+
+	if (!skops->sk)
+		return -1;
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		return -1;
+
+	return !!hdr_stg->resend_syn;
+}
+
+static __always_inline int nodata_opt_len(struct bpf_sock_ops *skops)
+{
+	struct hdr_stg *hdr_stg;
+	int resend;
+
+	resend =3D resend_in_ack(skops);
+	if (resend < 0)
+		RET_CG_ERR(0);
+
+	if (resend)
+		return syn_opt_len(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int write_nodata_opt(struct bpf_sock_ops *skops)
+{
+	struct hdr_stg *hdr_stg;
+	int resend;
+
+	resend =3D resend_in_ack(skops);
+	if (resend < 0)
+		RET_CG_ERR(0);
+
+	if (resend)
+		return write_syn_opt(skops);
+
+	return CG_OK;
+}
+
+static __always_inline int data_opt_len(struct bpf_sock_ops *skops)
+{
+	return nodata_opt_len(skops);
+}
+
+static __always_inline int write_data_opt(struct bpf_sock_ops *skops)
+{
+	return write_nodata_opt(skops);
+}
+
+static __always_inline int current_mss_opt_len(struct bpf_sock_ops *skop=
s)
+{
+	/* Reserve maximum that may be needed */
+	int err;
+
+	err =3D bpf_reserve_hdr_opt(skops, option_total_len(OPTION_MASK), 0);
+	if (err)
+		RET_CG_ERR(err);
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
+		RET_CG_ERR(0);
+
+	if (skops->skb_len > tcp_hdrlen(th))
+		return write_data_opt(skops);
+
+	return write_nodata_opt(skops);
+}
+
+static __always_inline int set_delack_max(struct bpf_sock_ops *skops,
+					  __u8 max_delack_ms)
+{
+	__u32 max_delack_us =3D max_delack_ms * 1000;
+
+	return bpf_setsockopt(skops, SOL_TCP, TCP_BPF_DELACK_MAX,
+			      &max_delack_us, sizeof(max_delack_us));
+}
+
+static __always_inline int set_rto_min(struct bpf_sock_ops *skops,
+				       __u8 peer_max_delack_ms)
+{
+	__u32 min_rto_us =3D peer_max_delack_ms * 1000;
+
+	return bpf_setsockopt(skops, SOL_TCP, TCP_BPF_RTO_MIN, &min_rto_us,
+			      sizeof(min_rto_us));
+}
+
+static __always_inline int handle_active_estab(struct bpf_sock_ops *skop=
s)
+{
+	struct hdr_stg *stg, init_stg =3D {
+		.active =3D true,
+	};
+	int err;
+
+	err =3D load_option(skops, &active_estab_in, false);
+	if (err && err !=3D -ENOMSG)
+		RET_CG_ERR(err);
+
+update_sk_stg:
+	init_stg.resend_syn =3D TEST_OPTION_FLAGS(active_estab_in.flags,
+						OPTION_RESEND);
+	if (!skops->sk || !bpf_sk_storage_get(&hdr_stg_map, skops->sk,
+					      &init_stg,
+					      BPF_SK_STORAGE_GET_F_CREATE))
+		RET_CG_ERR(0);
+
+	if (init_stg.resend_syn)
+		/* Don't clear the write_hdr cb now because
+		 * the ACK may get lost and retransmit may
+		 * be needed.
+		 *
+		 * PARSE_ALL_HDR cb flag is set to learn if this
+		 * resend_syn option has received by the peer.
+		 *
+		 * The header option will be resent until a valid
+		 * packet is received at handle_parse_hdr()
+		 * and all hdr cb flags will be cleared in
+		 * handle_parse_hdr().
+		 */
+		set_parse_all_hdr_cb_flags(skops);
+	else if (!active_fin_out.flags)
+		/* No options will be written from now */
+		clear_hdr_cb_flags(skops);
+
+	if (active_syn_out.max_delack_ms) {
+		err =3D set_delack_max(skops, active_syn_out.max_delack_ms);
+		if (err)
+			RET_CG_ERR(err);
+	}
+
+	if (active_estab_in.max_delack_ms) {
+		err =3D set_rto_min(skops, active_estab_in.max_delack_ms);
+		if (err)
+			RET_CG_ERR(err);
+	}
+
+	return CG_OK;
+}
+
+static __always_inline int handle_passive_estab(struct bpf_sock_ops *sko=
ps)
+{
+	struct hdr_stg *hdr_stg;
+	bool syncookie =3D false;
+	__u8 *start, *end, len;
+	struct tcphdr *th;
+	int err;
+
+	err =3D load_option(skops, &passive_estab_in, true);
+	if (err =3D=3D -ENOENT) {
+		/* saved_syn is not found. It was in syncookie mode.
+		 * We have asked the active side to resned the options
+		 * in ACK, so try to find the bpf_test_option from ACK now.
+		 */
+		err =3D load_option(skops, &passive_estab_in, false);
+		syncookie =3D true;
+	}
+
+	/* ENOMSG: The bpf_test_option is not found which is fine.
+	 * Bail out now for all other errors.
+	 */
+	if (err && err !=3D -ENOMSG)
+		RET_CG_ERR(err);
+
+	if (!skops->sk)
+		RET_CG_ERR(0);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!hdr_stg)
+		RET_CG_ERR(0);
+	hdr_stg->syncookie =3D syncookie;
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(0);
+
+	if (th->syn) {
+		/* Fastopen */
+
+		/* Cannot clear cb_flags to stop write_hdr cb.
+		 * synack is not sent yet for fast open.
+		 * Even it was, the synack may need to be retransmitted.
+		 *
+		 * PARSE_ALL_HDR cb flag is set to learn
+		 * if synack has reached the peer.
+		 * All cb_flags will be cleared in handle_parse_hdr().
+		 */
+		set_parse_all_hdr_cb_flags(skops);
+		hdr_stg->fastopen =3D true;
+	} else if (!passive_fin_out.flags) {
+		/* No options will be written from now */
+		clear_hdr_cb_flags(skops);
+	}
+
+	if (passive_synack_out.max_delack_ms) {
+		err =3D set_delack_max(skops, passive_synack_out.max_delack_ms);
+		if (err)
+			RET_CG_ERR(err);
+	}
+
+	if (passive_estab_in.max_delack_ms) {
+		err =3D set_rto_min(skops, passive_estab_in.max_delack_ms);
+		if (err)
+			RET_CG_ERR(err);
+	}
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
+		RET_CG_ERR(0);
+
+	th =3D skops->skb_data;
+	if (th + 1 > skops->skb_data_end)
+		RET_CG_ERR(0);
+
+	hdr_stg =3D bpf_sk_storage_get(&hdr_stg_map, skops->sk, NULL, 0);
+	if (!hdr_stg)
+		RET_CG_ERR(0);
+
+	if (hdr_stg->resend_syn || hdr_stg->fastopen)
+		/* The PARSE_ALL_HDR cb flag was turned on
+		 * to ensure that the previously written
+		 * options have reached the peer.
+		 * Those previously written option includes:
+		 *     - Active side: resend_syn in ACK during syncookie
+		 *      or
+		 *     - Passive side: SYNACK during fastopen
+		 *
+		 * A valid packet has been received here after
+		 * the 3WHS, so the PARSE_ALL_HDR cb flag
+		 * can be cleared now.
+		 */
+		clear_parse_all_hdr_cb_flags(skops);
+
+	if (hdr_stg->resend_syn && !active_fin_out.flags)
+		/* Active side resent the syn option in ACK
+		 * because the server was in syncookie mode.
+		 * A valid packet has been received, so
+		 * clear header cb flags if there is no
+		 * more option to send.
+		 */
+		clear_hdr_cb_flags(skops);
+
+	if (hdr_stg->fastopen && !passive_fin_out.flags)
+		/* Passive side was in fastopen.
+		 * A valid packet has been received, so
+		 * the SYNACK has reached the peer.
+		 * Clear header cb flags if there is no more
+		 * option to send.
+		 */
+		clear_hdr_cb_flags(skops);
+
+	if (th->fin) {
+		struct bpf_test_option *fin_opt;
+		__u8 *kind_start;
+		int err;
+
+		if (hdr_stg->active)
+			fin_opt =3D &active_fin_in;
+		else
+			fin_opt =3D &passive_fin_in;
+
+		err =3D load_option(skops, fin_opt, false);
+		if (err && err !=3D -ENOMSG)
+			RET_CG_ERR(err);
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
index 000000000000..13b9cfd502f8
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _TEST_TCP_HDR_OPTIONS_H
+#define _TEST_TCP_HDR_OPTIONS_H
+
+struct bpf_test_option {
+	__u8 flags;
+	__u8 max_delack_ms;
+	__u8 rand;
+} __attribute__((packed));
+
+enum {
+	OPTION_RESEND,
+	OPTION_MAX_DELACK_MS,
+	OPTION_RAND,
+	__NR_OPTION_FLAGS,
+};
+
+#define OPTION_F_RESEND		(1 << OPTION_RESEND)
+#define OPTION_F_MAX_DELACK_MS	(1 << OPTION_MAX_DELACK_MS)
+#define OPTION_F_RAND		(1 << OPTION_RAND)
+#define OPTION_MASK		((1 << __NR_OPTION_FLAGS) - 1)
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
+struct linum_err {
+	unsigned int linum;
+	int err;
+};
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
+#define TCPOPT_EOL		0
+#define TCPOPT_NOP		1
+#define TCPOPT_WINDOW		3
+#define TCPOPT_EXP		254
+
+#define TCP_BPF_EXPOPT_BASE_LEN 4
+#define MAX_TCP_HDR_LEN		60
+#define MAX_TCP_OPTION_SPACE	40
+
+#ifdef BPF_PROG_TEST_TCP_HDR_OPTIONS
+
+#define CG_OK	1
+#define CG_ERR	0
+
+#ifndef SOL_TCP
+#define SOL_TCP 6
+#endif
+
+struct tcp_exprm_opt {
+	__u8 kind;
+	__u8 len;
+	__u16 magic;
+	union {
+		__u8 data[4];
+		__u32 data32;
+	};
+} __attribute__((packed));
+
+struct tcp_opt {
+	__u8 kind;
+	__u8 len;
+	union {
+		__u8 data[4];
+		__u32 data32;
+	};
+} __attribute__((packed));
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, struct linum_err);
+} lport_linum_map SEC(".maps");
+
+static inline unsigned int tcp_hdrlen(const struct tcphdr *th)
+{
+	return th->doff << 2;
+}
+
+static inline __u8 skops_tcp_flags(const struct bpf_sock_ops *skops)
+{
+	return skops->skb_tcp_flags;
+}
+
+static inline void clear_hdr_cb_flags(struct bpf_sock_ops *skops)
+{
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags &
+				  ~(BPF_SOCK_OPS_PARSE_UNKWN_HDR_OPT_CB_FLAG |
+				    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG));
+}
+
+static inline void set_hdr_cb_flags(struct bpf_sock_ops *skops)
+{
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags |
+				  BPF_SOCK_OPS_PARSE_UNKWN_HDR_OPT_CB_FLAG |
+				  BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
+}
+static inline void
+clear_parse_all_hdr_cb_flags(struct bpf_sock_ops *skops)
+{
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags &
+				  ~BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG);
+}
+
+static inline void
+set_parse_all_hdr_cb_flags(struct bpf_sock_ops *skops)
+{
+	bpf_sock_ops_cb_flags_set(skops,
+				  skops->bpf_sock_ops_cb_flags |
+				  BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG);
+}
+
+#define RET_CG_ERR(__err) ({				\
+	struct linum_err __linum_err;		\
+	int __lport;				\
+						\
+	__linum_err.linum =3D __LINE__;		\
+	__linum_err.err =3D __err;		\
+	__lport =3D skops->local_port;		\
+	bpf_map_update_elem(&lport_linum_map, &__lport, &__linum_err, BPF_NOEXI=
ST); \
+	clear_hdr_cb_flags(skops);					\
+	clear_parse_all_hdr_cb_flags(skops);				\
+	return CG_ERR;							\
+})
+
+#endif /* BPF_PROG_TEST_TCP_HDR_OPTIONS */
+
+#endif /* _TEST_TCP_HDR_OPTIONS_H */
--=20
2.24.1

