Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EF6480F35
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbhL2DVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:21:51 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:37550 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231775AbhL2DVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:21:51 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowAB3fAAv1MthVhA+BQ--.4374S2;
        Wed, 29 Dec 2021 11:21:20 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     sam@mendozajonas.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net/ncsi: check for error return from call to nla_put_u32
Date:   Wed, 29 Dec 2021 11:21:18 +0800
Message-Id: <20211229032118.1706294-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAB3fAAv1MthVhA+BQ--.4374S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy7try5Jw18WrWrWF15urg_yoW8JF47pr
        W8KF93tw4kJ3y0grykA3W8urW5ZrsrXrW3Cryagw4rZFn5X3WqvF9rZFZaqr1fCrWvqw1x
        Ar4jqr1Y9Fs0ya7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r48
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUj8uctUUUU
        U==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we can see from the comment of the nla_put() that it could return
-EMSGSIZE if the tailroom of the skb is insufficient.
Therefore, it should be better to check the return value of the
nla_put_u32 and return the error code if error accurs.
Also, there are many other functions have the same problem, and if this
patch is correct, I will commit a new version to fix all.

Fixes: 955dc68cb9b2 ("net/ncsi: Add generic netlink family")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/ncsi/ncsi-netlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index bb5f1650f11c..c189b4c8a182 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -112,7 +112,11 @@ static int ncsi_write_package_info(struct sk_buff *skb,
 		pnest = nla_nest_start_noflag(skb, NCSI_PKG_ATTR);
 		if (!pnest)
 			return -ENOMEM;
-		nla_put_u32(skb, NCSI_PKG_ATTR_ID, np->id);
+		rc = nla_put_u32(skb, NCSI_PKG_ATTR_ID, np->id);
+		if (rc) {
+			nla_nest_cancel(skb, pnest);
+			return rc;
+		}
 		if ((0x1 << np->id) == ndp->package_whitelist)
 			nla_put_flag(skb, NCSI_PKG_ATTR_FORCED);
 		cnest = nla_nest_start_noflag(skb, NCSI_PKG_ATTR_CHANNEL_LIST);
-- 
2.25.1

