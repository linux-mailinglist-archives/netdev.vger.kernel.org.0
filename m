Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4248623A056
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgHCHdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:33:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43519 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725270AbgHCHdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 03:33:20 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 3 Aug 2020 10:33:13 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0737XCK2012882;
        Mon, 3 Aug 2020 10:33:13 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH net v2 2/2] netfilter: flowtable: Set offload timeout when adding flow
Date:   Mon,  3 Aug 2020 10:33:05 +0300
Message-Id: <20200803073305.702079-3-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20200803073305.702079-1-roid@mellanox.com>
References: <20200803073305.702079-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On heavily loaded systems the GC can take time to go over all existing
conns and reset their timeout. At that time other calls like from
nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
expired. To fix this when we set the offload bit we should also reset
the timeout instead of counting on GC to finish first iteration over
all conns before the initial timeout.

Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
Signed-off-by: Roi Dayan <roid@mellanox.com>
---

Notes:
    v2
    - timeout fix from flow_offload_add() instead of act_ct

 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b1eb5272b379..4f7a567c536e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -243,6 +243,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
+	nf_ct_offload_timeout(flow->ct);
+
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
-- 
2.8.4

