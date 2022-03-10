Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6224D4E65
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbiCJQQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbiCJQQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:16:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E666191414;
        Thu, 10 Mar 2022 08:15:27 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b8so5680997pjb.4;
        Thu, 10 Mar 2022 08:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHE/lJ4kASfr+QyhkhgNeiVjho1iL2iEgjJEg5v2OyI=;
        b=OHU+MWh9CJrrUMTgEdsq+q9mzUT5ZwhQEPcVrvYe8mOY5ODJBAvbdS1iXE1NC7/64P
         scVe8SNc56UZPDzV0outy5Qi7JmDgpVrK4y6AgzbavscsscHfmgp+ENBNozju1+uybLD
         ZBAWl9+NDw6qqWiqQ9RaeYuQI/SDrqiGp4hL8oxknl9DRvOhorgc41r6MLFoiDK7DWod
         kGG+XVwsU5l0Jge8jPxmVtOMTzsCdfibMM2pG7U9hGiGBmUiitukwt1IRc58KM2iRMZ6
         TbncybExqU0foqLJZ/KgPITEPFq2UdWC0vTRcTbq86oWweAWMT9HvNQa2jDFOORicH00
         W5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHE/lJ4kASfr+QyhkhgNeiVjho1iL2iEgjJEg5v2OyI=;
        b=vULVJuDj0USf7mX/jGWNrjXlGJg6GONMO4O0ZGfY1IN7LuGQ2p0QDCN0NsW/OVu2zb
         2JUjWCdjNLFj5GkHal1HexDuoVncaq6Fp5Hy/UbimMlfMLKAaRBnnWmLNk07XgtcUD3X
         UH4/LqZRy7t61qmmnbNJEJ2UjcrCy0PpG8VBTq0Led88P2JWZ1Q0qwW+Yk+e1DeRvuV5
         UDmVn14HGReJkXHiuuYNuR6qn/Lp4lED52rCdX75HYMlkwwVGgMwmxShGlfwvnYjLJCX
         t0uTwzk/A1EtOitTlVo5OBgy8KjjaseYcHd7Su+mOkxVprZ+KpEKnV5CEMg9EcpVJD+H
         6T9g==
X-Gm-Message-State: AOAM531pCUPNLnVkFDPfxYR9kYZWFdRICFRuUMnU2cE+5emYadd84oj7
        pP2KDn9nEgaQ0KPwysnpBSCYV5jEUExRiw==
X-Google-Smtp-Source: ABdhPJxIAe+tGSFToczm4tOwhDXJ4MadjBomzWKOgRcNGVbPUFQRaYIAyIYw5RTVgy9y7nRSbxloXQ==
X-Received: by 2002:a17:902:b488:b0:14e:e9f3:24a2 with SMTP id y8-20020a170902b48800b0014ee9f324a2mr5798308plr.72.1646928926355;
        Thu, 10 Mar 2022 08:15:26 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id n18-20020a628f12000000b004f743724c75sm7180434pfd.53.2022.03.10.08.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:15:25 -0800 (PST)
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
Subject: [PATCH bpf-next] bpf: Use offsetofend() to simplify macro definition
Date:   Fri, 11 Mar 2022 00:15:18 +0800
Message-Id: <20220310161518.534544-1-ytcoode@gmail.com>
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

Use offsetofend() instead of offsetof() + sizeof() to simplify
MIN_BPF_LINEINFO_SIZE macro definition.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/verifier.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e34264200e09..0db6cd8dcb35 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10400,8 +10400,7 @@ static void adjust_btf_func(struct bpf_verifier_env *env)
 		aux->func_info[i].insn_off = env->subprog_info[i].start;
 }
 
-#define MIN_BPF_LINEINFO_SIZE	(offsetof(struct bpf_line_info, line_col) + \
-		sizeof(((struct bpf_line_info *)(0))->line_col))
+#define MIN_BPF_LINEINFO_SIZE	offsetofend(struct bpf_line_info, line_col)
 #define MAX_LINEINFO_REC_SIZE	MAX_FUNCINFO_REC_SIZE
 
 static int check_btf_line(struct bpf_verifier_env *env,
-- 
2.35.1

