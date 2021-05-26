Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EB739123B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhEZI0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:26:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232349AbhEZI0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622017483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZS7ZD35dU/eELTvMx06tUPCxlf74xPaW7VsnOKz2lgA=;
        b=YoXA9nNFldikGUcYUNr161UObTN2s2JqW8GjgSmskkTkjKjZhbAKJ3vyF6LAtXIsSBM8mN
        IJ690VeOpN0Ve4gmmbjerq5ZpH+k+sz2PQh2yxQylUh2ik/2NUZhrXc7u3DzTNk1veHr1L
        QjPZdyXfe3kW3DMU2ZdovObzLygKjZE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-XLSv131bN4yBcGfts4Ji1Q-1; Wed, 26 May 2021 04:24:41 -0400
X-MC-Unique: XLSv131bN4yBcGfts4Ji1Q-1
Received: by mail-wm1-f70.google.com with SMTP id h9-20020a1cb7090000b029016d3f0b6ce4so115229wmf.9
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 01:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZS7ZD35dU/eELTvMx06tUPCxlf74xPaW7VsnOKz2lgA=;
        b=QePkZ6ccAkH/M0l1S7SVlNjfykUbxE+2sI27+/OR8GUORVTVuRRtzSeTcnBbh69iWy
         2Nk8yUPWfDH68fSyPFIdJqyoNJnHC2ybAi03f8BOehRb86U7dzQUE+Z/hQaSqZ5ibvXE
         O7juIeRKCbzv6dRgUJ4GkBZF/Q6FF5cV+g02R89XkkxrLwyIVj89T1pIDrHeYjAFr2tq
         WpczYfCvwAOrPzw8OMEbKRVaPyFmgdeO4aYHCgJZxyPhmbNzKKAYhRNqkhoiHyU1OfjY
         p3EBznibrn2ZAuC1g6/KnsBaOj7dbBLJA3MVLYtfVCSWKuXG4gVaHcgBrMVOWLrl/jJG
         F9lw==
X-Gm-Message-State: AOAM531Kk9ZToguGzsuJy0LqUGw6+uM0Yd05DdzHBlCRzy0GAg2V94C1
        crjAYCZLIYvPYTmXSbP3GEnWtPgOEuXL5xu0n/DdHcOU3MkTy8z68i01gZIRqduT+3/I1g616Ag
        tzhcaJGzhenIKbz00
X-Received: by 2002:a1c:4444:: with SMTP id r65mr2151369wma.127.1622017480213;
        Wed, 26 May 2021 01:24:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXdpzBs/WOwiOoCYBUHQSDzRAcpfSmL78loNWZAQmEL/+Swns93afcI95zX4GVL88WJjsVEw==
X-Received: by 2002:a1c:4444:: with SMTP id r65mr2151356wma.127.1622017480077;
        Wed, 26 May 2021 01:24:40 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id n20sm13641956wmk.12.2021.05.26.01.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 01:24:39 -0700 (PDT)
Date:   Wed, 26 May 2021 04:24:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v3 2/4] virtio_net: move txq wakeups under tx q lock
Message-ID: <20210526082423.47837-3-mst@redhat.com>
References: <20210526082423.47837-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526082423.47837-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently check num_free outside tx q lock
which is unsafe: new packets can arrive meanwhile
and there won't be space in the queue.
Thus a spurious queue wakeup causing overhead
and even packet drops.

Move the check under the lock to fix that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 12512d1002ec..c29f42d1e04f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1434,11 +1434,12 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 
 	if (__netif_tx_trylock(txq)) {
 		free_old_xmit_skbs(sq, true);
+
+		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+			netif_tx_wake_queue(txq);
+
 		__netif_tx_unlock(txq);
 	}
-
-	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
-		netif_tx_wake_queue(txq);
 }
 
 static int virtnet_poll(struct napi_struct *napi, int budget)
@@ -1522,6 +1523,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	virtqueue_disable_cb(sq->vq);
 	free_old_xmit_skbs(sq, true);
 
+	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+		netif_tx_wake_queue(txq);
+
 	opaque = virtqueue_enable_cb_prepare(sq->vq);
 
 	done = napi_complete_done(napi, 0);
@@ -1542,9 +1546,6 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
-		netif_tx_wake_queue(txq);
-
 	return 0;
 }
 
-- 
MST

