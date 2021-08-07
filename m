Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A063E36E6
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 21:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhHGTD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 15:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhHGTD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 15:03:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF2C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 12:03:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so13919472pjy.0
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 12:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S/3D3aMDtXVSJFM7tsLzMurd5V2BhLQrS2h6MfO9wr4=;
        b=Dkz7F/timlKKI8zYFblpjK5i/3wLqBYbWNQbV157b0VIxUcpbPXFyUVjjrjo2BNZ29
         w9KG+LNxWL8mtmcsV4FRBPjUKEOiqhF8xgFq4JW4OTJXnDOG3Y90Y8nOpptC5rpgsK9l
         49g3LM5Z3WRTtI+drWiST1BEpJyKrnkWgWYpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S/3D3aMDtXVSJFM7tsLzMurd5V2BhLQrS2h6MfO9wr4=;
        b=ZaBBbzXlfAk5l6zc/tGqstNVKy/nVWI0Gdt9Yz/iMNn83G/bWtR0g0ZCZi5mrAAM7n
         iT4UC+bfBlMw8xQLjMFlyoqW3tw/JnWepo2s0XSo75XkYVbWdXMcendXUOZcOanKqcr4
         xUGuGmaB16aUA6E7s9owjuN2yk1Ts2Z5RS0wZeFTwi8dvSY3A3KD+mUP81efiCMj/jru
         rc2Wu7yqiZa9wAIvwhTbWwTA7Wtf80naVAZo3e1tdX+hi7yhT2fGprDy/PxOPsk7iGbt
         lITVbiOS9gYVGY+q271O+extAr+vg7fPvslNuT0GIcGGqutkxmTc/brQuI0OrNqCIVqd
         nIZg==
X-Gm-Message-State: AOAM530hUn9b5Et57qAQjRXEk6vTPKRpzUCeoGoU1eD65Gb4B9eyOE82
        1ORqVUBgngVD6Z4o5FuEnO9TeQ==
X-Google-Smtp-Source: ABdhPJzm4ENuHp7tHAdxjuE4AhJdUPiegYbclUd/wzgXCGQqR5Suq0zxU8jWjHd2e9BZGAcV2r8Y4w==
X-Received: by 2002:a17:90b:295:: with SMTP id az21mr16954804pjb.123.1628363020392;
        Sat, 07 Aug 2021 12:03:40 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o18sm3378006pjp.1.2021.08.07.12.03.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Aug 2021 12:03:39 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com
Subject: [PATCH net 2/3] bnxt_en: Update firmware call to retrieve TX PTP timestamp
Date:   Sat,  7 Aug 2021 15:03:14 -0400
Message-Id: <1628362995-7938-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
References: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006dcec605c8fccf7f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006dcec605c8fccf7f

New firmware interface requires the PTP sequence ID header offset to
be passed to the firmware to properly find the matching timestamp
for all protocols.

Fixes: 83bb623c968e ("bnxt_en: Transmit and retrieve packet timestamps")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 5 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 6 ++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 89606587b156..2fe743503949 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -426,7 +426,10 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		if (ptp && ptp->tx_tstamp_en && !skb_is_gso(skb) &&
 		    atomic_dec_if_positive(&ptp->tx_avail) >= 0) {
-			if (!bnxt_ptp_parse(skb, &ptp->tx_seqid)) {
+			if (!bnxt_ptp_parse(skb, &ptp->tx_seqid,
+					    &ptp->tx_hdr_off)) {
+				if (vlan_tag_flags)
+					ptp->tx_hdr_off += VLAN_HLEN;
 				lflags |= cpu_to_le32(TX_BD_FLAGS_STAMP);
 				skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			} else {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index ec381c2423b8..81f40ab748f1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -20,7 +20,7 @@
 #include "bnxt.h"
 #include "bnxt_ptp.h"
 
-int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id)
+int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off)
 {
 	unsigned int ptp_class;
 	struct ptp_header *hdr;
@@ -34,6 +34,7 @@ int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id)
 		if (!hdr)
 			return -EINVAL;
 
+		*hdr_off = (u8 *)hdr - skb->data;
 		*seq_id	 = ntohs(hdr->sequence_id);
 		return 0;
 	default:
@@ -91,6 +92,7 @@ static int bnxt_hwrm_port_ts_query(struct bnxt *bp, u32 flags, u64 *ts)
 	    PORT_TS_QUERY_REQ_FLAGS_PATH_TX) {
 		req.enables = cpu_to_le16(BNXT_PTP_QTS_TX_ENABLES);
 		req.ptp_seq_id = cpu_to_le32(bp->ptp_cfg->tx_seqid);
+		req.ptp_hdr_offset = cpu_to_le16(bp->ptp_cfg->tx_hdr_off);
 		req.ts_req_timeout = cpu_to_le16(BNXT_PTP_QTS_TIMEOUT);
 	}
 	mutex_lock(&bp->hwrm_cmd_lock);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 254ba7bc0f99..57a8b9243a31 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -19,7 +19,8 @@
 
 #define BNXT_PTP_QTS_TIMEOUT	1000
 #define BNXT_PTP_QTS_TX_ENABLES	(PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID |	\
-				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT)
+				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT | \
+				 PORT_TS_QUERY_REQ_ENABLES_PTP_HDR_OFFSET)
 
 struct bnxt_ptp_cfg {
 	struct ptp_clock_info	ptp_info;
@@ -37,6 +38,7 @@ struct bnxt_ptp_cfg {
 	#define BNXT_PHC_OVERFLOW_PERIOD	(19 * 3600 * HZ)
 
 	u16			tx_seqid;
+	u16			tx_hdr_off;
 	struct bnxt		*bp;
 	atomic_t		tx_avail;
 #define BNXT_MAX_TX_TS	1
@@ -74,7 +76,7 @@ do {						\
 	((dst) = READ_ONCE(src))
 #endif
 
-int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id);
+int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
 int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
-- 
2.18.1


--0000000000006dcec605c8fccf7f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINAGrFr33E7zOnU/QdDeDbcX2xiwCUD7
CaleQE+Vmy27MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgw
NzE5MDM0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQANndnqwBH//2pgqpp92pelTX9rlNSqTy2XP8biyfoXXBDJwSzi
pXd6TkQEHyRDE49wXf7nvZl1urNCyjWkBJN3hy96IgTWjkOlncUA+/JiFAIvJSA9ie6cXzqsOIt5
OhmeXWsuGpu5mCHWyginBUPE0ovy9sqtfd0hzsLchTFYDzkMTPIhXxL8dTLrjMqsFxIwUdCWiDo+
yGsUKNUgU5tx61hZre6KGpwoKshN00ZX79sdZEZE++v1ihnnd/0OACdjRVD9kyO0XYeJ/vvwO7f0
oF9lBL1yuOc9QbR0tSNZgHTm4Qb8qVl0SkKEY1qyj2WBGL3y5yivKEXbr2XZwmRw
--0000000000006dcec605c8fccf7f--
