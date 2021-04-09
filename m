Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50C1359501
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 07:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhDIFwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 01:52:38 -0400
Received: from m12-16.163.com ([220.181.12.16]:49472 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhDIFwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 01:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=O0Fw6
        C8nkVcsEdj5tqNF1VdUgPPuLHJN/DPaM3S9r6A=; b=C5rCZ+exjQYqIMxJXI9KL
        MMEvRNe3NdGIFMN8nu0Pq/y4kOzd6nfqEjyaCmCFXPKm/1CBKePvvmt4c/ljzXA2
        pyo6exW/U0hB9/dN3zbC4a3BeQo8zXmYDAeBxXWitS07Xdy/3EyrW0AsllYsiCAK
        ry5p2h8x6xlXsbirYYbNIo=
Received: from localhost.localdomain (unknown [183.9.194.37])
        by smtp12 (Coremail) with SMTP id EMCowABnYDjF6m9grpXkkg--.11493S2;
        Fri, 09 Apr 2021 13:48:56 +0800 (CST)
From:   =?UTF-8?q?=C2=A0Zhongjun=20Tan?= <hbut_tan@163.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, kpsingh@google.com, dhowells@redhat.com,
        christian.brauner@ubuntu.com, zohar@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Zhongjun Tan <tanzhongjun@yulong.com>
Subject: [PATCH 2/2] selinux:Delete selinux_xfrm_policy_lookup() useless argument
Date:   Fri,  9 Apr 2021 13:48:41 +0800
Message-Id: <20210409054841.320-1-hbut_tan@163.com>
X-Mailer: git-send-email 2.30.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowABnYDjF6m9grpXkkg--.11493S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFWrWr43GrW7CrWkCrW5trb_yoW7Wr15pF
        4DKFyUKr4UXa4UuFn7JFnruFnIg3yYka9rJrWkCw1YyasrJr1rWws5JryakryFyrWUJFyI
        9w13CrZ5Gw45trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jTFALUUUUU=
X-Originating-IP: [183.9.194.37]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/xtbBqAhvxl75bagm0wAAse
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongjun Tan <tanzhongjun@yulong.com>

seliunx_xfrm_policy_lookup() is hooks of security_xfrm_policy_lookup().
The dir argument is uselss in security_xfrm_policy_lookup(). So
remove the dir argument from selinux_xfrm_policy_lookup() and
security_xfrm_policy_lookup().

Signed-off-by: Zhongjun Tan <tanzhongjun@yulong.com>
---
 include/linux/lsm_hook_defs.h   | 3 +--
 include/linux/security.h        | 4 ++--
 net/xfrm/xfrm_policy.c          | 6 ++----
 security/security.c             | 4 ++--
 security/selinux/include/xfrm.h | 2 +-
 security/selinux/xfrm.c         | 2 +-
 6 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 04c0179..2adeea4 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -358,8 +358,7 @@
 	 struct xfrm_sec_ctx *polsec, u32 secid)
 LSM_HOOK(void, LSM_RET_VOID, xfrm_state_free_security, struct xfrm_state *x)
 LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
-LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid,
-	 u8 dir)
+LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid)
 LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
 	 struct xfrm_policy *xp, const struct flowi_common *flic)
 LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,
diff --git a/include/linux/security.h b/include/linux/security.h
index 06f7c50..24eda04 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1681,7 +1681,7 @@ int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
 				      struct xfrm_sec_ctx *polsec, u32 secid);
 int security_xfrm_state_delete(struct xfrm_state *x);
 void security_xfrm_state_free(struct xfrm_state *x);
-int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
+int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid);
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
 				       const struct flowi_common *flic);
@@ -1732,7 +1732,7 @@ static inline int security_xfrm_state_delete(struct xfrm_state *x)
 	return 0;
 }
 
-static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
 {
 	return 0;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 156347f..d5d934e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1902,8 +1902,7 @@ static int xfrm_policy_match(const struct xfrm_policy *pol,
 
 	match = xfrm_selector_match(sel, fl, family);
 	if (match)
-		ret = security_xfrm_policy_lookup(pol->security, fl->flowi_secid,
-						  dir);
+		ret = security_xfrm_policy_lookup(pol->security, fl->flowi_secid);
 	return ret;
 }
 
@@ -2181,8 +2180,7 @@ static struct xfrm_policy *xfrm_sk_policy_lookup(const struct sock *sk, int dir,
 				goto out;
 			}
 			err = security_xfrm_policy_lookup(pol->security,
-						      fl->flowi_secid,
-						      dir);
+						      fl->flowi_secid);
 			if (!err) {
 				if (!xfrm_pol_hold_rcu(pol))
 					goto again;
diff --git a/security/security.c b/security/security.c
index b38155b..0c1c979 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2466,9 +2466,9 @@ void security_xfrm_state_free(struct xfrm_state *x)
 	call_void_hook(xfrm_state_free_security, x);
 }
 
-int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
 {
-	return call_int_hook(xfrm_policy_lookup, 0, ctx, fl_secid, dir);
+	return call_int_hook(xfrm_policy_lookup, 0, ctx, fl_secid);
 }
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 0a6f34a..7415940 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -23,7 +23,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 				     struct xfrm_sec_ctx *polsec, u32 secid);
 void selinux_xfrm_state_free(struct xfrm_state *x);
 int selinux_xfrm_state_delete(struct xfrm_state *x);
-int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
+int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid);
 int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      struct xfrm_policy *xp,
 				      const struct flowi_common *flic);
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 634f3db..be83e5c 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -150,7 +150,7 @@ static int selinux_xfrm_delete(struct xfrm_sec_ctx *ctx)
  * LSM hook implementation that authorizes that a flow can use a xfrm policy
  * rule.
  */
-int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
 {
 	int rc;
 
-- 
1.9.1


