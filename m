Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E44371E8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhJVGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhJVGin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:38:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A734EC061243;
        Thu, 21 Oct 2021 23:36:23 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z14so2143039wrg.6;
        Thu, 21 Oct 2021 23:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s2i2bAYmALhhytziHf98MliwPYuJKllV5e3emMbFmoM=;
        b=kd2EfN70C0Zr6Ykp59AHyw7wo1GjxpRElOt+Nb4IfpXqO6ToPsahJNhybck14SOhZ/
         qv79O3OWalOvjOz/O4Tq+NlmDFb8rWOouuXdDt4/akZQVJ09+qAItCq7JxqpbcZcofXf
         MneNzri7bqAD67sCZjNsg6x6e7013P1bG7lFxOQ+FfWZ5Xngzu7tJpIEeUf7l9OmIL63
         pk9v+w+U/jworaurbacIy2GVfxIEMQ14NIPXafyzSvYdYWGKjuLzl7WARWfsk518QVv7
         kiTmETuBmI2vpgUVNajzIZeLe6WdYXLslDqaMyjZBT+NM0QM0TK1zaEmgTB6ICkYZUma
         vQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s2i2bAYmALhhytziHf98MliwPYuJKllV5e3emMbFmoM=;
        b=nV6Ra8ZqykdnQ+DjKvupexSNaO/NytpzN5WR8jFRXKdNxoHsfPUDmMLZbFurM/I7cv
         WzBCSoxoHnjsgViQtWto+fyh4rcq+P3z3BAZD+TAlPAGqc0MYwNqaoOwHkAEujYf1WTo
         +6IOxQsVsxSn0cEGE0kpoJXziX0/k4rGZ9Ks9Rf0jZNPa374+zqf/5avRWTtKlC1J0NI
         zC/9zZ6/CnmNtA9FfpIcnBD1LAskepUcegNd2ZqSEosq0sC4CAhJxBdM5kIfHKaKxv73
         YlQ43lPr5hOJIcEMBciQzNIQqHka+bUz94dh9oFqrBEPIOf+Bw9hbCbHUTf013UO79xt
         pTMw==
X-Gm-Message-State: AOAM533PmxbrXNJ1BEhMFWo/wiH+yGSpEkD4HdQ42rw/jlnIU4uRntkl
        /D/LDjbjCy5ofNaLYgPSMo7Ba5Z8087ycg==
X-Google-Smtp-Source: ABdhPJxRKJWcSksKCp6W0Fl0ok+ZMFh4g8BF+3JbueHyAi+L39VU3M60g8zNw19+Co89+iA7p07XfQ==
X-Received: by 2002:adf:d1c3:: with SMTP id b3mr13412983wrd.237.1634884582093;
        Thu, 21 Oct 2021 23:36:22 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c7sm4099733wrp.51.2021.10.21.23.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:36:21 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH net 3/4] security: add sctp_assoc_established hook
Date:   Fri, 22 Oct 2021 02:36:11 -0400
Message-Id: <71602ec3cff6bf67d47fef520f64cb6bccba928c.1634884487.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634884487.git.lucien.xin@gmail.com>
References: <cover.1634884487.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

security_sctp_assoc_established() is added to replace
security_inet_conn_established() called in
sctp_sf_do_5_1E_ca(), so that asoc can be accessed in security
subsystem and save the peer secid to asoc->peer_secid.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/security/SCTP.rst | 22 ++++++++++------------
 include/linux/lsm_hook_defs.h   |  2 ++
 include/linux/lsm_hooks.h       |  5 +++++
 include/linux/security.h        |  8 ++++++++
 net/sctp/sm_statefuns.c         |  2 +-
 security/security.c             |  7 +++++++
 6 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index 9a38067762e5..3ebbcd80b3e7 100644
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
index a16407444871..11cdddf9685c 100644
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
@@ -1642,6 +1644,12 @@ static inline void security_sctp_sk_clone(struct sctp_association *asoc,
 					  struct sock *newsk)
 {
 }
+
+static inline void security_sctp_assoc_established(struct sctp_association *asoc,
+						   struct sk_buff *skb)
+{
+	return 0;
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

