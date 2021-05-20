Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA6389AB8
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 03:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhETBHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 21:07:14 -0400
Received: from m12-14.163.com ([220.181.12.14]:57474 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhETBHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 21:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=YOchqfhpn3lK2OOd3n
        pIduxooTbqyf1OrzYjh6gcgIE=; b=UfdiT528QWiFQVNDEHQc7ohjshGLBepBWC
        lIQaK6nm+bM6upKeBT3IPDOvpxA0T8hlHOt3Uekw7j8Eo5zKrG3xJVX3VcunabaT
        bl/hmPJsscw/s3svgsi1xdoxsoRXUFGAIIfYky5qyUzmi4pz0esOE3GGM9PL/BOW
        +PZp7btNk=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAC3EW_ktaVgHLaSJw--.37542S2;
        Thu, 20 May 2021 09:05:42 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     gustavoars@kernel.org, hslester96@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH RESEND] NFC: st21nfca: remove unnecessary variable and labels
Date:   Thu, 20 May 2021 09:05:50 +0800
Message-Id: <20210520010550.31240-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowAC3EW_ktaVgHLaSJw--.37542S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrWkKF17Gr1rJFy5WF1Dtrb_yoW5ur13pa
        yagrykArW8Gry2gr45uw4rAas09w4vvry7GFy5C3WSvw4jyr93XF1rG3WS9r45tr95Cw15
        Aw42qr4kWr9rJrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b5GQDUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiLwaYsVUMYlGKBwAAsn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

assign vlue (EIO/EPROTO) to variable r, and goto exit label,
but just return r follow exit label, so we delete exit label,
and just replace with return sentence.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/st21nfca/dep.c | 59 ++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 41 deletions(-)

diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index 8874d60..1ec651e 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -196,38 +196,29 @@ static int st21nfca_tm_recv_atr_req(struct nfc_hci_dev *hdev,
 
 	skb_trim(skb, skb->len - 1);
 
-	if (!skb->len) {
-		r = -EIO;
-		goto exit;
-	}
+	if (!skb->len)
+		return -EIO;
 
-	if (skb->len < ST21NFCA_ATR_REQ_MIN_SIZE) {
-		r = -EPROTO;
-		goto exit;
-	}
+	if (skb->len < ST21NFCA_ATR_REQ_MIN_SIZE)
+		return -EPROTO;
 
 	atr_req = (struct st21nfca_atr_req *)skb->data;
 
-	if (atr_req->length < sizeof(struct st21nfca_atr_req)) {
-		r = -EPROTO;
-		goto exit;
-	}
+	if (atr_req->length < sizeof(struct st21nfca_atr_req))
+		return -EPROTO;
 
 	r = st21nfca_tm_send_atr_res(hdev, atr_req);
 	if (r)
-		goto exit;
+		return r;
 
 	gb_len = skb->len - sizeof(struct st21nfca_atr_req);
 
 	r = nfc_tm_activated(hdev->ndev, NFC_PROTO_NFC_DEP_MASK,
 			      NFC_COMM_PASSIVE, atr_req->gbi, gb_len);
 	if (r)
-		goto exit;
-
-	r = 0;
+		return r;
 
-exit:
-	return r;
+	return 0;
 }
 
 static int st21nfca_tm_send_psl_res(struct nfc_hci_dev *hdev,
@@ -280,25 +271,18 @@ static int st21nfca_tm_recv_psl_req(struct nfc_hci_dev *hdev,
 				    struct sk_buff *skb)
 {
 	struct st21nfca_psl_req *psl_req;
-	int r;
 
 	skb_trim(skb, skb->len - 1);
 
-	if (!skb->len) {
-		r = -EIO;
-		goto exit;
-	}
+	if (!skb->len)
+		return -EIO;
 
 	psl_req = (struct st21nfca_psl_req *)skb->data;
 
-	if (skb->len < sizeof(struct st21nfca_psl_req)) {
-		r = -EIO;
-		goto exit;
-	}
+	if (skb->len < sizeof(struct st21nfca_psl_req))
+		return -EIO;
 
-	r = st21nfca_tm_send_psl_res(hdev, psl_req);
-exit:
-	return r;
+	return st21nfca_tm_send_psl_res(hdev, psl_req);
 }
 
 int st21nfca_tm_send_dep_res(struct nfc_hci_dev *hdev, struct sk_buff *skb)
@@ -324,7 +308,6 @@ static int st21nfca_tm_recv_dep_req(struct nfc_hci_dev *hdev,
 {
 	struct st21nfca_dep_req_res *dep_req;
 	u8 size;
-	int r;
 	struct st21nfca_hci_info *info = nfc_hci_get_clientdata(hdev);
 
 	skb_trim(skb, skb->len - 1);
@@ -332,20 +315,16 @@ static int st21nfca_tm_recv_dep_req(struct nfc_hci_dev *hdev,
 	size = 4;
 
 	dep_req = (struct st21nfca_dep_req_res *)skb->data;
-	if (skb->len < size) {
-		r = -EIO;
-		goto exit;
-	}
+	if (skb->len < size)
+		return -EIO;
 
 	if (ST21NFCA_NFC_DEP_DID_BIT_SET(dep_req->pfb))
 		size++;
 	if (ST21NFCA_NFC_DEP_NAD_BIT_SET(dep_req->pfb))
 		size++;
 
-	if (skb->len < size) {
-		r = -EIO;
-		goto exit;
-	}
+	if (skb->len < size)
+		return -EIO;
 
 	/* Receiving DEP_REQ - Decoding */
 	switch (ST21NFCA_NFC_DEP_PFB_TYPE(dep_req->pfb)) {
@@ -364,8 +343,6 @@ static int st21nfca_tm_recv_dep_req(struct nfc_hci_dev *hdev,
 	skb_pull(skb, size);
 
 	return nfc_tm_data_received(hdev->ndev, skb);
-exit:
-	return r;
 }
 
 static int st21nfca_tm_event_send_data(struct nfc_hci_dev *hdev,
-- 
1.9.1

