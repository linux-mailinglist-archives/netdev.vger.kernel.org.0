Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFEB175A3A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgCBMQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:16:56 -0500
Received: from gateway32.websitewelcome.com ([192.185.145.189]:27822 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgCBMQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:16:56 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id BA880CE8287
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 06:16:54 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8k0EjML7A8vkB8k0EjGb9T; Mon, 02 Mar 2020 06:16:54 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fBy+Bpjwg2IJmA+ROxW4TGZvoEbOMzciybHMAJdbmcg=; b=egbht0p08ibDUtG9LAjkpuTbVi
        W0JNlqOPxlQ3qPvefoYZ6hXsWfn9gUInQabyIn7gd5BjKqMtkknthIDQTpt01L+gkdGibAze4p+qW
        p/sO91s9sx+DMmnRwSuVuXXil5A66kozf74jybzWVbZzLmEFihXiZetkKrgmJtL5+ArEUCeCV2HXA
        iIP/asWNjEllVQMOXCRH4EM8RxN+up1461zNm96c1przRKu5+eK5qQC26RDw9LlvROEVWEt7K0J3b
        bHV7D7XjRlIRxDuX740KlD3pqAjgyzOl/b/+6IK1f9bjZdtNk5bNSmZcWvMrQwmE/jQIE3oVOhDaZ
        izqFsQtg==;
Received: from [201.166.157.90] (port=42544 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8k0C-004457-Si; Mon, 02 Mar 2020 06:16:53 -0600
Date:   Mon, 2 Mar 2020 06:19:53 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: atlantic: Replace zero-length array with
 flexible-array member
Message-ID: <20200302121953.GA32574@embeddedor>
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
X-Source-IP: 201.166.157.90
X-Source-L: No
X-Exim-ID: 1j8k0C-004457-Si
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.157.90]:42544
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 24
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
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 42f0c5c6ec2d..6b4f701e7006 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -225,7 +225,7 @@ struct __packed offload_info {
 	struct offload_port_info ports;
 	struct offload_ka_info kas;
 	struct offload_rr_info rrs;
-	u8 buf[0];
+	u8 buf[];
 };
 
 struct __packed hw_atl_utils_fw_rpc {
-- 
2.25.0

