Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1287519263A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgCYKxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:53:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45752 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726139AbgCYKxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:53:35 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 25 Mar 2020 12:53:33 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02PArWhK013788;
        Wed, 25 Mar 2020 12:53:32 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next] netfilter: flowtable: Fix accessing null dst entry
Date:   Wed, 25 Mar 2020 12:53:28 +0200
Message-Id: <1585133608-25295-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlink nft flow table flows, flows from act_ct tables don't have route,
and so don't have a dst_entry. nf_flow_rule_match() tries to deref
this null dst_entry regardless.

Fix that by checking for dst entry exists, and if not, skip
tunnel match.

Fixes: cfab6dbd0ecf ("netfilter: flowtable: add tunnel match offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ca40dfa..6518a91 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -92,7 +92,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
-	if (other_dst->lwtstate) {
+	if (other_dst && other_dst->lwtstate) {
 		tun_info = lwt_tun_info(other_dst->lwtstate);
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
-- 
1.8.3.1

