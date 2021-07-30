Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5083DC085
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhG3V4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbhG3VzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:55:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B8C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:54:57 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so7258726wms.0
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9N1tW89TqlIiC61bb1N01SspSqTHG3/Fdl/9Iy0V4T0=;
        b=FVd48kfase+Gddweu0XlimUF7dHn/CMy9SbtGb2VbnDrq1aHpb4LkYvENpQ+tXwC7P
         TsC1MGvNTTTEv3fj/Ue60+ZPz1QYXF1ipOscnLhMbXiVyHeWMDY9RyxFippqJfmYfjhv
         +oqM3O9ZnlQfYtB1p5RPP9jWSNrrRP27vqTuPFbdektxnkVkh2G17cQKn5FGCssefU91
         geiWQWNEfHwLg4g2mmw4fwRVa+551Ls+g6JC2DvmPSaVQlD+FIjJR7veEk38ZcmRm3O+
         5N4/e4pL4Jkooa56UdvFKngzH44BeBYJhLxDfmIKhwXOf+0gvRTthhuPaMsKwtULLVdk
         KSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9N1tW89TqlIiC61bb1N01SspSqTHG3/Fdl/9Iy0V4T0=;
        b=Jio9WtH+9FFK9iSH+EBdVmljasSWMxiJmOUFuWVV2cqdssZ8WHOnikvvCIIrSQcmjs
         1Dy5fGPs37ZNdYevYzZ57GXlNt6kxiq6mHPDlW7k+UGwMyFrMa7RYIdT61Be88RXQvGU
         1pulWmNcCZRN+w+aoFIMInx2fYKx1rhx9NdFMfVj40h2MjV9sZd6Gc5dgwDZ6wkcDYkM
         PmXihqUVOUfyzbWcFgwV1TSyqLknZuSwdiRYaQWN/ulpVSX7u/VNJvuJRQnaLakT5BWo
         ghFFu3zPtvBDBztBmDnyG8831svYu8/iJr0fY+rQZc/UQXgmnArQOaehXSOPIL7n58co
         weOA==
X-Gm-Message-State: AOAM5301YmGDgTTnvAThQKcF8rlBYvjy0e+lKIKtkAs9zcoaupD9K8cQ
        Klpo3DPtTCOc5SIspEUwh2aJvA==
X-Google-Smtp-Source: ABdhPJxiE+mK5LVW0c/TldRmB0dREOErd5noTOYxcs0lQ3PFeswMrtVX5gitEWiu1Yd/mebBLYKDHg==
X-Received: by 2002:a05:600c:198c:: with SMTP id t12mr5110727wmq.106.1627682096045;
        Fri, 30 Jul 2021 14:54:56 -0700 (PDT)
Received: from localhost.localdomain ([149.86.78.245])
        by smtp.gmail.com with ESMTPSA id v15sm3210871wmj.39.2021.07.30.14.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 14:54:55 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 3/7] tools: bpftool: complete and synchronise attach or map types
Date:   Fri, 30 Jul 2021 22:54:31 +0100
Message-Id: <20210730215435.7095-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730215435.7095-1-quentin@isovalent.com>
References: <20210730215435.7095-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bpftool's list of attach type names to tell it about the latest
attach types, or the "ringbuf" map. Also update the documentation, help
messages, and bash completion when relevant.

These missing items were reported by the newly added Python script used
to help maintain consistency in bpftool.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool-prog.rst | 2 +-
 tools/bpf/bpftool/bash-completion/bpftool        | 5 +++--
 tools/bpf/bpftool/common.c                       | 6 ++++++
 tools/bpf/bpftool/prog.c                         | 4 ++--
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index fe1b38e7e887..abf5f4cd7d3e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -48,7 +48,7 @@ PROG COMMANDS
 |		**struct_ops** | **fentry** | **fexit** | **freplace** | **sk_lookup**
 |	}
 |       *ATTACH_TYPE* := {
-|		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
+|		**msg_verdict** | **skb_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
 |	}
 |	*METRICs* := {
 |		**cycles** | **instructions** | **l1d_loads** | **llc_misses**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index a7c947e00345..1521a725f07c 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -405,7 +405,8 @@ _bpftool()
                             ;;
                         5)
                             local BPFTOOL_PROG_ATTACH_TYPES='msg_verdict \
-                                stream_verdict stream_parser flow_dissector'
+                                skb_verdict stream_verdict stream_parser \
+                                flow_dissector'
                             COMPREPLY=( $( compgen -W "$BPFTOOL_PROG_ATTACH_TYPES" -- "$cur" ) )
                             return 0
                             ;;
@@ -706,7 +707,7 @@ _bpftool()
                                 hash_of_maps devmap devmap_hash sockmap cpumap \
                                 xskmap sockhash cgroup_storage reuseport_sockarray \
                                 percpu_cgroup_storage queue stack sk_storage \
-                                struct_ops inode_storage task_storage'
+                                struct_ops inode_storage task_storage ringbuf'
                             COMPREPLY=( $( compgen -W "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
                             return 0
                             ;;
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 1828bba19020..c5e57cce887a 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -67,6 +67,12 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_MODIFY_RETURN]		= "mod_ret",
 	[BPF_LSM_MAC]			= "lsm_mac",
 	[BPF_SK_LOOKUP]			= "sk_lookup",
+	[BPF_TRACE_ITER]		= "trace_iter",
+	[BPF_XDP_DEVMAP]		= "xdp_devmap",
+	[BPF_XDP_CPUMAP]		= "xdp_cpumap",
+	[BPF_XDP]			= "xdp",
+	[BPF_SK_REUSEPORT_SELECT]	= "sk_skb_reuseport_select",
+	[BPF_SK_REUSEPORT_SELECT_OR_MIGRATE]	= "sk_skb_reuseport_select_or_migrate",
 };
 
 void p_err(const char *fmt, ...)
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index b1996b8f1d42..d98cfc973a1d 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2256,8 +2256,8 @@ static int do_help(int argc, char **argv)
 		"                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
 		"                 cgroup/getsockopt | cgroup/setsockopt | cgroup/sock_release |\n"
 		"                 struct_ops | fentry | fexit | freplace | sk_lookup }\n"
-		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
-		"                        flow_dissector }\n"
+		"       ATTACH_TYPE := { msg_verdict | skb_verdict | stream_verdict |\n"
+		"                        stream_parser | flow_dissector }\n"
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses | itlb_misses | dtlb_misses }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-- 
2.30.2

