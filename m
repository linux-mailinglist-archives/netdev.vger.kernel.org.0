Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0074F607694
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJUL4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJUL4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:56:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DA5263964;
        Fri, 21 Oct 2022 04:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666353390; x=1697889390;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Rtll0/nGhqW301uS5yfdR9R0zXk9od1cA+YGVzH/vYA=;
  b=nbDCEMIUyrpr7IwTriwxi2GG3V1yrfAV2H8ITQ47fIwv17waLH0XzhPt
   xoWEYk9migK/zxJ1IVq1xzNp6VyZIiZ1nsQGfIGZofCXcEs18FZSYppGy
   /7Z5cDkPFjdBfsdvh813ony9wpEZSTPt6J8fSeskAkFIpaSEH9ffwxgpT
   l2bZIohdckV3AxUCzJ8ZWdqURP/e7U7IrEwyvqX3Mpbr0hLCrM7kxjlLu
   9/DCXbcnSIZ8PNyjX2OQIFfnFCrJOaCTYRcbgYchQxVCD83OWe8KjCyDy
   EPc7LVFF613ukw/FrglpAxbwqacLNVXbeTicejdmFtyZwwCUucFbpZTJf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="393286599"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="393286599"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 04:56:28 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="632891119"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="632891119"
Received: from junxiaochang.bj.intel.com ([10.238.135.52])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 04:56:25 -0700
From:   Junxiao Chang <junxiao.chang@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        Joao.Pinto@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     junxiao.chang@intel.com
Subject: [PATCH net-next 1/2] net: stmmac: fix unsafe MTL DMA macro
Date:   Fri, 21 Oct 2022 19:47:10 +0800
Message-Id: <20221021114711.1610797-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Macro like "#define abc(x) (x, x)" is unsafe which might introduce
side effects. Each MTL RxQ DMA channel mask is 4 bits, so using
(0xf << chan) instead of GENMASK(x + 3, x) to avoid unsafe macro.

Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 71dad409f78b0..3c1490408a1c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -333,7 +333,7 @@ enum power_event {
 #define MTL_RXQ_DMA_MAP1		0x00000c34 /* queue 4 to 7 */
 #define MTL_RXQ_DMA_Q04MDMACH_MASK	GENMASK(3, 0)
 #define MTL_RXQ_DMA_Q04MDMACH(x)	((x) << 0)
-#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	GENMASK(11 + (8 * ((x) - 1)), 8 * (x))
+#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	(0xf << 8 * (x))
 #define MTL_RXQ_DMA_QXMDMACH(chan, q)	((chan) << (8 * (q)))
 
 #define MTL_CHAN_BASE_ADDR		0x00000d00
-- 
2.25.1

