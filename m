Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048964371DE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhJVGii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhJVGih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:38:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09696C061764;
        Thu, 21 Oct 2021 23:36:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 84-20020a1c0457000000b003232b0f78f8so2252410wme.0;
        Thu, 21 Oct 2021 23:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v+cwmsRwwmZoN2wTielpWSCcbxguEhGmYkIaK8uFFvE=;
        b=LqNsb8FFVHzDZS8gDXe0PRfNs+4uaXl9I5n0Y8ad+9QaV4CbUKp+4Y2l4h1ywrLN9o
         07/S1n8xCzMobdTn2NekVjP3xNQfizuuSOgnukNuIIGXPQ6DIRlXHIDTBgVST2ydTGpf
         0IXvl4RMpJ+T639HX+6Y1vUVEAS/Vk+hsdApQSj26mRJFPEf+MmCE0/lNrNgB0Wdrw17
         N6QqGRJZ7jLSQM19Q+sQ63x+p6WizdmAb4WmvUnFzSO+zao71mNh+6Kq0NNxLa0yyimZ
         vBdClDaY1ijPh2cqRw/2u3J5Q0wE8uvyIemEu1Q9CRJm/CNvgMdp7jujCbem+Nykadvm
         73dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+cwmsRwwmZoN2wTielpWSCcbxguEhGmYkIaK8uFFvE=;
        b=tdJLZtT+o6yjvdr+N0ucufM38kL1O8TCTtrsj1GZCxFY5x/kwnNEsYLyTs3ROs0CIC
         aypxGAgUEwJqn6Jg87X94Eg1ywUhdyzo5dtv9j+h20sbk9oqGx4k0LpfeViYKn6KI6pf
         BCQo6muIOqO9ANsPtWnNUtjmK1aR5RwKHs/aLY7IANSH+EFh49BIaTBemh7rEiOmLzNV
         YAORgFXGuYtqFFw5PT7uwLXbThB3THdj7GMKUISL9zrzHyHAaa0u39Tb2oWltNDXnv3s
         d3i2A5oXtEkk6tvEKrksnexhu6Pwioea1zQg2XT6KWPxrdxGlfTcfpQZ8LcumjccAkE5
         nxuw==
X-Gm-Message-State: AOAM533bF+TpwNYzIMQ+N3oFnOxWTlnxc7n/ms8CU8upUZMjmDPnrLcN
        d33zzW+Zbxe2Qsva1rlAWYZV77ukjvVcDg==
X-Google-Smtp-Source: ABdhPJzypysrANd0hEXkP7SJBZ2cKtBRsmEh2DpLs2cfyRvjOMd7EaALeDSLW/E4bGI5ZvmWQCpw3A==
X-Received: by 2002:a05:600c:5117:: with SMTP id o23mr4545269wms.81.1634884578196;
        Thu, 21 Oct 2021 23:36:18 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c7sm4099733wrp.51.2021.10.21.23.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:36:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH net 1/4] security: pass asoc to sctp_assoc_request and sctp_sk_clone
Date:   Fri, 22 Oct 2021 02:36:09 -0400
Message-Id: <615570feca5b99958947a7fdb807bab1e82196ca.1634884487.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634884487.git.lucien.xin@gmail.com>
References: <cover.1634884487.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to move secid and peer_secid from endpoint to association,
and pass asoc to sctp_assoc_request and sctp_sk_clone instead of ep. As
ep is the local endpoint and asoc represents a connection, and in SCTP
one sk/ep could have multiple asoc/connection, saving secid/peer_secid
for new asoc will overwrite the old asoc's.

Note that since asoc can be passed as NULL, security_sctp_assoc_request()
is moved to the place right after the new_asoc is created in
sctp_sf_do_5_1B_init() and sctp_sf_do_unexpected_init().

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/security/SCTP.rst     | 28 ++++++++++++++--------------
 include/linux/lsm_hook_defs.h       |  4 ++--
 include/linux/lsm_hooks.h           |  8 ++++----
 include/linux/security.h            | 10 +++++-----
 include/net/sctp/structs.h          | 20 ++++++++++----------
 net/sctp/sm_statefuns.c             | 26 +++++++++++++-------------
 net/sctp/socket.c                   |  5 ++---
 security/security.c                 |  8 ++++----
 security/selinux/hooks.c            | 20 ++++++++++----------
 security/selinux/include/netlabel.h |  4 ++--
 security/selinux/netlabel.c         | 14 +++++++-------
 11 files changed, 73 insertions(+), 74 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index 0bcf6c1245ee..415b548d9ce0 100644
--- a/Documentation/security/SCTP.rst
+++ b/Documentation/security/SCTP.rst
@@ -26,11 +26,11 @@ described in the `SCTP SELinux Support`_ chapter.
 
 security_sctp_assoc_request()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Passes the ``@ep`` and ``@chunk->skb`` of the association INIT packet to the
+Passes the ``@asoc`` and ``@chunk->skb`` of the association INIT packet to the
 security module. Returns 0 on success, error on failure.
 ::
 
-    @ep - pointer to sctp endpoint structure.
+    @asoc - pointer to sctp association structure.
     @skb - pointer to skbuff of association packet.
 
 
@@ -117,9 +117,9 @@ Called whenever a new socket is created by **accept**\(2)
 calls **sctp_peeloff**\(3).
 ::
 
-    @ep - pointer to current sctp endpoint structure.
+    @asoc - pointer to current sctp association structure.
     @sk - pointer to current sock structure.
-    @sk - pointer to new sock structure.
+    @newsk - pointer to new sock structure.
 
 
 security_inet_conn_established()
@@ -200,22 +200,22 @@ hooks with the SELinux specifics expanded below::
 
 security_sctp_assoc_request()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Passes the ``@ep`` and ``@chunk->skb`` of the association INIT packet to the
+Passes the ``@asoc`` and ``@chunk->skb`` of the association INIT packet to the
 security module. Returns 0 on success, error on failure.
 ::
 
-    @ep - pointer to sctp endpoint structure.
+    @asoc - pointer to sctp association structure.
     @skb - pointer to skbuff of association packet.
 
 The security module performs the following operations:
-     IF this is the first association on ``@ep->base.sk``, then set the peer
+     IF this is the first association on ``@asoc->base.sk``, then set the peer
      sid to that in ``@skb``. This will ensure there is only one peer sid
-     assigned to ``@ep->base.sk`` that may support multiple associations.
+     assigned to ``@asoc->base.sk`` that may support multiple associations.
 
-     ELSE validate the ``@ep->base.sk peer_sid`` against the ``@skb peer sid``
+     ELSE validate the ``@asoc->base.sk peer_sid`` against the ``@skb peer sid``
      to determine whether the association should be allowed or denied.
 
-     Set the sctp ``@ep sid`` to socket's sid (from ``ep->base.sk``) with
+     Set the sctp ``@asoc sid`` to socket's sid (from ``asoc->base.sk``) with
      MLS portion taken from ``@skb peer sid``. This will be used by SCTP
      TCP style sockets and peeled off connections as they cause a new socket
      to be generated.
@@ -259,13 +259,13 @@ security_sctp_sk_clone()
 Called whenever a new socket is created by **accept**\(2) (i.e. a TCP style
 socket) or when a socket is 'peeled off' e.g userspace calls
 **sctp_peeloff**\(3). ``security_sctp_sk_clone()`` will set the new
-sockets sid and peer sid to that contained in the ``@ep sid`` and
-``@ep peer sid`` respectively.
+sockets sid and peer sid to that contained in the ``@asoc sid`` and
+``@asoc peer sid`` respectively.
 ::
 
-    @ep - pointer to current sctp endpoint structure.
+    @asoc - pointer to current sctp association structure.
     @sk - pointer to current sock structure.
-    @sk - pointer to new sock structure.
+    @newsk - pointer to new sock structure.
 
 
 security_inet_conn_established()
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2adeea44c0d5..0024273a7382 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -328,11 +328,11 @@ LSM_HOOK(int, 0, tun_dev_create, void)
 LSM_HOOK(int, 0, tun_dev_attach_queue, void *security)
 LSM_HOOK(int, 0, tun_dev_attach, struct sock *sk, void *security)
 LSM_HOOK(int, 0, tun_dev_open, void *security)
-LSM_HOOK(int, 0, sctp_assoc_request, struct sctp_endpoint *ep,
+LSM_HOOK(int, 0, sctp_assoc_request, struct sctp_association *asoc,
 	 struct sk_buff *skb)
 LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
-LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_endpoint *ep,
+LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
 #endif /* CONFIG_SECURITY_NETWORK */
 
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 5c4c5c0602cb..240b92d89852 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1024,9 +1024,9 @@
  * Security hooks for SCTP
  *
  * @sctp_assoc_request:
- *	Passes the @ep and @chunk->skb of the association INIT packet to
+ *	Passes the @asoc and @chunk->skb of the association INIT packet to
  *	the security module.
- *	@ep pointer to sctp endpoint structure.
+ *	@asoc pointer to sctp association structure.
  *	@skb pointer to skbuff of association packet.
  *	Return 0 on success, error on failure.
  * @sctp_bind_connect:
@@ -1044,9 +1044,9 @@
  *	Called whenever a new socket is created by accept(2) (i.e. a TCP
  *	style socket) or when a socket is 'peeled off' e.g userspace
  *	calls sctp_peeloff(3).
- *	@ep pointer to current sctp endpoint structure.
+ *	@asoc pointer to current sctp association structure.
  *	@sk pointer to current sock structure.
- *	@sk pointer to new sock structure.
+ *	@newsk pointer to new sock structure.
  *
  * Security hooks for Infiniband
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 5b7288521300..a16407444871 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -179,7 +179,7 @@ struct xfrm_policy;
 struct xfrm_state;
 struct xfrm_user_sec_ctx;
 struct seq_file;
-struct sctp_endpoint;
+struct sctp_association;
 
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
@@ -1418,10 +1418,10 @@ int security_tun_dev_create(void);
 int security_tun_dev_attach_queue(void *security);
 int security_tun_dev_attach(struct sock *sk, void *security);
 int security_tun_dev_open(void *security);
-int security_sctp_assoc_request(struct sctp_endpoint *ep, struct sk_buff *skb);
+int security_sctp_assoc_request(struct sctp_association *asoc, struct sk_buff *skb);
 int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
-void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
+void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk);
 
 #else	/* CONFIG_SECURITY_NETWORK */
@@ -1624,7 +1624,7 @@ static inline int security_tun_dev_open(void *security)
 	return 0;
 }
 
-static inline int security_sctp_assoc_request(struct sctp_endpoint *ep,
+static inline int security_sctp_assoc_request(struct sctp_association *asoc,
 					      struct sk_buff *skb)
 {
 	return 0;
@@ -1637,7 +1637,7 @@ static inline int security_sctp_bind_connect(struct sock *sk, int optname,
 	return 0;
 }
 
-static inline void security_sctp_sk_clone(struct sctp_endpoint *ep,
+static inline void security_sctp_sk_clone(struct sctp_association *asoc,
 					  struct sock *sk,
 					  struct sock *newsk)
 {
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 651bba654d77..899c29c326ba 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1355,16 +1355,6 @@ struct sctp_endpoint {
 	      reconf_enable:1;
 
 	__u8  strreset_enable;
-
-	/* Security identifiers from incoming (INIT). These are set by
-	 * security_sctp_assoc_request(). These will only be used by
-	 * SCTP TCP type sockets and peeled off connections as they
-	 * cause a new socket to be generated. security_sctp_sk_clone()
-	 * will then plug these into the new socket.
-	 */
-
-	u32 secid;
-	u32 peer_secid;
 };
 
 /* Recover the outter endpoint structure. */
@@ -2104,6 +2094,16 @@ struct sctp_association {
 	__u64 abandoned_unsent[SCTP_PR_INDEX(MAX) + 1];
 	__u64 abandoned_sent[SCTP_PR_INDEX(MAX) + 1];
 
+	/* Security identifiers from incoming (INIT). These are set by
+	 * security_sctp_assoc_request(). These will only be used by
+	 * SCTP TCP type sockets and peeled off connections as they
+	 * cause a new socket to be generated. security_sctp_sk_clone()
+	 * will then plug these into the new socket.
+	 */
+
+	u32 secid;
+	u32 peer_secid;
+
 	struct rcu_head rcu;
 };
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index fb3da4d8f4a3..3206374209bc 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -326,11 +326,6 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	struct sctp_packet *packet;
 	int len;
 
-	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
-					chunk->skb))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* 6.10 Bundling
 	 * An endpoint MUST NOT bundle INIT, INIT ACK or
 	 * SHUTDOWN COMPLETE with any other chunks.
@@ -415,6 +410,12 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (!new_asoc)
 		goto nomem;
 
+	/* Update socket peer label if first association. */
+	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+		sctp_association_free(new_asoc);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+
 	if (sctp_assoc_set_bind_addr_from_ep(new_asoc,
 					     sctp_scope(sctp_source(chunk)),
 					     GFP_ATOMIC) < 0)
@@ -780,7 +781,6 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
-
 	/* Delay state machine commands until later.
 	 *
 	 * Re-build the bind address for the association is done in
@@ -1517,11 +1517,6 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	struct sctp_packet *packet;
 	int len;
 
-	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
-					chunk->skb))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* 6.10 Bundling
 	 * An endpoint MUST NOT bundle INIT, INIT ACK or
 	 * SHUTDOWN COMPLETE with any other chunks.
@@ -1594,6 +1589,12 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	if (!new_asoc)
 		goto nomem;
 
+	/* Update socket peer label if first association. */
+	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+		sctp_association_free(new_asoc);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+
 	if (sctp_assoc_set_bind_addr_from_ep(new_asoc,
 				sctp_scope(sctp_source(chunk)), GFP_ATOMIC) < 0)
 		goto nomem;
@@ -2255,8 +2256,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	}
 
 	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
-					chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6b937bfd4751..33391254fa82 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9412,7 +9412,6 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	struct inet_sock *inet = inet_sk(sk);
 	struct inet_sock *newinet;
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_endpoint *ep = sp->ep;
 
 	newsk->sk_type = sk->sk_type;
 	newsk->sk_bound_dev_if = sk->sk_bound_dev_if;
@@ -9457,9 +9456,9 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 		net_enable_timestamp();
 
 	/* Set newsk security attributes from original sk and connection
-	 * security attribute from ep.
+	 * security attribute from asoc.
 	 */
-	security_sctp_sk_clone(ep, sk, newsk);
+	security_sctp_sk_clone(asoc, sk, newsk);
 }
 
 static inline void sctp_copy_descendant(struct sock *sk_to,
diff --git a/security/security.c b/security/security.c
index 9ffa9e9c5c55..b0f1c007aa3b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2366,9 +2366,9 @@ int security_tun_dev_open(void *security)
 }
 EXPORT_SYMBOL(security_tun_dev_open);
 
-int security_sctp_assoc_request(struct sctp_endpoint *ep, struct sk_buff *skb)
+int security_sctp_assoc_request(struct sctp_association *asoc, struct sk_buff *skb)
 {
-	return call_int_hook(sctp_assoc_request, 0, ep, skb);
+	return call_int_hook(sctp_assoc_request, 0, asoc, skb);
 }
 EXPORT_SYMBOL(security_sctp_assoc_request);
 
@@ -2380,10 +2380,10 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 }
 EXPORT_SYMBOL(security_sctp_bind_connect);
 
-void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
+void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk)
 {
-	call_void_hook(sctp_sk_clone, ep, sk, newsk);
+	call_void_hook(sctp_sk_clone, asoc, sk, newsk);
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e7ebd45ca345..f025fc00421b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5356,10 +5356,10 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
  * connect(2), sctp_connectx(3) or sctp_sendmsg(3) (with no association
  * already present).
  */
-static int selinux_sctp_assoc_request(struct sctp_endpoint *ep,
+static int selinux_sctp_assoc_request(struct sctp_association *asoc,
 				      struct sk_buff *skb)
 {
-	struct sk_security_struct *sksec = ep->base.sk->sk_security;
+	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	u8 peerlbl_active;
@@ -5376,7 +5376,7 @@ static int selinux_sctp_assoc_request(struct sctp_endpoint *ep,
 		/* This will return peer_sid = SECSID_NULL if there are
 		 * no peer labels, see security_net_peersid_resolve().
 		 */
-		err = selinux_skb_peerlbl_sid(skb, ep->base.sk->sk_family,
+		err = selinux_skb_peerlbl_sid(skb, asoc->base.sk->sk_family,
 					      &peer_sid);
 		if (err)
 			return err;
@@ -5400,7 +5400,7 @@ static int selinux_sctp_assoc_request(struct sctp_endpoint *ep,
 		 */
 		ad.type = LSM_AUDIT_DATA_NET;
 		ad.u.net = &net;
-		ad.u.net->sk = ep->base.sk;
+		ad.u.net->sk = asoc->base.sk;
 		err = avc_has_perm(&selinux_state,
 				   sksec->peer_sid, peer_sid, sksec->sclass,
 				   SCTP_SOCKET__ASSOCIATION, &ad);
@@ -5418,11 +5418,11 @@ static int selinux_sctp_assoc_request(struct sctp_endpoint *ep,
 	if (err)
 		return err;
 
-	ep->secid = conn_sid;
-	ep->peer_secid = peer_sid;
+	asoc->secid = conn_sid;
+	asoc->peer_secid = peer_sid;
 
 	/* Set any NetLabel labels including CIPSO/CALIPSO options. */
-	return selinux_netlbl_sctp_assoc_request(ep, skb);
+	return selinux_netlbl_sctp_assoc_request(asoc, skb);
 }
 
 /* Check if sctp IPv4/IPv6 addresses are valid for binding or connecting
@@ -5507,7 +5507,7 @@ static int selinux_sctp_bind_connect(struct sock *sk, int optname,
 }
 
 /* Called whenever a new socket is created by accept(2) or sctp_peeloff(3). */
-static void selinux_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
+static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 				  struct sock *newsk)
 {
 	struct sk_security_struct *sksec = sk->sk_security;
@@ -5519,8 +5519,8 @@ static void selinux_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
 	if (!selinux_policycap_extsockclass())
 		return selinux_sk_clone_security(sk, newsk);
 
-	newsksec->sid = ep->secid;
-	newsksec->peer_sid = ep->peer_secid;
+	newsksec->sid = asoc->secid;
+	newsksec->peer_sid = asoc->peer_secid;
 	newsksec->sclass = sksec->sclass;
 	selinux_netlbl_sctp_sk_clone(sk, newsk);
 }
diff --git a/security/selinux/include/netlabel.h b/security/selinux/include/netlabel.h
index 0c58f62dc6ab..4d0456d3d459 100644
--- a/security/selinux/include/netlabel.h
+++ b/security/selinux/include/netlabel.h
@@ -39,7 +39,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
 int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
 				 u16 family,
 				 u32 sid);
-int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
+int selinux_netlbl_sctp_assoc_request(struct sctp_association *asoc,
 				     struct sk_buff *skb);
 int selinux_netlbl_inet_conn_request(struct request_sock *req, u16 family);
 void selinux_netlbl_inet_csk_clone(struct sock *sk, u16 family);
@@ -98,7 +98,7 @@ static inline int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
 	return 0;
 }
 
-static inline int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
+static inline int selinux_netlbl_sctp_assoc_request(struct sctp_association *asoc,
 						    struct sk_buff *skb)
 {
 	return 0;
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index abaab7683840..43d72f776a7d 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -268,22 +268,22 @@ int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
  * Returns zero on success, negative values on failure.
  *
  */
-int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
+int selinux_netlbl_sctp_assoc_request(struct sctp_association *asoc,
 				     struct sk_buff *skb)
 {
 	int rc;
 	struct netlbl_lsm_secattr secattr;
-	struct sk_security_struct *sksec = ep->base.sk->sk_security;
+	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
 	struct sockaddr_in addr4;
 	struct sockaddr_in6 addr6;
 
-	if (ep->base.sk->sk_family != PF_INET &&
-				ep->base.sk->sk_family != PF_INET6)
+	if (asoc->base.sk->sk_family != PF_INET &&
+	    asoc->base.sk->sk_family != PF_INET6)
 		return 0;
 
 	netlbl_secattr_init(&secattr);
 	rc = security_netlbl_sid_to_secattr(&selinux_state,
-					    ep->secid, &secattr);
+					    asoc->secid, &secattr);
 	if (rc != 0)
 		goto assoc_request_return;
 
@@ -293,11 +293,11 @@ int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
 	if (ip_hdr(skb)->version == 4) {
 		addr4.sin_family = AF_INET;
 		addr4.sin_addr.s_addr = ip_hdr(skb)->saddr;
-		rc = netlbl_conn_setattr(ep->base.sk, (void *)&addr4, &secattr);
+		rc = netlbl_conn_setattr(asoc->base.sk, (void *)&addr4, &secattr);
 	} else if (IS_ENABLED(CONFIG_IPV6) && ip_hdr(skb)->version == 6) {
 		addr6.sin6_family = AF_INET6;
 		addr6.sin6_addr = ipv6_hdr(skb)->saddr;
-		rc = netlbl_conn_setattr(ep->base.sk, (void *)&addr6, &secattr);
+		rc = netlbl_conn_setattr(asoc->base.sk, (void *)&addr6, &secattr);
 	} else {
 		rc = -EAFNOSUPPORT;
 	}
-- 
2.27.0

