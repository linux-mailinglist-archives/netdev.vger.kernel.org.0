Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31174B7D38
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbiBPCLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:11:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiBPCLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:52 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6462183B
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977500; x=1676513500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VAHQXvGMLjW0BhKz1BGe0ArSmPku8NRPTQCN9f9zBLs=;
  b=B1u71MOC3yCcml/LRDhLnchlaKOeRxYITewYt4vLfDuuI+gPIq8qtOGS
   Z3zDkXoT3gNdwyTKOk1FhWb/GyTCElXkE1pIEZ+mUEOBs3Bb1x9VkBZBg
   hgmN1dLHbhTcB9Aenko43vO6dc37v3pVlto7QZ6PtNMT2V8mDY/RqpOHa
   ABkzh1tZWNGZYwyVHEUGvcYdhj3djaRc4CgyRHSnE/yjEipJZXvmpKs0x
   nO3x4hFlh7lie3oLhEJsPSxJXAkrUDyp3rltA9pnirhl3M4JfrOrEMWSx
   1IHiFNAeXO2j2aRDTilrE/fVLRUTY4Vojq6i7QbzVElQDlWDnRrXJ5kad
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909070"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909070"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088816"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/8] mptcp: add SNDTIMEO setsockopt support
Date:   Tue, 15 Feb 2022 18:11:23 -0800
Message-Id: <20220216021130.171786-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
References: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Add setsockopt support for SO_SNDTIMEO_OLD and SO_SNDTIMEO_NEW to fix this
error reported by the mptcp bpf selftest:

 (network_helpers.c:64: errno: Operation not supported) Failed to set SO_SNDTIMEO
 test_mptcp:FAIL:115

 All error logs:

 (network_helpers.c:64: errno: Operation not supported) Failed to set SO_SNDTIMEO
 test_mptcp:FAIL:115
 Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index dacf3cee0027..f949d22f52bd 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -343,6 +343,8 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_RCVLOWAT:
 	case SO_RCVTIMEO_OLD:
 	case SO_RCVTIMEO_NEW:
+	case SO_SNDTIMEO_OLD:
+	case SO_SNDTIMEO_NEW:
 	case SO_BUSY_POLL:
 	case SO_PREFER_BUSY_POLL:
 	case SO_BUSY_POLL_BUDGET:
-- 
2.35.1

