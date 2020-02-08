Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCEB156537
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgBHPnJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:43:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727581AbgBHPnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:43:09 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-_G4WUAj2MtSddpsluOlogQ-1; Sat, 08 Feb 2020 10:43:04 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 551C58014CE;
        Sat,  8 Feb 2020 15:43:02 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60BD65C28F;
        Sat,  8 Feb 2020 15:42:59 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 12/14] bpf: Add trampolines to kallsyms
Date:   Sat,  8 Feb 2020 16:42:07 +0100
Message-Id: <20200208154209.1797988-13-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: _G4WUAj2MtSddpsluOlogQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding trampolines to kallsyms. It's displayed as
  bpf_trampoline_<ID> [bpf]

where ID is the BTF id of the trampoline function.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  2 ++
 kernel/bpf/trampoline.c | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7a4626c8e747..b91bac10d3ea 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -502,6 +502,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	void *image;
 	u64 selector;
+	struct bpf_ksym ksym;
 };
 
 #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
@@ -573,6 +574,7 @@ struct bpf_image {
 #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
 bool is_bpf_image_address(unsigned long address);
 void *bpf_image_alloc(void);
+void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
 /* Called only from code, so there's no need for stubs. */
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6b264a92064b..1ee29907cbe5 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -96,6 +96,15 @@ bool is_bpf_image_address(unsigned long addr)
 	return ret;
 }
 
+void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
+{
+	struct bpf_image *image = container_of(data, struct bpf_image, data);
+
+	ksym->start = (unsigned long) image;
+	ksym->end = ksym->start + PAGE_SIZE;
+	bpf_ksym_add(ksym);
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -131,6 +140,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
 	tr->image = image;
+	INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
@@ -267,6 +277,15 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
 	}
 }
 
+static void bpf_trampoline_kallsyms_add(struct bpf_trampoline *tr)
+{
+	struct bpf_ksym *ksym = &tr->ksym;
+
+	snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu",
+		 tr->key & ((u64) (1LU << 32) - 1));
+	bpf_image_ksym_add(tr->image, &tr->ksym);
+}
+
 int bpf_trampoline_link_prog(struct bpf_prog *prog)
 {
 	enum bpf_tramp_prog_type kind;
@@ -311,6 +330,8 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 	if (err) {
 		hlist_del(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
+	} else if (cnt == 0) {
+		bpf_trampoline_kallsyms_add(tr);
 	}
 out:
 	mutex_unlock(&tr->mutex);
@@ -336,6 +357,8 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
+	if (!(tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]))
+		bpf_ksym_del(&tr->ksym);
 	err = bpf_trampoline_update(prog->aux->trampoline);
 out:
 	mutex_unlock(&tr->mutex);
-- 
2.24.1

