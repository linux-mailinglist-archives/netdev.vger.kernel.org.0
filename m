Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4116B6AE
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgBYA14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:27:56 -0500
Received: from gateway33.websitewelcome.com ([192.185.145.23]:13242 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728087AbgBYA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:27:55 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id E210C135D2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:04:00 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6NhgjhSRLRP4z6Nhgj6Znb; Mon, 24 Feb 2020 18:04:00 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q67V6wkz/vP58iDZWoblidrn9lVnubX/pXsOU2x0CG0=; b=xjMuCcfDK2IR1n0XjWR9lmhBDv
        42BFoVIxSRVzKvH836FTURQOhCmJtGhYH/r5hHyXOuzILas2/BCeCkMw+nLzPnCgOH6f47dFqxCnP
        4komlYZTAvGklfkzV7OPVXrB15ou3eGQGOtga65+8wR8O/OjiZjYJ5H0YLY2cqnIgNbI2qD4i2H1H
        Q9hGdi8lpTi8V8JTCfoxOyZLpsBKVExitmnr+x75I4PPz0M1QdbdjPkNYJLFvAOVN9JkSdlfwgkSV
        JiRSsZ3Sg3G0wLiDkDQswEP+zI3mufPkEE7QGomr13FvlkUHYKUENi2VWwAh/vYk6ZnY8uHE+r1B1
        yqMpge3g==;
Received: from [201.166.190.71] (port=54310 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Nhe-002MWf-3D; Mon, 24 Feb 2020 18:03:59 -0600
Date:   Mon, 24 Feb 2020 18:06:47 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] sfc: Replace zero-length array with flexible-array
 member
Message-ID: <20200225000647.GA17795@embeddedor>
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
X-Source-IP: 201.166.190.71
X-Source-L: No
X-Exim-ID: 1j6Nhe-002MWf-3D
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.190.71]:54310
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 15
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
 drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
 drivers/net/ethernet/sfc/net_driver.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a49ea2e719b6..a529ff395ead 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -288,7 +288,7 @@ struct ef4_rx_buffer {
 struct ef4_rx_page_state {
 	dma_addr_t dma_addr;
 
-	unsigned int __pad[0] ____cacheline_aligned;
+	unsigned int __pad[] ____cacheline_aligned;
 };
 
 /**
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9f9886f222c8..392bd5b7017e 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -336,7 +336,7 @@ struct efx_rx_buffer {
 struct efx_rx_page_state {
 	dma_addr_t dma_addr;
 
-	unsigned int __pad[0] ____cacheline_aligned;
+	unsigned int __pad[] ____cacheline_aligned;
 };
 
 /**
-- 
2.25.0

