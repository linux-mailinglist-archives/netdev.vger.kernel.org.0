Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8B7211FCB
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGBJYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgGBJYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2BDC08C5DF
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:42 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a1so28441563ejg.12
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dUD5/O5JmmQd9avQsz8vU4NwUpBfW5dUvsNSWV5Va+g=;
        b=gCse1RVHndTjiEMMEdTrmxPrXahu5yJklsvinv478w8fLdmFReT5moIpZMh3Yd/B8J
         hyQmEXDCG2YAI7qBv9DSkFqnuXSp9lvejOyHp1Ez3AcbJ9C25D5wvX5PWCxy0kXWLlZB
         mO4Ot2efiqlJE9KRCFElt0+dtCp+qodhPRU5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dUD5/O5JmmQd9avQsz8vU4NwUpBfW5dUvsNSWV5Va+g=;
        b=tS8Gnb2w2KSmIIlCJmR6BBScLcyIJiNOvXISAk6HsLyalBGYsrsK3IlkYb6J/XW49q
         iotHIJdDaOKJ7nWeqDIoYCVCkO2eIdz6DFXJUAy9XgKjS4veIcFJs3ujUVOojgnDI7tl
         Zg2R/5ikkKd4QTCMnPXdI7eSAmagEj5elFAaY2a6bV6oagpMU5JyzlyXfraMbb1tFu05
         HRo1ZNAiBUb4cVStKVkxBNqTTRh03dHmNHNQbfvkz2VVK/1/cj+pgABAkZ0Xp6LCVcB2
         Mk2mDUjmYTzT1FP7+mNilbCVSp7PpaOKvsxc+jyET1BrFpxXgo/phHougKgBCfcs4nej
         QFbA==
X-Gm-Message-State: AOAM531jdAWzLKQEANekwzCP5TPcNyZiQQGFhku9Xb0D45Csib7KZ130
        GzizATOY77X7vSxnzdkETVszOQ==
X-Google-Smtp-Source: ABdhPJy7+mZFxJAc2XBftJ52gIc4NT73Xfq0gFwAfeaJjKfbA3a9Pbfe9xgccv3zEaKQfOVVTZkhDg==
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr25785889ejr.20.1593681880857;
        Thu, 02 Jul 2020 02:24:40 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id bq8sm2897301ejb.103.2020.07.02.02.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:40 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 13/16] tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type
Date:   Thu,  2 Jul 2020 11:24:13 +0200
Message-Id: <20200702092416.11961-14-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpftool show human-friendly identifiers for newly introduced program
and attach type, BPF_PROG_TYPE_SK_LOOKUP and BPF_SK_LOOKUP, respectively.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - New patch in v3.

 tools/bpf/bpftool/common.c | 1 +
 tools/bpf/bpftool/prog.c   | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 18e5604fe260..c254f6f5a3d6 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -63,6 +63,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_TRACE_FEXIT]		= "fexit",
 	[BPF_MODIFY_RETURN]		= "mod_ret",
 	[BPF_LSM_MAC]			= "lsm_mac",
+	[BPF_SK_LOOKUP]			= "sk_lookup",
 };
 
 void p_err(const char *fmt, ...)
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 6863c57effd0..3e6ecc6332e2 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -59,6 +59,7 @@ const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_TRACING]			= "tracing",
 	[BPF_PROG_TYPE_STRUCT_OPS]		= "struct_ops",
 	[BPF_PROG_TYPE_EXT]			= "ext",
+	[BPF_PROG_TYPE_SK_LOOKUP]		= "sk_lookup",
 };
 
 const size_t prog_type_name_size = ARRAY_SIZE(prog_type_name);
@@ -1905,7 +1906,7 @@ static int do_help(int argc, char **argv)
 		"                 cgroup/getsockname4 | cgroup/getsockname6 | cgroup/sendmsg4 |\n"
 		"                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
 		"                 cgroup/getsockopt | cgroup/setsockopt |\n"
-		"                 struct_ops | fentry | fexit | freplace }\n"
+		"                 struct_ops | fentry | fexit | freplace | sk_lookup }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
-- 
2.25.4

