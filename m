Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3B4371EB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhJVGiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhJVGin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:38:43 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C589C061348;
        Thu, 21 Oct 2021 23:36:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 84-20020a1c0457000000b003232b0f78f8so2252579wme.0;
        Thu, 21 Oct 2021 23:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OMTHXd8wN4GVMk0Y4plvW3FHJIOJ3hhBVSqFzI3gXh8=;
        b=HIuNuZ0b7dRAjLD2nbXuMYcoaGZe/XeIghr+tDs0dRNncd7k7zeE7ZYpjuA6XfdfKo
         oNBnMrLVU7bwcR/zg2h2Ol6vhGI7Icj4U4WYBl0JLXU3hdUnS00u+aQqJDU9SnIWouwY
         jHYobNiIRyPuV23xEB6Bu/Pmtlsf0cJhhlq4nvl9Sj0r3NopGhtVWJPlPhjuuMJuoeGx
         l8PkwBDnzZivrtEs/HSp95bCmyDi73rOmwDZK6c85N7cCuL6VKMEUQxGjB29VtitG8Nx
         siexKOhsSqNJ/MRnEz+xgEIfHK61OVuri/TgC7ixONVPrzzeSLeJYI3vNvrwEmcZAcMT
         nlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OMTHXd8wN4GVMk0Y4plvW3FHJIOJ3hhBVSqFzI3gXh8=;
        b=tYHIPGTy6V8l11p2OwFTfdGXLeTEHMV9+pUSTNnKtKf4QSz1bamF1gcJNSDpseItsJ
         d1nby+UKocCyBmbo8Hski9PZpSMDr0ofbCl8Oz3PGKV64hkgfCiy11jhoWHx/HuK9Pfy
         OxedSx+SwAhqDeyk9EbSyFsMhEb0kH4ccaEZhvCpKbToQZ98CK6xO4MdkFIx5lC2DO/V
         t5v36ZrWqiX4HDo3hWKOThqn1fJR0GtWQapy1edrAj7+foD5rGwAyxqMxEC3Xqp0cGDl
         dVfcDdxzyQCxcbm+dChUpVcY9hf1dUtioJIg9xOr5O5Ye40m/HtGjy/7WRhYUXg9o5PD
         7mAA==
X-Gm-Message-State: AOAM533UxWXoMx5ZbEkA5whrDpbbW9+N7qQs5aWaA6vIpVKharJlcHPY
        E2pYVVPJxmA4qjATB7XHhvj2SrxkMWbaUQ==
X-Google-Smtp-Source: ABdhPJxzQlQy4TNVePaviOD9GDlRbEH1LQSF0FeAONWtQx9S/YtUtPtk+qpAbQLydO/8p76ClAgBQA==
X-Received: by 2002:a1c:4d06:: with SMTP id o6mr26554591wmh.137.1634884584007;
        Thu, 21 Oct 2021 23:36:24 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c7sm4099733wrp.51.2021.10.21.23.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:36:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH net 4/4] security: implement sctp_assoc_established hook in selinux
Date:   Fri, 22 Oct 2021 02:36:12 -0400
Message-Id: <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634884487.git.lucien.xin@gmail.com>
References: <cover.1634884487.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Different from selinux_inet_conn_established(), it also gives the
secid to asoc->peer_secid in selinux_sctp_assoc_established(),
as one UDP-type socket may have more than one asocs.

Note that peer_secid in asoc will save the peer secid for this
asoc connection, and peer_sid in sksec will just keep the peer
secid for the latest connection. So the right use should be do
peeloff for UDP-type socket if there will be multiple asocs in
one socket, so that the peeloff socket has the right label for
its asoc.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 security/selinux/hooks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f025fc00421b..793fdcbc68bd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5525,6 +5525,21 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
 	selinux_netlbl_sctp_sk_clone(sk, newsk);
 }
 
+static void selinux_sctp_assoc_established(struct sctp_association *asoc,
+					   struct sk_buff *skb)
+{
+	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
+	u16 family = asoc->base.sk->sk_family;
+
+	/* handle mapped IPv4 packets arriving via IPv6 sockets */
+	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
+		family = PF_INET;
+
+	selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
+	asoc->secid = sksec->sid;
+	asoc->peer_secid = sksec->peer_sid;
+}
+
 static int selinux_inet_conn_request(const struct sock *sk, struct sk_buff *skb,
 				     struct request_sock *req)
 {
@@ -7290,6 +7305,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
 	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
 	LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
+	LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
 	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
 	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
 	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
-- 
2.27.0

