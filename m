Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56A42F1FC2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403977AbhAKTsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403842AbhAKTsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:48:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E55FC06179F
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 11:47:41 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g17so20967ybh.5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 11:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=xUocMv2mOdcyH4QCmuhEcB0lNnr4xgx5lFffo1oDelo=;
        b=YuBxC3Nu4KiswAN+JQXNyZ0Jfe3BBNgPWZUtSfrzr6g15hR/8Gw+3RsgZtJ5Lp54aK
         XZFiEP7/Noi6TpQG/msX03XdlGMFjn7o9kcxBKUf3exYti5BzGfmk3GokvnzQEaHD8mZ
         fCbN47xQDVBE+4x5ts+YTWhcahU/6s1c3/yU7zx9hQRR/zKxCs6HO5SGNcoDYLTjuNqC
         Ggiud363URFTo7jnRTp56J2/H717MtYd0PZtYX2xG5oqpll4zhfZdiDiD1H2vk12xarN
         5AZv+W1RvjFFOrcTX4GRq9gaFVKr7o2bTJSrpVH487ugkTN9mbtbCh9Ul3vk3biNN9qN
         gIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=xUocMv2mOdcyH4QCmuhEcB0lNnr4xgx5lFffo1oDelo=;
        b=oDgO/jUOtO/mrLXdO7hD6asET+rDd0hz8FHVaLn6ZmHMFhasUSmodcn7IhMbaDwaSW
         wKP2QhY+1LfDOKb7XLLgeYFeYXlJgmOkVE4zIM1yXjf6Dh5dd5j3pOodnvjUjSmuWpym
         uAR0su4rDK0dHjcn0oweQ+falvO+uE1ykeS8X1tOV9ds4eUKBWNOPygdzT+iYDGVM/lu
         YLI7XgEaA7qMpZslrXpFU/Rw8OVjmvb/Ush3U+Z9mbyLk2CYVeVqW2fp/9mNT7OqnoXD
         aT26+FROvz6wy9n1BAadhgeYq0ydV5z/+1bi8+kJPBDNxxgrS2y8gvJARM9xA3IccdLj
         azlA==
X-Gm-Message-State: AOAM532Iorb8meWkstlzRk4Sa/+7aE0gzmcweQNYAErtuIZhrnRgg3cn
        qF1MGm2vqQjeVyCR1CaDwj2RGTz0eeNRbe5KDA/6jpBQSTk3cCz/ZNMQPdDDdKvD/eM0PyzhJvs
        chPiDoVDHWWXf5VeJ9hdh0GXJH0suIRtUp/uQM/qU3g5PCagqvhXJCQ==
X-Google-Smtp-Source: ABdhPJxmTCmudGn+ZRVOZ76XkhLi3pgE7rvtDuzIW4Mm3GtN9Eo89TiuA37fB/7xKyzwJUjz/oTP3Ac=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:1104:: with SMTP id 4mr1988439ybr.476.1610394460296;
 Mon, 11 Jan 2021 11:47:40 -0800 (PST)
Date:   Mon, 11 Jan 2021 11:47:38 -0800
Message-Id: <20210111194738.132139-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf] bpf: don't leak memory in bpf getsockopt when optlen == 0
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

optlen == 0 indicates that the kernel should ignore BPF buffer
and use the original one from the user. We, however, forget
to free the temporary buffer that we've allocated for BPF.

Reported-by: Martin KaFai Lau <kafai@fb.com>
Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6ec088a96302..09179ab72c03 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1395,7 +1395,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	}
 
 out:
-	if (ret)
+	if (*kernel_optval == NULL)
 		sockopt_free_buf(&ctx);
 	return ret;
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

