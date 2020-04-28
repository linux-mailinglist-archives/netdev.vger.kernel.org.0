Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4F1BBBE1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgD1LGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:06:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726345AbgD1LGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 07:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588071978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cZrNh7746+qKc61SNba7Tg/YgZ8bEpvSXbrYCGKD2oc=;
        b=dmsWojv2JmF2rzL46jZcrfUJMfH2Fx/skxTVYiBGUDHrrl5DhD3hZpUXauJlcx/ty/qSPL
        wrGcMBygc98iWu1p9J/pNemgQyHDOSJLq/B8heKOva5Yzt5YQmyTd6MbxCXWT95IvyJB/4
        3s8dn6qyI/MhE8xurcj4L0z4Ns9GkQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-swH6yM4rPsyz54p_cLr8Qw-1; Tue, 28 Apr 2020 07:06:16 -0400
X-MC-Unique: swH6yM4rPsyz54p_cLr8Qw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1986B80B70B;
        Tue, 28 Apr 2020 11:06:15 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC4C25D750;
        Tue, 28 Apr 2020 11:06:11 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5111F300020FB;
        Tue, 28 Apr 2020 13:06:10 +0200 (CEST)
Subject: [PATCH net-next] net: sched: fallback to qdisc noqueue if default
 qdisc setup fail
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Date:   Tue, 28 Apr 2020 13:06:10 +0200
Message-ID: <158807197021.1980046.17172496536132159811.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/sched/sch_generic.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 2efd5b61acef..275b1347265e 100644
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
@@ -1055,6 +1054,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 
 	if (!netif_is_multiqueue(dev) ||
 	    dev->priv_flags & IFF_NO_QUEUE) {
+init_each_txq:
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
 		dev->qdisc = txq->qdisc_sleeping;
 		qdisc_refcount_inc(dev->qdisc);
@@ -1065,6 +1065,15 @@ static void attach_default_qdiscs(struct net_device *dev)
 			qdisc->ops->attach(qdisc);
 		}
 	}
+
+	/* Detect default qdisc setup/init failed and fallback to "noqueue" */
+	if (dev->qdisc == &noop_qdisc) {
+		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
+			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
+		dev->priv_flags |= IFF_NO_QUEUE;
+		goto init_each_txq;
+	}
+
 #ifdef CONFIG_NET_SCHED
 	if (dev->qdisc != &noop_qdisc)
 		qdisc_hash_add(dev->qdisc, false);


