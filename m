Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12233B547C
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhF0RW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhF0RW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 13:22:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F38C061787
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:33 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e33so13225430pgm.3
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pOKOviOib6Phu+bj0fyMjVgcAvOnEBIMrO7BXKLWijI=;
        b=Qxud4Z8YU2uUyWifoaD7XPgIsVWeRbnMXAuPtMeKH9qcUcH3SYEEqD+Cnmyzi+1gSZ
         DtFGMnOjVegx2ZyfFP4gV7UbHOXL28kOMmZ5dtgtp3bI+tAChBg4TSzDsIDxn8n2gFf1
         CiFCyDPN1dvK+ORj3Hcwgp4JTOGnJOjg1kqSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pOKOviOib6Phu+bj0fyMjVgcAvOnEBIMrO7BXKLWijI=;
        b=hj/+iVGqSwftnHd5N2tJfbG2c2VEy96JHwx5FbATRkWV0D9ebjy73ScFDjlKn023GO
         gtSqHuPuV6lrlbjLtkeqUNKQyJGUpMmzSNBZhLbb77AJaEGvUXg20vJ+pFBhcz8fiV8h
         xiBnZqFqP7B6jZVKSNMSCy8M1JbdFUCeLw2LY9HkzpT9BN/Jq9UT4mcZmQrshE6yXJtF
         gnh154hp3yTg69o9G/pvL/Eqiu7y6jAhODN1w6UBQLj2vXTbvBanr/LFRc4pm/GRRB44
         u2eUVzg6xwvNTGqO/YC8YAPwe1RT7Y+QEJNyINnJKkb72etvOykpAopohrcPduL5Z+AR
         0JbA==
X-Gm-Message-State: AOAM533D8yP5r+l5wfNE+o0RaSCtmZWwAGTywEMQLIPjvDOlCge576X+
        UjiSinKii10xhBjl3+FAcBiZmw==
X-Google-Smtp-Source: ABdhPJyMDuuuN68TFDf/1eETXJ1yLAhpUrxgtJq4uKWcvDEXf6RSFaUXfFVwTW5+pzeBMFxbJFkvlQ==
X-Received: by 2002:a63:609:: with SMTP id 9mr19380437pgg.44.1624814432985;
        Sun, 27 Jun 2021 10:20:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm11011584pfu.60.2021.06.27.10.20.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 10:20:32 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next v2 5/7] bnxt_en: Get the RX packet timestamp
Date:   Sun, 27 Jun 2021 13:19:48 -0400
Message-Id: <1624814390-1300-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
References: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002184c205c5c297b1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002184c205c5c297b1

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

If the RX packet is timestamped by the hardware, the RX completion
record will contain the lower 32-bit of the timestamp.  This needs
to be combined with the upper 16-bit of the periodic timestamp that
we get from the timer.  The previous snapshot in ptp->old_timer is
used to make sure that the snapshot is not ahead of the RX timestamp
and we adjust for wrap-around if needed.

v2: Make ptp->old_time read access safe on 32-bit CPUs.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 23 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 16 +++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 13 +++++++++++
 4 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 23eddde7bf12..5132f07a5f43 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1709,9 +1709,9 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	u8 *data_ptr, agg_bufs, cmp_type;
 	dma_addr_t dma_addr;
 	struct sk_buff *skb;
+	u32 flags, misc;
 	void *data;
 	int rc = 0;
-	u32 misc;
 
 	rxcmp = (struct rx_cmp *)
 			&cpr->cp_desc_ring[CP_RING(cp_cons)][CP_IDX(cp_cons)];
@@ -1809,7 +1809,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		goto next_rx_no_len;
 	}
 
-	len = le32_to_cpu(rxcmp->rx_cmp_len_flags_type) >> RX_CMP_LEN_SHIFT;
+	flags = le32_to_cpu(rxcmp->rx_cmp_len_flags_type);
+	len = flags >> RX_CMP_LEN_SHIFT;
 	dma_addr = rx_buf->mapping;
 
 	if (bnxt_rx_xdp(bp, rxr, cons, data, &data_ptr, &len, event)) {
@@ -1886,6 +1887,24 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		}
 	}
 
+	if (unlikely((flags & RX_CMP_FLAGS_ITYPES_MASK) ==
+		     RX_CMP_FLAGS_ITYPE_PTP_W_TS)) {
+		if (bp->flags & BNXT_FLAG_CHIP_P5) {
+			u32 cmpl_ts = le32_to_cpu(rxcmp1->rx_cmp_timestamp);
+			u64 ns, ts;
+
+			if (!bnxt_get_rx_ts_p5(bp, &ts, cmpl_ts)) {
+				struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+				spin_lock_bh(&ptp->ptp_lock);
+				ns = timecounter_cyc2time(&ptp->tc, ts);
+				spin_unlock_bh(&ptp->ptp_lock);
+				memset(skb_hwtstamps(skb), 0,
+				       sizeof(*skb_hwtstamps(skb)));
+				skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ns);
+			}
+		}
+	}
 	bnxt_deliver_skb(bp, bnapi, skb);
 	rc = 1;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 696163559b64..94a612e8cd42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -159,6 +159,7 @@ struct rx_cmp {
 	#define RX_CMP_FLAGS_RSS_VALID				(1 << 10)
 	#define RX_CMP_FLAGS_UNUSED				(1 << 11)
 	 #define RX_CMP_FLAGS_ITYPES_SHIFT			 12
+	 #define RX_CMP_FLAGS_ITYPES_MASK			 0xf000
 	 #define RX_CMP_FLAGS_ITYPE_UNKNOWN			 (0 << 12)
 	 #define RX_CMP_FLAGS_ITYPE_IP				 (1 << 12)
 	 #define RX_CMP_FLAGS_ITYPE_TCP				 (2 << 12)
@@ -240,7 +241,7 @@ struct rx_cmp_ext {
 	#define RX_CMPL_CFA_CODE_MASK				(0xffff << 16)
 	 #define RX_CMPL_CFA_CODE_SFT				 16
 
-	__le32 rx_cmp_unused3;
+	__le32 rx_cmp_timestamp;
 };
 
 #define RX_CMP_L2_ERRORS						\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index b0563c7761ff..cea7220f3d1b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -279,6 +279,22 @@ static long bnxt_ptp_ts_aux_work(struct ptp_clock_info *ptp_info)
 	return HZ;
 }
 
+int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u64 time;
+
+	if (!ptp)
+		return -ENODEV;
+
+	BNXT_READ_TIME64(ptp, time, ptp->old_time);
+	*ts = (time & BNXT_HI_TIMER_MASK) | pkt_ts;
+	if (pkt_ts < (time & BNXT_LO_TIMER_MASK))
+		*ts += BNXT_LO_TIMER_MASK + 1;
+
+	return 0;
+}
+
 void bnxt_ptp_start(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 61a67055c812..4f2c62f5a78e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -58,8 +58,21 @@ struct bnxt_ptp_cfg {
 	u32			refclk_mapped_regs[2];
 };
 
+#if BITS_PER_LONG == 32
+#define BNXT_READ_TIME64(ptp, dst, src)		\
+do {						\
+	spin_lock_bh(&(ptp)->ptp_lock);		\
+	(dst) = (src);				\
+	spin_unlock_bh(&(ptp)->ptp_lock);	\
+} while (0)
+#else
+#define BNXT_READ_TIME64(ptp, dst, src)		\
+	((dst) = READ_ONCE(src))
+#endif
+
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
 void bnxt_ptp_start(struct bnxt *bp);
 int bnxt_ptp_init(struct bnxt *bp);
 void bnxt_ptp_clear(struct bnxt *bp);
-- 
2.18.1


--0000000000002184c205c5c297b1
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICJ6Bi76uMcr6CqeTc5ucDRwYxqHH9m1
TOxE9aRDyZC/MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDYy
NzE3MjAzM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCfmES5XX3Z5njQgXwDCMro0GMqYYM9PPr8AsmrpcqriUOdQ2yj
XevVQcrB2Af0QyoxMnTK2ZXqLwqHIhBCzJoBnpavRGJimQhNm1g8sSRaiDPBrt28Kl9arhsBI1pq
+lBdSFEGkypTh5xVW2BJHxSNUlUeuAmIgCQMNi9qyedoDhAnc4z0X7PgJe5SAMAJKsecJYCdx2D4
+dGL5quo2pkzbrStCCrj8BcZfkCTQearnxXetxw8egU2dq47c5X5uxk/DGCilJFviHIsvXXL++eI
FXdtB0L8kb60N5+S8QrVBn3/n8HyJ6754HXaiGpoPpxCiuwsQBH1tlkPph68o19+
--0000000000002184c205c5c297b1--
