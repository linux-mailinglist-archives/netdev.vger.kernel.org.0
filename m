Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCC562E5C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGICx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:56 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45171 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbfGICxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so20143243qtr.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vWrLR+gW2eoNgMlfZYg4XY4ne8l73oqqtjzTtqJM/lg=;
        b=z2n3IRmSCbn/wRVkiaol2TO75BTzirzqFIVmqUP0rBdKsRUdpBb5K60JvyLYYvdkqy
         M73LFfVVqJC5Q+j8o5vKSZfIKtu4nZf8XGH7nrB46nkiTaXZykPwOz7S1ePy2uuuhCHz
         e5p6cQ+EyVzyWYE4UPxvWmkxX/Lin9i7heUkUgI0lPEVCSuV9N/h9DioPOTKeDuHPP09
         Y4/SMKTpHAD3UY1GaiKtXAIvdSE07wskiKYvmXXD94Lf3LLcFI3Wy/XNRMsOgDbOUUc+
         29TVTSC3eyZklSBhhrL7GSNAxLalwPKMA2+La3T72DhOjYVYhjPpRewLUHKolwQ0GUrh
         Lh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWrLR+gW2eoNgMlfZYg4XY4ne8l73oqqtjzTtqJM/lg=;
        b=qcQus8pNrdPkMz4f+wmSKQxy3jIDMLUOFZOp44aB5AuJ8PLoh1lydgfkkL2Ktrdfe4
         j7ncORatgmcXlSWON2k55iIcoD77QwPmnI2vJorXBqqlbu5DDxhhFSMxCLUcV1MPcS47
         VbXDqJJ+/gEw4lEDUr8SOj37aR1OD+wcKSt0MrZl98ju+rDUC3IvQRKKr5Ps5vvfw5ok
         LsiidQ7u4ZV+ouJlyB/OB649ztE4PCKTn2a7tG01j0gRNJ1cyoXspTp3mBwEQVVFH3kj
         JZo2KVNNuFTlH0BT0a7UbgslOWiQN6oGn2lRdTgbO06a8xKCNCcYXRC+iyPkOZyA5a4g
         fUKA==
X-Gm-Message-State: APjAAAUWAJPoonL0xm84bm6H3+05sc9/ILmV9ZrkJ6ACHI39avenJadu
        0bwsXjBBbTzEiUq6okMOv3Qn/g==
X-Google-Smtp-Source: APXvYqysjsjDPHCVFeer2WqSwz2uwXk7+kOLoa3Zz6ZPbFTkT9BuFAtWAkaS0l1FOYF0qPHsVi9dsQ==
X-Received: by 2002:a0c:e588:: with SMTP id t8mr17322173qvm.179.1562640834046;
        Mon, 08 Jul 2019 19:53:54 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:53 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 07/11] nfp: tls: don't leave key material in freed FW cmsg skbs
Date:   Mon,  8 Jul 2019 19:53:14 -0700
Message-Id: <20190709025318.5534-8-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the contents of the skb which carried key material
to the FW is cleared.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index d448c6de8ea4..96a96b35c0ca 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -4,6 +4,7 @@
 #include <linux/bitfield.h>
 #include <linux/ipv6.h>
 #include <linux/skbuff.h>
+#include <linux/string.h>
 #include <net/tls.h>
 
 #include "../ccm.h"
@@ -340,8 +341,22 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	memcpy(&back->salt, tls_ci->salt, TLS_CIPHER_AES_GCM_128_SALT_SIZE);
 	memcpy(back->rec_no, tls_ci->rec_seq, sizeof(tls_ci->rec_seq));
 
+	/* Get an extra ref on the skb so we can wipe the key after */
+	skb_get(skb);
+
 	err = nfp_ccm_mbox_communicate(nn, skb, NFP_CCM_TYPE_CRYPTO_ADD,
 				       sizeof(*reply), sizeof(*reply));
+	reply = (void *)skb->data;
+
+	/* We depend on CCM MBOX code not reallocating skb we sent
+	 * so we can clear the key material out of the memory.
+	 */
+	if (!WARN_ON_ONCE((u8 *)back < skb->head ||
+			  (u8 *)back > skb_end_pointer(skb)) &&
+	    !WARN_ON_ONCE((u8 *)&reply[1] > (u8 *)back))
+		memzero_explicit(back, sizeof(*back));
+	dev_consume_skb_any(skb); /* the extra ref from skb_get() above */
+
 	if (err) {
 		nn_dp_warn(&nn->dp, "failed to add TLS: %d (%d)\n",
 			   err, direction == TLS_OFFLOAD_CTX_DIR_TX);
@@ -349,7 +364,6 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 		goto err_conn_remove;
 	}
 
-	reply = (void *)skb->data;
 	err = -be32_to_cpu(reply->error);
 	if (err) {
 		if (err == -ENOSPC) {
-- 
2.21.0

