Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E330E43BC93
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhJZVoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbhJZVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:44:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87380C061745;
        Tue, 26 Oct 2021 14:41:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 187so702454pfc.10;
        Tue, 26 Oct 2021 14:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zYiUZsuAt0d8/CfnIpvY7tOtAIepLvDP7A9G8sy+glI=;
        b=RpAAO7kXo2VfE/3Qae1nBeHjIAfZKzj87hv5ekYTU08IHeE0+PNsLKEaBcYVlyGeXA
         vleVVRIHuMlaWPP6sYMp5Iq041VK1ZcLEs4IV73rs/JKzGoHvSsibNzc5SQsSRG3jd2h
         Oh0EZui9U5FHftQ55GqLbptge0jK6cLN5CrT4DXdxHoecYNMYFOdLaCzT/W3Qf7tM+Yz
         FAQjuJjN0MMJshJCjs4EvYFGWbcjAYjHH9hmDr1KhOB/cRGRtUjtVouJSxdbSvQAlGjC
         7tdCuM1nAD8tY07rNXZmfMwmvo69aA9dJ5E2x5VdYDgABGkYQkFrDq7Jqdlhf9ZW5080
         xd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zYiUZsuAt0d8/CfnIpvY7tOtAIepLvDP7A9G8sy+glI=;
        b=mKzCZMCR+REql3+wKCptU/0BGHnhtdKh+F2KKWatDL24+nsqxRUVDxoFShYWMXHfD+
         xTC/KlvU+gaEriXE2gUhRMW1RxHJpGVaQZ4pcW/S93cyfgfFPh8fo8qzazWUXMzSfufT
         Q7As4HBY5nX2hQP5EUUuV3Ly5+a7m4z1nSi2S4d7WTbP/fuvFoPDOa0UO0rC1ZUkBG6o
         8MjE1AsBwnvDlwyUhfMC6bOEJOrotyx1+63aueM5PmQmEzFhATMYgtCBlzzHaL6RueWf
         HPkQPcQTAXk+x8zWqTUIOrM3Ca8MgVmnQ5GGIPpIMK4987+v57rheCVX/63lYsXe/WkB
         0EjQ==
X-Gm-Message-State: AOAM530cVwML6ojGQgEv0NwaA3QxumATF1RjC8fXIq4dfgyJfY7BdqW4
        +ajfOTTII75n84Xa+YSLLNo=
X-Google-Smtp-Source: ABdhPJz2Up0zxfomMxEbV1N+Dcq61rPRBDMwTSH1T4iXe6QCV4CvFS9FSHnIrsSH1WzQF4C2uoJ09g==
X-Received: by 2002:a05:6a00:13a3:b0:47c:126:3596 with SMTP id t35-20020a056a0013a300b0047c01263596mr11906959pfg.5.1635284499143;
        Tue, 26 Oct 2021 14:41:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id g22sm6495400pfj.181.2021.10.26.14.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 14:41:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: [PATCH V2 bpf-next 2/3] bpf: fixes possible race in update_prog_stats() for 32bit arches
Date:   Tue, 26 Oct 2021 14:41:32 -0700
Message-Id: <20211026214133.3114279-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211026214133.3114279-1-eric.dumazet@gmail.com>
References: <20211026214133.3114279-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It seems update_prog_stats() suffers from same issue fixed
in the prior patch:

As it can run while interrupts are enabled, it could
be re-entered and the u64_stats syncp could be mangled.

Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/trampoline.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 39eaaff81953da6006702635fd67d08dd4a7daa2..e5963de368ed34874414d097bc6614ff7e168dd3 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -586,11 +586,13 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 	     * Hence check that 'start' is valid.
 	     */
 	    start > NO_START_TIME) {
+		unsigned long flags;
+
 		stats = this_cpu_ptr(prog->stats);
-		u64_stats_update_begin(&stats->syncp);
+		flags = u64_stats_update_begin_irqsave(&stats->syncp);
 		stats->cnt++;
 		stats->nsecs += sched_clock() - start;
-		u64_stats_update_end(&stats->syncp);
+		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	}
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

