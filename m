Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5A316B64B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgBYAJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:09:28 -0500
Received: from gateway33.websitewelcome.com ([192.185.146.195]:38731 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728235AbgBYAJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:09:28 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2020 19:09:26 EST
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id ADF6B7175A
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:09:26 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6NmwjJ3AwSl8q6Nmwjy5kU; Mon, 24 Feb 2020 18:09:26 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZwmvXNF0jxPluhfTdIp+OkMhFDGnO6D8vfAw9YlIa3k=; b=JD/Y/mISz9+s6xEcFV8VrUebnA
        GXp81qYIO0zcoyu28r1UkT83FgP+aju1ycUxK/cvS6CYIVP90cCrNqaK1cFMulvC47GW5P0yscOq/
        HU7qUwAULL+2b1mn3E0k6XakzlGx6bfvP6J6w5e4nmLbwrrY17Dq3IDFoR1Y+8AQ9z5VTrYU0p2MS
        7YFfFzYQYNKkfmweNOL+uywgNzcLBMr0pBdadbrRYgozPOvTXTklF75Q05Cumo/mCmOfirpAkpSQ2
        8Seg1Va6u0aZPU0w5lpNRL3DkoZ3ZrrUNFNViG9JhPXdYVESgL8wDtUg4TxIhcgWEpRxNvl/Yhgg2
        IrkC12Zw==;
Received: from [201.166.190.60] (port=54458 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Nmu-002OsC-IZ; Mon, 24 Feb 2020 18:09:25 -0600
Date:   Mon, 24 Feb 2020 18:12:13 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: marvell: Replace zero-length array with
 flexible-array member
Message-ID: <20200225001213.GA20527@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.190.60
X-Source-L: No
X-Exim-ID: 1j6Nmu-002OsC-IZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.190.60]:54458
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 25
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/marvell/skge.h | 2 +-
 drivers/net/ethernet/marvell/sky2.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
index 6fa7b6a34c08..a1313d57e283 100644
--- a/drivers/net/ethernet/marvell/skge.h
+++ b/drivers/net/ethernet/marvell/skge.h
@@ -2426,7 +2426,7 @@ struct skge_hw {
 	spinlock_t	     phy_lock;
 	struct tasklet_struct phy_task;
 
-	char		     irq_name[0]; /* skge@pci:000:04:00.0 */
+	char		     irq_name[]; /* skge@pci:000:04:00.0 */
 };
 
 enum pause_control {
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index b02b6523083c..ada1ca60f088 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2309,7 +2309,7 @@ struct sky2_hw {
 	struct work_struct   restart_work;
 	wait_queue_head_t    msi_wait;
 
-	char		     irq_name[0];
+	char		     irq_name[];
 };
 
 static inline int sky2_is_copper(const struct sky2_hw *hw)
-- 
2.25.0

