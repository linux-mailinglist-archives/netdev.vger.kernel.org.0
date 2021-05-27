Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D00A3939C9
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhE0X5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:57:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:38849 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236805AbhE0X4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:56:23 -0400
IronPort-SDR: Yq685jDSyxT838hKaABtXoaMK38TTgGWfBQNT6bWIX6SQjT7bBScyf2BeOz4HtYuDYqyRzFlTA
 gyxB20Q2u/jQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224079927"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="224079927"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
IronPort-SDR: f22sfi1egaHTR6B3xTSLz1ri23qMWeVim7VBIiZgx6pbQmKxUw8k3yH9z2y2lqWDF0elGy6a7X
 Qkiv+2i7Bu3g==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="443774257"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/7] mptcp: make sure flag signal is set when add addr with port
Date:   Thu, 27 May 2021 16:54:28 -0700
Message-Id: <20210527235430.183465-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
References: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

When add address with port, it is mean to create a listening socket,
and send an ADD_ADDR to remote, so it must have flag signal set,
add this check in mptcp_pm_parse_addr().

Fixes: a77e9179c7651 ("mptcp: deal with MPTCP_PM_ADDR_ATTR_PORT in PM netlink")
Acked-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7dbc4f308dbe..09722598994d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -971,8 +971,14 @@ static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
 		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
 
-	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
+	if (tb[MPTCP_PM_ADDR_ATTR_PORT]) {
+		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+			NL_SET_ERR_MSG_ATTR(info->extack, attr,
+					    "flags must have signal when using port");
+			return -EINVAL;
+		}
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));
+	}
 
 	return 0;
 }
-- 
2.31.1

