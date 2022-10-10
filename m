Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F4C5FA729
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJJV6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 17:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJJV6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 17:58:34 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B38272680
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 14:58:32 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id a18so4574823qko.0
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to;
        bh=+HjSmW9tpglN5ccFyvz+dD73Sw0/OvglxWepA2Jo0J8=;
        b=I/cO6PrHGUWOsL079qORX34o7QDdY+XbrAZk6JT2+Jt1kfnaFdzRSOl/qfyitom0dH
         Xuk8Ybmy8+vrVK8V+qRhhhK6vNkfUpZ3rCkBryMi421KFVXVtwdI3TdAiJ7CIMwSeHcK
         IHcaGVlrfrKah17oUVaAej/Dz9ZxMxZDRjBfkpFNVPpBN2oUJAXqx+CGn7m2+LTJ98d/
         U9GLTQ/153XOameRzBvhqcn0dMhyQQy9PnF8SATTj6KkC4P8vSX7TM1nNrVB5y9NEk/s
         A3qWCehFe+mcSBWdobPZAjQrXIJKj34IfaVpwpjOQna3OuZFH4E5Cigk2jo5OybFr2o5
         xcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HjSmW9tpglN5ccFyvz+dD73Sw0/OvglxWepA2Jo0J8=;
        b=He7z4Oq2iw3lG8K475SSsX0PY62Bte6UHBiE6FhtNEIxBgCingMvfiDtAY4iMJfW1M
         iYZWE9gin9y90h0VhWD1gBanPQNZr5UaFtruijke0ZZSfBnhSP/fwVwU6S8pPMTNeviz
         Jax+A/s8x+Rf9uuSxK/SlPOSw8GxY8mFZ9wxm4AH/05afsMQH+/s08jr0H0dVMBkBygz
         SJn7wpoHfm47QlQ1zr7bmCwxgpUkcNz6WBMVmy0SRlIt64LKw6W6Whg006S1B/hLZsJa
         Q6GkqXFY8ALXme2m68qv7eNGXmb5R4kaaoBjaV/rH+qPOFqOvEYGg74crvII4JELsPBg
         3OVg==
X-Gm-Message-State: ACrzQf2KqXt6ozTGen4cEmbjFzwX/A4fwtmJov2pEtcimnMaeE47WeXN
        c6G9XIb/4WOXWi0mZgdrYPQcI2GPqwzr
X-Google-Smtp-Source: AMsMyM7ogY72hWnpOfhJWsmDxAUR5/egyXlfT+Ho6XupmrhseZgpozxqJTvuHhrjZpMX3PDMt+xbcA==
X-Received: by 2002:a05:620a:1097:b0:6ea:b98f:ff2f with SMTP id g23-20020a05620a109700b006eab98fff2fmr10132300qkk.101.1665439111504;
        Mon, 10 Oct 2022 14:58:31 -0700 (PDT)
Received: from localhost (pool-108-26-161-203.bstnma.fios.verizon.net. [108.26.161.203])
        by smtp.gmail.com with ESMTPSA id u4-20020a05622a198400b00398ed306034sm5181214qtc.81.2022.10.10.14.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 14:58:30 -0700 (PDT)
Subject: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t safe
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 10 Oct 2022 17:58:29 -0400
Message-ID: <166543910984.474337.2779830480340611497.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
sockptr_t argument") made it possible to call sk_getsockopt()
with both user and kernel address space buffers through the use of
the sockptr_t type.  Unfortunately at the time of conversion the
security_socket_getpeersec_stream() LSM hook was written to only
accept userspace buffers, and in a desire to avoid having to change
the LSM hook the commit author simply passed the sockptr_t's
userspace buffer pointer.  Since the only sk_getsockopt() callers
at the time of conversion which used kernel sockptr_t buffers did
not allow SO_PEERSEC, and hence the
security_socket_getpeersec_stream() hook, this was acceptable but
also very fragile as future changes presented the possibility of
silently passing kernel space pointers to the LSM hook.

There are several ways to protect against this, including careful
code review of future commits, but since relying on code review to
catch bugs is a recipe for disaster and the upstream eBPF maintainer
is "strongly against defensive programming", this patch updates the
LSM hook, and all of the implementations to support sockptr_t and
safely handle both user and kernel space buffers.

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 include/linux/lsm_hook_defs.h |    2 +-
 include/linux/lsm_hooks.h     |    4 ++--
 include/linux/security.h      |   11 +++++++----
 net/core/sock.c               |    3 ++-
 security/apparmor/lsm.c       |   29 +++++++++++++----------------
 security/security.c           |    6 +++---
 security/selinux/hooks.c      |   13 ++++++-------
 security/smack/smack_lsm.c    |   19 ++++++++++---------
 8 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index ec119da1d89b4..6abde829b6e5e 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -302,7 +302,7 @@ LSM_HOOK(int, 0, socket_setsockopt, struct socket *sock, int level, int optname)
 LSM_HOOK(int, 0, socket_shutdown, struct socket *sock, int how)
 LSM_HOOK(int, 0, socket_sock_rcv_skb, struct sock *sk, struct sk_buff *skb)
 LSM_HOOK(int, 0, socket_getpeersec_stream, struct socket *sock,
-	 char __user *optval, int __user *optlen, unsigned len)
+	 sockptr_t optval, sockptr_t optlen, unsigned int len)
 LSM_HOOK(int, 0, socket_getpeersec_dgram, struct socket *sock,
 	 struct sk_buff *skb, u32 *secid)
 LSM_HOOK(int, 0, sk_alloc_security, struct sock *sk, int family, gfp_t priority)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 4ec80b96c22e7..883f0f252f062 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -962,8 +962,8 @@
  *	SO_GETPEERSEC.  For tcp sockets this can be meaningful if the
  *	socket is associated with an ipsec SA.
  *	@sock is the local socket.
- *	@optval userspace memory where the security state is to be copied.
- *	@optlen userspace int where the module should copy the actual length
+ *	@optval memory where the security state is to be copied.
+ *	@optlen memory where the module should copy the actual length
  *	of the security state.
  *	@len as input is the maximum length to copy to userspace provided
  *	by the caller.
diff --git a/include/linux/security.h b/include/linux/security.h
index ca1b7109c0dbb..0e419c595cee5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -31,6 +31,7 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/sockptr.h>
 
 struct linux_binprm;
 struct cred;
@@ -1411,8 +1412,8 @@ int security_socket_getsockopt(struct socket *sock, int level, int optname);
 int security_socket_setsockopt(struct socket *sock, int level, int optname);
 int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
-int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-				      int __user *optlen, unsigned len);
+int security_socket_getpeersec_stream(struct socket *sock, sockptr_t optval,
+				      sockptr_t optlen, unsigned int len);
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
@@ -1548,8 +1549,10 @@ static inline int security_sock_rcv_skb(struct sock *sk,
 	return 0;
 }
 
-static inline int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-						    int __user *optlen, unsigned len)
+static inline int security_socket_getpeersec_stream(struct socket *sock,
+						    sockptr_t optval,
+						    sockptr_t optlen,
+						    unsigned int len)
 {
 	return -ENOPROTOOPT;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index eeb6cbac6f499..70064415349d6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1793,7 +1793,8 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SO_PEERSEC:
-		return security_socket_getpeersec_stream(sock, optval.user, optlen.user, len);
+		return security_socket_getpeersec_stream(sock,
+							 optval, optlen, len);
 
 	case SO_MARK:
 		v.val = sk->sk_mark;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index f56070270c69d..89e84ef54e8eb 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1103,11 +1103,10 @@ static struct aa_label *sk_peer_label(struct sock *sk)
  * Note: for tcp only valid if using ipsec or cipso on lan
  */
 static int apparmor_socket_getpeersec_stream(struct socket *sock,
-					     char __user *optval,
-					     int __user *optlen,
+					     sockptr_t optval, sockptr_t optlen,
 					     unsigned int len)
 {
-	char *name;
+	char *name = NULL;
 	int slen, error = 0;
 	struct aa_label *label;
 	struct aa_label *peer;
@@ -1124,23 +1123,21 @@ static int apparmor_socket_getpeersec_stream(struct socket *sock,
 	/* don't include terminating \0 in slen, it breaks some apps */
 	if (slen < 0) {
 		error = -ENOMEM;
-	} else {
-		if (slen > len) {
-			error = -ERANGE;
-		} else if (copy_to_user(optval, name, slen)) {
-			error = -EFAULT;
-			goto out;
-		}
-		if (put_user(slen, optlen))
-			error = -EFAULT;
-out:
-		kfree(name);
-
+		goto done;
+	}
+	if (slen > len) {
+		error = -ERANGE;
+		goto done_len;
 	}
 
+	if (copy_to_sockptr(optval, name, slen))
+		error = -EFAULT;
+done_len:
+	if (copy_to_sockptr(optlen, &slen, sizeof(slen)))
+		error = -EFAULT;
 done:
 	end_current_label_crit_section(label);
-
+	kfree(name);
 	return error;
 }
 
diff --git a/security/security.c b/security/security.c
index 79d82cb6e4696..f27c885ee98db 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2267,11 +2267,11 @@ int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(security_sock_rcv_skb);
 
-int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-				      int __user *optlen, unsigned len)
+int security_socket_getpeersec_stream(struct socket *sock, sockptr_t optval,
+				      sockptr_t optlen, unsigned int len)
 {
 	return call_int_hook(socket_getpeersec_stream, -ENOPROTOOPT, sock,
-				optval, optlen, len);
+			     optval, optlen, len);
 }
 
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f553c370397ee..0bdddeba90a6c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5119,11 +5119,12 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	return err;
 }
 
-static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-					    int __user *optlen, unsigned len)
+static int selinux_socket_getpeersec_stream(struct socket *sock,
+					    sockptr_t optval, sockptr_t optlen,
+					    unsigned int len)
 {
 	int err = 0;
-	char *scontext;
+	char *scontext = NULL;
 	u32 scontext_len;
 	struct sk_security_struct *sksec = sock->sk->sk_security;
 	u32 peer_sid = SECSID_NULL;
@@ -5139,17 +5140,15 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
 				      &scontext_len);
 	if (err)
 		return err;
-
 	if (scontext_len > len) {
 		err = -ERANGE;
 		goto out_len;
 	}
 
-	if (copy_to_user(optval, scontext, scontext_len))
+	if (copy_to_sockptr(optval, scontext, scontext_len))
 		err = -EFAULT;
-
 out_len:
-	if (put_user(scontext_len, optlen))
+	if (copy_to_sockptr(optlen, &scontext_len, sizeof(scontext_len)))
 		err = -EFAULT;
 	kfree(scontext);
 	return err;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b6306d71c9088..2bd7fadf7fb4c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4006,12 +4006,12 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
  * returns zero on success, an error code otherwise
  */
 static int smack_socket_getpeersec_stream(struct socket *sock,
-					  char __user *optval,
-					  int __user *optlen, unsigned len)
+					  sockptr_t optval, sockptr_t optlen,
+					  unsigned int len)
 {
 	struct socket_smack *ssp;
 	char *rcp = "";
-	int slen = 1;
+	u32 slen = 1;
 	int rc = 0;
 
 	ssp = sock->sk->sk_security;
@@ -4019,15 +4019,16 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 		rcp = ssp->smk_packet->smk_known;
 		slen = strlen(rcp) + 1;
 	}
-
-	if (slen > len)
+	if (slen > len) {
 		rc = -ERANGE;
-	else if (copy_to_user(optval, rcp, slen) != 0)
-		rc = -EFAULT;
+		goto out_len;
+	}
 
-	if (put_user(slen, optlen) != 0)
+	if (copy_to_sockptr(optval, rcp, slen))
+		rc = -EFAULT;
+out_len:
+	if (copy_to_sockptr(optlen, &slen, sizeof(slen)))
 		rc = -EFAULT;
-
 	return rc;
 }
 

