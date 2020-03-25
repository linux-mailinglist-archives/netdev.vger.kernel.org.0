Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19098192F1A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgCYRXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:23:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47428 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727751AbgCYRXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585157014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYbu9ArKUYiZYJ7/mh+zIxZoPNWoNLkztPFMuDHvDWc=;
        b=F3sKMeOxMo6T5u3eDxFoXUGVPrmSuZcqEwanwJtjrwLVxuxqUuiW20/JRIOlOO/AAWw9cM
        klPylbKnzce7xisKYW/w1k3dOvvqYudPshuNv0HSm1gNPeG+dGKaIo6WW8CBj/1T4dsUFu
        aO2E744iddkSLV/zC2H9vl97uL1SQ0M=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-ad0bHuzhPs-n-E2Vx4QFoA-1; Wed, 25 Mar 2020 13:23:32 -0400
X-MC-Unique: ad0bHuzhPs-n-E2Vx4QFoA-1
Received: by mail-lj1-f198.google.com with SMTP id n3so345283ljg.16
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 10:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sYbu9ArKUYiZYJ7/mh+zIxZoPNWoNLkztPFMuDHvDWc=;
        b=JhSWS8z5hmzJXY24HcM6DRwCTp4m5u1JF4fO20x77cXubavn/JVQzWWVS6qiqBktPF
         51rNCtDMqSKu9YALquzpn5ZI6jnam/N4H8hdzR5O3ZVfCcb66Cem9Y6etZibaOg838gU
         Vlb1Wf8bn2hqP/QSbS7v/K6kQhmis+fimFUsHjISKxKKJWhYhlUSkMfNpobhuq5Qb+3o
         No2Lv5tNwlrvYn3anbngjuLDgueKXgu7adz6H6NdG8XWLim8DOKEk+/Br2Qeogk70NsP
         9ob8mthRYjvKk9DRnfaJ+FLic2InPqX5Gca9n9wjqY01ewD/U921A7/7tpMiV79l2a0d
         QO5w==
X-Gm-Message-State: AGi0Pub8HshI2gC+CbiIBsC+N3WRdrWlMn/ZGemHdG21sr/dBErGYA3U
        hRoheVvmECwtW3MRsPgdZ//lWxCZQ65vk4TyTFTmG/qKCcsjmDWvkubCOqQo+x1eRmn87vwutNm
        bgB+Ui2E2yyGOfJgZ
X-Received: by 2002:a2e:b521:: with SMTP id z1mr2698830ljm.19.1585157011225;
        Wed, 25 Mar 2020 10:23:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypIZUF0t5NXTTUZDr3I2FqJitHTR0+clgh7Avsu79NvNFB36sTuhhdFGQvRHW4WpR+am3tROkA==
X-Received: by 2002:a2e:b521:: with SMTP id z1mr2698804ljm.19.1585157010967;
        Wed, 25 Mar 2020 10:23:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j14sm1277899lfc.32.2020.03.25.10.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:23:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BEA6418158B; Wed, 25 Mar 2020 18:23:29 +0100 (CET)
Subject: [PATCH bpf-next v4 4/4] selftests/bpf: Add tests for attaching XDP
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
Date:   Wed, 25 Mar 2020 18:23:29 +0100
Message-ID: <158515700967.92963.15098921624731968356.stgit@toke.dk>
In-Reply-To: <158515700529.92963.17609642163080084530.stgit@toke.dk>
References: <158515700529.92963.17609642163080084530.stgit@toke.dk>
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
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   62 ++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_attach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
new file mode 100644
index 000000000000..05b294d6b923
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+#define IFINDEX_LO 1
+#define XDP_FLAGS_REPLACE		(1U << 4)
+
+void test_xdp_attach(void)
+{
+	struct bpf_object *obj1, *obj2, *obj3;
+	const char *file = "./test_xdp.o";
+	int err, fd1, fd2, fd3;
+	__u32 duration = 0;
+	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts,
+			    .old_fd = -1);
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
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd1, XDP_FLAGS_REPLACE,
+				       &opts);
+	if (CHECK(err, "load_ok", "initial load failed"))
+		goto out_close;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd2, XDP_FLAGS_REPLACE,
+				       &opts);
+	if (CHECK(!err, "load_fail", "load with expected id didn't fail"))
+		goto out;
+
+	opts.old_fd = fd1;
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd2, 0, &opts);
+	if (CHECK(err, "replace_ok", "replace valid old_fd failed"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd3, 0, &opts);
+	if (CHECK(!err, "replace_fail", "replace invalid old_fd didn't fail"))
+		goto out;
+
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, 0, &opts);
+	if (CHECK(!err, "remove_fail", "remove invalid old_fd didn't fail"))
+		goto out;
+
+	opts.old_fd = fd2;
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, 0, &opts);
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

