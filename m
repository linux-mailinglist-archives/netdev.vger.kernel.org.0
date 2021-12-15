Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72928475796
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhLOLQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbhLOLQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:16:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521CBC06173F
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:16:19 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so11070534pgg.3
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1J5rh8c88OIRT0cbzlqagWTRc0k7QBWGbd0OGAGYHKQ=;
        b=ZRiIx3G1K5spEnSmaztOgrLBgOSqAYBIV6SNAJZT37P61/XxH96oEMNKKATV+UNP06
         Q1W+R6yOxGXce8GaRa/tLBrvpq2dnguaNSXZD9ArtX9ASjoDWWgW/z4BSfbu29dNNyWa
         eyLisk9FIgXJP6YgPMkTtDIzBY3WgRs3B2fe1bbDMM/dB95MiBOaR3mOgrkga3+nnOaX
         vFuaY3J/kZZ3aV6ZR9jGHW55qE2KBOC79MXoVqTOXtBZn3c4w/+4W4A+/wz9sW/LyWbC
         mpnmQaG0lgV7726LjsbgvdfNWnqrDZFac70S/oN7Le6+RP8k5M552kDyrPPKsX9Lzutt
         A+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1J5rh8c88OIRT0cbzlqagWTRc0k7QBWGbd0OGAGYHKQ=;
        b=EXRyh8Bw4r8XYl0jkLXLXV0jfTucSc2WO0lWC30FiM5nDVLRoyhBr6/hUlU+lnc0FM
         siAApIOwaYGuVWOQcVpgb3UXo60A1blXNSV32WBgVHT1cDA/uJOEJAMchjm9IZCrwwHH
         U0SXE70fUcc7BsQmEYwyTZKmNT/BxITRLWshznnPJFA/yUXAC8/OkJnQo6tjra7Ge5+4
         VQJgkAv91Y9Zhwn38VOpjwLYnvbUUUigT1Lerg4KD4lrZwj9tfTBtQQHgiCuzNRp9gjz
         VF/yPtGN/zWQhSbLOE9fgbuJCtuvEtpNDRBhQu3rGb1y1nGYO+qWHMLlOg7qlKyS7RxY
         zc/w==
X-Gm-Message-State: AOAM532y9oPlyfT6iUUdUWIKy+hJddhskITbpHNPomqJDYgTkpUEm0ky
        BevPwxWvhq+jbS4xblUefNI=
X-Google-Smtp-Source: ABdhPJyc5D+19GIGvcIvjihecYJUsuIx04Moljqr171eleFa0vxNImbOBsqZOGH6BQBVQlwm9rJWaw==
X-Received: by 2002:a63:74b:: with SMTP id 72mr7584104pgh.231.1639566978876;
        Wed, 15 Dec 2021 03:16:18 -0800 (PST)
Received: from ELIJAHBAI-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id oa2sm5266812pjb.53.2021.12.15.03.16.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Dec 2021 03:16:18 -0800 (PST)
From:   Haimin Zhang <tcs.kernel@gmail.com>
To:     Greg KH <greg@kroah.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        security <security@kernel.org>,
        elijahbai <elijahbai@tencent.com>, netdev@vger.kernel.org
Subject: [PATCH v4] netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc
Date:   Wed, 15 Dec 2021 19:15:30 +0800
Message-Id: <20211215111530.72103-1-tcs.kernel@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-initialize memory for new map's value in function nsim_bpf_map_alloc
since it may cause a potential kernel information leak issue, as follows:
1. nsim_bpf_map_alloc calls nsim_map_alloc_elem to allocate elements for 
a new map.
2. nsim_map_alloc_elem uses kmalloc to allocate map's value, but doesn't
zero it.
3. A user application can use IOCTL BPF_MAP_LOOKUP_ELEM to get specific
element's information in the map.
4. The kernel function map_lookup_elem will call bpf_map_copy_value to get
the information allocated at step-2, then use copy_to_user to copy to the
user buffer.
This can only leak information for an array map.

Fixes: 395cacb5f1a0 ("netdevsim: bpf: support fake map offload")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
---
 drivers/net/netdevsim/bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 90aafb56f140..a43820212932 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -514,6 +514,7 @@ nsim_bpf_map_alloc(struct netdevsim *ns, struct bpf_offloaded_map *offmap)
 				goto err_free;
 			key = nmap->entry[i].key;
 			*key = i;
+			memset(nmap->entry[i].value, 0, offmap->map.value_size);
 		}
 	}
 
-- 
2.30.1 (Apple Git-130)

