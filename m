Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433612132E6
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgGCEcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgGCEcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 00:32:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A55C08C5C1;
        Thu,  2 Jul 2020 21:32:14 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so31211396iow.7;
        Thu, 02 Jul 2020 21:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ZrqaGeIV7JcQYbYQPx6QK/8ocSgakcVhj4omU7ByHzE=;
        b=TlyiPcoTjguDZ6RfPOkeLZTg0AXhK+9Q1s6Lc3e3zMSooG9WRBj+gKsr3VXC8KtAir
         hoO4aV9dhkdVo6YV581s8hng7uxD+bm6I3QeefGKkgmsLl0KlGq/I9Rzd1JqgGpwEVzH
         lokCJyjqaZxTyS8dxdGfa0ppzsqJHxU/MzEvcLmcrFlHX6tSmgN3S1762FLPForVEqGz
         wYO2AIQRkbmHe1VmskayaaOm4ZGz1PIe7kVpeL2Si1odOqDWBYuMzgYA8mKDilbYPI5x
         QwKtNcBoM3g+cpnuVNAsHeTghQcU6M7qriusVYQ+IP3x9yO5BwVtX0KGZ9w3uf3Q3djw
         U6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ZrqaGeIV7JcQYbYQPx6QK/8ocSgakcVhj4omU7ByHzE=;
        b=fs2PDW8G2IqnBz6IJGl4KZ8U/lZrdqyS73vFI2CGFAMg3Dl/I7QSKFUnk8Swu4//8K
         WrshOVahIZZvYnBuwHv8UDloo+dpyqDqpqDTtlTxnF+cDU+PZKLW+LZKtZD44OJPsFWm
         U3AULAtkElFendwzfatBP+wkxG0atprhmE7obGtGmizGb+aDg5hP9kGKGTZH+G4h3eVJ
         UxTktD70g0438Mo9qDWBhPeSYam6wHgL8Q8boyUKd4ANuE0GumX6jWfgLRhA/9XGizmw
         FYge0RqTfiaW0xvA9Un1it27ANaGiHbVaYrSk80bZdmhM4M8kjbOuKDjBTstFGYCn+ul
         bGEw==
X-Gm-Message-State: AOAM532tNK4lW9je0cmjzdLaz1CXONKS8g9KYMnSwvgmFPWBdV2pW5PH
        8YnTOdmmfSa9/Kf44NASlHY=
X-Google-Smtp-Source: ABdhPJzoyB0aa8z+8JinyotD1ciZshsW1GYEJvA5wUyWnRyGkR7j0Eib5tq8GVRKLwDiywJFRHxsqQ==
X-Received: by 2002:a05:6638:223:: with SMTP id f3mr37580442jaq.144.1593750734090;
        Thu, 02 Jul 2020 21:32:14 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w16sm5712219iom.27.2020.07.02.21.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 21:32:13 -0700 (PDT)
Subject: [bpf-next PATCH v2] bpf: fix bpftool without skeleton code enabled
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andriin@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 02 Jul 2020 21:31:59 -0700
Message-ID: <159375071997.14984.17404504293832961401.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix segfault from bpftool by adding emit_obj_refs_plain when skeleton
code is disabled.

Tested by deleting BUILD_BPF_SKELS in Makefile. We found this doing
backports for Cilium when a testing image pulled in latest bpf-next
bpftool, but kept using an older clang-7.

# ./bpftool prog show
Error: bpftool built without PID iterator support
3: cgroup_skb  tag 7be49e3934a125ba  gpl
        loaded_at 2020-07-01T08:01:29-0700  uid 0
Segmentation fault

Reported-by: Joe Stringer <joe@wand.net.nz>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/pids.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 2709be4de2b1..7d5416667c85 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -19,6 +19,7 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
 	return -ENOTSUP;
 }
 void delete_obj_refs_table(struct obj_refs_table *table) {}
+void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix) {}
 
 #else /* BPFTOOL_WITHOUT_SKELETONS */
 

