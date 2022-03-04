Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCDD4CCE46
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiCDHHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiCDHHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:07:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1F718E430;
        Thu,  3 Mar 2022 23:06:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b8so6647606pjb.4;
        Thu, 03 Mar 2022 23:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q/M3caOnFE3N93SPkyxpAe4BQV2suFmBpM97xNgq+TA=;
        b=anS/vfnrEbn89xVNCCdRDdOukM3FAdc/3eOHFcE9uWJA+9Xx46X3WP0tLapUtRkGPd
         Hj0FMecC2bNJmBBnyKEJqIOuvkWrTVI8vwTS6oXYbo6c38lu70/HoAnkMHCPSW8k3rOh
         ekyJ6fFjyp61UiOGj1uhC5ZoYVdioNtO9AxJmFzumb1AY5ffwwLjcPWPbsV8s2wZJq4h
         7ZZ39NvWbSpJezJ95Xm6u7Nsh4kL8sEWvDwuU73cBWIET6ZJ1iYihl6SoP5bf146yDJG
         gtYKBwgDcbRy3qfT8QQhzxWbHuOpuB76lauxlTn7F2YXaeeWkHg1FAAWjenCOdF7bk89
         3a3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q/M3caOnFE3N93SPkyxpAe4BQV2suFmBpM97xNgq+TA=;
        b=jbKdqX+xh8BQVrnKSWgI64PQwZYC5l0A3mh095Sii9AhHvrfeRFAhCfcln3UPpNnyA
         Gc1FOnxniPFYwU5ZOFcUoANOaItY6M7v2r+0D3gMXxZlCSLW6DpFpgT3+aDwGX54852x
         3E1YJi2Au8sApALefw9VYOYNeQOp2uh1kMisgD/orG3+iKAEEhM6WiXkejWRb4oi4Ulf
         aqx0BDkKljHuDgLhLy+TqP2SPsKHBWKqJNuPMEeLj4DlhW0ssFsWn3MgPw9P9UlHJcsy
         JucdVDtJQzgImknTJiucHWJaVF0pvi7eK4RVKIKioOP5mbFXwoGgC+k6fqK6a1gZJ7r2
         k+aw==
X-Gm-Message-State: AOAM5338RmWVKUxrTOA3DLideliS0IcMp95pobaE+hO0Qym8d3xQVqjV
        jmqQtKE8noqpYq52dwLgxB8=
X-Google-Smtp-Source: ABdhPJxJWAPOFI6E9NdzxWEpdtku8KpJi10GWzq0ldm6Pw+2AH4SvRr9Of/Dd1ZzIZzxezLQ0njqLg==
X-Received: by 2002:a17:902:e5cf:b0:151:b24e:8d3b with SMTP id u15-20020a170902e5cf00b00151b24e8d3bmr4883162plf.29.1646377585360;
        Thu, 03 Mar 2022 23:06:25 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id c34-20020a630d22000000b0034cb89e4695sm3783586pgl.28.2022.03.03.23.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 23:06:24 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     yhs@fb.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, ytcoode@gmail.com
Subject: [PATCH bpf-next v2] bpf: Replace strncpy() with strscpy()
Date:   Fri,  4 Mar 2022 15:04:08 +0800
Message-Id: <20220304070408.233658-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <e1e060a0-898f-1969-abec-ca01c2eb2049@fb.com>
References: <e1e060a0-898f-1969-abec-ca01c2eb2049@fb.com>
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

Using strncpy() on NUL-terminated strings is considered deprecated[1].
Moreover, if the length of 'task->comm' is less than the destination buffer
size, strncpy() will NUL-pad the destination buffer, which is a needless
performance penalty.

Replacing strncpy() with strscpy() fixes all these issues.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1 -> v2: replace strncpy() with strscpy() instead of strscpy_pad()

 kernel/bpf/helpers.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index ae64110a98b5..315053ef6a75 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -225,13 +225,8 @@ BPF_CALL_2(bpf_get_current_comm, char *, buf, u32, size)
 	if (unlikely(!task))
 		goto err_clear;
 
-	strncpy(buf, task->comm, size);
-
-	/* Verifier guarantees that size > 0. For task->comm exceeding
-	 * size, guarantee that buf is %NUL-terminated. Unconditionally
-	 * done here to save the size test.
-	 */
-	buf[size - 1] = 0;
+	/* Verifier guarantees that size > 0 */
+	strscpy(buf, task->comm, size);
 	return 0;
 err_clear:
 	memset(buf, 0, size);
-- 
2.35.1

