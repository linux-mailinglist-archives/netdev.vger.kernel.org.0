Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A706022577D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 08:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgGTGRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 02:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgGTGRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 02:17:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CCDC0619D5
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 23:17:45 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a19so12834341pjq.9
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 23:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hrTZ3ILM0xAvfuFOaXWaqEFvmBYS4j5nhBs2MogC2d4=;
        b=jCza9kObWWd7hRrzAmTOlTIznNK5au/+obW9N2t3FEDENVbFaIuGNwvI+czZfkkjfj
         yz5Acv84a48iP3jdHNxPq9oYAQ3JsaCd43nn72tDwiAb0KzKjz0D1eRaxZPmSvNI3v5p
         14yBIbxUS2mz1cy/VgcYLfGAwLfyPgaeo6KCWa24lFD8fcp2A8oN/a5lernNHq87QTsg
         uJDXeoEKZy1wotyY285VjM6pvyZt7ZdO0ouJqrQBQpT/blmMz44W6ZUa2RD3iVc6yJ3b
         7Xl+rFZB34WWL6EpieqghLEjm+gNI2iCaVcFn7br2mXNH9ssLJR3SbfkLhib6q4xprWM
         isOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hrTZ3ILM0xAvfuFOaXWaqEFvmBYS4j5nhBs2MogC2d4=;
        b=kSz7X39cx5hRDF47PKRRnfPo1X9n9P9eZuhRhTfHn+kAcYhNzyxOXs52zfCk9T1IE2
         UVeSHVJ6n2jksHPUKN765Eq1U4//+bmjqeRQebq0vESdiOpL8zZySZBrznivtdN6Lp+L
         bBX1h9eq+K9a5Wo3et2q3EhMmbWe+G5isrRfyWHTNG1kNQQOhYDVlycQ22iHrw9thkSc
         XrIP2xvsVJlP9B6FIqEWpYds8G1N9BCSEP0rSkhoXIMQ1/VpxGjvMwg3RlWwYCa2e4cW
         mup3iXfW2x0zvR44qLg24Lnz+X+DQWJww9PcnkZh5MneDJcT2wc9HydWW8EtGpASc3g+
         5VeA==
X-Gm-Message-State: AOAM531h94n0AeDh6Q3p2Sx/a+DPNSLR9/4uSJrYS3eNw7tXXtyx0su8
        pTvKLniAOT5qGGQfJY0vglSt3h7YRh+s
X-Google-Smtp-Source: ABdhPJxZ8KghvpQ17ZJUvd8FHOaqBfl50iarL4t96zD8AY8mjE1sgffczbDNvDrTORIDxuIPH0nKQjc6wtWJ
X-Received: by 2002:a17:902:b78b:: with SMTP id e11mr16332011pls.204.1595225864907;
 Sun, 19 Jul 2020 23:17:44 -0700 (PDT)
Date:   Sun, 19 Jul 2020 23:17:41 -0700
Message-Id: <20200720061741.1514673-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2] libbpf bpf_helpers: Use __builtin_offsetof for offsetof
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The non-builtin route for offsetof has a dependency on size_t from
stdlib.h/stdint.h that is undeclared and may break targets.
The offsetof macro in bpf_helpers may disable the same macro in other
headers that have a #ifdef offsetof guard. Rather than add additional
dependencies improve the offsetof macro declared here to use the
builtin that is available since llvm 3.7 (the first with a BPF backend).

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/bpf_helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index a510d8ed716f..bc14db706b88 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -40,7 +40,7 @@
  * Helper macro to manipulate data structures
  */
 #ifndef offsetof
-#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
+#define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
 #endif
 #ifndef container_of
 #define container_of(ptr, type, member)				\
-- 
2.28.0.rc0.105.gf9edc3c819-goog

