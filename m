Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B783447F3FF
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 18:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhLYRM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 12:12:56 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56025 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhLYRMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 12:12:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V.jKjkz_1640452363;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V.jKjkz_1640452363)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Dec 2021 01:12:53 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] netfilter: conntrack: Use max() instead of doing it manually
Date:   Sun, 26 Dec 2021 01:12:41 +0800
Message-Id: <20211225171241.119887-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:

./include/net/netfilter/nf_conntrack.h:282:16-17: WARNING opportunity
for max().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 871489df63c6..a4a14f3a5e38 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -279,7 +279,7 @@ static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
 {
 	s32 timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
 
-	return timeout > 0 ? timeout : 0;
+	return max(timeout, 0);
 }
 
 static inline bool nf_ct_is_expired(const struct nf_conn *ct)
-- 
2.20.1.7.g153144c

