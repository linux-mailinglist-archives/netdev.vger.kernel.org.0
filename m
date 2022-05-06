Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3443151CE76
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387836AbiEFBUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387829AbiEFBUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:20:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E39947AE8;
        Thu,  5 May 2022 18:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651799802; x=1683335802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOvOqax6KOhlpH/LmdNBTgNA3C4NJmTJTccfO13GOaY=;
  b=GuZw5ODTlGBT194W5xaKU9/HivXmG1l456PCAFIrXmzu288XF4KAfjqz
   bFBQExTWnfD2QVTJPJ+llQNbxoQ41NvdisKzuV1yyGPn+kNC3/QVV31pe
   i1pWMh2vSTGK3VR6zq0Db0RtT3YSxA5i5lcmvVYgGLzS0yrNv7DoYbXAJ
   zbFl0qZCNV3DxOZcAxy0LcadkxSgRVyn+uimMdWupIJy0lmmEMQaewh+p
   DIRU0leWa2X8ag29FjMFagXsLOC25zHapwk2veDow2tjb6t2J4bXkn8PD
   bMCuXDcxYr4TSXtsWwf/u3nWBNoLUZH4ytMTBJQgUh3PGbU9gMwl7wz2/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="265902433"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="265902433"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:16:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="654482419"
Received: from kdjohns3-mobl1.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.212.250.65])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:16:41 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v7 01/14] list: Add list_next_entry_circular() and list_prev_entry_circular()
Date:   Thu,  5 May 2022 18:16:03 -0700
Message-Id: <20220506011616.1774805-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com>
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to get the next or previous entries and wraparound if
needed. For example, calling list_next_entry_circular() on the last
element should return the first element in the list.

Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/list.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index dd6c2041d09c..c147eeb2d39d 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -563,6 +563,19 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_next_entry(pos, member) \
 	list_entry((pos)->member.next, typeof(*(pos)), member)
 
+/**
+ * list_next_entry_circular - get the next element in list
+ * @pos:	the type * to cursor.
+ * @head:	the list head to take the element from.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Wraparound if pos is the last element (return the first element).
+ * Note, that list is expected to be not empty.
+ */
+#define list_next_entry_circular(pos, head, member) \
+	(list_is_last(&(pos)->member, head) ? \
+	list_first_entry(head, typeof(*(pos)), member) : list_next_entry(pos, member))
+
 /**
  * list_prev_entry - get the prev element in list
  * @pos:	the type * to cursor
@@ -571,6 +584,19 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_prev_entry(pos, member) \
 	list_entry((pos)->member.prev, typeof(*(pos)), member)
 
+/**
+ * list_prev_entry_circular - get the prev element in list
+ * @pos:	the type * to cursor.
+ * @head:	the list head to take the element from.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Wraparound if pos is the first element (return the last element).
+ * Note, that list is expected to be not empty.
+ */
+#define list_prev_entry_circular(pos, head, member) \
+	(list_is_first(&(pos)->member, head) ? \
+	list_last_entry(head, typeof(*(pos)), member) : list_prev_entry(pos, member))
+
 /**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
-- 
2.25.1

