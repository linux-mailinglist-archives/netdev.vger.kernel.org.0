Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6584363B7
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJUOFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhJUOFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 10:05:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868B4C0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:02:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mdYem-0000iQ-MM; Thu, 21 Oct 2021 16:02:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     dsahern@kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH net] fcnal-test: kill hanging ping/nettest binaries on cleanup
Date:   Thu, 21 Oct 2021 16:02:47 +0200
Message-Id: <20211021140247.29691-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On my box I see a bunch of ping/nettest processes hanging
around after fcntal-test.sh is done.

Clean those up before netns deletion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/fcnal-test.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 13350cd5c8ac..5aba16c52c2b 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -439,10 +439,13 @@ cleanup()
 		ip -netns ${NSA} link set dev ${NSA_DEV} down
 		ip -netns ${NSA} link del dev ${NSA_DEV}
 
+		ip netns pids ${NSA} | xargs kill 2>/dev/null
 		ip netns del ${NSA}
 	fi
 
+	ip netns pids ${NSB} | xargs kill 2>/dev/null
 	ip netns del ${NSB}
+	ip netns pids ${NSC} | xargs kill 2>/dev/null
 	ip netns del ${NSC} >/dev/null 2>&1
 }
 
-- 
2.32.0

