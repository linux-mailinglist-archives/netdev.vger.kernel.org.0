Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED05113CB8
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 09:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfLEIB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 03:01:28 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:47010 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfLEIB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 03:01:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id y14so1207885pfm.13;
        Thu, 05 Dec 2019 00:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=36DAjWG2mm2tz8K1vYwbwLCud3iD4r0zeR17P7GkWE4=;
        b=cvM2xvVp4FcpPGysrIPQW8rZivr9Tl8u3AQ9vd8/G6KAzJrDWZccDwyD48Fo7/cO8B
         Qv1yOVgsTRI3iJ11VFVq+XNVeSHA2bF6owg735Z89TacuPGcpoWiX4LeWCnZ4ub+FQNN
         pPDWjZVa4V5h00gymNT1k7LJrlRsnF9JCkzMPzqXcLD/lXSbtag4xpSJfZErBTf0vkaB
         9ky8V6gSBVDg+9DVWdUb9tg5hq1kM2UCS74NGzlAzwdFvTQVun/rM5JXcZw4qQh1GgHM
         SMsr/SdAvv0Q1GVI7TtfXRljNYaq2mb4rgyWV1nw9apwPZxL/tuPInzybuFg2bd5ZIpt
         tFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=36DAjWG2mm2tz8K1vYwbwLCud3iD4r0zeR17P7GkWE4=;
        b=s2fohjC519WbAcS9tAbFAmBYjNQ8KPySUTKvgAUiVLpmk5vDpNcTzewYDijXV/xSz2
         HCC5KAXnzD9SbTnaTzPyznJzYZp4LmNutXfZ2fxIggKmQad0ZVGKP0nGf0kj7A+V/jso
         XuM7D4kT1BsbwjkWWNn55+7S2qdHrZLFMvScPA5gr7sqYy6jdrXvn6Uszzy1XJ63Lmzr
         VkKxfNcH/6BmbS78vLtzJ7WBqCGBd6/wWCXZhHToucr7iys3IlLkI2R6l1K7Fp7Jx4H0
         /A/uKPv9BhODbmh741zXCy+q8NFc4TFMxlbeLqUbbpQu8uEUOljcPhAji7X6MK1NBbR4
         4VNw==
X-Gm-Message-State: APjAAAU6T0O6cVctGKEOMiCLhAkD487NlzyntljPo7lFsfgnAcSrxZsz
        ojvVQKxj5fcWfRu4a+NFhg==
X-Google-Smtp-Source: APXvYqy8CN6ZQYwMK+lFuFUpsIWdFmdGbat4B8U5IBfF3Qwl3r1dgv20U0Exu23WAnba79uwsgkafg==
X-Received: by 2002:a62:5547:: with SMTP id j68mr7944989pfb.6.1575532885813;
        Thu, 05 Dec 2019 00:01:25 -0800 (PST)
Received: from localhost.localdomain ([114.71.48.24])
        by smtp.gmail.com with ESMTPSA id 129sm11510739pfw.71.2019.12.05.00.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 00:01:25 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next v2 2/2] samples: bpf: fix syscall_tp due to unused syscall
Date:   Thu,  5 Dec 2019 17:01:14 +0900
Message-Id: <20191205080114.19766-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191205080114.19766-1-danieltimlee@gmail.com>
References: <20191205080114.19766-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, open() is called from the user program and it calls the syscall
'sys_openat', not the 'sys_open'. This leads to an error of the program
of user side, due to the fact that the counter maps are zero since no
function such 'sys_open' is called.

This commit adds the kernel bpf program which are attached to the
tracepoint 'sys_enter_openat' and 'sys_enter_openat'.

Fixes: 1da236b6be963 ("bpf: add a test case for syscalls/sys_{enter|exit}_* tracepoints")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in v2:
 - Remove redundant casting
 
 samples/bpf/syscall_tp_kern.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 1d78819ffef1..630ce8c4d5a2 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -47,13 +47,27 @@ static __always_inline void count(void *map)
 SEC("tracepoint/syscalls/sys_enter_open")
 int trace_enter_open(struct syscalls_enter_open_args *ctx)
 {
-	count((void *)&enter_open_map);
+	count(&enter_open_map);
+	return 0;
+}
+
+SEC("tracepoint/syscalls/sys_enter_openat")
+int trace_enter_open_at(struct syscalls_enter_open_args *ctx)
+{
+	count(&enter_open_map);
 	return 0;
 }
 
 SEC("tracepoint/syscalls/sys_exit_open")
 int trace_enter_exit(struct syscalls_exit_open_args *ctx)
 {
-	count((void *)&exit_open_map);
+	count(&exit_open_map);
+	return 0;
+}
+
+SEC("tracepoint/syscalls/sys_exit_openat")
+int trace_enter_exit_at(struct syscalls_exit_open_args *ctx)
+{
+	count(&exit_open_map);
 	return 0;
 }
-- 
2.24.0

