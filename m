Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5C18C58A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCTDAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:00:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41577 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCTDAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:00:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so1898696plr.8;
        Thu, 19 Mar 2020 20:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gxG63zAIWgKTBOzHey2DE/duHVniOWkY6U4i26i98aw=;
        b=kpCH9LKrGaaiPmxORj8fBNKI8yqyzvb5aT65crNDKkfH0n2KJs8Aw+8z2lgPEuXN4e
         sxfYSe66E8q7uBa4SKdhr+IrXOOtLws+f8ZCoU2sV3sHwU0TkxBuAyD4qpoGw1phwvOn
         DzABBTRWOJomb0lhh7Xrka7woxbA36GHOzLFwNs3Vc2zX9gshbz1deuycF91wJ8YH/69
         Rjt7rVkNUhGRRQOMmi6npUfpek23wzY8MtXHeOyMAIbijP4o32evxvPeJYJffpDRjIuA
         9eB3LYuicMm1bY05vGCyIqkHCWJ4KVAy5tncp1B6ftKY4BIOVdcd51koVKQOWMRZMaVp
         cATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gxG63zAIWgKTBOzHey2DE/duHVniOWkY6U4i26i98aw=;
        b=dzjghrSPwOT7743d5AmMQikoX8/0Qt4jXgVxR5d2xLksTcWYJQ0xoACAS0uiPg2lDk
         eyrRxMr5g4S4jQ71J/T1WDVWK7srHjZHI0fmSXzWPm66whT4UCAjuD7GZ0xHy66yog6F
         DC8W0YD3iYwRkODfPNFheG4NsI1zocm/riYasl7azVAr9SGbCurcQUZvoCtj/SZRvo6K
         Jge2SuX8ql7OZqcSQ0pYXRvUFWycyydzDC78uO3ZO6mKPT8nxPPFhCqYdQ/JRz3wn7JC
         JXzgwR+4b36QDlgliTVuN139FZpxMQc0pAbjMeV/vp4up9wIDiC6mOZgRJ6f7eA3GS2T
         dYeg==
X-Gm-Message-State: ANhLgQ0qVZMTdQTWfMH9IVasoexbrqnw4HPPajweoojWWvNEcD3hnU/q
        rU2tIEs1x5m8ceihHMFjY+4cvbH/
X-Google-Smtp-Source: ADFU+vvQMiSD4kmAPMzMtXnU0/i5RXxIHIPkQNLxnQbasYOi9U2EHYOh/MEm2uCaf5e8BGZZcARL1g==
X-Received: by 2002:a17:90a:33d1:: with SMTP id n75mr6898323pjb.167.1584673227305;
        Thu, 19 Mar 2020 20:00:27 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id w127sm3680794pfb.70.2020.03.19.20.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 20:00:26 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH] iptables: open eBPF programs in read only mode
Date:   Thu, 19 Mar 2020 20:00:15 -0700
Message-Id: <20200320030015.195806-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
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
 extensions/libxt_bpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
index 92958247..bf46505c 100644
--- a/extensions/libxt_bpf.c
+++ b/extensions/libxt_bpf.c
@@ -61,12 +61,13 @@ static const struct xt_option_entry bpf_opts_v1[] = {
 	XTOPT_TABLEEND,
 };
 
-static int bpf_obj_get(const char *filepath)
+static int bpf_obj_get_readonly(const char *filepath)
 {
 #if defined HAVE_LINUX_BPF_H && defined __NR_bpf && defined BPF_FS_MAGIC
 	union bpf_attr attr;
 
 	memset(&attr, 0, sizeof(attr));
+	attr.file_flags = BPF_F_RDONLY;
 	attr.pathname = (__u64) filepath;
 
 	return syscall(__NR_bpf, BPF_OBJ_GET, &attr, sizeof(attr));
@@ -125,7 +126,7 @@ static void bpf_parse_string(struct sock_filter *pc, __u16 *lenp, __u16 len_max,
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

