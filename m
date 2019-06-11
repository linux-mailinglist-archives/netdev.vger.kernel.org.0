Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DB53C272
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391137AbfFKElD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:03 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34404 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391095AbfFKElC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:41:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so13034556qtu.1
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UeGuXWIH6R57ioeAgB5INyW++FJkENvG5XW14jtxPgo=;
        b=nBFe3nX9sG7CprNja65cWhEcCJi6tiOaDyTI2EMZwzNiVJnfheYXiUnNhCXQSYJNoS
         MCXVgjy2Cesjec+GXyU6BTL3qA5N1CqTzn7K211iNYwagWLngSBdrFVDCbUgb5UKbYek
         LFaksTWOXh37u4Eywt1G9BJs63JjVQbLI6fiq3QbdS5rB52+EgkwudzW8MyTGLyh6Mbq
         uuH+igVK06XFnijQhGskHcgwgcW1p3Rs2kZ34fJoJ2SfC9x30GLmg4IzgSk331roD/mU
         3KRld4DKKQljBItoArfqa5JhYDdsMfnM6TxDuAPQ1+D8IABAcJ4HMLEpxDRnXiL3dT4K
         AJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UeGuXWIH6R57ioeAgB5INyW++FJkENvG5XW14jtxPgo=;
        b=dAKqXIlx3KTdAEymwXygDYK4ui0TqFFEgaBje18c0WYBg18QkLrci9Z+sPa4f67XJu
         biQNnNPc38enEr3MmPp8zcCgUu6BXqBpKPVCrmb4jDO6mwiElK7BzXvmDVvrvFzShnXh
         hnQpEg6glfTKwByQCqxr6lXbWCykWmrjb9ScuTj8de4e3FdWQgBef1Cd/qfcnVX+zDe3
         ym+jHnqgv0eqmRQuqNvkq04X+jIR9rOczKROU0rLLik2pMUZjFQ5lucht+x1gXrpizrO
         cM36B5TIkHZu85qYnFhhoLQTxf6EztTneiIYMinetW+GyfAtP6I9VCwWwMq68regFUfY
         yLsg==
X-Gm-Message-State: APjAAAVmzww5ZPJ8CmqStynP6sc80t+TMLrhjzkElN8NC0ffcWE9nTEi
        Y9G6lyzwDJKOCK2yvfPa/jYFJA==
X-Google-Smtp-Source: APXvYqybFSWCWCu3TVZRsYbMrv94V4h0FOvmUS03y+Wm0AG0FM5i+cUQtJdDpaEAyOjbi2NBjikLVQ==
X-Received: by 2002:ac8:1a1c:: with SMTP id v28mr59621210qtj.270.1560228061674;
        Mon, 10 Jun 2019 21:41:01 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.41.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:41:01 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 08/12] nfp: tls: implement RX TLS resync
Date:   Mon, 10 Jun 2019 21:40:06 -0700
Message-Id: <20190611044010.29161-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Enable kernel-controlled RX resync and propagate TLS connection
RX resync from kernel TLS to firmware.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index b7d7317d71d1..eebaf5e1621d 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -344,6 +344,11 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	ntls->next_seq = start_offload_tcp_sn;
 	dev_consume_skb_any(skb);
 
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
+		return 0;
+
+	tls_offload_rx_resync_set_type(sk,
+				       TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT);
 	return 0;
 
 err_fw_remove:
@@ -368,9 +373,36 @@ nfp_net_tls_del(struct net_device *netdev, struct tls_context *tls_ctx,
 	nfp_net_tls_del_fw(nn, ntls->fw_handle);
 }
 
+static void
+nfp_net_tls_resync_rx(struct net_device *netdev, struct sock *sk, u32 seq,
+		      u8 *rcd_sn)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_net_tls_offload_ctx *ntls;
+	struct nfp_crypto_req_update *req;
+	struct sk_buff *skb;
+
+	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	ntls = tls_driver_ctx(sk, TLS_OFFLOAD_CTX_DIR_RX);
+	req = (void *)skb->data;
+	req->ep_id = 0;
+	req->opcode = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC;
+	memset(req->resv, 0, sizeof(req->resv));
+	memcpy(req->handle, ntls->fw_handle, sizeof(ntls->fw_handle));
+	req->tcp_seq = cpu_to_be32(seq);
+	memcpy(req->rec_no, rcd_sn, sizeof(req->rec_no));
+
+	nfp_ccm_mbox_post(nn, skb, NFP_CCM_TYPE_CRYPTO_UPDATE,
+			  sizeof(struct nfp_crypto_reply_simple));
+}
+
 static const struct tlsdev_ops nfp_net_tls_ops = {
 	.tls_dev_add = nfp_net_tls_add,
 	.tls_dev_del = nfp_net_tls_del,
+	.tls_dev_resync_rx = nfp_net_tls_resync_rx,
 };
 
 static int nfp_net_tls_reset(struct nfp_net *nn)
-- 
2.21.0

