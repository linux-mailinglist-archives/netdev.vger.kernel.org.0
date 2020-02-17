Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB6D161C54
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgBQUeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:34:09 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.133]:37011 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgBQUeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:34:09 -0500
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 15:34:08 EST
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id A04FF400C863E
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:09:49 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3miDjuGNWAGTX3miDj5Q7u; Mon, 17 Feb 2020 14:09:49 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vHceqN2sfu9/dun1wAVisIIuaP0oWbPTBe15FV0Ep7k=; b=Sy87GQ6f+8H2i0L06NBJWgrn++
        rUw2BwxRHTrbMJC/ri+w3KZGetwhbP+bqzS8J3KZuync1nQ9jUNxWzlbN5j28m4B9HRzwHJwbaKhw
        443xGyx6HnAGZiLt66hahset5y/AfSUPxiE4ELEvMlDUdSbU5MLZPV6klhQ4wsCL+Ygf2fB4qTv1J
        I4oq+mlOgjCNw8HjEOdZ836EIaMyGJ1KgllIZ9SpLBR17b2zjo+u9nzbQ64qRZd7RXpp8Fgqxx3wH
        R2ZQ9kUibgw3qxmOSz3jHp4jT+LhK5nCjoVUE/PItMBHjhIRQFOM4eXyltvVNtCTae5HYgB3FvICn
        wdzlEClQ==;
Received: from [200.68.140.26] (port=7630 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3miC-000TtM-3r; Mon, 17 Feb 2020 14:09:48 -0600
Date:   Mon, 17 Feb 2020 14:12:29 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] can: peak_canfd: replace zero-length array with
 flexible-array member
Message-ID: <20200217201229.GA9608@embeddedor>
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
X-Source-IP: 200.68.140.26
X-Source-L: No
X-Exim-ID: 1j3miC-000TtM-3r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:7630
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 18
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
 drivers/net/can/peak_canfd/peak_pciefd_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/peak_canfd/peak_pciefd_main.c b/drivers/net/can/peak_canfd/peak_pciefd_main.c
index d08a3d559114..6ad83a881039 100644
--- a/drivers/net/can/peak_canfd/peak_pciefd_main.c
+++ b/drivers/net/can/peak_canfd/peak_pciefd_main.c
@@ -146,7 +146,7 @@ struct pciefd_rx_dma {
 	__le32 irq_status;
 	__le32 sys_time_low;
 	__le32 sys_time_high;
-	struct pucan_rx_msg msg[0];
+	struct pucan_rx_msg msg[];
 } __packed __aligned(4);
 
 /* Tx Link record */
@@ -194,7 +194,7 @@ struct pciefd_board {
 	struct pci_dev *pci_dev;
 	int can_count;
 	spinlock_t cmd_lock;		/* 64-bits cmds must be atomic */
-	struct pciefd_can *can[0];	/* array of network devices */
+	struct pciefd_can *can[];	/* array of network devices */
 };
 
 /* supported device ids. */
-- 
2.25.0

