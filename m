Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4FC4F8B17
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiDGWjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiDGWjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:39:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1816129253;
        Thu,  7 Apr 2022 15:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649371031; x=1680907031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=MHiLlcSaMnahwidQH1EnOY42tA4Hy/pUqwVnkznAwCQ=;
  b=XpScJ68zD77lDwQqT0+MZZg/tjOVIs7gv1jLfKfttlGOjARdkW5ma4yl
   vAPswn3706MVASev0pusto34EH8Y6NLAtvHiv13HP3yoK5SJPNzBAt8NN
   4wCorJvhhkQ8xDGkNgf47SCSs3Bg7ht0LqrTju3zGyR6hl1aQcGMYT8iq
   IZeNgFDk4rPQmLk1tjr2qB0J6okktcgmS45/2lJBfClPnxmcWGWvs08yb
   IYZJFlV8hSYNA6g++NfV8Ps3gfXdBFPW5HQWxTKsrWfGIuluSKZiDFpy/
   qme3dXLbdHfnu5ctByQDfr31aJIsWXuXGJtLiT1JYGc0xL12r+vmCDahh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261449303"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="261449303"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:37:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="659242870"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:37:11 -0700
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
Subject: [PATCH net-next v6 01/13] list: Add list_next_entry_circular() and list_prev_entry_circular()
Date:   Thu,  7 Apr 2022 15:36:17 -0700
Message-Id: <20220407223629.21487-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
index d7d2bfa1a365..c36e3b9a651b 100644
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

