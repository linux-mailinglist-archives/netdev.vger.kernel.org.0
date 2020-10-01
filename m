Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5689C27FB13
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbgJAIIJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:08:09 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:54308 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731067AbgJAIII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:08:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-s2QRyDWfMUOkq9IBwFci3A-1; Thu, 01 Oct 2020 04:00:44 -0400
X-MC-Unique: s2QRyDWfMUOkq9IBwFci3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20731ADF0D;
        Thu,  1 Oct 2020 08:00:43 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 570395C1CF;
        Thu,  1 Oct 2020 08:00:42 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 09/12] net: link_watch: fix operstate when the link has the same index as the device
Date:   Thu,  1 Oct 2020 09:59:33 +0200
Message-Id: <879af1e3232451feee4a306c1e757bef188b0ee4.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we create a macvlan device on top of a bond, the macvlan device
should always start with IF_OPER_LOWERLAYERDOWN if the bond is
down. Currently, this doesn't happen if the macvlan device gets the
same ifindex as the bond, which can happen because different
namespaces assign the ifindex independently:

    ip netns add main
    ip netns add peer
    ip -net main link add type bond # idx 9
    ip -net main link add link bond0 netns peer type macvlan # idx 10
    ip -net main link add link bond0 type macvlan # idx 9

    ip -net main link show type macvlan # M-DOWN since bond0 is DOWN
      10: macvlan0@bond0: <BROADCAST,MULTICAST,M-DOWN> ...

    ip -net peer link show type macvlan # should also be M-DOWN
       9: macvlan0@if9: <BROADCAST,MULTICAST> ...

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/core/link_watch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 75431ca9300f..6932ad51aa4a 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -38,7 +38,7 @@ static unsigned char default_operstate(const struct net_device *dev)
 		return IF_OPER_TESTING;
 
 	if (!netif_carrier_ok(dev))
-		return (dev->ifindex != dev_get_iflink(dev) ?
+		return (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink ?
 			IF_OPER_LOWERLAYERDOWN : IF_OPER_DOWN);
 
 	if (netif_dormant(dev))
-- 
2.28.0

