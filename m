Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD4B50C360
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiDVWau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiDVWaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:30:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5E42B39A8
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650664558; x=1682200558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KzVgAjy1MAePp7dexbri62NwjNy15/+MEAR3zH12P2U=;
  b=NMRMNO1Us/53fIFO59ErzzW/tQOvDOeM+DY3ehn107FnQRMuUNF4GJyk
   mfW5kiMQ3NbFITBH1VGdWOo23JFhthuQLfVe6f9B2fSQbFmDt0P2Iir6l
   V5WrWTnn/LVmlN3Aor4b1rp09/77QQRVx+ffZ6fcnC47b7j/qzVG/N6sI
   OS3bU2osuVD6RzItWsugjwWqac+MhNwMQolEcMsXl/MyYN/Y9Ia286s0i
   doSlRnFY5rMPxmkDqyNYZwiZogfHmQmpcvM1B3bWcAjLjsA5PrbfHg2jb
   Am/xLqBxkaT8zs66qSxvfdJp9t7MNyDY5LsBC6N+cvPT6jJPoV4El6ldz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264285982"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264285982"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578119262"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.99.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/8] mptcp: infinite mapping receiving
Date:   Fri, 22 Apr 2022 14:55:40 -0700
Message-Id: <20220422215543.545732-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
References: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds the infinite mapping receiving logic. When the infinite
mapping is received, set the map_data_len of the subflow to 0.

In subflow_check_data_avail(), only reset the subflow when the map_data_len
of the subflow is non-zero.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 31dcb550316f..30ffb00661bb 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1006,7 +1006,9 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 
 	data_len = mpext->data_len;
 	if (data_len == 0) {
+		pr_debug("infinite mapping received");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
+		subflow->map_data_len = 0;
 		return MAPPING_INVALID;
 	}
 
@@ -1220,7 +1222,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 			return true;
 		}
 
-		if (subflow->mp_join || subflow->fully_established) {
+		if ((subflow->mp_join || subflow->fully_established) && subflow->map_data_len) {
 			/* fatal protocol error, close the socket.
 			 * subflow_error_report() will introduce the appropriate barriers
 			 */
-- 
2.36.0

