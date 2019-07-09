Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6AB62E58
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfGICxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42812 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbfGICxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id h18so12770863qtm.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sl59QAW5wo3vEat4HoeUGFuiXd7xAyZc3PqKJkgCtJE=;
        b=OQ9v2/S/aAwy+A0OGAqLxtk3jKPoYrbGYy7pMbksSTdysopl/zmnzLdwT2KyImJ3Sw
         HfRZXPyn9lsm+bK0qiTKF25lMnFbWcV9ZmqbmCGxQhcRm6j4ZMzTYk4f1YjELj7MeI1c
         pQHTWIzzDmBLEC1PNaFp8g6hRcYjbI1VHcA/Ng4ILzvG+lSVHA65LnL1DKj7JLhEkJSI
         /9bD60ovaUO9nHP/Z7HxY0IdJvQZ2Anh7bm2c/5ib+TMCvgZC4AZdgjvR59erXZrg75+
         ksdzzQk+kB+DmWj8fnfWDaQYzqLqjj5bJPxuLx+b9s1qIqYHt8CNwM5hoOcbfDHmYZzK
         zAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sl59QAW5wo3vEat4HoeUGFuiXd7xAyZc3PqKJkgCtJE=;
        b=Lc/IbTkGXbLoVMJ70pbKGgRfL9nX9apekK4Uk+1zTosfqBLA4eJPDg/vkp3H58thwV
         KZd6KFihaeCW5Mbuu66vfEvfGojlPw7z7WNLSluujI+Qb6LAFXUuYzzqydZWRvZaFN5p
         H7wQ2keXkAAMT+/H8j9eSnsaEhX1oE4NfkSJ/pq8BI3Rw3+rDaeJBiWKl08Hnetq4XWv
         vtCc7eZqCnP1kr2iD7N2oGpot0jWJr55fVt1Hj11fVIXR77fQxjOSzQxatgEKkPFsVLh
         b8VuMsoqyDTA+yZaRSrBhWs4wrNbhVhooDF5jlQB9mD13nFgQfu/kUIMW569vEzApcXO
         1Raw==
X-Gm-Message-State: APjAAAVZ+JrSc8fhQb8YXcb4Vc8du5pm6KJPU2yQjFfs3AAgtPMB50A3
        HOz2PW5EAiWHDSEnaRdzbFVlMg==
X-Google-Smtp-Source: APXvYqyO3qOncwMaeceQBEL9WYWmO/+Y0n8afJbi7vMnQfRiAgSUbrRkZ2Nst/ph7XCW4cIHB82rYw==
X-Received: by 2002:aed:3924:: with SMTP id l33mr16055304qte.214.1562640828579;
        Mon, 08 Jul 2019 19:53:48 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:48 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 03/11] nfp: tls: use unique connection ids instead of 4-tuple for TX
Date:   Mon,  8 Jul 2019 19:53:10 -0700
Message-Id: <20190709025318.5534-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connection 4 tuple reuse is slightly problematic - TLS socket
and context do not get destroyed until all the associated skbs
left the system and all references are released. This leads
to stale connection entry in the device preventing addition
of new one if the 4 tuple is reused quickly enough.

Instead of using read 4 tuple as the key use a unique ID.
Set the protocol to TCP and port to 0 to ensure no collisions
with real connections.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 .../net/ethernet/netronome/nfp/crypto/fw.h    |  2 +
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 43 +++++++++++++------
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  3 ++
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/fw.h b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
index 192ba907d91b..67413d946c4a 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/fw.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
@@ -31,6 +31,8 @@ struct nfp_crypto_req_add_front {
 	u8 key_len;
 	__be16 ipver_vlan __packed;
 	u8 l4_proto;
+#define NFP_NET_TLS_NON_ADDR_KEY_LEN	8
+	u8 l3_addrs[0];
 };
 
 struct nfp_crypto_req_add_back {
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index b13b3dbd4843..b49405b4af55 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -155,17 +155,30 @@ nfp_net_tls_set_ipver_vlan(struct nfp_crypto_req_add_front *front, u8 ipver)
 						   NFP_NET_TLS_VLAN_UNUSED));
 }
 
+static void
+nfp_net_tls_assign_conn_id(struct nfp_net *nn,
+			   struct nfp_crypto_req_add_front *front)
+{
+	u32 len;
+	u64 id;
+
+	id = atomic64_inc_return(&nn->ktls_conn_id_gen);
+	len = front->key_len - NFP_NET_TLS_NON_ADDR_KEY_LEN;
+
+	memcpy(front->l3_addrs, &id, sizeof(id));
+	memset(front->l3_addrs + sizeof(id), 0, len - sizeof(id));
+}
+
 static struct nfp_crypto_req_add_back *
-nfp_net_tls_set_ipv4(struct nfp_crypto_req_add_v4 *req, struct sock *sk,
-		     int direction)
+nfp_net_tls_set_ipv4(struct nfp_net *nn, struct nfp_crypto_req_add_v4 *req,
+		     struct sock *sk, int direction)
 {
 	struct inet_sock *inet = inet_sk(sk);
 
 	req->front.key_len += sizeof(__be32) * 2;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
-		req->src_ip = inet->inet_saddr;
-		req->dst_ip = inet->inet_daddr;
+		nfp_net_tls_assign_conn_id(nn, &req->front);
 	} else {
 		req->src_ip = inet->inet_daddr;
 		req->dst_ip = inet->inet_saddr;
@@ -175,8 +188,8 @@ nfp_net_tls_set_ipv4(struct nfp_crypto_req_add_v4 *req, struct sock *sk,
 }
 
 static struct nfp_crypto_req_add_back *
-nfp_net_tls_set_ipv6(struct nfp_crypto_req_add_v6 *req, struct sock *sk,
-		     int direction)
+nfp_net_tls_set_ipv6(struct nfp_net *nn, struct nfp_crypto_req_add_v6 *req,
+		     struct sock *sk, int direction)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6_pinfo *np = inet6_sk(sk);
@@ -184,8 +197,7 @@ nfp_net_tls_set_ipv6(struct nfp_crypto_req_add_v6 *req, struct sock *sk,
 	req->front.key_len += sizeof(struct in6_addr) * 2;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
-		memcpy(req->src_ip, &np->saddr, sizeof(req->src_ip));
-		memcpy(req->dst_ip, &sk->sk_v6_daddr, sizeof(req->dst_ip));
+		nfp_net_tls_assign_conn_id(nn, &req->front);
 	} else {
 		memcpy(req->src_ip, &sk->sk_v6_daddr, sizeof(req->src_ip));
 		memcpy(req->dst_ip, &np->saddr, sizeof(req->dst_ip));
@@ -205,8 +217,8 @@ nfp_net_tls_set_l4(struct nfp_crypto_req_add_front *front,
 	front->l4_proto = IPPROTO_TCP;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
-		back->src_port = inet->inet_sport;
-		back->dst_port = inet->inet_dport;
+		back->src_port = 0;
+		back->dst_port = 0;
 	} else {
 		back->src_port = inet->inet_dport;
 		back->dst_port = inet->inet_sport;
@@ -260,6 +272,7 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	struct nfp_crypto_reply_add *reply;
 	struct sk_buff *skb;
 	size_t req_sz;
+	void *req;
 	bool ipv6;
 	int err;
 
@@ -302,16 +315,17 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 
 	front = (void *)skb->data;
 	front->ep_id = 0;
-	front->key_len = 8;
+	front->key_len = NFP_NET_TLS_NON_ADDR_KEY_LEN;
 	front->opcode = nfp_tls_1_2_dir_to_opcode(direction);
 	memset(front->resv, 0, sizeof(front->resv));
 
 	nfp_net_tls_set_ipver_vlan(front, ipv6 ? 6 : 4);
 
+	req = (void *)skb->data;
 	if (ipv6)
-		back = nfp_net_tls_set_ipv6((void *)skb->data, sk, direction);
+		back = nfp_net_tls_set_ipv6(nn, req, sk, direction);
 	else
-		back = nfp_net_tls_set_ipv4((void *)skb->data, sk, direction);
+		back = nfp_net_tls_set_ipv4(nn, req, sk, direction);
 
 	nfp_net_tls_set_l4(front, back, sk, direction);
 
@@ -329,7 +343,8 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	err = nfp_ccm_mbox_communicate(nn, skb, NFP_CCM_TYPE_CRYPTO_ADD,
 				       sizeof(*reply), sizeof(*reply));
 	if (err) {
-		nn_dp_warn(&nn->dp, "failed to add TLS: %d\n", err);
+		nn_dp_warn(&nn->dp, "failed to add TLS: %d (%d)\n",
+			   err, direction == TLS_OFFLOAD_CTX_DIR_TX);
 		/* communicate frees skb on error */
 		goto err_conn_remove;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 0659756bf2bb..5d6c3738b494 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -583,6 +583,7 @@ struct nfp_net_dp {
  * @tlv_caps:		Parsed TLV capabilities
  * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
  * @ktls_rx_conn_cnt:	Number of offloaded kTLS RX connections
+ * @ktls_conn_id_gen:	Trivial generator for kTLS connection ids (for TX)
  * @ktls_no_space:	Counter of firmware rejecting kTLS connection due to
  *			lack of space
  * @mbox_cmsg:		Common Control Message via vNIC mailbox state
@@ -670,6 +671,8 @@ struct nfp_net {
 	unsigned int ktls_tx_conn_cnt;
 	unsigned int ktls_rx_conn_cnt;
 
+	atomic64_t ktls_conn_id_gen;
+
 	atomic_t ktls_no_space;
 
 	struct {
-- 
2.21.0

