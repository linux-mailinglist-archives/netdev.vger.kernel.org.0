Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580D716B63E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgBYAGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:06:53 -0500
Received: from gateway30.websitewelcome.com ([192.185.196.18]:16613 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727976AbgBYAGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:06:53 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 95DC7FDE5
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:06:52 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6NkSjn3wUAGTX6NkSjwj2g; Mon, 24 Feb 2020 18:06:52 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W2nVCBOC3RQtFd1bJm8Y55rMfod2dkAr8hWnPOcjNNM=; b=C/ezcuvREGquXC4mgNW/H88+ug
        TVAa6onqkKTEYBN++tieBb1vLd2PnxxGpJ99XXjMhkF3X5vm3yFh+dX31VyJS4lN0jNOp8h8BWxKO
        q9EhUxG3KUKxBWkkCy7Q88JqK0vy8o5Q8Xxn/1qhrxnSP80grhsxxAYOBBL0I6q6NzKSGQrH8hFEA
        0LfXdZIgDC4fV+88I9t5k0KJXM+zYMDi1GnGYqMQlJU6zPeVuqemnXl7DSfa7osY2LhJuvY5TOHP6
        0tbshf9NfwsYuh7Ks/fAYtdqwRhI+1hm7Q63aemirVaCFA0ytK48jW68iC397zTuMZSu+VZyND0De
        5+WkfkSg==;
Received: from [201.166.190.177] (port=54400 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6NkQ-002Nmd-0p; Mon, 24 Feb 2020 18:06:51 -0600
Date:   Mon, 24 Feb 2020 18:09:39 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: hns: Replace zero-length array with
 flexible-array member
Message-ID: <20200225000939.GA18897@embeddedor>
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
X-Source-IP: 201.166.190.177
X-Source-L: No
X-Exim-ID: 1j6NkQ-002Nmd-0p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.190.177]:54400
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 20
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
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.h | 2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.h b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.h
index 2721f1f1ab42..0f0e16f9afc0 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.h
@@ -92,7 +92,7 @@ struct ppe_common_cb {
 	u8 comm_index;   /*ppe_common index*/
 
 	u32 ppe_num;
-	struct hns_ppe_cb ppe_cb[0];
+	struct hns_ppe_cb ppe_cb[];
 
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.h b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.h
index 3741befb914e..a9f805925699 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.h
@@ -108,7 +108,7 @@ struct rcb_common_cb {
 	u32 ring_num;
 	u32 desc_num; /*  desc num per queue*/
 
-	struct ring_pair_cb ring_pair_cb[0];
+	struct ring_pair_cb ring_pair_cb[];
 };
 
 int hns_rcb_buf_size2type(u32 buf_size);
-- 
2.25.0

