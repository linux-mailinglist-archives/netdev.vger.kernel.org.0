Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8517918D514
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgCTQ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:56:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52123 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727692AbgCTQ4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584723376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+kdxHN4Aw50ZGEywCIGDQ0nEgiFhegivX0saPcWODnM=;
        b=ef9BLUrazRdvc+2jr+PN6JeUSS74MWybjreEbS9t/BQhw4ENtT6fqW8+6vS8PwE84YLEht
        02+XReBcbQYAbYPxERRssaXnZocg5yif1xMkITqqCu68EMUnpK6kdeVyDjQ0d6gadOuJp0
        fGcWwL3a3ir4iaUFJCHH76GsegyYAJE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-XYGYUnGIMTCEvG78IdeSkw-1; Fri, 20 Mar 2020 12:56:15 -0400
X-MC-Unique: XYGYUnGIMTCEvG78IdeSkw-1
Received: by mail-wr1-f71.google.com with SMTP id q18so2907207wrw.5
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+kdxHN4Aw50ZGEywCIGDQ0nEgiFhegivX0saPcWODnM=;
        b=PHm2SR6AHYc9eMB7T2wmKAe32qd/6/AO4sKP9R+rK/jLrhG84GFm8oWkvoqx34cfIX
         SoROBlcB9sDtnyyoPCHtF+6uklT8qXxoakIWoi5ac0bKh46KSoYg5eUieBYs7TcmRoKk
         DOkCZs7zdpFTJ/eJOwR5xM3rKxEL6RHAn4P9577IU2L5CqGzdCwGaEfrnbqyqgG1dESp
         P2ewIBXy+cWMSiovG69QKsYggxPNTRuECCR/C+SMsqtV5P6mX95uBkuZD4WLL2BETaLM
         GjXVt/1JYpt5vzUHXs5wnTom8RRHYp/VBj74AFEFT2kkW/fa9U4dLktXsZBgZh3HI9Z5
         XJvA==
X-Gm-Message-State: ANhLgQ2sBkdfwUWkWMiAmjmqFdtM4YRnwBtYWI7D1S40WEDWOYMtoF8Z
        fEpQjQIAEA0EdXajYBsRFk+A8DQd47nEZB7lHbaEfGmL+DP2Ojhpvy13ST4V4BsgRPmIK5fHEVX
        ofwsaZcJPHu1QEa5k
X-Received: by 2002:adf:ea88:: with SMTP id s8mr12837494wrm.124.1584723373940;
        Fri, 20 Mar 2020 09:56:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vscFIY04jprprjlJLR1NfOFn1MpsCnzxlnKZCA45VXaWrGMdR3TawMLC1jO5YaRNHWBwCwptw==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr12837475wrm.124.1584723373764;
        Fri, 20 Mar 2020 09:56:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c5sm11981008wma.3.2020.03.20.09.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 09:56:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB344180371; Fri, 20 Mar 2020 17:56:11 +0100 (CET)
Subject: [PATCH bpf-next v2 4/4] selftests/bpf: Add tests for attaching XDP
 programs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 20 Mar 2020 17:56:11 +0100
Message-ID: <158472337187.296548.15379933456613894354.stgit@toke.dk>
In-Reply-To: <158472336748.296548.5028326196275429565.stgit@toke.dk>
References: <158472336748.296548.5028326196275429565.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds tests for the various replacement operations using
IFLA_XDP_EXPECTED_FD.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   55 ++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_attach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
new file mode 100644
index 000000000000..c41d9a1d4eb1
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+#define IFINDEX_LO 1
+
+void test_xdp_attach(void)
+{
+	struct bpf_object *obj1, *obj2, *obj3;
+	const char *file = "./test_xdp.o";
+	int err, fd1, fd2, fd3;
+	__u32 duration = 0;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj1, &fd1);
+	if (CHECK_FAIL(err))
+		return;
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj2, &fd2);
+	if (CHECK_FAIL(err))
+		goto out_1;
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj3, &fd3);
+	if (CHECK_FAIL(err))
+		goto out_2;
+
+	err = bpf_set_link_xdp_fd_replace(IFINDEX_LO, fd1, -1, 0);
+	if (CHECK(err, "load_ok", "initial load failed"))
+		goto out_close;
+
+	err = bpf_set_link_xdp_fd_replace(IFINDEX_LO, fd2, -1, 0);
+	if (CHECK(!err, "load_fail", "load with expected fd didn't fail"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_replace(IFINDEX_LO, fd2, fd1, 0);
+	if (CHECK(err, "replace_ok", "replace valid old_fd failed"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_replace(IFINDEX_LO, fd3, fd1, 0);
+	if (CHECK(!err, "replace_fail", "replace invalid old_fd didn't fail"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_replace(IFINDEX_LO, -1, fd1, 0);
+	if (CHECK(!err, "remove_fail", "remove invalid old_fd didn't fail"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_replace(IFINDEX_LO, -1, fd2, 0);
+	if (CHECK(err, "remove_ok", "remove valid old_fd failed"))
+		goto out;
+
+out:
+	bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
+out_close:
+	bpf_object__close(obj3);
+out_2:
+	bpf_object__close(obj2);
+out_1:
+	bpf_object__close(obj1);
+}

