Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075384B36E7
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 18:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiBLR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 12:59:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiBLR7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 12:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D517A2FFF1
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 09:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644688769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CI5DWcgVgXaBLSoxyZxDnI72khnbfvnjog5cb0lN2+E=;
        b=R7rT07Dz8zBJoqyZvsNQLyFJQfeimuqQnTy8CmRlTFiVMhVCXTp4ezvj4/PTIgbY0iUnkC
        mNR3vHnzGOcTnIYRUs+IjJITTNEz7yYyJThryMrRadp/EGRgKeJFGiL1jYzfmj7EF58zcy
        QnGm31ykTDx2BgWa/MyfJ6hoknF4Bko=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-uEFangx2OZ6dDtVR2UjMfA-1; Sat, 12 Feb 2022 12:59:27 -0500
X-MC-Unique: uEFangx2OZ6dDtVR2UjMfA-1
Received: by mail-ed1-f71.google.com with SMTP id r11-20020a508d8b000000b00410a4fa4768so166931edh.9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 09:59:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CI5DWcgVgXaBLSoxyZxDnI72khnbfvnjog5cb0lN2+E=;
        b=3xMAkeTbrWMP70DjS77Byy6cbBo0zzYONJ8moYirap/8psIKFSwSu3Dr8t+Y0k38hd
         fJmJU9u/17XgP0J9TN/4Wi7eMM+e4CrBQzZsFEwJvBRCSZt10S2zeKJh8ZojVOSKFVpv
         EGSft/IkGx/NvhZKpNKUHW9SUkDiCn2siUbMW93MpVS1jA9ZpblRtDgBfmjcyNW3moke
         tTFOsav/hPjLQ4wYh1jJOSZAVcZ+z7J49d46qeV6RFp8fjVfknXFanrRvZJ2C/2I0ouj
         PNJ595OXqRqVKY27NtnHxNoHVBknwoYQlBaKe+meg8bxFWi9+8bhCVTIi+Qm3gzpRnV0
         /QEg==
X-Gm-Message-State: AOAM532N0SCfqz5NsuPlkiXJmvpOoSa3jrjGzvLJwj13AT+Dq87YmsoD
        EhJjVgDSf8Uxh2/YxYug4fbnn52vRpJlvwi/JL6LSa6/4dDOeGosuq6YjhaGpWrVYX8XDwjMFay
        klU6QTlc8goU04yVKSUoaHdRj7vyY5RcJIcbFQcYoGKXbRnIHMkqhQx3ElDS6cY+sIFmY
X-Received: by 2002:aa7:ccd3:: with SMTP id y19mr4534398edt.390.1644688766304;
        Sat, 12 Feb 2022 09:59:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvuw6Om31pBIP7clC++J760LvFX06IDLOmBcntLIHzGLV3OH4CIY72Tq3NdhpaVsjrIfHJWw==
X-Received: by 2002:aa7:ccd3:: with SMTP id y19mr4534374edt.390.1644688766046;
        Sat, 12 Feb 2022 09:59:26 -0800 (PST)
Received: from localhost.localdomain ([2a02:8308:b106:e300:32b0:6ebb:8ca4:d4d3])
        by smtp.gmail.com with ESMTPSA id d10sm437409ejo.207.2022.02.12.09.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 09:59:25 -0800 (PST)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prashanth Prahlad <pprahlad@redhat.com>
Subject: [PATCH net v3 1/2] security: add sctp_assoc_established hook
Date:   Sat, 12 Feb 2022 18:59:21 +0100
Message-Id: <20220212175922.665442-2-omosnace@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220212175922.665442-1-omosnace@redhat.com>
References: <20220212175922.665442-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

security_sctp_assoc_established() is added to replace
security_inet_conn_established() called in
sctp_sf_do_5_1E_ca(), so that asoc can be accessed in security
subsystem and save the peer secid to asoc->peer_secid.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Based-on-patch-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 Documentation/security/SCTP.rst | 22 ++++++++++------------
 include/linux/lsm_hook_defs.h   |  2 ++
 include/linux/lsm_hooks.h       |  5 +++++
 include/linux/security.h        |  8 ++++++++
 net/sctp/sm_statefuns.c         |  8 +++++---
 security/security.c             |  7 +++++++
 6 files changed, 37 insertions(+), 15 deletions(-)

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
index a5a724c308d8..45931d81ccc3 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -332,6 +332,8 @@ LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
 LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
+LSM_HOOK(int, 0, sctp_assoc_established, struct sctp_association *asoc,
+	 struct sk_buff *skb)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 3bf5c658bc44..419b5febc3ca 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1046,6 +1046,11 @@
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
index 6d72772182c8..25b3ef71f495 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1422,6 +1422,8 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
 void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk);
+int security_sctp_assoc_established(struct sctp_association *asoc,
+				    struct sk_buff *skb);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1641,6 +1643,12 @@ static inline void security_sctp_sk_clone(struct sctp_association *asoc,
 					  struct sock *newsk)
 {
 }
+
+static inline int security_sctp_assoc_established(struct sctp_association *asoc,
+						  struct sk_buff *skb)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index cc544a97c4af..7f342bc12735 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -930,6 +930,11 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Set peer label for connection. */
+	if (security_sctp_assoc_established((struct sctp_association *)asoc,
+					    chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Verify that the chunk length for the COOKIE-ACK is OK.
 	 * If we don't do this, any bundled chunks may be junked.
 	 */
@@ -945,9 +950,6 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
 
-	/* Set peer label for connection. */
-	security_inet_conn_established(ep->base.sk, chunk->skb);
-
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
 	 * E) Upon reception of the COOKIE ACK, endpoint "A" will move
diff --git a/security/security.c b/security/security.c
index e649c8691be2..9663ffcca4b0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2393,6 +2393,13 @@ void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
+int security_sctp_assoc_established(struct sctp_association *asoc,
+				    struct sk_buff *skb)
+{
+	return call_int_hook(sctp_assoc_established, 0, asoc, skb);
+}
+EXPORT_SYMBOL(security_sctp_assoc_established);
+
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
-- 
2.34.1

