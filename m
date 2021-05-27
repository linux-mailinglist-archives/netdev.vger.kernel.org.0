Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE243939C5
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhE0X5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:57:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:38830 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236804AbhE0X4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:56:23 -0400
IronPort-SDR: OesIxgos4y/PQcGh+NJzDLR+6aQXm6SityKbJ4s6R9BB+X9BAkj6JGREhzlbUqMo0Gn/5MWCkP
 uhoJIxZo7i8A==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224079926"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="224079926"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
IronPort-SDR: AlZk9QDHn8HCxSHqdJlfmrUESDPaIAczaqLoigWubrKT9HkdmAEH8fMTN1tIp4HiRnyAmMM47x
 CgWZeaTgLuMw==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="443774254"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/7] mptcp: remove redundant initialization in pm_nl_init_net()
Date:   Thu, 27 May 2021 16:54:27 -0700
Message-Id: <20210527235430.183465-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
References: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

Memory of struct pm_nl_pernet{} is allocated by kzalloc()
in setup_net()->ops_init(), so it's no need to reset counters
and zero bitmap in pm_nl_init_net().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2469e06a3a9d..7dbc4f308dbe 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1913,10 +1913,13 @@ static int __net_init pm_nl_init_net(struct net *net)
 	struct pm_nl_pernet *pernet = net_generic(net, pm_nl_pernet_id);
 
 	INIT_LIST_HEAD_RCU(&pernet->local_addr_list);
-	__reset_counters(pernet);
 	pernet->next_id = 1;
-	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
 	spin_lock_init(&pernet->lock);
+
+	/* No need to initialize other pernet fields, the struct is zeroed at
+	 * allocation time.
+	 */
+
 	return 0;
 }
 
-- 
2.31.1

