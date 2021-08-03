Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A690A3DEFF5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhHCOR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:17:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56910 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhHCORX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:17:23 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uoO50/v7bqMCm6KdvZeuFGej/XDok02zYQUn61la+Q=;
        b=q209fWC/mgcf8ee5UUh02WLuwHEZJOkbdDWOqmIg3Gvv+lUDPJUOCkdDanYrqSO3Q76ewX
        evkXGjlIc2Wllr5yCbchHJ/yUtiog/syfaQ5vQvPmgX6MWqHqJnGM155I/M6zx1GZqPd8B
        IAe0tPTI8TfvOyD7QvNxr+2Cl9BDOwFcPJPzqoGjRC7MGGMsaQDRrdZdAP2FDFm2ZnmNCo
        lpL5BiSWcnWWL7BqdCVYu78OwkVrUU10rouVIFdzW8aTGgG9jwmC8QGKERWu2ealInkU6U
        7IbLvrFieqw4ynJviuZBc593/JQ4SnEjffWX0QmX327q62TUnCTEx4601diWcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uoO50/v7bqMCm6KdvZeuFGej/XDok02zYQUn61la+Q=;
        b=qr6ly/VeWBNIbG7ikdjGJ0C3OWrZHNj4rRwhmYZY9FSxYdtfgooDNLOn2sOGznPqHnaI01
        cSdCHzLg7wbNExDA==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 21/38] virtio_net: Replace deprecated CPU-hotplug functions.
Date:   Tue,  3 Aug 2021 16:16:04 +0200
Message-Id: <20210803141621.780504-22-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/virtio_net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 56c3f85190938..ea551ac9e08db 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2208,14 +2208,14 @@ static int virtnet_set_channels(struct net_device *=
dev,
 	if (vi->rq[0].xdp_prog)
 		return -EINVAL;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	err =3D _virtnet_set_queues(vi, queue_pairs);
 	if (err) {
-		put_online_cpus();
+		cpus_read_unlock();
 		goto err;
 	}
 	virtnet_set_affinity(vi);
-	put_online_cpus();
+	cpus_read_unlock();
=20
 	netif_set_real_num_tx_queues(dev, queue_pairs);
 	netif_set_real_num_rx_queues(dev, queue_pairs);
@@ -2970,9 +2970,9 @@ static int init_vqs(struct virtnet_info *vi)
 	if (ret)
 		goto err_free;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	virtnet_set_affinity(vi);
-	put_online_cpus();
+	cpus_read_unlock();
=20
 	return 0;
=20
--=20
2.32.0

