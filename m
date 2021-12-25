Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D6547F2AA
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 09:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhLYIc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 03:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhLYIc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 03:32:56 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C6EC061759
        for <netdev@vger.kernel.org>; Sat, 25 Dec 2021 00:32:56 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c2so9415986pfc.1
        for <netdev@vger.kernel.org>; Sat, 25 Dec 2021 00:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6OvxUrQQkCom57wUVJl60P0MeViWixpOkxhe4s/JMMc=;
        b=RqringsfiLKfKcM47FFkD6KrLPItmi7FABgsNk/148heTtAR1r/ygCEQMT+/2uksHW
         4gdnT0zNnd71ljvF9FZ0ufnsFtJ3ivmBwMaJ/2Xg60m3U/b0n3zKkf3iScJQy3lX4GrL
         wdb1UkwHzAZh/fKs1n9SdhjnjRwCV4ztudLq6nXx2k4n13mddDnzjKrCVktZ6OGhb3FX
         mVrn2rP0ONBRN/imaEfE+gyjFxx3yH0BSm2PPFfnhvmyYMoHo3VlW1FWg40yXh6+nXtv
         IV+Im24G5A1FspoDPx/gcyopsZLL7t2RSJZeJjYMvInTKiQW3aJs5B84PbOkxETbjqkR
         6PbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OvxUrQQkCom57wUVJl60P0MeViWixpOkxhe4s/JMMc=;
        b=f19Gcgz1wnUdFM15C8YTTcjJX3XV69O+sQfLPH+R3LvtqNXw6erL04z9bs/O14yB+J
         ASiGqS4rf6RUuiRdGz/GQvVdhy8yZo5Bs+4Sxm4IlC+qe1YJDlxByKAw3sZnc9JgFANE
         N74M9NYMmKEKf6289t7gR5rzG8ffhMomi/I6tS1F7XB4TObd2YVDYt8SJE3g7qT+BEAo
         /u4eWhSB0dBjrTA+Npwu2f/XYFXRe29tFpLUgPQzAcyxg/vgGbOPJD8AAhxbrSlu+ywk
         9clPfcIeJuAPab9iTfW9/76qu2G8IGvp2yfN233YwZWe8EKPVgiorXoEcKSxGHiiDfMi
         GBzw==
X-Gm-Message-State: AOAM531C7Lx8M8E6jOKJ/wrxX4k8jkgcFF8u+OhLjaBThsDAVNPFiLuf
        ZNoj5m4S5q0TtW3StGKkbdP9ew==
X-Google-Smtp-Source: ABdhPJznlmyOBW5dwARFvPNmx4v4bpPjIaj+WRiRkAKwfVZTF2LDG1F5Wg2BL3O2dQ3s7Xucyt7aQg==
X-Received: by 2002:a63:6603:: with SMTP id a3mr8460664pgc.578.1640421176186;
        Sat, 25 Dec 2021 00:32:56 -0800 (PST)
Received: from localhost.localdomain ([122.14.229.79])
        by smtp.googlemail.com with ESMTPSA id cx5sm10181713pjb.22.2021.12.25.00.32.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Dec 2021 00:32:55 -0800 (PST)
From:   Qiang Wang <wangqiang.wq.frank@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouchengming@bytedance.com,
        songmuchun@bytedance.com, duanxiongchun@bytedance.com,
        shekairui@bytedance.com
Subject: [PATCH 2/2] libbpf: Support repeated legacy kprobes on same function
Date:   Sat, 25 Dec 2021 16:32:42 +0800
Message-Id: <20211225083242.38498-2-wangqiang.wq.frank@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211225083242.38498-1-wangqiang.wq.frank@bytedance.com>
References: <20211225083242.38498-1-wangqiang.wq.frank@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If repeated legacy kprobes on same function in one process,
libbpf will register using the same probe name and got -EBUSY
error. So append index to the probe name format to fix this
problem.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 tools/lib/bpf/libbpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b7d6c951fa09..0c41a45ffd54 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9634,7 +9634,9 @@ static int append_to_file(const char *file, const char *fmt, ...)
 static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
 					 const char *kfunc_name, size_t offset)
 {
-	snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx", getpid(), kfunc_name, offset);
+	static int index = 0;
+	snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx_%d", getpid(), kfunc_name, offset
+		 __sync_fetch_and_add(&index, 1));
 }
 
 static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
-- 
2.20.1

