Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877D7391240
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhEZI0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:26:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232958AbhEZI0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622017490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o40Fmid6nNIkbFe8iYePDZhpBrn8pMAYTwjh787uFdE=;
        b=bMgWZzvxoCCUOHiqAt0w139I9D42aQf9cd8BYUDxKX/uDjIEkOzpeo62tkp5FvqyWDP7Aa
        rm3CPN2Qp+lzFBggvoHlokDF1QVUFH9JQyXMZbeqpgWtE4xc36908E1BjbXIIrrgdrujnt
        iKk9y9eolWhyG7h//Rh6E2PzNDkgCno=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-mifakwWHP-6pm-AzVN-kGA-1; Wed, 26 May 2021 04:24:46 -0400
X-MC-Unique: mifakwWHP-6pm-AzVN-kGA-1
Received: by mail-wm1-f72.google.com with SMTP id n20-20020a05600c4f94b029017f371265feso4634946wmq.5
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 01:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o40Fmid6nNIkbFe8iYePDZhpBrn8pMAYTwjh787uFdE=;
        b=LaZUDnplN9yqp7Gwstn1P4MYQXH5Lw6XhXCPMo9pGbc62FKFQ0AaEvZLzw+GvfTO6Q
         b8vwuN8FO2gVzkI7nfx/scwOQtwxgQAQNyuj+WJId66drZYiXFFGPDMLC1Z1sUX2n2QG
         5AFi4ORaFdXAn3ObvNMABsJNSOFBkfU7DTF40BtsrX8pQAaUT53pCaO+piP016lMaVnD
         cah7UXXTdGXUAU229TdyyvHg/cg8W5qfVIoi4eoBsbMnFHrgUZihy+qO3ZjCGEgom8J/
         8FKJCDM+XXllxNRSq8vhBptL2pL6fa0wQgtVT+W2dNrazfoJu6eFlO6wHz35Tz4f1ASr
         NOzw==
X-Gm-Message-State: AOAM533U4/qUj0rvmXGRMkdaZXENb5HtuKit/WOgmlKNRRfVKw9Th4Ef
        a0/ob55xAF6P4ToDbdAEYM66rgwkPbJE4XGHBi6hFjaEuQtp8n7fBfeEb/WQ7OD6CzehAUqrc0i
        5vd+3B9sGL+FeM9t9
X-Received: by 2002:a1c:f303:: with SMTP id q3mr2246260wmq.9.1622017485572;
        Wed, 26 May 2021 01:24:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3YaY8d7OxUasPPsyIXLBzSHdDVjW4txQgjFtjWKP91pjY4SLYxtZjAEHxMjzrOAh+TdWZzQ==
X-Received: by 2002:a1c:f303:: with SMTP id q3mr2246253wmq.9.1622017485441;
        Wed, 26 May 2021 01:24:45 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id l188sm769420wmf.27.2021.05.26.01.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 01:24:45 -0700 (PDT)
Date:   Wed, 26 May 2021 04:24:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v3 4/4] virtio_net: disable cb aggressively
Message-ID: <20210526082423.47837-5-mst@redhat.com>
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

There are currently two cases where we poll TX vq not in response to a
callback: start xmit and rx napi.  We currently do this with callbacks
enabled which can cause extra interrupts from the card.  Used not to be
a big issue as we run with interrupts disabled but that is no longer the
case, and in some cases the rate of spurious interrupts is so high
linux detects this and actually kills the interrupt.

Fix up by disabling the callbacks before polling the tx vq.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c29f42d1e04f..a83dc038d8af 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1433,7 +1433,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 		return;
 
 	if (__netif_tx_trylock(txq)) {
-		free_old_xmit_skbs(sq, true);
+		do {
+			virtqueue_disable_cb(sq->vq);
+			free_old_xmit_skbs(sq, true);
+		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 			netif_tx_wake_queue(txq);
@@ -1605,12 +1608,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
 	bool kick = !netdev_xmit_more();
 	bool use_napi = sq->napi.weight;
+	unsigned int bytes = skb->len;
 
 	/* Free up any pending old buffers before queueing new ones. */
-	free_old_xmit_skbs(sq, false);
+	do {
+		if (use_napi)
+			virtqueue_disable_cb(sq->vq);
 
-	if (use_napi && kick)
-		virtqueue_enable_cb_delayed(sq->vq);
+		free_old_xmit_skbs(sq, false);
+
+	} while (use_napi && kick &&
+	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
-- 
MST

