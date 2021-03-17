Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A433F48B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 16:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhCQPu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 11:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbhCQPul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 11:50:41 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C5FC061763
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 08:50:34 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id r18so10845333wmq.5
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 08:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eZ0IaSrEKtqBhBUO7kHmyEE/SbgsMqZRhisBRsFJTV8=;
        b=V7xt+yDM9UTZWAWIMbyOEfzgodCexInv09lKBQeNYN2aA78GKy7WIK53kbxOX9B23W
         WxTx6CZLYLVA6LkesJXPxaGgrXwZimaNJ4dsPBZ5QceNimMaXO+P00UEq1sMsn3jxo9x
         wjR98ct7z+GYONYBiOibp11AaMMk/icEbxM5To7snSBEvfrEHtNmRzfQjkj9EDvYrO1i
         OlMipoxsiKGPvjTRGHJJkvTlSLMvx34p3FU+1gMB0mkED+TO64NxyuoSlaCsmTdUsGiF
         BUa2vKUl8YWz2AQIBJ9Ildoiw6Mxb0mVxtArWBdkhxNsUAX6urwDA1nEifC7tCCb2FrV
         hTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eZ0IaSrEKtqBhBUO7kHmyEE/SbgsMqZRhisBRsFJTV8=;
        b=pCkk7NZISzx0AMzEvD3Zheu1yDlkO0BgfXwMNHhUw4AXi9Uyv4iVYRFo5cnSr1WhtZ
         eezvxH+mJI3EXQmyH2gbxU75NFVF8Ri+IMpdkgU56UgPYdwZMC7kYiRVGa6gxuSPscVQ
         IHHX938cBDZk4btVZWJJliuGf5hn4tOL/638rTDYRRlUPDXWiDYa53hSwJcDc0OKXEPy
         VGUd0SRHAWsJHPOKCIJG9KZeCuKcRhaVyxddofVI4a8IBXjCz5OzkcZhFn3K7bFGENhk
         Ew6fYP+pIezOHfUNUrqlPzG5Y26bDrW9hqD9G7S3o8rNnn7RD77CjL5qo0PTyrAFLyeE
         aoyA==
X-Gm-Message-State: AOAM532/Xy/nPGJdrXXiaQNzOh31WCfoI7Yc3CMG8p6PhYKzp6boA9d0
        0zA8AfkLrphguYFNXhcmLtPSWBj7vC9WRg==
X-Google-Smtp-Source: ABdhPJyAihfXcNLMxfLmDlNAy51x1RvGzXsVoVv2S0gp0kZBj642cmMzEdhuNg+IZnCFBE0gBLfzQVJ5F/cmeA==
X-Received: from dbrazdil.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:a7b:cb89:: with SMTP id
 m9mr4267737wmi.27.1615995892631; Wed, 17 Mar 2021 08:44:52 -0700 (PDT)
Date:   Wed, 17 Mar 2021 15:44:48 +0000
Message-Id: <20210317154448.1034471-1-dbrazdil@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] selinux: vsock: Set SID for socket returned by accept()
From:   David Brazdil <dbrazdil@google.com>
To:     selinux@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alistair Delva <adelva@google.com>,
        David Brazdil <dbrazdil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For AF_VSOCK, accept() currently returns sockets that are unlabelled.
Other socket families derive the child's SID from the SID of the parent
and the SID of the incoming packet. This is typically done as the
connected socket is placed in the queue that accept() removes from.

Implement an LSM hook 'vsock_sk_clone' that takes the parent (server)
and child (connection) struct socks, and assigns the parent SID to the
child. There is no packet SID in this case.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
This is my first patch in this part of the kernel so please comment if I
missed anything, specifically whether there is a packet SID that should
be mixed into the child SID.

Tested on Android.

 include/linux/lsm_hook_defs.h |  1 +
 include/linux/lsm_hooks.h     |  7 +++++++
 include/linux/security.h      |  5 +++++
 net/vmw_vsock/af_vsock.c      |  1 +
 security/security.c           |  5 +++++
 security/selinux/hooks.c      | 10 ++++++++++
 6 files changed, 29 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 477a597db013..f35e422b2b5c 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -329,6 +329,7 @@ LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
 LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_endpoint *ep,
 	 struct sock *sk, struct sock *newsk)
+LSM_HOOK(void, LSM_RET_VOID, vsock_sk_clone, struct sock *sock, struct sock *newsk)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index fb7f3193753d..1b4e92990401 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1033,6 +1033,13 @@
  *	@sk pointer to current sock structure.
  *	@sk pointer to new sock structure.
  *
+ * Security hooks for vSockets
+ *
+ * @vsock_sk_clone:
+ *	Clone SID from the server socket to a newly connected child socket.
+ *	@sock contains the sock structure.
+ *	@newsk contains the new sock structure.
+ *
  * Security hooks for Infiniband
  *
  * @ib_pkey_access:
diff --git a/include/linux/security.h b/include/linux/security.h
index 8aeebd6646dc..ffac67058355 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1404,6 +1404,7 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
 void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
 			    struct sock *newsk);
+void security_vsock_sk_clone(struct sock *sock, struct sock *newsk);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1623,6 +1624,10 @@ static inline void security_sctp_sk_clone(struct sctp_endpoint *ep,
 					  struct sock *newsk)
 {
 }
+
+static inline void security_vsock_sk_clone(struct sock *sock, struct sock *newsk)
+{
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5546710d8ac1..a9bf3b90cb2f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -755,6 +755,7 @@ static struct sock *__vsock_create(struct net *net,
 		vsk->buffer_size = psk->buffer_size;
 		vsk->buffer_min_size = psk->buffer_min_size;
 		vsk->buffer_max_size = psk->buffer_max_size;
+		security_vsock_sk_clone(parent, sk);
 	} else {
 		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
diff --git a/security/security.c b/security/security.c
index 5ac96b16f8fa..050b653405e0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2335,6 +2335,11 @@ void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
+void security_vsock_sk_clone(struct sock *sock, struct sock *newsk)
+{
+	call_void_hook(vsock_sk_clone, sock, newsk);
+}
+EXPORT_SYMBOL(security_vsock_sk_clone);
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ddd097790d47..7b92d6f2e0fd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5616,6 +5616,15 @@ static int selinux_tun_dev_open(void *security)
 	return 0;
 }
 
+static void selinux_socket_vsock_sk_clone(struct sock *sock, struct sock *newsk)
+{
+	struct sk_security_struct *sksec_sock = sock->sk_security;
+	struct sk_security_struct *sksec_new = newsk->sk_security;
+
+	/* Always returns 0 when packet SID is SECSID_NULL. */
+	WARN_ON_ONCE(selinux_conn_sid(sksec_sock->sid, SECSID_NULL, &sksec_new->sid));
+}
+
 #ifdef CONFIG_NETFILTER
 
 static unsigned int selinux_ip_forward(struct sk_buff *skb,
@@ -7228,6 +7237,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
+	LSM_HOOK_INIT(vsock_sk_clone, selinux_socket_vsock_sk_clone),
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
 	LSM_HOOK_INIT(ib_endport_manage_subnet,
-- 
2.31.0.rc2.261.g7f71774620-goog

