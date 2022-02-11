Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B44B1F20
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347628AbiBKHNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347642AbiBKHNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:13:32 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9A126DF
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:30 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrgL9007907
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/jtFkhp35HfBDdv1QEOtm4rdpgGFv2fjKm6qwsS63gM=;
 b=WJQeVkv9GYuWglu9S0HLdpyhlEdhmG8Ev0tYs49bAwg7SKM54XpNxrqGkKMzM6WNY0Dz
 AE/CBuDg4+OKa4VOMbo7wMYfoJtdTjjNxilW5RxU/c/3S2/L1iLdAkZKhDKUo2aAKw5Y
 3OwMfKjbarKg2Uh4IdOcOLePX61YJtr3unE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e5853c4va-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:30 -0800
Received: from twshared12416.02.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:13:29 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9C1496C75C7C; Thu, 10 Feb 2022 23:13:22 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 8/8] bpf: selftests: test skb->tstamp in redirect_neigh
Date:   Thu, 10 Feb 2022 23:13:22 -0800
Message-ID: <20220211071322.894148-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -p5gwyddRHiUTqcXluRCmTiWcbT4cFzc
X-Proofpoint-ORIG-GUID: -p5gwyddRHiUTqcXluRCmTiWcbT4cFzc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests on forwarding the delivery_time for
the following cases
- tcp/udp + ip4/ip6 + bpf_redirect_neigh
- tcp/udp + ip4/ip6 + ip[6]_forward
- bpf_skb_set_delivery_time
- The old rcv timestamp expectation on tc-bpf@ingress

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/tc_redirect.c    | 434 ++++++++++++++++++
 .../selftests/bpf/progs/test_tc_dtime.c       | 348 ++++++++++++++
 2 files changed, 782 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_dtime.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools=
/testing/selftests/bpf/prog_tests/tc_redirect.c
index c2426df58e17..3036154916a7 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -17,6 +17,8 @@
 #include <linux/if_tun.h>
 #include <linux/limits.h>
 #include <linux/sysctl.h>
+#include <linux/time_types.h>
+#include <linux/net_tstamp.h>
 #include <sched.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -29,6 +31,11 @@
 #include "test_tc_neigh_fib.skel.h"
 #include "test_tc_neigh.skel.h"
 #include "test_tc_peer.skel.h"
+#include "test_tc_dtime.skel.h"
+
+#ifndef TCP_TX_DELAY
+#define TCP_TX_DELAY 37
+#endif
=20
 #define NS_SRC "ns_src"
 #define NS_FWD "ns_fwd"
@@ -61,6 +68,7 @@
 #define CHK_PROG_PIN_FILE "/sys/fs/bpf/test_tc_chk"
=20
 #define TIMEOUT_MILLIS 10000
+#define NSEC_PER_SEC 1000000000ULL
=20
 #define log_err(MSG, ...) \
 	fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
@@ -440,6 +448,431 @@ static int set_forwarding(bool enable)
 	return 0;
 }
=20
+static void rcv_tstamp(int fd, const char *expected, size_t s)
+{
+	struct __kernel_timespec pkt_ts =3D {};
+	char ctl[CMSG_SPACE(sizeof(pkt_ts))];
+	struct timespec now_ts;
+	struct msghdr msg =3D {};
+	__u64 now_ns, pkt_ns;
+	struct cmsghdr *cmsg;
+	struct iovec iov;
+	char data[32];
+	int ret;
+
+	iov.iov_base =3D data;
+	iov.iov_len =3D sizeof(data);
+	msg.msg_iov =3D &iov;
+	msg.msg_iovlen =3D 1;
+	msg.msg_control =3D &ctl;
+	msg.msg_controllen =3D sizeof(ctl);
+
+	ret =3D recvmsg(fd, &msg, 0);
+	if (!ASSERT_EQ(ret, s, "recvmsg"))
+		return;
+	ASSERT_STRNEQ(data, expected, s, "expected rcv data");
+
+	cmsg =3D CMSG_FIRSTHDR(&msg);
+	if (cmsg && cmsg->cmsg_level =3D=3D SOL_SOCKET &&
+	    cmsg->cmsg_type =3D=3D SO_TIMESTAMPNS_NEW)
+		memcpy(&pkt_ts, CMSG_DATA(cmsg), sizeof(pkt_ts));
+
+	pkt_ns =3D pkt_ts.tv_sec * NSEC_PER_SEC + pkt_ts.tv_nsec;
+	ASSERT_NEQ(pkt_ns, 0, "pkt rcv tstamp");
+
+	ret =3D clock_gettime(CLOCK_REALTIME, &now_ts);
+	ASSERT_OK(ret, "clock_gettime");
+	now_ns =3D now_ts.tv_sec * NSEC_PER_SEC + now_ts.tv_nsec;
+
+	if (ASSERT_GE(now_ns, pkt_ns, "check rcv tstamp"))
+		ASSERT_LT(now_ns - pkt_ns, 5 * NSEC_PER_SEC,
+			  "check rcv tstamp");
+}
+
+static void snd_tstamp(int fd, char *b, size_t s)
+{
+	struct sock_txtime opt =3D { .clockid =3D CLOCK_TAI };
+	char ctl[CMSG_SPACE(sizeof(__u64))];
+	struct timespec now_ts;
+	struct msghdr msg =3D {};
+	struct cmsghdr *cmsg;
+	struct iovec iov;
+	__u64 now_ns;
+	int ret;
+
+	ret =3D clock_gettime(CLOCK_TAI, &now_ts);
+	ASSERT_OK(ret, "clock_get_time(CLOCK_TAI)");
+	now_ns =3D now_ts.tv_sec * NSEC_PER_SEC + now_ts.tv_nsec;
+
+	iov.iov_base =3D b;
+	iov.iov_len =3D s;
+	msg.msg_iov =3D &iov;
+	msg.msg_iovlen =3D 1;
+	msg.msg_control =3D &ctl;
+	msg.msg_controllen =3D sizeof(ctl);
+
+	cmsg =3D CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level =3D SOL_SOCKET;
+	cmsg->cmsg_type =3D SCM_TXTIME;
+	cmsg->cmsg_len =3D CMSG_LEN(sizeof(now_ns));
+	*(__u64 *)CMSG_DATA(cmsg) =3D now_ns;
+
+	ret =3D setsockopt(fd, SOL_SOCKET, SO_TXTIME, &opt, sizeof(opt));
+	ASSERT_OK(ret, "setsockopt(SO_TXTIME)");
+
+	ret =3D sendmsg(fd, &msg, 0);
+	ASSERT_EQ(ret, s, "sendmsg");
+}
+
+static void test_inet_dtime(int family, int type, const char *addr, __u1=
6 port)
+{
+	int opt =3D 1, accept_fd =3D -1, client_fd =3D -1, listen_fd, err;
+	char buf[] =3D "testing testing";
+	struct nstoken *nstoken;
+
+	nstoken =3D open_netns(NS_DST);
+	if (!ASSERT_OK_PTR(nstoken, "setns dst"))
+		return;
+	listen_fd =3D start_server(family, type, addr, port, 0);
+	close_netns(nstoken);
+
+	if (!ASSERT_GE(listen_fd, 0, "listen"))
+		return;
+
+	/* Ensure the kernel puts the (rcv) timestamp for all skb */
+	err =3D setsockopt(listen_fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+			 &opt, sizeof(opt));
+	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS_NEW)"))
+		goto done;
+
+	if (type =3D=3D SOCK_STREAM) {
+		/* Ensure the kernel set EDT when sending out rst/ack
+		 * from the kernel's ctl_sk.
+		 */
+		err =3D setsockopt(listen_fd, SOL_TCP, TCP_TX_DELAY, &opt,
+				 sizeof(opt));
+		if (!ASSERT_OK(err, "setsockopt(TCP_TX_DELAY)"))
+			goto done;
+	}
+
+	nstoken =3D open_netns(NS_SRC);
+	if (!ASSERT_OK_PTR(nstoken, "setns src"))
+		goto done;
+	client_fd =3D connect_to_fd(listen_fd, TIMEOUT_MILLIS);
+	close_netns(nstoken);
+
+	if (!ASSERT_GE(client_fd, 0, "connect_to_fd"))
+		goto done;
+
+	if (type =3D=3D SOCK_STREAM) {
+		int n;
+
+		accept_fd =3D accept(listen_fd, NULL, NULL);
+		if (!ASSERT_GE(accept_fd, 0, "accept"))
+			goto done;
+
+		n =3D write(client_fd, buf, sizeof(buf));
+		if (!ASSERT_EQ(n, sizeof(buf), "send to server"))
+			goto done;
+		rcv_tstamp(accept_fd, buf, sizeof(buf));
+	} else {
+		snd_tstamp(client_fd, buf, sizeof(buf));
+		rcv_tstamp(listen_fd, buf, sizeof(buf));
+	}
+
+done:
+	close(listen_fd);
+	if (accept_fd !=3D -1)
+		close(accept_fd);
+	if (client_fd !=3D -1)
+		close(client_fd);
+}
+
+static int netns_load_dtime_bpf(struct test_tc_dtime *skel)
+{
+	struct nstoken *nstoken;
+
+#define PIN_FNAME(__file) "/sys/fs/bpf/" #__file
+#define PIN(__prog) ({							\
+		int err =3D bpf_program__pin(skel->progs.__prog, PIN_FNAME(__prog)); \
+		if (!ASSERT_OK(err, "pin " #__prog))		\
+			goto fail;					\
+		})
+
+	/* setup ns_src tc progs */
+	nstoken =3D open_netns(NS_SRC);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS_SRC))
+		return -1;
+	PIN(egress_host);
+	PIN(ingress_host);
+	SYS("tc qdisc add dev veth_src clsact");
+	SYS("tc filter add dev veth_src ingress bpf da object-pinned "
+	    PIN_FNAME(ingress_host));
+	SYS("tc filter add dev veth_src egress bpf da object-pinned "
+	    PIN_FNAME(egress_host));
+	close_netns(nstoken);
+
+	/* setup ns_dst tc progs */
+	nstoken =3D open_netns(NS_DST);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS_DST))
+		return -1;
+	PIN(egress_host);
+	PIN(ingress_host);
+	SYS("tc qdisc add dev veth_dst clsact");
+	SYS("tc filter add dev veth_dst ingress bpf da object-pinned "
+	    PIN_FNAME(ingress_host));
+	SYS("tc filter add dev veth_dst egress bpf da object-pinned "
+	    PIN_FNAME(egress_host));
+	close_netns(nstoken);
+
+	/* setup ns_fwd tc progs */
+	nstoken =3D open_netns(NS_FWD);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS_FWD))
+		return -1;
+	PIN(ingress_fwdns_prio100);
+	PIN(egress_fwdns_prio100);
+	PIN(ingress_fwdns_prio101);
+	PIN(egress_fwdns_prio101);
+	SYS("tc qdisc add dev veth_dst_fwd clsact");
+	SYS("tc filter add dev veth_dst_fwd ingress prio 100 bpf da object-pinn=
ed "
+	    PIN_FNAME(ingress_fwdns_prio100));
+	SYS("tc filter add dev veth_dst_fwd ingress prio 101 bpf da object-pinn=
ed "
+	    PIN_FNAME(ingress_fwdns_prio101));
+	SYS("tc filter add dev veth_dst_fwd egress prio 100 bpf da object-pinne=
d "
+	    PIN_FNAME(egress_fwdns_prio100));
+	SYS("tc filter add dev veth_dst_fwd egress prio 101 bpf da object-pinne=
d "
+	    PIN_FNAME(egress_fwdns_prio101));
+	SYS("tc qdisc add dev veth_src_fwd clsact");
+	SYS("tc filter add dev veth_src_fwd ingress prio 100 bpf da object-pinn=
ed "
+	    PIN_FNAME(ingress_fwdns_prio100));
+	SYS("tc filter add dev veth_src_fwd ingress prio 101 bpf da object-pinn=
ed "
+	    PIN_FNAME(ingress_fwdns_prio101));
+	SYS("tc filter add dev veth_src_fwd egress prio 100 bpf da object-pinne=
d "
+	    PIN_FNAME(egress_fwdns_prio100));
+	SYS("tc filter add dev veth_src_fwd egress prio 101 bpf da object-pinne=
d "
+	    PIN_FNAME(egress_fwdns_prio101));
+	close_netns(nstoken);
+
+#undef PIN
+
+	return 0;
+
+fail:
+	close_netns(nstoken);
+	return -1;
+}
+
+enum {
+	INGRESS_FWDNS_P100,
+	INGRESS_FWDNS_P101,
+	EGRESS_FWDNS_P100,
+	EGRESS_FWDNS_P101,
+	INGRESS_ENDHOST,
+	EGRESS_ENDHOST,
+	SET_DTIME,
+	__MAX_CNT,
+};
+
+const char *cnt_names[] =3D {
+	"ingress_fwdns_p100",
+	"ingress_fwdns_p101",
+	"egress_fwdns_p100",
+	"egress_fwdns_p101",
+	"ingress_endhost",
+	"egress_endhost",
+	"set_dtime",
+};
+
+enum {
+	TCP_IP6_CLEAR_DTIME,
+	TCP_IP4,
+	TCP_IP6,
+	UDP_IP4,
+	UDP_IP6,
+	TCP_IP4_RT_FWD,
+	TCP_IP6_RT_FWD,
+	UDP_IP4_RT_FWD,
+	UDP_IP6_RT_FWD,
+	UKN_TEST,
+	__NR_TESTS,
+};
+
+const char *test_names[] =3D {
+	"tcp ip6 clear dtime",
+	"tcp ip4",
+	"tcp ip6",
+	"udp ip4",
+	"udp ip6",
+	"tcp ip4 rt fwd",
+	"tcp ip6 rt fwd",
+	"udp ip4 rt fwd",
+	"udp ip6 rt fwd",
+};
+
+static const char *dtime_cnt_str(int test, int cnt)
+{
+	static char name[64];
+
+	snprintf(name, sizeof(name), "%s %s", test_names[test], cnt_names[cnt])=
;
+
+	return name;
+}
+
+static const char *dtime_err_str(int test, int cnt)
+{
+	static char name[64];
+
+	snprintf(name, sizeof(name), "%s %s errs", test_names[test],
+		 cnt_names[cnt]);
+
+	return name;
+}
+
+static void test_tcp_clear_dtime(struct test_tc_dtime *skel)
+{
+	int i, t =3D TCP_IP6_CLEAR_DTIME;
+	__u32 *dtimes =3D skel->bss->dtimes[t];
+	__u32 *errs =3D skel->bss->errs[t];
+
+	skel->bss->test =3D t;
+	test_inet_dtime(AF_INET6, SOCK_STREAM, IP6_DST, 0);
+
+	ASSERT_EQ(dtimes[INGRESS_FWDNS_P100], 0,
+		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
+	ASSERT_EQ(dtimes[INGRESS_FWDNS_P101], 0,
+		  dtime_cnt_str(t, INGRESS_FWDNS_P101));
+	ASSERT_GT(dtimes[EGRESS_FWDNS_P100], 0,
+		  dtime_cnt_str(t, EGRESS_FWDNS_P100));
+	ASSERT_EQ(dtimes[EGRESS_FWDNS_P101], 0,
+		  dtime_cnt_str(t, EGRESS_FWDNS_P101));
+	ASSERT_GT(dtimes[EGRESS_ENDHOST], 0,
+		  dtime_cnt_str(t, EGRESS_ENDHOST));
+	ASSERT_GT(dtimes[INGRESS_ENDHOST], 0,
+		  dtime_cnt_str(t, INGRESS_ENDHOST));
+
+	for (i =3D INGRESS_FWDNS_P100; i < __MAX_CNT; i++)
+		ASSERT_EQ(errs[i], 0, dtime_err_str(t, i));
+}
+
+static void test_tcp_dtime(struct test_tc_dtime *skel, int family, bool =
bpf_fwd)
+{
+	__u32 *dtimes, *errs;
+	const char *addr;
+	int i, t;
+
+	if (family =3D=3D AF_INET) {
+		t =3D bpf_fwd ? TCP_IP4 : TCP_IP4_RT_FWD;
+		addr =3D IP4_DST;
+	} else {
+		t =3D bpf_fwd ? TCP_IP6 : TCP_IP6_RT_FWD;
+		addr =3D IP6_DST;
+	}
+
+	dtimes =3D skel->bss->dtimes[t];
+	errs =3D skel->bss->errs[t];
+
+	skel->bss->test =3D t;
+	test_inet_dtime(family, SOCK_STREAM, addr, 0);
+
+	/* fwdns_prio100 prog does not read delivery_time_type, so
+	 * kernel puts the (rcv) timetamp in __sk_buff->tstamp
+	 */
+	ASSERT_EQ(dtimes[INGRESS_FWDNS_P100], 0,
+		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
+	for (i =3D INGRESS_FWDNS_P101; i < SET_DTIME; i++)
+		ASSERT_GT(dtimes[i], 0, dtime_cnt_str(t, i));
+
+	for (i =3D INGRESS_FWDNS_P100; i < __MAX_CNT; i++)
+		ASSERT_EQ(errs[i], 0, dtime_err_str(t, i));
+}
+
+static void test_udp_dtime(struct test_tc_dtime *skel, int family, bool =
bpf_fwd)
+{
+	__u32 *dtimes, *errs;
+	const char *addr;
+	int i, t;
+
+	if (family =3D=3D AF_INET) {
+		t =3D bpf_fwd ? UDP_IP4 : UDP_IP4_RT_FWD;
+		addr =3D IP4_DST;
+	} else {
+		t =3D bpf_fwd ? UDP_IP6 : UDP_IP6_RT_FWD;
+		addr =3D IP6_DST;
+	}
+
+	dtimes =3D skel->bss->dtimes[t];
+	errs =3D skel->bss->errs[t];
+
+	skel->bss->test =3D t;
+	test_inet_dtime(family, SOCK_DGRAM, addr, 0);
+
+	ASSERT_EQ(dtimes[INGRESS_FWDNS_P100], 0,
+		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
+	/* non mono delivery time is not forwarded */
+	ASSERT_EQ(dtimes[INGRESS_FWDNS_P101], 0,
+		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
+	for (i =3D EGRESS_FWDNS_P100; i < SET_DTIME; i++)
+		ASSERT_GT(dtimes[i], 0, dtime_cnt_str(t, i));
+
+	for (i =3D INGRESS_FWDNS_P100; i < __MAX_CNT; i++)
+		ASSERT_EQ(errs[i], 0, dtime_err_str(t, i));
+}
+
+static void test_tc_redirect_dtime(struct netns_setup_result *setup_resu=
lt)
+{
+	struct test_tc_dtime *skel;
+	struct nstoken *nstoken;
+	int err;
+
+	skel =3D test_tc_dtime__open();
+	if (!ASSERT_OK_PTR(skel, "test_tc_dtime__open"))
+		return;
+
+	skel->rodata->IFINDEX_SRC =3D setup_result->ifindex_veth_src_fwd;
+	skel->rodata->IFINDEX_DST =3D setup_result->ifindex_veth_dst_fwd;
+
+	err =3D test_tc_dtime__load(skel);
+	if (!ASSERT_OK(err, "test_tc_dtime__load"))
+		goto done;
+
+	if (netns_load_dtime_bpf(skel))
+		goto done;
+
+	nstoken =3D open_netns(NS_FWD);
+	if (!ASSERT_OK_PTR(nstoken, "setns fwd"))
+		goto done;
+	err =3D set_forwarding(false);
+	close_netns(nstoken);
+	if (!ASSERT_OK(err, "disable forwarding"))
+		goto done;
+
+	test_tcp_clear_dtime(skel);
+
+	test_tcp_dtime(skel, AF_INET, true);
+	test_tcp_dtime(skel, AF_INET6, true);
+	test_udp_dtime(skel, AF_INET, true);
+	test_udp_dtime(skel, AF_INET6, true);
+
+	/* Test the kernel ip[6]_forward path instead
+	 * of bpf_redirect_neigh().
+	 */
+	nstoken =3D open_netns(NS_FWD);
+	if (!ASSERT_OK_PTR(nstoken, "setns fwd"))
+		goto done;
+	err =3D set_forwarding(true);
+	close_netns(nstoken);
+	if (!ASSERT_OK(err, "enable forwarding"))
+		goto done;
+
+	test_tcp_dtime(skel, AF_INET, false);
+	test_tcp_dtime(skel, AF_INET6, false);
+	test_udp_dtime(skel, AF_INET, false);
+	test_udp_dtime(skel, AF_INET6, false);
+
+done:
+	test_tc_dtime__destroy(skel);
+}
+
 static void test_tc_redirect_neigh_fib(struct netns_setup_result *setup_=
result)
 {
 	struct nstoken *nstoken =3D NULL;
@@ -787,6 +1220,7 @@ static void *test_tc_redirect_run_tests(void *arg)
 	RUN_TEST(tc_redirect_peer_l3);
 	RUN_TEST(tc_redirect_neigh);
 	RUN_TEST(tc_redirect_neigh_fib);
+	RUN_TEST(tc_redirect_dtime);
 	return NULL;
 }
=20
diff --git a/tools/testing/selftests/bpf/progs/test_tc_dtime.c b/tools/te=
sting/selftests/bpf/progs/test_tc_dtime.c
new file mode 100644
index 000000000000..b52ed4e4696b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_dtime.c
@@ -0,0 +1,348 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stddef.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <linux/bpf.h>
+#include <linux/stddef.h>
+#include <linux/pkt_cls.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <sys/socket.h>
+
+/* veth_src --- veth_src_fwd --- veth_det_fwd --- veth_dst
+ *           |                                 |
+ *  ns_src   |              ns_fwd             |   ns_dst
+ *
+ * ns_src and ns_dst: ENDHOST namespace
+ *            ns_fwd: Fowarding namespace
+ */
+
+#define ctx_ptr(field)		(void *)(long)(field)
+
+#define ip4_src			__bpf_htonl(0xac100164) /* 172.16.1.100 */
+#define ip4_dst			__bpf_htonl(0xac100264) /* 172.16.2.100 */
+
+#define ip6_src			{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+				  0x00, 0x01, 0xde, 0xad, 0xbe, 0xef, 0xca, 0xfe }
+#define ip6_dst			{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+				  0x00, 0x02, 0xde, 0xad, 0xbe, 0xef, 0xca, 0xfe }
+
+#define v6_equal(a, b)		(a.s6_addr32[0] =3D=3D b.s6_addr32[0] && \
+				 a.s6_addr32[1] =3D=3D b.s6_addr32[1] && \
+				 a.s6_addr32[2] =3D=3D b.s6_addr32[2] && \
+				 a.s6_addr32[3] =3D=3D b.s6_addr32[3])
+
+volatile const __u32 IFINDEX_SRC;
+volatile const __u32 IFINDEX_DST;
+
+#define EGRESS_ENDHOST_MAGIC	0x0b9fbeef
+#define INGRESS_FWDNS_MAGIC	0x1b9fbeef
+#define EGRESS_FWDNS_MAGIC	0x2b9fbeef
+
+enum {
+	INGRESS_FWDNS_P100,
+	INGRESS_FWDNS_P101,
+	EGRESS_FWDNS_P100,
+	EGRESS_FWDNS_P101,
+	INGRESS_ENDHOST,
+	EGRESS_ENDHOST,
+	SET_DTIME,
+	__MAX_CNT,
+};
+
+enum {
+	TCP_IP6_CLEAR_DTIME,
+	TCP_IP4,
+	TCP_IP6,
+	UDP_IP4,
+	UDP_IP6,
+	TCP_IP4_RT_FWD,
+	TCP_IP6_RT_FWD,
+	UDP_IP4_RT_FWD,
+	UDP_IP6_RT_FWD,
+	UKN_TEST,
+	__NR_TESTS,
+};
+
+enum {
+	SRC_NS =3D 1,
+	DST_NS,
+};
+
+__u32 dtimes[__NR_TESTS][__MAX_CNT] =3D {};
+__u32 errs[__NR_TESTS][__MAX_CNT] =3D {};
+__u32 test =3D 0;
+
+static void inc_dtimes(__u32 idx)
+{
+	if (test < __NR_TESTS)
+		dtimes[test][idx]++;
+	else
+		dtimes[UKN_TEST][idx]++;
+}
+
+static void inc_errs(__u32 idx)
+{
+	if (test < __NR_TESTS)
+		errs[test][idx]++;
+	else
+		errs[UKN_TEST][idx]++;
+}
+
+static int skb_proto(int type)
+{
+	return type & 0xff;
+}
+
+static int skb_ns(int type)
+{
+	return (type >> 8) & 0xff;
+}
+
+static bool fwdns_clear_dtime(void)
+{
+	return test =3D=3D TCP_IP6_CLEAR_DTIME;
+}
+
+static bool bpf_fwd(void)
+{
+	return test < TCP_IP4_RT_FWD;
+}
+
+/* -1: parse error: TC_ACT_SHOT
+ *  0: not testing traffic: TC_ACT_OK
+ * >0: first byte is the inet_proto, second byte has the netns
+ *     of the sender
+ */
+static int skb_get_type(struct __sk_buff *skb)
+{
+	void *data_end =3D ctx_ptr(skb->data_end);
+	void *data =3D ctx_ptr(skb->data);
+	__u8 inet_proto =3D 0, ns =3D 0;
+	struct ipv6hdr *ip6h;
+	struct iphdr *iph;
+
+	switch (skb->protocol) {
+	case __bpf_htons(ETH_P_IP):
+		iph =3D data + sizeof(struct ethhdr);
+		if (iph + 1 > data_end)
+			return -1;
+		if (iph->saddr =3D=3D ip4_src)
+			ns =3D SRC_NS;
+		else if (iph->saddr =3D=3D ip4_dst)
+			ns =3D DST_NS;
+		inet_proto =3D iph->protocol;
+		break;
+	case __bpf_htons(ETH_P_IPV6):
+		ip6h =3D data + sizeof(struct ethhdr);
+		if (ip6h + 1 > data_end)
+			return -1;
+		if (v6_equal(ip6h->saddr, (struct in6_addr)ip6_src))
+			ns =3D SRC_NS;
+		else if (v6_equal(ip6h->saddr, (struct in6_addr)ip6_dst))
+			ns =3D DST_NS;
+		inet_proto =3D ip6h->nexthdr;
+		break;
+	default:
+		return 0;
+	}
+
+	if ((inet_proto !=3D IPPROTO_TCP && inet_proto !=3D IPPROTO_UDP) || !ns=
)
+		return 0;
+
+	return (ns << 8 | inet_proto);
+}
+
+/* format: direction@iface@netns
+ * egress@veth_(src|dst)@ns_(src|dst)
+ */
+SEC("tc")
+int egress_host(struct __sk_buff *skb)
+{
+	int skb_type;
+
+	skb_type =3D skb_get_type(skb);
+	if (skb_type =3D=3D -1)
+		return TC_ACT_SHOT;
+	if (!skb_type)
+		return TC_ACT_OK;
+
+	if (skb_proto(skb_type) =3D=3D IPPROTO_TCP) {
+		if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO &&
+		    skb->tstamp)
+			inc_dtimes(EGRESS_ENDHOST);
+		else
+			inc_errs(EGRESS_ENDHOST);
+	} else {
+		if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_UNSPEC &&
+		    skb->tstamp)
+			inc_dtimes(EGRESS_ENDHOST);
+		else
+			inc_errs(EGRESS_ENDHOST);
+	}
+
+	skb->tstamp =3D EGRESS_ENDHOST_MAGIC;
+
+	return TC_ACT_OK;
+}
+
+/* ingress@veth_(src|dst)@ns_(src|dst) */
+SEC("tc")
+int ingress_host(struct __sk_buff *skb)
+{
+	int skb_type;
+
+	skb_type =3D skb_get_type(skb);
+	if (skb_type =3D=3D -1)
+		return TC_ACT_SHOT;
+	if (!skb_type)
+		return TC_ACT_OK;
+
+	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO &&
+	    skb->tstamp =3D=3D EGRESS_FWDNS_MAGIC)
+		inc_dtimes(INGRESS_ENDHOST);
+	else
+		inc_errs(INGRESS_ENDHOST);
+
+	return TC_ACT_OK;
+}
+
+/* ingress@veth_(src|dst)_fwd@ns_fwd priority 100 */
+SEC("tc")
+int ingress_fwdns_prio100(struct __sk_buff *skb)
+{
+	int skb_type;
+
+	skb_type =3D skb_get_type(skb);
+	if (skb_type =3D=3D -1)
+		return TC_ACT_SHOT;
+	if (!skb_type)
+		return TC_ACT_OK;
+
+	/* delivery_time is only available to the ingress
+	 * if the tc-bpf checks the skb->delivery_time_type.
+	 */
+	if (skb->tstamp =3D=3D EGRESS_ENDHOST_MAGIC)
+		inc_errs(INGRESS_FWDNS_P100);
+
+	if (fwdns_clear_dtime())
+		skb->tstamp =3D 0;
+
+	return TC_ACT_UNSPEC;
+}
+
+/* egress@veth_(src|dst)_fwd@ns_fwd priority 100 */
+SEC("tc")
+int egress_fwdns_prio100(struct __sk_buff *skb)
+{
+	int skb_type;
+
+	skb_type =3D skb_get_type(skb);
+	if (skb_type =3D=3D -1)
+		return TC_ACT_SHOT;
+	if (!skb_type)
+		return TC_ACT_OK;
+
+	/* delivery_time is always available to egress even
+	 * the tc-bpf did not use the delivery_time_type.
+	 */
+	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO &&
+	    skb->tstamp =3D=3D INGRESS_FWDNS_MAGIC)
+		inc_dtimes(EGRESS_FWDNS_P100);
+	else
+		inc_errs(EGRESS_FWDNS_P100);
+
+	if (fwdns_clear_dtime())
+		skb->tstamp =3D 0;
+
+	return TC_ACT_UNSPEC;
+}
+
+/* ingress@veth_(src|dst)_fwd@ns_fwd priority 101 */
+SEC("tc")
+int ingress_fwdns_prio101(struct __sk_buff *skb)
+{
+	__u64 expected_dtime =3D EGRESS_ENDHOST_MAGIC;
+	int skb_type;
+
+	skb_type =3D skb_get_type(skb);
+	if (skb_type =3D=3D -1 || !skb_type)
+		/* Should have handled in prio100 */
+		return TC_ACT_SHOT;
+
+	if (skb_proto(skb_type) =3D=3D IPPROTO_UDP)
+		expected_dtime =3D 0;
+
+	if (skb->delivery_time_type) {
+		if (fwdns_clear_dtime() ||
+		    skb->delivery_time_type !=3D BPF_SKB_DELIVERY_TIME_MONO ||
+		    skb->tstamp !=3D expected_dtime)
+			inc_errs(INGRESS_FWDNS_P101);
+		else
+			inc_dtimes(INGRESS_FWDNS_P101);
+	} else {
+		if (!fwdns_clear_dtime() && expected_dtime)
+			inc_errs(INGRESS_FWDNS_P101);
+	}
+
+	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO) {
+		skb->tstamp =3D INGRESS_FWDNS_MAGIC;
+	} else {
+		if (bpf_skb_set_delivery_time(skb, INGRESS_FWDNS_MAGIC,
+					      BPF_SKB_DELIVERY_TIME_MONO))
+			inc_errs(SET_DTIME);
+		if (!bpf_skb_set_delivery_time(skb, INGRESS_FWDNS_MAGIC,
+					       BPF_SKB_DELIVERY_TIME_UNSPEC))
+			inc_errs(SET_DTIME);
+	}
+
+	if (skb_ns(skb_type) =3D=3D SRC_NS)
+		return bpf_fwd() ?
+			bpf_redirect_neigh(IFINDEX_DST, NULL, 0, 0) : TC_ACT_OK;
+	else
+		return bpf_fwd() ?
+			bpf_redirect_neigh(IFINDEX_SRC, NULL, 0, 0) : TC_ACT_OK;
+}
+
+/* egress@veth_(src|dst)_fwd@ns_fwd priority 101 */
+SEC("tc")
+int egress_fwdns_prio101(struct __sk_buff *skb)
+{
+	int skb_type;
+
+	skb_type =3D skb_get_type(skb);
+	if (skb_type =3D=3D -1 || !skb_type)
+		/* Should have handled in prio100 */
+		return TC_ACT_SHOT;
+
+	if (skb->delivery_time_type) {
+		if (fwdns_clear_dtime() ||
+		    skb->delivery_time_type !=3D BPF_SKB_DELIVERY_TIME_MONO ||
+		    skb->tstamp !=3D INGRESS_FWDNS_MAGIC)
+			inc_errs(EGRESS_FWDNS_P101);
+		else
+			inc_dtimes(EGRESS_FWDNS_P101);
+	} else {
+		if (!fwdns_clear_dtime())
+			inc_errs(EGRESS_FWDNS_P101);
+	}
+
+	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO) {
+		skb->tstamp =3D EGRESS_FWDNS_MAGIC;
+	} else {
+		if (bpf_skb_set_delivery_time(skb, EGRESS_FWDNS_MAGIC,
+					      BPF_SKB_DELIVERY_TIME_MONO))
+			inc_errs(SET_DTIME);
+		if (!bpf_skb_set_delivery_time(skb, EGRESS_FWDNS_MAGIC,
+					       BPF_SKB_DELIVERY_TIME_UNSPEC))
+			inc_errs(SET_DTIME);
+	}
+
+	return TC_ACT_OK;
+}
+
+char __license[] SEC("license") =3D "GPL";
--=20
2.30.2

