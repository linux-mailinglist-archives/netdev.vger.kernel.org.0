Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443EE51E879
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 18:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386181AbiEGQUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 12:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386141AbiEGQUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 12:20:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CFBC22B09
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 09:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651940207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CUuc+lgOyGwvC+Mjteke+5WNN677eQkpHYS3l7z3q2M=;
        b=ZqI/hsuxZ/V+jWULtrpgm8sNp3e/0Hkn75p4J4GGXInGlPlxhCDEabmYS64Zd0sT+dPlUX
        4pBoWkIyix7w0zQiwwteC764tn0AFzbagown/rSI2p8gz7JdRItDr7CC+4+DbKaV6H4eNJ
        1hPk8c67jBqhuasrJLYrhr8guV/fwrg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-GiYN5q7rMb6f8rRsHdpnfw-1; Sat, 07 May 2022 12:16:41 -0400
X-MC-Unique: GiYN5q7rMb6f8rRsHdpnfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96AD038041E5;
        Sat,  7 May 2022 16:16:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.81])
        by smtp.corp.redhat.com (Postfix) with SMTP id B36B240CFD0C;
        Sat,  7 May 2022 16:16:36 +0000 (UTC)
Received: by localhost.localdomain (sSMTP sendmail emulation); Sat, 07 May 2022 18:16:35 +0200
From:   "Jerome Marchand" <jmarchan@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Jerome Marchand <jmarchan@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] samples: bpf: Don't fail for a missing VMLINUX_BTF when VMLINUX_H is provided
Date:   Sat,  7 May 2022 18:16:35 +0200
Message-Id: <20220507161635.2219052-1-jmarchan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samples/bpf build currently always fails if it can't generate
vmlinux.h from vmlinux, even when vmlinux.h is directly provided by
VMLINUX_H variable, which makes VMLINUX_H pointless.
Only fails when neither method works.

Fixes: 384b6b3bbf0d ("samples: bpf: Add vmlinux.h generation support")
Reported-by: CKI Project <cki-project@redhat.com>
Reported-by: Veronika Kabatova <vkabatov@redhat.com>
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 samples/bpf/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 38638845db9d..72bb85c18804 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -368,16 +368,15 @@ VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
 
 $(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
 ifeq ($(VMLINUX_H),)
+ifeq ($(VMLINUX_BTF),)
+	$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)",\
+		build the kernel or set VMLINUX_BTF or VMLINUX_H variable)
+endif
 	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
 else
 	$(Q)cp "$(VMLINUX_H)" $@
 endif
 
-ifeq ($(VMLINUX_BTF),)
-	$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)",\
-		build the kernel or set VMLINUX_BTF variable)
-endif
-
 clean-files += vmlinux.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
-- 
2.35.1

