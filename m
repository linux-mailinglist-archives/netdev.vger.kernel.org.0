Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965791952A3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0IK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:10:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54992 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgC0IKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:10:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C000320538;
        Fri, 27 Mar 2020 09:10:15 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PIFcCdL6GOI5; Fri, 27 Mar 2020 09:10:15 +0100 (CET)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B673920539;
        Fri, 27 Mar 2020 09:10:13 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 09:10:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2A76B318032B; Fri, 27 Mar 2020 09:10:13 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/8] esp: remove the skb from the chain when it's enqueued in cryptd_wq
Date:   Fri, 27 Mar 2020 09:10:05 +0100
Message-ID: <20200327081007.1185-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327081007.1185-1-steffen.klassert@secunet.com>
References: <20200327081007.1185-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3231ec628544..e2db468cf50e 100644
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
2.17.1

