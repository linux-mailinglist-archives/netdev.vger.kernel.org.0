Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16FA1F956
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfEOR3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:29:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35071 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEOR3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:29:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id c15so511463qkl.2
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0KMMvqJVQqCqSBFWrZt2YUrSROx7ZY7DgCNV4xuJCCM=;
        b=sd+gpOYE/ZU+DZTVYmi6dsxb92e9yLpa/uKsdcmfjXRWXU0/n1w7FlYiPF3fMFUxDv
         K5bhHzRBdoKCyKXObxyxoOxtBcsB1C7PPLjm+m7dzlWVjcaKOVaYuyndzwLwxwcK0U14
         Q833mLo6fjc//Lnv5Q92+M9Zrq74mAvccaoLUcRrzLgz0RwEh4qD3fMn7WgqYp3fkIIW
         HPWYoJyEOmU5KcSekKivjtePkjXRSAVl1HEKyPCOgc15z9zqhQXrMUudaYn79/YDSbii
         oYGIbY6xzQSwIeqW4snGskMyAjMVR5tPRdhDavCu2ebGENNdioGHqMCvUm+KvHEm8vKC
         GxPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0KMMvqJVQqCqSBFWrZt2YUrSROx7ZY7DgCNV4xuJCCM=;
        b=Fr+tofxTzlUP9vyWkSY8xSbJ2/nWzlc83mMHgc5QvRsmulwlrwrC2lfPHppVQ0EzYn
         0Px7Ohsl1mgMIyy8y1LlzBsaCMIzf2BTHOLs/eVJxUvSZ+Gl7AGc7oUBVgtDCXNMXRwo
         DcCLJrrg04LVi443uMhhv38qKXhDnsw4XbNPXs8hxaYc4EXL1nSLX5fZiAHoy6YjrSv0
         xG9T2lRzZmPLBHB3Vvj7MOMta9TXYMfvc0/jlwSkyhTyfbhoP/ot8K4Chwt3oN1cFcAg
         8ulukNfgT7SV09IB9ti6In9hgSy6ELbcFiXUDV90qytABiT1Najgxlc57RZnXFXITe2G
         9uyQ==
X-Gm-Message-State: APjAAAUWilvvm35KBk/twRAzUVy4P8Nq1Lv99PyxMEO7V6MaYVMo/II1
        lcE3h0T+8ELM2jBxG86yJoCm1uDc
X-Google-Smtp-Source: APXvYqyK6caC1Y9/cSAlvGU+lo2b48oMm193D/fYGktMmA0Dwt52A0Z/UyZXbSYgA5JHtfNft/NANA==
X-Received: by 2002:a37:a387:: with SMTP id m129mr34294947qke.39.1557941359178;
        Wed, 15 May 2019 10:29:19 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id a1sm1629421qth.69.2019.05.15.10.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:29:18 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] net: test nouarg before dereferencing zerocopy pointers
Date:   Wed, 15 May 2019 13:29:16 -0400
Message-Id: <20190515172916.143166-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Zerocopy skbs without completion notification were added for packet
sockets with PACKET_TX_RING user buffers. Those signal completion
through the TP_STATUS_USER bit in the ring. Zerocopy annotation was
added only to avoid premature notification after clone or orphan, by
triggering a copy on these paths for these packets.

The mechanism had to define a special "no-uarg" mode because packet
sockets already use skb_uarg(skb) == skb_shinfo(skb)->destructor_arg
for a different pointer.

Before deferencing skb_uarg(skb), verify that it is a real pointer.

Fixes: 5cd8d46ea1562 ("packet: copy user buffers before orphan or clone")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/skbuff.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6d58fa8a65fde..2ee5e63195c02 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1434,10 +1434,12 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
 	struct ubuf_info *uarg = skb_zcopy(skb);
 
 	if (uarg) {
-		if (uarg->callback == sock_zerocopy_callback) {
+		if (skb_zcopy_is_nouarg(skb)) {
+			/* no notification callback */
+		} else if (uarg->callback == sock_zerocopy_callback) {
 			uarg->zerocopy = uarg->zerocopy && zerocopy;
 			sock_zerocopy_put(uarg);
-		} else if (!skb_zcopy_is_nouarg(skb)) {
+		} else {
 			uarg->callback(uarg, zerocopy);
 		}
 
@@ -2691,7 +2693,8 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	if (likely(!skb_zcopy(skb)))
 		return 0;
-	if (skb_uarg(skb)->callback == sock_zerocopy_callback)
+	if (!skb_zcopy_is_nouarg(skb) &&
+	    skb_uarg(skb)->callback == sock_zerocopy_callback)
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
-- 
2.21.0.1020.gf2820cf01a-goog

