Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2A13CD35
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgAOThX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:37:23 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:35105 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgAOThW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 14:37:22 -0500
X-Greylist: delayed 831 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2020 14:37:21 EST
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 00FJN41Y007665
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jan 2020 20:23:05 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Litao jiao <jiaolitao@raisecom.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>
Subject: [net] vxlan: fix vxlan6_get_route() adding a call to xfrm_lookup_route()
Date:   Wed, 15 Jan 2020 20:22:31 +0100
Message-Id: <20200115192231.3005-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently IPSEC cannot be used to encrypt/decrypt IPv6 vxlan traffic.
The problem is that the vxlan module uses the vxlan6_get_route()
function to find out the route for transmitting an IPv6 packet, which in
turn uses ip6_dst_lookup() available in ip6_output.c.
Unfortunately ip6_dst_lookup() does not perform any xfrm route lookup,
so the xfrm framework cannot be used with vxlan6.

To fix the issue above, the vxlan6_get_route() function has been patched
by adding a missing call to xfrm_lookup_route(). Doing that, the
vxlan6_get_route() is now capable to lookup a route taking into account
also xfrm policies, if any.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
---
 drivers/net/vxlan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index bf04bc2e68c2..bec55a911c4f 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2306,6 +2306,11 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 		return ERR_PTR(-ENETUNREACH);
 	}
 
+	ndst = xfrm_lookup_route(vxlan->net, ndst, flowi6_to_flowi(&fl6),
+				 sock6->sock->sk, 0);
+	if (IS_ERR_OR_NULL(ndst))
+		return ERR_PTR(-ENETUNREACH);
+
 	if (unlikely(ndst->dev == dev)) {
 		netdev_dbg(dev, "circular route to %pI6\n", daddr);
 		dst_release(ndst);
-- 
2.20.1

