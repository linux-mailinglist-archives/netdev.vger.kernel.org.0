Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D554DE9A1
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243709AbiCSRc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbiCSRcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9D445789;
        Sat, 19 Mar 2022 10:30:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z3so9462505plg.8;
        Sat, 19 Mar 2022 10:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fbHuw2wN1RGMdDQanAXcScwfI02r7zqf8nuc7Y7i6So=;
        b=EftifGYUFgc8p+r1eKYESSfOtKu9MWFg12bUtv26Rl9uF8geVk4/r0RujVw831C6Lr
         T67W6T2AueI9nWi7cQR7+n+uc21vhyz/KzxW3obbga4ubV8ZHtNCvwkJGAKLOPgGPSIk
         721tpCeodYzGhqsZqTUNTRUprE5xNnkes80HIOv2xps7OOSbI4Lp98xb3bUz+SxWyy92
         XNIySUhtFQKYVe9ZqsF9YqZ/ri7ZiNx8cT+U6sIVIkPOO1xM20Jh5k9ZoQMAg7+S7/uQ
         WqQnWm1PEr6vu2BoH16fWCxx2Vvfw4H+Bd4T5qAkZRbbgyAi95RPz7rgZokXSTrDnvfG
         V2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fbHuw2wN1RGMdDQanAXcScwfI02r7zqf8nuc7Y7i6So=;
        b=FfMgD7Y2QRcpoAOOJPFsnrXCpG+kOCPqnTfYg3ywLd4w0doJkE20pVBm/7y8Z1+qv9
         khp1JskFdQolG8IDu/Mfv3RTf6BZWNhg4NZ8ED1uvjtGZQ4tHMS5XuZYYksn/734rFBs
         Wpch0Rf0yy1PtfnjqQfZJcxVU0lMS9QjXCXS1IKuTXERjEVYr4PW54ZTh8elAXuRNiS/
         6I7prBoOs8NgEYSVpbwt1Brp53Bj6rTfJWZE1tO9LYiJmlTAQjKv4TkJ1OCbYDjeLmYY
         h2XPH3+4cVF7ZMclhwbnx3SeYRbKjQ+66ppbqh6XTmbsiSI1T+AKtKqe4ve6k5axVneG
         RBzg==
X-Gm-Message-State: AOAM5317qW4LAEB1d+Atg9Nj1o/ylXm6T4D+UB6BKXtqmDHWr3EB4+e3
        PG+ODC85qUhddwaKj/RKk3V3cG2YornQN7z752Y=
X-Google-Smtp-Source: ABdhPJwJva28WJ7jWfa33Znt81ZHpX/1QIXtCHZnxe+533hjN5affi9hym5cjzvBQn/oJ+7rhn5haA==
X-Received: by 2002:a17:90a:1f4d:b0:1bb:a657:ace5 with SMTP id y13-20020a17090a1f4d00b001bba657ace5mr27796079pjy.39.1647711048648;
        Sat, 19 Mar 2022 10:30:48 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:48 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 07/14] bpf: Allow no charge in map specific allocation
Date:   Sat, 19 Mar 2022 17:30:29 +0000
Message-Id: <20220319173036.23352-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some maps have their own ->map_alloc, in which the no charge should also
be allowed.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/arraymap.c          | 2 +-
 kernel/bpf/bpf_local_storage.c | 5 +++--
 kernel/bpf/cpumap.c            | 2 +-
 kernel/bpf/devmap.c            | 2 +-
 kernel/bpf/hashtab.c           | 2 +-
 kernel/bpf/local_storage.c     | 2 +-
 kernel/bpf/lpm_trie.c          | 2 +-
 kernel/bpf/ringbuf.c           | 6 +++---
 8 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index e26aef906392..9df425ad769c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1062,7 +1062,7 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	struct bpf_array_aux *aux;
 	struct bpf_map *map;
 
-	aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
+	aux = kzalloc(sizeof(*aux), map_flags_no_charge(GFP_KERNEL, attr));
 	if (!aux)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index a92d3032fcde..b626546d384d 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -582,11 +582,12 @@ int bpf_local_storage_map_alloc_check(union bpf_attr *attr)
 
 struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 {
+	gfp_t gfp_flags = map_flags_no_charge(GFP_USER | __GFP_NOWARN, attr);
 	struct bpf_local_storage_map *smap;
 	unsigned int i;
 	u32 nbuckets;
 
-	smap = kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	smap = kzalloc(sizeof(*smap), gfp_flags);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
@@ -597,7 +598,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	smap->bucket_log = ilog2(nbuckets);
 
 	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+				 map_flags_no_charge(GFP_USER | __GFP_NOWARN, attr));
 	if (!smap->buckets) {
 		kfree(smap);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 5a5b40e986ff..fd3b3f05e76a 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -99,7 +99,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~CPU_MAP_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_ACCOUNT);
+	cmap = kzalloc(sizeof(*cmap), map_flags_no_charge(GFP_USER, attr));
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2857176c82bb..6aaa2e3ce795 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -160,7 +160,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = kzalloc(sizeof(*dtab), GFP_USER | __GFP_ACCOUNT);
+	dtab = kzalloc(sizeof(*dtab), map_flags_no_charge(GFP_USER, attr));
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2c84045ff8e1..74696d8196a5 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -474,7 +474,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
+	htab = kzalloc(sizeof(*htab), map_flags_no_charge(GFP_USER, attr));
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 865766c240d6..741ab7cf3626 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,7 +313,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-EINVAL);
 
 	map = kmalloc_node(sizeof(struct bpf_cgroup_storage_map),
-			   __GFP_ZERO | GFP_USER | __GFP_ACCOUNT, numa_node);
+			   map_flags_no_charge(__GFP_ZERO | GFP_USER, attr), numa_node);
 	if (!map)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index f42edf613624..9673f8e98c58 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -557,7 +557,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
 
-	trie = kzalloc(sizeof(*trie), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	trie = kzalloc(sizeof(*trie), map_flags_no_charge(GFP_USER | __GFP_NOWARN, attr));
 	if (!trie)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index a3b4d2a0a2c7..3db07cd0ab60 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -60,8 +60,8 @@ struct bpf_ringbuf_hdr {
 
 static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, union bpf_attr *attr)
 {
-	const gfp_t flags = GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
-			    __GFP_NOWARN | __GFP_ZERO;
+	const gfp_t flags = map_flags_no_charge(__GFP_RETRY_MAYFAIL |
+			__GFP_NOWARN | __GFP_ZERO, attr);
 	int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
 	int nr_data_pages = data_sz >> PAGE_SHIFT;
 	int nr_pages = nr_meta_pages + nr_data_pages;
@@ -164,7 +164,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = kzalloc(sizeof(*rb_map), GFP_USER | __GFP_ACCOUNT);
+	rb_map = kzalloc(sizeof(*rb_map), map_flags_no_charge(GFP_USER, attr));
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.17.1

