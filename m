Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50B62362D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiKIVxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiKIVxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:53:34 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325CA3C6E4;
        Wed,  9 Nov 2022 13:52:49 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id io19so18348578plb.8;
        Wed, 09 Nov 2022 13:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJTZwmsusxeJbHgIbDeXz7BpaeNwMKLsmROONoqlOjE=;
        b=H/3JK2glHGKHQmBjgr/T3CI+6HuQBpwZIg8qPfl2Yd9ldmHZmb/MivqlJD6MnnOK5z
         DLCFTNq6lk42MZdxkMmUxZtvtn1G/1Q5S5TDu9v/ujpwIxtlp1aO9QXJaJfqtN28gSDw
         IiAoDnvYovEdp996YnvYQwGDpz8rcUaFVn+7fCj1LXhxH3wdyFv7O/Q/KAJ8mL/wQI4H
         JoDeQiW0LNjQiQqTqXhztUXyrOmrpHTc2B6/lL83+slc9SfEamyP8g/nNQ2tX5Zkal9h
         /U2jtjdYOqQ+oyrQZR+RE+oXmEdoJtPn+bL28t+WProX3PrYNq4Oev4ALXWw9DysNbcP
         XfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJTZwmsusxeJbHgIbDeXz7BpaeNwMKLsmROONoqlOjE=;
        b=SmieTHP5dSdTlB4/6dZO7IsPvR7Rxa4QTJm3wkgSXrYNqsZNGpC3blxpDzuK1myqBi
         tGG1V1euR1rkxe1dRKo2BDWJwnp7FrSf40bKrqOa9ycFva4LBgxF4jeKf5S3GnH8IStk
         Mwhc/swe3EJQudZANztlQE1PM1wjG+9anQTY1o7X1wABoUMCGkEw30mkVNDo3uxUf/UP
         brgqM8ZoLvZvDKPC0DagM4zeVHhViCgHHc/ZReWeDbwxVx1LW5X3z6Qk6pXdSThMPQgn
         VQtWNGLB0SJp3JZFCaBfMu85UGTI0QQNOcjupWDdzpA4hXCuZbu3x78y06SYaWjhYSZI
         NyOQ==
X-Gm-Message-State: ACrzQf2+d/5po+WOuKcwUQVwHaSVyaO/nIsASzMIc4kpg0OB0kC8YK4H
        Fxn+GsNV/1O/oTnTxJzXa9o=
X-Google-Smtp-Source: AMsMyM4exJa57YfJAKglk9vp6YGZ4kqPRGXRaLAlt1PCAnNVvhd87UIKOjVga0q5SZRH/zQvxyr8+g==
X-Received: by 2002:a17:902:f691:b0:186:b250:9763 with SMTP id l17-20020a170902f69100b00186b2509763mr63945311plg.62.1668030768681;
        Wed, 09 Nov 2022 13:52:48 -0800 (PST)
Received: from john.lan ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id h3-20020aa796c3000000b0056246403534sm8727802pfq.88.2022.11.09.13.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 13:52:48 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     hawk@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, sdf@google.com
Subject: [2/2 bpf-next] bpf: add selftest to read xdp_md fields
Date:   Wed,  9 Nov 2022 13:52:42 -0800
Message-Id: <20221109215242.1279993-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221109215242.1279993-1-john.fastabend@gmail.com>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a selftest to read the xdp_md net_device and extract common
fields we use. This will also compare xdp_md->ifindex with the value
extracted through the dev pointer.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/xdp_md.c | 35 +++++++++++++++++++
 .../testing/selftests/bpf/progs/test_xdp_md.c | 25 +++++++++++++
 2 files changed, 60 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_md.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_md.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_md.c b/tools/testing/selftests/bpf/prog_tests/xdp_md.c
new file mode 100644
index 000000000000..facf3f3ab86f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_md.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_xdp_md.skel.h"
+
+void test_xdp_md(void)
+{
+	struct test_xdp_md *skel;
+	int err, prog_fd;
+	char buf[128];
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.data_out = buf,
+		.data_size_out = sizeof(buf),
+		.repeat = 1,
+	);
+
+	skel = test_xdp_md__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.md_xdp);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(topts.retval, XDP_PASS, "xdp_md test_run retval");
+
+	ASSERT_EQ(skel->bss->ifindex, 1, "xdp_md ifindex");
+	ASSERT_EQ(skel->bss->ifindex, skel->bss->ingress_ifindex, "xdp_md ingress_ifindex");
+	ASSERT_STREQ(skel->bss->name, "lo", "xdp_md name");
+	ASSERT_NEQ(skel->bss->inum, 0, "xdp_md inum");
+
+	test_xdp_md__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_md.c b/tools/testing/selftests/bpf/progs/test_xdp_md.c
new file mode 100644
index 000000000000..66ad4a7c80cd
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_md.c
@@ -0,0 +1,25 @@
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <string.h>
+
+#define	IFNAMSIZ 16
+
+int ifindex, ingress_ifindex;
+char name[IFNAMSIZ];
+unsigned int inum;
+
+SEC("xdp")
+int md_xdp(struct xdp_md *ctx)
+{
+	struct net_device *dev;
+
+	dev = ctx->rx_dev;
+
+	ifindex = dev->ifindex;
+	inum = dev->nd_net.net->ns.inum;
+	memcpy(name, dev->name, IFNAMSIZ);
+	ingress_ifindex = ctx->ingress_ifindex;
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.33.0

