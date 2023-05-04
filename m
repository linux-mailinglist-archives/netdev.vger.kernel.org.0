Return-Path: <netdev+bounces-295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F44E6F6EE3
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D6E21C211B3
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79C48F59;
	Thu,  4 May 2023 15:26:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C29FC06;
	Thu,  4 May 2023 15:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED40C4339B;
	Thu,  4 May 2023 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683213988;
	bh=3+XK7KKMb/pdWRO5jeZ+e//49MxpSglEfIQL5W5/Fe8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VibbSfUT3fdTkN9YwfRRVCuzKa8mu+tJs+5PsYLOS/v6BT6HqMrGg1YpevcKCnMsO
	 uyZgKOGmi4CgsAMIyie7xJ+Dd2dLth7NAsF6yTYeq8SbfsldDZqdYa00QFn69TxBR/
	 zabb7xki4eQnFXoKcVWOjKz094Pgy99sCnjEhg0Mc+BchTyrgKEgh35sSCzFjjBDHh
	 EtkFj5fQQkR7TQnS2AyyiOeLaZ4w8BLxHOHhe3RuxWaxjvC3Nhe8OuDz2g4oOdegJk
	 a5MAJtJzNkRIQREiiWcTja/PAEYLZV5s2eM/JhfMjWszSWony35I3G56rgiQS1FV2p
	 cx/oa9FWZlXqA==
Subject: [PATCH 5/5] net/handshake: Enable the SNI extension to work properly
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Thu, 04 May 2023 11:26:17 -0400
Message-ID: 
 <168321397496.16695.17457090959897234928.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
References: 
 <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

Enable the upper layer protocol to specify the SNI peername. This
avoids the need for tlshd to use a DNS lookup, which can return a
hostname that doesn't match the incoming certificate's SubjectName.

Fixes: 2fd5532044a8 ("net/handshake: Add a kernel API for requesting a TLSv1.3 handshake")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/netlink/specs/handshake.yaml |    4 ++++
 Documentation/networking/tls-handshake.rst |    5 +++++
 include/net/handshake.h                    |    1 +
 include/uapi/linux/handshake.h             |    1 +
 net/handshake/tlshd.c                      |    8 ++++++++
 5 files changed, 19 insertions(+)

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
index 614f1a585511..6d89e30f5fd5 100644
--- a/Documentation/netlink/specs/handshake.yaml
+++ b/Documentation/netlink/specs/handshake.yaml
@@ -68,6 +68,9 @@ attribute-sets:
         type: nest
         nested-attributes: x509
         multi-attr: true
+      -
+        name: peername
+        type: string
   -
     name: done
     attributes:
@@ -105,6 +108,7 @@ operations:
             - auth-mode
             - peer-identity
             - certificate
+            - peername
     -
       name: done
       doc: Handler reports handshake completion
diff --git a/Documentation/networking/tls-handshake.rst b/Documentation/networking/tls-handshake.rst
index a2817a88e905..6f5ea1646a47 100644
--- a/Documentation/networking/tls-handshake.rst
+++ b/Documentation/networking/tls-handshake.rst
@@ -53,6 +53,7 @@ fills in a structure that contains the parameters of the request:
         struct socket   *ta_sock;
         tls_done_func_t ta_done;
         void            *ta_data;
+        const char      *ta_peername;
         unsigned int    ta_timeout_ms;
         key_serial_t    ta_keyring;
         key_serial_t    ta_my_cert;
@@ -71,6 +72,10 @@ instantiated a struct file in sock->file.
 has completed. Further explanation of this function is in the "Handshake
 Completion" sesction below.
 
+The consumer can provide a NUL-terminated hostname in the @ta_peername
+field that is sent as part of ClientHello. If no peername is provided,
+the DNS hostname associated with the server's IP address is used instead.
+
 The consumer can fill in the @ta_timeout_ms field to force the servicing
 handshake agent to exit after a number of milliseconds. This enables the
 socket to be fully closed once both the kernel and the handshake agent
diff --git a/include/net/handshake.h b/include/net/handshake.h
index 3352b1ab43b3..2e26e436e85f 100644
--- a/include/net/handshake.h
+++ b/include/net/handshake.h
@@ -24,6 +24,7 @@ struct tls_handshake_args {
 	struct socket		*ta_sock;
 	tls_done_func_t		ta_done;
 	void			*ta_data;
+	const char		*ta_peername;
 	unsigned int		ta_timeout_ms;
 	key_serial_t		ta_keyring;
 	key_serial_t		ta_my_cert;
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
index 1de4d0b95325..3d7ea58778c9 100644
--- a/include/uapi/linux/handshake.h
+++ b/include/uapi/linux/handshake.h
@@ -44,6 +44,7 @@ enum {
 	HANDSHAKE_A_ACCEPT_AUTH_MODE,
 	HANDSHAKE_A_ACCEPT_PEER_IDENTITY,
 	HANDSHAKE_A_ACCEPT_CERTIFICATE,
+	HANDSHAKE_A_ACCEPT_PEERNAME,
 
 	__HANDSHAKE_A_ACCEPT_MAX,
 	HANDSHAKE_A_ACCEPT_MAX = (__HANDSHAKE_A_ACCEPT_MAX - 1)
diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
index fcbeb63b4eb1..b735f5cced2f 100644
--- a/net/handshake/tlshd.c
+++ b/net/handshake/tlshd.c
@@ -31,6 +31,7 @@ struct tls_handshake_req {
 	int			th_type;
 	unsigned int		th_timeout_ms;
 	int			th_auth_mode;
+	const char		*th_peername;
 	key_serial_t		th_keyring;
 	key_serial_t		th_certificate;
 	key_serial_t		th_privkey;
@@ -48,6 +49,7 @@ tls_handshake_req_init(struct handshake_req *req,
 	treq->th_timeout_ms = args->ta_timeout_ms;
 	treq->th_consumer_done = args->ta_done;
 	treq->th_consumer_data = args->ta_data;
+	treq->th_peername = args->ta_peername;
 	treq->th_keyring = args->ta_keyring;
 	treq->th_num_peerids = 0;
 	treq->th_certificate = TLS_NO_CERT;
@@ -214,6 +216,12 @@ static int tls_handshake_accept(struct handshake_req *req,
 	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MESSAGE_TYPE, treq->th_type);
 	if (ret < 0)
 		goto out_cancel;
+	if (treq->th_peername) {
+		ret = nla_put_string(msg, HANDSHAKE_A_ACCEPT_PEERNAME,
+				     treq->th_peername);
+		if (ret < 0)
+			goto out_cancel;
+	}
 	if (treq->th_timeout_ms) {
 		ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_TIMEOUT, treq->th_timeout_ms);
 		if (ret < 0)



