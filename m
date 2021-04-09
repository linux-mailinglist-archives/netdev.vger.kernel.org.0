Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B412B359C9B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhDILFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233808AbhDILFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617966296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Kg+9VcaU+Z6KIIDcciZvVQMsHcbW6lW06uhXUx6N6o=;
        b=cavgd5tcAUQOWe3exW59tDhBF3eXlOfHpQUvbDSr8ctuD1UWDQS+4Mijsz40dn5aUZgwT2
        eBsOjABTcjwYPj98QbGsyjZnYGnaIWxyZLMAcyoIwiRNcvzE/qyBc6CWw5buaPPQ6x0R9K
        kqvYzbvUSsiV+KQxE7KZd0hfGt21hSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-16so64Y2OJm-xl5h7uCcBw-1; Fri, 09 Apr 2021 07:04:52 -0400
X-MC-Unique: 16so64Y2OJm-xl5h7uCcBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2539F1020C20;
        Fri,  9 Apr 2021 11:04:51 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFC1210023BE;
        Fri,  9 Apr 2021 11:04:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 1/4] veth: use skb_orphan_partial instead of skb_orphan
Date:   Fri,  9 Apr 2021 13:04:37 +0200
Message-Id: <e72b0660f85d505c91544153b6c244a1a322651a.1617965243.git.pabeni@redhat.com>
In-Reply-To: <cover.1617965243.git.pabeni@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As described by commit 9c4c325252c5 ("skbuff: preserve sock
reference when scrubbing the skb."), orphaning a skb
in the TX path will cause OoO.

Let's use skb_orphan_partial() instead of skb_orphan(), so
that we keep the sk around for queue's selection sake and we
still avoid the problem fixed with commit 4bf9ffa0fb57 ("veth:
Orphan skb before GRO")

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 91b73db37555b..ad36e7ed16134 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -674,7 +674,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	int mac_len, delta, off;
 	struct xdp_buff xdp;
 
-	skb_orphan(skb);
+	skb_orphan_partial(skb);
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
-- 
2.26.2

