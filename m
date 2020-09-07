Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A4425F525
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgIGI1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgIGI1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:27:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A324FC061573;
        Mon,  7 Sep 2020 01:27:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so7685214pgm.11;
        Mon, 07 Sep 2020 01:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iizqsN3gyWTlK31Q87BLKr9d4pjHp4FM1LZnK4SWMSo=;
        b=SmyamS2s92FHAdtX/EGAZ8GgOOWkHECJ3qdkw13KraR58l22FXpNbyVkxBFnmc3Qgo
         VzeQ1yC9Xkgr11igVkvjVs30OgzzrQWljUBtV275uHm6uPgueSPPxOHTUlg5Sny1+tLa
         LtpDMeQC+r1J+bPhXBosoNc07sgU2WR4yt8OT0sXaqLE2/vwf121lz0pRYBVSo5hpyXB
         aIfoO7B4cokGxVxu7WsMzZm6ZLqbkT8M69LVQwgVkksPuSr17P0jmb0KqdKt7pDOAI1L
         SuZ7BHBXkmubrrvPMwA1o76NfjenQH+qgGHnyf/upO0sTqagEC6NG1LZ+zq2K+EI+San
         hcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iizqsN3gyWTlK31Q87BLKr9d4pjHp4FM1LZnK4SWMSo=;
        b=LB29LyfC7kkoZjMX/S+wsohaZnlyb9JOTrWqtwzXCFWYhfgRGxSDystiZWSFbADM1T
         wvTkNhMMJUEgZKFtjOnXgEbee9K/sr/i4T5hOgzXlI9WCs7XzfkYfCOZzySTpJDaYc7E
         Y77r8MaD6etkPDKOoOt7Qd9h2T0aBnj1HPs7VHDLRcaT6lI5Tac+hNYnhYQHHkqjHWQG
         /MxYE8+ALknRYkpkLwcYYmdk4qXi2uOvkTGymp/K5uJEAruvXYA4O1hXxg944Zy9ixs2
         PUlK2wGnnELxFXu2VQfGYVdgVOg2hmUlLCg1W8IymIOsfXFfWVr9q81uDBaXJki/th0b
         v4Vg==
X-Gm-Message-State: AOAM531Vi/5D6exITPPsMlBj5tPXJ5PX1TNwuuSrFBH7mvDun3GrE7r6
        m6QlPhesXecF9gAq955qkjXl0fp9cItjsQ==
X-Google-Smtp-Source: ABdhPJxKRlXWHpSWZHiNoYj3xxD7oLPyK4y/F6hPUITgDLEnMn7fjEsV8M3PjfjsoU0pH3dQuLx8GA==
X-Received: by 2002:a63:1c4e:: with SMTP id c14mr15529545pgm.98.1599467266041;
        Mon, 07 Sep 2020 01:27:46 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i20sm11756311pgk.77.2020.09.07.01.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 01:27:45 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv11 bpf-next 1/5] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon,  7 Sep 2020 16:27:20 +0800
Message-Id: <20200907082724.1721685-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907082724.1721685-1-liuhangbin@gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v11: no update
v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
v9: merge the patch from [1] in to this series.
v1-v8: no this patch

[1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/

---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6d9f2c444f4..884392297874 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -292,6 +292,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
 };
 
 /* type of values returned from helper functions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b4e9c56b8b32..95444022f74c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3966,9 +3966,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		expected_type = SCALAR_VALUE;
 		if (type != expected_type)
 			goto err_type;
-	} else if (arg_type == ARG_CONST_MAP_PTR) {
+	} else if (arg_type == ARG_CONST_MAP_PTR ||
+		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
 		expected_type = CONST_PTR_TO_MAP;
-		if (type != expected_type)
+		if (register_is_null(reg) &&
+		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
+			/* fall through to next check */;
+		else if (type != expected_type)
 			goto err_type;
 	} else if (arg_type == ARG_PTR_TO_CTX ||
 		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
@@ -4085,9 +4089,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		return -EFAULT;
 	}
 
-	if (arg_type == ARG_CONST_MAP_PTR) {
-		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
-		meta->map_ptr = reg->map_ptr;
+	if (arg_type == ARG_CONST_MAP_PTR ||
+	    arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
+		meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;
 	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
 		/* bpf_map_xxx(..., map_ptr, ..., key) call:
 		 * check that [key, key + map->key_size) are within
-- 
2.25.4

