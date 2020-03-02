Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD59B1759E5
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 12:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgCBL7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 06:59:17 -0500
Received: from gateway23.websitewelcome.com ([192.185.49.177]:42314 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbgCBL7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 06:59:16 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 4FD43AC38
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 05:59:13 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8jj7jydA3Efyq8jj7j3DkM; Mon, 02 Mar 2020 05:59:13 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kzUqRBProYnJMl/U55hJEG0fvIDnfxPBZ5ML3y+DSkM=; b=eYGWa4noBm4mb5y8OEjY+SufaR
        07Jf8aAq0TLuzMcMdPkT1DSYPUHKSA1CFiRfkhYy6QK/dKTVePx097lF+5XdhpjX6tnlT+lCiiu2C
        cDVB72xS8EfwXX1+Kmw9g+F+DGXSwZGqjXZ0OTk2lGaCsIuqNkHVIfku7cbfIvUeaxZ+3sRaVJ+Ln
        I5RdqywHznMQYwV7vcp1nkDqzL1EnCF6cmO8G2LH3zynVNWPW5ve4L3BAC8SBQE/wBw2X6d9TL1+y
        V6kRuHZvLLS7eIZaoHL/tGEK8X5fOOYJSfx0/H2wZnAQYm1F7Yc/KYH6NEkq0Cq+Ps/7eH5eO+bxZ
        2dtoezBQ==;
Received: from [201.166.157.105] (port=42214 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8jj4-003q5x-W0; Mon, 02 Mar 2020 05:59:11 -0600
Date:   Mon, 2 Mar 2020 06:02:09 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] drop_monitor: Replace zero-length array with
 flexible-array member
Message-ID: <20200302120209.GA15699@embeddedor>
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
X-Source-IP: 201.166.157.105
X-Source-L: No
X-Exim-ID: 1j8jj4-003q5x-W0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.157.105]:42214
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
 include/uapi/linux/net_dropmon.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 66048cc5d7b3..67e31f329190 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -29,12 +29,12 @@ struct net_dm_config_entry {
 
 struct net_dm_config_msg {
 	__u32 entries;
-	struct net_dm_config_entry options[0];
+	struct net_dm_config_entry options[];
 };
 
 struct net_dm_alert_msg {
 	__u32 entries;
-	struct net_dm_drop_point points[0];
+	struct net_dm_drop_point points[];
 };
 
 struct net_dm_user_msg {
-- 
2.25.0

