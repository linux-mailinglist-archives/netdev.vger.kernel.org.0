Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F20D3D992B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhG1W7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhG1W7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:59:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680DDC061757;
        Wed, 28 Jul 2021 15:59:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15-20020a05600c19cfb02902501bdb23cdso5512608wmq.0;
        Wed, 28 Jul 2021 15:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k39DDalMzTShpUS7xTfsnHh2DrwwNvLFQeGw20Ks4sU=;
        b=bMX3AHpR29KHfRWNM21RUKVBI9g88zD7R80s3ktuIHY5+NXXbLd4SBFF319thVdGmJ
         Y4R9zHTqvm4zLogiMUdxqr+zk6IIl2nW73UyA4tuk/cGSUuDXSa/ba6AZAHUrp7uHFzf
         EXbS5x6Ja1Z1T6D61GhxHhQAsqo29FZ8c6OkxPshDdpYAKd0Xb81nkh1tjpp7BtQC//g
         DmL/TNurbK1Psg5riMfbn/5ysHbyaQ+Qx/ept89NQxmhXQPzYymy7FOnDluzrHFfDNI/
         iQLwjJj8AtIqQbqhBvv+Wjhms6YWt6rvSYpAElUjHo1hapZ8r2dY8riijesbi3fJQ+YG
         lNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k39DDalMzTShpUS7xTfsnHh2DrwwNvLFQeGw20Ks4sU=;
        b=ltv0dzjjJLy3poE4KIC6sDh6THSlOMp6G9Jvfkyda5yDakeCAPtTzL5Tv1mR3X2+pZ
         KAT/Tgidw85UWMJ2oENVv2oFwM66vXD8wf+k2p+QX1PWbZTFK5sv5Ay2htVjtkILjyEP
         io4n9A4OfhZjsdEN/MUSXBCNjC5avGQS/uCthjrz7fc08LP1HVIyNQ9K3zBmMhyjz07A
         vm5uuv0teAnEJ303gE79WalwVqRJ3Lp/u9MceO8XuwT4hNgW9cmkJr7DXQSRd2iPoeOZ
         v28dcsvJJiZ4ZORklE9KT8qb48EZNdDhD3j4XGjmiPyFUxTJxE3hdKQ7S+Gy/RmUCIuy
         hwtQ==
X-Gm-Message-State: AOAM533BZCKV9pRgPFLL1THayQxbrPRE7k38S4e2btN1k1TL0HI8uAAL
        2Zp2nIvc07qAwOJ4F0LLML8=
X-Google-Smtp-Source: ABdhPJyGtnZaI0lopAsxl0tTyhk+yqqNERVD1Zpj353mgyTZY/7WYWlsVd/FttUfdovBhRJPEQ2KuQ==
X-Received: by 2002:a05:600c:1ca3:: with SMTP id k35mr11268958wms.174.1627513178039;
        Wed, 28 Jul 2021 15:59:38 -0700 (PDT)
Received: from rgo-tower.fritz.box ([2a02:8109:b5bf:a504:bde4:7833:8c39:986c])
        by smtp.gmail.com with ESMTPSA id a8sm1326903wmj.8.2021.07.28.15.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 15:59:37 -0700 (PDT)
From:   "=?UTF-8?q?Robin=20G=C3=B6gge?=" <r.goegge@googlemail.com>
X-Google-Original-From: =?UTF-8?q?Robin=20G=C3=B6gge?= <r.goegge@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?q?Robin=20G=C3=B6gge?= <r.goegge@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH RESEND bpf] libbpf: fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT
Date:   Thu, 29 Jul 2021 00:58:25 +0200
Message-Id: <20210728225825.2357586-1-r.goegge@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the probe for BPF_PROG_TYPE_CGROUP_SOCKOPT,
so the probe reports accurate results when used by e.g.
bpftool.

Fixes: 4cdbfb59c44a ("libbpf: support sockopt hooks")

Signed-off-by: Robin Gögge <r.goegge@gmail.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/libbpf_probes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index ecaae2927ab8..cd8c703dde71 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -75,6 +75,9 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		xattr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
 		break;
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+		xattr.expected_attach_type = BPF_CGROUP_GETSOCKOPT;
+		break;
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		xattr.expected_attach_type = BPF_SK_LOOKUP;
 		break;
@@ -104,7 +107,6 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_SK_REUSEPORT:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
-	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_TRACING:
 	case BPF_PROG_TYPE_STRUCT_OPS:
 	case BPF_PROG_TYPE_EXT:
-- 
2.25.1

