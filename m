Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA2AE5AA9
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfJZNQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbfJZNQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C0321E6F;
        Sat, 26 Oct 2019 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095814;
        bh=n8LV+Zy/n4u8Rf26UdYHsaoqWPPxw9wALgq1SRMH8WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1a/0ZsceQky8W6QCWEgW84LbJjDzi3JLya3BftgEBM4OaYTkikAA+q6GeL1WsraKl
         hljfG3VypbqlVymWI/DStb+Cqn3Tfe/EbjqUWASmV7dNgD7+ik1yMvEgRucMmFiF8x
         kpTHUmWV1kAltRsEZSPFQluEeWzXeTd3COMdQgmE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Benc <jbenc@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 29/99] selftests/bpf: Set rp_filter in test_flow_dissector
Date:   Sat, 26 Oct 2019 09:14:50 -0400
Message-Id: <20191026131600.2507-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit fd418b01fe26c2430b1091675cceb3ab2b52e1e0 ]

Many distributions enable rp_filter. However, the flow dissector test
generates packets that have 1.1.1.1 set as (inner) source address without
this address being reachable. This causes the selftest to fail.

The selftests should not assume a particular initial configuration. Switch
off rp_filter.

Fixes: 50b3ed57dee9 ("selftests/bpf: test bpf flow dissection")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Petar Penkov <ppenkov@google.com>
Link: https://lore.kernel.org/bpf/513a298f53e99561d2f70b2e60e2858ea6cda754.1570539863.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_flow_dissector.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index d23d4da66b834..e2d06191bd35c 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -63,6 +63,9 @@ fi
 
 # Setup
 tc qdisc add dev lo ingress
+echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
+echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
+echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
 
 echo "Testing IPv4..."
 # Drops all IP/UDP packets coming from port 9
-- 
2.20.1

