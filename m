Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD66F48E1EA
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbiANBGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:06:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:27438 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238606AbiANBGy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122414; x=1673658414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=uzozva/1N7/m+s2dpT0GzhJ+v8U7T1UsbKU59h0M1wQ=;
  b=JUTGHnHoiGaRA7OG5rgnGctI8sASKHB2kESPQ/gFy+/wq/N/jeCwrW6G
   VeJs+Ux1Qc0Jp4jxKbKzTY3LaEYVmg3cZAVRvOw4dfkd8x3dNGhwWS7qk
   h/ji/ayh4whb1z0uMSR7qhFXMqHFyS8e7cZ/Z+/a7P9J6OV8DzraxJn/0
   udbXyvYjuF4107Fs8SiKMoVOdTYbz2qnkL9pxd9oFlfehk0L75A7imAu+
   FQBwMD4xV8SsKAajC0MbVX/txTAYdw2AoM7xIkf6jb2crYzNgs5xwyTFu
   8DVR0Cnw5e2SYWiwY8jsfPeeckQp/BnvYI2T4gH11dxF8q0Q4f6Iuio+u
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="242970846"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="242970846"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014184"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:52 -0800
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
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v4 01/13] list: Add list_next_entry_circular() and list_prev_entry_circular()
Date:   Thu, 13 Jan 2022 18:06:15 -0700
Message-Id: <20220114010627.21104-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to get the next or previous entries and wraparound if
needed. For example, calling list_next_entry_circular() on the last
element should return the first element in the list.

Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
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

