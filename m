Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E78110178
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfLCPnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 10:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbfLCPnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 10:43:45 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DE252070A;
        Tue,  3 Dec 2019 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575387824;
        bh=XzjGxQFNNGP7Xb9NC+HCNSYs1m7NPNzTqnj/N3YaE2o=;
        h=From:To:Cc:Subject:Date:From;
        b=kbUCHTprobwZmHos9LDcFyGhEnRVE5yjP9izejbEVYI44etuIVTvTGkKO9ygpsINl
         1hjVy4Bd22LEH8yQYikxPUasjw2c7MqYjU5wG+bS++B/VtvzhoNfjCA4VlnuI8MBRZ
         9IiEUPoIcsKEHBhqoAPqBHEVFDggKEK3O4U/4Rys=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>
Cc:     Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH net] net/core: Populate VF index in struct ifla_vf_guid
Date:   Tue,  3 Dec 2019 17:43:36 +0200
Message-Id: <20191203154337.42422-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

In addition to filling the node_guid and port_guid attributes,
there is a need to populate VF index too, otherwise users of netlink
interface will see same VF index for all VFs.

Fixes: 30aad41721e0 ("net/core: Add support for getting VF GUIDs")
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/core/rtnetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 93791dad3e31..af3a4f7ce3dc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1236,7 +1236,9 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		vf_spoofchk.vf =
 		vf_linkstate.vf =
 		vf_rss_query_en.vf =
-		vf_trust.vf = ivi.vf;
+		vf_trust.vf =
+		node_guid.vf =
+		port_guid.vf = ivi.vf;

 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
 	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
--
2.20.1

