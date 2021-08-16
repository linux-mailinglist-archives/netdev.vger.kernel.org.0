Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E993EDB39
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhHPQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhHPQtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 12:49:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645CBC0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 09:48:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n20-20020a2540140000b0290593b8e64cd5so17279482yba.3
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 09:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2pXBI3DPkrMxBJGQ9ZomO9Sr2huQpV8lZhoQffbmZEI=;
        b=S0gCrI3LwcM/0wtammOB+CuVrR5xvW6a7GtQ56biFkYoI8RtTvdlFUr+XXCkW/ih9j
         Jdc1saP408Ci8EIc2Pz0ccaUed8zpAB+7zyt/dLv/6Ts9SC4rLJx8YZsiUWV9F7YVmXV
         26gKEGjZGvFEsZgPoO8p80s2w16Py9SVIE06btNaYA8IhGaTXM/YK1BaqaHgVd9NXeBy
         5NnDx4ufsOOhz/U8IOkUWivfe/e0x0heXQImKpuInh7tXAP1u4jU1Fja2EylX3pPyoyo
         bSmNJ/EhdjDZIZrwLeUTJs+B1ruxARKVd84SaCqtQIeZj0vz6Kr2TE2HCY+5hyy/BqlO
         rAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2pXBI3DPkrMxBJGQ9ZomO9Sr2huQpV8lZhoQffbmZEI=;
        b=jZGtPJr18E2nTDHUPHyNiNmxDu3hAb3+6aXawa3iajfkNUpfE9hOB08Eb4bcZ2G6k7
         TJJmbX7ss5IZYjS+1Zeg85wHDLpoULlloTbTypbbghpzFaVgvtFm3Nmcg/PC5WLulUFZ
         JZSnu7CVvlOAxbI8M3RApapzlEHKSVy7Kbs1mOqZ+C5wUco/XJl7dQ9DXX6Gy2d7kCaY
         fVNbzGoZiS2vKDjETEmUAflBbxijgXUTQg8BER93BKa4607JkRXdgJlZ8lm8W3oWcKkh
         7WmQeuSS7nz/8HCKGkpZHlAMds4HMuiWKJJp3vwsbdbSmPjTttnk2pRwlG5ucq3RwbEh
         CkEQ==
X-Gm-Message-State: AOAM532CKeWrM2yOI29DjEHuSmiy4WlCi1CRktKcByA5rdDAAkvdDPWv
        pK8SbPm1XiTfuxw+DlfqOq+Cuu6Er6TPpsWd75M46VOJHD+5QLMruCHPwfo4+pM9Zc3f05Gy0Pn
        L4nW45PeAKjVmjBTEG+ZnTJThQvEPlcHZMDeEVmmaZl2kEiviJ89e2g==
X-Google-Smtp-Source: ABdhPJwzqKItWq9/8Q1d9Xf7fXBvnolae4sKR05FiKXxnc6DwHldrh7iCVHr+KRGmpDQqo/EUQPLO6k=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:afa2:caa8:d56a:b355])
 (user=sdf job=sendgmr) by 2002:a25:b7d0:: with SMTP id u16mr15293668ybj.342.1629132514566;
 Mon, 16 Aug 2021 09:48:34 -0700 (PDT)
Date:   Mon, 16 Aug 2021 09:48:32 -0700
Message-Id: <20210816164832.1743675-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next] bpf: use kvmalloc in map_lookup_elem
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kvmalloc/kvfree for temporary value when looking up a map.
kmalloc might not be sufficient for percpu maps where the value is big.

Can be reproduced with netcnt test on qemu with "-smp 255".

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9a2068e39d23..ae0b1c1c8ece 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1076,7 +1076,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1091,7 +1091,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	err = 0;
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
-- 
2.33.0.rc1.237.g0d66db33f3-goog

