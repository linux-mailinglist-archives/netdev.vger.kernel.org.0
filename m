Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1155127236A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIUMNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgIUMNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0335FC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a17so12477705wrn.6
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCyFS5QslMeWTOil0l98YYYoFrmDonUoF0YDrsUpPGg=;
        b=NCZF/nQvdg/E2X0Y2SyA1suKVtzhQuo9BkwJ2DhlWpw7IIB6FC96tUKCnVZKAbFMCe
         CfXvKuOhmIF3w17m7STfsamrYVzJdoK0cZ028RMG6oWOM9j+WnqTpbz8qn9GywejC54R
         dm23BZERF1kic+WsfwvOVmmeyXGxGuBC6yHSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCyFS5QslMeWTOil0l98YYYoFrmDonUoF0YDrsUpPGg=;
        b=DEGZc2KLn5KpipyVlXoux+KKml0Pi4052GegqqIMRFvndpjVImv4NztnvmMfWD5mVh
         /sh6hdi5VWaUTcgrJkIr3UhAKC+KPwnL4a/ZXd+bAuyhFcuCgVv9Xd9MJPXjV+LlAapU
         IwWit/sfo5qb/7spdDzYFrnL/MtPdldeXL9cEglZVVEZ7I6vhmhg03v3D6IZo+YoDncd
         kd3DqCICr8P7nz0RoS6S/0OyKonrk5Tk3DZ5oRE5wGLjh143qZ2n4p05IE035S+1euIH
         +pNM8TrVER3VdaZFwehoXz4DJijsEf7NsRzKZ8ziojMIpTf3+A1pEK6qsuMHLn8LhVgx
         KMzA==
X-Gm-Message-State: AOAM530DyLWlwxBfjvAVwPvTnAP/D41U5KopUcRTVNUTZTRS4OG9OrZZ
        ZzQsUMGLwDJ7v072+D7OnVghJw==
X-Google-Smtp-Source: ABdhPJw6LuyvG1QR4d9+wKwRElRb+rGut5+apknNDOUeIhw/lRiSUdjZ7OA0XMiDRos8T+n9U7JXmw==
X-Received: by 2002:a05:6000:7:: with SMTP id h7mr55208463wrx.16.1600690398725;
        Mon, 21 Sep 2020 05:13:18 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:18 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 03/11] btf: Add BTF_ID_LIST_SINGLE macro
Date:   Mon, 21 Sep 2020 13:12:19 +0100
Message-Id: <20200921121227.255763-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a convenience macro that allows defining a BTF ID list with
a single item. This lets us cut down on repetitive macros.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Suggested-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/btf_ids.h       | 8 ++++++++
 tools/include/linux/btf_ids.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 210b086188a3..57890b357f85 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -76,6 +76,13 @@ extern u32 name[];
 #define BTF_ID_LIST_GLOBAL(name)			\
 __BTF_ID_LIST(name, globl)
 
+/* The BTF_ID_LIST_SINGLE macro defines a BTF_ID_LIST with
+ * a single entry.
+ */
+#define BTF_ID_LIST_SINGLE(name, prefix, typename)	\
+	BTF_ID_LIST(name) \
+	BTF_ID(prefix, typename)
+
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
  * It's used when we want to define 'unused' entry
@@ -140,6 +147,7 @@ extern struct btf_id_set name;
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
 #define BTF_ID_LIST_GLOBAL(name) u32 name[1];
+#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 name[1];
 #define BTF_SET_START(name) static struct btf_id_set name = { 0 };
 #define BTF_SET_START_GLOBAL(name) static struct btf_id_set name = { 0 };
 #define BTF_SET_END(name)
diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
index 210b086188a3..57890b357f85 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -76,6 +76,13 @@ extern u32 name[];
 #define BTF_ID_LIST_GLOBAL(name)			\
 __BTF_ID_LIST(name, globl)
 
+/* The BTF_ID_LIST_SINGLE macro defines a BTF_ID_LIST with
+ * a single entry.
+ */
+#define BTF_ID_LIST_SINGLE(name, prefix, typename)	\
+	BTF_ID_LIST(name) \
+	BTF_ID(prefix, typename)
+
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
  * It's used when we want to define 'unused' entry
@@ -140,6 +147,7 @@ extern struct btf_id_set name;
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
 #define BTF_ID_LIST_GLOBAL(name) u32 name[1];
+#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 name[1];
 #define BTF_SET_START(name) static struct btf_id_set name = { 0 };
 #define BTF_SET_START_GLOBAL(name) static struct btf_id_set name = { 0 };
 #define BTF_SET_END(name)
-- 
2.25.1

