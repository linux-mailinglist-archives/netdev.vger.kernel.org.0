Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB851BF5BA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgD3Kj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:39:57 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:47263 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgD3Kj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:39:56 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mn2eH-1imlQV01yR-00kARQ; Thu, 30 Apr 2020 12:39:28 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        YueHaibing <yuehaibing@huawei.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4/chcr: avoid -Wreturn-local-addr warning
Date:   Thu, 30 Apr 2020 12:39:02 +0200
Message-Id: <20200430103912.1170231-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:5+w+rmHduM4USb7BbUDtV2T/6YuOUWXDJBzD599DTfCLafCrRgA
 c6zBQaNIYZY80MMSO/ydDLWhgTbJLeKjAX5yruj2ouxILc3UE0KV1Tt9UhZaqPnNxEKnj0T
 MV5/U01GI7Q5B4iKnfo9iE6gWGYJ+Hp3czl0eklRVsBG9qCEE5mdlXo4u3rfp2C8oFHHgZI
 x67vb4vpOdmrJ3UmiBg3A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TRKCmxFftsw=:KEs2ut/AuE2a118kdJ3q7s
 +cbXLWdoPnWdXXYr95kAB7H0p3Lhqeh0on2ixQwOS/UB2zNyjrxgYM2PaOmjTUE6jSlN2WxHE
 sKxGzysrzamToZzTGWj1DvdQxKz7rX11ek9SVlmrzDzf4+xr3it21gWxCzwTrh++erD9tZeRM
 5S1kIsCVT359pCTl89pP/t+jPGBTy4dbRoVaywxP3pQaHX+8AOHaBKlzOHs0EfM6V7FeXSIw3
 fpjWwPMR5AStKgZBSm50PX0MFSw/AErs7kHi0tej/AeMJ5dQ82Ss3KusX9lSQ8tU5wOQw5Wc6
 yn48sRVmK/RG92Z1kut0GzMGrnyWjI6xyLJyiwoLqB2KRxJ00ZktuYjFH1g/fXF47TxEIzIGZ
 +0np/5ein2OhfTMW598Puuw0dagtH6uFuz0YSf3S2NqNnlOJ3A1kwQ5Bs/81hakR5F7r6HhBJ
 c+fe6ymWdtQ1H87YSidNi+35Uj4+uv0/iRlrdVNPC5dFdpfRcJ5LLXU7/D9Tnk0rxhev94bIC
 58MOH4VGGFviz6YJbrnY9n+dcZ6JKDbQBMz/z8yjvFuIby79iN4BK7VZYsEbYzhoD22+uOU5a
 TqrYOXAEayewz4gydgxAWI3H6TA3udItHkX5xMuMeu7vcBmddGarsfVB+/QyidD7kMuamFP9J
 rOcS359cBIgcA3re6eJYkyTwL9a2horq5klQ5CyabQbLuAAebkOPQoimZO06IbGftBCbFJOpl
 jFBS4JvaiHURYLxwUfZHckUannbrAoeQ4IU4lTgPfveA6br5UlFHxzKlNICLzmeeM30YmO4pP
 EMvGH08+0i2BItWyRW91C12HBcmskfsPKyNwuJC7pHWZajKwTE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 warns about functions that return a pointer to a stack
variable. In chcr_write_cpl_set_tcb_ulp(), this does not actually
happen, but it's too hard to see for the compiler:

drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_write_cpl_set_tcb_ulp.constprop':
drivers/crypto/chelsio/chcr_ktls.c:760:9: error: function may return address of local variable [-Werror=return-local-addr]
  760 |  return pos;
      |         ^~~
drivers/crypto/chelsio/chcr_ktls.c:712:5: note: declared here
  712 |  u8 buf[48] = {0};
      |     ^~~

Split the middle part of the function out into a helper to make
it easier to understand by both humans and compilers, which avoids
the warning.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/chelsio/chcr_ktls.c | 83 +++++++++++++++++-------------
 1 file changed, 46 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index a4f2d8dae8b9..c286c60dadfd 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -686,41 +686,14 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 	return 0;
 }
 
-/*
- * chcr_write_cpl_set_tcb_ulp: update tcb values.
- * TCB is responsible to create tcp headers, so all the related values
- * should be correctly updated.
- * @tx_info - driver specific tls info.
- * @q - tx queue on which packet is going out.
- * @tid - TCB identifier.
- * @pos - current index where should we start writing.
- * @word - TCB word.
- * @mask - TCB word related mask.
- * @val - TCB word related value.
- * @reply - set 1 if looking for TP response.
- * return - next position to write.
- */
-static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
-					struct sge_eth_txq *q, u32 tid,
-					void *pos, u16 word, u64 mask,
+static void *__chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
+					u32 tid, void *pos, u16 word, u64 mask,
 					u64 val, u32 reply)
 {
 	struct cpl_set_tcb_field_core *cpl;
 	struct ulptx_idata *idata;
 	struct ulp_txpkt *txpkt;
-	void *save_pos = NULL;
-	u8 buf[48] = {0};
-	int left;
 
-	left = (void *)q->q.stat - pos;
-	if (unlikely(left < CHCR_SET_TCB_FIELD_LEN)) {
-		if (!left) {
-			pos = q->q.desc;
-		} else {
-			save_pos = pos;
-			pos = buf;
-		}
-	}
 	/* ULP_TXPKT */
 	txpkt = pos;
 	txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) | ULP_TXPKT_DEST_V(0));
@@ -745,18 +718,54 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 	idata = (struct ulptx_idata *)(cpl + 1);
 	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_NOOP));
 	idata->len = htonl(0);
+	pos = idata + 1;
 
-	if (save_pos) {
-		pos = chcr_copy_to_txd(buf, &q->q, save_pos,
-				       CHCR_SET_TCB_FIELD_LEN);
-	} else {
-		/* check again if we are at the end of the queue */
-		if (left == CHCR_SET_TCB_FIELD_LEN)
+	return pos;
+}
+
+
+/*
+ * chcr_write_cpl_set_tcb_ulp: update tcb values.
+ * TCB is responsible to create tcp headers, so all the related values
+ * should be correctly updated.
+ * @tx_info - driver specific tls info.
+ * @q - tx queue on which packet is going out.
+ * @tid - TCB identifier.
+ * @pos - current index where should we start writing.
+ * @word - TCB word.
+ * @mask - TCB word related mask.
+ * @val - TCB word related value.
+ * @reply - set 1 if looking for TP response.
+ * return - next position to write.
+ */
+static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
+					struct sge_eth_txq *q, u32 tid,
+					void *pos, u16 word, u64 mask,
+					u64 val, u32 reply)
+{
+	int left = (void *)q->q.stat - pos;
+
+	if (unlikely(left < CHCR_SET_TCB_FIELD_LEN)) {
+		if (!left) {
 			pos = q->q.desc;
-		else
-			pos = idata + 1;
+		} else {
+			u8 buf[48] = {0};
+
+			__chcr_write_cpl_set_tcb_ulp(tx_info, tid, buf, word,
+						     mask, val, reply);
+
+			return chcr_copy_to_txd(buf, &q->q, pos,
+						CHCR_SET_TCB_FIELD_LEN);
+		}
 	}
 
+	pos = __chcr_write_cpl_set_tcb_ulp(tx_info, tid, pos, word,
+					   mask, val, reply);
+
+	/* check again if we are at the end of the queue */
+	if (left == CHCR_SET_TCB_FIELD_LEN)
+		pos = q->q.desc;
+
 	return pos;
 }
 
-- 
2.26.0

