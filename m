Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757074BC95B
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242613AbiBSQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242608AbiBSQkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:05 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5824C1BBF61;
        Sat, 19 Feb 2022 08:39:46 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i21so4921107pfd.13;
        Sat, 19 Feb 2022 08:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U58d365gzPg+r2bYkmkDtyaFXBJMwii/YyeHeGff4Eo=;
        b=YvWbUDISvPYVGn1LkhxmqlQvW8PUBW6uoxnXk5gZ5tTtCoaLFX2D8lhi1Vu6d1+T4z
         jrApZeb5KZgWnzrbgPtvLgkCI3Yc6SfjCnF1d/iKYvXI1IBaAqrLCfPrJ3KtPUHMquu+
         vN1/NlMVbr1URKUrzhoTBRXvvi/N93U5ELzSvPDdeDNgPB21IlRDwkpp1T8//jRyUNuM
         hNBgls/01YsDnki9KSqx4bnZuDnFvsvswDAlFttExmy8e8+OOj5rKeYf5LbkukC2TjWP
         /DFEok8UV+M8lUuv7sy/+xPT8i6jN45RJuQ9rg7YXcX03POXcFIVuHfwZkM33bd6AHN+
         oW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U58d365gzPg+r2bYkmkDtyaFXBJMwii/YyeHeGff4Eo=;
        b=5FQpvolY15D6T2HIoL2WowITk4+idyTTSSL6X31HrRmFBJYy63uVA9z69iDs42ukds
         xJGfriIcF6UxcMd9SpqZHnuG41XAS3SXwbWs1BN8QvnQ6UfoO1ZPQjnXERjxjPgE3Vxt
         ngw5UH0PMzhayrNe5AoeQJHZfj+qvPeuGnMgHCQ9TEnCvPPIiCcyuGanOAN5ldUnWen3
         Ckj+0MjHPxn80N7hvm8+nW287Hqy6spKT5FkyYvbPVlbObhDQQRQLjDZE4hmA5O3Ecod
         JJPrHF9tp/sr1wt7U/SQ4mF3912x2mg+g7xmitaAFHJ6vcg8DG2gH/ESSBQh/HNXuJto
         le3Q==
X-Gm-Message-State: AOAM530KPW3Fuhe1h8GGIwqwhnKgu+Pt8sCOEdGwomJjUs/cwj5mgG9a
        JRxC/qX31iYFrgSK6Wy6c18=
X-Google-Smtp-Source: ABdhPJybP2T/Zb/FF6wF8GZtpZHb4kUaoqzLTpY63uuXPaF+a+AkVsIaRdGbrtqL5uPHbkwvxWw7Kg==
X-Received: by 2002:a63:5f42:0:b0:373:d440:496e with SMTP id t63-20020a635f42000000b00373d440496emr6867491pgb.529.1645288785813;
        Sat, 19 Feb 2022 08:39:45 -0800 (PST)
Received: from localhost.localdomain ([2405:201:9005:88cd:46e0:823b:7e8c:4cf1])
        by smtp.gmail.com with ESMTPSA id w198sm7207238pff.96.2022.02.19.08.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 08:39:44 -0800 (PST)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, memxor@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] bpf: Initialize ret to 0 inside btf_populate_kfunc_set()
Date:   Sat, 19 Feb 2022 22:09:15 +0530
Message-Id: <20220219163915.125770-1-jrdr.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>

Kernel test robot reported below error ->

kernel/bpf/btf.c:6718 btf_populate_kfunc_set()
error: uninitialized symbol 'ret'.

Initialize ret to 0.

Fixes: 	dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 02d7014417a0..2c4c5dbe2abe 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6706,7 +6706,7 @@ static int btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 				  const struct btf_kfunc_id_set *kset)
 {
 	bool vmlinux_set = !btf_is_module(btf);
-	int type, ret;
+	int type, ret = 0;
 
 	for (type = 0; type < ARRAY_SIZE(kset->sets); type++) {
 		if (!kset->sets[type])
-- 
2.25.1

