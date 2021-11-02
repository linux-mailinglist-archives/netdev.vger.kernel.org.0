Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70910442D71
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhKBMFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhKBMFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:05:33 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3570C061714;
        Tue,  2 Nov 2021 05:02:58 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id bu11so5206800qvb.0;
        Tue, 02 Nov 2021 05:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=++zfDrKy6nNfkeRLTYQUCOMjjV9cL+Ci5XBEptzIIdU=;
        b=i+rBN+DIyL8os/XYT7RviNX2Cq8MOzOS90UXSVsu53utdw3Z20cykfev3j1RyEfzAU
         YPydC8mhByz3Xy3NephOGUf0hVzO6fPIp4Dl7dXcTtTLczg5rNSuANQsLi5mWmBJ3T7A
         NRfncBYiVym6Q6hPfwb2BV50cjw9eRqG7DXH1kLjJTcXdU/3gPEXRc+0aE0Y+kxHyK0I
         tjwo5WO1/rpezhg/8ApqUQffNJI3Ng4jX63O/Q4KRUn2q2pfko/bc159KWgXqF01Go7m
         nBrdf3MIYGROK4YHu+K30RoUtcDtK10aEuD1njAPFjBGWXfJB7i6ftB1NX+FbiyU5kom
         T3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++zfDrKy6nNfkeRLTYQUCOMjjV9cL+Ci5XBEptzIIdU=;
        b=wWDCEImAjGnPdM/uFq5RwchafxYNJElxmGWbvpQjie7afPMetGyoES7IMiAPnJM2y5
         xN31sm5B3Cst3E3vQRcpQ07GHKH+EKvuzf9vyIfkNd0Iyietpm1eYvgzL2ojorQ0//g5
         95sd/zopn3AhA9oxXldUGlDJihGWue0tdVpuOLqYxxapzo7hA9pNLPffu9+R1J+HPkjM
         qpfOKbLnuPNerXdXxKxH569ruhsLUUpaLDXiJj1hJGmS2q3JGfQ63mc7XPXIbW+u/ehG
         HPAwB4JUhwioFjBSAXr0+w86WJ4iWeBkUKEFCJ9AGtSn2o/W6Rbvjn6xAqZUjDk248Dd
         U7Bg==
X-Gm-Message-State: AOAM5318WOLGmD5a7jPB97OnGHYSWsnlU3gLhpmLfoiS3RU2U2qkgOed
        Ct+yKv/MHwyUAWUHtWJ7IuDBaP8slYU1a8EL
X-Google-Smtp-Source: ABdhPJy36K1M3FvSQAjnPCVeRQj3JLe/jXkiuWIBozdCvxCaNVMksYlNY8c2AeGn58xD9I0aw7a5Gg==
X-Received: by 2002:a0c:b412:: with SMTP id u18mr34737581qve.14.1635854577755;
        Tue, 02 Nov 2021 05:02:57 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w9sm12498988qko.19.2021.11.02.05.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:02:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCHv2 net 3/4] security: add sctp_assoc_established hook
Date:   Tue,  2 Nov 2021 08:02:49 -0400
Message-Id: <6c3a6772929152134b78d0d73ad74094e588a906.1635854268.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635854268.git.lucien.xin@gmail.com>
References: <cover.1635854268.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

security_sctp_assoc_established() is added to replace
security_inet_conn_established() called in
sctp_sf_do_5_1E_ca(), so that asoc can be accessed in security
subsystem and save the peer secid to asoc->peer_secid.

v1->v2:
  - fix the return value of security_sctp_assoc_established() in
    security.h, found by kernel test robot and Ondrej.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
Tested-by: Richard Haines <richard_c_haines@btinternet.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/security/SCTP.rst | 22 ++++++++++------------
 include/linux/lsm_hook_defs.h   |  2 ++
 include/linux/lsm_hooks.h       |  5 +++++
 include/linux/security.h        |  7 +++++++
 net/sctp/sm_statefuns.c         |  2 +-
 security/security.c             |  7 +++++++
 6 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index d5fd6ccc3dcb..406cc68b8808 100644
--- a/Documentation/security/SCTP.rst
+++ b/Documentation/security/SCTP.rst
@@ -15,10 +15,7 @@ For security module support, three SCTP specific hooks have been implemented::
     security_sctp_assoc_request()
     security_sctp_bind_connect()
     security_sctp_sk_clone()
-
-Also the following security hook has been utilised::
-
-    security_inet_conn_established()
+    security_sctp_assoc_established()
 
 The usage of these hooks are described below with the SELinux implementation
 described in the `SCTP SELinux Support`_ chapter.
@@ -122,11 +119,12 @@ calls **sctp_peeloff**\(3).
     @newsk - pointer to new sock structure.
 
 
-security_inet_conn_established()
+security_sctp_assoc_established()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Called when a COOKIE ACK is received::
+Called when a COOKIE ACK is received, and the peer secid will be
+saved into ``@asoc->peer_secid`` for client::
 
-    @sk  - pointer to sock structure.
+    @asoc - pointer to sctp association structure.
     @skb - pointer to skbuff of the COOKIE ACK packet.
 
 
@@ -134,7 +132,7 @@ Security Hooks used for Association Establishment
 -------------------------------------------------
 
 The following diagram shows the use of ``security_sctp_bind_connect()``,
-``security_sctp_assoc_request()``, ``security_inet_conn_established()`` when
+``security_sctp_assoc_request()``, ``security_sctp_assoc_established()`` when
 establishing an association.
 ::
 
@@ -172,7 +170,7 @@ establishing an association.
           <------------------------------------------- COOKIE ACK
           |                                               |
     sctp_sf_do_5_1E_ca                                    |
- Call security_inet_conn_established()                    |
+ Call security_sctp_assoc_established()                   |
  to set the peer label.                                   |
           |                                               |
           |                               If SCTP_SOCKET_TCP or peeled off
@@ -198,7 +196,7 @@ hooks with the SELinux specifics expanded below::
     security_sctp_assoc_request()
     security_sctp_bind_connect()
     security_sctp_sk_clone()
-    security_inet_conn_established()
+    security_sctp_assoc_established()
 
 
 security_sctp_assoc_request()
@@ -271,12 +269,12 @@ sockets sid and peer sid to that contained in the ``@asoc sid`` and
     @newsk - pointer to new sock structure.
 
 
-security_inet_conn_established()
+security_sctp_assoc_established()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Called when a COOKIE ACK is received where it sets the connection's peer sid
 to that in ``@skb``::
 
-    @sk  - pointer to sock structure.
+    @asoc - pointer to sctp association structure.
     @skb - pointer to skbuff of the COOKIE ACK packet.
 
 
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 0024273a7382..e9870118cc67 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -334,6 +334,8 @@ LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
 LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
+LSM_HOOK(void, LSM_RET_VOID, sctp_assoc_established, struct sctp_association *asoc,
+	 struct sk_buff *skb)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 240b92d89852..ba42c22204e2 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1047,6 +1047,11 @@
  *	@asoc pointer to current sctp association structure.
  *	@sk pointer to current sock structure.
  *	@newsk pointer to new sock structure.
+ * @sctp_assoc_established:
+ *	Passes the @asoc and @chunk->skb of the association COOKIE_ACK packet
+ *	to the security module.
+ *	@asoc pointer to sctp association structure.
+ *	@skb pointer to skbuff of association packet.
  *
  * Security hooks for Infiniband
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index a16407444871..c2ac6b15e50b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1423,6 +1423,8 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
 void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk);
+void security_sctp_assoc_established(struct sctp_association *asoc,
+				     struct sk_buff *skb);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1642,6 +1644,11 @@ static inline void security_sctp_sk_clone(struct sctp_association *asoc,
 					  struct sock *newsk)
 {
 }
+
+static inline void security_sctp_assoc_established(struct sctp_association *asoc,
+						   struct sk_buff *skb)
+{
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b818532c3fc2..5fabaa54b77d 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -946,7 +946,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
 
 	/* Set peer label for connection. */
-	security_inet_conn_established(ep->base.sk, chunk->skb);
+	security_sctp_assoc_established((struct sctp_association *)asoc, chunk->skb);
 
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
diff --git a/security/security.c b/security/security.c
index b0f1c007aa3b..4b2b4b5beb27 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2387,6 +2387,13 @@ void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
+void security_sctp_assoc_established(struct sctp_association *asoc,
+				     struct sk_buff *skb)
+{
+	call_void_hook(sctp_assoc_established, asoc, skb);
+}
+EXPORT_SYMBOL(security_sctp_assoc_established);
+
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
-- 
2.27.0

