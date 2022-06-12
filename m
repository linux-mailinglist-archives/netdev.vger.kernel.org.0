Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37B6547A87
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 16:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiFLOmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 10:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiFLOml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 10:42:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD5ACE7;
        Sun, 12 Jun 2022 07:42:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j6so3599547pfe.13;
        Sun, 12 Jun 2022 07:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qh4jpXPUL/lnXpEsemWdF0NXNKzKzJDmJs+zlYRBbs0=;
        b=c5kmpyw3B+J0+0aS/DER/c1ZjN8lPNMpS0uTbDvtbaZwDvQ5UuEdxxs0GWdsn/uKA4
         Uj+jf+qRs1MLyYS0W8Q7Rd9/ZaEwnjBJ5SOwlqraVYEGGGK9CxR8Kwu/5BsBpxkrf6BR
         lXaBIlMZTt12lBzgulgxR+9BHjFogMgM7eIoR8iCk+QY8qhVb2qj2aMs9Ch16EBdRCXc
         7urLWMkAujFucwpWNcGYT49iT1hrR7AJJpVuNKeVUPUzBhIuLs6XBuotHIebbdhX8V3Y
         DB2pMS+jUPlo8OP5/NXf6gHDMquje4h8SgNiQWcVbX1cJRzSPN0cdIKdiN2c8lapSvd9
         YaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qh4jpXPUL/lnXpEsemWdF0NXNKzKzJDmJs+zlYRBbs0=;
        b=0ING3uGux2tkhTQsDGdPwkH0gAZhGiI1G5b4QgEHtDvyb+VxRCxk94VWSKrKUX9Get
         TpFdgX60VompJeb96pRt/a4qDWCQL7G98bTNfB/ehGsvxBPHg36cx3rZZOX8vuti5Jyo
         eYeo26GFBh1YBVWIEtmBHBOWeVlvFlGXkOC08+daz55Z1EbFaPzlM2S8xgFgDFJUd1ja
         +QJc0vcmhKKzLS92uKGCExDOH/1ONbOyqwmzojfw7OhC4rB5UP1sg2hMoDL0W3Ri+spl
         PsKKFNmtkJr44BlQwOzHLpF9bdTrePftknw0fKJ0ikEvGO9xLf/aOHCZVhe9r4OEnUCG
         w0Aw==
X-Gm-Message-State: AOAM5307QZJ8hI7g0/xQi2y5Fj41jlSNxDatDxGZSAsj8oLSKngmcIQN
        AzOI+bX8QPpfIB7ePYpOhms=
X-Google-Smtp-Source: ABdhPJwnxH3odbVtnElrJelk/AlHcF6LoZjMj+emFe31ip6yHExOQyh2+NBYUkMVBaRN9Xulx/R8tA==
X-Received: by 2002:a63:3ce:0:b0:3fc:6a52:8668 with SMTP id 197-20020a6303ce000000b003fc6a528668mr48255062pgd.424.1655044958699;
        Sun, 12 Jun 2022 07:42:38 -0700 (PDT)
Received: from ubuntu.localdomain ([103.230.148.189])
        by smtp.gmail.com with ESMTPSA id h30-20020aa79f5e000000b00519cfca8e30sm3317660pfr.209.2022.06.12.07.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 07:42:38 -0700 (PDT)
From:   Gautam Menghani <gautammenghani201@gmail.com>
To:     rostedt@goodmis.org, mingo@redhat.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com
Cc:     Gautam Menghani <gautammenghani201@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] kernel/trace: Remove unwanted initialization in __trace_uprobe_create()
Date:   Sun, 12 Jun 2022 07:42:32 -0700
Message-Id: <20220612144232.145209-1-gautammenghani201@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unwanted initialization of variable 'ret'. This fixes the clang
scan warning: Value stored to 'ret' is never read [deadcode.DeadStores]

Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
---
 kernel/trace/trace_uprobe.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9711589273cd..c3dc4f859a6b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -546,7 +546,6 @@ static int __trace_uprobe_create(int argc, const char **argv)
 	bool is_return = false;
 	int i, ret;
 
-	ret = 0;
 	ref_ctr_offset = 0;
 
 	switch (argv[0][0]) {
-- 
2.25.1

