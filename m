Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA92541CF91
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 00:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346851AbhI2W7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 18:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345988AbhI2W7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 18:59:39 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC964C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 15:57:57 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a73so1327716pge.0
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 15:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9E90c6YkLKHA18V49jTcSpNtA72RonacrjjL8A0pD5A=;
        b=odqPw+zXGzz3GNHO1w7ZYKxx4vDSR9zIIArYWSZ8sSFo9+fQC7PuxdcD1tCzyzzXsC
         GEY6S7CnNikeg84kNYPZrsPiPkxCStzaU9DaaUys9urnFFQjEfYBU80VYtEMaJdkFT/r
         ynGLcUvtm96ADVp8YfCgGv8ECirDcBMJYepdYDnM1RPdEdrFNXIlNn6dGU5z43JODm/b
         1JIVX3lerK3elvWmD1oMh2RdT12FXkz9CJOBKE5eq1U2Az6Br1wVN8Qm16pxTTUgjCmP
         K/9FrpAp7MtO9LOrvZ/956hKqCtf3bFGcE2gmH1NnOj6sCwolrpX9taICd3iarDNr1g9
         DBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9E90c6YkLKHA18V49jTcSpNtA72RonacrjjL8A0pD5A=;
        b=qpfuWH1hqbhbMF1AwLlfRxLf8F0Yj4HYKG5faoOnU2jZDwhuNHRumC5F3T11OjgetZ
         2VlX0YTwwwP+Wmzlm0wCOwB5AqqURsX310pfxH30bGH5+wI2U+wlo9glOgRgIxZT9Cqp
         +hibq3/Q/s+pka0v/3ewyyqZ6xxHHV5KyBJfNnvLaZpGGVkSbjZipPv9J+qM6ruZ3UsP
         8CU6av4gQUlCFJcrl85X9e6sLY6cpiiFgWMTOqKumufUGVIeMME1Lm+8gwDEFCNyond4
         HgRuOMrRcPcrAmutJUpY8MJiKyVPgSzW5xP/ZDBfkuJwy0nO+CSI6LL1UijCtz3GkNp6
         UatA==
X-Gm-Message-State: AOAM532zMwJL2KB5qrgdiXen8D2hBxKR2U+O+mfmy+z0HtXjTFhzI/dC
        DeVVJJGs+/4LX9PUdwdtudQ=
X-Google-Smtp-Source: ABdhPJxRyjsszn86TYDwnd4CbrkdA9i80X4EVInOcPEVKPP/GsIRQ4ESXcUjmPhY96y+Bwi22mc3SA==
X-Received: by 2002:a05:6a00:1307:b0:43d:2b4:419a with SMTP id j7-20020a056a00130700b0043d02b4419amr975872pfu.62.1632956277375;
        Wed, 29 Sep 2021 15:57:57 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8858:a0b7:dcc9:9a3b])
        by smtp.gmail.com with ESMTPSA id z11sm2955636pjn.12.2021.09.29.15.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:57:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH net] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
Date:   Wed, 29 Sep 2021 15:57:50 -0700
Message-Id: <20210929225750.2548112-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.

In order to fix this issue, this patch adds a new spinlock that needs
to be used whenever these fields are read or written.

Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
reading sk->sk_peer_pid which makes no sense, as this field
is only possibly set by AF_UNIX sockets.
We will have to clean this in a separate patch.
This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
or implementing what was truly expected.

Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
---
 include/net/sock.h |  2 ++
 net/core/sock.c    | 32 ++++++++++++++++++++++++++------
 net/unix/af_unix.c | 34 ++++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c005c3c750e89b6d4d36d36ccfad392a7e733603..f471cd0a6f98cb5b2b961f01c2de62870d61521e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -488,8 +488,10 @@ struct sock {
 	u8			sk_prefer_busy_poll;
 	u16			sk_busy_poll_budget;
 #endif
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	ktime_t			sk_stamp;
 #if BITS_PER_LONG==32
diff --git a/net/core/sock.c b/net/core/sock.c
index 512e629f97803f3216db8f054e97fd1b7a6e6c63..c70cbce69a66181c3688862ea51aa781b3ce4f97 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1376,6 +1376,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(sock_setsockopt);
 
+static const struct cred *sk_get_peer_cred(struct sock *sk)
+{
+	const struct cred *cred;
+
+	spin_lock(&sk->sk_peer_lock);
+	cred = get_cred(sk->sk_peer_cred);
+	spin_unlock(&sk->sk_peer_lock);
+
+	return cred;
+}
 
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
@@ -1552,7 +1562,11 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
+
+		spin_lock(&sk->sk_peer_lock);
 		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		spin_unlock(&sk->sk_peer_lock);
+
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
@@ -1560,20 +1574,23 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 	case SO_PEERGROUPS:
 	{
+		const struct cred *cred;
 		int ret, n;
 
-		if (!sk->sk_peer_cred)
+		cred = sk_get_peer_cred(sk);
+		if (!cred)
 			return -ENODATA;
 
-		n = sk->sk_peer_cred->group_info->ngroups;
+		n = cred->group_info->ngroups;
 		if (len < n * sizeof(gid_t)) {
 			len = n * sizeof(gid_t);
+			put_cred(cred);
 			return put_user(len, optlen) ? -EFAULT : -ERANGE;
 		}
 		len = n * sizeof(gid_t);
 
-		ret = groups_to_user((gid_t __user *)optval,
-				     sk->sk_peer_cred->group_info);
+		ret = groups_to_user((gid_t __user *)optval, cred->group_info);
+		put_cred(cred);
 		if (ret)
 			return ret;
 		goto lenout;
@@ -1935,9 +1952,10 @@ static void __sk_destruct(struct rcu_head *head)
 		sk->sk_frag.page = NULL;
 	}
 
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	/* We do not need to acquire sk->sk_peer_lock, we are the last user. */
+	put_cred(sk->sk_peer_cred);
 	put_pid(sk->sk_peer_pid);
+
 	if (likely(sk->sk_net_refcnt))
 		put_net(sock_net(sk));
 	sk_prot_free(sk->sk_prot_creator, sk);
@@ -3145,6 +3163,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_peer_pid 	=	NULL;
 	sk->sk_peer_cred	=	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=	0;
 	sk->sk_rcvlowat		=	1;
 	sk->sk_rcvtimeo		=	MAX_SCHEDULE_TIMEOUT;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f505b89bda6adefe973806f842001d428fc6c5ca..efac5989edb5d37881139bb1ad2fb9cf63bd7342 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -608,20 +608,42 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 static void init_peercred(struct sock *sk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(task_tgid(current));
 	sk->sk_peer_cred = get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static int unix_listen(struct socket *sock, int backlog)
-- 
2.33.0.800.g4c38ced690-goog

