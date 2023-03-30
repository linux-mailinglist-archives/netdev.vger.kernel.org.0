Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8356D11FC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 00:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjC3WJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 18:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjC3WJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 18:09:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2662010C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 15:09:57 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5446a91c40cso202445397b3.18
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 15:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680214196;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+umX8atUPZwWiNw4VgSmxkATt9rskQl35253xwjy8ms=;
        b=FaK/kSnLh3vOzkV/vLcJZUxDXrE3NvmKSCFuQEnm581h1uoWoS4ubSTioLjnMXclp/
         mj0Yfd6J2apYPpBhAN3+RhdJ9zRymYFySnw+7LEK1JffuQlNDcIlCf4CSKQWfaMF/8Tw
         bTSFVFimy1cscbIpix5xD1z1Yum1pXpghESzkBkZWMbZJr+9xeXhD+cmsOhgIuf97mYB
         zAlbehrY49h2Qblf5OPINdmF6CUTek9zLAMPLzDS9JM0G0f/moKGaYcIbzHTKkZo1Tl4
         Qp3eIHuxSEsu86MjErtdMlJib4jZFpYh550RjRUGGrISelJrcDhrFc8RASmSPwxNfSsl
         jcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680214196;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+umX8atUPZwWiNw4VgSmxkATt9rskQl35253xwjy8ms=;
        b=FJ6J+d3tfWnMk1tJD5V48uCADyGiI56IPKm5bmz7v1cfnmsTqejw4tLnwqg3K34b3w
         ezrXcv2Wi+dL3vR+OO/ej3n9xUbVMFh2fb2PJ0LRW6z7fFJJG3Z9F3YXZt12/zL9f8bU
         fmUTN9VQdmySZrGz8/IXv0YBFCbg/rL+Tqvd+0+9eWCMHXB02qNB7zK+zy2Ii7/ZHr6B
         U8KcMO3yslypMvdWbnuM0IfFIi69kFVb5tClZ9v7fXwVIMVeiF7ZW1o0GqVklQM+h8wv
         DlY9t0Znc2Ft5UdRlKgnlmzPauEIVIKtYSKvGj+Aq+ltpeekCmFzOR0inKiyZrMb9W/4
         gkjQ==
X-Gm-Message-State: AAQBX9dKccdYNyEx4+0PEeRSt0OLrpHEzZW2Nt8rhl19RedugBtX4AYF
        VZaR68piK6uyaf3350eadvS2cjAdCOB71T3zAKki0hvVtvhnFODJlQEeS9h1ZbCIiDLjMtxzazY
        hhT+qOUs2zRA080uuldR+fSp9xSz/2PwwcULc22CIcey9hbEwTnfGJ9NmJTkpydiMQ8g=
X-Google-Smtp-Source: AKy350b0aMRFxyxNqOqOnJlQK47TAdjtDrdD6nHMuofvwgcA+LKhu4/d5EFwLdOvspPjQnnW9qgukKbPb9TO1A==
X-Received: from shailend.sea.corp.google.com ([2620:15c:100:202:1fe2:b998:e44b:84a0])
 (user=shailend job=sendgmr) by 2002:a05:6902:1004:b0:b75:968e:f282 with SMTP
 id w4-20020a056902100400b00b75968ef282mr16362449ybt.11.1680214196349; Thu, 30
 Mar 2023 15:09:56 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:09:39 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330220939.2341562-1-shailend@google.com>
Subject: [PATCH net] gve: Secure enough bytes in the first TX desc for all TCP pkts
From:   Shailend Chand <shailend@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shailend Chand <shailend@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Non-GSO TCP packets whose SKBs' linear portion did not include the
entire TCP header were not populating the first Tx descriptor with
as many bytes as the vNIC expected. This change ensures that all
TCP packets populate the first descriptor with the correct number of
bytes.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Shailend Chand <shailend@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 4888bf05fbed..e28b3fe26153 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -284,8 +284,8 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 	int bytes;
 	int hlen;
 
-	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) +
-				 tcp_hdrlen(skb) : skb_headlen(skb);
+	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) + tcp_hdrlen(skb) :
+				 min_t(int, 182, skb->len);
 
 	pad_bytes = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo,
 						   hlen);
@@ -454,13 +454,11 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 	pkt_desc = &tx->desc[idx];
 
 	l4_hdr_offset = skb_checksum_start_offset(skb);
-	/* If the skb is gso, then we want the tcp header in the first segment
-	 * otherwise we want the linear portion of the skb (which will contain
-	 * the checksum because skb->csum_start and skb->csum_offset are given
-	 * relative to skb->head) in the first segment.
+	/* If the skb is gso, then we want the tcp header alone in the first segment
+	 * otherwise we want the spec-stipulated minimum of 182B.
 	 */
 	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
-			skb_headlen(skb);
+			min_t(int, 182, skb->len);
 
 	info->skb =  skb;
 	/* We don't want to split the header, so if necessary, pad to the end
-- 
2.40.0.348.gf938b09366-goog

