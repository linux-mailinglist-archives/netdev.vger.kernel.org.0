Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8405D2C25AC
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbgKXM1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:27:03 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40711 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729172AbgKXM1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:27:03 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@nvidia.com)
        with SMTP; 24 Nov 2020 14:26:57 +0200
Received: from c-236-0-240-241.mtl.labs.mlnx (c-236-0-240-241.mtl.labs.mlnx [10.236.0.241])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AOCQvkW022191;
        Tue, 24 Nov 2020 14:26:57 +0200
From:   Roi Dayan <roid@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Roi Dayan <roid@nvidia.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>, zahari.doychev@linux.com,
        jianbol@mellanox.com, jhs@mojatatu.com
Subject: [PATCH iproute2 1/1] tc flower: fix parsing vlan_id and vlan_prio
Date:   Tue, 24 Nov 2020 14:26:41 +0200
Message-Id: <20201124122641.46696-1-roid@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When protocol is vlan then eth_type is set to the vlan eth type.
So when parsing vlan_id and vlan_prio need to check tc_proto
is vlan and not eth_type.

Fixes: 4c551369e083 ("tc flower: use right ethertype in icmp/arp parsing")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 tc/f_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 58e1140d7391..9b278f3c0e83 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1432,7 +1432,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			__u16 vid;
 
 			NEXT_ARG();
-			if (!eth_type_vlan(eth_type)) {
+			if (!eth_type_vlan(tc_proto)) {
 				fprintf(stderr, "Can't set \"vlan_id\" if ethertype isn't 802.1Q or 802.1AD\n");
 				return -1;
 			}
@@ -1446,7 +1446,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			__u8 vlan_prio;
 
 			NEXT_ARG();
-			if (!eth_type_vlan(eth_type)) {
+			if (!eth_type_vlan(tc_proto)) {
 				fprintf(stderr, "Can't set \"vlan_prio\" if ethertype isn't 802.1Q or 802.1AD\n");
 				return -1;
 			}
-- 
2.25.4

