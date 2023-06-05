Return-Path: <netdev+bounces-7846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B34721C85
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414202810BF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EC93FDC;
	Mon,  5 Jun 2023 03:25:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4964139B;
	Mon,  5 Jun 2023 03:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F219C433A0;
	Mon,  5 Jun 2023 03:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685935529;
	bh=vCS+0O+llNRhLjcqsTnAJiVXReGH+K2zHMbKF1jlOBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=u9JkjjhpBuiI/wY6qZTXlttG13d/h1RcrVbqAbBfauQK1XJJLgOlmTCOHIbHbrEO4
	 0TE8eu1OJQ7HCWVtuHuTWL2bA5hC5+mVowI6XMdcD32kzURVb5fsFRxoKkjDky/tOH
	 uTnGiAHT54lqTPbIObf+VQygIWjYmxUFKYnU5o6YEQY6UDbHjUd1pB6+8Xz2gLLQyY
	 zhlI6ZJ7Q61FsiZBAxSXbI7V1BOPS4vbAUU9sYxDxKjmcosU472weRZTzzoUsi/wPD
	 i4K+y8c1lGW86ORL6ks/36JG3f7scNPPUGld4XFVAhfJFeXrKPnKeJqKUfhkO0ZxRS
	 2fKAB8jbxLXIQ==
From: Mat Martineau <martineau@kernel.org>
Date: Sun, 04 Jun 2023 20:25:18 -0700
Subject: [PATCH net 2/5] selftests: mptcp: update userspace pm addr tests
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230602-send-net-20230602-v1-2-fe011dfa859d@kernel.org>
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

This patch is linked to the previous commit ("mptcp: only send RM_ADDR in
nl_cmd_remove").

To align with what is done by the in-kernel PM, update userspace pm addr
selftests, by sending a remove_subflows command together after the
remove_addrs command.

Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Fixes: 97040cf9806e ("selftests: mptcp: userspace pm address tests")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 96f63172b8fe..651740a656f0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -862,7 +862,15 @@ do_transfer()
 				     sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
 				ip netns exec ${listener_ns} ./pm_nl_ctl ann $addr token $tk id $id
 				sleep 1
+				sp=$(grep "type:10" "$evts_ns1" |
+				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+				da=$(grep "type:10" "$evts_ns1" |
+				     sed -n 's/.*\(daddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
+				dp=$(grep "type:10" "$evts_ns1" |
+				     sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q')
 				ip netns exec ${listener_ns} ./pm_nl_ctl rem token $tk id $id
+				ip netns exec ${listener_ns} ./pm_nl_ctl dsf lip "::ffff:$addr" \
+							lport $sp rip $da rport $dp token $tk
 			fi
 
 			counter=$((counter + 1))

-- 
2.40.1


