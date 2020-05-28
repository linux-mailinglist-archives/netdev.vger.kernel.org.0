Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28681E5FC4
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbgE1L5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388916AbgE1L5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F13215A4;
        Thu, 28 May 2020 11:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667022;
        bh=XGQY4lkxh1sVy4fv5Bb37M5kyF4uv2WZElrUH33Elkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avLHH3Ufe47ouF3ge1A3jRv0bnRILfU9LZ3G6+jMR83AlE57I9ZGRW3+9kJLnhonv
         +6t8Z74qDUXv/EI2b572oeBVWvy/kU90ZvngyVjYzpzJHEcjXiWv9jBHIpu0ld4YmY
         tWKqusYfbMfR47ggZbWR/mGQES1/zrDd3wSFT3lg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Mashak <mrv@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/26] net sched: fix reporting the first-time use timestamp
Date:   Thu, 28 May 2020 07:56:35 -0400
Message-Id: <20200528115654.1406165-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115654.1406165-1-sashal@kernel.org>
References: <20200528115654.1406165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>

[ Upstream commit b15e62631c5f19fea9895f7632dae9c1b27fe0cd ]

When a new action is installed, firstuse field of 'tcf_t' is explicitly set
to 0. Value of zero means "new action, not yet used"; as a packet hits the
action, 'firstuse' is stamped with the current jiffies value.

tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.

Fixes: 48d8ee1694dd ("net sched actions: aggregate dumping of actions timeinfo")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/act_api.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b18c699681ca..59d05feecfb8 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -69,7 +69,8 @@ static inline void tcf_tm_dump(struct tcf_t *dtm, const struct tcf_t *stm)
 {
 	dtm->install = jiffies_to_clock_t(jiffies - stm->install);
 	dtm->lastuse = jiffies_to_clock_t(jiffies - stm->lastuse);
-	dtm->firstuse = jiffies_to_clock_t(jiffies - stm->firstuse);
+	dtm->firstuse = stm->firstuse ?
+		jiffies_to_clock_t(jiffies - stm->firstuse) : 0;
 	dtm->expires = jiffies_to_clock_t(stm->expires);
 }
 
-- 
2.25.1

