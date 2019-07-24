Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F56573386
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfGXQSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:18:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36858 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfGXQSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:18:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so46092429qtc.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 09:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NWYRn8bi/K0ffAk0tYkZ+J9UdEp+t7rEtBXMz8LUjck=;
        b=VPGlCeIWb3UcXrjYTfiWrtbgBkrf3IqpF286qThiZMqhz95LkPnyXzWbZoqIFCtoob
         Qc8AXdc4A9YN293kJuS6Z3CcPJjzqsOX5082pPJYUwXj8oYHP5xFmL8Io0UbOuazrsV7
         POGTgpY/8tr5fbh9soR4bmPEkJEH9VaGecp/BnBpUWdKGWd9zplsOS5tcZFycjnWlo+H
         lukH/t4rPE8Q4UCynDMSfWaIH9DNmCntSWQf9k0q4BZieBujM8/Ju1cbNNfnJVV9o4Fo
         Y+OWqi1G5mqYhT1m9wgjSe2AXcJxAqRFPwOuOBuTQiNgDJVeTpSG6Iut/zktFwmznJlu
         4pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NWYRn8bi/K0ffAk0tYkZ+J9UdEp+t7rEtBXMz8LUjck=;
        b=AJGK6GiGOAZWq74iB/LiH47CPIxkXQnST/tVN9xnN1btYFwcmrfKs/HPfWFrog+WaI
         YHDwhxclBuddzWlp+E5m0g4m26zAQcBqtkT2kzIeXpSbcrgSf1qaLaiPpbrNXk+jH4we
         +ME0nkeUzpnHryPajGx2r0PZv+DsbLhUD5ylNZNtDmERC05ZLeT3idqNQRNNiaKroD57
         JvhfzaV7VPIGwaQhMunlTmTfOSs+AwUcUCpCfL9YMFwTxyuIfI+veC9ZQ1WAplAlW8aS
         D6DY/RcGV8hyvsPhpcW83dH9ZmuWHI/AEkIioC8Q53xMHzIzOAIjj3A2Nq9yR5sgx8TN
         XP4Q==
X-Gm-Message-State: APjAAAUVcBqrhPK3VgHqkobW+GnpN0Zx1KCZA96vrp3//Co5QmQm3SOF
        vOfmjnWqpo9EX9uQjABJr3/I0g==
X-Google-Smtp-Source: APXvYqwntz1CwN/uQFpbmGM/1OWZgtbwRwe5bIqyLaCzpNvw7Qltsf2CB6Xlcn5JyqmXp6QVQfE8Ww==
X-Received: by 2002:ac8:6950:: with SMTP id n16mr4950053qtr.185.1563985110178;
        Wed, 24 Jul 2019 09:18:30 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x8sm21688368qka.106.2019.07.24.09.18.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 09:18:29 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH -next v2] net/ixgbevf: fix a compilation error of skb_frag_t
Date:   Wed, 24 Jul 2019 12:17:59 -0400
Message-Id: <1563985079-12888-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The linux-next commit "net: Rename skb_frag_t size to bv_len" [1]
introduced a compilation error on powerpc as it forgot to deal with the
renaming from "size" to "bv_len" for ixgbevf.

[1] https://lore.kernel.org/netdev/20190723030831.11879-1-willy@infradead.org/T/#md052f1c7de965ccd1bdcb6f92e1990a52298eac5

In file included from ./include/linux/cache.h:5,
                 from ./include/linux/printk.h:9,
                 from ./include/linux/kernel.h:15,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:9,
                 from
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:12:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function
'ixgbevf_xmit_frame_ring':
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:4138:51: error:
'skb_frag_t' {aka 'struct bio_vec'} has no member named 'size'
   count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
                                                   ^
./include/uapi/linux/kernel.h:13:40: note: in definition of macro
'__KERNEL_DIV_ROUND_UP'
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
                                        ^
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:4138:12: note: in
expansion of macro 'TXD_USE_COUNT'
   count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);

Signed-off-by: Qian Cai <cai@lca.pw>
---

v2: Use the fine accessor per Matthew.

 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index bdfccaf38edd..8c011d4ce7a9 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4134,8 +4134,11 @@ static int ixgbevf_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 #if PAGE_SIZE > IXGBE_MAX_DATA_PER_TXD
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
+
+		count += TXD_USE_COUNT(skb_frag_size(frag));
+	}
 #else
 	count += skb_shinfo(skb)->nr_frags;
 #endif
-- 
1.8.3.1

