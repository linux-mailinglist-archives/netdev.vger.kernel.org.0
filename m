Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029DA199AE5
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbgCaQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:07:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33139 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgCaQHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:07:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so10547622pgo.0;
        Tue, 31 Mar 2020 09:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b1X+kWvTaoc1/8sKIH9Urvg+efjSevl6Sn9xX+k+tdk=;
        b=E7QP6+nEWaQ3piARVTGv7PrQ3KlmEtoVc+b+4iGu/u4TGouhnhdh2fRTlpC05P6KLf
         XzoLMuQuFyazLq0QkvzB9raa7zRAwG/07oTtiVyAI7N/sz5tE0fjflijVUn7AYm9JTrl
         hYR5t2Z0xpbccNY/FEuTZhhBDLY5794BTIB6/xn1Z6QbZsEjdKaoUPVfJq2v0XKRa5Lu
         vE26toe7X0qGplsHI+/LjDEQwo5Xya0zPxAuiS4I2rjs4X3YPmcIQ8gziJLfVqLgk++J
         cqLv3KL7+GxXzyTgowPgwQy2dx14TMeqLHJ4rj9auNpahVQMYBjrqaa9+L6wXGpx1kOK
         LGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b1X+kWvTaoc1/8sKIH9Urvg+efjSevl6Sn9xX+k+tdk=;
        b=pxba0ow81XxCgQIMwIITx8KmH86ojvakKFSx72HvMjvgxFkjiH4JOGwIsAF80vAQMA
         JgHebxw6f/aH6fmN1EZ5SGR+wMbjeTNsVGRMQTltPfV0bznuuYKkm9kNUgzTEY3Hiihy
         j/3OfJp3przgdWvCeNmAjUFcNYN0lTYO7KJ+4hl/5TQmO31eg1sJGqw6V1KwxJilTjrd
         W9H6GS6M7Qmq1hk9ccgpMF8zwLD2uALMK91mWsusVDVKJntFffh1RGPc0mD20Sk7CRxH
         RbCVd4pRY8+f0jpezXkYdN25OBwYoHoz8imZ4NBWd8s2hIeYCKJsfppQmQXxTnsdMwNf
         KhQg==
X-Gm-Message-State: AGi0PubKudS6thWZISpK+8oLDuVopEG1ey38rhqEO5JmZ09OAB5s+zco
        SNwyM2UJrMhrJS0/xxu+Z4s=
X-Google-Smtp-Source: APiQypJ/yTO4LiP72ogFNw4xPxdl9op8Gz7lBGkcJE/KhfT3rIhzZOPCqgd0mpZM/YN8hYlgbvbXWA==
X-Received: by 2002:a63:7159:: with SMTP id b25mr4722166pgn.72.1585670829465;
        Tue, 31 Mar 2020 09:07:09 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id t63sm11887819pgc.85.2020.03.31.09.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 09:07:08 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v3] iptables: open eBPF programs in read only mode
Date:   Tue, 31 Mar 2020 09:07:03 -0700
Message-Id: <20200331160703.56842-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
In-Reply-To: <20200320030015.195806-1-zenczykowski@gmail.com>
References: <20200320030015.195806-1-zenczykowski@gmail.com>
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
 extensions/libxt_bpf.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
index 92958247..4aea477a 100644
--- a/extensions/libxt_bpf.c
+++ b/extensions/libxt_bpf.c
@@ -61,14 +61,25 @@ static const struct xt_option_entry bpf_opts_v1[] = {
 	XTOPT_TABLEEND,
 };
 
-static int bpf_obj_get(const char *filepath)
+static int bpf_obj_get_readonly(const char *filepath)
 {
 #if defined HAVE_LINUX_BPF_H && defined __NR_bpf && defined BPF_FS_MAGIC
-	union bpf_attr attr;
-
-	memset(&attr, 0, sizeof(attr));
-	attr.pathname = (__u64) filepath;
-
+	// union bpf_attr includes this in an anonymous struct, but the
+	// file_flags field and the BPF_F_RDONLY constant are only present
+	// in Linux 4.15+ kernel headers (include/uapi/linux/bpf.h)
+	struct {   // this part of union bpf_attr is for BPF_OBJ_* commands
+		__aligned_u64	pathname;
+		__u32		bpf_fd;
+		__u32		file_flags;
+	} attr = {
+		.pathname = (__u64)filepath,
+		.file_flags = (1U << 3),   // BPF_F_RDONLY
+	};
+	int fd = syscall(__NR_bpf, BPF_OBJ_GET, &attr, sizeof(attr));
+	if (fd >= 0) return fd;
+
+	// on any error fallback to default R/W access for pre-4.15-rc1 kernels
+	attr.file_flags = 0;
 	return syscall(__NR_bpf, BPF_OBJ_GET, &attr, sizeof(attr));
 #else
 	xtables_error(OTHER_PROBLEM,
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
2.26.0.rc2.310.g2932bb562d-goog

