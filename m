Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047521CEC30
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 06:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgELEwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 00:52:03 -0400
Received: from mo-csw-fb1514.securemx.jp ([210.130.202.170]:40796 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgELEwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 00:52:03 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2020 00:52:02 EDT
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1514) id 04C4iF5O024609; Tue, 12 May 2020 13:44:15 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 04C4i5Jc015176; Tue, 12 May 2020 13:44:05 +0900
X-Iguazu-Qid: 34trJzXMW4Zrve7CWg
X-Iguazu-QSIG: v=2; s=0; t=1589258645; q=34trJzXMW4Zrve7CWg; m=Yw9vRq7HtTeBSs7yyuQQOX8SwRDmXNQJ75QIYgWJHeo=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1510) id 04C4i3A3033009;
        Tue, 12 May 2020 13:44:04 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 04C4i3I6023533;
        Tue, 12 May 2020 13:44:03 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 04C4i39S023080;
        Tue, 12 May 2020 13:44:03 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     daniel.sangorrin@toshiba.co.jp,
        Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC] e1000e: Relax condition to trigger reset for ME workaround
Date:   Tue, 12 May 2020 13:43:47 +0900
X-TSB-HOP: ON
Message-Id: <20200512044347.3810257-1-punit1.agrawal@toshiba.co.jp>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's an error if the value of the RX/TX tail descriptor does not match
what was written. The error condition is true regardless the duration
of the interference from ME. But the code only performs the reset if
E1000_ICH_FWSM_PCIM2PCI_COUNT (2000) iterations of 50us delay have
transpired. The extra condition can lead to inconsistency between the
state of hardware as expected by the driver.

Fix this by dropping the check for number of delay iterations.

Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Hi,

The issue was noticed through code inspection while backporting the
workaround for TDT corruption. Sending it out as an RFC as I am not
familiar with the hardware internals of the e1000e.

Another unresolved question is the inherent racy nature of the
workaround - the ME could block access again after releasing the
device (i.e., BIT(E1000_ICH_FWSM_PCIM2PCI) clear) but before the
driver performs the write. Has this not been a problem?

Any feedback on the patch or the more information on the issues
appreciated.

Thanks,
Punit

 drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 177c6da80c57..5ed4d7ed35b3 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -607,11 +607,11 @@ static void e1000e_update_rdt_wa(struct e1000_ring *rx_ring, unsigned int i)
 {
 	struct e1000_adapter *adapter = rx_ring->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
 
+	__ew32_prepare(hw);
 	writel(i, rx_ring->tail);
 
-	if (unlikely(!ret_val && (i != readl(rx_ring->tail)))) {
+	if (unlikely(i != readl(rx_ring->tail))) {
 		u32 rctl = er32(RCTL);
 
 		ew32(RCTL, rctl & ~E1000_RCTL_EN);
@@ -624,11 +624,11 @@ static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
 {
 	struct e1000_adapter *adapter = tx_ring->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
 
+	__ew32_prepare(hw);
 	writel(i, tx_ring->tail);
 
-	if (unlikely(!ret_val && (i != readl(tx_ring->tail)))) {
+	if (unlikely(i != readl(tx_ring->tail))) {
 		u32 tctl = er32(TCTL);
 
 		ew32(TCTL, tctl & ~E1000_TCTL_EN);
-- 
2.26.2

