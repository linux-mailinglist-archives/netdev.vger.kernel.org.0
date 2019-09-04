Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECDAA8A36
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732076AbfIDP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732038AbfIDP6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646C222DBF;
        Wed,  4 Sep 2019 15:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612719;
        bh=WCP6QyaYIxXcP8RcE8oUkk9e6+XZKDW0z21xQZ+MEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3XTBGuGYMKGqGBO3x5WBbEjxULDFz0O6vO4onPlq5jIMfZex9TQiyZEHuD3NF7zE
         O6qi+bqGumGNx6dEMShoxhSxF7amEXeWozZy8jCdufv6NoFqTu/LtjSCFOfadH8Ud2
         PwbotcEckw1aWhtuYGFgLy+sIBFACXldPlcy29LM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Petar Penkov <ppenkov@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 40/94] flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH
Date:   Wed,  4 Sep 2019 11:56:45 -0400
Message-Id: <20190904155739.2816-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit db38de39684dda2bf307f41797db2831deba64e9 ]

Call to bpf_prog_put(), with help of call_rcu(), queues an RCU-callback to
free the program once a grace period has elapsed. The callback can run
together with new RCU readers that started after the last grace period.
New RCU readers can potentially see the "old" to-be-freed or already-freed
pointer to the program object before the RCU update-side NULLs it.

Reorder the operations so that the RCU update-side resets the protected
pointer before the end of the grace period after which the program will be
freed.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Petar Penkov <ppenkov@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index edd622956083d..b15c0c0f6e557 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -138,8 +138,8 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 		mutex_unlock(&flow_dissector_mutex);
 		return -ENOENT;
 	}
-	bpf_prog_put(attached);
 	RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
+	bpf_prog_put(attached);
 	mutex_unlock(&flow_dissector_mutex);
 	return 0;
 }
-- 
2.20.1

