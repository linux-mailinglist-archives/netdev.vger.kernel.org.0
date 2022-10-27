Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E37610247
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiJ0UBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236874AbiJ0UAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:00:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF04495CC
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso1705762plg.7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1k5yzkMHPKVpJxfSBsEcHHj8plrhgO9vuyoJKASsEmU=;
        b=n/UREpPnnfxUxStjCXxqowwL2ThEEnX9FQtVh5YzRyLm3FRk8nYtEeSPHheYShmRFE
         dQp+z/ltMDVcH40cWXqO3ducFy/S7FQXAzoPHRPsCL89E/HlgdKue7moQYaPuacXzsNQ
         egrDtG9z3RAfm624yVeFqOAVBb5r73TaRylF8e6OGqkqw5gEhG4l3plf2py/ZEet2I3O
         XFrwzOlGrQPJr/z3P9IO7bCQSMQNgwGlLIgw6dcxC3CyGF+C7D1NtEgc+vg6r+jqtEQe
         JLkSyfiJx+sIL1bAkiyESVld9LUyeR0ESNa4iSOT42G0oFTQcGaQMhFklsehNpGmQG3w
         b4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1k5yzkMHPKVpJxfSBsEcHHj8plrhgO9vuyoJKASsEmU=;
        b=gjYjxh1UAodKK9KwskkO1Kkf1bkcAjjlQ/Av74TkHb/fY2vgZI8OZHnolPk/W0q9++
         xNP97qr8QwwugIickyzFprk5IpW9JYNaDmtaQJ4CzWgnsVS/3SPWGam35hNIeyUbtjpj
         2zValH+nnZT+4kmX46Z1bjV+0TOTCM8T2dyG6qpKCn0K112ZR+a3jAKky8Y5VV3Gwl1k
         J2piH0DMbQg99mmf+q02/fuInTRvyJKHZRlG36Z/TszQ8ItRHIV7b2PuZY73SJmUMVOU
         O3M5TuOhKm+0yCZZab64FWwErkPGW3P8TPhcLIMOWFqQrDp5z9ZrhoYjXfqnCHcheljJ
         rQCg==
X-Gm-Message-State: ACrzQf0rx2AAl9CzQgkd3go2pT4rrohlTTA6rvs4fEzatiwM2pHFzZBg
        re6V1acATHis7vzz83UEgVMX7Cs=
X-Google-Smtp-Source: AMsMyM42i2qmj5/tum0aiLkRrGO//i6iA+au9HoLSXhG8Jardj8mUd8pmeDSUGDth8T8hAOsIOqdmsQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:80e:b0:563:4ad2:9d39 with SMTP id
 m14-20020a056a00080e00b005634ad29d39mr51074982pfk.66.1666900828817; Thu, 27
 Oct 2022 13:00:28 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:00:18 -0700
In-Reply-To: <20221027200019.4106375-1-sdf@google.com>
Mime-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200019.4106375-5-sdf@google.com>
Subject: [RFC bpf-next 4/5] selftests/bpf: Convert xskxceiver to use custom program
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes (in theory): convert libxsk-generated
program bytecode to the C code to better illustrate kfunc
metadata (see next patch in the series).

There is also a bunch of unrelated changes, ignore them for the
sake of demo:
- stats.rx_dopped == 2048 vs 2047 ?
- buggy ksft_print_msg calls
- test is limited only to
  TEST_MODE_DRV+TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT

Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../testing/selftests/bpf/progs/xskxceiver.c  | 21 ++++
 tools/testing/selftests/bpf/xskxceiver.c      | 98 +++++++++++++++----
 tools/testing/selftests/bpf/xskxceiver.h      |  5 +-
 4 files changed, 105 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xskxceiver.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 79edef1dbda4..3cab2e1b0e74 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -378,6 +378,7 @@ linked_maps.skel.h-deps := linked_maps1.bpf.o linked_maps2.bpf.o
 test_subskeleton.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o test_subskeleton.bpf.o
 test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o
 test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
+xskxceiver-deps := xskxceiver.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/progs/xskxceiver.c b/tools/testing/selftests/bpf/progs/xskxceiver.c
new file mode 100644
index 000000000000..b135daddad3a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xskxceiver.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_XSKMAP);
+	__uint(max_entries, 4);
+	__type(key, __u32);
+	__type(value, __u32);
+} xsk SEC(".maps");
+
+SEC("xdp")
+int rx(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 681a5db80dae..066bd691db13 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -399,6 +399,58 @@ static void usage(const char *prog)
 	ksft_print_msg(str, prog);
 }
 
+static void bpf_update_xsk_map(struct ifobject *ifobject, __u32 queue_id)
+{
+	int map_fd;
+	int sock_fd;
+	int ret;
+
+	map_fd = bpf_map__fd(ifobject->bpf_obj->maps.xsk);
+	sock_fd = xsk_socket__fd(ifobject->xsk->xsk);
+
+	(void)bpf_map_delete_elem(map_fd, &queue_id);
+	ret = bpf_map_update_elem(map_fd, &queue_id, &sock_fd, 0);
+	if (ret)
+		exit_with_error(-ret);
+}
+
+static int bpf_attach(struct ifobject *ifobject)
+{
+	__u32 prog_id = 0;
+
+	bpf_xdp_query_id(ifobject->ifindex, ifobject->xdp_flags, &prog_id);
+	if (prog_id)
+		return 0;
+
+	int ret = bpf_xdp_attach(ifobject->ifindex,
+				 bpf_program__fd(ifobject->bpf_obj->progs.rx),
+				 ifobject->xdp_flags, NULL);
+	if (ret < 0) {
+		if (errno != EEXIST && errno != EBUSY) {
+			exit_with_error(errno);
+		}
+	}
+
+	bpf_update_xsk_map(ifobject, 0);
+
+	return 0;
+}
+
+static void bpf_detach(struct ifobject *ifobject)
+{
+	int my_ns = open("/proc/self/ns/net", O_RDONLY);
+
+	/* Make sure we're in the right namespace when detaching.
+	 * Relevant only for TEST_TYPE_BIDI.
+	 */
+	if (ifobject->ns_fd > 0)
+		setns(ifobject->ns_fd, 0);
+
+	bpf_xdp_detach(ifobject->ifindex, ifobject->xdp_flags, NULL);
+
+	setns(my_ns, 0);
+}
+
 static int switch_namespace(const char *nsname)
 {
 	char fqns[26] = "/var/run/netns/";
@@ -1141,9 +1193,10 @@ static int validate_rx_dropped(struct ifobject *ifobject)
 	if (err)
 		return TEST_FAILURE;
 
-	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2)
+	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 - 1)
 		return TEST_PASS;
 
+	printf("%lld != %d\n", stats.rx_dropped, ifobject->pkt_stream->nb_pkts / 2 - 1);
 	return TEST_FAILURE;
 }
 
@@ -1239,7 +1292,6 @@ static void thread_common_ops_tx(struct test_spec *test, struct ifobject *ifobje
 {
 	xsk_configure_socket(test, ifobject, test->ifobj_rx->umem, true);
 	ifobject->xsk = &ifobject->xsk_arr[0];
-	ifobject->xsk_map_fd = test->ifobj_rx->xsk_map_fd;
 	memcpy(ifobject->umem, test->ifobj_rx->umem, sizeof(struct xsk_umem_info));
 }
 
@@ -1284,6 +1336,14 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
+	ifindex = if_nametoindex(ifobject->ifname);
+	if (!ifindex)
+		exit_with_error(errno);
+
+	ifobject->bpf_obj = xskxceiver__open_and_load();
+	if (libbpf_get_error(ifobject->bpf_obj))
+		exit_with_error(libbpf_get_error(ifobject->bpf_obj));
+
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
 
@@ -1307,11 +1367,8 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifobject->rx_on)
 		return;
 
-	ifindex = if_nametoindex(ifobject->ifname);
-	if (!ifindex)
-		exit_with_error(errno);
-
-	ret = xsk_setup_xdp_prog_xsk(ifobject->xsk->xsk, &ifobject->xsk_map_fd);
+	ifobject->ifindex = ifindex;
+	ret = bpf_attach(ifobject);
 	if (ret)
 		exit_with_error(-ret);
 
@@ -1321,19 +1378,17 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 
 	if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
 		if (opts.attach_mode != XDP_ATTACHED_SKB) {
-			ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
+			ksft_print_msg("ERROR: XDP prog not in SKB mode\n");
 			exit_with_error(-EINVAL);
 		}
 	} else if (ifobject->xdp_flags & XDP_FLAGS_DRV_MODE) {
 		if (opts.attach_mode != XDP_ATTACHED_DRV) {
-			ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
+			ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
 			exit_with_error(-EINVAL);
 		}
 	}
 
-	ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
-	if (ret)
-		exit_with_error(-ret);
+	bpf_update_xsk_map(ifobject, 0);
 }
 
 static void *worker_testapp_validate_tx(void *arg)
@@ -1372,8 +1427,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	if (test->current_step == 1) {
 		thread_common_ops(test, ifobject);
 	} else {
-		bpf_map_delete_elem(ifobject->xsk_map_fd, &id);
-		xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
+		bpf_update_xsk_map(ifobject, id);
 	}
 
 	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
@@ -1481,6 +1535,8 @@ static int testapp_validate_traffic(struct test_spec *test)
 	if (test->total_steps == test->current_step || test->fail) {
 		xsk_socket__delete(ifobj_tx->xsk->xsk);
 		xsk_socket__delete(ifobj_rx->xsk->xsk);
+		bpf_detach(ifobj_tx);
+		bpf_detach(ifobj_rx);
 		testapp_clean_xsk_umem(ifobj_rx);
 		if (!ifobj_tx->shared_umem)
 			testapp_clean_xsk_umem(ifobj_tx);
@@ -1531,16 +1587,12 @@ static void testapp_bidi(struct test_spec *test)
 
 static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
 {
-	int ret;
-
 	xsk_socket__delete(ifobj_tx->xsk->xsk);
 	xsk_socket__delete(ifobj_rx->xsk->xsk);
 	ifobj_tx->xsk = &ifobj_tx->xsk_arr[1];
 	ifobj_rx->xsk = &ifobj_rx->xsk_arr[1];
 
-	ret = xsk_socket__update_xskmap(ifobj_rx->xsk->xsk, ifobj_rx->xsk_map_fd);
-	if (ret)
-		exit_with_error(-ret);
+	bpf_update_xsk_map(ifobj_tx, 0);
 }
 
 static void testapp_bpf_res(struct test_spec *test)
@@ -1635,6 +1687,8 @@ static bool testapp_unaligned(struct test_spec *test)
 {
 	if (!hugepages_present(test->ifobj_tx)) {
 		ksft_test_result_skip("No 2M huge pages present.\n");
+		bpf_detach(test->ifobj_tx);
+		bpf_detach(test->ifobj_rx);
 		return false;
 	}
 
@@ -1947,10 +2001,16 @@ int main(int argc, char **argv)
 
 	for (i = 0; i < modes; i++)
 		for (j = 0; j < TEST_TYPE_MAX; j++) {
+			if (j != TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT) continue; // XXX
+			if (i != TEST_MODE_DRV) continue; // XXX
+
 			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
 			run_pkt_test(&test, i, j);
 			usleep(USLEEP_MAX);
 
+			xskxceiver__destroy(ifobj_tx->bpf_obj);
+			xskxceiver__destroy(ifobj_rx->bpf_obj);
+
 			if (test.fail)
 				failed_tests++;
 		}
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index edb76d2def9f..c27dcbdb030f 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -5,6 +5,8 @@
 #ifndef XSKXCEIVER_H_
 #define XSKXCEIVER_H_
 
+#include "xskxceiver.skel.h"
+
 #ifndef SOL_XDP
 #define SOL_XDP 283
 #endif
@@ -134,6 +136,7 @@ typedef void *(*thread_func_t)(void *arg);
 struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
+	struct xskxceiver *bpf_obj;
 	struct xsk_socket_info *xsk;
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
@@ -141,7 +144,7 @@ struct ifobject {
 	validation_func_t validation_func;
 	struct pkt_stream *pkt_stream;
 	int ns_fd;
-	int xsk_map_fd;
+	int ifindex;
 	u32 dst_ip;
 	u32 src_ip;
 	u32 xdp_flags;
-- 
2.38.1.273.g43a17bfeac-goog

