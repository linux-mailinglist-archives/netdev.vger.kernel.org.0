Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0134DE997
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243679AbiCSRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243429AbiCSRcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E104552B;
        Sat, 19 Mar 2022 10:30:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so7230301pjm.0;
        Sat, 19 Mar 2022 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tlUVvnpalHf+NQDEGRuVRqs1mWkMR7ChiLJEV3o+2Gs=;
        b=b+0WOzv5QB5+n/S20HOa2mzV0FPpHcvm5Mx9dRPMPi7QXc74QJdQSxv7OA8ZqCgIiK
         iBpzwwFyifkOo5bTzlngp0xZ3JGhEx9QkudeAMe0+40BuN5YHkTzX2v3ZX9a0EfZl2aW
         8Tqci4BTDrs36dy2i6vFKfuL8bfCcDESXEQA6ypm5CkAgDotEzGaU0ENq0rrVBTIypOU
         R0FagYGZDwo0mw7n/YF6JJ7hUhpLf406llT0/cbYv2YXgZA4uwFG2lLa60lFtirQn7Ja
         hLmQascreXw/6d3tZzPiP5rSkjByzIFCDTYKYiC3NWfGxzlTOzmOTGistXW2i1CCmARZ
         vh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tlUVvnpalHf+NQDEGRuVRqs1mWkMR7ChiLJEV3o+2Gs=;
        b=rd5vu5cuR5CdYHbb3wSTNOhmwP+lZH1KHFtQNxcxgNH79SRyzp+5TgaZ14ekkcEWqs
         A+VVUQ4W72AZeC85AIh5KSkPUlMkNPrFmDQsSup6NH0cHN6mVeeaGQzUXQTm11WTE1Sg
         5CUsqg4M58S2kwkmDblnaMbnybAieqN0n231sPSZCqhPFCSTW2W1RPVJxp2f4sZfeSp7
         hVt3mJSsfCDdgbuX2xgwXHrIWnRxyt0IENuOZX0oq0VcjugD7iD1FnBsD9IBQSo/gS4L
         24BYxK/5MTIE5Ahwc2R0sq+1trkWCw6+rN54x8JPcea2rsWCVuZNK1qF8Bx7xNG9Hqf3
         QfxQ==
X-Gm-Message-State: AOAM530Hb0rNG1U2wISbhQUqNm6p941PguE0oRQ12wi5yykCS2Amg3Lo
        RCocWVX3Dylprh5KAB212ZY=
X-Google-Smtp-Source: ABdhPJwJRkOwuhK3vq0vx0S4/e1H1jq1fI2TUfzFUYVOzgYTg/Db5VgKFU+zPydyVvPXiNi64ge4+Q==
X-Received: by 2002:a17:902:be18:b0:153:2444:9c1a with SMTP id r24-20020a170902be1800b0015324449c1amr5212078pls.152.1647711047452;
        Sat, 19 Mar 2022 10:30:47 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:47 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 06/14] bpf: Allow no charge for allocation not at map creation time
Date:   Sat, 19 Mar 2022 17:30:28 +0000
Message-Id: <20220319173036.23352-7-laoar.shao@gmail.com>
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

Below three functions are used for memory allocation which is not at
map creation time,
  - bpf_map_kmalloc_node()
  - bpf_map_kzalloc()
  - bpf_map_alloc_percpu()

For this kind of path, we can get the no charge flag from bpf_map
struct we set before.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index add3b4045b4d..e84aeefa05f4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -434,7 +434,8 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 	void *ptr;
 
 	old_memcg = set_active_memcg(map->memcg);
-	ptr = kmalloc_node(size, flags | __GFP_ACCOUNT, node);
+	ptr = kmalloc_node(size, bpf_flags_no_charge(flags, map->no_charge),
+			node);
 	set_active_memcg(old_memcg);
 
 	return ptr;
@@ -446,7 +447,7 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	void *ptr;
 
 	old_memcg = set_active_memcg(map->memcg);
-	ptr = kzalloc(size, flags | __GFP_ACCOUNT);
+	ptr = kzalloc(size, bpf_flags_no_charge(flags, map->no_charge));
 	set_active_memcg(old_memcg);
 
 	return ptr;
@@ -459,7 +460,8 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	void __percpu *ptr;
 
 	old_memcg = set_active_memcg(map->memcg);
-	ptr = __alloc_percpu_gfp(size, align, flags | __GFP_ACCOUNT);
+	ptr = __alloc_percpu_gfp(size, align,
+			bpf_flags_no_charge(flags, map->no_charge));
 	set_active_memcg(old_memcg);
 
 	return ptr;
-- 
2.17.1

