Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57BE2309EA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfEaIPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfEaIPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:10 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/13] iavf: iavf_client: use struct_size() helper
Date:   Fri, 31 May 2019 01:15:09 -0700
Message-Id: <20190531081518.16430-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

size = sizeof(struct foo) + count * sizeof(struct boo);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

size = struct_size(instance, entry, count);

This code was detected with the help of Coccinelle.

Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_client.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
index aea45364fd1c..ab9db7e9f09d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
@@ -451,7 +451,7 @@ static int iavf_client_setup_qvlist(struct i40e_info *ldev,
 	struct i40e_qv_info *qv_info;
 	iavf_status err;
 	u32 v_idx, i;
-	u32 msg_size;
+	size_t msg_size;
 
 	if (adapter->aq_required)
 		return -EAGAIN;
@@ -469,9 +469,8 @@ static int iavf_client_setup_qvlist(struct i40e_info *ldev,
 	}
 
 	v_qvlist_info = (struct virtchnl_iwarp_qvlist_info *)qvlist_info;
-	msg_size = sizeof(struct virtchnl_iwarp_qvlist_info) +
-			(sizeof(struct virtchnl_iwarp_qv_info) *
-			(v_qvlist_info->num_vectors - 1));
+	msg_size = struct_size(v_qvlist_info, qv_info,
+			       v_qvlist_info->num_vectors - 1);
 
 	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP);
 	err = iavf_aq_send_msg_to_pf(&adapter->hw,
-- 
2.21.0

