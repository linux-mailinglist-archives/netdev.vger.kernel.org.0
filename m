Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAE24E1AB7
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 08:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242585AbiCTHy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 03:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241285AbiCTHyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 03:54:53 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BA538795;
        Sun, 20 Mar 2022 00:53:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p8so13018611pfh.8;
        Sun, 20 Mar 2022 00:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YdfDvLiYSkwoveTevrFyxDKIAlT96ozvId3O7lsxmG0=;
        b=fnIJAOczZfkcMTWxm71ikrU6gEZlqXkgoBp02rK9vmFvGqokGO6q7F4OOi9OF1tIOB
         YVXJj0ICg/MJxS365Px2eOqE0pGKiu8LWvFL+JZeozosE8v5+rc8u8/edZPB/yq+T5zc
         00/E4kRq8N5RKxHfNuI5IVxviXDdK8durx0YX21qoNOELe5fgwOUxZyBvXZm+5l6hRk3
         9WwuwwXWXVaqSawbzyHKfiUpClVopJNdmABS9eabkLvZCH2SYizwGtNb/AnNGT+jkeui
         Z2zP47M3DXSYgzIbsLktAR92RkrFDuaje4FvV5j3pRU0TQ8T1WDOYvqAwHkGpWfIxLqx
         nLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YdfDvLiYSkwoveTevrFyxDKIAlT96ozvId3O7lsxmG0=;
        b=UcAmuHFKefDFnyBG/kZHpyp+NUfS86BXUkzAzRtHkKosdaRcoQstjY9DT64cudqgXx
         SXMep9UqspRROxonRLuCUjbp2t4EM0ND7t2/XZBFoD+a7S1cob82mrH/RDuo4NMY6X78
         T/1b2xAKXxFrzcTVG7YXP8ZuzyMo+4WXKguctukTUik1C84onv+CSyPqWJV4yQctmdSs
         dXgCiT0b8UwFHJFI5rgYXt/KwUV+sTyP0dnimD5DR2PSyb317Ofv7G7Cu5FYXFNhn5Up
         5GZY82CWF9EtbLWNjkWyf4DFmJa8AnohUO/TKlkgCEbYB1u8timEmMlEfZir/ubRvHwY
         wy3Q==
X-Gm-Message-State: AOAM533YmDC+sW5OYsyv5IYzsN7rra1L4kFAf3BMEeE/4/bQzrWqQPlq
        2OyCe2OXH3PkMVjqsMWDY8Y=
X-Google-Smtp-Source: ABdhPJxiDmjx7mx8m64J0PZxBOiWCifW7YmdHFPCmKLgxX7B4hFnkhIuncFr2s0uHcqIOMhdMIY3GQ==
X-Received: by 2002:aa7:8c45:0:b0:4f6:bf82:7aba with SMTP id e5-20020aa78c45000000b004f6bf827abamr18350033pfd.20.1647762809470;
        Sun, 20 Mar 2022 00:53:29 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm15162247pfv.199.2022.03.20.00.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 00:53:28 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Simplify check in btf_parse_hdr()
Date:   Sun, 20 Mar 2022 15:52:40 +0800
Message-Id: <20220320075240.1001728-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Replace offsetof(hdr_len) + sizeof(hdr_len) with offsetofend(hdr_len) to
simplify the check for correctness of btf_data_size in btf_parse_hdr()

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/btf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6d9e711cb5d4..97fd853db16b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4480,8 +4480,7 @@ static int btf_parse_hdr(struct btf_verifier_env *env)
 	btf = env->btf;
 	btf_data_size = btf->data_size;
 
-	if (btf_data_size <
-	    offsetof(struct btf_header, hdr_len) + sizeof(hdr->hdr_len)) {
+	if (btf_data_size < offsetofend(struct btf_header, hdr_len)) {
 		btf_verifier_log(env, "hdr_len not found");
 		return -EINVAL;
 	}
-- 
2.35.1

