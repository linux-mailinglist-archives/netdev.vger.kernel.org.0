Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365EB2DC696
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgLPSfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:35:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731227AbgLPSfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608143651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sOGP3rQm93hAvqRe0Gp2CAAjmcieUTa/npDPAP18fdw=;
        b=NR7pQoBTXhBgQb+n3gz5ux67UlsYHC2o1d6oDI3IZp0dfK9P+j90gcgjkUsWg7+Jeu3hew
        LsN0JWJROD/j03w040ZZ6VwZoy2OO98CnBE2Zry32LiROWt8SRc3Suhj7z5GHXWTFwLXTn
        QaoJafOyBzvYbmq//WnCzz/um9LLDSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-jEULJ0_bO6CVVXDs0Ha5ug-1; Wed, 16 Dec 2020 13:34:07 -0500
X-MC-Unique: jEULJ0_bO6CVVXDs0Ha5ug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A77459;
        Wed, 16 Dec 2020 18:34:05 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.194.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7E743A47;
        Wed, 16 Dec 2020 18:34:02 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net/sched: sch_taprio: reset child qdiscs before freeing them
Date:   Wed, 16 Dec 2020 19:33:29 +0100
Message-Id: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller shows that packets can still be dequeued while taprio_destroy()
is running. Let sch_taprio use the reset() function to cancel the advance
timer and drop all skbs from the child qdiscs.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Link: https://syzkaller.appspot.com/bug?id=f362872379bf8f0017fb667c1ab158f2d1e764ae
Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_taprio.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 26fb8a62996b..c74817ec9964 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1597,6 +1597,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	return err;
 }
 
+static void taprio_reset(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int i;
+
+	hrtimer_cancel(&q->advance_timer);
+	if (q->qdiscs) {
+		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
+			qdisc_reset(q->qdiscs[i]);
+	}
+	sch->qstats.backlog = 0;
+	sch->q.qlen = 0;
+}
+
 static void taprio_destroy(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1607,7 +1622,6 @@ static void taprio_destroy(struct Qdisc *sch)
 	list_del(&q->taprio_list);
 	spin_unlock(&taprio_list_lock);
 
-	hrtimer_cancel(&q->advance_timer);
 
 	taprio_disable_offload(dev, q, NULL);
 
@@ -1954,6 +1968,7 @@ static struct Qdisc_ops taprio_qdisc_ops __read_mostly = {
 	.init		= taprio_init,
 	.change		= taprio_change,
 	.destroy	= taprio_destroy,
+	.reset		= taprio_reset,
 	.peek		= taprio_peek,
 	.dequeue	= taprio_dequeue,
 	.enqueue	= taprio_enqueue,
-- 
2.29.2

