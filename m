Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7873D430C
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 00:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhGWWFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 18:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhGWWFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 18:05:30 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EE5C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 15:46:03 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id d3so2088270qvq.6
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 15:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IXMHN1p1xWo4UB7EaGyYonwfbbu8eU/2HKestiCVXqw=;
        b=qDNIn540u8CMMuCMP4l1j3lUgiKkAAvpUk27+ESx7qyCvUheLiMVbqqbsM/1WMUIxt
         aKOG04AXykFGqOiaLwD0Rwsx7bnTy3x5LOymVYBZoi0bH3q9Jn/mCjTOE1blMZxdoQMJ
         aiTwb2UMn+RvTeUHQPPFsghi2HqJGR18hWL0xzgcOb1tGxPLpcs8f9bCTKQe5InIoE91
         Wc7W2dkJT3k8MYLp7l+3NQLH1unD/Q7pfB6NZHLQZ505mBZ4S40QEBxBI71CjljVrzCG
         llEcAxUnJTj/aHEWFhvoz9wSB3J6KHbyE6PCLAuEzxn1MyajiCBdCc2oxPSRafrRhpxz
         2SMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IXMHN1p1xWo4UB7EaGyYonwfbbu8eU/2HKestiCVXqw=;
        b=sD3VIv4TqNiMkBsbFmVxyDtXDC9LOlSEFTkP+Suc+0QknxOIKSaWZ4piafJgRZpHka
         Mm6nwEgSVINfIs1OzoUgctgo9zxQIXUokKgv0ZM178QKO7tBjC9ieNe0G8q0fv/62IG0
         pDFT56y9wTk4gLzXebnJYYI3oT5wDHwbaY1pvq+IvoBZp9wqeyC4iIcv0EwrbYlwbg3V
         RHlHWlQUwiHhpPvnkuO49lSB381582LAV312i98fGt3yh/pY5kC5ZSc84Qg1Ft9XgV3C
         N7r5cOw+00K1h7/IGLcEJ6CW0AaYw5zuImZOYOZLbViuTSg4Qk26rYXQ3/iOGb160C9w
         JDSg==
X-Gm-Message-State: AOAM530UlKQzrsjxpYEXnMw7z6Idy6dasNqCvSln5eU4pD3ScOcbnFiF
        PBw/XqZcgmffGBlQ9ugkB66nNlZfWTsWfg==
X-Google-Smtp-Source: ABdhPJyIE1z3kqZhOsFM5lJWIld2Eqkq0l+ifRZKsWBXlhPbQrxYqAfWBytrB4wWhBFgyXMMl+L1OA==
X-Received: by 2002:a0c:db01:: with SMTP id d1mr6933874qvk.38.1627080362255;
        Fri, 23 Jul 2021 15:46:02 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e123sm14928798qkf.103.2021.07.23.15.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 15:46:01 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net] tipc: do not write skb_shinfo frags when doing decrytion
Date:   Fri, 23 Jul 2021 18:46:01 -0400
Message-Id: <453b10a48c21d1882bbee21fe2c84197faad75e1.1627080361.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One skb's skb_shinfo frags are not writable, and they can be shared with
other skbs' like by pskb_copy(). To write the frags may cause other skb's
data crash.

So before doing en/decryption, skb_cow_data() should always be called for
a cloned or nonlinear skb if req dst is using the same sg as req src.
While at it, the likely branch can be removed, as it will be covered
by skb_cow_data().

Note that esp_input() has the same issue, and I will fix it in another
patch. tipc_aead_encrypt() doesn't have this issue, as it only processes
linear data in the unlikely branch.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/crypto.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index e5c43d4d5a75..c9391d38de85 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -898,16 +898,10 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 	if (unlikely(!aead))
 		return -ENOKEY;
 
-	/* Cow skb data if needed */
-	if (likely(!skb_cloned(skb) &&
-		   (!skb_is_nonlinear(skb) || !skb_has_frag_list(skb)))) {
-		nsg = 1 + skb_shinfo(skb)->nr_frags;
-	} else {
-		nsg = skb_cow_data(skb, 0, &unused);
-		if (unlikely(nsg < 0)) {
-			pr_err("RX: skb_cow_data() returned %d\n", nsg);
-			return nsg;
-		}
+	nsg = skb_cow_data(skb, 0, &unused);
+	if (unlikely(nsg < 0)) {
+		pr_err("RX: skb_cow_data() returned %d\n", nsg);
+		return nsg;
 	}
 
 	/* Allocate memory for the AEAD operation */
-- 
2.27.0

