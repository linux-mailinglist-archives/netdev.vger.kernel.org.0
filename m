Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF376342FE
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiKVRvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiKVRv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:51:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E00B1BAC
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669139289; x=1700675289;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+lZlzOey+N2T5dJ99mloaMy5FtnSTIdVqqdNKRUqnwg=;
  b=JzREktjZofJdKnooRJ0yyih/lRnh6tDPX25k7RZY4OZv915hXca0cRjQ
   YNUkYO0UCEKV5TvFSHsXiiQheNit+ZxxNOceXAUQwGJw4QCPC8iEGwQae
   d1Vzhn5U2YHIkcBlgFchQGDF0TDFxOdX/xaP6FR4706k+FVfX6lTuMQum
   q7DLt6sntKNq3n2i32ahEpOZVgh2asGMBruQKfmMPS1ilYiBw2958CMd0
   wkqAd0btxYaBJsfTijMo+4TJ0wz+q1X+CFY0nLeQkPNnghJv3nnmo1WBG
   KsLKD4Qy8efBjv9KEj1peGYBIW5NCCoEUaVGbkt9BjJFvmpGDy5UyhR6C
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="400165212"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="400165212"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 09:47:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="619301145"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="619301145"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2022 09:47:49 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        edumazet@google.com, pabeni@redhat.com
Subject: [PATCH net 4/4] net: wwan: iosm: fix incorrect skb length
Date:   Tue, 22 Nov 2022 23:17:46 +0530
Message-Id: <20221122174746.3496864-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

skb passed to network layer contains incorrect length.

In mux aggregation protocol, the datagram block received
from device contains block signature, packet & datagram
header. The right skb len to be calculated by subracting
datagram pad len from datagram length.

Whereas in mux lite protocol, the skb contains single
datagram so skb len is calculated by subtracting the
packet offset from datagram header.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index 738420bd14af..16f319dd2804 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -365,7 +365,8 @@ static void ipc_mux_dl_cmd_decode(struct iosm_mux *ipc_mux, struct sk_buff *skb)
 /* Pass the DL packet to the netif layer. */
 static int ipc_mux_net_receive(struct iosm_mux *ipc_mux, int if_id,
 			       struct iosm_wwan *wwan, u32 offset,
-			       u8 service_class, struct sk_buff *skb)
+			       u8 service_class, struct sk_buff *skb,
+			       u32 pkt_len)
 {
 	struct sk_buff *dest_skb = skb_clone(skb, GFP_ATOMIC);

@@ -373,7 +374,7 @@ static int ipc_mux_net_receive(struct iosm_mux *ipc_mux, int if_id,
 		return -ENOMEM;

 	skb_pull(dest_skb, offset);
-	skb_set_tail_pointer(dest_skb, dest_skb->len);
+	skb_trim(dest_skb, pkt_len);
 	/* Pass the packet to the netif layer. */
 	dest_skb->priority = service_class;

@@ -473,7 +474,8 @@ static void ipc_mux_dl_adgh_decode(struct iosm_mux *ipc_mux,

 	/* Pass the packet to the netif layer */
 	rc = ipc_mux_net_receive(ipc_mux, if_id, wwan, packet_offset,
-				 adgh->service_class, skb);
+				 adgh->service_class, skb,
+				 adgh->length - packet_offset);
 	if (rc) {
 		dev_err(ipc_mux->dev, "mux adgh decoding error");
 		return;
@@ -565,8 +567,9 @@ static int mux_dl_process_dg(struct iosm_mux *ipc_mux, struct mux_adbh *adbh,
 			/* Pass the packet to the netif layer. */
 			rc = ipc_mux_net_receive(ipc_mux, if_id, ipc_mux->wwan,
 						 packet_offset,
-						 dg->service_class,
-						 skb);
+						 dg->service_class, skb,
+						 dg->datagram_length -
+						 dl_head_pad_len);
 			if (rc)
 				goto dg_error;
 		}
--
2.34.1

