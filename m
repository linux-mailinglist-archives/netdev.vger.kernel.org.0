Return-Path: <netdev+bounces-7845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6FC721C84
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1102810FE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C020620FB;
	Mon,  5 Jun 2023 03:25:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC5F137D;
	Mon,  5 Jun 2023 03:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B30C4339B;
	Mon,  5 Jun 2023 03:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685935530;
	bh=YUyzdA7qU9iJt56KPySyZzECEj2SmbL6D5w4307jOiQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UwL8LFvw3KFZWf8+jR1+sKRJiG9Nx36ieuplhhpXqVDA6AmYIPbr417MJwhaGwCQk
	 7nch5K1NMngPTcg+nm9tGjxnzLhosrd31lPQ+lZMIUkAzKQZRUq+L4ahz1TTSeMpUs
	 ydLHIa/XFeaecJmgBP3kwPLDmMM9knJqNjCpIYYYRw+RyTE94RU/q/SRJy4BrQ4y8S
	 CwgHbfVPX1bar+DeGr3MUrt3aEez7DZwYNIWDoMRIGH8R8tFUTNRgX2clCkYkIZHSq
	 Zq98ndYIsw1RnmT26FAKSmP7xTQKCgW0RLAoTgVzA6IuGBhTxitrQyxD2NHGYk3kYe
	 mUl0hx/Gu5GVQ==
From: Mat Martineau <martineau@kernel.org>
Date: Sun, 04 Jun 2023 20:25:20 -0700
Subject: [PATCH net 4/5] selftests: mptcp: update userspace pm subflow
 tests
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230602-send-net-20230602-v1-4-fe011dfa859d@kernel.org>
References: <20230602-send-net-20230602-v1-0-fe011dfa859d@kernel.org>
In-Reply-To: <20230602-send-net-20230602-v1-0-fe011dfa859d@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kishen Maloor <kishen.maloor@intel.com>, 
 Geliang Tang <geliang.tang@suse.com>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.12.2

From: Geliang Tang <geliang.tang@suse.com>

To align with what is done by the in-kernel PM, update userspace pm
subflow selftests, by sending the a remove_addrs command together
before the remove_subflows command. This will get a RM_ADDR in
chk_rm_nr().

Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Fixes: 5e986ec46874 ("selftests: mptcp: userspace pm subflow tests")
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/379
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 651740a656f0..29f0c99d9a46 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -936,6 +936,7 @@ do_transfer()
 				sleep 1
 				sp=$(grep "type:10" "$evts_ns2" |
 				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+				ip netns exec ${connector_ns} ./pm_nl_ctl rem token $tk id $id
 				ip netns exec ${connector_ns} ./pm_nl_ctl dsf lip $addr lport $sp \
 									rip $da rport $dp token $tk
 			fi
@@ -3150,7 +3151,7 @@ userspace_tests()
 		pm_nl_set_limits $ns1 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow
 		chk_join_nr 1 1 1
-		chk_rm_nr 0 1
+		chk_rm_nr 1 1
 		kill_events_pids
 	fi
 }

-- 
2.40.1


