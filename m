Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96804C1E8B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244051AbiBWWfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243645AbiBWWfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:35:37 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860921C106;
        Wed, 23 Feb 2022 14:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645655708; x=1677191708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=l44v8W5Bft9bSBP2aodKJZT3sd0EJtHNMPrJkziyrr4=;
  b=gvzttfJ5gJ0nFv89wH3WUl8r5itmUjYeJWAC3Eehn55uqlZu5fKS0Rwy
   YTjL9kCy0gsFCDrIbf1zNQZ9dHq6khdPXs1mVHXHQ8h1v9P0x7XB7P8/V
   90aa1jaP5kLUrT4SIWVrFH+F2SdftbjgjVuzyAoYUDEf6C2hPRFFFtUvB
   OzHsQdPGVsJnhcEXH8ckhy6UzXdnYU5x3xUTtUCRt1rh8DL6wmBJBweJ7
   i4B2UMdOcsqZcxpuPsX78HA+KiY7EwANgEKFdSf0H0/Rc9YMpAAG3Fovs
   GDPUUoMFtgATFo4LNatiOQZB476n4nty5VOb2U7XK/wvtOkt3veCfVeju
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="312812421"
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="312812421"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:35:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="628252220"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:35:06 -0800
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
Subject: [PATCH net-next v5 01/13] list: Add list_next_entry_circular() and list_prev_entry_circular()
Date:   Wed, 23 Feb 2022 15:33:14 -0700
Message-Id: <20220223223326.28021-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
2.17.1

