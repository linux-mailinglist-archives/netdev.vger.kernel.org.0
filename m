Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0056011E979
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfLMRva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:51:30 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39188 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfLMRva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:51:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so173091pga.6;
        Fri, 13 Dec 2019 09:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLNlGhqLYHCsO91lGPZ7ui8kT0agkrSOimXTiG5x1G8=;
        b=leCPf89VRxc6g9lMvgmMfn9w2IUTISGKAplBxPujeKWxLysWNIcJVvvEpCoj25mJJK
         8xkyDYZUM4qvirL60uHS0tdKrM7k70yp90P6DbwOuXJXdT1eUv0rdw07/gHvkACTjaEx
         C5EZQmd4L5FONT9LhhpKyMdDfWAoHr9zxuK0oBNHE1TV9ywX70w8/yU3aJPu9GrSZn67
         5EP8DgxpFgQPXixHXO2+n3JFgB8H+KGQIvcddLXOlm2/upDp/fjqyZryKDXUOEcLHlF8
         za0yEo0HSsc541n8wDJwtSqyvYD0WFBj4Q/+d94bIcGdB3A4CWJsWJT1EWIml3S7hG0D
         lctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLNlGhqLYHCsO91lGPZ7ui8kT0agkrSOimXTiG5x1G8=;
        b=Ye1YNHVCD+5QG2S8EtaUrUxpgQITVSGuwIJuJ/J0A0VYS4MX9CECPez6QxcrLlSRvU
         iuDJMZDw0EHFgtGJ2YEjqElFc/Zi2Jzz2I9E4SYkJwgDTjwW7Fp4GLrs492OcDpTotHG
         8Li5vxEMuVtZ/LEGX7MlYARVpYN8gyiKhF6bcDoulqybq+QK0mN2tY5wSlVo+bK2ohN2
         cskAKkyCsnSz9pgpg0lWbp4skOH9yG6c39kkAMdWT89ot2xIWuQLMtqfoq+uvW2uWHH2
         a5HjDANCpFTeRSuCvgxrVhWO/cnrnYirPP5q/+aQMQsgFBWWxj+dIKMbCDnnIpGW7iKL
         6PTg==
X-Gm-Message-State: APjAAAWnFH0iC+tgExVp2OQl1ZnYibJpyzreHS3+5YbwOYDn8l10DjJo
        HY4G3eJP5Spd/Jn9McYKsLej6LszOda+mg==
X-Google-Smtp-Source: APXvYqwbf5T0IO2vksIoCy0/IuGcP2JQZgQ1OV5fxGOQbwnHn9CMdnuaw3H1tSHQMSqXfbnWikPYRw==
X-Received: by 2002:a65:490e:: with SMTP id p14mr734956pgs.4.1576259489338;
        Fri, 13 Dec 2019 09:51:29 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id q12sm12166366pfh.158.2019.12.13.09.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:51:28 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v5 1/6] bpf: move trampoline JIT image allocation to a function
Date:   Fri, 13 Dec 2019 18:51:07 +0100
Message-Id: <20191213175112.30208-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213175112.30208-1-bjorn.topel@gmail.com>
References: <20191213175112.30208-1-bjorn.topel@gmail.com>
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

