Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33301C00D3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgD3PwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:52:02 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:37390 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgD3PwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 11:52:01 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 6C9922E09A3;
        Thu, 30 Apr 2020 18:51:58 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 6BkFZc3MFu-ptAurvVc;
        Thu, 30 Apr 2020 18:51:58 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588261918; bh=8Rd/fXqnFMTym0mjU2YYZJ6hLiguyxD0waGMMtU0Whk=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=HOaxSBVRgaR1nmy8UuOMQHzi5CWrOTTrNQQBMhXNFCH6BeP/F1B4zHdX/jmAp+eQe
         6/m3D28S+K/P7wBA2EmdKzWKSyvBO63yx43vgYtsoFIp4pMBIjTm/p6MkLQ1Ihbl7m
         dCqT3RCfokEqUIPzsG5EpwOyYeUTGttzSPcMWx5U=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.215.84])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GL4sw8JMR4-ptYGEs9I;
        Thu, 30 Apr 2020 18:51:55 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, tj@kernel.org, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 1/2] inet_diag: add cgroup id attribute
Date:   Thu, 30 Apr 2020 18:51:14 +0300
Message-Id: <20200430155115.83306-2-zeil@yandex-team.ru>
In-Reply-To: <20200430155115.83306-1-zeil@yandex-team.ru>
References: <20200430155115.83306-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Acked-By: Tejun Heo <tj@kernel.org>
---
 include/linux/inet_diag.h      | 6 +++++-
 include/uapi/linux/inet_diag.h | 1 +
 net/ipv4/inet_diag.c           | 7 +++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index ce9ed1c..0ef2d80 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -71,7 +71,11 @@ static inline size_t inet_diag_msg_attrs_size(void)
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
index 57cc429..c9b1e55 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -157,6 +157,7 @@ enum {
 	INET_DIAG_MD5SIG,
 	INET_DIAG_ULP_INFO,
 	INET_DIAG_SK_BPF_STORAGES,
+	INET_DIAG_CGROUP_ID,
 	__INET_DIAG_MAX,
 };
 
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 5d50aad..9c4c315 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -162,6 +162,13 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
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

