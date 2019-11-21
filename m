Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E83105642
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKUP7B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 10:59:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726279AbfKUP7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:59:01 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-KRMKHbf9Mqu1PXVVnVspzQ-1; Thu, 21 Nov 2019 10:58:57 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 016031801CEF;
        Thu, 21 Nov 2019 15:58:56 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44E6F60F8B;
        Thu, 21 Nov 2019 15:58:53 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next] audit: Move audit_log_task declaration under CONFIG_AUDITSYSCALL
Date:   Thu, 21 Nov 2019 16:58:53 +0100
Message-Id: <20191121155853.3750-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: KRMKHbf9Mqu1PXVVnVspzQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 0-DAY found that audit_log_task is not declared under
CONFIG_AUDITSYSCALL which causes compilation error when
it is not defined:

    kernel/bpf/syscall.o: In function `bpf_audit_prog.isra.30':
 >> syscall.c:(.text+0x860): undefined reference to `audit_log_task'

Adding the audit_log_task declaration and stub within
CONFIG_AUDITSYSCALL ifdef.

Fixes: 91e6015b082b ("bpf: Emit audit messages upon successful prog load and unload")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/audit.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index edd006f4597d..18925d924c73 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -159,7 +159,6 @@ extern void		    audit_log_key(struct audit_buffer *ab,
 extern void		    audit_log_link_denied(const char *operation);
 extern void		    audit_log_lost(const char *message);
 
-extern void audit_log_task(struct audit_buffer *ab);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
 
@@ -220,8 +219,6 @@ static inline void audit_log_key(struct audit_buffer *ab, char *key)
 { }
 static inline void audit_log_link_denied(const char *string)
 { }
-static inline void audit_log_task(struct audit_buffer *ab)
-{ }
 static inline int audit_log_task_context(struct audit_buffer *ab)
 {
 	return 0;
@@ -361,6 +358,8 @@ static inline void audit_ptrace(struct task_struct *t)
 		__audit_ptrace(t);
 }
 
+extern void audit_log_task(struct audit_buffer *ab);
+
 				/* Private API (for audit.c only) */
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode);
@@ -648,6 +647,9 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 
 static inline void audit_ptrace(struct task_struct *t)
 { }
+
+static inline void audit_log_task(struct audit_buffer *ab)
+{ }
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
-- 
2.23.0

