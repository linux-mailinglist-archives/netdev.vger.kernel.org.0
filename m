Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB48F3FD0A0
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbhIABQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241207AbhIABQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:16:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0A4C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 18:15:32 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k24so1068303pgh.8
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 18:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=FemXNJWqoTE/PHwIMdMwncwNgKgnaH+N2XZI6nX3pdE=;
        b=Wt3mLhUzXtepVYsbkiOTBwQNYnDFmkozsSIAAUduD4+51P1PqszqtFsY6kbDoO58lO
         UE6aRI1WnBFmuyLxzQ2tWQIunY8foD22hf2lOjpUF2nE0HAolTwhteub0lbhPU3MnGQA
         YbYtyK5A3G3k1l0eF3G95zuOYBb69k0oRDB70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FemXNJWqoTE/PHwIMdMwncwNgKgnaH+N2XZI6nX3pdE=;
        b=YlsG5Cq3xGJ0QOtERwAhK+o6JDZKQ43pqtF61NoJ2acrVhskxvfOrDneyvlx2DHjAQ
         J9g9TOlZsH6T2qncrusgNeId6af07qcyl8tg2O/t12UyChYkjuQQADQzPZK9t7AvP17n
         v0yRDUlz+rxqWjLIVXwKxdeD6/ZKGR7K2iAdSljxW7vq4Y7urEdrlCOkEkvxYp1zOpvL
         M0LwMwXylSUTA3mAJsCF4geYk57D54aIHgm9hG9FxUJJoe+0+eQmp8C7xWX1L4bC+gTS
         P00i5+C/FxiDMmxECySzC5g2StRc/8HbyK7c7Evbwgq758Jn+VqOL5yaPEr7G40Zyj0w
         2jog==
X-Gm-Message-State: AOAM530JgBELS8n+ri+k6mXW+Mf9eZxLDPUGcahGwbMvbZeNDdKmdOij
        roElEyR8jlo9cigsZ7/vprnjJg==
X-Google-Smtp-Source: ABdhPJybDiVaE5QZtKUl65tpny+Y2IHC1dJtajF64Bbd+/vu5gc20DUH7lFCzVuY/jRlkZ7Tircu+Q==
X-Received: by 2002:a63:d250:: with SMTP id t16mr30009315pgi.95.1630458932184;
        Tue, 31 Aug 2021 18:15:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w3sm3887346pjv.0.2021.08.31.18.15.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Aug 2021 18:15:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, florian.fainelli@broadcom.com
Subject: [PATCH net-next v2] bnxt_en: Fix 64-bit doorbell operation on 32-bit kernels
Date:   Tue, 31 Aug 2021 21:15:23 -0400
Message-Id: <1630458923-14161-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000081f5c605cae4cdcd"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000081f5c605cae4cdcd

The driver requires 64-bit doorbell writes to be atomic on 32-bit
architectures.  So we redefined writeq as a new macro with spinlock
protection on 32-bit architectures.  This created a new warning when
we added a new file in a recent patchset.  writeq is defined on many
32-bit architectures to do the memory write non-atomically and it
generated a new macro redefined warning.  This warning was fixed
incorrectly in the recent patch.

Fix this properly by adding a new bnxt_writeq() function that will
do the non-atomic write under spinlock on 32-bit systems.  All callers
in the driver will now call bnxt_writeq() instead.

v2: Need to pass in bp to bnxt_writeq()
    Use lo_hi_writeq() [suggested by Florian]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: f9ff578251dc ("bnxt_en: introduce new firmware message API based on DMA pools")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 +++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 37 +++++++++++++++--------
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 627f85ee3922..acaf1e0f049e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -305,13 +305,15 @@ static bool bnxt_vf_pciid(enum board_idx idx)
 	writel(DB_CP_FLAGS | RING_CMP(idx), (db)->doorbell)
 
 #define BNXT_DB_NQ_P5(db, idx)						\
-	writeq((db)->db_key64 | DBR_TYPE_NQ | RING_CMP(idx), (db)->doorbell)
+	bnxt_writeq(bp, (db)->db_key64 | DBR_TYPE_NQ | RING_CMP(idx),	\
+		    (db)->doorbell)
 
 #define BNXT_DB_CQ_ARM(db, idx)						\
 	writel(DB_CP_REARM_FLAGS | RING_CMP(idx), (db)->doorbell)
 
 #define BNXT_DB_NQ_ARM_P5(db, idx)					\
-	writeq((db)->db_key64 | DBR_TYPE_NQ_ARM | RING_CMP(idx), (db)->doorbell)
+	bnxt_writeq(bp, (db)->db_key64 | DBR_TYPE_NQ_ARM | RING_CMP(idx),\
+		    (db)->doorbell)
 
 static void bnxt_db_nq(struct bnxt *bp, struct bnxt_db_info *db, u32 idx)
 {
@@ -332,8 +334,8 @@ static void bnxt_db_nq_arm(struct bnxt *bp, struct bnxt_db_info *db, u32 idx)
 static void bnxt_db_cq(struct bnxt *bp, struct bnxt_db_info *db, u32 idx)
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5)
-		writeq(db->db_key64 | DBR_TYPE_CQ_ARMALL | RING_CMP(idx),
-		       db->doorbell);
+		bnxt_writeq(bp, db->db_key64 | DBR_TYPE_CQ_ARMALL |
+			    RING_CMP(idx), db->doorbell);
 	else
 		BNXT_DB_CQ(db, idx);
 }
@@ -2638,8 +2640,8 @@ static void __bnxt_poll_cqs_done(struct bnxt *bp, struct bnxt_napi *bnapi,
 
 		if (cpr2 && cpr2->had_work_done) {
 			db = &cpr2->cp_db;
-			writeq(db->db_key64 | dbr_type |
-			       RING_CMP(cpr2->cp_raw_cons), db->doorbell);
+			bnxt_writeq(bp, db->db_key64 | dbr_type |
+				    RING_CMP(cpr2->cp_raw_cons), db->doorbell);
 			cpr2->had_work_done = 0;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a8212dcdad5f..ec046e7a2484 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -28,6 +28,7 @@
 #include <net/dst_metadata.h>
 #include <net/xdp.h>
 #include <linux/dim.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #ifdef CONFIG_TEE_BNXT_FW
 #include <linux/firmware/broadcom/tee_bnxt_fw.h>
 #endif
@@ -1981,7 +1982,7 @@ struct bnxt {
 	struct mutex		sriov_lock;
 #endif
 
-#ifndef writeq
+#if BITS_PER_LONG == 32
 	/* ensure atomic 64-bit doorbell writes on 32-bit systems. */
 	spinlock_t		db_lock;
 #endif
@@ -2110,24 +2111,36 @@ static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
 		((txr->tx_prod - txr->tx_cons) & bp->tx_ring_mask);
 }
 
-#ifndef writeq
-#define writeq(val64, db)			\
-do {						\
-	spin_lock(&bp->db_lock);		\
-	writel((val64) & 0xffffffff, db);	\
-	writel((val64) >> 32, (db) + 4);	\
-	spin_unlock(&bp->db_lock);		\
-} while (0)
+static inline void bnxt_writeq(struct bnxt *bp, u64 val,
+			       volatile void __iomem *addr)
+{
+#if BITS_PER_LONG == 32
+	spin_lock(&bp->db_lock);
+	lo_hi_writeq(val, addr);
+	spin_unlock(&bp->db_lock);
+#else
+	writeq(val, addr);
+#endif
+}
 
-#define writeq_relaxed writeq
+static inline void bnxt_writeq_relaxed(struct bnxt *bp, u64 val,
+				       volatile void __iomem *addr)
+{
+#if BITS_PER_LONG == 32
+	spin_lock(&bp->db_lock);
+	lo_hi_writeq_relaxed(val, addr);
+	spin_unlock(&bp->db_lock);
+#else
+	writeq_relaxed(val, addr);
 #endif
+}
 
 /* For TX and RX ring doorbells with no ordering guarantee*/
 static inline void bnxt_db_write_relaxed(struct bnxt *bp,
 					 struct bnxt_db_info *db, u32 idx)
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
-		writeq_relaxed(db->db_key64 | idx, db->doorbell);
+		bnxt_writeq_relaxed(bp, db->db_key64 | idx, db->doorbell);
 	} else {
 		u32 db_val = db->db_key32 | idx;
 
@@ -2142,7 +2155,7 @@ static inline void bnxt_db_write(struct bnxt *bp, struct bnxt_db_info *db,
 				 u32 idx)
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
-		writeq(db->db_key64 | idx, db->doorbell);
+		bnxt_writeq(bp, db->db_key64 | idx, db->doorbell);
 	} else {
 		u32 db_val = db->db_key32 | idx;
 
-- 
2.18.1


--00000000000081f5c605cae4cdcd
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIphrBl1W18p91B9x8hKDe6OR/ziAb/B
d9ThMOLpG/57MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkw
MTAxMTUzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAvgAojVEQO4EbxVjQfglCRWKDpEwVUo0543RopwBZE/uYvoqxb
PyCslCCDf+whoDgfT5jPnPEuD4uujGn3EPCXofGr18huSTB92e4LeDtL81etDuWebQHLq9J9aLvi
PsPXi1L7T21dicvulgowGwdToPfow0yjiKk5hX4K11BxCaCToH2lashN8liSdvbqte1IubJbX+r9
mWVtn4rVsQz9nJGS2gCZA/IP/1H01TrGKh8aFBxabTfaQmIG2xVrvVpDrN81hShcHebWaH1Fd6x4
KcfzwS3YcRQVyt3H+cARyDXQrJnfliK+UgdsN8CKbEK6ajnVSpc9DDtRNWKI0JbA
--00000000000081f5c605cae4cdcd--
