Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A6A9DAB8
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 02:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfH0Aeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 20:34:36 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42656 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbfH0Aeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 20:34:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id i30so12889386pfk.9
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 17:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Vs+TQr7hHy2v8MzMkCOjJVcnNTmLTAgeFS/JpBulfo=;
        b=TbRrANRIH92j2fSmCx5BdSbQOzmBU/XbqoZ7xd1Ww6AaUEz68WzvbdIanurUAl4uCi
         TY5ohivdtzQn+XaVmJg6fPUKxrj24BAg74pSnwI7DkAuOrdvMiXXCrTy2hSlOyRnUj+6
         wtSltIyQcEmY1aect58Y183r1a351O76l3nNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Vs+TQr7hHy2v8MzMkCOjJVcnNTmLTAgeFS/JpBulfo=;
        b=nuypLgwD6WLfZQS7zaFmRmbz9V6EtBV9PwtoXru/Piv210/5X3qG5F6ykOQNgTRdsu
         ++Fn1B+kLPsu0nbmyTbqrZ+8Y6KxkGyU1rmWDwCXp/Rh6znm/dTbvnOjmf1PnVg6GgSF
         PB2wwQr6CKGmRltn6bYnQYosouBHSXrwGTVHIs+lvwZmAVawW92a88U3XfMbGUbQmdFA
         FafuZCb1+hOqjPrfaUB16sPMDnMNh91Vl90JL75ZBAh167DcgA2qJdBjHSfnRX/qxNpk
         z/oF8IEKRmy8FObRI8Si1605SwO7IOYVpdr++hx1pnchYKWk9jw8D8287r3w5PACSLIx
         MKDQ==
X-Gm-Message-State: APjAAAVP3ObqHVtZTCxhCCpn6ryH2Slt/oEbzDhRB9WjxnfMNDlsGuC7
        P8Ad7AIeR4yRdfpKGQykJORTKw==
X-Google-Smtp-Source: APXvYqyXHySgZZYqvzNM28Yd+pRvNdNbnVHxIZpOA4FgrKCaNtwMUDuAlL2eCKLsx6jrUwC8C3dTJQ==
X-Received: by 2002:a05:6a00:8e:: with SMTP id c14mr22563388pfj.241.1566866074901;
        Mon, 26 Aug 2019 17:34:34 -0700 (PDT)
Received: from drinkcat2.tpe.corp.google.com ([2401:fa00:1:b:d8b7:33af:adcb:b648])
        by smtp.gmail.com with ESMTPSA id a23sm9081429pfc.71.2019.08.26.17.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 17:34:34 -0700 (PDT)
From:   Nicolas Boichat <drinkcat@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wgong@codeaurora.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        briannorris@chromium.org, tientzu@chromium.org
Subject: [PATCH,RFC] ath10k: Fix skb->len (properly) in ath10k_sdio_mbox_rx_packet
Date:   Tue, 27 Aug 2019 08:33:26 +0800
Message-Id: <20190827003326.147452-1-drinkcat@chromium.org>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(not a formal patch, take this as a bug report for now, I can clean
up depending on the feedback I get here)

There's at least 3 issues here, and the patch fixes 2/3 only, I'm not sure
how/if 1 should be handled.
 1. ath10k_sdio_mbox_rx_alloc allocating skb of a incorrect size (too
    small)
 2. ath10k_sdio_mbox_rx_packet calling skb_put with that incorrect size.
 3. ath10k_sdio_mbox_rx_process_packet attempts to fixup the size, but
    does not use proper skb_put commands to do so, so we end up with
    a mismatch between skb->head + skb->tail and skb->data + skb->len.

Let's start with 3, this is quite serious as this and causes corruptions
in the TCP stack, as the stack tries to coalesce packets, and relies on
skb->tail being correct (that is, skb_tail_pointer must point to the
first byte _after_ the data): one must never manipulate skb->len
directly.

Instead, we need to use skb_put to allocate more space (which updates
skb->len and skb->tail). But it seems odd to do that in
ath10k_sdio_mbox_rx_process_packet, so I move the code to
ath10k_sdio_mbox_rx_packet (point 2 above).

However, there is still something strange (point 1 above), why is
ath10k_sdio_mbox_rx_alloc allocating packets of the incorrect
(too small?) size? What happens if the packet is bigger than alloc_len?
Does this lead to corruption/lost data?

Fixes: 8530b4e7b22bc3b ("ath10k: sdio: set skb len for all rx packets")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>

---

One simple way to test this is this scriplet, that sends a lot of
small packets over SSH:
(for i in `seq 1 300`; do echo $i; sleep 0.1; done) | ssh $IP cat

In my testing it rarely ever reach 300 without failure.

 drivers/net/wireless/ath/ath10k/sdio.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 8ed4fbd8d6c3888..a9f5002863ee7bb 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -381,16 +381,14 @@ static int ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
 	struct ath10k_htc_hdr *htc_hdr = (struct ath10k_htc_hdr *)skb->data;
 	bool trailer_present = htc_hdr->flags & ATH10K_HTC_FLAG_TRAILER_PRESENT;
 	enum ath10k_htc_ep_id eid;
-	u16 payload_len;
 	u8 *trailer;
 	int ret;
 
-	payload_len = le16_to_cpu(htc_hdr->len);
-	skb->len = payload_len + sizeof(struct ath10k_htc_hdr);
+	/* TODO: Remove this? */
+	WARN_ON(skb->len != le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr));
 
 	if (trailer_present) {
-		trailer = skb->data + sizeof(*htc_hdr) +
-			  payload_len - htc_hdr->trailer_len;
+		trailer = skb->data + skb->len - htc_hdr->trailer_len;
 
 		eid = pipe_id_to_eid(htc_hdr->eid);
 
@@ -637,8 +635,16 @@ static int ath10k_sdio_mbox_rx_packet(struct ath10k *ar,
 	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
 				 skb->data, pkt->alloc_len);
 	pkt->status = ret;
-	if (!ret)
+	if (!ret) {
+		/* Update actual length. */
+		/* FIXME: This looks quite wrong, why is pkt->act_len not
+		 * correct in the first place?
+		 */
+		struct ath10k_htc_hdr *htc_hdr =
+			(struct ath10k_htc_hdr *)skb->data;
+		pkt->act_len = le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr);
 		skb_put(skb, pkt->act_len);
+	}
 
 	return ret;
 }
-- 
2.23.0.187.g17f5b7556c-goog

