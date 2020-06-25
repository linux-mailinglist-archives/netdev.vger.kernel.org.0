Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1971F20A669
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390785AbgFYUMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:12:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389344AbgFYUMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593115934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AceQv1Pht73uByJy0LhtnWLO52xwnez23HLgovVp0cg=;
        b=b1qPcKCnqSGWxVJroYLXVXCk4Jqyr0c1kx8ncKFSEDVzroJtb1bq5yB3bdNIE/wOGg0DmI
        HQE5jWaamBJDCkBV1gifoqT1T7QpX0o4eRF4hjYC1Y/fh1q4lqUWdp+SF6yWOD5mfpgueq
        qE97qqnZz9ObEZQmx6F3rh3L/HVfFLY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-7npVg3tYMCSjd18B7uIAYg-1; Thu, 25 Jun 2020 16:12:11 -0400
X-MC-Unique: 7npVg3tYMCSjd18B7uIAYg-1
Received: by mail-qk1-f200.google.com with SMTP id 204so4941764qki.20
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AceQv1Pht73uByJy0LhtnWLO52xwnez23HLgovVp0cg=;
        b=D6qCVmMJqmVODaS+usKQM0CrTyGg+efIAg2Z2idayTAnHCf5xdNYPkqzv+J0UhnCfO
         3ExUYPwsbqufZl2d90mZ2QbXqdZ2iyGaTr7LIVqjsB8aYmFd9htKfaN6xERsFLwQ4MGH
         Y2GHxaBOcO2C+n1CkAYAJ1U764khmOJBtmrnvdf6WmzWf+yMm5glffanjQV/KxiEqGBW
         uwI6a/IqeLlc/KG2g5n6ZgscGYBudKAlVfEnVFrVd0DTHm9XDXWNZCvm5iT2IPWIMple
         X7N1v+Mizk83MHnMLRNR2td5aNst27UpyAUeyd74ZK0+pUUnJPUVuXwlipDYnuW7aK32
         kdaA==
X-Gm-Message-State: AOAM533oXtbnhejrwUo98IjqLbQM3F/1/sNjSnKG7LBOF8m0wrWPS9cP
        EP/xghDS5sPs2MElw4qzvrWEbZ6T3lwqrK4wq/ZW75kYZT/TYf+JhFrouBORO0uaAf8sn2FMvOe
        1O06tP4lWTz36otA8
X-Received: by 2002:a37:5b81:: with SMTP id p123mr23554531qkb.150.1593115930885;
        Thu, 25 Jun 2020 13:12:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPSz4rD1cTkLTiDYIIsSKKfe4VQ60Qil8ZXRoEPj1gtJkYL675rJPfUDZFJRUNU3/jkr84Dg==
X-Received: by 2002:a37:5b81:: with SMTP id p123mr23554510qkb.150.1593115930658;
        Thu, 25 Jun 2020 13:12:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v12sm7126493qtj.32.2020.06.25.13.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:12:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 50D7C1814FC; Thu, 25 Jun 2020 22:12:08 +0200 (CEST)
Subject: [PATCH net 2/3] sch_cake: don't call diffserv parsing code when it is
 not needed
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 22:12:08 +0200
Message-ID: <159311592823.207748.268914285724823456.stgit@toke.dk>
In-Reply-To: <159311592607.207748.5904268231642411759.stgit@toke.dk>
References: <159311592607.207748.5904268231642411759.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

As a further optimisation of the diffserv parsing codepath, we can skip it
entirely if CAKE is configured to neither use diffserv-based
classification, nor to zero out the diffserv bits.

Fixes: c87b4ecdbe8d ("sch_cake: Make sure we can write the IP header before changing DSCP bits")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index cae006bef565..094d6e652deb 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1551,7 +1551,7 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return idx + (tin << 16);
 }
 
-static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
+static u8 cake_handle_diffserv(struct sk_buff *skb, bool wash)
 {
 	const int offset = skb_network_offset(skb);
 	u16 *buf, buf_;
@@ -1612,14 +1612,17 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 tin, mark;
+	bool wash;
 	u8 dscp;
 
 	/* Tin selection: Default to diffserv-based selection, allow overriding
-	 * using firewall marks or skb->priority.
+	 * using firewall marks or skb->priority. Call DSCP parsing early if
+	 * wash is enabled, otherwise defer to below to skip unneeded parsing.
 	 */
-	dscp = cake_handle_diffserv(skb,
-				    q->rate_flags & CAKE_FLAG_WASH);
 	mark = (skb->mark & q->fwmark_mask) >> q->fwmark_shft;
+	wash = !!(q->rate_flags & CAKE_FLAG_WASH);
+	if (wash)
+		dscp = cake_handle_diffserv(skb, wash);
 
 	if (q->tin_mode == CAKE_DIFFSERV_BESTEFFORT)
 		tin = 0;
@@ -1633,6 +1636,8 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 		tin = q->tin_order[TC_H_MIN(skb->priority) - 1];
 
 	else {
+		if (!wash)
+			dscp = cake_handle_diffserv(skb, wash);
 		tin = q->tin_index[dscp];
 
 		if (unlikely(tin >= q->tin_cnt))

