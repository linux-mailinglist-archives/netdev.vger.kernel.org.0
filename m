Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F0D636B98
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiKWUvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbiKWUvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D886BDEF
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236673; x=1700772673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rku8K/zbqyxv7f8xBYQxiUKCL1JyGcni5iPCSqysSfI=;
  b=aA9lm0UQlCodPXXCZUEgQx+5l60K1TC6yItfAGy28BhWlNFNMex8LKJq
   BlUz+KmNwDyxodAl19eTaoHwGeGUOHQvPwvCur+VBkgP8YMoMD6tMbCA4
   m6AubwO6vXNVbpvwA1ILbugBKfsUbo0rcw5+IIAOhIOLrodCl43mNRzEp
   0s1vPX+G4PhUHLvr9pqIPjVQFUwNzmO/Gy57ekgf7PnIRDwkXGgdopukU
   zyyF385K5eZ0Lqw55g9umxtrKcS5mhA6BuVSYvfoAn33XudUYYW+/gMGV
   m8LNaf2bL+SN0bMXuh8hu93ANG+CSJEPhsTYeC/mXlxWxbTzpxsGeCzYT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862665"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862665"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947690"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947690"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:12 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH v2 net-next 1/6] ch_ktls: Use memcpy_from_page() instead of k[un]map_atomic()
Date:   Wed, 23 Nov 2022 12:52:14 -0800
Message-Id: <20221123205219.31748-2-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
the map-memcpy-unmap usage pattern (done using k[un]map_atomic()) with
memcpy_from_page(), which internally uses kmap_local_page() and
kunmap_local(). This renders the variables 'data' and 'vaddr' unnecessary,
and so remove these too.

Note that kmap_atomic() disables preemption and page-fault processing, but
kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
to check if the code being executed between the map/unmap implicitly
depends on page-faults and/or preemption being disabled. If yes, then code
to disable page-faults and/or preemption should also be added for
functional correctness. That however doesn't appear to be the case here,
so just memcpy_from_page() is used.

Also note that the page being mapped is not allocated by the driver, and so
the driver doesn't know if the page is in normal memory. This is the reason
kmap_local_page() is used (via memcpy_from_page()) as opposed to
page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
v1 -> v2:
 Use memcpy_from_page() as suggested by Fabio
 Add a "Suggested-by" tag
 Rework commit message
 Some emails cc'd in v1 are defunct. Drop them. The MAINTAINERS file for
 Chelsio drivers likely needs an update
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 26 +++++++++----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index da9973b..1a5fdd7 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1839,9 +1839,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (prior_data_len) {
 			int i = 0;
-			u8 *data = NULL;
 			skb_frag_t *f;
-			u8 *vaddr;
 			int frag_size = 0, frag_delta = 0;
 
 			while (remaining > 0) {
@@ -1853,24 +1851,24 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 				i++;
 			}
 			f = &record->frags[i];
-			vaddr = kmap_atomic(skb_frag_page(f));
-
-			data = vaddr + skb_frag_off(f)  + remaining;
 			frag_delta = skb_frag_size(f) - remaining;
 
 			if (frag_delta >= prior_data_len) {
-				memcpy(prior_data, data, prior_data_len);
-				kunmap_atomic(vaddr);
+				memcpy_from_page(prior_data, skb_frag_page(f),
+						 skb_frag_off(f) + remaining,
+						 prior_data_len);
 			} else {
-				memcpy(prior_data, data, frag_delta);
-				kunmap_atomic(vaddr);
+				memcpy_from_page(prior_data, skb_frag_page(f),
+						 skb_frag_off(f) + remaining,
+						 frag_delta);
+
 				/* get the next page */
 				f = &record->frags[i + 1];
-				vaddr = kmap_atomic(skb_frag_page(f));
-				data = vaddr + skb_frag_off(f);
-				memcpy(prior_data + frag_delta,
-				       data, (prior_data_len - frag_delta));
-				kunmap_atomic(vaddr);
+
+				memcpy_from_page(prior_data + frag_delta,
+						 skb_frag_page(f),
+						 skb_frag_off(f),
+						 prior_data_len - frag_delta);
 			}
 			/* reset tcp_seq as per the prior_data_required len */
 			tcp_seq -= prior_data_len;
-- 
2.37.2

