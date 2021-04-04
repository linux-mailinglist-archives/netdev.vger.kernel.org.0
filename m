Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE48E35393C
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhDDRuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 13:50:46 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45885 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhDDRup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 13:50:45 -0400
X-Originating-IP: 78.45.89.65
Received: from im-t490s.redhat.com (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 3089B20003;
        Sun,  4 Apr 2021 17:50:37 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     Pravin B Shelar <pshelar@ovn.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net] openvswitch: fix send of uninitialized stack memory in ct limit reply
Date:   Sun,  4 Apr 2021 19:50:31 +0200
Message-Id: <20210404175031.3834734-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'struct ovs_zone_limit' has more members than initialized in
ovs_ct_limit_get_default_limit().  The rest of the memory is a random
kernel stack content that ends up being sent to userspace.

Fix that by using designated initializer that will clear all
non-specified fields.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 net/openvswitch/conntrack.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c29b0ef1fc27..cadb6a29b285 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2032,10 +2032,10 @@ static int ovs_ct_limit_del_zone_limit(struct nlattr *nla_zone_limit,
 static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
 					  struct sk_buff *reply)
 {
-	struct ovs_zone_limit zone_limit;
-
-	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
-	zone_limit.limit = info->default_limit;
+	struct ovs_zone_limit zone_limit = {
+		.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE,
+		.limit   = info->default_limit,
+	};
 
 	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
-- 
2.26.2

