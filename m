Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9BF170A4E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 22:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgBZVUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 16:20:30 -0500
Received: from gateway30.websitewelcome.com ([192.185.196.18]:21971 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbgBZVU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 16:20:29 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id E30CE36EB
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 15:20:27 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 746VjFuQEXVkQ746Vjb7hG; Wed, 26 Feb 2020 15:20:27 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u27AWESU6IBnunkwxt/DOyNrqsBFUtPolFnlbLmyax0=; b=hWN5RsL2079aQWubVBv8qBN4wE
        eW+GIP42AvfEqYGxZj4MaTWSYHq+AaLEcwe5WZQOs451KliadxqfypJUZOhVYIiti6Ux4Y2FBIPDS
        wRBfndyWfD2WJWZu4VsEK3Ib6LWmjtsCqC/bYjLBTsd48qdnrERuT48kqMvMQd5MnHQoqeLT1KF7T
        vZXNHdICj2VdH/zn6DSS0//BcwoXfs0tvIxCv7VkZ6/xvKUhr3CS8N7Zbk0oMZQhvIVDVF46k336C
        W0twgwTyeQ0cxyVgpk87sUua6UJJplRxMB/Cv5COLxRbxJW9TgIeg1eGvLlhcgM7MY9vktzWLYrWw
        u+Dwikhg==;
Received: from [201.162.161.146] (port=47662 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j746T-000m4L-0m; Wed, 26 Feb 2020 15:20:25 -0600
Date:   Wed, 26 Feb 2020 15:23:17 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kevin Curtis <kevin.curtis@farsite.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] WAN: Replace zero-length array with flexible-array
 member
Message-ID: <20200226212317.GA2172@embeddedor>
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
X-Source-IP: 201.162.161.146
X-Source-L: No
X-Exim-ID: 1j746T-000m4L-0m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.161.146]:47662
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
 drivers/net/wan/farsync.h | 2 +-
 drivers/net/wan/wanxl.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/farsync.h b/drivers/net/wan/farsync.h
index 47b8e36f97ab..5f43568a9715 100644
--- a/drivers/net/wan/farsync.h
+++ b/drivers/net/wan/farsync.h
@@ -65,7 +65,7 @@
 struct fstioc_write {
         unsigned int  size;
         unsigned int  offset;
-        unsigned char data[0];
+	unsigned char data[];
 };
 
 
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 23f93f1c815d..499f7cd19a4a 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -78,7 +78,7 @@ struct card {
 	struct sk_buff *rx_skbs[RX_QUEUE_LENGTH];
 	struct card_status *status;	/* shared between host and card */
 	dma_addr_t status_address;
-	struct port ports[0];	/* 1 - 4 port structures follow */
+	struct port ports[];	/* 1 - 4 port structures follow */
 };
 
 
-- 
2.25.0

