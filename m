Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8FB12306
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEBUNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:13:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfEBUNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 16:13:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 57EB0308623B;
        Thu,  2 May 2019 20:13:02 +0000 (UTC)
Received: from netdev64.ntdv.lab.eng.bos.redhat.com (wsfd-netdev64.ntdv.lab.eng.bos.redhat.com [10.19.188.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0307E5C1B4;
        Thu,  2 May 2019 20:12:59 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     pshelar@ovn.org, davem@davemloft.net, dev@openvswitch.org
Subject: [PATCH net-next] net: openvswitch: return an error instead of doing BUG_ON()
Date:   Thu,  2 May 2019 16:12:38 -0400
Message-Id: <20190502201238.21698.58459.stgit@netdev64>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 02 May 2019 20:13:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For all other error cases in queue_userspace_packet() the error is
returned, so it makes sense to do the same for these two error cases.

Reported-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/openvswitch/datapath.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index b95015c..dc9ff93 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -455,7 +455,8 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	upcall->dp_ifindex = dp_ifindex;
 
 	err = ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false, user_skb);
-	BUG_ON(err);
+	if (err)
+		goto out;
 
 	if (upcall_info->userdata)
 		__nla_put(user_skb, OVS_PACKET_ATTR_USERDATA,
@@ -471,7 +472,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 		}
 		err = ovs_nla_put_tunnel_info(user_skb,
 					      upcall_info->egress_tun_info);
-		BUG_ON(err);
+		if (err)
+			goto out;
+
 		nla_nest_end(user_skb, nla);
 	}
 

