Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D44C47C797
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241837AbhLUTjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:39:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46810 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbhLUTjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:39:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16BECB81990;
        Tue, 21 Dec 2021 19:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62828C36AEA;
        Tue, 21 Dec 2021 19:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640115588;
        bh=wRRFAUwQWksyjwTR4qA4+DrhT6T2cP/utpnaRghH37c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3TbihOgQMBsKPbw22G8Qpn+olIzOlxx31zDblcZum4j3m/fYirRsmpShmLOcH2jw
         OvVXAmDnaNVzHxdVjn0KaXWkPKwY31WGfKlWygRJrB16tOOab3rr5JgFUjUtBxrMla
         o67uAPYhVSI0CMqWAIapqtCxQuI+OxSIULSkA7xn2XHUiafqvloX6VHwI7q0rR52Cb
         F0G5/5oOiW4QWg4jMvOg4iH7RAVdVjr3Ao/m/6tKjPfDgbeOgMXyxoU6NdfYlugbjj
         NSrtoQg09lC9WGxkHt1fM0jzaeTzafwV8rZL0D3T6ThByaSx4ZICUKoBR6IJdDLL1h
         xvtAwdyIUYZuA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kvalo@kernel.org, luciano.coelho@intel.com, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH net-next 2/2] codel: remove unnecessary pkt_sched.h include
Date:   Tue, 21 Dec 2021 11:39:41 -0800
Message-Id: <20211221193941.3805147-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221193941.3805147-1-kuba@kernel.org>
References: <20211221193941.3805147-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d068ca2ae2e6 ("codel: split into multiple files") moved all
Qdisc-related code to codel_qdisc.h, move the include of pkt_sched.h
as well.

This is similar to the previous commit, although we don't care as
much about incremental builds after pkt_sched.h was touched itself
it is included by net/sch_generic.h which is modified ~20 times
a year.

This decreases the incremental build size after touching pkt_sched.h
from 1592 to 617 objects.

Fix unmasked missing includes in WiFi drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kvalo@kernel.org
CC: luciano.coelho@intel.com
CC: nbd@nbd.name
CC: lorenzo.bianconi83@gmail.com
CC: ryder.lee@mediatek.com
CC: shayne.chen@mediatek.com
CC: sean.wang@mediatek.com
CC: johannes.berg@intel.com
CC: emmanuel.grumbach@intel.com
CC: ath11k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath11k/reg.c               | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c | 1 +
 drivers/net/wireless/mediatek/mt76/testmode.h       | 2 ++
 include/net/codel.h                                 | 1 -
 include/net/codel_qdisc.h                           | 2 ++
 6 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 1f8a81987187..d6575feca5a2 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -2,6 +2,8 @@
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
  */
+#include <linux/rtnetlink.h>
+
 #include "core.h"
 #include "debug.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f12e571d3581..a3324c30af90 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
 #include <linux/vmalloc.h>
 #include <net/mac80211.h>
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c b/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
index f702ad85e609..78450366312b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
@@ -4,6 +4,7 @@
  */
 #include "mvm.h"
 #include <linux/nl80211-vnd-intel.h>
+#include <net/netlink.h>
 
 static const struct nla_policy
 iwl_mvm_vendor_attr_policy[NUM_IWL_MVM_VENDOR_ATTR] = {
diff --git a/drivers/net/wireless/mediatek/mt76/testmode.h b/drivers/net/wireless/mediatek/mt76/testmode.h
index d1f9c036dd1f..725973f1ca58 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.h
+++ b/drivers/net/wireless/mediatek/mt76/testmode.h
@@ -7,6 +7,8 @@
 
 #define MT76_TM_TIMEOUT	10
 
+#include <net/netlink.h>
+
 /**
  * enum mt76_testmode_attr - testmode attributes inside NL80211_ATTR_TESTDATA
  *
diff --git a/include/net/codel.h b/include/net/codel.h
index d74dd8fda54e..5fed2f16cb8d 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -44,7 +44,6 @@
 #include <linux/types.h>
 #include <linux/ktime.h>
 #include <linux/skbuff.h>
-#include <net/pkt_sched.h>
 
 /* Controlling Queue Delay (CoDel) algorithm
  * =========================================
diff --git a/include/net/codel_qdisc.h b/include/net/codel_qdisc.h
index 098630f83a55..58b6d0ebea10 100644
--- a/include/net/codel_qdisc.h
+++ b/include/net/codel_qdisc.h
@@ -49,6 +49,8 @@
  * Implemented on linux by Dave Taht and Eric Dumazet
  */
 
+#include <net/pkt_sched.h>
+
 /* Qdiscs using codel plugin must use codel_skb_cb in their own cb[] */
 struct codel_skb_cb {
 	codel_time_t enqueue_time;
-- 
2.31.1

