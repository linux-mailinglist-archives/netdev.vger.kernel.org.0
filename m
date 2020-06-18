Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FE71FE9AD
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgFRDxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:45 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD046C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:43 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o24so1587843qkm.22
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GuK2H7trFzxvwB1X/goEsLEeF1PfsbFY6xB/Wlv9LcY=;
        b=SwWW4Ux2Bnv6cBbY97nh97Qj8nR1Cxl1cbfTptADIiUevrcb5KGY05kYP/Fel9AHLw
         9ItHEoBmsxDVf51TkgKUxjOqywaJbH1mOn4iJZQ+boNO/ITLVPHcPuyf/FmXGFJQEGne
         IedKnCNS99wX4LKn9/sDXZFOZKjA1CAt6VnQTK77cuPC8QempoRC0EPUa2Bw6TPCCQec
         B9mVOhBHAGl21HC17rMLOF2PqI4EMAnJp2MBvm0fVz06FyAHV9jeFOK6vFMiu8vdwACc
         XZL1RtJv/wTprHNS7cktwXl/0dtX6jktTgo68zi/u/lFSWVeJZTvDlnRY4JxOLcJJ2QJ
         JNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GuK2H7trFzxvwB1X/goEsLEeF1PfsbFY6xB/Wlv9LcY=;
        b=nDARbF0YOerr/CW9u4XF2Ck8F4vPSUUGL9lrVHZdrkFsVk7m6uZvEGi7R7htEQlKz6
         c6djVPc5NKmVWCeThI8G8V/s0fUuIgSdJK+LGwv5dMRkMGi4byp+wWCPM6Whud5x0UBg
         6hFuo3yrRXDfRIwJXNxi4mz1Y3fJ4ZbndA3owaNKjtkKm1DXhNIc30TV/lyq8SK9wufQ
         9+MLJdiPQV4b/lwbHbIWNu6sRhhnnpFNGWsqbiRvPkGntdX98r3WOD3gNRY++9BGfLIV
         nDdtf0+BgeBWmkv8Fd2ZwvMbUOM0PIlp1PRZFozUPKwSq0KCckVsSnJ7tlVR0vWu7PGc
         gkXQ==
X-Gm-Message-State: AOAM533JdCxZOZylK7cHoz9n8bHhxdjW9ClzhazL5j+pS4F72xbtfzp2
        Gxu6Hfi4XajnjS6ueHkiqZETUXFs5CNK7A==
X-Google-Smtp-Source: ABdhPJygPmrXAjwTn7oSWfbj/Vd7HptuliEdU86hbvwPseRzcZbOu6n2ZVNii8I3hTJ7Z4/kJOYSoaJ6GsLMVA==
X-Received: by 2002:a05:6214:405:: with SMTP id z5mr1817628qvx.112.1592452421790;
 Wed, 17 Jun 2020 20:53:41 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:25 -0700
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
Message-Id: <20200618035326.39686-6-edumazet@google.com>
Mime-Version: 1.0
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 5/6] net: tso: cache transport header length
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tlen field into struct tso_t, and change tso_start()
to return skb_transport_offset(skb) + tso->tlen

This removes from callers the need to use tcp_hdrlen(skb) and
will ease UDP segmentation offload addition.

v2: calls tso_start() earlier in otx2_sq_append_tso() [Jakub]

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c    |  5 +++--
 drivers/net/ethernet/freescale/fec_main.c             |  5 ++---
 drivers/net/ethernet/marvell/mv643xx_eth.c            |  5 ++---
 drivers/net/ethernet/marvell/mvneta.c                 |  5 ++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       |  6 +++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    |  6 +++---
 include/net/tso.h                                     |  3 ++-
 net/core/tso.c                                        | 11 +++++++----
 8 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 069e7413f1ef57ef401adfa6c7efdaad8005aba0..a45223f0cca5813324dd6543095f5375ffe5f27e 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -1489,9 +1489,10 @@ static int nicvf_sq_append_tso(struct nicvf *nic, struct snd_queue *sq,
 	int seg_subdescs = 0, desc_cnt = 0;
 	int seg_len, total_len, data_left;
 	int hdr_qentry = qentry;
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int hdr_len;
+
+	hdr_len = tso_start(skb, &tso);
 
-	tso_start(skb, &tso);
 	total_len = skb->len - hdr_len;
 	while (total_len > 0) {
 		char *hdr;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d0d313ee7c5a193a805f858b9fcd83f98a4ebea..9f80a33c5b16b07b30aa8ebfbc4dc8338a6ae056 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -710,8 +710,7 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 				   struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
-	int total_len, data_left;
+	int hdr_len, total_len, data_left;
 	struct bufdesc *bdp = txq->bd.cur;
 	struct tso_t tso;
 	unsigned int index = 0;
@@ -731,7 +730,7 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	}
 
 	/* Initialize the TSO handler, and prepare the first payload */
-	tso_start(skb, &tso);
+	hdr_len = tso_start(skb, &tso);
 
 	total_len = skb->len - hdr_len;
 	while (total_len > 0) {
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 4d4b6243318a59ac01190446766d2864f016564e..90e6111ce534dba7f16de983549ade748890124c 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -816,10 +816,9 @@ static int txq_submit_tso(struct tx_queue *txq, struct sk_buff *skb,
 			  struct net_device *dev)
 {
 	struct mv643xx_eth_private *mp = txq_to_mp(txq);
-	int total_len, data_left, ret;
+	int hdr_len, total_len, data_left, ret;
 	int desc_count = 0;
 	struct tso_t tso;
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	struct tx_desc *first_tx_desc;
 	u32 first_cmd_sts = 0;
 
@@ -832,7 +831,7 @@ static int txq_submit_tso(struct tx_queue *txq, struct sk_buff *skb,
 	first_tx_desc = &txq->tx_desc_area[txq->tx_curr_desc];
 
 	/* Initialize the TSO handler, and prepare the first payload */
-	tso_start(skb, &tso);
+	hdr_len = tso_start(skb, &tso);
 
 	total_len = skb->len - hdr_len;
 	while (total_len > 0) {
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 946925bbcb2de93629f45c3b9eecbfaf7338e8d1..95b447c14411479a026cf5a0375e79b345152d7c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2604,11 +2604,10 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 			 struct mvneta_tx_queue *txq)
 {
-	int total_len, data_left;
+	int hdr_len, total_len, data_left;
 	int desc_count = 0;
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct tso_t tso;
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	int i;
 
 	/* Count needed descriptors */
@@ -2621,7 +2620,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	/* Initialize the TSO handler, and prepare the first payload */
-	tso_start(skb, &tso);
+	hdr_len = tso_start(skb, &tso);
 
 	total_len = skb->len - hdr_len;
 	while (total_len > 0) {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 24f4d8e0da989daaca10333ec9c5a3a22ec66c48..e9f28756802628cc0a77dd80451a36ffe4b7f19c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3160,9 +3160,8 @@ static int mvpp2_tx_tso(struct sk_buff *skb, struct net_device *dev,
 			struct mvpp2_txq_pcpu *txq_pcpu)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	int hdr_sz, i, len, descs = 0;
 	struct tso_t tso;
-	int hdr_sz = skb_transport_offset(skb) + tcp_hdrlen(skb);
-	int i, len, descs = 0;
 
 	/* Check number of available descriptors */
 	if (mvpp2_aggr_desc_num_check(port, aggr_txq, tso_count_descs(skb)) ||
@@ -3170,7 +3169,8 @@ static int mvpp2_tx_tso(struct sk_buff *skb, struct net_device *dev,
 					     tso_count_descs(skb)))
 		return 0;
 
-	tso_start(skb, &tso);
+	hdr_sz = tso_start(skb, &tso);
+
 	len = skb->len - hdr_sz;
 	while (len > 0) {
 		int left = min_t(int, skb_shinfo(skb)->gso_size, len);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index b04f5429d72d911da145ee13b99506d84a9d7925..3a5b34a2a7a653370f66272487cd7c2f69985142 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -619,13 +619,14 @@ static void otx2_sq_append_tso(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			       struct sk_buff *skb, u16 qidx)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(pfvf->netdev, qidx);
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
-	int tcp_data, seg_len, pkt_len, offset;
+	int hdr_len, tcp_data, seg_len, pkt_len, offset;
 	struct nix_sqe_hdr_s *sqe_hdr;
 	int first_sqe = sq->head;
 	struct sg_list list;
 	struct tso_t tso;
 
+	hdr_len = tso_start(skb, &tso);
+
 	/* Map SKB's fragments to DMA.
 	 * It's done here to avoid mapping for every TSO segment's packet.
 	 */
@@ -636,7 +637,6 @@ static void otx2_sq_append_tso(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 
 	netdev_tx_sent_queue(txq, skb->len);
 
-	tso_start(skb, &tso);
 	tcp_data = skb->len - hdr_len;
 	while (tcp_data > 0) {
 		char *hdr;
diff --git a/include/net/tso.h b/include/net/tso.h
index 32d9272ade6af0e3dd1272ecafa948f1535ea61f..62c98a9c60f15d7b4869f1ab523dfeb83fb18ba6 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -11,6 +11,7 @@ struct tso_t {
 	int	size;
 	void	*data;
 	u16	ip_id;
+	u8	tlen; /* transport header len */
 	bool	ipv6;
 	u32	tcp_seq;
 };
@@ -19,6 +20,6 @@ int tso_count_descs(const struct sk_buff *skb);
 void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last);
 void tso_build_data(const struct sk_buff *skb, struct tso_t *tso, int size);
-void tso_start(struct sk_buff *skb, struct tso_t *tso);
+int tso_start(struct sk_buff *skb, struct tso_t *tso);
 
 #endif	/* _TSO_H */
diff --git a/net/core/tso.c b/net/core/tso.c
index 56487e3bb26dc01b65f73f96fd0157bec73ea0d0..9f35518815bda275106d27bc5cc34b019429d254 100644
--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -17,7 +17,7 @@ void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last)
 {
 	struct tcphdr *tcph;
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int hdr_len = skb_transport_offset(skb) + tso->tlen;
 	int mac_hdr_len = skb_network_offset(skb);
 
 	memcpy(hdr, skb->data, hdr_len);
@@ -30,7 +30,7 @@ void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 	} else {
 		struct ipv6hdr *iph = (void *)(hdr + mac_hdr_len);
 
-		iph->payload_len = htons(size + tcp_hdrlen(skb));
+		iph->payload_len = htons(size + tso->tlen);
 	}
 	tcph = (struct tcphdr *)(hdr + skb_transport_offset(skb));
 	put_unaligned_be32(tso->tcp_seq, &tcph->seq);
@@ -62,10 +62,12 @@ void tso_build_data(const struct sk_buff *skb, struct tso_t *tso, int size)
 }
 EXPORT_SYMBOL(tso_build_data);
 
-void tso_start(struct sk_buff *skb, struct tso_t *tso)
+int tso_start(struct sk_buff *skb, struct tso_t *tso)
 {
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int tlen = tcp_hdrlen(skb);
+	int hdr_len = skb_transport_offset(skb) + tlen;
 
+	tso->tlen = tlen;
 	tso->ip_id = ntohs(ip_hdr(skb)->id);
 	tso->tcp_seq = ntohl(tcp_hdr(skb)->seq);
 	tso->next_frag_idx = 0;
@@ -83,5 +85,6 @@ void tso_start(struct sk_buff *skb, struct tso_t *tso)
 		tso->data = skb_frag_address(frag);
 		tso->next_frag_idx++;
 	}
+	return hdr_len;
 }
 EXPORT_SYMBOL(tso_start);
-- 
2.27.0.290.gba653c62da-goog

