Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B43C162C72
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgBRRRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:17:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38363 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726521AbgBRRRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582046264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ftxKpw6Ms75A8PydSJeyb7c1XGBJk47Mo8HcpQ5JSLk=;
        b=O6Mh5IjykgsxIP+CCLEClXmsFvFjecIIm+jCAsoCnwcgVKp00NgZGoGmEMA4KiJo2oT2pb
        jFHjjnAMtUtT1H5nomqk7u7GCmK9oHw//MlemWkbSB1BBzdMXE5r7bvuzqls2HtYpONfIn
        lTeWjZYnERIjrm+MwbBdLXvBcXoN1ro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-1O1nCBXiPzGEFj9JUqCXGw-1; Tue, 18 Feb 2020 12:17:04 -0500
X-MC-Unique: 1O1nCBXiPzGEFj9JUqCXGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2539F8017CC;
        Tue, 18 Feb 2020 17:17:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-149.ams2.redhat.com [10.36.117.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05487384;
        Tue, 18 Feb 2020 17:17:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [PATCH net] Revert "net: dev: introduce support for sch BYPASS for lockless qdisc"
Date:   Tue, 18 Feb 2020 18:15:44 +0100
Message-Id: <26b6bdd93aadb81d643da8279e2e340637f3a07e.1582019010.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ba27b4cdaaa66561aaedb2101876e563738d36fe

Ahmed reported ouf-of-order issues bisected to commit ba27b4cdaaa6
("net: dev: introduce support for sch BYPASS for lockless qdisc").
I can't find any working solution other than a plain revert.

This will introduce some minor performance regressions for
pfifo_fast qdisc. I plan to address them in net-next with more
indirect call wrapper boilerplate for qdiscs.

Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Fixes: ba27b4cdaaa6 ("net: dev: introduce support for sch BYPASS for lock=
less qdisc")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Due to pathological lack of coffee, a previous copy did not
land on the netdev ML, I'm sorry for the noise on CC addresses
---
 net/core/dev.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2577ebfed293..e10bd680dc03 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3662,26 +3662,8 @@ static inline int __dev_xmit_skb(struct sk_buff *s=
kb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
=20
 	if (q->flags & TCQ_F_NOLOCK) {
-		if ((q->flags & TCQ_F_CAN_BYPASS) && READ_ONCE(q->empty) &&
-		    qdisc_run_begin(q)) {
-			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
-					      &q->state))) {
-				__qdisc_drop(skb, &to_free);
-				rc =3D NET_XMIT_DROP;
-				goto end_run;
-			}
-			qdisc_bstats_cpu_update(q, skb);
-
-			rc =3D NET_XMIT_SUCCESS;
-			if (sch_direct_xmit(skb, q, dev, txq, NULL, true))
-				__qdisc_run(q);
-
-end_run:
-			qdisc_run_end(q);
-		} else {
-			rc =3D q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-			qdisc_run(q);
-		}
+		rc =3D q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		qdisc_run(q);
=20
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
--=20
2.21.1

