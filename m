Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06D33A4C41
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 04:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhFLCil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 22:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLCij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 22:38:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067BDC0617AF;
        Fri, 11 Jun 2021 19:36:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g24so6668499pji.4;
        Fri, 11 Jun 2021 19:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5oTyBg2zzSvZuVYD/2K5aNP50Oymbht27Q2wyBGJt3w=;
        b=ptskm5sgUj/qxXMUF/gLmV6yBKXYt3QpalwYbSOy0xqEUATqnL6KHqZ33FcRJaOHwG
         n6WpLK5dqW0p4c+yOvRlwQnD7LRC7JJz0gjsOaRU0/4lZwRWRCicUifFzA314WnsgLWb
         QzT2gI1Vzkv8LctzNDOtqEZHlFUxrbK3im9RC/c1Aeg8GFCqGWEe6Bte1XYL5fKunNng
         BwNDIxeouajOhYpaFLhiQ+r1SjTx5HC+yrJTN3OM99sQ5+8z+11rcHuh0Ju8w36hU3Rc
         JZVR4Vcl4aF6LUJsHlVccmdfSGVLH285mup+bqhW3+7A16fi78bAJOVpEB4MWVKIKXCT
         6BDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oTyBg2zzSvZuVYD/2K5aNP50Oymbht27Q2wyBGJt3w=;
        b=XT0mZEt2afgrkV/fX9xrYwaewDjopUAefFk/kn6MQN11oFnbxV3WUoakB1NK6cDEaV
         OMUwUtMjrZUpZg6GuWf6ownXw8u1zZYYeKzOI3WVu+pgYsjJTNs7JE4SfHFpX65SQaHO
         vVtR1LWZlDA1IbZiMm46qpi4oV7fMau2kE4k37pxaVVkMTnGtaFUsfZD01lkbGVjh9fK
         xhIrVM1b6wfrgl78+ifWJYm/KV0i3qQkh/FO7k19IFjC4OKbyrJ3qags9Xw36M5ON3FD
         g8sRThv6se46F997Bs2sJzBmYKvu4t6n+LS72yX+OKj2nwJZgBePdc556I2emE/wmaNv
         dyYQ==
X-Gm-Message-State: AOAM533E/Uk+Yqa/WNafYu9Wr8/Vvh3Wtc48JTy7okg4LAPL/D5qX7hS
        PjE4gVd4mm1X9G5AEj04f+AffKanHj0=
X-Google-Smtp-Source: ABdhPJwxDA2DovcyD9w/5/CEBjVlJZOoZW/0BrrK2UUjLsyh7qzRiX3UbYbT6piPIzIRieODIhhjVA==
X-Received: by 2002:a17:90a:7841:: with SMTP id y1mr12074959pjl.119.1623465388439;
        Fri, 11 Jun 2021 19:36:28 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id cl4sm5842238pjb.32.2021.06.11.19.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 19:36:28 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next 2/3] libbpf: set NLM_F_EXCL when creating qdisc
Date:   Sat, 12 Jun 2021 08:05:01 +0530
Message-Id: <20210612023502.1283837-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210612023502.1283837-1-memxor@gmail.com>
References: <20210612023502.1283837-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This got lost during the refactoring across versions. We always use
NLM_F_EXCL when creating some TC object, so reflect what the function
says and set the flag.

Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index efbb50ad59d8..cf9381f03b16 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -457,7 +457,7 @@ static int tc_qdisc_modify(struct bpf_tc_hook *hook, int cmd, int flags)
 
 static int tc_qdisc_create_excl(struct bpf_tc_hook *hook)
 {
-	return tc_qdisc_modify(hook, RTM_NEWQDISC, NLM_F_CREATE);
+	return tc_qdisc_modify(hook, RTM_NEWQDISC, NLM_F_CREATE | NLM_F_EXCL);
 }
 
 static int tc_qdisc_delete(struct bpf_tc_hook *hook)
-- 
2.31.1

