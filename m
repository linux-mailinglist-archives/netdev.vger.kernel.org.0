Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4587535D774
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344682AbhDMFsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:48:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344638AbhDMFsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 01:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618292880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QGJBfGcLgKMi1+/2KjTQyyM9awqMoNgF1ipdHiAyD40=;
        b=KFJmODUs9bg1g3CTvYREH5ojlYv8wpBMibY4n03+MGDQ4x0ZdfqW2aB6oa1tIU6xyz6xZC
        hqI/ORvv2kDqBkdIhbCEDrE7DlARI3ZcZjeHl7R/owlg0xPQte02Xc718/0c7sb8RiAFFr
        Z96hXkDFThtaBW/x4RSb0adlP3OD5Ck=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-BgdvswQ_PZaLwiqvzK33Fw-1; Tue, 13 Apr 2021 01:47:58 -0400
X-MC-Unique: BgdvswQ_PZaLwiqvzK33Fw-1
Received: by mail-wm1-f72.google.com with SMTP id t83-20020a1cc3560000b029011f8f517694so665351wmf.3
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 22:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QGJBfGcLgKMi1+/2KjTQyyM9awqMoNgF1ipdHiAyD40=;
        b=WAD47njAQz0s+qI8uOarQM7/KCiQI5FlDLFIBzWKf5R/U8ujpFqdllvU/72zgkKcF9
         oHSFdZqxZwLHDd8XYHpeEExqHI474kLE3ZQUnT3qRicsipd+KGoVh+2/YXLJy1EsNnts
         qKpot1uiAl901SmcBCxbtdmzmSeK9wQMsiqO9YasuWI3Ys0Pfd9hjyTs6dd6U4LOCJaA
         mWAWvGPgrXnlpwnZEv6eODCH4RlAZcBqUvZQ6k2ZygnUjG0Hu53e1OTomNIk3QZW7eLf
         EggFQusuela+BwX8K+xHxZUtYwAgWu50XNYYz0jlO4gogFuUbEe3az+3ojfoTmF99Q2I
         zvOA==
X-Gm-Message-State: AOAM5334futWFnrrocMUJnYRWcS+S0jawv4UfOdjayU18klQpPyhSo0a
        wPrL5lYdqKMKkWQIfXqH1zAxVpjSalCSSyveEmdcwMGRs2bRLftcignXn3CLrdLPAicEjq30OFI
        OuNsg6Ya5OP1MSImt
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr2254268wmc.179.1618292877175;
        Mon, 12 Apr 2021 22:47:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW5ocyM6oF51LY1hu/Bl53XZpnXsl6/4JelfE4ZTpiVul59teVVfXyx5S11Km6LpSBfopV3w==
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr2254249wmc.179.1618292877015;
        Mon, 12 Apr 2021 22:47:57 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id a8sm20895382wrh.91.2021.04.12.22.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 22:47:56 -0700 (PDT)
Date:   Tue, 13 Apr 2021 01:47:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jason Wang <jasowang@redhat.com>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v2 4/4] virtio_net: move txq wakeups under tx q lock
Message-ID: <20210413054733.36363-5-mst@redhat.com>
References: <20210413054733.36363-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413054733.36363-1-mst@redhat.com>
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
index 460ccdbb840e..febaf55ec1f6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1431,11 +1431,12 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 	if (__netif_tx_trylock(txq)) {
 		virtqueue_disable_cb(sq->vq);
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
@@ -1519,6 +1520,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	virtqueue_disable_cb(sq->vq);
 	free_old_xmit_skbs(sq, true);
 
+	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+		netif_tx_wake_queue(txq);
+
 	opaque = virtqueue_enable_cb_prepare(sq->vq);
 
 	done = napi_complete_done(napi, 0);
@@ -1539,9 +1543,6 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
-		netif_tx_wake_queue(txq);
-
 	return 0;
 }
 
-- 
MST

