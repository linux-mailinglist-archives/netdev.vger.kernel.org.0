Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288A533B03
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfFCWSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:01 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:45882 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfFCWSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:01 -0400
Received: by mail-qt1-f171.google.com with SMTP id j19so7729902qtr.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+pqKDfPQGT7rKqlNa/CLyaTMQNxGWiEIT0uvpF0Ts8=;
        b=IGrg8U8Fy72poqkfLJoJMki36I8xxADvy/aE0TVCaLsf/N08zGP8n77TIvuxfkLSDq
         UJK3lA5Xzx+xZCsl31GWi50uZ9nAe2B8h6dmpUlhirzhokUaq4X3hTEyiqX5Dyou5899
         95RrExKKMZU9HJaQAgcMqySherLSw6qcHBxaDs+8UnblyYvZuq91mCxkbtB7dd6T64qX
         15NDHrTOiDCzWxCOaVNQxBZUdSvVHvUMQitguCjl8UEYsDE3eOvHV07TQgoVBkVURy5D
         BfgeDy193nIJLw9Qh9BKUDSDtAlrSm7Tw6ma65oBINXzO4MTM0BPaElgl323+UKzKYrP
         QeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+pqKDfPQGT7rKqlNa/CLyaTMQNxGWiEIT0uvpF0Ts8=;
        b=I6LR/+IXc650jpb7yuchLVV3JQs+wOfDj4sH9EdLTthGJNLVgK0hh27ShPRkHvq0H+
         cP7kBBkpgOH1akD5dGRh4B8+1oVQ9BL/OoGNf2VQE9LfcQlBzgHQPz2ax738LLGnZ+N2
         ZPSWklzj+mR/S85lttZQJu0/ZZrjHTUUynXN4o6yFbPG6veIx8QesSBeWjU3kxzVPSMB
         v6ckjmVN8/MW8RnSRJPMJ8LZsKxS4hLuR+ZIngSmGcAqXIZRhzetDWt1VW75Y1qAm3I5
         QRR257zJi8Mt+/saZhGekdT5VCqa8fTpFUtDHCmtIDbx2rzoRx2czhEOyAbZBlng21dS
         YjOQ==
X-Gm-Message-State: APjAAAUb/nBk91hkGwlvl0vhLT4sRAcjYaScJxzDmScaW1Ph8KTu4lfv
        7B4OQbhSZhKunVqpI9eRoECZ7g==
X-Google-Smtp-Source: APXvYqzXnCk4vipqpcySFfs5BPFfQdTyXEYc5HKJlGtemHurS+Iu2zMcsdbgosXqINI9cdCafL5mqA==
X-Received: by 2002:a0c:d196:: with SMTP id e22mr24145318qvh.75.1559600279903;
        Mon, 03 Jun 2019 15:17:59 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.17.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:17:59 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 3/8] net/tls: remove false positive warning
Date:   Mon,  3 Jun 2019 15:17:00 -0700
Message-Id: <20190603221705.12602-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that TCP stack will decide to retransmit a packet
right when that packet's data gets acked, especially in presence
of packet reordering.  This means that packets may be in flight,
even though tls_device code has already freed their record state.
Make fill_sg_in() and in turn tls_sw_fallback() not generate a
warning in that case, and quietly proceed to drop such frames.

Make the exit path from tls_sw_fallback() drop monitor friendly,
for users to be able to troubleshoot dropped retransmissions.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 Documentation/networking/tls-offload.rst | 19 -------------------
 net/tls/tls_device_fallback.c            |  6 ++++--
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index cb85af559dff..eb7c9b81ccf5 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -379,7 +379,6 @@ Following minimum set of TLS-related statistics should be reported
    but did not arrive in the expected order
  * ``tx_tls_drop_no_sync_data`` - number of TX packets dropped because
    they arrived out of order and associated record could not be found
-   (see also :ref:`pre_tls_data`)
 
 Notable corner cases, exceptions and additional requirements
 ============================================================
@@ -462,21 +461,3 @@ Redirects leak clear text
 
 In the RX direction, if segment has already been decrypted by the device
 and it gets redirected or mirrored - clear text will be transmitted out.
-
-.. _pre_tls_data:
-
-Transmission of pre-TLS data
-----------------------------
-
-User can enqueue some already encrypted and framed records before enabling
-``ktls`` on the socket. Those records have to get sent as they are. This is
-perfectly easy to handle in the software case - such data will be waiting
-in the TCP layer, TLS ULP won't see it. In the offloaded case when pre-queued
-segment reaches transmission point it appears to be out of order (before the
-expected TCP sequence number) and the stack does not have a record information
-associated.
-
-All segments without record information cannot, however, be assumed to be
-pre-queued data, because a race condition exists between TCP stack queuing
-a retransmission, the driver seeing the retransmission and TCP ACK arriving
-for the retransmitted data.
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index c3a5fe624b4e..5a087e1981c3 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -240,7 +240,6 @@ static int fill_sg_in(struct scatterlist *sg_in,
 	record = tls_get_record(ctx, tcp_seq, rcd_sn);
 	if (!record) {
 		spin_unlock_irqrestore(&ctx->lock, flags);
-		WARN(1, "Record not found for seq %u\n", tcp_seq);
 		return -EINVAL;
 	}
 
@@ -409,7 +408,10 @@ static struct sk_buff *tls_sw_fallback(struct sock *sk, struct sk_buff *skb)
 		put_page(sg_page(&sg_in[--resync_sgs]));
 	kfree(sg_in);
 free_orig:
-	kfree_skb(skb);
+	if (nskb)
+		consume_skb(skb);
+	else
+		kfree_skb(skb);
 	return nskb;
 }
 
-- 
2.21.0

