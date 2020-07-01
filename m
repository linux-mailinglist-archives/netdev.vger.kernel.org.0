Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729AE211619
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgGAWe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:25457 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgGAWe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:26 -0400
IronPort-SDR: LaSgor6DsQchfjKuQF4UBAwyvU2J+S/ak/YRB7s2cBcTW2tPHi3KwFQoYZFldpgtf9x1fXN0OV
 NXIjE8Mxi5+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178600"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: YrMpDwSmN0BIrnLMg9EKFtQ0+x0pxcrGhV9CT8hmvqUIzubnKubzkMiGmuxkNb+5vj/6AZuWAV
 1pZqbOy9MA8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276106"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 03/12] iavf: fix error return code in iavf_init_get_resources()
Date:   Wed,  1 Jul 2020 15:34:03 -0700
Message-Id: <20200701223412.2675606-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 78bd9e3df3ac..b90ad1abbabb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1852,8 +1852,10 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 
 	adapter->rss_key = kzalloc(adapter->rss_key_size, GFP_KERNEL);
 	adapter->rss_lut = kzalloc(adapter->rss_lut_size, GFP_KERNEL);
-	if (!adapter->rss_key || !adapter->rss_lut)
+	if (!adapter->rss_key || !adapter->rss_lut) {
+		err = -ENOMEM;
 		goto err_mem;
+	}
 	if (RSS_AQ(adapter))
 		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
 	else
-- 
2.26.2

