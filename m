Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C588A161C30
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgBQUQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:16:09 -0500
Received: from gateway34.websitewelcome.com ([192.185.148.214]:16120 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729334AbgBQUQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:16:09 -0500
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 15:16:08 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 77A8848645
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 13:55:36 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3mUSjoDBaRP4z3mUSjEp98; Mon, 17 Feb 2020 13:55:36 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=crsZaVbHNmz9iNAH8JjIvtOy8euRMhiayEMBT2tKPSA=; b=rNPCQnyoGNxrnnhTyp1ahn8zhf
        Fl6T1a8oHvVIdwFb4MkmEDJDTOpGcxPI3NsgLLtu+lwnbvJ/9mCYT1kBZ7rD2Rfm6pM8DHmkc2HX/
        ffYzv/JaQKCKt4//9bSAuOQM9IrId4qWzgUT+PGBrFeNfdv4c5QHWxFR+WT/DE4BgC4ErlhHqYwFZ
        cxKsOCeFrLAK8hC8QUdu170I46KcFfddFaSl76R122Cq/xU49oliP3yBT2iH07pq3ktvIL7c8BAec
        QoOYasX33PJgk1g2S244DK3NKewDmtRx2SHSHFzZmPcQx1Q1bCoQzIeZma7o31mVxJcqLn3OIEIQY
        7mSu22lg==;
Received: from [200.68.140.26] (port=23204 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3mUQ-000LJn-QK; Mon, 17 Feb 2020 13:55:34 -0600
Date:   Mon, 17 Feb 2020 13:58:16 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: usb: cdc-phonet: Replace zero-length array
 with flexible-array member
Message-ID: <20200217195816.GA3306@embeddedor>
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
X-Exim-ID: 1j3mUQ-000LJn-QK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:23204
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
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
 drivers/net/usb/cdc-phonet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index bcabd39d136a..9bdbd7b472a0 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -36,7 +36,7 @@ struct usbpn_dev {
 
 	spinlock_t		rx_lock;
 	struct sk_buff		*rx_skb;
-	struct urb		*urbs[0];
+	struct urb		*urbs[];
 };
 
 static void tx_complete(struct urb *req);
-- 
2.25.0

