Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26FA5178A4
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387528AbiEBU4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387517AbiEBU4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:56:15 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC476574
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524765; x=1683060765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uCmDuCffsSpAMH/ALNDVwMW6WhS/bEFusqTpuRquYcM=;
  b=U5y5VUG2f9vnZ8zgTj+8IRO5cY48QD6sTe5za0PtNCl6PgRfwz3/Hqpt
   R+V3DMWcV8hp1y49US+hCP2Qi0p8F+hj0g3k+CObQis1aGsh/wtIUMsz4
   gp50qJ1DpIy0GyO9tg+WC1sd1NW6TXu3tfFScD6T4Hjd3Y/TxytI60Ldf
   tO71D2yCFF/Owq4aNfucpwti7If4uWdFqpLLNhiHCX2ymfLDIBga2bREo
   66jj6tYruvnnh/pXBY4XN4Cp9QernWNCyJIiwYBpQnWsKLg7c1iomQMlW
   yVYTl0I9q6e0NGcXi0LwQ4F1dMl0RmvgIO0eQsuLoUsRKT65ge97sxol2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="254785530"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="254785530"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733619588"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/7] mptcp: expose server_side attribute in MPTCP netlink events
Date:   Mon,  2 May 2022 13:52:36 -0700
Message-Id: <20220502205237.129297-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
References: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change records the 'server_side' attribute of MPTCP_EVENT_CREATED
and MPTCP_EVENT_ESTABLISHED events to inform their recipient about the
Client/Server role of the running MPTCP application.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/246
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h | 1 +
 net/mptcp/pm_netlink.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 9690efedb5fa..e41ea01a94bb 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -188,6 +188,7 @@ enum mptcp_event_attr {
 	MPTCP_ATTR_IF_IDX,	/* s32 */
 	MPTCP_ATTR_RESET_REASON,/* u32 */
 	MPTCP_ATTR_RESET_FLAGS, /* u32 */
+	MPTCP_ATTR_SERVER_SIDE,	/* u8 */
 
 	__MPTCP_ATTR_AFTER_LAST
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index eeaa96bcae6c..a4430c576ce9 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1985,6 +1985,9 @@ static int mptcp_event_created(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	if (nla_put_u8(skb, MPTCP_ATTR_SERVER_SIDE, READ_ONCE(msk->pm.server_side)))
+		return -EMSGSIZE;
+
 	return mptcp_event_add_subflow(skb, ssk);
 }
 
-- 
2.36.0

