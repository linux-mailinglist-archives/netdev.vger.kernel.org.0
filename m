Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C800F43BBB3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbhJZUlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbhJZUlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:41:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DD8C061570;
        Tue, 26 Oct 2021 13:38:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m26so601796pff.3;
        Tue, 26 Oct 2021 13:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MRtccMdi1NGrZmESKfdGKtX5OHduZDH2rm/cokwWIs8=;
        b=MpezclMoLmUG/nEvApQ8jtm+U1hWVxqrP0cluiQreVvjRIAk6Gc1Lvq3ztZg4/iAcj
         dOB2iOeYUXHpqEZ7MP3aSTLgK/J9CTajf9P+RkgVIl+gucVNKl2a6eWYauMxj5ZI6gkx
         Qpu80r8uznzAZvGuN1hb8mzEDOZCwE9eFwbWHL28bnA+wuBUpNISB4vtxFLB23Ue7G/n
         1fUzQUXRZjTG3ILLL4o7KmIP4LvyPw/70/X/Gh3PxkiEO50GP4KFzGvHECV5oB8ZrjT4
         xz2uzB//OMhkuwTumk1dRDs+ABOksF+au6pTAg29kb585CdtuiolvGziOB00BbZNBX4n
         glJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MRtccMdi1NGrZmESKfdGKtX5OHduZDH2rm/cokwWIs8=;
        b=e3aAuzR8vWzSOjmMPH4dXywV35KIty33PTH8OkdbGsuBAe+N5aqFDUVcUWyZNPhNLa
         12AFJ3kekB17E6kTSiM6dUp1T1QP7J4hp/mUWvWFbC/bRbrv8PSr80wUFfAWCPyUwApE
         Ed30dBwEk29QYLjB/OwiMLhJrjbtwEqNy2q0YDCXBidxZn3CISSKqB65UxebcAzRGmGS
         U3ylab21JrRaimRdGXCVDR3TOEoR0E2t4UJN8E07tZDE+0M1MLMMi0niGgRVrnS2vmkp
         SjcgTTjMvEgJBJa/9fSy6WqiAX1sOfJzmZrtX9upIzot0NtV/bWwDyRXKKykFSVnYpKG
         5b6w==
X-Gm-Message-State: AOAM531Yj4FagyxKPoITZLmXYADOKCitK7lEl5ucySqQyb97ch1sisjA
        CvHyGckmmvv30R7yquMvTv4=
X-Google-Smtp-Source: ABdhPJyRH0xqeonwoTBxjQCxhaQsoJAk/LlNymjEePUY/ElRHFa58JczzEDGGYaxeVcRjU1ToUyGfg==
X-Received: by 2002:a05:6a00:1897:b0:47b:ff8c:3b05 with SMTP id x23-20020a056a00189700b0047bff8c3b05mr11924157pfh.37.1635280715469;
        Tue, 26 Oct 2021 13:38:35 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id ip8sm1944477pjb.9.2021.10.26.13.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 13:38:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: [PATCH bpf 2/2] bpf: fixes possible race in update_prog_stats() for 32bit arches
Date:   Tue, 26 Oct 2021 13:38:25 -0700
Message-Id: <20211026203825.2720459-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211026203825.2720459-1-eric.dumazet@gmail.com>
References: <20211026203825.2720459-1-eric.dumazet@gmail.com>
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
index fe1e857324e6683cecf5f88d24e0790f7ec72253..d3a307a8c42b95692f082f23f01e1ed470e63dec 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -585,11 +585,13 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
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

