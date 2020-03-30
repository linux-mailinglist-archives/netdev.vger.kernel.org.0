Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30683197AF4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 13:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgC3LiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 07:38:11 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:56286 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729494AbgC3LiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 07:38:11 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 43EC02E0ACC;
        Mon, 30 Mar 2020 14:38:08 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id BnTteJOtrH-c7uWUvWZ;
        Mon, 30 Mar 2020 14:38:08 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585568288; bh=sQAkZ4Uo115HMFbpbbPUykkBoIYJtF4Ly0qbX/dsoqg=;
        h=Message-ID:Subject:To:From:Date:Cc;
        b=vwnJWlIx8fauBwA0V0kzxOmVJaK6lAC/xJsfwHOrfCvZrGKxJ4iD/avVaQAR4mM0j
         M+AvIRWM2nCOS73R2h2W02E9PHUFMzDm5QxglkGegI0asVepO3tjHwsU/d/N+RpjOC
         eAPREGiKuE+iH1wNjlle0CWlQRdhFUgNyCH62P3s=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:8707::1:6])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0VSYOpt6G5-c7X4qbqM;
        Mon, 30 Mar 2020 14:38:07 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Mon, 30 Mar 2020 14:38:03 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru
Subject: [PATCH v2 net] inet_diag: add cgroup id attribute
Message-ID: <20200330113803.GA19490@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds cgroup v2 id to common inet diag message attributes.
This allows investigate sockets on per cgroup basis when
net_cls/net_prio cgroup not used.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 include/linux/inet_diag.h      | 6 +++++-
 include/uapi/linux/inet_diag.h | 1 +
 net/ipv4/inet_diag.c           | 7 +++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index c91cf2d..8bc5e7d 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -66,7 +66,11 @@ static inline size_t inet_diag_msg_attrs_size(void)
 		+ nla_total_size(1)  /* INET_DIAG_SKV6ONLY */
 #endif
 		+ nla_total_size(4)  /* INET_DIAG_MARK */
-		+ nla_total_size(4); /* INET_DIAG_CLASS_ID */
+		+ nla_total_size(4)  /* INET_DIAG_CLASS_ID */
+#ifdef CONFIG_SOCK_CGROUP_DATA
+		+ nla_total_size(8)  /* INET_DIAG_CGROUP_ID */
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
index 8c83775..ba0bb14 100644
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

