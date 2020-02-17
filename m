Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC49161BE8
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 20:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgBQTv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 14:51:56 -0500
Received: from gateway36.websitewelcome.com ([192.185.200.11]:31228 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729129AbgBQTv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 14:51:56 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 8A56C40FA075C
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 13:06:14 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3mQsjiJOP8vkB3mQsjfGpX; Mon, 17 Feb 2020 13:51:54 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fs6PYRX24xfRohVEXUr8oWq2yWMbC09iZHVjQRC+Gwo=; b=PLnsB5f6nrXVqy94cZgjLGOLoQ
        EN3T8hGVFqNQU0nxwTRyHD+UOqojMqN9wzdy2kN++YxRJ6os4xaXXarsN/IHVuWlY6zZaaWOpK15S
        J4EE5Wz8Fzsxa6xdO1p0P8n3e2kho+UMnYH8DBSBQZMHRPLchAYvbSOPJFZk6SgSYs5chnR6PUBBu
        UQ3bypf8pVK05RPJAtjlmAa5jk2+ZZWvqFFaUGLuwvsljc8Q2SfFb0EMFVqiAnQQNrRnkf1Qi8VU2
        bCkdG4Vv7IEbQ6cFkFE+kpNIbO3jIkSLaCpRkmUeHGY8ruS79w9f/umSizvq1wqQv/vfLOJyQT13C
        O4f4+e3g==;
Received: from [200.68.140.26] (port=27288 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3mQr-000JUr-20; Mon, 17 Feb 2020 13:51:53 -0600
Date:   Mon, 17 Feb 2020 13:54:34 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net/mlx5: IPsec, Replace zero-length array with
 flexible-array member
Message-ID: <20200217195434.GA1166@embeddedor>
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
X-Exim-ID: 1j3mQr-000JUr-20
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:27288
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
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
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 4c61d25d2e88..b794888fa3ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -57,7 +57,7 @@ struct mlx5_fpga_ipsec_cmd_context {
 	struct completion complete;
 	struct mlx5_fpga_device *dev;
 	struct list_head list; /* Item in pending_cmds */
-	u8 command[0];
+	u8 command[];
 };
 
 struct mlx5_fpga_esp_xfrm;
-- 
2.25.0

