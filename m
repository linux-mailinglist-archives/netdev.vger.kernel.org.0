Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E527FB0E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgJAIHF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:47606 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731584AbgJAIHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:04 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-OKq6BDwgObuMt32IHqf7oA-1; Thu, 01 Oct 2020 04:00:45 -0400
X-MC-Unique: OKq6BDwgObuMt32IHqf7oA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 458C318C89FD;
        Thu,  1 Oct 2020 08:00:44 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 791D65C1D7;
        Thu,  1 Oct 2020 08:00:43 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 10/12] net: link_watch: fix detection of urgent events
Date:   Thu,  1 Oct 2020 09:59:34 +0200
Message-Id: <5a58a1a6425c565bb0ba7f46461fdd23cedb6b72.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linkwatch_urgent_event can miss urgent events when the device and its
link have the same ifindex, which can happen when those devices are in
different network namespaces.

With this setup, the vlan0 device can remain in LOWERLAYERDOWN state
for a full second (the linkwatch delay for non-urgent events), while
the vlan1 device will come up immediately:

    ip netns add a
    ip netns add b
    ip -net a link add dummy0 type dummy
    ip -net a link add link dummy0 vlan0 netns b type vlan id 1
    ip -net a link add link dummy0 vlan1 netns b type vlan id 2

    ip -net a link set dummy0 up
    ip -net b link set vlan1 down ; ip -net b link set vlan0 down
    sleep 2
    ip -net b link set vlan1 up   ; ip -net b link set vlan0 up

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/core/link_watch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 6932ad51aa4a..8a5d0ab820f9 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -92,7 +92,7 @@ static bool linkwatch_urgent_event(struct net_device *dev)
 	if (!netif_running(dev))
 		return false;
 
-	if (dev->ifindex != dev_get_iflink(dev))
+	if (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink)
 		return true;
 
 	if (netif_is_lag_port(dev) || netif_is_lag_master(dev))
-- 
2.28.0

