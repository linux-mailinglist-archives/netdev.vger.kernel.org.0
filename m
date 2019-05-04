Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F34713C4A
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfEDXtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:49:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:20569 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbfEDXtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:49:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994680"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: Use more efficient structures
Date:   Sat,  4 May 2019 16:49:28 -0700
Message-Id: <20190504234929.3005-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Move a bunch of members around to make more efficient use of
memory, eliminating holes where possible. None of these members
are hot path so cache line alignment is not very important here.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index 0038a4109c99..e0585394d984 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -79,6 +79,7 @@ struct ice_rq_event_info {
 /* Control Queue information */
 struct ice_ctl_q_info {
 	enum ice_ctl_q qtype;
+	enum ice_aq_err rq_last_status;	/* last status on receive queue */
 	struct ice_ctl_q_ring rq;	/* receive queue */
 	struct ice_ctl_q_ring sq;	/* send queue */
 	u32 sq_cmd_timeout;		/* send queue cmd write back timeout */
@@ -86,10 +87,9 @@ struct ice_ctl_q_info {
 	u16 num_sq_entries;		/* send queue depth */
 	u16 rq_buf_size;		/* receive queue buffer size */
 	u16 sq_buf_size;		/* send queue buffer size */
+	enum ice_aq_err sq_last_status;	/* last status on send queue */
 	struct mutex sq_lock;		/* Send queue lock */
 	struct mutex rq_lock;		/* Receive queue lock */
-	enum ice_aq_err sq_last_status;	/* last status on send queue */
-	enum ice_aq_err rq_last_status;	/* last status on receive queue */
 };
 
 #endif /* _ICE_CONTROLQ_H_ */
-- 
2.20.1

