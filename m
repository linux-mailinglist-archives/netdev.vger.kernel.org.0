Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EF31C00D8
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgD3PwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:52:11 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:45242 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgD3PwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 11:52:11 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id CED192E151D;
        Thu, 30 Apr 2020 18:52:06 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id YnfjpBIhTs-q4bKPk5C;
        Thu, 30 Apr 2020 18:52:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588261926; bh=qevvM7tLYgQfMmFHJXtjadc10CdA9MGNJ0dLRlKyxKk=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=P7u87fgc8jONEl/XyAQ/0Ltp2aE46AKSrW9HF6rV/f7AkVRN6fRjJCfaU65mCcOjd
         R+HpnqeyyIsJra0B0YyBavK5qVkDuwiEFYcHPlcU+Iqtd2cYVZMsnkrwAYsDm7qmuq
         /ENBoN0R6lwOvBnACohgPND5UF9RzXX1P95eGosQ=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.215.84])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GL4sw8JMR4-q4YGNsm6;
        Thu, 30 Apr 2020 18:52:04 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, tj@kernel.org, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 2/2] inet_diag: add support for cgroup filter
Date:   Thu, 30 Apr 2020 18:51:15 +0300
Message-Id: <20200430155115.83306-3-zeil@yandex-team.ru>
In-Reply-To: <20200430155115.83306-1-zeil@yandex-team.ru>
References: <20200430155115.83306-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds ability to filter sockets based on cgroup v2 ID.
Such filter is helpful in ss utility for filtering sockets by
cgroup pathname.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 include/uapi/linux/inet_diag.h |  1 +
 net/ipv4/inet_diag.c           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index c9b1e55..e6f183e 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -96,6 +96,7 @@ enum {
 	INET_DIAG_BC_MARK_COND,
 	INET_DIAG_BC_S_EQ,
 	INET_DIAG_BC_D_EQ,
+	INET_DIAG_BC_CGROUP_COND,   /* u64 cgroup v2 ID */
 };
 
 struct inet_diag_hostcond {
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 9c4c315..0034092 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -43,6 +43,9 @@ struct inet_diag_entry {
 	u16 userlocks;
 	u32 ifindex;
 	u32 mark;
+#ifdef CONFIG_SOCK_CGROUP_DATA
+	u64 cgroup_id;
+#endif
 };
 
 static DEFINE_MUTEX(inet_diag_table_mutex);
@@ -682,6 +685,16 @@ static int inet_diag_bc_run(const struct nlattr *_bc,
 				yes = 0;
 			break;
 		}
+#ifdef CONFIG_SOCK_CGROUP_DATA
+		case INET_DIAG_BC_CGROUP_COND: {
+			u64 cgroup_id;
+
+			cgroup_id = get_unaligned((const u64 *)(op + 1));
+			if (cgroup_id != entry->cgroup_id)
+				yes = 0;
+			break;
+		}
+#endif
 		}
 
 		if (yes) {
@@ -732,6 +745,9 @@ int inet_diag_bc_sk(const struct nlattr *bc, struct sock *sk)
 		entry.mark = inet_rsk(inet_reqsk(sk))->ir_mark;
 	else
 		entry.mark = 0;
+#ifdef CONFIG_SOCK_CGROUP_DATA
+	entry.cgroup_id = cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data));
+#endif
 
 	return inet_diag_bc_run(bc, &entry);
 }
@@ -821,6 +837,15 @@ static bool valid_markcond(const struct inet_diag_bc_op *op, int len,
 	return len >= *min_len;
 }
 
+#ifdef CONFIG_SOCK_CGROUP_DATA
+static bool valid_cgroupcond(const struct inet_diag_bc_op *op, int len,
+			     int *min_len)
+{
+	*min_len += sizeof(u64);
+	return len >= *min_len;
+}
+#endif
+
 static int inet_diag_bc_audit(const struct nlattr *attr,
 			      const struct sk_buff *skb)
 {
@@ -863,6 +888,12 @@ static int inet_diag_bc_audit(const struct nlattr *attr,
 			if (!valid_markcond(bc, len, &min_len))
 				return -EINVAL;
 			break;
+#ifdef CONFIG_SOCK_CGROUP_DATA
+		case INET_DIAG_BC_CGROUP_COND:
+			if (!valid_cgroupcond(bc, len, &min_len))
+				return -EINVAL;
+			break;
+#endif
 		case INET_DIAG_BC_AUTO:
 		case INET_DIAG_BC_JMP:
 		case INET_DIAG_BC_NOP:
-- 
2.7.4

