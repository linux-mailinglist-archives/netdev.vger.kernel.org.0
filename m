Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3754CB88E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 09:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiCCITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 03:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiCCITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 03:19:36 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F9D1712B4;
        Thu,  3 Mar 2022 00:18:51 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id z16so4149026pfh.3;
        Thu, 03 Mar 2022 00:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vU1b7wDDnqVNlq1Z3Hvkh5KsF871sfs1Pb9VrlvOM1A=;
        b=qpwp/6D+p9CYtGRLDE/pjwu0ektMH0lMywmc/153ea/IKQFvTa0ijFGROHSzpG0ur2
         0lxIRSCwR55CVXs3b4YkLKTlfXCLiaDoP9TEl0pHT65bK6dIkDIto8ztD28Fc6QR9e1G
         94yRK/QPDODBgmyvQuwUcgpAimqi7ihlZsrXkPZVOz1Hz7F7DtUQCdrZgsx+h27uzd0O
         ABRUNvI5dDHu7TcJ7Yx6tBpjMEVnXwl3RV80aHQEC6vbSJx6aIMqkTC3At0wd7wpcfFS
         5OD7VtKzLqmjB/f5+Rs2HOIRipvXTg32g8OUFJ2JisK5njm6Dtl0MboQUoYb5nS9LjDD
         08mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vU1b7wDDnqVNlq1Z3Hvkh5KsF871sfs1Pb9VrlvOM1A=;
        b=3CyAXQFS0evdBRiUOyskkUERs+ipi1DxehTA7f6SQos8WWOBPVUrC9qQZne6cs1lK6
         DqZdNMtz6FTFDzkFHHkc4qseECCW0gPSgZn5Gz2ZqY4BvOPSu53L/5UAyWbOoCeT/ZVh
         zu7URgPZN6z8DNGmDwlKnyWXXFS2KGxRXtf2gNDGOGjCwO8w+1XXXmk3wH1ubSOGFG9Y
         CdqpR0heBVzz2+p9oCpPrvAE18ablU580eAITUeEYZwI+boqXaeLy94VGu3qZ94C++3V
         VUIaNcjYK24ndSQxajoL06VemzCr/eFOBY+kgKfQOzXAuNV+5WbyvsmPQouZP/asvVO0
         Y5eg==
X-Gm-Message-State: AOAM533mCvA0HzFDGRfWvtP6N036N+QI+q1glAIuomM9wwsq4LZh0EN/
        mHlBuRWeCFYWGYnEZFutkInHuAVMxMnNCZOM
X-Google-Smtp-Source: ABdhPJyaZ7N5WWHDTy0tfYJJ9BH5pHdFZMLr4vk8eCMjqLRRsNjkUIBSBREIrqJRHdC14YEzXyDjIg==
X-Received: by 2002:a65:41c3:0:b0:363:5711:e234 with SMTP id b3-20020a6541c3000000b003635711e234mr29286766pgq.386.1646295530702;
        Thu, 03 Mar 2022 00:18:50 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id k20-20020a056a00135400b004ecc81067b8sm1733592pfu.144.2022.03.03.00.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 00:18:50 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Replace strncpy() with strscpy_pad()
Date:   Thu,  3 Mar 2022 16:18:00 +0800
Message-Id: <20220303081800.82653-1-ytcoode@gmail.com>
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

Using strncpy() on NUL-terminated strings is considered deprecated[1],
replace it with strscpy_pad().

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/helpers.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index ae64110a98b5..d03b28761a67 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -225,13 +225,7 @@ BPF_CALL_2(bpf_get_current_comm, char *, buf, u32, size)
 	if (unlikely(!task))
 		goto err_clear;
 
-	strncpy(buf, task->comm, size);
-
-	/* Verifier guarantees that size > 0. For task->comm exceeding
-	 * size, guarantee that buf is %NUL-terminated. Unconditionally
-	 * done here to save the size test.
-	 */
-	buf[size - 1] = 0;
+	strscpy_pad(buf, task->comm, size);
 	return 0;
 err_clear:
 	memset(buf, 0, size);
-- 
2.35.1

