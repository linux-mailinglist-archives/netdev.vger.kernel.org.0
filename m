Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41F760BFA5
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiJYAds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJYAdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:33:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07D757BE4;
        Mon, 24 Oct 2022 15:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666652294; x=1698188294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t3bv2MkjydtsyaQXVR2HQj9d69MKIx3tGIYCICf7vKY=;
  b=aQxgHaZdJNYAbonuzsqyEAE9Y4sl0jDSCJoSSfd5mL4a+CYBr/TDVdIE
   4Az5nQ1kMpKjb4OUs+oJmIBzCckUDRbjHGOgOfaj2p1GoKictzIwzjFYG
   rtpRDL+oQ4OuEZMhwPGepkk70uma5xwUC4umyvF3gUrDKZ2PbPN5NzVl6
   C9zbm8RZSDHBQTBny8HvbVb0JVFcrfgbINLvC7Skevtu0PApU62z3csDe
   jNSE0QgacAvr6Q70noiv6IB47K1Gd6pzeYaIRCif9mAU6jPZRREeouNGi
   sa2ujiCWAVOwBvKQLsZ9IXTrlSw2/UckrIa74+wXOaiCa3iz+NT6T9vTM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="308633274"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="308633274"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:57:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="609363403"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="609363403"
Received: from pkearns-mobl1.amr.corp.intel.com (HELO guptapa-desk.intel.com) ([10.252.131.64])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:57:56 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>, dave.hansen@intel.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: [RFC PATCH 1/2] nospec: Add a generic barrier_nospec()
Date:   Mon, 24 Oct 2022 15:57:46 -0700
Message-Id: <a29745ae921ed03084b7d4bdec38c7b01d764fb9.1666651511.git.pawan.kumar.gupta@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

barrier_nospec() is a speculation barrier with an arch dependent
implementation. Architectures that don't need a speculation barrier
shouldn't have to define an arch specific version.

To be able to use barrier_nospec() in non-architecture code add a
generic version that does nothing. Architectures needing speculation
barrier can override the generic version in their asm/barrier.h.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 include/linux/nospec.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index c1e79f72cd89..60e040a5df27 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -60,6 +60,10 @@ static inline unsigned long array_index_mask_nospec(unsigned long index,
 	(typeof(_i)) (_i & _mask);					\
 })
 
+#ifndef barrier_nospec
+#define barrier_nospec()	do { } while (0)
+#endif
+
 /* Speculation control prctl */
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which);
 int arch_prctl_spec_ctrl_set(struct task_struct *task, unsigned long which,
-- 
2.37.3

