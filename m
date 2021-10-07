Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7E4253A2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhJGNHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:07:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240974AbhJGNHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633611915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z6NOaQwFIEDE4RMAf1c0V7rB5qzDN+srWMSmfGsxBko=;
        b=dq/parE8IltxwAcwFGxmY3NNqEVlM0g/8WX5L6K8RAKF8X6oEI9zAHDzo1hEttkQyAjc1p
        UKLUGnom03wYUKAWusPSrkpGibCbAtynFuS2evO+8YznbFLS4JO+nft8L+KL0WPv8CJpTe
        Fz0Ru7vwrrTdCuKO9vE/oIQOdda1pzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-bGjT8AZ9MMu0E8KJr6HObg-1; Thu, 07 Oct 2021 09:05:14 -0400
X-MC-Unique: bGjT8AZ9MMu0E8KJr6HObg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DADF1005E4D;
        Thu,  7 Oct 2021 13:05:13 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.195.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06CC49AA3F;
        Thu,  7 Oct 2021 13:05:10 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: sch_ets: properly init all active DRR list handles
Date:   Thu,  7 Oct 2021 15:05:02 +0200
Message-Id: <60d274838bf09777f0371253416e8af71360bc08.1633609148.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

leaf classes of ETS qdiscs are served in strict priority or deficit round
robin (DRR), depending on the value of 'nstrict'. Since this value can be
changed while traffic is running, we need to be sure that the active list
of DRR classes can be updated at any time, so:

1) call INIT_LIST_HEAD(&alist) on all leaf classes in .init(), before the
   first packet hits any of them.
2) ensure that 'alist' is not overwritten with zeros when a leaf class is
   no more strict priority nor DRR (i.e. array elements beyond 'nbands').

Link: https://lore.kernel.org/netdev/YS%2FoZ+f0Nr8eQkzH@dcaratti.users.ipa.redhat.com
Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_ets.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 1f857ffd1ac2..ed86b7021f6d 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -661,7 +661,6 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 
 	q->nbands = nbands;
 	for (i = nstrict; i < q->nstrict; i++) {
-		INIT_LIST_HEAD(&q->classes[i].alist);
 		if (q->classes[i].qdisc->q.qlen) {
 			list_add_tail(&q->classes[i].alist, &q->active);
 			q->classes[i].deficit = quanta[i];
@@ -687,7 +686,11 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	ets_offload_change(sch);
 	for (i = q->nbands; i < oldbands; i++) {
 		qdisc_put(q->classes[i].qdisc);
-		memset(&q->classes[i], 0, sizeof(q->classes[i]));
+		q->classes[i].qdisc = NULL;
+		q->classes[i].quantum = 0;
+		q->classes[i].deficit = 0;
+		memset(&q->classes[i].bstats, 0, sizeof(q->classes[i].bstats));
+		memset(&q->classes[i].qstats, 0, sizeof(q->classes[i].qstats));
 	}
 	return 0;
 }
@@ -696,7 +699,7 @@ static int ets_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 			  struct netlink_ext_ack *extack)
 {
 	struct ets_sched *q = qdisc_priv(sch);
-	int err;
+	int err, i;
 
 	if (!opt)
 		return -EINVAL;
@@ -706,6 +709,9 @@ static int ets_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 		return err;
 
 	INIT_LIST_HEAD(&q->active);
+	for (i = 0; i < TCQ_ETS_MAX_BANDS; i++)
+		INIT_LIST_HEAD(&q->classes[i].alist);
+
 	return ets_qdisc_change(sch, opt, extack);
 }
 
-- 
2.31.1

