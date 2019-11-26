Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7051C109BC1
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfKZKIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:08:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41684 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfKZKIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:08:46 -0500
Received: by mail-pl1-f193.google.com with SMTP id t8so7862979plr.8;
        Tue, 26 Nov 2019 02:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Sl43iVtC4+YcjLflynrQtIj0zEs25bg62I/x2OEQu0=;
        b=rA6x08okN9S24McUdG2LHlghnPmhIHd24jmymmQaGlT2PAs6RXcIrFN4KgQ3vtEJQH
         ienFzUlPPNlyI9b9KsozGHG9jQpVMUrYON+jnaQvRyei7uhWiVfPBjDJK/c0EY88qnZp
         ZDkq7a+rI2J1MXnLhIb+/EQ22pDhhmb3BAM7x8wEHqFYQ02bE0rYvl/KjEMarmxBop+q
         p94+hXB+SsDfHHCvbR+iONGBx5fsJeIFS9XDNF/UJ7uD0+X9HjxSjqCZa8oiIpnB76Hg
         UUUoXmIcImh1gfbohC0t5i//haGFawSR5oYyXeA/IjzMZkOh/+g99F3i75HTqeit7+cx
         TveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Sl43iVtC4+YcjLflynrQtIj0zEs25bg62I/x2OEQu0=;
        b=lUXdYO1z8ShuHf00pGQ3lfGv76p2GfSL0c171Kgr4bhMpbfML5s4IlrqtgkGiK8kf0
         znp/A5cd6LGhCTEqpAw3U3RFedFSeAp/A/V76nMEF7W1qq6LsdKJMd3zZYcK2Mk7G1d8
         EBh/O2Fc4s5e8K3QlT44wfZGJMlIfac6KhsF9pKyhiSzcROIV7g+zpp5mWauqcLH0VTF
         oGAUAJzFcZUBBBYeK0QBacNeeJ1IVVkfJQMv2UGkEtDngTIXWtbTkm1jGYO9UDvriiAi
         NswRWo3THH/oEeEVV8GsDNcFf29j9Np4vN7UiKhdFMjiJcVHj5205XcPzRD1yhf4dMJQ
         2MUQ==
X-Gm-Message-State: APjAAAUT1eZcJA1LzvTGPo0+e6lvrqCOKbGpMvkdRgyGo6mJLwUgH/Ap
        It6Wr0q0VfOrNDRu5n2uwgQ=
X-Google-Smtp-Source: APXvYqxA6tuNs0G2K7BYOi/UgwxlWXR+3qbxnD5Hrpm6hj4529qhKxDgIXplkY5qr6yeBIl6U2CJIw==
X-Received: by 2002:a17:90a:5aa3:: with SMTP id n32mr5651673pji.97.1574762926051;
        Tue, 26 Nov 2019 02:08:46 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:08:45 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 01/18] bpf: introduce bpf_prog_offload_verifier_setup()
Date:   Tue, 26 Nov 2019 19:07:27 +0900
Message-Id: <20191126100744.5083-2-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

Background:
This change was initiated from virtio_net XDP offload work. As per
the implementation plan, a copy of original program with map fds from
guest replaced with map fds from host needs to be offloaded to the
host. To implement this fd replacement, insn_hook() must provide an
insn with map fd intact. bpf_map and driver specific map data can be
derived from map_fd.

Since verifier calls all the offload callbacks after replacing map
fds, it was difficult to implement virtio_net XDP offload feature.
If virtio_net gets only one callback with original bpf program, it
will get a chance to perform the fd replacement in its own copy of the
program.

Solution:
Let's introduce a setup() callback in bpf_prog_offload_ops. It will be
non mandetory. The verifier will call it just before replacing the map
fds.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/bpf.h          |  1 +
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/offload.c         | 14 ++++++++++++++
 kernel/bpf/verifier.c        |  6 ++++++
 4 files changed, 22 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35903f148be5..1cdba120357c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -361,6 +361,7 @@ struct bpf_prog_offload_ops {
 			    struct bpf_insn *insn);
 	int (*remove_insns)(struct bpf_verifier_env *env, u32 off, u32 cnt);
 	/* program management callbacks */
+	int (*setup)(struct bpf_prog *prog);
 	int (*prepare)(struct bpf_prog *prog);
 	int (*translate)(struct bpf_prog *prog);
 	void (*destroy)(struct bpf_prog *prog);
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 26e40de9ef55..de7028e17c0d 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -418,6 +418,7 @@ static inline struct bpf_reg_state *cur_regs(struct bpf_verifier_env *env)
 	return cur_func(env)->regs;
 }
 
+int bpf_prog_offload_verifier_setup(struct bpf_prog *prog);
 int bpf_prog_offload_verifier_prep(struct bpf_prog *prog);
 int bpf_prog_offload_verify_insn(struct bpf_verifier_env *env,
 				 int insn_idx, int prev_insn_idx);
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 5b9da0954a27..04ca7a31d947 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -124,6 +124,20 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	return err;
 }
 
+int bpf_prog_offload_verifier_setup(struct bpf_prog *prog)
+{
+	struct bpf_prog_offload *offload;
+	int ret = 0;
+
+	down_read(&bpf_devs_lock);
+	offload = prog->aux->offload;
+	if (offload && offload->offdev->ops->setup)
+		ret = offload->offdev->ops->setup(prog);
+	up_read(&bpf_devs_lock);
+
+	return ret;
+}
+
 int bpf_prog_offload_verifier_prep(struct bpf_prog *prog)
 {
 	struct bpf_prog_offload *offload;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a0482e1c4a77..94b43542439e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9737,6 +9737,12 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 
 	env->allow_ptr_leaks = is_priv;
 
+	if (bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = bpf_prog_offload_verifier_setup(env->prog);
+		if (ret)
+			goto skip_full_check;
+	}
+
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
 
-- 
2.20.1

