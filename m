Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB915BC2
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfEGF5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbfEGFhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:37:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C91E205ED;
        Tue,  7 May 2019 05:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207456;
        bh=/e5Rzz7OTo+vD5sjMdOifrw51uY0wJXphwAgI/IDy5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5KM7+jtqYMcvBqPzUif11sopmHYnUuUjikwTyKUi8eZkz2RdavfvZMhTscg0lqez
         K/Eh3yiYk39h/Hy8btsf93Ss95h8BOjKm6EXTmpOxt3le8B33e92uL6ooO3d6DpIBo
         Zf0tcx127WEgKJby3viBgtQqNsr7rbHPpFS3S3bg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Vagin <avagin@gmail.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 52/81] netfilter: fix nf_l4proto_log_invalid to log invalid packets
Date:   Tue,  7 May 2019 01:35:23 -0400
Message-Id: <20190507053554.30848-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
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
index 51c5d7eec0a3..e903ef9b96cf 100644
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

