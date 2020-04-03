Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE8119D478
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 11:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390649AbgDCJ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 05:56:36 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:55240 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgDCJ4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 05:56:36 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 63E8D2E0B0E;
        Fri,  3 Apr 2020 12:56:32 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id E5QFmAImMn-uVNK4SJG;
        Fri, 03 Apr 2020 12:56:32 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585907792; bh=quoFiDMrc4n64AIBxbW1ayY5jdo/MDfLHVb25p4vCC0=;
        h=Message-ID:Subject:To:From:Date:Cc;
        b=qfW4f15gWBYhHThlb6i7AgwCc9v26b0hEDJ8cy40bXs5eVJKV6dpInZkz3DcGxcdp
         Ie2esvZimeok6tAjsZgmVd2DsR9t7SxHYvCAp65argc/j3dqJ8BUOkgjNnLkEk/zHR
         sTpRoYpL5qrjJVNEdfLcWhdcmkW88Lju8xzivL+0=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:7115::1:c])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ZJWyyT8QkH-uVW4dxLT;
        Fri, 03 Apr 2020 12:56:31 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Fri, 3 Apr 2020 12:56:27 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v3 net] inet_diag: add cgroup id attribute
Message-ID: <20200403095627.GA85072@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds cgroup v2 ID to common inet diag message attributes.
Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
cgroup ID) for newly created sockets.

Some notes about this ID:

1) gets initialized in socket() syscall
2) incoming socket gets ID from listening socket
   (not during accept() syscall)
3) not changed when process get moved to another cgroup
4) can point to deleted cgroup (refcounting)

v2:
  - use CONFIG_SOCK_CGROUP_DATA instead if CONFIG_CGROUPS

v3:
  - fix attr size by using nla_total_size_64bit() (Eric Dumazet)
  - more detailed commit message (Konstantin Khlebnikov)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 include/linux/inet_diag.h      | 6 +++++-
 include/uapi/linux/inet_diag.h | 1 +
 net/ipv4/inet_diag.c           | 7 +++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index c91cf2d..0696f86 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -66,7 +66,11 @@ static inline size_t inet_diag_msg_attrs_size(void)
 		+ nla_total_size(1)  /* INET_DIAG_SKV6ONLY */
 #endif
 		+ nla_total_size(4)  /* INET_DIAG_MARK */
-		+ nla_total_size(4); /* INET_DIAG_CLASS_ID */
+		+ nla_total_size(4)  /* INET_DIAG_CLASS_ID */
+#ifdef CONFIG_SOCK_CGROUP_DATA
+		+ nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_CGROUP_ID */
+#endif
+		;
 }
 int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 			     struct inet_diag_msg *r, int ext,
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index a1ff345..dc87ad6 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -154,6 +154,7 @@ enum {
 	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
 	INET_DIAG_MD5SIG,
 	INET_DIAG_ULP_INFO,
+	INET_DIAG_CGROUP_ID,
 	__INET_DIAG_MAX,
 };
 
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 8c83775..17e3c52 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -161,6 +161,13 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 			goto errout;
 	}
 
+#ifdef CONFIG_SOCK_CGROUP_DATA
+	if (nla_put_u64_64bit(skb, INET_DIAG_CGROUP_ID,
+			      cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data)),
+			      INET_DIAG_PAD))
+		goto errout;
+#endif
+
 	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	r->idiag_inode = sock_i_ino(sk);
 
-- 
2.7.4

