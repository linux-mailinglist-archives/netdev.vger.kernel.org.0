Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D664BAFF3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiBRDDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:38 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiBRDDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E126359A41
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153399; x=1676689399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rJcUjjhStw1S/M4Ov0UOD4j8IEQ/i/HzgPMq0VdQJRk=;
  b=eEGp8XvugsT+JzrOSKIYZJ+26G4msi5BUCQHcYW1vtcOwQVz0MhNIJRC
   /QTp3znwJYapPIjSfuZyaD5BXz3HcUqXOCslbpeHKn5hvANqaHUXy/w5c
   NodTYLe/Ti/k0h99aXBrUgrm5lXhqAbGWWfCxlHxuL5JQhWnEz9dSRPCA
   rcD+RGSbusfceRYfrI/7YbWdIjRfB/Jr2n31BK/mxv27DKAywaUxhz3PU
   h9fllixXtnoVaQ3oYyAr1ILayDPd3HvudfuDBErkw3P3BIzFF2aF19OXM
   ZsoC2r0jwRUmGntdEwaF7n269ZijrRgJZNa71giiUraMmpEugJ9JLWnUH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794592"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794592"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431891"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] selftests: mptcp: increase timeout to 20 minutes
Date:   Thu, 17 Feb 2022 19:03:05 -0800
Message-Id: <20220218030311.367536-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

With the increase number of tests, one CI instance, using a debug kernel
config and not recent hardware, takes around 10 minutes to execute the
slowest MPTCP test: mptcp_join.sh.

Even if most CIs don't take that long to execute these tests --
typically max 10 minutes to run all selftests -- it will help some of
them if the timeout is increased.

The timeout could be disabled but it is always good to have an extra
safeguard, just in case.

Please note that on slow public CIs with kernel debug settings, it has
been observed it can easily take up to 45 minutes to execute all tests
in this very slow environment with other jobs running in parallel.
The slowest test, mptcp_join.sh takes ~30 minutes in this case.

In such environments, the selftests timeout set in the 'settings' file
is disabled because this environment is known as being exceptionnally
slow. It has been decided not to take such exceptional environments into
account and set the timeout to 20min.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/settings b/tools/testing/selftests/net/mptcp/settings
index a62d2fa1275c..79b65bdf05db 100644
--- a/tools/testing/selftests/net/mptcp/settings
+++ b/tools/testing/selftests/net/mptcp/settings
@@ -1 +1 @@
-timeout=600
+timeout=1200
-- 
2.35.1

