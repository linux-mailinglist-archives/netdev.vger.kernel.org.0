Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116051E0E73
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 14:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390531AbgEYM3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 08:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390492AbgEYM3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 08:29:31 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51354C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 05:29:31 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y17so8527815wrn.11
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 05:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=okfMkOEy6BJedGaS7fNe8T5pyno8cyE3qtzAy6s5wmQ=;
        b=wEp8gGGNEJrCAy3mYECILXNzwxfDNqxu0dS9KZMFc/s4TJV7gE5pmN4yEcNNIcNfrV
         VmBoZ1HqFa/7bH9E5VY0MsDv+cVjXlXiID2WB6zHKNmDTrJuJUTwUVgp1ADF9gobJGwv
         sHhgiLFDPYOMhRwl3hNs06xgCNcp5lg0t+B1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=okfMkOEy6BJedGaS7fNe8T5pyno8cyE3qtzAy6s5wmQ=;
        b=qSfu9bbR+T4jhhcajNcwNeF8q87r4n5XIjdGOmgpHOrl9fajpMkBdWsdRVU39r4+/e
         BzxO9K8K0TTpO/EHcIumVAxyAgDQBs7QFYTfo9+zBaoQSMm+KpbuS6FpyQ+Vx+DPZQwZ
         gKylAMtj2eW2dqhf5AqdQb1XP1TOcZs3JNUfBTu9+IROMQtjeimulFbiF6Z/7bDzlXnb
         W3AZOvVK+M6kcsEJ/qVVyiQN+XxFr9X/vlg1HSfBmjpWpoN9Ss8WVZImKgW49XtnEpty
         H//hVaUA33YS5y+uPKV7CSXEH5SRolOaE7M059r7gPTOxjASY/m6fm2D4BBQ6YvEApsc
         bUqA==
X-Gm-Message-State: AOAM533uNbvORlhlGTR3Z1kFaeqvWO3GPWPI2sTRk32cWsMvPpHrH0Yo
        1IA0IOPfBaGHywJKH8AzxeRzfg==
X-Google-Smtp-Source: ABdhPJyJ2iVgeJ7fBQOtbESPYe7+p6XwHcKKH8gfAS9eusHYoFX2/sTGcJKwR1BqBIYaI3hUJ738Dw==
X-Received: by 2002:adf:ee47:: with SMTP id w7mr9504433wro.171.1590409770020;
        Mon, 25 May 2020 05:29:30 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h20sm18017302wma.6.2020.05.25.05.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 05:29:29 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next] bpf: Fix returned error sign when link doesn't support updates
Date:   Mon, 25 May 2020 14:29:28 +0200
Message-Id: <20200525122928.1164495-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

System calls encode returned errors as negative values. Fix a typo that
breaks this convention for bpf(LINK_UPDATE) when bpf_link doesn't support
update operation.

Fixes: f9d041271cf4 ("bpf: Refactor bpf_link update handling")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 431241c74614..f9c86e0579da 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3913,7 +3913,7 @@ static int link_update(union bpf_attr *attr)
 	if (link->ops->update_prog)
 		ret = link->ops->update_prog(link, new_prog, old_prog);
 	else
-		ret = EINVAL;
+		ret = -EINVAL;
 
 out_put_progs:
 	if (old_prog)
-- 
2.25.4

