Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208CF175A10
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgCBMKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:10:08 -0500
Received: from gateway31.websitewelcome.com ([192.185.143.234]:12368 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgCBMKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:10:07 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 754CA23CBEC
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 06:10:06 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8jtejXn3DAGTX8jtejgDUG; Mon, 02 Mar 2020 06:10:06 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SI9L7t5+PJPUj9nJSrkM4IY5Y4jla0GxFqwLN6bviuM=; b=c5+T4h6ffuTf0aWn7ux1BWA2Yr
        hXkYlM9AjdbBIi5V8XZ/z7/oJTlLFZD3hICBaLLQxSZsxdNO2l2p9fTi6H/tkYjDOVu27Vb1N3PVG
        rR/bFcR6cy/wJSWeRqkqD/6hzBKvr6B4R/ri4yqKX6FDWzDi1IeijJ0ZEW3y3RkCU6S6+STp3nxzk
        oLWU6DHq5LzuRD38CkYfEPOR8XA8iH8FsVTSkU4ThnNUsYHSilhei9giFG+PueTQHtpbXUaISmIf+
        9wJrUdx5mzYFXYPT0RE6/tYIOi5shFMXPYpxwaRf+Nx8ZmJgGHjxNEy78a2JYwmBtaH4acM0wTp0R
        AzhRR0Ew==;
Received: from [201.166.157.38] (port=42262 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8jrV-003wUT-JF; Mon, 02 Mar 2020 06:07:54 -0600
Date:   Mon, 2 Mar 2020 06:10:51 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] bna: bnad: Replace zero-length array with
 flexible-array member
Message-ID: <20200302121051.GA28820@embeddedor>
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
X-Source-IP: 201.166.157.38
X-Source-L: No
X-Exim-ID: 1j8jrV-003wUT-JF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.157.38]:42262
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
 drivers/net/ethernet/brocade/bna/bnad.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.h b/drivers/net/ethernet/brocade/bna/bnad.h
index 492a02d54f14..bfa58b40dc3f 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.h
+++ b/drivers/net/ethernet/brocade/bna/bnad.h
@@ -253,7 +253,7 @@ struct bnad_rx_unmap_q {
 	int			alloc_order;
 	u32			map_size;
 	enum bnad_rxbuf_type	type;
-	struct bnad_rx_unmap	unmap[0] ____cacheline_aligned;
+	struct bnad_rx_unmap	unmap[] ____cacheline_aligned;
 };
 
 #define BNAD_PCI_DEV_IS_CAT2(_bnad) \
-- 
2.25.0

