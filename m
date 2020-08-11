Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D668024224D
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHKWFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 18:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:05:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FB1C06174A;
        Tue, 11 Aug 2020 15:05:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id r4so187174pls.2;
        Tue, 11 Aug 2020 15:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Jv34c1zVCW1Zn5DLAPBWJEA8tPhSD/upIhUsB5wLwsc=;
        b=Glazygkwli4I0GeR7e0TwA3Io1YsUv0TYNj4H3nsJnhtQMCYZuFW/H+//TJwp31rZQ
         p9vEvYOy3WpDsvCVdJCk9K7BBlJL+sblJP/AXU8VJiQe1e97i9O2oeGYCccEBnx2Eb9d
         0i9qttnPmUx95Ysq9saKVD6MykgBHkuJYKvZmWVpqqbc8ay6LOR3CS++DzXwGv0MU9/W
         grMhmYluABPR+wQGx3xOv2woo0dbPyd/nqJk1G6q1IwtCDPc9f8gkfQrRbGt2VYoV8jO
         gLneTMWSLA2Z+gkjJK/XAi+4eo46w2A7E0Sp1rkz2iFf/UsnDnhz8jgo9S2Dtxfwsyuh
         oQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Jv34c1zVCW1Zn5DLAPBWJEA8tPhSD/upIhUsB5wLwsc=;
        b=f9nXymBg5abPd8CuQZCfs0ce2qn92kCBlBYLRua/1PvLGScQ0dYywQ3rZhzEUjJOeF
         Dd/3/l7fWAKaGjsmlCMcO18CwmUJOhfsMGfSYIcrcl+jhiHUMCBiNBTpAE4ILJLBOQyG
         kxucOVJ5lZlQ9iIRQMA/+IJhjYpucec7Y6Xxs0ySEduDzWs1p3RNiRD/TpFlTX7beyhH
         v+3HVDCJI5Y3cbv4Xzd6npJfMCD8esk8wdMqwihbX+EGG54iJ67o1+fi7jNPBWMGlLPn
         2aYxfmptjj86WvfurE9+jSSoBl8jYfxmaW6KfF4YUJsLdP+iq0HjRBx1bi20wxlWsEVk
         Ob8A==
X-Gm-Message-State: AOAM5326BNbQ/+vfPHJk+mxbsmPoVJKlhaDx8IVtyaT9MN3ybSsotMX0
        pIcD/jEnUnPbUOZRgbFlAEU=
X-Google-Smtp-Source: ABdhPJwT7MP8ZcJ2f4sHtYqnqRWYKweUzqtXdXsDQNwIv5plaQD3q9WJ3RTWQtdKDIm2PA6kVVSOfA==
X-Received: by 2002:a17:90a:d252:: with SMTP id o18mr3075776pjw.146.1597183547305;
        Tue, 11 Aug 2020 15:05:47 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id mr21sm3633652pjb.57.2020.08.11.15.05.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 15:05:46 -0700 (PDT)
Subject: [bpf PATCH v3 4/5] bpf,
 selftests: Add tests for sock_ops load with r9, r8.r7 registers
From:   John Fastabend <john.fastabend@gmail.com>
To:     songliubraving@fb.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 11 Aug 2020 15:05:33 -0700
Message-ID: <159718353345.4728.8805043614257933227.stgit@john-Precision-5820-Tower>
In-Reply-To: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
References: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loads in sock_ops case when using high registers requires extra logic to
ensure the correct temporary value is used. We need to ensure the temp
register does not use either the src_reg or dst_reg. Lets add an asm
test to force the logic is triggered.

The xlated code is here,

  30: (7b) *(u64 *)(r9 +32) = r7
  31: (61) r7 = *(u32 *)(r9 +28)
  32: (15) if r7 == 0x0 goto pc+2
  33: (79) r7 = *(u64 *)(r9 +0)
  34: (63) *(u32 *)(r7 +916) = r8
  35: (79) r7 = *(u64 *)(r9 +32)

Notice r9 and r8 are not used for temp registers and r7 is chosen.

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index f8b13682..6420b61 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -75,6 +75,13 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		: [skops] "r"(skops)
 		:);
 
+	asm volatile (
+		"r9 = %[skops];\n"
+		"r8 = *(u32 *)(r9 +164);\n"
+		"*(u32 *)(r9 +164) = r8;\n"
+		:: [skops] "r"(skops)
+		: "r9", "r8");
+
 	op = (int) skops->op;
 
 	update_event_map(op);

