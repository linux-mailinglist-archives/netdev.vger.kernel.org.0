Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACAC2235D7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgGQHX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgGQHXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:23:25 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D8C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 00:23:24 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 13so5447490qks.11
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 00:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5JEHKtkNKwD/IFM6abRMVdLiY/nHNFDRNsJu7Y4oxIQ=;
        b=EVLuhEDfl6DZfCFR93tOM8LMOcPSAmqarvN0/aeKDzhjJYsPnD9A76hKAwYn5U+vLl
         X7nj7aHYzY4TzVwkilEoKwV6Ns3VmLifEJtEfuWg4vHnd7VPvumlPkpdZuLPeWo7GOqU
         lQPQp4w1EtYwsS98PsELQYO2qF7wd2VRo8EVI9Z0Al/Xcu5hYNIAKOuoz2TmrKsO3Bom
         Za8jUnqGG5TpaxAA+3Dx3imqKnHPD92aJfjs0uLieGleb+sD5faOWhZhW8Nr8aNfKal+
         cN8+7hatUtaeN8yo4AdOrjYVoUwqzEh2h6vBq9KCZZCNZkNNrQUtF/Ze7TFtOY1nATBk
         4B2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5JEHKtkNKwD/IFM6abRMVdLiY/nHNFDRNsJu7Y4oxIQ=;
        b=hSy8FMoWlO6PEJNDDxQURtVYPnrSOJr3dvNj9l+7tj219CfhGTad8XZ1In7ZxkdB3U
         lk/MbHl7ILLPT+IRwXalYEiAar15VtcjBeVBpkrRe0yiI2um0ycixFUDKK2ja5Y9Yh4Y
         3vr6tIsIU8sMlpcFW8Ug+CIDZc3tErrQMKUrKhlUn6P1dUBUjSkwL0AVI8B/PERIYHxm
         yvoesjItwM1FyKte8WtLfuA5YNKxwj8qPN0NPyzbGHLhAO5glAn9WrT3P32GoaCa6es7
         g/v+aCvi6yZ23b0EfJ221eiTB7FF0SEU65+4V1FZgEZBcueVahCs4/5kjve1YKmm7cEB
         e3Rw==
X-Gm-Message-State: AOAM5329124TlWSjyM1KMZf//ovBmQ4/NgHxEfQeTMCblDUdfF9b74kn
        RilSlgnYZaaSRmC3KEE1VbabYYOyBWLf
X-Google-Smtp-Source: ABdhPJyu6o/+eHADGbRiTA6nJ9eXX4wP+XlVH17O9nWIVLs4cg1HQkJTLuqrw9yZ/ysh1FWVtnVwOREcvew3
X-Received: by 2002:a0c:e747:: with SMTP id g7mr7589622qvn.77.1594970603845;
 Fri, 17 Jul 2020 00:23:23 -0700 (PDT)
Date:   Fri, 17 Jul 2020 00:23:19 -0700
Message-Id: <20200717072319.101302-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH] libbpf bpf_helpers: Use __builtin_offsetof for offsetof if available
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
builtin if available.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/bpf_helpers.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index a510d8ed716f..ed2ac74fc515 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -40,8 +40,12 @@
  * Helper macro to manipulate data structures
  */
 #ifndef offsetof
+#if __has_builtin(__builtin_offsetof)
+#define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
+#else
 #define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
 #endif
+#endif
 #ifndef container_of
 #define container_of(ptr, type, member)				\
 	({							\
-- 
2.28.0.rc0.105.gf9edc3c819-goog

