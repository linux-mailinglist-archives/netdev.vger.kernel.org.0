Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58304178CD4
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 09:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387711AbgCDIvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 03:51:52 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35084 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387692AbgCDIvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 03:51:52 -0500
Received: by mail-pj1-f68.google.com with SMTP id s8so647812pjq.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 00:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ahJ82zO0dVpinysviptrWIvTlanTQiP1oFeAdo0BheI=;
        b=ci5eSaBZZJ/zei1n8hqBaosw2urDYHkeAHs7XFsLOaUINkMcQRsGBKdgZ9it3g3ZFL
         dhIqnSBSEHNU2kzgYEbvTxqHqfgVve+s+GZAPjuO4xw7yPs4amArWQAb351D7IuuUd+f
         NANHXsikL+17XFLNZPMm1/qDJFNKlxMMKowJR9e0713zv39Jcf1/NYl1FKuvXlJKm1jo
         3Wwg7NEtGbVw5qgwiJjQB+Pk2QbwEbW+crvcm/xUKG7emTbTv4jQCOtREVInycAwWEFe
         zAsikSWL6zWHWBSO9mx7I14y+jMwV2qiX9zpyRR2Ibz1IHZ0CHieYayuH9tr8tFY05Kc
         cJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ahJ82zO0dVpinysviptrWIvTlanTQiP1oFeAdo0BheI=;
        b=hvH4BZWKjSoTICr8km8vovxvMJSoCU5vzlgYQ5H5bGnLgPhuoKcXDDDWWouRo+xdP7
         BXN4OTtGkploo/jLL0O0D9VtBDibHvYWn8YN8PeAgKFCokhnWKkZAv5jiqKu2ibc4yTP
         GwzWaK3gFSHUPHR+zUw7VZMwJawCaxJydCMbC9YjUHT5skdGbc7FtPl7w0ra5iKScOkL
         1YDoJ59DNrpY4p5tb/OLEIbgZCOu2BVkKGA1iDr5/7ygaIg5eE+Fax+ytf3IAIQUTkTn
         KgU6LloBVpoxAR9s5XFhQ6q/z0VHn5mBm8XGE+yUcUr15Du5ykcGSkvyIM4kzll1jSSK
         0JeA==
X-Gm-Message-State: ANhLgQ2db//MOqxBjGcqWOWuTSXOY1HuorDH2I46n4ijOEh9eieDUlvN
        bjDLiQ6d7XpQjNu5A51ak7WMQOSG
X-Google-Smtp-Source: ADFU+vuVOZl9LOV9UtBhHXd9pXt/Bs4Q+Kh32Jbfl6etjxN1/V/OJjp0AX9Era9mse92pZztuB5TbQ==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr2147476plr.81.1583311911098;
        Wed, 04 Mar 2020 00:51:51 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z10sm26331555pgf.35.2020.03.04.00.51.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 00:51:50 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] esp: remove the skb from the chain when it's enqueued in cryptd_wq
Date:   Wed,  4 Mar 2020 16:51:42 +0800
Message-Id: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiumei found a panic in esp offload:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  RIP: 0010:esp_output_done+0x101/0x160 [esp4]
  Call Trace:
   ? esp_output+0x180/0x180 [esp4]
   cryptd_aead_crypt+0x4c/0x90
   cryptd_queue_worker+0x6e/0xa0
   process_one_work+0x1a7/0x3b0
   worker_thread+0x30/0x390
   ? create_worker+0x1a0/0x1a0
   kthread+0x112/0x130
   ? kthread_flush_work_fn+0x10/0x10
   ret_from_fork+0x35/0x40

It was caused by that skb secpath is used in esp_output_done() after it's
been released elsewhere.

The tx path for esp offload is:

  __dev_queue_xmit()->
    validate_xmit_skb_list()->
      validate_xmit_xfrm()->
        esp_xmit()->
          esp_output_tail()->
            aead_request_set_callback(esp_output_done) <--[1]
            crypto_aead_encrypt()  <--[2]

In [1], .callback is set, and in [2] it will trigger the worker schedule,
later on a kernel thread will call .callback(esp_output_done), as the call
trace shows.

But in validate_xmit_xfrm():

  skb_list_walk_safe(skb, skb2, nskb) {
    ...
    err = x->type_offload->xmit(x, skb2, esp_features);  [esp_xmit]
    ...
  }

When the err is -EINPROGRESS, which means this skb2 will be enqueued and
later gets encrypted and sent out by .callback later in a kernel thread,
skb2 should be removed fromt skb chain. Otherwise, it will get processed
again outside validate_xmit_xfrm(), which could release skb secpath, and
cause the panic above.

This patch is to remove the skb from the chain when it's enqueued in
cryptd_wq. While at it, remove the unnecessary 'if (!skb)' check.

Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for GRO packets.")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3231ec6..e2db468 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -78,8 +78,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	int err;
 	unsigned long flags;
 	struct xfrm_state *x;
-	struct sk_buff *skb2, *nskb;
 	struct softnet_data *sd;
+	struct sk_buff *skb2, *nskb, *pskb = NULL;
 	netdev_features_t esp_features = features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
@@ -168,14 +168,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		} else {
 			if (skb == skb2)
 				skb = nskb;
-
-			if (!skb)
-				return NULL;
+			else
+				pskb->next = nskb;
 
 			continue;
 		}
 
 		skb_push(skb2, skb2->data - skb_mac_header(skb2));
+		pskb = skb2;
 	}
 
 	return skb;
-- 
2.1.0

