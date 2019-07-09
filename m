Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B1E62E5F
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfGICyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:54:00 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42830 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfGICx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:59 -0400
Received: by mail-qt1-f196.google.com with SMTP id h18so12771100qtm.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lw5IHVghl58oLpSoeFhoyldBUQqOWdc2i/eFhzjG1hs=;
        b=YGh4W2j/0ypsSKWH8aXIv+SWF0Bif/y4xorEssbiWy+ksHaely24VV7+YGNgOITsj9
         S3rampLbA6JFAyzTv33D84vAMZaQVlvs3TSMUmFaXQAaB0TqD38BiTnfctwpyORJY78S
         CSy27v6bRXBtk2lc201aHyr6ZuW5sCgAe+oMCfaJq4FLN1mAqiRVGxZMgcIGq534lqUr
         RRjnO1Ef8q+9r10w6mmGDSZvMhcDcRdnzvpVHYx2gySzWsaPkPxYKwbLuaJuq6MciOsN
         KBFw7eNs12k71lZ0EbGvW1SZAZXwSjZ5cTsVzmcYOG/3p9znQxgjpMdiTJm4OZM1oMdY
         eifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lw5IHVghl58oLpSoeFhoyldBUQqOWdc2i/eFhzjG1hs=;
        b=hURIn5+ctUzYcZinR0cg6FVwR6Bf3zFroPZKcqyAGXoFa0779aarumWXypm8flVFyp
         ib0LzfrLc5Z3OpOMnDkuYMfNnzG4IRBhFAZ/XO/7urzitdW7NDLm0ynUZDR52w/5v/id
         vDNxvRdOPbjBqSIVw7V7DrQ/kgff08BQgDWZgTl6HSqiCmyE5eIAhHY2RqbnMzqAvCXk
         Tem56VCGnuBnISEQcDgKVCIxWYX4gvCls80a3mTrUmP96SUwZoT+OmgjNG5H4zBCqrza
         2Me9fUZVHMPY5WGuWVM2zkBx2OlSL/YAWjcdL8/pdPnYnsNYe27AA/Qxadw15dIdl6FH
         QxZA==
X-Gm-Message-State: APjAAAWsWgFk8yrNztIdVSWNPBngmet+QWNWG7MODtUiFB0wG0gpAOq6
        CTMqxdiD7buy65Zh3N+Yg5NFXw==
X-Google-Smtp-Source: APXvYqyOV8sBIZSXgqEdgZsfoaeFkade8fnBiRSHB6v/33B+IBIDnau+E8JeMOvY965uTxKeMk/keQ==
X-Received: by 2002:ac8:22ad:: with SMTP id f42mr16621011qta.271.1562640838045;
        Mon, 08 Jul 2019 19:53:58 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:57 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 10/11] nfp: tls: undo TLS sequence tracking when dropping the frame
Date:   Mon,  8 Jul 2019 19:53:17 -0700
Message-Id: <20190709025318.5534-11-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If driver has to drop the TLS frame it needs to undo the TCP
sequence tracking changes, otherwise device will receive
segments out of order and drop them.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 54dd98b2d645..9903805717da 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -893,6 +893,28 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	return skb;
 }
 
+static void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
+{
+#ifdef CONFIG_TLS_DEVICE
+	struct nfp_net_tls_offload_ctx *ntls;
+	u32 datalen, seq;
+
+	if (!tls_handle)
+		return;
+	if (WARN_ON_ONCE(!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk)))
+		return;
+
+	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	seq = ntohl(tcp_hdr(skb)->seq);
+
+	ntls = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
+	if (ntls->next_seq == seq + datalen)
+		ntls->next_seq = seq;
+	else
+		WARN_ON_ONCE(1);
+#endif
+}
+
 static void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
 {
 	wmb();
@@ -1102,6 +1124,7 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 	u64_stats_update_begin(&r_vec->tx_sync);
 	r_vec->tx_errors++;
 	u64_stats_update_end(&r_vec->tx_sync);
+	nfp_net_tls_tx_undo(skb, tls_handle);
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
-- 
2.21.0

