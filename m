Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190E3A0B36
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfH1UVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:21:17 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.120]:49618 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfH1UVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:21:13 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8D48C80C2
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 15:21:12 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 34RLivszS2PzO34RMitiMo; Wed, 28 Aug 2019 15:21:12 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0KlKtoMMdaSnIE0WBzv6BhEcDym6e8VWs0NWf0HUHbg=; b=vxvra40vSdMu5ik/ySD8sWqhKq
        rP0yAf+7hhM8msx/83BKnyZGaOg8cLOaSjoiBJFoO+3mMkUwz+13eooev2b+oSKOetYTGV6spS6NF
        Lb9g8UJLalconxJCmd+QPReGB33RTUkxS8Nw7XmoGVK7ZXJ37GPdv+a0RNgyzE4Jw2rd5RvO1mzud
        UvCbZ4zJpt0cJSUQxaQn5iPCXMUllALTGXrCuXADbtPUV7FbXsb2f/7IDsL617Wc4Ff83h0W82CAY
        /yCsRG6OVgrhL4x/J45ZObcCJJ/fxCTHogVVhefrWByDBvegGqAFsD/mQJcpzf9NNilwsk26eHwJj
        a8K3Qa6Q==;
Received: from [189.152.216.116] (port=48342 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1i34RK-001jwb-JM; Wed, 28 Aug 2019 15:21:10 -0500
Date:   Wed, 28 Aug 2019 15:21:08 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] net: spider_net: Use struct_size() helper
Message-ID: <20190828202108.GA9494@embeddedor>
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
X-Source-IP: 189.152.216.116
X-Source-L: No
X-Exim-ID: 1i34RK-001jwb-JM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.152.216.116]:48342
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct spider_net_card {
	...
        struct spider_net_descr darray[0];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

So, replace the following form:

sizeof(struct spider_net_card) + (tx_descriptors + rx_descriptors) * sizeof(struct spider_net_descr)

with:

struct_size(card, darray, tx_descriptors + rx_descriptors)

Notice that, in this case, variable alloc_size is not necessary, hence it
is removed.

Building: allmodconfig powerpc.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/toshiba/spider_net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 0f346761a2b2..538e70810d3d 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2311,11 +2311,9 @@ spider_net_alloc_card(void)
 {
 	struct net_device *netdev;
 	struct spider_net_card *card;
-	size_t alloc_size;
 
-	alloc_size = sizeof(struct spider_net_card) +
-	   (tx_descriptors + rx_descriptors) * sizeof(struct spider_net_descr);
-	netdev = alloc_etherdev(alloc_size);
+	netdev = alloc_etherdev(struct_size(card, darray,
+					    tx_descriptors + rx_descriptors));
 	if (!netdev)
 		return NULL;
 
-- 
2.23.0

