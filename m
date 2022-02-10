Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C34B0210
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiBJBZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:25:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiBJBZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:25:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAC1205DF;
        Wed,  9 Feb 2022 17:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644456316; x=1675992316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G0+MAlrnsf/greE/vEdVzWDF/aTaDZ7Y2QTg6LX8frg=;
  b=ZP0dsq2Ytlr/Sj5TMQW2wheutX4axLG4MBzvFU0Fx5GBzxfehQjNsSJN
   2sk30YoSXk5t+sYUfgYp9BxO0qpcgFkI1oj7+rKTK04EpfvTEAbmF4nEV
   n9C376bRIWG6Zc/uBdMWIiWc2+Pt2dxBbqeKemsJEAitlFJ/4Ihepmptn
   2aYNZPqJD6V256JMP5suQqdtUXdcwxR+jeg42N45TJApZ0bnuyEJMmtr1
   lrPIizQlcM9GAxDNBYkVzZR2FvY4V+q1fUEH+LQOWvY7VdELAcR+4NP3p
   6FoJj9NlnrCcez/3hM+uZa7doUgyFXWknGJafvEA426ULzEhUyl6GvRFu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="230029677"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="230029677"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 17:25:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="526263247"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.22.101])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 17:25:15 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, stable@vger.kernel.org,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] mptcp: netlink: process IPv6 addrs in creating listening sockets
Date:   Wed,  9 Feb 2022 17:25:08 -0800
Message-Id: <20220210012508.226880-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
References: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change updates mptcp_pm_nl_create_listen_socket() to create
listening sockets bound to IPv6 addresses (where IPv6 is supported).

Cc: stable@vger.kernel.org
Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Acked-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 782b1d452269..356f596e2032 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -925,6 +925,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct mptcp_sock *msk;
 	struct socket *ssock;
@@ -949,8 +950,11 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	}
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
-	err = kernel_bind(ssock, (struct sockaddr *)&addr,
-			  sizeof(struct sockaddr_in));
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (entry->addr.family == AF_INET6)
+		addrlen = sizeof(struct sockaddr_in6);
+#endif
+	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
 	if (err) {
 		pr_warn("kernel_bind error, err=%d", err);
 		goto out;
-- 
2.35.1

