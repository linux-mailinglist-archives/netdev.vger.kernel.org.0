Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3721918B3
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCXSNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:13:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:32448 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727775AbgCXSNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585073584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3Wa07YAd+zFovCvokyH5i/22yVWoZ1gMGqsMWsRY8s=;
        b=ZdHY1X7AYZNTJF9sZq+L+3HEne/qS+HjWWHoE2W7+PCAFHBjcHQ0IyKsdyPmip9NZ1/why
        fWOI5fcG2cyPrnmj72OsNl7O8AQIcbiJe0h4cKLOfGcV8obZVuHvkAoBGAwZDa5Ho4HEv3
        nx8W61R3uledvZJ5a8tdZ1WdESpPbww=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-7ZAXlAvJMTG_xdGX69ZPOQ-1; Tue, 24 Mar 2020 14:13:02 -0400
X-MC-Unique: 7ZAXlAvJMTG_xdGX69ZPOQ-1
Received: by mail-wr1-f69.google.com with SMTP id h17so9614342wru.16
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 11:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R3Wa07YAd+zFovCvokyH5i/22yVWoZ1gMGqsMWsRY8s=;
        b=apSra0s5CRB5QCk080HTlOKOpxf2qaGy+AJhn3DyGLxkNXnn1vZ2vbT4QdRJJ8DLoX
         e5hlC4N+qjrE73SEl1QfNU1W9uSOmQMANFHABqOQAOCrVY6W1n5vAqf5Vjl0KYPQ0Nz3
         SLTJKe0cqH73/TXCCRo4X32RPu4OBvkA0CwdXuuQ2aEGRhr8ylm14tDa5fbbTdMcutz4
         /JEoSpFC9hegiKdVel4Hpf6RQJ2yLwAfjf8c3fqxVftrmqTp+nXh+9Zyi8lUuCpP5lrL
         KUMKZTgcTOnBe3/4YE5Op6p4XPCxDh4gJgxGcgUwpYUlOQWcyRZ/j/GTYgJGfZPNbio+
         QkCA==
X-Gm-Message-State: ANhLgQ3GgGTDH1VEJrhqABL7Z3QlgxBXlXaaIHo5azJhim3yW8IXlUeQ
        PuKQQiZ9l+j3QesWA1tonoZEfwtDEuxQOPIePQXZD3nurOY9Ij85QKZ3YsISzdNhPNDn+574jIf
        BYaqy/0A9cRTmePXm
X-Received: by 2002:a05:600c:2101:: with SMTP id u1mr7012082wml.177.1585073581085;
        Tue, 24 Mar 2020 11:13:01 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvpNYRWpV6uRP+NqVy6W9zqRQjKTec8plOaPvuVG45PE92D30xfQiDfaCz8oZmdrLiInBErZw==
X-Received: by 2002:a05:600c:2101:: with SMTP id u1mr7012049wml.177.1585073580838;
        Tue, 24 Mar 2020 11:13:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j2sm13308840wrs.64.2020.03.24.11.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:12:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5C64118158B; Tue, 24 Mar 2020 19:12:56 +0100 (CET)
Subject: [PATCH bpf-next v3 4/4] selftests/bpf: Add tests for attaching XDP
 programs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Date:   Tue, 24 Mar 2020 19:12:56 +0100
Message-ID: <158507357632.6925.5524660251258919856.stgit@toke.dk>
In-Reply-To: <158507357205.6925.17804771242752938867.stgit@toke.dk>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk>
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
IFLA_XDP_EXPECTED_ID.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   74 ++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_attach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
new file mode 100644
index 000000000000..190df7599107
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+#define IFINDEX_LO 1
+#define XDP_FLAGS_EXPECT_ID		(1U << 4)
+
+void test_xdp_attach(void)
+{
+	struct bpf_object *obj1, *obj2, *obj3;
+	const char *file = "./test_xdp.o";
+	struct bpf_prog_info info = {};
+	__u32 duration = 0, id1, id2;
+	__u32 len = sizeof(info);
+	int err, fd1, fd2, fd3;
+	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts);
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
+	err = bpf_obj_get_info_by_fd(fd1, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_2;
+	id1 = info.id;
+
+	memset(&info, 0, sizeof(info));
+	err = bpf_obj_get_info_by_fd(fd2, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_2;
+	id2 = info.id;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd1, XDP_FLAGS_EXPECT_ID,
+				       &opts);
+	if (CHECK(err, "load_ok", "initial load failed"))
+		goto out_close;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd2, XDP_FLAGS_EXPECT_ID,
+				       &opts);
+	if (CHECK(!err, "load_fail", "load with expected id didn't fail"))
+		goto out;
+
+	opts.old_id = id1;
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd2, 0, &opts);
+	if (CHECK(err, "replace_ok", "replace valid old_id failed"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd3, 0, &opts);
+	if (CHECK(!err, "replace_fail", "replace invalid old_id didn't fail"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, 0, &opts);
+	if (CHECK(!err, "remove_fail", "remove invalid old_id didn't fail"))
+		goto out;
+
+	opts.old_id = id2;
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, 0, &opts);
+	if (CHECK(err, "remove_ok", "remove valid old_id failed"))
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

