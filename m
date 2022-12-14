Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0424864D2F8
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiLNXDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLNXDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:03:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040AD2654F
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671058981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXNmb9nNU+pTTCz+IAYj7AYrFVzkHxkIMcPQu94dFWI=;
        b=EUIPM9leWQKT2AQybqGOBg+bsgpq+o5JeTs1Spu8CLfyoPeCdWOp+ZrJVss2WZV+mIl4x0
        OHDBaJV6HyPpzDdT6tP4W2lZbJERAbkDq0jM4SqGo9kM284sWxGcAV6VzZTqGN3Bs9mlht
        0CAgdvyVEQCVVRLoRINB9871halHZaY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-110-AJTNNwt3OmmPzv_rrm49aQ-1; Wed, 14 Dec 2022 18:02:59 -0500
X-MC-Unique: AJTNNwt3OmmPzv_rrm49aQ-1
Received: by mail-ed1-f71.google.com with SMTP id s13-20020a056402520d00b0046c78433b54so10572077edd.16
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXNmb9nNU+pTTCz+IAYj7AYrFVzkHxkIMcPQu94dFWI=;
        b=vR4vhYFR+M6y150hK/8jf3M53M5LPXgrxK/EhCyN5HbPxiTOw5s6d8s2lxzVnW1IBr
         EAPWZ3fR6TZH57gyXEIwVL/Bz/BX+e01c6bF+2enr8+jAfcUkOri4Ec3do8KnH7X95Y9
         AJNKPRz6TldLDJ26N9jlzHAdkOGlV2nlTgtxh7V0wGJHkk1yrRLeg4yNNZaFbr0tHub7
         6u9aO+8uMKWqa9+FFXd+naY6NPzIOJRHHd6WGMOBPGPUdmB/17vIYEjEdwZ4uZ9oJYaT
         dP1GgboAfjVBXWz9LDSmN6ld4CPHPazCWi5UNOwAZ7eQVvQ+vKVzq8zwBVbNzUrNcbyv
         wP/Q==
X-Gm-Message-State: ANoB5pkYd2TVirhrMh1gh020hbOprpPzOzVXA/PJOikncOUEqh4M1SH8
        QkuOPACWNUvcJSruAdLPzFcHcxLF3L4iVj6/XkiQOCFnBrhSSYicpXlvDPuOIgXQUoxW8WeqR7H
        F4ZCOMxnhwzXyP8IQ
X-Received: by 2002:a17:907:970b:b0:7c1:9462:2dd3 with SMTP id jg11-20020a170907970b00b007c194622dd3mr7627213ejc.70.1671058978441;
        Wed, 14 Dec 2022 15:02:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6GuqJMgnqY9NOYShhwWGDqAcdpgyPOLBRgnPSQ457FL3KGn01AhMI4AZ7Z0qlaWR1vwbyzag==
X-Received: by 2002:a17:907:970b:b0:7c1:9462:2dd3 with SMTP id jg11-20020a170907970b00b007c194622dd3mr7627184ejc.70.1671058978099;
        Wed, 14 Dec 2022 15:02:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id rk19-20020a170907215300b007c4f6c371a6sm943598ejb.186.2022.12.14.15.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:02:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D3E7A82F659; Thu, 15 Dec 2022 00:02:56 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf v5 2/2] selftests/bpf: Add a test for using a cpumap from an freplace-to-XDP program
Date:   Thu, 15 Dec 2022 00:02:54 +0100
Message-Id: <20221214230254.790066-2-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214230254.790066-1-toke@redhat.com>
References: <20221214230254.790066-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a simple test for inserting an XDP program into a cpumap that is
"owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
does). Prior to the kernel fix this would fail because the map type
ownership would be set to PROG_TYPE_EXT instead of being resolved to
PROG_TYPE_XDP.

v5:
- Fix a few nits from Andrii, add his ACK
v4:
- Use skeletons for selftest
v3:
- Update comment to better explain the cause
- Add Yonghong's ACK

Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 48 +++++++++++++++++++
 .../selftests/bpf/progs/freplace_progmap.c    | 24 ++++++++++
 2 files changed, 72 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index d1e32e792536..20f5fa0fcec9 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -4,6 +4,8 @@
 #include <network_helpers.h>
 #include <bpf/btf.h>
 #include "bind4_prog.skel.h"
+#include "freplace_progmap.skel.h"
+#include "xdp_dummy.skel.h"
 
 typedef int (*test_cb)(struct bpf_object *obj);
 
@@ -500,6 +502,50 @@ static void test_fentry_to_cgroup_bpf(void)
 	bind4_prog__destroy(skel);
 }
 
+static void test_func_replace_progmap(void)
+{
+	struct bpf_cpumap_val value = { .qsize = 1 };
+	struct freplace_progmap *skel = NULL;
+	struct xdp_dummy *tgt_skel = NULL;
+	__u32 key = 0;
+	int err;
+
+	skel = freplace_progmap__open();
+	if (!ASSERT_OK_PTR(skel, "prog_open"))
+		return;
+
+	tgt_skel = xdp_dummy__open_and_load();
+	if (!ASSERT_OK_PTR(tgt_skel, "tgt_prog_load"))
+		goto out;
+
+	err = bpf_program__set_attach_target(skel->progs.xdp_cpumap_prog,
+					     bpf_program__fd(tgt_skel->progs.xdp_dummy_prog),
+					     "xdp_dummy_prog");
+	if (!ASSERT_OK(err, "set_attach_target"))
+		goto out;
+
+	err = freplace_progmap__load(skel);
+	if (!ASSERT_OK(err, "obj_load"))
+		goto out;
+
+	/* Prior to fixing the kernel, loading the PROG_TYPE_EXT 'redirect'
+	 * program above will cause the map owner type of 'cpumap' to be set to
+	 * PROG_TYPE_EXT. This in turn will cause the bpf_map_update_elem()
+	 * below to fail, because the program we are inserting into the map is
+	 * of PROG_TYPE_XDP. After fixing the kernel, the initial ownership will
+	 * be correctly resolved to the *target* of the PROG_TYPE_EXT program
+	 * (i.e., PROG_TYPE_XDP) and the map update will succeed.
+	 */
+	value.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_drop_prog);
+	err = bpf_map_update_elem(bpf_map__fd(skel->maps.cpu_map),
+				  &key, &value, 0);
+	ASSERT_OK(err, "map_update");
+
+out:
+	xdp_dummy__destroy(tgt_skel);
+	freplace_progmap__destroy(skel);
+}
+
 /* NOTE: affect other tests, must run in serial mode */
 void serial_test_fexit_bpf2bpf(void)
 {
@@ -525,4 +571,6 @@ void serial_test_fexit_bpf2bpf(void)
 		test_func_replace_global_func();
 	if (test__start_subtest("fentry_to_cgroup_bpf"))
 		test_fentry_to_cgroup_bpf();
+	if (test__start_subtest("func_replace_progmap"))
+		test_func_replace_progmap();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_progmap.c b/tools/testing/selftests/bpf/progs/freplace_progmap.c
new file mode 100644
index 000000000000..81b56b9aa7d6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_progmap.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__type(key, __u32);
+	__type(value, struct bpf_cpumap_val);
+	__uint(max_entries, 1);
+} cpu_map SEC(".maps");
+
+SEC("xdp/cpumap")
+int xdp_drop_prog(struct xdp_md *ctx)
+{
+	return XDP_DROP;
+}
+
+SEC("freplace")
+int xdp_cpumap_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&cpu_map, 0, XDP_PASS);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.38.1

