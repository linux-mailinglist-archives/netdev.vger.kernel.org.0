Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA127FB09
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbgJAIHG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:06 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:54589 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731592AbgJAIHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-xfHXktrMMp-DTQpSgZrIYQ-1; Thu, 01 Oct 2020 04:00:48 -0400
X-MC-Unique: xfHXktrMMp-DTQpSgZrIYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 882F210BBED0;
        Thu,  1 Oct 2020 08:00:46 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E5705C1CF;
        Thu,  1 Oct 2020 08:00:44 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net 11/12] batman-adv: fix iflink detection in batadv_is_on_batman_iface
Date:   Thu,  1 Oct 2020 09:59:35 +0200
Message-Id: <afa206858a88910691bdb917d0956cea3f32f667.1600770261.git.sd@queasysnail.net>
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

BATMAN compares ifindex with dev_get_iflink to detect devices that
don't have a parent, but that's wrong, since a device can have the
same index as its parent if it's created in a different network
namespace:

    ip netns add main
    ip netns add peer
    ip -net main link add dummy0 type dummy
    # keep ifindex in sync between the namespaces
    ip -net peer link add eatidx type dummy

    ip netns exec main batctl if add dummy0
    # macsec0 and bat0 have the same ifindex
    ip -net main link add link bat0 netns peer type macsec
    ip netns exec peer batctl if add macsec0

That last command would fail if we didn't keep the ifindex in sync
between the two namespaces, and should also fail when the macsec0
device has the same ifindex as its link. Let's use the presence of a
ndo_get_iflink operation, rather than the value it returns, to detect
a device without a link.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/batman-adv/hard-interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index fa06b51c0144..0d87c5d56844 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -159,7 +159,7 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 
 	/* no more parents..stop recursion */
 	if (dev_get_iflink(net_dev) == 0 ||
-	    dev_get_iflink(net_dev) == net_dev->ifindex)
+	    !(net_dev->netdev_ops && net_dev->netdev_ops->ndo_get_iflink))
 		return false;
 
 	parent_net = batadv_getlink_net(net_dev, net);
-- 
2.28.0

