Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522EE48F36
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfFQTbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:31:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50086 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfFQTbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:31:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 12:31:22 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 17 Jun 2019 12:31:22 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v3 1/6] igb: clear out tstamp after sending the packet.
Date:   Mon, 17 Jun 2019 12:31:05 -0700
Message-Id: <1560799870-18956-2-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->tstamp is being used at multiple places. On the transmit side, it
is used to determine the launchtime of the packet. It is also used to
determine the software timestamp after the packet has been transmitted.

So, clear out the tstamp value after it has been read so that we do not
report false software timestamp on the receive side.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index fc925adbd9fa..f66dae72fe37 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5688,6 +5688,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
 	 */
 	if (tx_ring->launchtime_enable) {
 		ts = ns_to_timespec64(first->skb->tstamp);
+		first->skb->tstamp = 0;
 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->seqnum_seed = 0;
-- 
2.7.3

