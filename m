Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B946918C34F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgCSWvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:51:36 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.196]:26611 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727138AbgCSWvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:51:36 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id E992C2D0F
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:51:35 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id F40ljl6YZAGTXF40ljB2VG; Thu, 19 Mar 2020 17:51:35 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3GUe41RpPlWxlU4UBdpwU27X24kKmhrLlmW78YqosvU=; b=PotKNb+ojypKAQcTZXqn6if3jp
        Srm3U3QXP+I2eCm3vRPlhyNZvf+iMxuwAbk8RNsE/azcr+xZ4O2g3wyazkYL5U7ufaSPXnwxmTdtR
        JDqNhHWzZxzBw9Y3D2YbDLbenraJDPcPfg9DXxtWbUSx8/xa8UtGsBiMOclsqHxfGrTsdYjQ9DiC3
        5xFy1289MlR6RdXR4hL9jY291Kan/s7WO+xylOcX1JJjiV/bv9q3vnr1x0Y32AWtyv9Lq3o0keQKM
        tx8WI2gC5VtMPenvh5fVDfjqLnk8SzoMbiYe0HBI7+LRgVfc34WjXzlbfNVQB78md2Duj2oHc3any
        hiyLBVZQ==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:54002 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jF40k-002HVt-1I; Thu, 19 Mar 2020 17:51:34 -0500
Date:   Thu, 19 Mar 2020 17:51:33 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] atmel: at76c50x-usb.h: Replace zero-length array with
 flexible-array member
Message-ID: <20200319225133.GA29672@embeddedor.com>
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
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jF40k-002HVt-1I
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:54002
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 53
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
 drivers/net/wireless/atmel/at76c50x-usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.h b/drivers/net/wireless/atmel/at76c50x-usb.h
index f56863403b05..746e64dfd8aa 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.h
+++ b/drivers/net/wireless/atmel/at76c50x-usb.h
@@ -151,7 +151,7 @@ struct at76_command {
 	u8 cmd;
 	u8 reserved;
 	__le16 size;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /* Length of Atmel-specific Rx header before 802.11 frame */
-- 
2.23.0

