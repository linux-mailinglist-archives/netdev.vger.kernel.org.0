Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2700616B718
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgBYBRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:17:23 -0500
Received: from gateway30.websitewelcome.com ([192.185.196.18]:47403 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727378AbgBYBRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:17:22 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 0897C3CA4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 19:17:21 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6OqfjjMxJvBMd6OqfjfVfV; Mon, 24 Feb 2020 19:17:21 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8PuKkfXcmVyx3upImaxoOPndGOZW+wA+Sy4Sih/Rb3U=; b=fNVAqJz/DRQv+OOERZb352EIG2
        c41NMqpOz2CQ44CATBGzKrFbwtNxw1WK6PZewR66YgVClYxFBgohbKBIE1fRdHE+rsGdmmM8sI6Cx
        uqlTZGaE3XJWFq4+c39PBtxKOmaHDa/YQpyj1CAY7dapnHIXmrncAuu4MaHxh3RLNi9XYR609Pz+B
        6UHaC3Ak3feP3RO/Uqdv2d0kJgjdtu05UYAZUONpbbfLSjQqwvcRg7YZkaTMK00txwHpSh5oBEUTZ
        VboH0gquje3vTf8J4TjcGVHlVdazQsUQPRY5bt0Hp9VlstlgWNYGiK3U/S9drUzHSO47/axkGoPYn
        YsIED7HQ==;
Received: from [201.166.191.50] (port=58608 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Oqd-002v0R-6d; Mon, 24 Feb 2020 19:17:19 -0600
Date:   Mon, 24 Feb 2020 19:20:08 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] prism54: Replace zero-length array with flexible-array
 member
Message-ID: <20200225012008.GA4309@embeddedor>
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
X-Source-IP: 201.166.191.50
X-Source-L: No
X-Exim-ID: 1j6Oqd-002v0R-6d
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.50]:58608
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 28
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
 drivers/net/wireless/intersil/prism54/isl_oid.h    | 8 ++++----
 drivers/net/wireless/intersil/prism54/islpci_mgt.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intersil/prism54/isl_oid.h b/drivers/net/wireless/intersil/prism54/isl_oid.h
index 5441c1f9f2fc..1afc2ccf94ca 100644
--- a/drivers/net/wireless/intersil/prism54/isl_oid.h
+++ b/drivers/net/wireless/intersil/prism54/isl_oid.h
@@ -37,7 +37,7 @@ struct obj_mlmeex {
 	u16 state;
 	u16 code;
 	u16 size;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct obj_buffer {
@@ -68,12 +68,12 @@ struct obj_bss {
 
 struct obj_bsslist {
 	u32 nr;
-	struct obj_bss bsslist[0];
+	struct obj_bss bsslist[];
 } __packed;
 
 struct obj_frequencies {
 	u16 nr;
-	u16 mhz[0];
+	u16 mhz[];
 } __packed;
 
 struct obj_attachment {
@@ -81,7 +81,7 @@ struct obj_attachment {
 	char reserved;
 	short id;
 	short size;
-	char data[0];
+	char data[];
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/intersil/prism54/islpci_mgt.h b/drivers/net/wireless/intersil/prism54/islpci_mgt.h
index d6bbbac46b4a..1f87d0aea60c 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_mgt.h
+++ b/drivers/net/wireless/intersil/prism54/islpci_mgt.h
@@ -99,7 +99,7 @@ struct islpci_mgmtframe {
 	pimfor_header_t *header;      /* payload header, points into buf */
 	void *data;		      /* payload ex header, points into buf */
         struct work_struct ws;	      /* argument for schedule_work() */
-	char buf[0];		      /* fragment buffer */
+	char buf[];		      /* fragment buffer */
 };
 
 int
-- 
2.25.0

