Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4441E964E
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgEaI3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgEaI3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:29:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1C7C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p18so4946516eds.7
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p7Yz1Ip/MdlQVatt3PrHLJX21WMp8fUAAaz80EdCwFw=;
        b=o6dsmiTYf1nmamQbX3iy5KIQGliZaMFhLv2lm/tzjm2iUiROzilVlnhC70IooAhoif
         LiDr/ZjbFjhwdf++OXnrB0QPg+7Cn3GbrnShv7qxUmvUWxXeGKGGt0+r6TiWo9oyz1OZ
         tVogZ+/abswlkulESv4QBKirZOL7oB0r3njSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p7Yz1Ip/MdlQVatt3PrHLJX21WMp8fUAAaz80EdCwFw=;
        b=F82jpM2d7ShrFF19Q1CRWjfK4OLAN+n74gwYJUO02FYHq47qp/Bp6Uh8NLyfapSoAA
         ooAVAfzMaCtL6PUwbMhJJrls4Ufrx8Arafcnr6W67BaW8n7wdpj0NhEYH/lS8zOCtwOf
         Oe9RFEFqN8lQ159mQrBrD1syYRbozUddVYs3DFTPdoAhgrHhgktF1wmf7kmG8CiU3R8y
         VSFnWJdLPguum4UeRq6vOJ9Iz+y3RxNh5FnZGTBnVHa7jTKRxCurhfZdNNoxbER6NckT
         lAJsrokknU0eyJQCyWDoWZXLrsGYIcVj4jqVUt3xmfOM94S2rSODwv2pt/7EBxrTPzNK
         OvMA==
X-Gm-Message-State: AOAM530YBSvqct5pSJH1xKzfnKSXwV8Hp8/qtYayxNXvdRfzcEgrcp1l
        NLCBbfDkjsib5qui8fjch2A/Ig==
X-Google-Smtp-Source: ABdhPJwREDxtX70i/qUVtnlgDxgodf5WEFJvL8iYmyEL0DLrqbFHgurke7mOfp4OjV6iQJ/zr1ltxQ==
X-Received: by 2002:a05:6402:22b3:: with SMTP id cx19mr4165306edb.329.1590913750418;
        Sun, 31 May 2020 01:29:10 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e8sm12781700edk.42.2020.05.31.01.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:29:10 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 11/12] selftests/bpf: Convert test_flow_dissector to use BPF skeleton
Date:   Sun, 31 May 2020 10:28:45 +0200
Message-Id: <20200531082846.2117903-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch flow dissector test setup from custom BPF object loader to BPF
skeleton to save boilerplate and prepare for testing higher-level API for
attaching flow dissector with bpf_link.

To avoid depending on program order in the BPF object when populating the
flow dissector PROG_ARRAY map, change the program section names to contain
the program index into the map. This follows the example set by tailcall
tests.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/flow_dissector.c | 50 +++++++++++++++++--
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 20 ++++----
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index ef5aab2f60b5..b6370c0b3b7a 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -6,6 +6,8 @@
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 
+#include "bpf_flow.skel.h"
+
 #ifndef IP_MF
 #define IP_MF 0x2000
 #endif
@@ -444,17 +446,54 @@ static int ifup(const char *ifname)
 	return 0;
 }
 
+static int init_prog_array(struct bpf_object *obj, struct bpf_map *prog_array)
+{
+	int i, err, map_fd, prog_fd;
+	struct bpf_program *prog;
+	char prog_name[32];
+
+	map_fd = bpf_map__fd(prog_array);
+	if (map_fd < 0)
+		return -1;
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		snprintf(prog_name, sizeof(prog_name), "flow_dissector/%i", i);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (!prog)
+			return -1;
+
+		prog_fd = bpf_program__fd(prog);
+		if (prog_fd < 0)
+			return -1;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (err)
+			return -1;
+	}
+	return 0;
+}
+
 void test_flow_dissector(void)
 {
 	int i, err, prog_fd, keys_fd = -1, tap_fd;
-	struct bpf_object *obj;
+	struct bpf_flow *skel;
 	__u32 duration = 0;
 
-	err = bpf_flow_load(&obj, "./bpf_flow.o", "flow_dissector",
-			    "jmp_table", "last_dissection", &prog_fd, &keys_fd);
-	if (CHECK_FAIL(err))
+	skel = bpf_flow__open_and_load();
+	if (CHECK(!skel, "skel", "failed to open/load skeleton\n"))
 		return;
 
+	prog_fd = bpf_program__fd(skel->progs._dissect);
+	if (CHECK(prog_fd < 0, "bpf_program__fd", "err %d\n", prog_fd))
+		goto out_destroy_skel;
+	keys_fd = bpf_map__fd(skel->maps.last_dissection);
+	if (CHECK(keys_fd < 0, "bpf_map__fd", "err %d\n", keys_fd))
+		goto out_destroy_skel;
+	err = init_prog_array(skel->obj, skel->maps.jmp_table);
+	if (CHECK(err, "init_prog_array", "err %d\n", err))
+		goto out_destroy_skel;
+
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		struct bpf_flow_keys flow_keys;
 		struct bpf_prog_test_run_attr tattr = {
@@ -526,5 +565,6 @@ void test_flow_dissector(void)
 
 	close(tap_fd);
 	bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
-	bpf_object__close(obj);
+out_destroy_skel:
+	bpf_flow__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 9941f0ba471e..de6de9221518 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -20,20 +20,20 @@
 #include <bpf/bpf_endian.h>
 
 int _version SEC("version") = 1;
-#define PROG(F) SEC(#F) int bpf_func_##F
+#define PROG(F) PROG_(F, _##F)
+#define PROG_(NUM, NAME) SEC("flow_dissector/"#NUM) int bpf_func##NAME
 
 /* These are the identifiers of the BPF programs that will be used in tail
  * calls. Name is limited to 16 characters, with the terminating character and
  * bpf_func_ above, we have only 6 to work with, anything after will be cropped.
  */
-enum {
-	IP,
-	IPV6,
-	IPV6OP,	/* Destination/Hop-by-Hop Options IPv6 Extension header */
-	IPV6FR,	/* Fragmentation IPv6 Extension Header */
-	MPLS,
-	VLAN,
-};
+#define IP		0
+#define IPV6		1
+#define IPV6OP		2 /* Destination/Hop-by-Hop Options IPv6 Ext. Header */
+#define IPV6FR		3 /* Fragmentation IPv6 Extension Header */
+#define MPLS		4
+#define VLAN		5
+#define MAX_PROG	6
 
 #define IP_MF		0x2000
 #define IP_OFFSET	0x1FFF
@@ -59,7 +59,7 @@ struct frag_hdr {
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
-	__uint(max_entries, 8);
+	__uint(max_entries, MAX_PROG);
 	__uint(key_size, sizeof(__u32));
 	__uint(value_size, sizeof(__u32));
 } jmp_table SEC(".maps");
-- 
2.25.4

