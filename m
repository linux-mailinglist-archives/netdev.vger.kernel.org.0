Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAB63769F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiKXKix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiKXKiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:38:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B158E7A358
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669286323; x=1700822323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vQ6M/ScGrWch18nOti3VGyscZr0HjS0AnqiKYC+E4Yg=;
  b=TkZLlu0ALT9dutS/yxTqPLVhDPmy4PzRdMPQ4HuAs2Che8+9QM++dm18
   dP5XmwmjSrF9JAaxgxSnliTXV0XPSTYfo5RFAGDD6HT6cAR/wxIHT/pWd
   GoOi5ryr1xlxgv6tdTDf8N2uzx/YsMMVGrU5FzrskNy300TSWejrHJ6S7
   rPOMuMh42HKICp5qQ1wPlC13p2oC7IdWHGuusSBVFt6lL0jbwVfIXb57S
   eqBWgxfnglOY7CpNG1QeklSnf961LmeVmg2tdiZJUcSgmjzSlJJiTbsMG
   rv3nVIMM/LoXk3nVNS/IWgbIuzPFrJ6mhPCAYcUnTxL4+XbTP4LAo9dxW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293978751"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="293978751"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 02:38:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619980173"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="619980173"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2022 02:38:39 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com, M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH v2 net 4/4] net: wwan: iosm: fix incorrect skb length
Date:   Thu, 24 Nov 2022 16:08:32 +0530
Message-Id: <20221124103832.1446026-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
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
--
v2: fix sparse warnings.
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index 738420bd14af..d6b166fc5c0e 100644
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
 
@@ -429,7 +430,7 @@ static void ipc_mux_dl_fcth_decode(struct iosm_mux *ipc_mux,
 static void ipc_mux_dl_adgh_decode(struct iosm_mux *ipc_mux,
 				   struct sk_buff *skb)
 {
-	u32 pad_len, packet_offset;
+	u32 pad_len, packet_offset, adgh_len;
 	struct iosm_wwan *wwan;
 	struct mux_adgh *adgh;
 	u8 *block = skb->data;
@@ -470,10 +471,12 @@ static void ipc_mux_dl_adgh_decode(struct iosm_mux *ipc_mux,
 	packet_offset = sizeof(*adgh) + pad_len;
 
 	if_id += ipc_mux->wwan_q_offset;
+	adgh_len = le16_to_cpu(adgh->length);
 
 	/* Pass the packet to the netif layer */
 	rc = ipc_mux_net_receive(ipc_mux, if_id, wwan, packet_offset,
-				 adgh->service_class, skb);
+				 adgh->service_class, skb,
+				 adgh_len - packet_offset);
 	if (rc) {
 		dev_err(ipc_mux->dev, "mux adgh decoding error");
 		return;
@@ -547,7 +550,7 @@ static int mux_dl_process_dg(struct iosm_mux *ipc_mux, struct mux_adbh *adbh,
 			     int if_id, int nr_of_dg)
 {
 	u32 dl_head_pad_len = ipc_mux->session[if_id].dl_head_pad_len;
-	u32 packet_offset, i, rc;
+	u32 packet_offset, i, rc, dg_len;
 
 	for (i = 0; i < nr_of_dg; i++, dg++) {
 		if (le32_to_cpu(dg->datagram_index)
@@ -562,11 +565,12 @@ static int mux_dl_process_dg(struct iosm_mux *ipc_mux, struct mux_adbh *adbh,
 			packet_offset =
 				le32_to_cpu(dg->datagram_index) +
 				dl_head_pad_len;
+			dg_len = le16_to_cpu(dg->datagram_length);
 			/* Pass the packet to the netif layer. */
 			rc = ipc_mux_net_receive(ipc_mux, if_id, ipc_mux->wwan,
 						 packet_offset,
-						 dg->service_class,
-						 skb);
+						 dg->service_class, skb,
+						 dg_len - dl_head_pad_len);
 			if (rc)
 				goto dg_error;
 		}
-- 
2.34.1

