Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC8015C6B
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfEGGDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfEGFfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:35:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D72732087F;
        Tue,  7 May 2019 05:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207305;
        bh=A4X9SQPPjfGkJkY0C5z49LKq+k0Ez1/oGHC7xzeoxxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTSN+U/XeXNNd2Iieni7R8Sr7Q7I7FYHNPmoLWSHyydOuBkmWTxMkgSmmQysAw/f3
         BRSRg3aleSGZ10sR0crNpDxfD7dpLpBqwQhTOncfpfupqfriHG2E7HNlKSrR/nNMHs
         iSxVppsJp34iP06+7F1VK6J4n8gv8OlOHKYkOSJ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Vagin <avagin@gmail.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 75/99] netfilter: fix nf_l4proto_log_invalid to log invalid packets
Date:   Tue,  7 May 2019 01:32:09 -0400
Message-Id: <20190507053235.29900-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

[ Upstream commit d48668052b2603b6262459625c86108c493588dd ]

It doesn't log a packet if sysctl_log_invalid isn't equal to protonum
OR sysctl_log_invalid isn't equal to IPPROTO_RAW. This sentence is
always true. I believe we need to replace OR to AND.

Cc: Florian Westphal <fw@strlen.de>
Fixes: c4f3db1595827 ("netfilter: conntrack: add and use nf_l4proto_log_invalid")
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 859f5d07a915..78361e462e80 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -86,7 +86,7 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
 	struct va_format vaf;
 	va_list args;
 
-	if (net->ct.sysctl_log_invalid != protonum ||
+	if (net->ct.sysctl_log_invalid != protonum &&
 	    net->ct.sysctl_log_invalid != IPPROTO_RAW)
 		return;
 
-- 
2.20.1

