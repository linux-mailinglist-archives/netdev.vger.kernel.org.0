Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01834E672B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351750AbiCXQoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343904AbiCXQoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:44:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC339F393;
        Thu, 24 Mar 2022 09:42:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id w21so4261723pgm.7;
        Thu, 24 Mar 2022 09:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IHzG2Bc1iEc3DkxvoIR2nYYwik8/uVlYKPuVvvDNKG0=;
        b=QNlvUnQ8opRbo/8qjMjhuNNly3CK6ylgBXed9nXw52TH5thCkE4vMCjuwCYADYW8By
         OzZL0VC3oJdPAnfwDuybO4uN/qYh6b8L0IGwkLUOa4YiJ+4nwce22Hzku4istL4fdgo1
         KH4Kx0zjoGP1F+FJjXwAs6iDk81NK/R9umkOp3PyTrgiCM/02fe2wb7NQca7zoZR5Uag
         y+aecWmvmC7k5acY6jH/REUoBjcnxJUc59wJW8xFs8jCaoACYuwTsjKa//0+kiwsueeW
         B1oYK8DXNuYOW5wIy9xlO8MR4/RS1Wbsp15JDFGFGq3S8D29oumO8PcjrTnMf+EygKet
         ceEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IHzG2Bc1iEc3DkxvoIR2nYYwik8/uVlYKPuVvvDNKG0=;
        b=FqxK1E9VseOEluyi+gZSERes/AhOWkCp6kVr3AFsTksBlnsMeRY/pkqqT2g9srhpaR
         SFxbP6mIhX+glBb5NRuu4HEvaPhrGSUw9rr6C2Dt8Xx8+DA6dcMZqPJn1Qsw0lJoWkm+
         iQWefM+3sk4YXdspOzwCElzhUdzgfOj2F9YqjC4APue5dVtBCpfaZIb2zw10wBbRjlP2
         f7IRWxVrjMMLF9ROPYa8lci/iQCQoQGstfUy+GswLfZLQA+56w9tSTAcJgynrwoz4J3z
         WV1bqMmK6hXe7J2qeObTqrGTWcBV5mcU2RDQUzwH0z4Tl1CnSoAFggGC8fkWnxEHoz+J
         jjzg==
X-Gm-Message-State: AOAM533PppQG2JAvBGfFWRb2hjeXTGwoibxrQNFjq3WqDmq/Ar5AhD9t
        Qhj9UoD0H1HHYgvtHsfnXkWAO1sHOMy8UQ==
X-Google-Smtp-Source: ABdhPJwjYjJbOpUAfEPi8cUxFAVZqrinaguZED2+9dMPmc9Ufmoe40VsI3WLGaWGQBxJI24Wn/yKGg==
X-Received: by 2002:a63:ba07:0:b0:382:4739:8941 with SMTP id k7-20020a63ba07000000b0038247398941mr4753971pgf.293.1648140166863;
        Thu, 24 Mar 2022 09:42:46 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id il3-20020a17090b164300b001c6d5ed3cacsm4024945pjb.1.2022.03.24.09.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 09:42:46 -0700 (PDT)
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
Subject: [PATCH bpf-next] bpf: Fix maximum permitted number of arguments check
Date:   Fri, 25 Mar 2022 00:42:38 +0800
Message-Id: <20220324164238.1274915-1-ytcoode@gmail.com>
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

Since the m->arg_size array can hold up to MAX_BPF_FUNC_ARGS argument
sizes, it's ok that nargs is equal to MAX_BPF_FUNC_ARGS.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 24788ce564a0..0918a39279f6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5507,7 +5507,7 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	}
 	args = (const struct btf_param *)(func + 1);
 	nargs = btf_type_vlen(func);
-	if (nargs >= MAX_BPF_FUNC_ARGS) {
+	if (nargs > MAX_BPF_FUNC_ARGS) {
 		bpf_log(log,
 			"The function %s has %d arguments. Too many.\n",
 			tname, nargs);
-- 
2.35.1

