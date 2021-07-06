Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5493BDDB5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 21:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhGFTEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 15:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhGFTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 15:04:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD17EC061574;
        Tue,  6 Jul 2021 12:02:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d12so22298841pgd.9;
        Tue, 06 Jul 2021 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FxIWX9o3nry3qUAuCyUJX/YGznw7N9DuDggJJIUGkU4=;
        b=HlRE+oldd0J9W+UGFBW0iMwJeVAgkEj17eUexgrpXHJlHBFsV9y9vYjnsbBeUaUtXU
         4VD3PXEy2AUw3Q/m7/JWqHOAnvdYBmtIvjZbcjq0T9cZp3PZnTbJFyzlD7o8ts0xajJb
         8Zb5S73Xvk8ysBZbw1H0eS6njsIiKQCpgtmkN/zq+ABg02QlDjKQbTKw98xSwga73J7N
         eNilFIda1NOpvPQ2OHBNS8ER1w2svB/ZP5zn795o4A0ss99P8VDR0MADNJV5ixF9bZEO
         vztue4WpKZc8Ru4l2LTKfMBQuAyhXJ+TWBETbjKrSOnWAp/vFBxz4NCK7cjUfqhyd3Xk
         CGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FxIWX9o3nry3qUAuCyUJX/YGznw7N9DuDggJJIUGkU4=;
        b=Mezi6CMQcexdO06LEq5zgJ9dG6Mgws4qml8S48TN+M7Q0H+BW+FwHqmdXDfAW+wezD
         H4YPhkigX8KuUAaYORdiheRbMDhhdeVEdTiDVGa28Z2uzZqOxGDe5VZtSnWW/k5qr6/r
         Iq5KC5HJ6aHnmNs1hvMEVPQpINLGMzU9wLt5xo2NtBIj8O+fiwxxacN8edA3GsbTxZl0
         EkVYqyBaFcNQmnJNlToyQlB/YKPJpc14ShDoANg2BJIijbrzSeVH+dj1qX9g7RmMjj4s
         DRwkeGk5yHPDA6rAOk+okmWfr0mdrabger8sx4HKXUE2zhh987V1KDy9v4zK5yAlpCjG
         26Pg==
X-Gm-Message-State: AOAM533OrVu8Qop9IoPS5yxwNq2FTQEBqbd95F0g9Aahn12bCEU7hZEw
        AMxJACv8siA0XEtCoHBAJrs=
X-Google-Smtp-Source: ABdhPJzVCESAZmAIXrITAFmGvc6rVhQ9jct/kWSEaTilLJt4I7g1ogFjDnRzEMd4KR8ghhgiYRN7VQ==
X-Received: by 2002:a65:6404:: with SMTP id a4mr22625782pgv.175.1625598133011;
        Tue, 06 Jul 2021 12:02:13 -0700 (PDT)
Received: from localhost.localdomain ([103.82.210.28])
        by smtp.googlemail.com with ESMTPSA id y5sm3549437pjy.2.2021.07.06.12.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 12:02:12 -0700 (PDT)
From:   SanjayKumar J <vjsanjay@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     SanjayKumar J <vjsanjay@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v3] tools/runqslower: use __state instead of state
Date:   Wed,  7 Jul 2021 00:29:26 +0530
Message-Id: <20210706185927.19272-1-vjsanjay@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2f064a59a11f: sched: Change task_struct::state
renamed task->state to task->__state in task_struct

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
---
 tools/bpf/runqslower/runqslower.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 645530ca7e98..ab9353f2fd46 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -74,7 +74,7 @@ int handle__sched_switch(u64 *ctx)
 	u32 pid;
 
 	/* ivcsw: treat like an enqueue event and store timestamp */
-	if (prev->state == TASK_RUNNING)
+	if (prev->__state == TASK_RUNNING)
 		trace_enqueue(prev);
 
 	pid = next->pid;
-- 
2.32.0

