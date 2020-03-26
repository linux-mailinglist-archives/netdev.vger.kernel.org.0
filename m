Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506A6194148
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgCZO2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:28:17 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37303 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbgCZO2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:28:17 -0400
Received: by mail-pj1-f66.google.com with SMTP id o12so2473407pjs.2;
        Thu, 26 Mar 2020 07:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hnqEuIgL5QE/YWaTNknecm17JEF809CxZ0Nxmz2DZwk=;
        b=BBufUMaHut3q3W2RS1KeFJYqBrMPTIUj8xaZUU4ZQpVrB3GFqpKYlPXDLZF6hgJi3m
         aGszVGXY6fL+ntCVnpqL43pwIEjkjHIDgMi+2+ooJwVjodluXYFJr06FULKygI4UG19l
         q+waP0flM4v3g4f0sXnBHkMFd+CjcfXoQZruSamUEsR3Bd13BNxfNSQFsdAHp64GnT6X
         AyS2G2g9L3TqveE8yuiKR1MYfhF5mjzjh6+VcC3qwKDF93D2hO2DuMyyrn2Q/UhiVbF3
         AQuIeTL120824lZZNwjPTD28J0H7ym0Sn7bRIsP0f6HooY+BdZ4ik0Ay7kORSqZjNcO9
         bQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hnqEuIgL5QE/YWaTNknecm17JEF809CxZ0Nxmz2DZwk=;
        b=OcMJSG0mdLBebi3aD584+7uH/0D+vkpgU0ktqZOUFgNqrkacvl8MaS055+GqkMUbrc
         OF9EC8tB69s1pvZUGeGKafstXBXvsZTvWAkW7FAJSev0bkaAyX++npKc57q98WgNN9w9
         BFp29vkJ7K7FaMHFhdCmOC6ZLjozLQr29uJJyi4Qi9EjZQfdPu46Z/OXGGQH/b2wMI9J
         F7JNHJVx0rNhQ9y06OX2jsKVfnWhbesXWpt2cfn9xsOd9rCjYj0o9lkHjZTMzjBTolN+
         mDx7EjkK6oIGFZERK3oiCrOGeqfSRAQkB+Mnx54C158Ldpelsf/GARsIoPc+sNfFMELM
         HVWA==
X-Gm-Message-State: ANhLgQ0vV30Dsx8/OzzaAWswOngphEBUaP6AJ0CpGSMHDvFBDwIkDoUB
        XGhtdP8ufxaI1An+LPhXZ1c=
X-Google-Smtp-Source: ADFU+vtHwGrjzDkKQvm76Xrla89vS2y1y5MXcN5XcJrmeVgothXtSmtlTExzmEIRhKYuupM1E5QPHQ==
X-Received: by 2002:a17:902:8c88:: with SMTP id t8mr8249487plo.176.1585232895708;
        Thu, 26 Mar 2020 07:28:15 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id j38sm1732732pgi.51.2020.03.26.07.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:28:14 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v2] iptables: open eBPF programs in read only mode
Date:   Thu, 26 Mar 2020 07:28:03 -0700
Message-Id: <20200326142803.239183-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <CAHo-OoxMNBTDZW_xqp1X3SGncM-twAySrdnc=ntS7_e2j0YEaA@mail.gmail.com>
References: <CAHo-OoxMNBTDZW_xqp1X3SGncM-twAySrdnc=ntS7_e2j0YEaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Adjust the mode eBPF programs are opened in so 0400 pinned bpf programs
work without requiring CAP_DAC_OVERRIDE.

This matches Linux 5.2's:
  commit e547ff3f803e779a3898f1f48447b29f43c54085
  Author: Chenbo Feng <fengc@google.com>
  Date:   Tue May 14 19:42:57 2019 -0700

    bpf: relax inode permission check for retrieving bpf program

    For iptable module to load a bpf program from a pinned location, it
    only retrieve a loaded program and cannot change the program content so
    requiring a write permission for it might not be necessary.
    Also when adding or removing an unrelated iptable rule, it might need to
    flush and reload the xt_bpf related rules as well and triggers the inode
    permission check. It might be better to remove the write premission
    check for the inode so we won't need to grant write access to all the
    processes that flush and restore iptables rules.

  kernel/bpf/inode.c:
  - int ret = inode_permission(inode, MAY_READ | MAY_WRITE);
  + int ret = inode_permission(inode, MAY_READ);

In practice, AFAICT, the xt_bpf match .fd field isn't even used by new
kernels, but I believe it might be needed for compatibility with old ones
(though I'm pretty sure table modifications on them will outright fail).

Test: builds, passes Android test suite (albeit on an older iptables base),
  git grep bpf_obj_get - finds no other users
Cc: Chenbo Feng <fengc@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libxt_bpf.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
index 92958247..44cdd5cb 100644
--- a/extensions/libxt_bpf.c
+++ b/extensions/libxt_bpf.c
@@ -61,11 +61,22 @@ static const struct xt_option_entry bpf_opts_v1[] = {
 	XTOPT_TABLEEND,
 };
 
-static int bpf_obj_get(const char *filepath)
+static int bpf_obj_get_readonly(const char *filepath)
 {
 #if defined HAVE_LINUX_BPF_H && defined __NR_bpf && defined BPF_FS_MAGIC
 	union bpf_attr attr;
+	// file_flags && BPF_F_RDONLY requires Linux 4.15+ uapi kernel headers
+#ifdef BPF_F_RDONLY
+	int fd;
 
+	memset(&attr, 0, sizeof(attr));
+	attr.pathname = (__u64) filepath;
+	attr.file_flags = BPF_F_RDONLY;
+	fd = syscall(__NR_bpf, BPF_OBJ_GET, &attr, sizeof(attr));
+	if (fd >= 0) return fd;
+
+	// on any error fallback to default R/W access for pre-4.15-rc1 kernels
+#endif
 	memset(&attr, 0, sizeof(attr));
 	attr.pathname = (__u64) filepath;
 
@@ -125,7 +136,7 @@ static void bpf_parse_string(struct sock_filter *pc, __u16 *lenp, __u16 len_max,
 static void bpf_parse_obj_pinned(struct xt_bpf_info_v1 *bi,
 				 const char *filepath)
 {
-	bi->fd = bpf_obj_get(filepath);
+	bi->fd = bpf_obj_get_readonly(filepath);
 	if (bi->fd < 0)
 		xtables_error(PARAMETER_PROBLEM,
 			      "bpf: failed to get bpf object");
-- 
2.25.1.696.g5e7596f4ac-goog

