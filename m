Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24F5107D39
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKWFwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:52:04 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45850 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWFwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:52:03 -0500
Received: by mail-pg1-f195.google.com with SMTP id k1so4444572pgg.12;
        Fri, 22 Nov 2019 21:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nsszb52WMbsoV1rPe8WzmUkafy3C0NqHfvYpYKepBX8=;
        b=VPVdl50ff+Nya54GhFlwSi/iHRfRTVtUQ4cykvMEbS8ArZ7CBSGJ3yFkRIA1Hp2tam
         TeKZy54MWzjSczWf2XCCpqk1TkgZo5obqLJdBPJqwC6WLN40pfL4Y3kBiddkR7kDOacp
         i8UPKT/MVrh80VW0Dw5CKK6C7blEuVg0b8STizr7ak9/QisiaeNNmqLB5VUFbOGV1HYf
         K386o8lCLLqTQrKPSBjNg9x4DmZpAdkO1AuI0ttNgGsrqO1Cw8HJxHenaqTZLnFvXgpE
         P63lTskuIvMnlz4Eu0//mpJUkCyPhWKL2/e/dVJw7MruvsP1hYalY6tA6iUKjXbbRGZt
         xb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nsszb52WMbsoV1rPe8WzmUkafy3C0NqHfvYpYKepBX8=;
        b=Y5B0scOEWecV5+Zvg0xgr/3IFUzHBU7GbWkRLrezS+8CPr3kyzGjGON4hVbKL1VcX3
         Qs7GpHtE6CR7RpbkCoaxHy1jcYHcj4p+WVL0j7xjZBLtGnvhfo2el4MT6VTnWr1WfZTQ
         Z8b2Iah0pm6wCskTil8JFEwWyIJFbMwBvp33fgB70P9LvNflu9UpTbWP6RUoQ50o+kFc
         qbFF3zO87bINZsrP9+AmVD2ZBC8pwd1zTkPSCF/eGKW6imSrcYt5R0W4VTWPxpQsPT7o
         wpMo7wJxtLOazoXM1/xGfsil44QNK7ghqTkVg3VtqA660jocE6t320v3vbZuu0A6M6Cl
         tVUQ==
X-Gm-Message-State: APjAAAXCyEdl9gfGIeKAgAX12FAj6PIlRFxbP1G3uC37B8schu2IhS5w
        qhd0uGMwULx4ACi0401gmw==
X-Google-Smtp-Source: APXvYqxcx/qzT+fiLxp7SGnPDbuBWrls/EXf8Zl1kzm2ZbTXvIRR1XKozI6d2+l0duw+C/C5H7MxaQ==
X-Received: by 2002:a62:606:: with SMTP id 6mr21875056pfg.76.1574488323018;
        Fri, 22 Nov 2019 21:52:03 -0800 (PST)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id s22sm738350pjr.5.2019.11.22.21.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 21:52:02 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next 2/2] samples: bpf: fix syscall_tp due to unused syscall
Date:   Sat, 23 Nov 2019 14:51:51 +0900
Message-Id: <20191123055151.9990-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191123055151.9990-1-danieltimlee@gmail.com>
References: <20191123055151.9990-1-danieltimlee@gmail.com>
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

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/syscall_tp_kern.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 1d78819ffef1..4ea91b1d3e03 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -51,9 +51,23 @@ int trace_enter_open(struct syscalls_enter_open_args *ctx)
 	return 0;
 }
 
+SEC("tracepoint/syscalls/sys_enter_openat")
+int trace_enter_open_at(struct syscalls_enter_open_args *ctx)
+{
+	count((void *)&enter_open_map);
+	return 0;
+}
+
 SEC("tracepoint/syscalls/sys_exit_open")
 int trace_enter_exit(struct syscalls_exit_open_args *ctx)
 {
 	count((void *)&exit_open_map);
 	return 0;
 }
+
+SEC("tracepoint/syscalls/sys_exit_openat")
+int trace_enter_exit_at(struct syscalls_exit_open_args *ctx)
+{
+	count((void *)&exit_open_map);
+	return 0;
+}
-- 
2.24.0

