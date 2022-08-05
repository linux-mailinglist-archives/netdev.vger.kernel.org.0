Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE4758A420
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbiHEAVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 20:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbiHEAVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 20:21:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DDA1A066
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 17:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659658896; x=1691194896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lfrTHdhyC6ywAdzyLkgsZFix3MXo+dFu0OSQV5qmghE=;
  b=Hiv3bvk0rimG9k2WQFLzVnI2xC3mn9KBX2AwBR4Ck83ad6fXAgZc3abm
   eBrFjqnV1bV3TIEbNZthBWb0IYuclRO/dNIrmYO6ghvg0+LZHfRrLIaJA
   H8Q5jyquun4/cd1NHg5abnfY7ssRIQQsW2/KeLwamCPolGUqMgpnuViw6
   j6FT3Qzc98BWuIDDFkL/iJwI3uRGTSFO8VKFCoEw+D3G5Nlr28q3CLJ+8
   KahOyYCBMtLW17t7MJc5D+pD/XwD/UQungRAM8jigZwRDsBHLi/VkVM/h
   FfdWVkWfOrLQglL16xlu6GcPreQry/nwfwE/n3+hYhkv58Kokx9reDKUh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="270467355"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="270467355"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="729810992"
Received: from ramankur-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.169.219])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, dcaratti@redhat.com,
        mptcp@lists.linux.dev, Xiumei Mu <xmu@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/3] selftests: mptcp: make sendfile selftest work
Date:   Thu,  4 Aug 2022 17:21:27 -0700
Message-Id: <20220805002127.88430-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
References: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When the selftest got added, sendfile() on mptcp sockets returned
-EOPNOTSUPP, so running 'mptcp_connect.sh -m sendfile' failed
immediately.

This is no longer the case, but the script fails anyway due to timeout.
Let the receiver know once the sender has sent all data, just like
with '-m mmap' mode.

v2: need to respect cfg_wait too, as pm_userspace.sh relied
on -m sendfile to keep the connection open (Mat Martineau)

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 26 ++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index e2ea6c126c99..24d4e9cb617e 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -553,6 +553,18 @@ static void set_nonblock(int fd, bool nonblock)
 		fcntl(fd, F_SETFL, flags & ~O_NONBLOCK);
 }
 
+static void shut_wr(int fd)
+{
+	/* Close our write side, ev. give some time
+	 * for address notification and/or checking
+	 * the current status
+	 */
+	if (cfg_wait)
+		usleep(cfg_wait);
+
+	shutdown(fd, SHUT_WR);
+}
+
 static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
 {
 	struct pollfd fds = {
@@ -630,14 +642,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after
 					/* ... and peer also closed already */
 					break;
 
-				/* ... but we still receive.
-				 * Close our write side, ev. give some time
-				 * for address notification and/or checking
-				 * the current status
-				 */
-				if (cfg_wait)
-					usleep(cfg_wait);
-				shutdown(peerfd, SHUT_WR);
+				shut_wr(peerfd);
 			} else {
 				if (errno == EINTR)
 					continue;
@@ -767,7 +772,7 @@ static int copyfd_io_mmap(int infd, int peerfd, int outfd,
 		if (err)
 			return err;
 
-		shutdown(peerfd, SHUT_WR);
+		shut_wr(peerfd);
 
 		err = do_recvfile(peerfd, outfd);
 		*in_closed_after_out = true;
@@ -791,6 +796,9 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 		err = do_sendfile(infd, peerfd, size);
 		if (err)
 			return err;
+
+		shut_wr(peerfd);
+
 		err = do_recvfile(peerfd, outfd);
 		*in_closed_after_out = true;
 	}
-- 
2.37.1

