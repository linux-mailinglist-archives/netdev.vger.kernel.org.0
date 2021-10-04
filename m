Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2A94208B4
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 11:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhJDJvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 05:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbhJDJu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 05:50:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78875C061745;
        Mon,  4 Oct 2021 02:49:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 187so9592558pfc.10;
        Mon, 04 Oct 2021 02:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8J25Gq6xzCDmlDqYl4jc967Wi537iG16/emcYGXLlM=;
        b=fzxOW1f/y0CMTAl0VcNoUKwW4usxc3D2fA/o9/TPoAIA0GiTvUIXJBY/fgLFISROyL
         ddoeLQmXu8Xwbhg1xpZ37ajlGufogr7Ud2JRxdqj7uO+4CXxMIYvdv+SzgbomJSbnj4m
         EqiMPUse7h46+hI/j7jVNlFC6adhyqWK1/DZ+hLCFp39DLthg8pw3yG1Y72Cx+IwryJF
         w7SIUQLHXBhi8o0MGdPkjkq2aDSvrOMjXh+FYnVK8Kt+wGwdJ+yIV6B7OQKNlqmkgmdA
         dIEgZWDuxuxFoejaNKmQauaXxTjaZh+OykOzzc57JQcsyL38aVIZ1BXf+SKuhppj+kGs
         y53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8J25Gq6xzCDmlDqYl4jc967Wi537iG16/emcYGXLlM=;
        b=N6YSTHi0gw5RG6pbs1CrkbmT0w05p4usmMklP4Yl8RALh5jV4t5tIiYSDI2QhvZ+wW
         DsyIrESAaPlb922D1lgUItAGCatxAmnClJRu7LyByQ8J0j3ormZBp8M9KDJGv2cTJryK
         CO9kfO96HR4Sd6dJi1QwRaD2S0qaex+BHT3dfSMSgVhFUufE1gfGn8lX3TsYy9EkUPYi
         cMOZJNI1uYmvesjrvwJuKGACdsXY/svSDhycsSH6A1wWNxvaKlkAhMX5wtJgrEOQQEEE
         3HsdXIZTDZF8tqQgtBSbx9HdWOSjQkVkPOvHXDDHSI7Jr1FuM4OqRic02ZxzcZ/d/UeV
         ivGw==
X-Gm-Message-State: AOAM530PYel1SJ+L75A9OlXkrv0c5ta7xP/waZVdZvKX+KCtq+WNGkpF
        w12FA+U8fVngU0OWh3tq9og=
X-Google-Smtp-Source: ABdhPJx1dgxbjxTuUugAErAQ5vD1veWy18SQTVcqXO+gegOfWAjhc9HyL+jUYnmrQorsrQDuvSHGNg==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr10170214pgj.263.1633340949116;
        Mon, 04 Oct 2021 02:49:09 -0700 (PDT)
Received: from localhost ([27.102.113.79])
        by smtp.gmail.com with ESMTPSA id g10sm7659107pfv.109.2021.10.04.02.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:49:08 -0700 (PDT)
From:   Hou Tao <hotforest@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next v5 1/3] bpf: support writable context for bare tracepoint
Date:   Mon,  4 Oct 2021 17:48:55 +0800
Message-Id: <20211004094857.30868-2-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211004094857.30868-1-hotforest@gmail.com>
References: <20211004094857.30868-1-hotforest@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
supports writable context for tracepoint, but it misses the support
for bare tracepoint which has no associated trace event.

Bare tracepoint is defined by DECLARE_TRACE(), so adding a corresponding
DECLARE_TRACE_WRITABLE() macro to generate a definition in __bpf_raw_tp_map
section for bare tracepoint in a similar way to DEFINE_TRACE_WRITABLE().

Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/trace/bpf_probe.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index a23be89119aa..a8e97f84b652 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -93,8 +93,7 @@ __section("__bpf_raw_tp_map") = {					\
 
 #define FIRST(x, ...) x
 
-#undef DEFINE_EVENT_WRITABLE
-#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size)	\
+#define __CHECK_WRITABLE_BUF_SIZE(call, proto, args, size)		\
 static inline void bpf_test_buffer_##call(void)				\
 {									\
 	/* BUILD_BUG_ON() is ignored if the code is completely eliminated, but \
@@ -103,8 +102,12 @@ static inline void bpf_test_buffer_##call(void)				\
 	 */								\
 	FIRST(proto);							\
 	(void)BUILD_BUG_ON_ZERO(size != sizeof(*FIRST(args)));		\
-}									\
-__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
+}
+
+#undef DEFINE_EVENT_WRITABLE
+#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size) \
+	__CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
+	__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -119,9 +122,17 @@ __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
 	__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))		\
 	__DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0)
 
+#undef DECLARE_TRACE_WRITABLE
+#define DECLARE_TRACE_WRITABLE(call, proto, args, size) \
+	__CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
+	__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args)) \
+	__DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), size)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#undef DECLARE_TRACE_WRITABLE
 #undef DEFINE_EVENT_WRITABLE
+#undef __CHECK_WRITABLE_BUF_SIZE
 #undef __DEFINE_EVENT
 #undef FIRST
 
-- 
2.20.1

