Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19C149576A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378423AbiAUAfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:35:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:65249 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378409AbiAUAfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642725338; x=1674261338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6d0wzumL2zpgrbwhNb2ExiuQQiRc8+qhYIDnlEKDhk=;
  b=ZOfNe4kOdcSaLudh7PGJBcmA5YK0d/+GCgSSCi0Kgt/aaC/6D1GHzY1s
   xcDaqXWYj5raMgp7XBjRGVRfyoqwmxTB/tbe3bBPslEdrFFTdsoB+Gqtf
   bLW1biFTUufT/uxLMWd8tN/1oI1l6Usk5k6qihfbrQcjznw8XUGSlwV0g
   uTAxUjb5zg9zmjSIT5exyElQW2ceYiS2/SmpO2cQSyRn5Je8iZ7Qt3Nli
   y8yMjfL9kYvlER38ENy1vofGaL2Nty3bt/wqU0fDZJ4A54KdzMlWPm8Vl
   woxP+hnK3krob4H6AY5lxYcGrFE+0ESZr1mk8CoAqvMJwWdLpcxNbOtx+
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="226200822"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="226200822"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:35:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="531215218"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.220.167])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:35:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/3] mptcp: fix removing ids bitmap setting
Date:   Thu, 20 Jan 2022 16:35:28 -0800
Message-Id: <20220121003529.54930-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
References: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

In mptcp_pm_nl_rm_addr_or_subflow(), the bit of rm_list->ids[i] in the
id_avail_bitmap should be set, not rm_list->ids[1]. This patch fixed it.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index f17a09f7fbf9..782b1d452269 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -791,7 +791,7 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			removed = true;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
-		__set_bit(rm_list->ids[1], msk->pm.id_avail_bitmap);
+		__set_bit(rm_list->ids[i], msk->pm.id_avail_bitmap);
 		if (!removed)
 			continue;
 
-- 
2.34.1

