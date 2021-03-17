Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D230F33F889
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhCQSyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:54:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39348 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhCQSy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:54:27 -0400
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1lMbJJ-0007zv-QH; Wed, 17 Mar 2021 18:54:26 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
Subject: [PATCH 2/2] neighbour: allow NUD_NOARP entries to be forced GCed
Date:   Wed, 17 Mar 2021 15:53:20 -0300
Message-Id: <20210317185320.1561608-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317185320.1561608-1-cascardo@canonical.com>
References: <20210317185320.1561608-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's possible to
fill up the neighbour table with enough entries that it will overflow for
valid connections after that.

This behaviour is more prevalent after commit 58956317c8de ("neighbor:
Improve garbage collection") is applied, as it prevents removal from
entries that are not NUD_FAILED, unless they are more than 5s old.

Fixes: 58956317c8de (neighbor: Improve garbage collection)
Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index bbc89c7ffdfd..be5ca411b149 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -256,6 +256,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 		write_lock(&n->lock);
 		if ((n->nud_state == NUD_FAILED) ||
+		    (n->nud_state == NUD_NOARP) ||
 		    (tbl->is_multicast &&
 		     tbl->is_multicast(n->primary_key)) ||
 		    time_after(tref, n->updated))
-- 
2.27.0

