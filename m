Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4202DC950
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgLPW5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgLPW5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:57:31 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3647C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 14:56:50 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r7so24729571wrc.5
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 14:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ppb1L5L02MNXoAquol9CcaGpIxhRLJqE0QFisycBhlQ=;
        b=e8Za54qPO1RZAbu+3sQUq7F/OUjZwd/u+7zr/SwNemwoOVp30cU4nZ1VabJ6x6GwTi
         PczXuixZjg0FSaKozjTDjsVSbXomS/H5JwTYxy+FCykUwEwEMCtlvBczOi3MfJbL/D32
         PgbkpBi6okOgX/Zudb6SUAywJF40spTxmw5uaja++5c+I4CBqnBsw9Ljj8L2C5qk4EXU
         crlO69+TN2QLlCYlZOM2xksAZ8xUNX6m/ACB6H8Iw7ufcMrm/xqqOUqb1/BD2h+I2QHY
         l3S9iv7e3m0tIdedxmqMR7hJAX8gQwu10jJ47HgTz7M/2TH3G+6zu2AxXVlwHNc/r8Xu
         16IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ppb1L5L02MNXoAquol9CcaGpIxhRLJqE0QFisycBhlQ=;
        b=OvFGPZM84NOERaylQQozqaytopxaZmGuGRWut9LSDa3haofQmkk6KqEh3gGAqn/x0F
         lhi3emG1+5DTWsHk2urseZfl3cu7wA/92uqR6pc2kJuWM1AegXQJKSC0EzkIWMmH2Mag
         2MpIsZ79mgVo+DM5j2GfCipKw+lfphMskI40YBzIlz7JWgWnRZTBUoWBRN63HkhLQO6A
         IWA5pZa88RfRfVEFzPm5QkwnDIKEBOl208vaYJ56qSvitcsD81BuEPlddxvqjD2F9oIW
         hBKY3vS4LOOE07/GdBtHomwyYde56vsuThjyGhKlo617Q8T4rjI/bmd8Eled2UKj73vQ
         VvDQ==
X-Gm-Message-State: AOAM533+miBLUzqEHomZvXMqdYTvgC/A1YMiOujq8M6XaH4j2mSPbC45
        +pHhnh8DiHVFCYyDWuORlQ2bmg==
X-Google-Smtp-Source: ABdhPJzrsZElhJ/bJEcwen2Q0Pocp6eulCQhUJK9HZmPrpRHse5r6jwEKKzaMG6ofq+xLqr/ec2Wbg==
X-Received: by 2002:adf:eb91:: with SMTP id t17mr40501980wrn.330.1608159409664;
        Wed, 16 Dec 2020 14:56:49 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id i4sm5719361wri.88.2020.12.16.14.56.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Dec 2020 14:56:49 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com, netdev@vger.kernel.org
Cc:     Victor Stewart <v@nametag.social>
Subject: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
Date:   Wed, 16 Dec 2020 22:56:48 +0000
Message-Id: <20201216225648.48037-1-v@nametag.social>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds PROTO_CMSG_DATA_ONLY to inet_dgram_ops and inet6_dgram_ops so that UDP_SEGMENT (GSO) and UDP_GRO can be used through io_uring.

GSO and GRO are vital to bring QUIC servers on par with TCP throughputs, and together offer a higher
throughput gain than io_uring alone (rate of data transit
considering), thus io_uring is presently the lesser performance choice.

RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
GSO is about +~63% and GRO +~82%.

this patch closes that loophole.

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

