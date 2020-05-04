Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9C1C4895
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEDUwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:52:44 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.218]:19917 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727952AbgEDUwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:52:44 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id BB7E5B33558
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:04:17 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id VhK5jQLYaEfyqVhK5jEJUf; Mon, 04 May 2020 15:04:17 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V96LBizxl4+aEJIjzbcrRlhTjAqahm2dmV9MAZqHdGc=; b=L4JqgH+UVyVZV2P7eUgtXNCiOR
        SNVfuSkG3J1W6yEXdAOSzu/7iJk37Nx6f+qmfoVr4NvirPvSMFnOuYtCT6axHGIB5OTK3Ftq6h1uF
        F5epi927ICta8GvCWztD9SikDgk3pzeFCuu8m2P0Tgkp0oLPw0XbuCOP4fGF4NpEj8p4f/8mtQrjK
        qxOvr9wynLQWlBrk1XRabwH7QlqyrymSub0l/rfky81DJZmckWhRkLHXJDEGs8ulU17h29TcecsVx
        w2sRFbfjDqKtCjvHWYCsLFwN7IGezLXe7m3vfZ+Uu8DNTglqtORFixXudBRWvC206UmCzjVTiDThS
        //HscYMg==;
Received: from [189.207.59.248] (port=58762 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jVhK3-002Fbe-9W; Mon, 04 May 2020 15:04:15 -0500
Date:   Mon, 4 May 2020 15:08:38 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ath6kl: Replace zero-length array with flexible-array
Message-ID: <20200504200838.GA31974@embeddedor>
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
X-Source-IP: 189.207.59.248
X-Source-L: No
X-Exim-ID: 1jVhK3-002Fbe-9W
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.207.59.248]:58762
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
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

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  | 4 ++--
 drivers/net/wireless/ath/ath6kl/debug.c | 2 +-
 drivers/net/wireless/ath/ath6kl/hif.h   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 0d30e762c090..77e052336eb5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -160,7 +160,7 @@ enum ath6kl_fw_capability {
 struct ath6kl_fw_ie {
 	__le32 id;
 	__le32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum ath6kl_hw_flags {
@@ -406,7 +406,7 @@ struct ath6kl_mgmt_buff {
 	u32 id;
 	bool no_cck;
 	size_t len;
-	u8 buf[0];
+	u8 buf[];
 };
 
 struct ath6kl_sta {
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 54337d60f288..7506cea46f58 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -30,7 +30,7 @@ struct ath6kl_fwlog_slot {
 	__le32 length;
 
 	/* max ATH6KL_FWLOG_PAYLOAD_SIZE bytes */
-	u8 payload[0];
+	u8 payload[];
 };
 
 #define ATH6KL_FWLOG_MAX_ENTRIES 20
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index dc6bd8cd9b83..aea7fea2a81e 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -199,7 +199,7 @@ struct hif_scatter_req {
 
 	u32 scat_q_depth;
 
-	struct hif_scatter_item scat_list[0];
+	struct hif_scatter_item scat_list[];
 };
 
 struct ath6kl_irq_proc_registers {
-- 
2.26.2

