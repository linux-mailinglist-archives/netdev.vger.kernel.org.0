Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807C02DDADB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgLQVbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:31:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbgLQVbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 16:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608240599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9ulptTw1QljZ7bj+CS6pjcsikYpCRgwLuxEmUENeONQ=;
        b=eAYX0y3CVuSUsBawT+zzu+enZ5x26I92YC7aOxYQvBnwQdmngjhyySXOyIj6Yx1xBIEfGK
        2BzfCSYQkXwqmKV0U4fXvObyKOZSAG40vCM7XvX0Yd7cjk7mw1L+OFbGojU/8UgD1hf0SL
        9v0R8MUmA7EHz3Jtrz6IeLxACxwqDcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-jEI9rnMAMIa8VRMp2cCUlg-1; Thu, 17 Dec 2020 16:29:55 -0500
X-MC-Unique: jEI9rnMAMIa8VRMp2cCUlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF557B8100;
        Thu, 17 Dec 2020 21:29:52 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.194.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48BD018A50;
        Thu, 17 Dec 2020 21:29:50 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net/sched: sch_taprio: ensure to reset/destroy all child qdiscs
Date:   Thu, 17 Dec 2020 22:29:46 +0100
Message-Id: <13edef6778fef03adc751582562fba4a13e06d6a.1608240532.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio_graft() can insert a NULL element in the array of child qdiscs. As
a consquence, taprio_reset() might not reset child qdiscs completely, and
taprio_destroy() might leak resources. Fix it by ensuring that loops that
iterate over q->qdiscs[] don't end when they find the first NULL item.

Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_taprio.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c74817ec9964..6f775275826a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1605,8 +1605,9 @@ static void taprio_reset(struct Qdisc *sch)
 
 	hrtimer_cancel(&q->advance_timer);
 	if (q->qdiscs) {
-		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
-			qdisc_reset(q->qdiscs[i]);
+		for (i = 0; i < dev->num_tx_queues; i++)
+			if (q->qdiscs[i])
+				qdisc_reset(q->qdiscs[i]);
 	}
 	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
@@ -1626,7 +1627,7 @@ static void taprio_destroy(struct Qdisc *sch)
 	taprio_disable_offload(dev, q, NULL);
 
 	if (q->qdiscs) {
-		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
+		for (i = 0; i < dev->num_tx_queues; i++)
 			qdisc_put(q->qdiscs[i]);
 
 		kfree(q->qdiscs);
-- 
2.29.2

