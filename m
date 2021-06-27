Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8805F3B547D
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhF0RXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhF0RXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 13:23:01 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B406EC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b1so1033505pls.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GX5JWHS3tER4fXTfa4wdXdGrCJim9rFAkPM02eqa5W0=;
        b=h1pMgZDfX9UvAWZ+RPpeEBZt7FjNZrRtZWnVIaBniqAPXrNnPTPbcKTLJJ9KATC0ZN
         +IoN3Dnzg1LF4jYkCx9+6rfkoFOCQfgEcQKgTRRtW7QcoNJD+d1wVx35y44ueQcmAJLq
         Zr/whGcF72+Er7sXh+11mpxKuD5miLPA4gnqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GX5JWHS3tER4fXTfa4wdXdGrCJim9rFAkPM02eqa5W0=;
        b=Gw8xCphLtvol+OfUcXJMPPU3SBfKjfcVxVuzgctZWq/HV68gFsWHnUlibiYNzSK3IF
         b/yqgupn0hOjdHO7k37DWxzqVVHkhtvx+7+CBEqOQPOlcT8eoDYl6wwdsNSn1E6lsFWl
         79QMlrLrKzgmgONZUs19UbqDo8vaObui19Wvo0LIHgnKaNGNHOH/NFV2xiVPg1q9WmKU
         q6a2CJX3RhNN16xNaarsc8+PZ0WtJkvfbprZKuBNtfYIfEPStfrBfPLYcAa8J1WIRgb/
         7fbJH8x+n5cZz32XvKOc8LbpFppa8CU6H76ghktfdBUdt+LN67vLgG36ID3f9gECRUSx
         TE7w==
X-Gm-Message-State: AOAM53281TyEzVXJDE7cl9JhfWc3VQqyLTIanq7tS57Pre8tBOmG+sYA
        bndx+TMwyTnH/ACHYaRca45rKfDikzIfW7zd
X-Google-Smtp-Source: ABdhPJxN+rA6OP8LM9/8FNGSUengLHNx2eYg04GOauGIaCx+Bphz5WFjK0hkXpg68v+eb0rBN3abPg==
X-Received: by 2002:a17:902:a70f:b029:ea:d4a8:6a84 with SMTP id w15-20020a170902a70fb02900ead4a86a84mr18801366plq.42.1624814436991;
        Sun, 27 Jun 2021 10:20:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm11011584pfu.60.2021.06.27.10.20.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 10:20:36 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next v2 6/7] bnxt_en: Transmit and retrieve packet timestamps
Date:   Sun, 27 Jun 2021 13:19:49 -0400
Message-Id: <1624814390-1300-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
References: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005f14e205c5c2975f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005f14e205c5c2975f

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Setup the TXBD to enable TX timestamp if requested.  At TX packet DMA
completion, if we requested TX timestamp on that packet, we defer to
.do_aux_work() to obtain the TX timestamp from the firmware before we
free the TX SKB.

v2: Use .do_aux_work() to get the TX timestamp from firmware.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 38 +++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 94 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  2 +
 4 files changed, 131 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5132f07a5f43..e198e1426551 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -421,12 +421,25 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			vlan_tag_flags |= 1 << TX_BD_CFA_META_TPID_SHIFT;
 	}
 
-	if (unlikely(skb->no_fcs)) {
-		lflags |= cpu_to_le32(TX_BD_FLAGS_NO_CRC);
-		goto normal_tx;
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+		if (ptp && ptp->tx_tstamp_en && !skb_is_gso(skb) &&
+		    atomic_dec_if_positive(&ptp->tx_avail) >= 0) {
+			if (!bnxt_ptp_parse(skb, &ptp->tx_seqid)) {
+				lflags |= cpu_to_le32(TX_BD_FLAGS_STAMP);
+				skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			} else {
+				atomic_inc(&bp->ptp_cfg->tx_avail);
+			}
+		}
 	}
 
-	if (free_size == bp->tx_ring_size && length <= bp->tx_push_thresh) {
+	if (unlikely(skb->no_fcs))
+		lflags |= cpu_to_le32(TX_BD_FLAGS_NO_CRC);
+
+	if (free_size == bp->tx_ring_size && length <= bp->tx_push_thresh &&
+	    !lflags) {
 		struct tx_push_buffer *tx_push_buf = txr->tx_push;
 		struct tx_push_bd *tx_push = &tx_push_buf->push_bd;
 		struct tx_bd_ext *tx_push1 = &tx_push->txbd2;
@@ -593,6 +606,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	netdev_tx_sent_queue(txq, skb->len);
 
+	skb_tx_timestamp(skb);
+
 	/* Sync BD data before updating doorbell */
 	wmb();
 
@@ -622,6 +637,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_dma_error:
+	if (BNXT_TX_PTP_IS_SET(lflags))
+		atomic_inc(&bp->ptp_cfg->tx_avail);
+
 	last_frag = i;
 
 	/* start back at beginning and unmap skb */
@@ -656,6 +674,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 	for (i = 0; i < nr_pkts; i++) {
 		struct bnxt_sw_tx_bd *tx_buf;
+		bool compl_deferred = false;
 		struct sk_buff *skb;
 		int j, last;
 
@@ -682,12 +701,21 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 				skb_frag_size(&skb_shinfo(skb)->frags[j]),
 				PCI_DMA_TODEVICE);
 		}
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+			if (bp->flags & BNXT_FLAG_CHIP_P5) {
+				if (!bnxt_get_tx_ts_p5(bp, skb))
+					compl_deferred = true;
+				else
+					atomic_inc(&bp->ptp_cfg->tx_avail);
+			}
+		}
 
 next_tx_int:
 		cons = NEXT_TX(cons);
 
 		tx_bytes += skb->len;
-		dev_kfree_skb_any(skb);
+		if (!compl_deferred)
+			dev_kfree_skb_any(skb);
 	}
 
 	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 94a612e8cd42..bcf8d00b8c80 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -89,6 +89,8 @@ struct tx_bd_ext {
 	#define TX_BD_CFA_META_KEY_VLAN                         (1 << 28)
 };
 
+#define BNXT_TX_PTP_IS_SET(lflags) ((lflags) & cpu_to_le32(TX_BD_FLAGS_STAMP))
+
 struct rx_bd {
 	__le32 rx_bd_len_flags_type;
 	#define RX_BD_TYPE					(0x3f << 0)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index cea7220f3d1b..f698b6bd4ff8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -15,10 +15,32 @@
 #include <linux/net_tstamp.h>
 #include <linux/timecounter.h>
 #include <linux/timekeeping.h>
+#include <linux/ptp_classify.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_ptp.h"
 
+int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id)
+{
+	unsigned int ptp_class;
+	struct ptp_header *hdr;
+
+	ptp_class = ptp_classify_raw(skb);
+
+	switch (ptp_class & PTP_CLASS_VMASK) {
+	case PTP_CLASS_V1:
+	case PTP_CLASS_V2:
+		hdr = ptp_parse_header(skb, ptp_class);
+		if (!hdr)
+			return -EINVAL;
+
+		*seq_id	 = ntohs(hdr->sequence_id);
+		return 0;
+	default:
+		return -ERANGE;
+	}
+}
+
 static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
 			    const struct timespec64 *ts)
 {
@@ -57,6 +79,28 @@ static void bnxt_ptp_get_current_time(struct bnxt *bp)
 	spin_unlock_bh(&ptp->ptp_lock);
 }
 
+static int bnxt_hwrm_port_ts_query(struct bnxt *bp, u32 flags, u64 *ts)
+{
+	struct hwrm_port_ts_query_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_port_ts_query_input req = {0};
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_TS_QUERY, -1, -1);
+	req.flags = cpu_to_le32(flags);
+	if ((flags & PORT_TS_QUERY_REQ_FLAGS_PATH) ==
+	    PORT_TS_QUERY_REQ_FLAGS_PATH_TX) {
+		req.enables = cpu_to_le16(BNXT_PTP_QTS_TX_ENABLES);
+		req.ptp_seq_id = cpu_to_le32(bp->ptp_cfg->tx_seqid);
+		req.ts_req_timeout = cpu_to_le16(BNXT_PTP_QTS_TIMEOUT);
+	}
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
+		*ts = le64_to_cpu(resp->ptp_msg_ts);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static int bnxt_ptp_gettimex(struct ptp_clock_info *ptp_info,
 			     struct timespec64 *ts,
 			     struct ptp_system_timestamp *sts)
@@ -269,16 +313,62 @@ static u64 bnxt_cc_read(const struct cyclecounter *cc)
 	return bnxt_refclk_read(ptp->bp, NULL);
 }
 
+static void bnxt_stamp_tx_skb(struct bnxt *bp, struct sk_buff *skb)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	struct skb_shared_hwtstamps timestamp;
+	u64 ts = 0, ns = 0;
+	int rc;
+
+	rc = bnxt_hwrm_port_ts_query(bp, PORT_TS_QUERY_REQ_FLAGS_PATH_TX, &ts);
+	if (!rc) {
+		memset(&timestamp, 0, sizeof(timestamp));
+		spin_lock_bh(&ptp->ptp_lock);
+		ns = timecounter_cyc2time(&ptp->tc, ts);
+		spin_unlock_bh(&ptp->ptp_lock);
+		timestamp.hwtstamp = ns_to_ktime(ns);
+		skb_tstamp_tx(ptp->tx_skb, &timestamp);
+	} else {
+		netdev_err(bp->dev, "TS query for TX timer failed rc = %x\n",
+			   rc);
+	}
+
+	dev_kfree_skb_any(ptp->tx_skb);
+	ptp->tx_skb = NULL;
+	atomic_inc(&ptp->tx_avail);
+}
+
 static long bnxt_ptp_ts_aux_work(struct ptp_clock_info *ptp_info)
 {
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
+	unsigned long now = jiffies;
 	struct bnxt *bp = ptp->bp;
 
+	if (ptp->tx_skb)
+		bnxt_stamp_tx_skb(bp, ptp->tx_skb);
+
+	if (!time_after_eq(now, ptp->next_period))
+		return ptp->next_period - now;
+
 	bnxt_ptp_get_current_time(bp);
+	ptp->next_period = now + HZ;
 	return HZ;
 }
 
+int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (ptp->tx_skb) {
+		netdev_err(bp->dev, "deferring skb:one SKB is still outstanding\n");
+		return -EBUSY;
+	}
+	ptp->tx_skb = skb;
+	ptp_schedule_worker(ptp->ptp_clock, 0);
+	return 0;
+}
+
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -375,5 +465,9 @@ void bnxt_ptp_clear(struct bnxt *bp)
 		ptp_clock_unregister(ptp->ptp_clock);
 
 	ptp->ptp_clock = NULL;
+	if (ptp->tx_skb) {
+		dev_kfree_skb_any(ptp->tx_skb);
+		ptp->tx_skb = NULL;
+	}
 	bnxt_unmap_ptp_regs(bp);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 4f2c62f5a78e..6b6245750e20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -70,8 +70,10 @@ do {						\
 	((dst) = READ_ONCE(src))
 #endif
 
+int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
 void bnxt_ptp_start(struct bnxt *bp);
 int bnxt_ptp_init(struct bnxt *bp);
-- 
2.18.1


--0000000000005f14e205c5c2975f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFBkecRlzbEG41I4b4lxupyZ749wqK/4
5APgq2vVAYSYMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDYy
NzE3MjAzN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAYFMppRoBwQYRN79jUd1vllVMlA7dO9nMn59eyW//oAjSk3H+P
aNTzCT0SYdc96n2Ohx4oA85D8mSYcvTdU3YMkCQIktJV3338ds+6GAuGXXLaVmAu6CCMDpi+a1oZ
Ts5SJqufPGvhpCcMmZgnIZLlhBc6FoEWputvY2taIvSjXNaaC68rDuPc6bm3Zzaef2wO3+Nt182i
9Qr++z5bPDgk8FZppl6cTS6uiToB7b9/GuyEwdWywm3VsPSx555YxUY3j86Xa/tcGHcQjg0lph7g
JkCKaGAAqDupKUyQI31dC97TFAKFMTxR+BLGc8OTQbjxPZPo4LKe0kzSNX/a5KAF
--0000000000005f14e205c5c2975f--
