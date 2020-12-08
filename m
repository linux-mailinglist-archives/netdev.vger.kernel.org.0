Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07732D2121
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgLHCt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:49:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48387 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727816AbgLHCt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 21:49:28 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from cmi@nvidia.com)
        with SMTP; 8 Dec 2020 04:48:39 +0200
Received: from dev-r630-03.mtbc.labs.mlnx (dev-r630-03.mtbc.labs.mlnx [10.75.205.13])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B82mbFN017563;
        Tue, 8 Dec 2020 04:48:37 +0200
From:   Chris Mi <cmi@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kuba@kernel.org, roid@nvidia.com,
        Chris Mi <cmi@nvidia.com>
Subject: [PATCH net v2] net: flow_offload: Fix memory leak for indirect flow block
Date:   Tue,  8 Dec 2020 10:48:35 +0800
Message-Id: <20201208024835.63253-1-cmi@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offending commit introduces a cleanup callback that is invoked
when the driver module is removed to clean up the tunnel device
flow block. But it returns on the first iteration of the for loop.
The remaining indirect flow blocks will never be freed.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
CC: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
v2: - CC relevant people.

 net/core/flow_offload.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index d4474c812b64..715b67f6c62f 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -381,10 +381,8 @@ static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
 		if (this->release == release &&
-		    this->indr.cb_priv == cb_priv) {
+		    this->indr.cb_priv == cb_priv)
 			list_move(&this->indr.list, cleanup_list);
-			return;
-		}
 	}
 }
 
-- 
2.26.2

