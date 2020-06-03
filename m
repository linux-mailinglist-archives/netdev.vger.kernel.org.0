Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982ED1ECC42
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 11:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFCJM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 05:12:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725877AbgFCJM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 05:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591175545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=hKkgqcuE0bLXUgu+w+sntJ1W5FE/jZVw53E18zFTKcs=;
        b=UZyYzdDCxQL8fUn/wQ5qB8pSrxZUx2VuayM1qheycVNWHIDgi0w7/gY46JIuPCdcWUWhUt
        KQMwLlJcLX6k7aSJzub5iQ56tY5TmVmNUVeLK9QjzjvY2zOO2dnIvW5yui8EzCGtQnnoFY
        pTSxAJCr6tK6h+InnodsfFBaRlqSHCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-YSrle9TKNC26kvgUuRh4_A-1; Wed, 03 Jun 2020 05:12:23 -0400
X-MC-Unique: YSrle9TKNC26kvgUuRh4_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B409018FE861
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 09:12:22 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.194.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 321CA7F4C5
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 09:12:22 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net] geneve: change from tx_error to tx_dropped on missing metadata
Date:   Wed,  3 Jun 2020 11:12:14 +0200
Message-Id: <66009f71a08cba878fbdf86ca8dd137cdf19eaac.1591175373.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the geneve interface is in collect_md (external) mode, it can't send any
packets submitted directly to its net interface, as such packets won't have
metadata attached. This is expected.

However, the kernel itself sends some packets to the interface, most
notably, IPv6 DAD, IPv6 multicast listener reports, etc. This is not wrong,
as tunnel metadata can be specified in routing table (although technically,
that has never worked for IPv6, but hopefully will be fixed eventually) and
then the interface must correctly participate in IPv6 housekeeping.

The problem is that any such attempt increases the tx_error counter. Just
bringing up a geneve interface with IPv6 enabled is enough to see a number
of tx_errors. That causes confusion among users, prompting them to find
a network error where there is none.

Change the counter used to tx_dropped. That better conveys the meaning
(there's nothing wrong going on, just some packets are getting dropped) and
hopefully will make admins panic less.

Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 drivers/net/geneve.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 6b461be1820b..75266580b586 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -987,9 +987,10 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (geneve->collect_md) {
 		info = skb_tunnel_info(skb);
 		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
-			err = -EINVAL;
 			netdev_dbg(dev, "no tunnel metadata\n");
-			goto tx_error;
+			dev_kfree_skb(skb);
+			dev->stats.tx_dropped++;
+			return NETDEV_TX_OK;
 		}
 	} else {
 		info = &geneve->info;
@@ -1006,7 +1007,7 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (likely(!err))
 		return NETDEV_TX_OK;
-tx_error:
+
 	dev_kfree_skb(skb);
 
 	if (err == -ELOOP)
-- 
2.18.1

