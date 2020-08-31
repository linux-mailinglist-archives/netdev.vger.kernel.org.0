Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8263125849B
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 02:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgIAAAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 20:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgIAAAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 20:00:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AC1D2083E;
        Tue,  1 Sep 2020 00:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598918405;
        bh=7+D1+o6KRKCeo756ZxO2RYzu2L9XMS7+qqtWVPWrtcA=;
        h=From:To:Cc:Subject:Date:From;
        b=ns0wkilJLlszmINi5QU5ErWSodFRFv3MBmzHPIn474jRpetghDngLU6kk/Z8rrEr3
         pHFNlDoVY54CPw4gG9PKakpAKz1Kg5plmfhuig1Pwx00sbtS864/te8NYLfNybo1Uf
         ah+h3RvfuctdRM01vMct+XhD+xeyfrm2tDQWOhEk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, zeil@yandex-team.ru,
        khlebnikov@yandex-team.ru, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH net-next] net: diag: add workaround for inode truncation
Date:   Mon, 31 Aug 2020 16:59:56 -0700
Message-Id: <20200831235956.2143127-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave reports that struct inet_diag_msg::idiag_inode is 32 bit,
while inode's type is unsigned long. This leads to truncation.

Since there is nothing we can do about the size of existing
fields - add a new attribute to carry 64 bit inode numbers.

Reported-by: Dave Marchevsky <davemarchevsky@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/inet_diag.h      | 1 +
 include/uapi/linux/inet_diag.h | 1 +
 net/ipv4/inet_diag.c           | 7 ++++++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 0ef2d800fda7..5ea0f965c173 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -75,6 +75,7 @@ static inline size_t inet_diag_msg_attrs_size(void)
 #ifdef CONFIG_SOCK_CGROUP_DATA
 		+ nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_CGROUP_ID */
 #endif
+		+ nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_INODE */
 		;
 }
 int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index 5ba122c1949a..0819a473ee9c 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -160,6 +160,7 @@ enum {
 	INET_DIAG_ULP_INFO,
 	INET_DIAG_SK_BPF_STORAGES,
 	INET_DIAG_CGROUP_ID,
+	INET_DIAG_INODE,
 	__INET_DIAG_MAX,
 };
 
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 4a98dd736270..6a52947591fc 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -125,6 +125,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 			     bool net_admin)
 {
 	const struct inet_sock *inet = inet_sk(sk);
+	unsigned long ino;
 
 	if (nla_put_u8(skb, INET_DIAG_SHUTDOWN, sk->sk_shutdown))
 		goto errout;
@@ -177,8 +178,12 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 		goto errout;
 #endif
 
+	ino = sock_i_ino(sk);
+	if (nla_put_u64_64bit(skb, INET_DIAG_INODE, ino, INET_DIAG_PAD))
+		goto errout;
+
 	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
-	r->idiag_inode = sock_i_ino(sk);
+	r->idiag_inode = ino;
 
 	return 0;
 errout:
-- 
2.26.2

