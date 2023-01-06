Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8D16606D0
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbjAFS6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbjAFS5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:57:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A8D81132
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031459; x=1704567459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3fiv2KVsy3BxuGn+B7sjE5utRrRGPxnUasLYv+7wX4M=;
  b=KKL6YbDSUxjmCEg2oUTZkCTY3NRXV7itRyhsKYtnWIs53y5aObgQ9v1a
   GTLNoqnWC0cQWtjvMndhrEDAWoJ9ioxof8BZGdM/t0UEZTnkcnZMlfWDR
   vy+ncBjYCJjCvIX22ogVCXXVxfF+Cf5QdJXQJSEfl32lOHVms+tTHd5es
   gJToYm31gK3vDhAiS0/c7cc4JYKRyhbCdhoW0BXWb/6Hr/LomKIaTb4A3
   YI2ftlcmEWrehXdPGXY6GFkr6zU21dBEO+bWPjB4AzWDM5S2uScq0Sav4
   JyyIpLVCUcKnO5u3cGjQ32iT148gz6q3GRWxJ86W5KSG6mFm8LYd4g0IO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322611259"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="322611259"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688383435"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688383435"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/9] selftest: mptcp: exit from copyfd_io_poll() when receive SIGUSR1
Date:   Fri,  6 Jan 2023 10:57:24 -0800
Message-Id: <20230106185725.299977-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
References: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

For now, mptcp_connect won't exit after receiving the 'SIGUSR1' signal
if '-r' is set. Fix this by skipping poll and sleep in copyfd_io_poll()
if 'quit' is set.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 8a8266957bc5..b25a31445ded 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -627,7 +627,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd,
 		char rbuf[8192];
 		ssize_t len;
 
-		if (fds.events == 0)
+		if (fds.events == 0 || quit)
 			break;
 
 		switch (poll(&fds, 1, poll_timeout)) {
@@ -733,7 +733,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd,
 	}
 
 	/* leave some time for late join/announce */
-	if (cfg_remove)
+	if (cfg_remove && !quit)
 		usleep(cfg_wait);
 
 	return 0;
-- 
2.39.0

