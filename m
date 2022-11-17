Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237B662E860
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiKQWZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiKQWZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:25:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC282223
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668723899; x=1700259899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+8N8UJYFMgC6lZZbxYIhTmrbq33ONaW2XhrzXOeCa3k=;
  b=nHBYZuxPWnkEOf9gyxCjEDxrLO/HpzHdsgxe+6eScOw9KVMJWHaFh/VS
   nJsWVx2xrJZE7fEzF24Knhb+GJf7dAHlNb2m5nrGYCUaRZ+AamddJlFyZ
   BOOshTVteqbod/l1iUtZYcSfXMHQNRtiImzxnhlsk3bJMpchGyzsm1/ep
   oFtPqMRFLMFMbXgGs+0bp9v7KgAE+CWy+omVmvj9IUzFrAY/shHUbOOOO
   d1Thdhml6BIxGQNU4V46W3cSnFngSp9Zf+mXq3+xmM9MkrZmdtvt8BBsE
   CR0J034L1XnY8mmWHe7Hwt8FIajETyS3c+ekxFowNBbsSWkaU+4V/fi0d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339826322"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339826322"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="885055459"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="885055459"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2022 14:24:58 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next 1/5] ch_ktls: Use kmap_local_page() instead of kmap_atomic()
Date:   Thu, 17 Nov 2022 14:25:53 -0800
Message-Id: <20221117222557.2196195-2-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is being deprecated in favor of kmap_local_page().
Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
and kunmap_local() respectively.

Note that kmap_atomic() disables preemption and page-fault processing,
but kmap_local_page() doesn't. Converting the former to the latter is safe
only if there isn't an implicit dependency on preemption and page-fault
handling being disabled, which does appear to be the case here.

Also note that the page being mapped is not allocated by the driver,
and so the driver doesn't know if the page is in normal memory. This is the
reason kmap_local_page() is used as opposed to page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index da9973b..d95f230 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1853,24 +1853,24 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 				i++;
 			}
 			f = &record->frags[i];
-			vaddr = kmap_atomic(skb_frag_page(f));
+			vaddr = kmap_local_page(skb_frag_page(f));
 
 			data = vaddr + skb_frag_off(f)  + remaining;
 			frag_delta = skb_frag_size(f) - remaining;
 
 			if (frag_delta >= prior_data_len) {
 				memcpy(prior_data, data, prior_data_len);
-				kunmap_atomic(vaddr);
+				kunmap_local(vaddr);
 			} else {
 				memcpy(prior_data, data, frag_delta);
-				kunmap_atomic(vaddr);
+				kunmap_local(vaddr);
 				/* get the next page */
 				f = &record->frags[i + 1];
-				vaddr = kmap_atomic(skb_frag_page(f));
+				vaddr = kmap_local_page(skb_frag_page(f));
 				data = vaddr + skb_frag_off(f);
 				memcpy(prior_data + frag_delta,
 				       data, (prior_data_len - frag_delta));
-				kunmap_atomic(vaddr);
+				kunmap_local(vaddr);
 			}
 			/* reset tcp_seq as per the prior_data_required len */
 			tcp_seq -= prior_data_len;
-- 
2.37.2

