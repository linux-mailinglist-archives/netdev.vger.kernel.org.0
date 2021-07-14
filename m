Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA93C7FA6
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 09:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhGNIA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:00:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:50798 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238343AbhGNIA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 04:00:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="271416418"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="271416418"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 00:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="505139965"
Received: from npg-dpdk-haiyue-1.sh.intel.com ([10.67.118.197])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jul 2021 00:57:56 -0700
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     netdev@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>, Kuo Zhao <kuozhao@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] gve: fix the wrong AdminQ buffer overflow check
Date:   Wed, 14 Jul 2021 15:34:59 +0800
Message-Id: <20210714073501.133736-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'tail' pointer is also free-running count, so it needs to be masked
as 'adminq_prod_cnt' does, to become an index value of AdminQ buffer.

Fixes: 5cdad90de62c ("gve: Batch AQ commands for creating and destroying queues.")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 5bb56b454541..f089d33dd48e 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -322,7 +322,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
 
 	// Check if next command will overflow the buffer.
-	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+	    (tail & priv->adminq_mask)) {
 		int err;
 
 		// Flush existing commands to make room.
@@ -332,7 +333,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 
 		// Retry.
 		tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
-		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+		    (tail & priv->adminq_mask)) {
 			// This should never happen. We just flushed the
 			// command queue so there should be enough space.
 			return -ENOMEM;
-- 
2.32.0

