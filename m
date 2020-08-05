Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C64E23CD2D
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgHERWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgHERVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:21:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EC7C06179F
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 10:21:12 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r11so15185921pfl.11
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 10:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FbzyMEQueQDY3YDpmwzlLQ7A2LdIlI00oS2N1BmMemo=;
        b=1p9kECCs2Xu30P/0sAU+cJKXlwibxSqcehh6AyJa4aBU4moLlvMpXPt/tyOryRrF2q
         33XZM2JlPVoeldKBki9UbuapxrXDnWnTYJWGdd51STCGwlS3vT7D13q4mQdwVyiIE8pP
         K5/wGPaF37h2DxnFPLpVXsP0q6X7wdW1HsFrJaX+k1AocBq7BF1R4zQyHMxPH+I+2Xeh
         VnxtaGlErCNqRJkqMJik4ILc/Xw1ksRRpn5m8COXa9VN3Uqbcyckyfw1VxHq5rPnAKca
         05sUegVB6m5V6ARTNN9vuWcCC2gTsYDe4SisszMj13Evi+Su4zGJTgbttY/H9t92qyfu
         XfDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FbzyMEQueQDY3YDpmwzlLQ7A2LdIlI00oS2N1BmMemo=;
        b=mphhue7Gi5SUXDKLeNJmclmqha6EXgSRD3AdybUTYJ+YtmDdpbpJLlStFoBLaXKX/M
         7KiilyL4SIPD72vPhFYNM+VCPILMhhGhubmukU8Q+74catjFeedNNkjccckftjZpdl4C
         IW2m6ISB50Ek5niIZdzCKR4fyZmw0JjIk96lfF1vJE8qpxsh1Ojp+IzM3IL7VWCIOcru
         hvByYzLLQe1bbIiMfMAoYOLOQjppc4eM7XRaddCuRP3VtYZrQisszWyhTFNAXlMlszCl
         KbaYaRsG4IoCdLIck3L5DvDl2l2ZdDHSgefXAcvNt05BEKH0B7ROh//inUsHvx1ayH6D
         u2BQ==
X-Gm-Message-State: AOAM531QCVxxuRFbsKfUVVrgs/edJGcqYXLDzqr8JLrx4YWMhFtGUyjX
        lie6bRKnGONIxyc2SVpx1d/New==
X-Google-Smtp-Source: ABdhPJzIkVaHvoR9tH5K50gUhGmPh+91WufLNUGc3rhmCrQDI0HIHRst5vySfI+LEfznVwHsaMaGmg==
X-Received: by 2002:aa7:92cb:: with SMTP id k11mr4287827pfa.233.1596648071561;
        Wed, 05 Aug 2020 10:21:11 -0700 (PDT)
Received: from localhost.localdomain ([103.136.220.73])
        by smtp.gmail.com with ESMTPSA id z1sm3709583pjn.34.2020.08.05.10.21.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 10:21:10 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     rostedt@goodmis.org, naveen.n.rao@linux.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        sfr@canb.auug.org.au, mingo@kernel.org, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] kprobes: fix compiler warning for !CONFIG_KPROBES_ON_FTRACE
Date:   Thu,  6 Aug 2020 01:20:46 +0800
Message-Id: <20200805172046.19066-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix compiler warning(as show below) for !CONFIG_KPROBES_ON_FTRACE.

kernel/kprobes.c: In function 'kill_kprobe':
kernel/kprobes.c:1116:33: warning: statement with no effect
[-Wunused-value]
 1116 | #define disarm_kprobe_ftrace(p) (-ENODEV)
      |                                 ^
kernel/kprobes.c:2154:3: note: in expansion of macro
'disarm_kprobe_ftrace'
 2154 |   disarm_kprobe_ftrace(p);

Link: https://lore.kernel.org/r/20200805142136.0331f7ea@canb.auug.org.au

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 kernel/kprobes.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 503add629599..d36e2b017588 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1114,9 +1114,20 @@ static int disarm_kprobe_ftrace(struct kprobe *p)
 		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
-#define prepare_kprobe(p)	arch_prepare_kprobe(p)
-#define arm_kprobe_ftrace(p)	(-ENODEV)
-#define disarm_kprobe_ftrace(p)	(-ENODEV)
+static inline int prepare_kprobe(struct kprobe *p)
+{
+	return arch_prepare_kprobe(p);
+}
+
+static inline int arm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
+
+static inline int disarm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
 #endif
 
 /* Arm a kprobe with text_mutex */
-- 
2.11.0

