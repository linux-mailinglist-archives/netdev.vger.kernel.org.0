Return-Path: <netdev+bounces-662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7408A6F8D39
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 268D6281189
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6946A10E6;
	Sat,  6 May 2023 00:47:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF12621;
	Sat,  6 May 2023 00:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3B4C433D2;
	Sat,  6 May 2023 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683334071;
	bh=eTxFe8I0usIgXQc4fJI8zUjobHNfAGGIsd3NKKltHMQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VoPlxoH+/9NOT+F5fs9KAOGn0+MjOe5UFJNBfH1tv2fqxLhsmKTfHtcdSV0tSrkdq
	 g0clwzOkGin6jdAv+1bZEGK6NEDc/2GLqaB6fyJoh6eiO+cCzCuW47Mic9tT/gfMPq
	 hQ7JQSOrnlaiPDDkjgBx4V1GggnrEW1A3tifw/fUbp8xdAYykkmmej6ug7XnN9gVrL
	 HBtPx3socnUbW+wH04kAag0s55Bf/0kyggS2isoK8BZZ4zWlN8y8vQvWO3C/3yafDX
	 LRra8BQ1Nrcy67oa7+L2hyz05cwVy/a6a9Jq0j3tGYZLNPNYVR+ouoR7Blrzh0WCur
	 moPRmro1//Wew==
Subject: [PATCH v2 6/6] net/handshake: Enable the SNI extension to work
 properly
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:47:40 -0400
Message-ID: 
 <168333405010.7813.3126925595560504793.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
References: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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



