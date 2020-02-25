Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4582516B705
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgBYBJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:09:06 -0500
Received: from gateway34.websitewelcome.com ([192.185.149.72]:34078 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728523AbgBYBJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:09:06 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 768AF25979
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 19:09:04 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6OiejPZyWXVkQ6OiejlB5o; Mon, 24 Feb 2020 19:09:04 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c98g6WeC58NkLgTxbAHyTHrMsSRtYF/+CmdBm9wFx1c=; b=oBmrIz9lcLMYNVxyceXUi64LhN
        R8bn0YkI5rDDRrS/advScUhcNp+BYBkCreXmX/0S4G+jGoBdPwIxm3cR9VMB55ECU1Zt8t/pFwYzj
        wnTS+gDFDxK3HRygcf2W8jZGc1m/99WeWur14UrZ11trJZHygvdSRcfZzYUge9nSEhF9MUuNHxaTC
        mTJuL5Hlcq3iB+Jyn4EJ+2t3HAVyd1ZQUndUfOVAXMt7Sp69zvtnLfR/sFpc7+nlxDMlvEsUSntx8
        TEvBW0idcOql4aAo1KnpVJdPmCVKgAREfEafCLkGTxQhu6QzoDdgDaIzLudK+b7vCEAnL7aCQThOj
        7ygB7Rkg==;
Received: from [201.166.190.254] (port=58460 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Oib-002rNH-ID; Mon, 24 Feb 2020 19:09:01 -0600
Date:   Mon, 24 Feb 2020 19:11:51 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] hostap: Replace zero-length array with flexible-array
 member
Message-ID: <20200225011151.GA30675@embeddedor>
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
X-Source-IP: 201.166.190.254
X-Source-L: No
X-Exim-ID: 1j6Oib-002rNH-ID
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.190.254]:58460
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
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
 drivers/net/wireless/intersil/hostap/hostap_common.h | 2 +-
 drivers/net/wireless/intersil/hostap/hostap_wlan.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_common.h b/drivers/net/wireless/intersil/hostap/hostap_common.h
index 22543538239b..dd29a8e8d349 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_common.h
+++ b/drivers/net/wireless/intersil/hostap/hostap_common.h
@@ -322,7 +322,7 @@ struct prism2_download_param {
 		u32 addr; /* wlan card address */
 		u32 len;
 		void __user *ptr; /* pointer to data in user space */
-	} data[0];
+	} data[];
 };
 
 #define PRISM2_MAX_DOWNLOAD_AREA_LEN 131072
diff --git a/drivers/net/wireless/intersil/hostap/hostap_wlan.h b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
index 487883fbb58c..dd2603d9b5d3 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
@@ -615,7 +615,7 @@ struct prism2_download_data {
 		u32 addr; /* wlan card address */
 		u32 len;
 		u8 *data; /* allocated data */
-	} data[0];
+	} data[];
 };
 
 
-- 
2.25.0

