Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119E251DED0
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389234AbiEFSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 14:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiEFSQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 14:16:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477C06E8C7;
        Fri,  6 May 2022 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651860795; x=1683396795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOvOqax6KOhlpH/LmdNBTgNA3C4NJmTJTccfO13GOaY=;
  b=aIQcONpeOPJuz1yc5STMLx08weGs0JOX6YbSL6CWrfxpdrcrVqO07A+X
   SbTanYItdWftGGIZbpfMi6WqysrN0Med90DL7+7sRP1RcvkzZeeCBRC7e
   wnieWpfV8+sWvpjpDMBKWFuHeGDpvNyJqYZT+pXYD9niUK9uJWzg+BGND
   XzBDwYqa1QmzhB5pgh3BsyTY783+VDQolUSMmsCEjpEjVIA5vKNrPJ7/G
   0LBjP+OAzOZsovaZnup2F4wVQgsTt6GEX7sFpACrXWmUbDsdiujyJyc0o
   wnS+780W8awUI5VXooWyhqYpof2IyM1DKR+z7ieSxpLtnSLW7+CKGj6uQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="267379018"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="267379018"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:13:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="621931043"
Received: from jpankrat-mobl.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.209.104.156])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:13:13 -0700
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
Subject: [PATCH net-next v8 01/14] list: Add list_next_entry_circular() and list_prev_entry_circular()
Date:   Fri,  6 May 2022 11:12:57 -0700
Message-Id: <20220506181310.2183829-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.25.1

