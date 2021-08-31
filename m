Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F303FCC3A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbhHaRUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 13:20:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:40152 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240340AbhHaRUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 13:20:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="216680285"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="216680285"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 10:19:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="690094692"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.246])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 10:19:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net v2 2/2] selftests: mptcp: clean tmp files in simult_flows
Date:   Tue, 31 Aug 2021 10:19:26 -0700
Message-Id: <20210831171926.80920-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
References: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

'$cin' and '$sin' variables are local to a function: they are then not
available from the cleanup trap.

Instead, we need to use '$large' and '$small' that are not local and
defined just before setting the trap.

Without this patch, running this script in a loop might cause a:

  write: No space left on device

issue.

Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index fd63ebfe9a2b..910d8126af8f 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -22,8 +22,8 @@ usage() {
 
 cleanup()
 {
-	rm -f "$cin" "$cout"
-	rm -f "$sin" "$sout"
+	rm -f "$cout" "$sout"
+	rm -f "$large" "$small"
 	rm -f "$capout"
 
 	local netns
-- 
2.33.0

