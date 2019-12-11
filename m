Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2F11AACB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfLKMai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:30:38 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42815 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfLKMai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:30:38 -0500
Received: by mail-pg1-f194.google.com with SMTP id s64so3994678pgb.9;
        Wed, 11 Dec 2019 04:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLNlGhqLYHCsO91lGPZ7ui8kT0agkrSOimXTiG5x1G8=;
        b=Ga7mVGMTQSC5xNd9KZHQWlV9qEm8yoPteflv1CvmGu//VtfoauP0KGIXznyhhnO/j7
         jCB02K8vPAtZewQnPZF0xISo6VgkWouBYeQvAVhFV/5xtBKfCqTe2/TjCVS6pu8yIBKb
         /gSxYv1wxOLRiMbA2ApxItUGZdsAoWJNu1ODGZgfYACNCEll89L0UBFEpsblCm3U+nPA
         SY+noe+8WKVFDbB5+KVBO+of2z6SkOGF6RqGH8hJxEXRasHgmC0B7qTvjknsM4qe2eJR
         EMfrsrDSmTnr1INKV6FC6aCXpCOnfFLdcs69x6S+EDqjte0oop7iyR1Ev+UIQp00SKQi
         7Hng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLNlGhqLYHCsO91lGPZ7ui8kT0agkrSOimXTiG5x1G8=;
        b=KJ0ZI3rJ4T0xaIOt8p1doiLJeAX5vCHNJFT6/qcPcI8a4yJzA/3jWUC3Bd8ZaulfcU
         nFGszSwsoYhBTjmI2k7OCeCzzVMxA5y6YA7CHXL1542W9Ff5sBjweJaI8rPtQ78Msp5d
         CSTMiycLXQO4wtgTKyJ2GYs4nHzvT0ziySYIpUIE6/zyy5y+fDPSPR5f7wKRWR3gpGKF
         3658MG4bwFb+cOSutcxkygguu5qAfRRHDPXZ8WqR9s6L/uMblTz2OkX7/tRLNBOK1jbv
         rKmDYQoFmkdIwuspu9jpCfvpCWFfkO/HrorJq9S4o853aujSx+MhZ4Xi79dXwrSel1go
         uX6A==
X-Gm-Message-State: APjAAAUxj8LlCA/w/2qKiaRsFyR2+iECk8bfCbVQkenZFggSiv/7xZNB
        1d9wLwqQQe3WD3IPaoiHe5gm/sV/2FkYyw==
X-Google-Smtp-Source: APXvYqyTXzNCsuLmLMkE3u00PvVVfhObGRYehU3uzwCd8WCwEZjhIMlJbHtfEPqc4EK9+G3AzAPUEA==
X-Received: by 2002:a63:5f91:: with SMTP id t139mr3744283pgb.185.1576067437237;
        Wed, 11 Dec 2019 04:30:37 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 24sm3097132pfn.101.2019.12.11.04.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 04:30:36 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v4 1/6] bpf: move trampoline JIT image allocation to a function
Date:   Wed, 11 Dec 2019 13:30:12 +0100
Message-Id: <20191211123017.13212-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123017.13212-1-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
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

