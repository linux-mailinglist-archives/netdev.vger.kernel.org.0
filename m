Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6205B11FB
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiIHBOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiIHBOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:14:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAB21EC5A
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662599685; x=1694135685;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VGU9oD7rgt4NyQmrZoinhkV5X+aChrxTqlNxOWSqk+k=;
  b=N8psf+NfLPmEuY/n8+YhQaGOTUA5WnhL0T8ySyIy3uuGKXp9OG2QvsH3
   IN/lKQ2GMlqabky5L3gkRoPIEfweGGizAEeNG9bVgSEHR6nlVWBFsBhXf
   sUZwN3YMv47NO4yFmntl0rdCggRhH8P+UD/fF8GhWmlOCBJUDKJ2HhuMf
   eTdLYKefgN/anm2J9k60hcuuaUZGFU0SXBV7Z5M2h2Zscm/gj6hQOnJuE
   Q/zR1RbdlZSJt3Am9P6XKDVv8LfwPDuZ0IhDrxsdWe0ieqkELVHXxtBjr
   lbGyq30bCvVdh2Q/uTcPVMA1MFpwGUYsr4fOjWEmPh1XGPb6P6Fls0tj9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="284055019"
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="284055019"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 18:14:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="617290737"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga007.fm.intel.com with ESMTP; 07 Sep 2022 18:14:44 -0700
Subject: [net-next PATCH v2 4/4] Documentation: networking: TC queue based
 filtering
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Wed, 07 Sep 2022 18:24:19 -0700
Message-ID: <166260025920.81018.12730039389826735230.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added tc-queue-filters.rst with notes on TC filters for
selecting a set of queues and/or a queue.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 Documentation/networking/tc-queue-filters.rst |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/networking/tc-queue-filters.rst

diff --git a/Documentation/networking/tc-queue-filters.rst b/Documentation/networking/tc-queue-filters.rst
new file mode 100644
index 000000000000..5839ddd23eb4
--- /dev/null
+++ b/Documentation/networking/tc-queue-filters.rst
@@ -0,0 +1,24 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+TC queue based filtering
+=========================
+
+TC can be used for directing traffic to either a set of queues or
+on a single queue on both the transmit and receive side.
+
+On the transmit side:
+1. TC filter directing traffic to a set of queues is achieved
+   using the action skbedit priority for Tx priority selection,
+   the priority maps to a traffic class (set of queues).
+2. TC filter directs traffic to a transmit queue with the action
+   skbedit queue_mapping $tx_qid.
+
+Likewise, on the receive side, the two filters for selecting set of
+queues and/or a single queue is supported as below:
+1. TC flower filter directs traffic to a set of queues using the
+   'hw_tc' option of tc-flower.
+   hw_tc $TCID - Specify a hardware traffic class to pass matching
+   packets on to. TCID is in the range 0 through 15.
+2. TC filter with action skbedit queue_mapping $rx_qid selects a
+   receive queue.

