Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCCB1BF702
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3Lma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:42:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20154 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbgD3Lma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588246949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ASTPXKoP+Z/TRKL+rGrmmpMwwaioxhAYVij/hQ4tT+Y=;
        b=UwecC2lw86uGejbzIhn9YD6P0zlew731LUcx47wa2mekkQ0yXIMvchRy6vMQdoMHE4q5qb
        GJqD2Q9DwH++M4Gy5bobj0bIkcysKl1gcxuOFkjS2kgz8CUtOCwqXqXRth019kk8hMyB9+
        4Px9TvNdAO0smWcQDdAeuK9srH4niuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-NPqstq6jPMqZXbuGM1SiIw-1; Thu, 30 Apr 2020 07:42:27 -0400
X-MC-Unique: NPqstq6jPMqZXbuGM1SiIw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24F1F835B40;
        Thu, 30 Apr 2020 11:42:26 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D231396;
        Thu, 30 Apr 2020 11:42:23 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 18A4C30000272;
        Thu, 30 Apr 2020 13:42:22 +0200 (CEST)
Subject: [PATCH net-next V2] net: sched: fallback to qdisc noqueue if default
 qdisc setup fail
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Date:   Thu, 30 Apr 2020 13:42:22 +0200
Message-ID: <158824694174.2180470.8094886910962590764.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if the default qdisc setup/init fails, the device ends up with
qdisc "noop", which causes all TX packets to get dropped.

With the introduction of sysctl net/core/default_qdisc it is possible
to change the default qdisc to be more advanced, which opens for the
possibility that Qdisc_ops->init() can fail.

This patch detect these kind of failures, and choose to fallback to
qdisc "noqueue", which is so simple that its init call will not fail.
This allows the interface to continue functioning.

V2:
As this also captures memory failures, which are transient, the
device is not kept in IFF_NO_QUEUE state.  This allows the net_device
to retry to default qdisc assignment.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/sched/sch_generic.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 2efd5b61acef..ad24fa1a51e6 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1037,10 +1037,9 @@ static void attach_one_default_qdisc(struct net_device *dev,
 		ops = &pfifo_fast_ops;
 
 	qdisc = qdisc_create_dflt(dev_queue, ops, TC_H_ROOT, NULL);
-	if (!qdisc) {
-		netdev_info(dev, "activation failed\n");
+	if (!qdisc)
 		return;
-	}
+
 	if (!netif_is_multiqueue(dev))
 		qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
 	dev_queue->qdisc_sleeping = qdisc;
@@ -1065,6 +1064,18 @@ static void attach_default_qdiscs(struct net_device *dev)
 			qdisc->ops->attach(qdisc);
 		}
 	}
+
+	/* Detect default qdisc setup/init failed and fallback to "noqueue" */
+	if (dev->qdisc == &noop_qdisc) {
+		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
+			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
+		dev->priv_flags |= IFF_NO_QUEUE;
+		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
+		dev->qdisc = txq->qdisc_sleeping;
+		qdisc_refcount_inc(dev->qdisc);
+		dev->priv_flags ^= IFF_NO_QUEUE;
+	}
+
 #ifdef CONFIG_NET_SCHED
 	if (dev->qdisc != &noop_qdisc)
 		qdisc_hash_add(dev->qdisc, false);


