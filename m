Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F56196BC3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbfHTVuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:50:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:28768 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730982AbfHTVux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330531"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 11/14] ice: Increase size of Mailbox receive queue for many VFs
Date:   Tue, 20 Aug 2019 14:50:45 -0700
Message-Id: <20190820215048.14377-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we use the ICE_MBXQ_LEN for both the Mailbox send and receive
queues that are used to communicate with VFs. This is fine for the send
queue because the PF driver will lock the queue for every single send,
but for the Mailbox receive queue every VF is posting to its Mailbox
send queue and the hardware is then handing the message to the PF on its
Mailbox receive queue. This becomes a problem with many VFs because it
seems to overburden the Mailbox receive queue on the PF. Fix this by
increasing the Mailbox receive queue for the PF to 512 entries.

The number 512 was determined based on the number of VFs supported by
the device. We can have a total of 256 VFs so in the worst case this
allows the VFs to put 2 messages in the PFs Mailbox receive queue at the
same time.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 3 ++-
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bde0b3617d9b..b60e64c0036b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -69,7 +69,8 @@ extern const char ice_drv_ver[];
 #define ICE_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
 #define ICE_ETHTOOL_FWVER_LEN	32
 #define ICE_AQ_LEN		64
-#define ICE_MBXQ_LEN		64
+#define ICE_MBXSQ_LEN		64
+#define ICE_MBXRQ_LEN		512
 #define ICE_MIN_MSIX		2
 #define ICE_NO_VSI		0xffff
 #define ICE_MAX_TXQS		2048
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7805c2abd4ac..a0d148f590c2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1507,8 +1507,8 @@ static void ice_set_ctrlq_len(struct ice_hw *hw)
 	hw->adminq.num_sq_entries = ICE_AQ_LEN;
 	hw->adminq.rq_buf_size = ICE_AQ_MAX_BUF_LEN;
 	hw->adminq.sq_buf_size = ICE_AQ_MAX_BUF_LEN;
-	hw->mailboxq.num_rq_entries = ICE_MBXQ_LEN;
-	hw->mailboxq.num_sq_entries = ICE_MBXQ_LEN;
+	hw->mailboxq.num_rq_entries = ICE_MBXRQ_LEN;
+	hw->mailboxq.num_sq_entries = ICE_MBXSQ_LEN;
 	hw->mailboxq.rq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
 	hw->mailboxq.sq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
 }
-- 
2.21.0

