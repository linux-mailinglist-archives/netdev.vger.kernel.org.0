Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A27126069
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLSLER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:04:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28596 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726699AbfLSLER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:04:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576753455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=s87526mx9qsysBObwAI2WyHflUMBtSSBLp0eIi2jCtI=;
        b=e0mdoaxIn/vQDSBJET8xv6BUuWX5VaEceC3R6Frj9rgChkpysxrDAVwBvrwEzx7gDDxBOx
        h86y87Pl075zdYjH3ofI5oSFZ7Y1iD8sVlRs34XCugP0VofQogudIu4ZOzxA7Jz0cD3Ubf
        WFiblFQ9VWQfBLoCNxdhvYsNQ0L2/AA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-sPsUsn4YPQW-41SjKAElsA-1; Thu, 19 Dec 2019 06:04:13 -0500
X-MC-Unique: sPsUsn4YPQW-41SjKAElsA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47455800D48;
        Thu, 19 Dec 2019 11:04:12 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE3E010013A1;
        Thu, 19 Dec 2019 11:04:11 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf fentry/fexit trace to an XDP program
Date:   Thu, 19 Dec 2019 11:03:29 +0000
Message-Id: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that will attach a FENTRY and FEXIT program to the XDP test
program. It will also verify data from the XDP context on FENTRY and
verifies the return code on exit.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   95 ++++++++++++++=
++++++
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++
 2 files changed, 139 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
new file mode 100644
index 000000000000..175364843ec5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <net/if.h>
+
+#define PROG_CNT 2
+
+void test_xdp_bpf2bpf(void)
+{
+	const char *prog_name[PROG_CNT] =3D {
+		"fentry/_xdp_tx_iptunnel",
+		"fexit/_xdp_tx_iptunnel"
+	};
+	struct bpf_link *link[PROG_CNT] =3D {};
+	struct bpf_program *prog[PROG_CNT];
+	struct bpf_map *data_map;
+	const int zero =3D 0;
+	u64 result[PROG_CNT];
+	struct vip key4 =3D {.protocol =3D 6, .family =3D AF_INET};
+	struct iptnl_info value4 =3D {.family =3D AF_INET};
+	const char *file =3D "./test_xdp.o";
+	struct bpf_object *obj, *tracer_obj =3D NULL;
+	char buf[128];
+	struct iphdr *iph =3D (void *)buf + sizeof(struct ethhdr);
+	__u32 duration, retval, size;
+	int err, prog_fd, map_fd;
+
+	/* Load XDP program to introspect */
+	err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	map_fd =3D bpf_find_map(__func__, obj, "vip2tnl");
+	if (map_fd < 0)
+		goto out;
+	bpf_map_update_elem(map_fd, &key4, &value4, 0);
+
+	/* Load eBPF trace program */
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			    .attach_prog_fd =3D prog_fd,
+			   );
+
+	tracer_obj =3D bpf_object__open_file("./test_xdp_bpf2bpf.o", &opts);
+	if (CHECK(IS_ERR_OR_NULL(tracer_obj), "obj_open",
+		  "failed to open test_xdp_bpf2bpf: %ld\n",
+		  PTR_ERR(tracer_obj)))
+		goto out;
+
+	err =3D bpf_object__load(tracer_obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto out;
+
+	for (int i =3D 0; i < PROG_CNT; i++) {
+		prog[i] =3D bpf_object__find_program_by_title(tracer_obj,
+							    prog_name[i]);
+		if (CHECK(!prog[i], "find_prog", "prog %s not found\n",
+			  prog_name[i]))
+			goto out;
+		link[i] =3D bpf_program__attach_trace(prog[i]);
+		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
+			goto out;
+	}
+	data_map =3D bpf_object__find_map_by_name(tracer_obj, "test_xdp.bss");
+	if (CHECK(!data_map, "find_data_map", "data map not found\n"))
+		goto out;
+
+	/* Run test program */
+	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval !=3D XDP_TX || size !=3D 74 ||
+	      iph->protocol !=3D IPPROTO_IPIP, "ipv4",
+	      "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	/* Verify test results */
+	err =3D bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, &result);
+	if (CHECK(err, "get_result",
+		  "failed to get output data: %d\n", err))
+		goto out;
+
+	if (CHECK(result[0] !=3D if_nametoindex("lo"),
+		  "result", "%s failed err %ld\n", prog_name[0], result[0]))
+		goto out;
+
+	if (CHECK(result[1] !=3D XDP_TX, "result", "%s failed err %ld\n",
+		  prog_name[1], result[1]))
+		goto out;
+out:
+	for (int i =3D 0; i < PROG_CNT; i++)
+		if (!IS_ERR_OR_NULL(link[i]))
+			bpf_link__destroy(link[i]);
+	if (!IS_ERR_OR_NULL(tracer_obj))
+		bpf_object__close(tracer_obj);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
new file mode 100644
index 000000000000..82b87b2fc4e1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+#include "bpf_trace_helpers.h"
+
+struct net_device {
+	/* Structure does not need to contain all entries,
+	 * as "preserve_access_index" will use BTF to fix this...
+	 */
+	int ifindex;
+} __attribute__((preserve_access_index));
+
+struct xdp_rxq_info {
+	/* Structure does not need to contain all entries,
+	 * as "preserve_access_index" will use BTF to fix this...
+	 */
+	struct net_device *dev;
+	__u32 queue_index;
+} __attribute__((preserve_access_index));
+
+struct xdp_buff {
+	void *data;
+	void *data_end;
+	void *data_meta;
+	void *data_hard_start;
+	unsigned long handle;
+	struct xdp_rxq_info *rxq;
+} __attribute__((preserve_access_index));
+
+static volatile __u64 test_result_fentry;
+BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
+	    struct xdp_buff *, xdp)
+{
+	test_result_fentry =3D xdp->rxq->dev->ifindex;
+	return 0;
+}
+
+static volatile __u64 test_result_fexit;
+BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
+	    struct xdp_buff*, xdp, int, ret)
+{
+	test_result_fexit =3D ret;
+	return 0;
+}

