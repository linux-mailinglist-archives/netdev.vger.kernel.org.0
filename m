Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425F84EDD0
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfFUR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:28:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:30241 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbfFUR2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 13:28:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 10:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="171282959"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga002.jf.intel.com with ESMTP; 21 Jun 2019 10:28:48 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v5 1/7] igb: clear out skb->tstamp after reading the txtime
Date:   Fri, 21 Jun 2019 10:28:22 -0700
Message-Id: <1561138108-12943-2-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1561138108-12943-1-git-send-email-vedang.patel@intel.com>
References: <1561138108-12943-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a packet which is utilizing the launchtime feature (via SO_TXTIME socket
option) also requests the hardware transmit timestamp, the hardware
timestamp is not delivered to the userspace. This is because the value in
skb->tstamp is mistaken as the software timestamp.

Applications, like ptp4l, request a hardware timestamp by setting the
SOF_TIMESTAMPING_TX_HARDWARE socket option. Whenever a new timestamp is
detected by the driver (this work is done in igb_ptp_tx_work() which calls
igb_ptp_tx_hwtstamps() in igb_ptp.c[1]), it will queue the timestamp in the
ERR_QUEUE for the userspace to read. When the userspace is ready, it will
issue a recvmsg() call to collect this timestamp.  The problem is in this
recvmsg() call. If the skb->tstamp is not cleared out, it will be
interpreted as a software timestamp and the hardware tx timestamp will not
be successfully sent to the userspace. Look at skb_is_swtx_tstamp() and the
callee function __sock_recv_timestamp() in net/socket.c for more details.

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

