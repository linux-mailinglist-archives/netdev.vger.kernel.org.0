Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D80F2DC5D9
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgLPSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgLPSED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:04:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBAAC06138C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 10:03:20 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id e25so3329643wme.0
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 10:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eCSvCN7b1yDwYZq88Y7ccUTykwBJvil9q+CKf7WjEIY=;
        b=3psfpBDzfDjJRlWbknDPBfp2rgEly50U1OTWV084JlvLH8gCNr7kCO6Tq4R9NEnDf+
         CE3j6/sznPoS5Ey/sWQuvVJsfBoTlcFQYHaf3UbmfB0dVj3B9SHxyEzKEma4hGIO+/MK
         qB6NIK4/sbCnId6G5MUgLkMDQfDIDuapuDVLHb41DNY5Xzgmeu/lABmdFwpHC2pqIH2j
         krokPxOnLZpB/HlURzFJhxwO3gbEC4nxa63aG7grNOLAS+F5NyvB5T8qE0h7490t753v
         UpenX4+crKBYLPIcCk3utg+yMtiioewcJL2NUI9FYaH/LBUfPCr/bvQlAokXQBXKkHx7
         jyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCSvCN7b1yDwYZq88Y7ccUTykwBJvil9q+CKf7WjEIY=;
        b=rYVj5MR3DhP3QYIacYZSOvs7h8gMoc1CKUqYbe+xQtTNQD4fW6r7m9g3TL/SCCaUgW
         pFxVtk46lsPG+3tC4cQlCxRpJpuDRlVS1KRitl1jdyQ1ysxZP9D7oxVV2JUKHCp295Sv
         f5AN/j1Kz5tL/usS5GZYPHPpG/2QRQhlYAGiuGwAK/wA6OvZr+M7lZJ1tq5Ti48CUG3X
         jFAEahRE391lf7CCiFtRFeHCgdfKDlSqmldS9Y6+Xpb6g45uj8rghd4f1Zggcq/LlCue
         G4DfSnvgTrrQPlD0gwe1krCO4kkAAB9b2tw9wH/Dhuw2x/37e5i049/LuW2RbFNb1gYk
         FK3w==
X-Gm-Message-State: AOAM533kNKz95QFVj69AUYCpUcQP3oonJilW+idFyEekpJ/xnY84bd3a
        pYbE4zat3ZMqFSdHLt1T2LoINg==
X-Google-Smtp-Source: ABdhPJyDeMhepAElK9BoM+AIoWZXywyd6pt1XZcV3B5t3k1YQTXYGmnaorRDuxOU6f5SsZHvntsh8Q==
X-Received: by 2002:a1c:1bc6:: with SMTP id b189mr4495026wmb.71.1608141799158;
        Wed, 16 Dec 2020 10:03:19 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id b13sm4311281wrt.31.2020.12.16.10.03.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Dec 2020 10:03:18 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com, netdev@vger.kernel.org
Cc:     Victor Stewart <v@nametag.social>
Subject: [PATCH net-next v4] udp:allow UDP cmsghdrs through io_uring
Date:   Wed, 16 Dec 2020 18:03:13 +0000
Message-Id: <20201216180313.46610-2-v@nametag.social>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216180313.46610-1-v@nametag.social>
References: <20201216180313.46610-1-v@nametag.social>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Victor Stewart <v@nametag.social>
---
 net/ipv4/af_inet.c  | 1 +
 net/ipv6/af_inet6.c | 1 +
 net/socket.c        | 8 +++++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b7260c8cef2e..c9fd5e7cfd6e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1052,6 +1052,7 @@ EXPORT_SYMBOL(inet_stream_ops);
 
 const struct proto_ops inet_dgram_ops = {
 	.family		   = PF_INET,
+	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,
 	.bind		   = inet_bind,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb167..560f45009d06 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops = {
 
 const struct proto_ops inet6_dgram_ops = {
 	.family		   = PF_INET6,
+	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
diff --git a/net/socket.c b/net/socket.c
index 6e6cccc2104f..6995835d6355 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2416,9 +2416,11 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
+	if (msg->msg_control || msg->msg_controllen) {
+		/* disallow ancillary data reqs unless cmsg is plain data */
+		if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
+			return -EINVAL;
+	}
 
 	return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
-- 
2.26.2

