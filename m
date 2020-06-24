Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D72207D84
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 22:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406710AbgFXUen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 16:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406695AbgFXUeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 16:34:37 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BD6C061573;
        Wed, 24 Jun 2020 13:34:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id e11so3232136qkm.3;
        Wed, 24 Jun 2020 13:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+1rdjNbNhNdSQ1AVA+fZ00uP3B7DPUsKONFybd/2Sg=;
        b=DfmigqBIaoNQSbQtf1CVZ7JFr8EJ5NmREQnOiiz/pvkx6iSiiyrvkwGR3sn3hnpBNO
         CdKLfKuH8NNZinFpCy5RHwo2kcgSIyWJkfVAR+pebuwGQUv2ngMGrCnq5Efy0AHO4g1p
         sf3BUSWo/LdIAd2wIrYFzrcp4OsqJzrxVc4J6sB5PozGnSIn9JISk2ZdcY5DePnjWGtI
         C4mPMi3MnH4dqQhBVItzXR4prmjN+4/bKUoOxpRU9tc6yVLRQxjtSWVVVYkXoZEtZUSb
         iWLd+BP6HU49xzsf5GXM7H6qlIGaOVGG+bC1j8i88/NM+kI6oREDS4mtam5teVeEX8ui
         E07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+1rdjNbNhNdSQ1AVA+fZ00uP3B7DPUsKONFybd/2Sg=;
        b=NrASBKeg6IW8nz6Cd2wz4hOKepqXL/PmUZ0wKYfeKKHRIGkaEoMWFkJJAjNQ3wgizM
         b85SeXHR5RnqiS4ffMfmAXdkAnpSKDQ/RHTR7Qw+MfTSPNkRLEAJEhlidZMYK/O+I+cE
         /2RLtngRxdszf//Zpon/7FPpClOX7nN+Dqq8Qk96AkK+N34toqXkKsgVuAW1crkGCUuU
         Ns/WsdvV1fFKOoFhfZvOu5Esuui3xzAlwjc4hI9wTsH1E0TkGKBT8i6Eh+p2HVg4Bnj6
         KagYhIWLwuxTEWGSTFDWSZ1c/g7pm7Db2ip8RodW3KG/EOsqwxUMao4wC6Re2Pwco3C6
         dNsA==
X-Gm-Message-State: AOAM533axYeVMN9kxSmgQjEhh/mbZ61x3v/hXf7H7Y1XFbNDWIOgNiLq
        x20C4Sx4udk2fee09/Qt3R4=
X-Google-Smtp-Source: ABdhPJyYFaRLGtudowV2QjaffD6oveDWFZYYeKjON25l+rUq1NyRhmcLrGXCQUF68bfsRc79oJGErA==
X-Received: by 2002:a37:70d:: with SMTP id 13mr9285584qkh.366.1593030876192;
        Wed, 24 Jun 2020 13:34:36 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.113])
        by smtp.gmail.com with ESMTPSA id d186sm4006074qkb.110.2020.06.24.13.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 13:34:35 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5D0F3C3123; Wed, 24 Jun 2020 17:34:32 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Michael Tuexen <Michael.Tuexen@lurchi.franken.de>,
        Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH net] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Date:   Wed, 24 Jun 2020 17:34:18 -0300
Message-Id: <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623160417.12418-1-minyard@acm.org>
References: <20200623160417.12418-1-minyard@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a socket is set ipv6only, it will still send IPv4 addresses in the
INIT and INIT_ACK packets. This potentially misleads the peer into using
them, which then would cause association termination.

The fix is to not add IPv4 addresses to ipv6only sockets.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/constants.h | 8 +++++---
 net/sctp/associola.c         | 5 ++++-
 net/sctp/bind_addr.c         | 1 +
 net/sctp/protocol.c          | 3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 15b4d9aec7ff278e67a7183f10c14be237227d6b..122d9e2d8dfde33b787d575fc42d454732550698 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -353,11 +353,13 @@ enum {
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
-#define SCTP_ADDR6_ALLOWED	0x00000001	/* IPv6 address is allowed by
+#define SCTP_ADDR4_ALLOWED	0x00000001	/* IPv4 address is allowed by
 						   local sock family */
-#define SCTP_ADDR4_PEERSUPP	0x00000002	/* IPv4 address is supported by
+#define SCTP_ADDR6_ALLOWED	0x00000002	/* IPv6 address is allowed by
+						   local sock family */
+#define SCTP_ADDR4_PEERSUPP	0x00000004	/* IPv4 address is supported by
 						   peer */
-#define SCTP_ADDR6_PEERSUPP	0x00000004	/* IPv6 address is supported by
+#define SCTP_ADDR6_PEERSUPP	0x00000008	/* IPv6 address is supported by
 						   peer */
 
 /* Reasons to retransmit. */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 72315137d7e7f20d5182291ef4b01102f030078b..8d735461fa196567ab19c583703aad098ef8e240 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1565,12 +1565,15 @@ void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned int len)
 int sctp_assoc_set_bind_addr_from_ep(struct sctp_association *asoc,
 				     enum sctp_scope scope, gfp_t gfp)
 {
+	struct sock *sk = asoc->base.sk;
 	int flags;
 
 	/* Use scoping rules to determine the subset of addresses from
 	 * the endpoint.
 	 */
-	flags = (PF_INET6 == asoc->base.sk->sk_family) ? SCTP_ADDR6_ALLOWED : 0;
+	flags = (PF_INET6 == sk->sk_family) ? SCTP_ADDR6_ALLOWED : 0;
+	if (!inet_v6_ipv6only(sk))
+		flags |= SCTP_ADDR4_ALLOWED;
 	if (asoc->peer.ipv4_address)
 		flags |= SCTP_ADDR4_PEERSUPP;
 	if (asoc->peer.ipv6_address)
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 53bc61537f44f4e766c417fcef72234df52ecd04..701c5a4e441d9c248df9472f22db5b78987f9e44 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -461,6 +461,7 @@ static int sctp_copy_one_addr(struct net *net, struct sctp_bind_addr *dest,
 		 * well as the remote peer.
 		 */
 		if ((((AF_INET == addr->sa.sa_family) &&
+		      (flags & SCTP_ADDR4_ALLOWED) &&
 		      (flags & SCTP_ADDR4_PEERSUPP))) ||
 		    (((AF_INET6 == addr->sa.sa_family) &&
 		      (flags & SCTP_ADDR6_ALLOWED) &&
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 092d1afdee0d23cd974210839310fbf406dd443f..cde29f3c7fb3c40ee117636fa3b4b7f0a03e4fba 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -148,7 +148,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 		 * sock as well as the remote peer.
 		 */
 		if (addr->a.sa.sa_family == AF_INET &&
-		    !(copy_flags & SCTP_ADDR4_PEERSUPP))
+		    (!(copy_flags & SCTP_ADDR4_ALLOWED) ||
+		     !(copy_flags & SCTP_ADDR4_PEERSUPP)))
 			continue;
 		if (addr->a.sa.sa_family == AF_INET6 &&
 		    (!(copy_flags & SCTP_ADDR6_ALLOWED) ||
-- 
2.25.4

