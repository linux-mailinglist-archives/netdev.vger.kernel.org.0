Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250473CCAA1
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 22:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhGRUlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 16:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhGRUlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 16:41:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B166C061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 13:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Edba7aw1oE6EidqArVZWfy3/i6yHPWy2u1GNWU9/eSw=; b=a2xrdZE8hb4tJ5/YqNwQnNmu/p
        5i051VzLtDeIx7boZuMd8ApUlw4vH3BedCC9FQ7uJv8iN5RlP9rrVh5y+eylD2aucDw1EX1Gch3Cl
        RVqUg4yseZwb8JGwLRXNbHg19R5G+BoLn0jUKboqAMdKiyWNTvgZeIoxGs1cAjNdIpCcbdXrWD9CT
        W9OzlE/J4ViqCs2cvXzLJFwZ7kNFXmLJmhLbHT8FAPRNw21qz5clHH+J79eYJunGKViky9zGwSkf6
        GXNFOJDPtd1muHOwSzTRdChcHCsw3q8mQInBr240vJKcW7MysxMIs5hlwdtUaK5LvFK4Lnq8Ttve0
        mVxOCkug==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5DYZ-0080Rq-0k; Sun, 18 Jul 2021 20:38:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition
Date:   Sun, 18 Jul 2021 13:38:34 -0700
Message-Id: <20210718203834.11297-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building on ARCH=arc causes a "redefined" warning, so rename this
driver's CACHE_LINE_MASK to avoid the warning.

../drivers/net/ethernet/hisilicon/hip04_eth.c:134: warning: "CACHE_LINE_MASK" redefined
  134 | #define CACHE_LINE_MASK   0x3F
In file included from ../include/linux/cache.h:6,
                 from ../include/linux/printk.h:9,
                 from ../include/linux/kernel.h:19,
                 from ../include/linux/list.h:9,
                 from ../include/linux/module.h:12,
                 from ../drivers/net/ethernet/hisilicon/hip04_eth.c:7:
../arch/arc/include/asm/cache.h:17: note: this is the location of the previous definition
   17 | #define CACHE_LINE_MASK  (~(L1_CACHE_BYTES - 1))

Fixes: d413779cdd93 ("net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20210716.orig/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ linux-next-20210716/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -131,7 +131,7 @@
 /* buf unit size is cache_line_size, which is 64, so the shift is 6 */
 #define PPE_BUF_SIZE_SHIFT		6
 #define PPE_TX_BUF_HOLD			BIT(31)
-#define CACHE_LINE_MASK			0x3F
+#define SOC_CACHE_LINE_MASK		0x3F
 #else
 #define PPE_CFG_QOS_VMID_GRP_SHIFT	8
 #define PPE_CFG_RX_CTRL_ALIGN_SHIFT	11
@@ -531,8 +531,8 @@ hip04_mac_start_xmit(struct sk_buff *skb
 #if defined(CONFIG_HI13X1_GMAC)
 	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV
 		| TX_RELEASE_TO_PPE | priv->port << TX_POOL_SHIFT);
-	desc->data_offset = (__force u32)cpu_to_be32(phys & CACHE_LINE_MASK);
-	desc->send_addr =  (__force u32)cpu_to_be32(phys & ~CACHE_LINE_MASK);
+	desc->data_offset = (__force u32)cpu_to_be32(phys & SOC_CACHE_LINE_MASK);
+	desc->send_addr =  (__force u32)cpu_to_be32(phys & ~SOC_CACHE_LINE_MASK);
 #else
 	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV);
 	desc->send_addr = (__force u32)cpu_to_be32(phys);
