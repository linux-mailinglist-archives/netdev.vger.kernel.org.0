Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D2B321B99
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 16:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhBVPfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 10:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhBVPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 10:35:30 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96265C061786;
        Mon, 22 Feb 2021 07:34:46 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id k13so1805829otn.13;
        Mon, 22 Feb 2021 07:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DZndD8IzowW9JWMwsfjieWxvmryF7Em96dlZzgrwefo=;
        b=qMdtZNvPKUdnvfhjOHnLQkABZVQHGkculT25lDjTO7m+3f1dTfpbBKVjPoeYqa2mKy
         UbKHakxQLz3tbI663q9t8eIv2/bqmEBab5+lIbY9LHbNgZV6jJsdKfX2A8i0Wp6lD5oh
         P49m3LC+FZoZN/nXHRMfXV6KfrcMtPRvxSjeqt/4jH5fU04OkgLYweEK0yaD1r+3M8/O
         7PUEHZM9WYUKUT1If4/YWVW5FIoUJnlxdoWPywguKm/diEc/Fad+9mO/U3tX2iKytufy
         7fNJSpbDCttrUEZZO4rNT1NfrVNCjElj+uMUHyg+Dd6fr3Oqgjd1uxtttPO3LTYDOgdh
         oENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DZndD8IzowW9JWMwsfjieWxvmryF7Em96dlZzgrwefo=;
        b=SjBHZXMz4iuCxVMBTvKeskQW/+2A/fmE2OrkJSz/wWk6Ks8TRsmdDAeDTbPAaO7qNg
         y9OuhmVsJdcNtq8wzspft/uwmZr+X85oSeu+DMTQVRmEWm1eCPOAEIPjjBSRzMSREbqC
         aUwvEVowzUp26paiW09gEaN535AiQ3BdNqHLk92EHrHd7DEX45tzACqlYTM4Ea+9SmMO
         IC6GZmY3houeqSx9fXwFAeVEzP1ErtUsznKcO/WQ2CSa1m+b/wJqZAUU0prxfjWdgdMM
         THzU8at2TV8R0jyBeKHvaAsemFXOvX685ZtZWSd+inGE5lcl+I1ZxhbuIhwsZ/yEzhVm
         Llhw==
X-Gm-Message-State: AOAM531uIlKDqbnkdWRlZDAQzSgiPMfO/7tztFrIH73Yqqz05yBfAce4
        DuayWpvLQNKQJB2l4fjIGAI=
X-Google-Smtp-Source: ABdhPJw6IlSmsqUv8EymuxuuHz3p7ItPq1LNdePb8fVINiXJOzDGzh29yqBkeCUmEMDVmFQEcYGrNA==
X-Received: by 2002:a9d:6a8c:: with SMTP id l12mr17349364otq.343.1614008086006;
        Mon, 22 Feb 2021 07:34:46 -0800 (PST)
Received: from localhost.localdomain (162-198-41-83.lightspeed.wepbfl.sbcglobal.net. [162.198.41.83])
        by smtp.gmail.com with ESMTPSA id l25sm816785oic.49.2021.02.22.07.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 07:34:45 -0800 (PST)
From:   grantseltzer <grantseltzer@gmail.com>
To:     andrii@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     irogers@google.com, yhs@fb.com, tklauser@distanz.ch,
        netdev@vger.kernel.org, mrostecki@opensuse.org, ast@kernel.org,
        quentin@isovalent.com, bpf@vger.kernel.org,
        grantseltzer <grantseltzer@gmail.com>
Subject: [PATCH v3 bpf-next] Add CONFIG_DEBUG_INFO_BTF check to bpftool feature command
Date:   Sat, 20 Feb 2021 17:13:07 +0000
Message-Id: <20210220171307.128382-1-grantseltzer@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the CONFIG_DEBUG_INFO_BTF kernel compile option to output of
the bpftool feature command. This is relevant for developers that want
to use libbpf to account for data structure definition differences
between kernels.

Signed-off-by: grantseltzer <grantseltzer@gmail.com>
---
 tools/bpf/bpftool/feature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 359960a8f..b90cc6832 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -336,6 +336,8 @@ static void probe_kernel_image_config(const char *define_prefix)
 		{ "CONFIG_BPF_JIT", },
 		/* Avoid compiling eBPF interpreter (use JIT only) */
 		{ "CONFIG_BPF_JIT_ALWAYS_ON", },
+		/* Kernel BTF debug information available */
+		{ "CONFIG_DEBUG_INFO_BTF", },
 
 		/* cgroups */
 		{ "CONFIG_CGROUPS", },
-- 
2.29.2

