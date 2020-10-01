Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6727FB0A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgJAIHG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:06 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:52078 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731596AbgJAIHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-6b_LtMKCMyORfAEColTw4A-1; Thu, 01 Oct 2020 04:00:50 -0400
X-MC-Unique: 6b_LtMKCMyORfAEColTw4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FA913EB9;
        Thu,  1 Oct 2020 08:00:48 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E20CB5C1CF;
        Thu,  1 Oct 2020 08:00:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net 12/12] batman-adv: fix detection of lower link in batadv_get_real_netdevice
Date:   Thu,  1 Oct 2020 09:59:36 +0200
Message-Id: <9599bc5738a16580aa5b87a6586110953918d622.1600770261.git.sd@queasysnail.net>
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

Currently, batadv_get_real_netdevice can return different results in
this situation:

    ip netns add main
    ip netns add peer
    ip -net main link add dummy1 type dummy
    ip -net main link add link dummy1 netns peer type macsec # same ifindex as dummy1
    ip -net main link add link dummy1 netns peer type macsec port 2

Let's use the presence of a ndo_get_iflink operation, rather than the
value it returns, to detect a device without a link.

Fixes: 5ed4a460a1d3 ("batman-adv: additional checks for virtual interfaces on top of WiFi")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/batman-adv/hard-interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 0d87c5d56844..8f7d2dd37321 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -223,7 +223,7 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 	if (!netdev)
 		return NULL;
 
-	if (netdev->ifindex == dev_get_iflink(netdev)) {
+	if (!(netdev->netdev_ops && netdev->netdev_ops->ndo_get_iflink)) {
 		dev_hold(netdev);
 		return netdev;
 	}
-- 
2.28.0

