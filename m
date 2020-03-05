Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892E917A3D4
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgCELNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:13:20 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:26201 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbgCELNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 06:13:19 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 80A394010522E
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 05:09:12 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 9oNMjLYPWEfyq9oNMjPNJy; Thu, 05 Mar 2020 05:09:12 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P2Op+mBXz77ucWJILHHJw8eByoBg+MewO1F656lbx2E=; b=ji17C/Vaif3YLuwY5Eupaw96C3
        UkR/HtBh0rxG6oqJeCoxCqvqpi8ybYvNhPQZc4u4PspBum9K9otRdwHGpp+z6kQ1uO9p92AV+U9o7
        cw9NCmRgwQgYR6IKYvyO4Pn0kx2NMJLQKHNufslluDwqCrWy57oC1/EufE58QHrSsbRocu4B48Kql
        vv2w6FXCFADmLqKzJGTHjOyf5h6EC1YVaRTCLN7T8DrqS+2XhYCUtytm54y3AwCZv0MZ78p/tN7i3
        OdDZH28+0ahQ1sIeoZbD9r6KcdhTMUJXEzFN69oODHqCrukUWxVQX3K/N+6C4WecmGUZzLpD+tbP8
        M6etCAWw==;
Received: from [201.166.169.220] (port=30902 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j9oNK-003q3G-0k; Thu, 05 Mar 2020 05:09:10 -0600
Date:   Thu, 5 Mar 2020 05:12:16 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
Message-ID: <20200305111216.GA24982@embeddedor>
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
X-Source-IP: 201.166.169.220
X-Source-L: No
X-Exim-ID: 1j9oNK-003q3G-0k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.169.220]:30902
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
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
 drivers/net/wireless/zydas/zd1211rw/zd_usb.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.h b/drivers/net/wireless/zydas/zd1211rw/zd_usb.h
index a52ee323a142..8f03b09a602c 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.h
@@ -69,7 +69,7 @@ enum control_requests {
 
 struct usb_req_read_regs {
 	__le16 id;
-	__le16 addr[0];
+	__le16 addr[];
 } __packed;
 
 struct reg_data {
@@ -79,7 +79,7 @@ struct reg_data {
 
 struct usb_req_write_regs {
 	__le16 id;
-	struct reg_data reg_writes[0];
+	struct reg_data reg_writes[];
 } __packed;
 
 enum {
@@ -95,7 +95,7 @@ struct usb_req_rfwrite {
 	/* 2: other (default) */
 	__le16 bits;
 	/* RF2595: 24 */
-	__le16 bit_values[0];
+	__le16 bit_values[];
 	/* (ZD_CR203 & ~(RF_IF_LE | RF_CLK | RF_DATA)) | (bit ? RF_DATA : 0) */
 } __packed;
 
@@ -118,7 +118,7 @@ struct usb_int_header {
 
 struct usb_int_regs {
 	struct usb_int_header hdr;
-	struct reg_data regs[0];
+	struct reg_data regs[];
 } __packed;
 
 struct usb_int_retry_fail {
-- 
2.25.0

