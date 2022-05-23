Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9244531640
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiEWTtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiEWTtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:49:25 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA03A1B1;
        Mon, 23 May 2022 12:49:20 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id m13so7351316qtx.0;
        Mon, 23 May 2022 12:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=AaOXGurfoGcgghsoe7AEt+lCGKe8LojafE+rl0fnGow=;
        b=n1iXq4cNPsoM5/PqAjuGh9LzTutdZOI/IfKWfoi1OoZa2kcaxRwrb0BGLZM07CTs9O
         wf5jBWjaDEd5B5Dqw4mkc1djHHmoVx1qJjt46sizZKPwUOxIZAfffZzV77zObzhj/eLs
         WPyw1UgmZtdGY8o4g0l+DMmmJCLJwxJ3dszWNo5Nftfn4ocxA1tLuURRBj8H7GItgwUo
         L4PG0AA6NOCqP1QHU0uX3e6e0dc+tzexn4/sIr6GljRgy5osuWFW6opqze5Snuh783ug
         pTiLdExe9wnVNafPgXICJhkDFDNeF/cztSuy7AtwHyqVzWFMSKX3it3AJ9GpYnQ7DjLF
         pgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=AaOXGurfoGcgghsoe7AEt+lCGKe8LojafE+rl0fnGow=;
        b=nRMLoySYcilHZZv9zyKg3LF2YkjUtqF1ch9UcX7m/wCHSLArPHxAWU9iVhAWQuU7Qn
         D2pkoZXX2sAnCADCJPjLqMP65zqgmg8vctzBCd6VrwiGvyco2DRJmmlckswjPWpZzh5F
         mwSXrH7c1Otk10M2c/IBp9nSKa0+SugDDeZrV5AeFnAGLVikX7yDPb+3cIDrx6FjrFbl
         O/nHKE/pjBuqA6Kd9fHrGe78VyxsnZ91LJTVU3k61gs5z+Z2Hl8wmH7kGr2/SaJ0aDKs
         McF6oGVelgHuOevf/dNXtt6W0JDinbnG9/7LLvgc5jMg6y1iQ3AXwXLsjQ9f8NQ6cacl
         VLgw==
X-Gm-Message-State: AOAM532PewxoXiSM1cMtKiWu2IzID80qk8LYuaL7lwhWFJ988f3p3APU
        8gSOCK9jJUJ6JhgoD+oaU3A=
X-Google-Smtp-Source: ABdhPJzF0D2t+8LLtKszTPl+X0/Roh1qaUpSA9SCq85gzGexA6O3p7sKRcNlySogmuRnUqYsZlGwTA==
X-Received: by 2002:a05:622a:14d1:b0:2f3:b8e0:ae46 with SMTP id u17-20020a05622a14d100b002f3b8e0ae46mr17760448qtx.250.1653335360015;
        Mon, 23 May 2022 12:49:20 -0700 (PDT)
Received: from jup ([2607:fea8:e2e4:d600::6ece])
        by smtp.gmail.com with ESMTPSA id cb15-20020a05622a1f8f00b002f90a33c78csm4760512qtb.67.2022.05.23.12.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 12:49:19 -0700 (PDT)
Date:   Mon, 23 May 2022 15:49:17 -0400
From:   Michael Mullin <masmullin@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Check for NULL ptr of btf in codegen_asserts
Message-ID: <20220523194917.igkgorco42537arb@jup>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_object__btf() can return a NULL value.  If bpf_object__btf returns
null, do not progress through codegen_asserts(). This avoids a null ptr
dereference at the call btf__type_cnt() in the function find_type_for_map()

Signed-off-by: Michael Mullin <masmullin@gmail.com>
---
 tools/bpf/bpftool/gen.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 4c9477ff748d..f158dc1c2149 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -474,6 +474,9 @@ static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
 	const struct btf_type *sec;
 	char map_ident[256], var_ident[256];
 
+	if (!btf)
+		return;
+
 	codegen("\
 		\n\
 		__attribute__((unused)) static void			    \n\
-- 
2.36.1

