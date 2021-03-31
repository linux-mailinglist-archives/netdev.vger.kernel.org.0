Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2ED34F556
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhCaAJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:14824 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232580AbhCaAJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:04 -0400
IronPort-SDR: 0WousGZcXS8dLKBcjZa6I7d7S8AxSuyqZB2iRtI3zKFfau4/ZcrjbWmNlboAFWMvjr5r+fTYdL
 Um5Y08kim7vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277058943"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="277058943"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
IronPort-SDR: LAnNb3uuzyfQaXR7//ZMqRINGz44cybAHojwlrX0TNi1TluBi05SpqkwCip9eUSjON2giZvcum
 2VbWKz8G19eA==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682560"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH net-next 4/6] selftests: mptcp: avoid calling pm_nl_ctl with bad IDs
Date:   Tue, 30 Mar 2021 17:08:54 -0700
Message-Id: <20210331000856.117636-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

IDs are supposed to be between 0 and 255.

In pm_nl_ctl, for both the 'add' and 'get' instruction, the ID is casted
in a u_int8_t. So if we give 256, we will delete ID 0. Obviously, the
goal is not to delete this ID by giving 256.

We could modify pm_nl_ctl and stop if the ID is negative or higher than
255 but probably better not to increase the number of lines for such
things in this tool which is only used in selftests. Instead, we use it
within the limits.

This modification also means that we will no longer add a new ID for the
2nd entry. That's why we removed an expected entry from the dump and
introduced with
commit dc8eb10e95a8 ("selftests: mptcp: add testcases for setting the address ID").

So now we delete ID 9 like before and we add entries for IDs 10 to 255
that are deleted just after.

Note that this could be seen as a fix but it was not really an issue so
far: we were simply playing with ID 0/1 once again. With the following
commit ("selftests: mptcp: add addr argument for del_addr"), it will be
different because ID 0 is going to required an address. We don't want
errors when trying to delete ID 0 without the address argument.

Acked-and-tested-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index a617e293734c..3c741abe034e 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -100,12 +100,12 @@ done
 check "ip netns exec $ns1 ./pm_nl_ctl get 9" "id 9 flags signal 10.0.1.9" "hard addr limit"
 check "ip netns exec $ns1 ./pm_nl_ctl get 10" "" "above hard addr limit"
 
-for i in `seq 9 256`; do
+ip netns exec $ns1 ./pm_nl_ctl del 9
+for i in `seq 10 255`; do
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.9 id $i
 	ip netns exec $ns1 ./pm_nl_ctl del $i
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.9 id $((i+1))
 done
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags  10.0.1.1
-id 2 flags  10.0.0.9
 id 3 flags signal,backup 10.0.1.3
 id 4 flags signal 10.0.1.4
 id 5 flags signal 10.0.1.5
-- 
2.31.1

