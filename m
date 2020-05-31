Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D451E9656
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgEaI33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgEaI3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:29:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B64AC061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:00 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gl26so6249898ejb.11
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P6hhD1gpEYyyTsG5wna8NX2v+cYMcZ2GZPPNFHidNbU=;
        b=OGJxXLZSHYBkDmS0aWBcuNeJQ0aCQ6lpwg0IelWNG+40n/4Q1uum8+vpztVHsB2cZY
         sHzWBaIsQpNCgju/b+cxfFQESwgIq20xHkNfRW6x3avQz7IYiPgH4EDHmi0zLsoBiQ6w
         CqmW5H3uorXADzOM3C9rbDmr/87Jk6Aljpkgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P6hhD1gpEYyyTsG5wna8NX2v+cYMcZ2GZPPNFHidNbU=;
        b=TtUbpStdTN44v6RKyRq3Bna92GmBBB4NoGTGxGhoolQp6CEiR4xdTc+Uq5PP75ayGc
         Gdb4GJDq+1z97/nyABWC2XwEOtZ+skKu3iE46EcndIm3CSbd6RopggxenEh+afbowEy2
         FIezaPRhM6ts5F4/zeXrr+feHmyNocbY+RzN5zKT032tZXSgIIBxZrkHdgPJbC7FYYK2
         EZcqcmaK2pead0exVWorfxvRv0rOfXo8JMSLwskcbg1/gextxtDRrWdxvN1il+gY/Mq5
         DEVuto/VSRW9uULQOHG2M/meZoOfkK+4fH/9FADZ/cScX6Tts4G2BrxdfmeWN8X6gc5h
         eFTQ==
X-Gm-Message-State: AOAM532cmfC3ktzl4qxaABEzm/LRNyHQn8HakdFCY0SWYx4WxjYgM6le
        c8KxPpboiZwLKdnnXqmxf3Wncg==
X-Google-Smtp-Source: ABdhPJxXEeVlpE0iKL373LIknlsYtHroJQJyEUVG50oLhXoNzHULY7aSAulW7u2Q2TNySjDuERTfWw==
X-Received: by 2002:a17:906:3bd7:: with SMTP id v23mr4153545ejf.299.1590913738962;
        Sun, 31 May 2020 01:28:58 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id dt12sm12089119ejb.102.2020.05.31.01.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:28:58 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 05/12] bpf, cgroup: Return ENOLINK for auto-detached links on update
Date:   Sun, 31 May 2020 10:28:39 +0200
Message-Id: <20200531082846.2117903-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Failure to update a bpf_link because it has been auto-detached by a dying
cgroup currently results in EINVAL error, even though the arguments passed
to bpf() syscall are not wrong.

bpf_links attaching to netns in this case will return ENOLINK, which
carries the message that the link is no longer attached to anything.

Change cgroup bpf_links to do the same to keep the uAPI errors consistent.

Fixes: 0c991ebc8c69 ("bpf: Implement bpf_prog replacement for an active bpf_cgroup_link")
Suggested-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 5c0e964105ac..fdf7836750a3 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -595,7 +595,7 @@ static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
 	mutex_lock(&cgroup_mutex);
 	/* link might have been auto-released by dying cgroup, so fail */
 	if (!cg_link->cgroup) {
-		ret = -EINVAL;
+		ret = -ENOLINK;
 		goto out_unlock;
 	}
 	if (old_prog && link->prog != old_prog) {
-- 
2.25.4

