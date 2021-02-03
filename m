Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB0030D233
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhBCDi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:38:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44555 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230083AbhBCDi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 22:38:28 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from cmi@nvidia.com)
        with SMTP; 3 Feb 2021 05:10:59 +0200
Received: from dev-r630-03.mtbc.labs.mlnx (dev-r630-03.mtbc.labs.mlnx [10.75.205.13])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 1133AvNn017835;
        Wed, 3 Feb 2021 05:10:58 +0200
From:   Chris Mi <cmi@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     idosch@nvidia.com, Chris Mi <cmi@nvidia.com>,
        Yotam Gigi <yotam.gi@gmail.com>
Subject: [PATCH net] net: psample: Fix the netlink skb length
Date:   Wed,  3 Feb 2021 11:10:28 +0800
Message-Id: <20210203031028.171318-1-cmi@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the netlink skb length only includes metadata and data
length. It doesn't include the psample generic netlink header length.
Fix it by adding it.

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
CC: Yotam Gigi <yotam.gi@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
---
 net/psample/psample.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index 33e238c965bd..807d75f5a40f 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -363,6 +363,7 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 	struct ip_tunnel_info *tun_info;
 #endif
 	struct sk_buff *nl_skb;
+	int header_len;
 	int data_len;
 	int meta_len;
 	void *data;
@@ -381,12 +382,13 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 		meta_len += psample_tunnel_meta_len(tun_info);
 #endif
 
+	/* psample generic netlink header size */
+	header_len = nlmsg_total_size(GENL_HDRLEN + psample_nl_family.hdrsize);
 	data_len = min(skb->len, trunc_size);
-	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
-		data_len = PSAMPLE_MAX_PACKET_SIZE - meta_len - NLA_HDRLEN
+	if (header_len + meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
+		data_len = PSAMPLE_MAX_PACKET_SIZE - header_len - meta_len - NLA_HDRLEN
 			    - NLA_ALIGNTO;
-
-	nl_skb = genlmsg_new(meta_len + nla_total_size(data_len), GFP_ATOMIC);
+	nl_skb = genlmsg_new(header_len + meta_len + nla_total_size(data_len), GFP_ATOMIC);
 	if (unlikely(!nl_skb))
 		return;
 
-- 
2.26.2

