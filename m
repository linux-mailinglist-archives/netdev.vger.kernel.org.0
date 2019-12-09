Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5911F116E3C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfLINzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:39 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44409 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLINzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:39 -0500
Received: by mail-pl1-f194.google.com with SMTP id bh2so4717860plb.11;
        Mon, 09 Dec 2019 05:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLNlGhqLYHCsO91lGPZ7ui8kT0agkrSOimXTiG5x1G8=;
        b=PqRpISSmXoWMWkMKZlV7XUrMTBgiYusZ3Uk58H2X4HUyE6cWMJ2pBKuTYvfNtomlUP
         qmtaZGDTdmEyX+S7nw56L3tlIeS5QPMHfV/LOosKF0lyD0UpBYBk5WJ8tXi3GoURzxsY
         2Hk4MolcySsN2mMmL8Dzlt6N4RgVHuHL4bAca4ZP2g4twOp2gZnLpC7YDPUDXsItEj04
         sd2nuECOYRmiFyZ3MVaCmq70ViSV7jtXgLlDYcmFIUBvlyh9dqehsqC9lYL+5iafS6PT
         HFC/N16iDQBB4VNH/SuXjJdtHDlQducywx+0EMsFW24JDk9z5LuAM9tZHuY8SP0rmixf
         VY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLNlGhqLYHCsO91lGPZ7ui8kT0agkrSOimXTiG5x1G8=;
        b=SxPbRaOtG5jP+IVa/XuM7BQxgDAbGxT7bzb9CDjNNWf7hUusJjquNJs1h5c9sIeFiq
         4QrYne5SAYyYGxSvJ6N08lvSx5M1tXbc158+Npr3Nrg7wV2ZeeuP7hRZZOuNXgZOrgUI
         ECBlELaQuL9zyjWY4V7HR1WEcKOsKQPN25C8kuQRKvryCm0AiJWDVbwA8y54QG9dDb5r
         WI1uMez+gF4pd+5n4EASapoxZ4DVVU0e/wL2MZ8uCtKHL2B34DOWbIbXoeE69/da0k89
         29KR0YKWqJsPY5HY4zuhurwOjc/azEKRNYkhlzUJU7nhRq6J+5bKCQdv5xMiyaB600Pg
         pUoA==
X-Gm-Message-State: APjAAAVrhaZZvFeOJWchw12nP4eH1sG9pb6+kbx2K88egG59eaLWsgrC
        IRl/KxniEL589atgwxMnF0GuTf7PyHwVxQ==
X-Google-Smtp-Source: APXvYqxYXbn9K3P2T5UoQiM3KClTN0V961T9AWpfwrl/03IQwNHY5xeM7Fj2lw/hNixAHoRDQg7+9Q==
X-Received: by 2002:a17:90a:8a98:: with SMTP id x24mr33539244pjn.113.1575899738300;
        Mon, 09 Dec 2019 05:55:38 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:37 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 1/6] bpf: move trampoline JIT image allocation to a function
Date:   Mon,  9 Dec 2019 14:55:17 +0100
Message-Id: <20191209135522.16576-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Refactor the image allocation in the BPF trampoline code into a
separate function, so it can be shared with the BPF dispatcher in
upcoming commits.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h     |  1 +
 kernel/bpf/trampoline.c | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35903f148be5..5d744828b399 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -475,6 +475,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+void *bpf_jit_alloc_exec_page(void);
 #else
 static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7e89f1f49d77..5ee301ddbd00 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -13,6 +13,22 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
 
+void *bpf_jit_alloc_exec_page(void)
+{
+	void *image;
+
+	image = bpf_jit_alloc_exec(PAGE_SIZE);
+	if (!image)
+		return NULL;
+
+	set_vm_flush_reset_perms(image);
+	/* Keep image as writeable. The alternative is to keep flipping ro/rw
+	 * everytime new program is attached or detached.
+	 */
+	set_memory_x((long)image, 1);
+	return image;
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -33,7 +49,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 		goto out;
 
 	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
-	image = bpf_jit_alloc_exec(PAGE_SIZE);
+	image = bpf_jit_alloc_exec_page();
 	if (!image) {
 		kfree(tr);
 		tr = NULL;
@@ -47,12 +63,6 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	mutex_init(&tr->mutex);
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
-
-	set_vm_flush_reset_perms(image);
-	/* Keep image as writeable. The alternative is to keep flipping ro/rw
-	 * everytime new program is attached or detached.
-	 */
-	set_memory_x((long)image, 1);
 	tr->image = image;
 out:
 	mutex_unlock(&trampoline_mutex);
-- 
2.20.1

