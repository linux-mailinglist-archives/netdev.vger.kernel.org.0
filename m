Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE28E51CE8F
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387840AbiEFBUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387832AbiEFBUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:20:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5961947AE8;
        Thu,  5 May 2022 18:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651799803; x=1683335803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sNZqGjmuN50IzZBHHILw9e8gR/Dm5bu9RYfBrH+MqL0=;
  b=kl40wPkvRj08TOLZM61ZAtJfUKezJ6DYpEQgNuKicI/YoFM5r9Y6AD71
   fktsYJa/97ue5Xrof2++oBb4tQH2Z5RKI1y/X0qA4+lcJvI8U+q5Kw1Bk
   wDz+x5SCnIs9xTMaLP4ROr+BAPLxXTbi9iMVolqaWgbla6DjIeGAmCj5a
   9QJ5lAw7OjMJrEEX+kTJt5/mvNXJaLfjCRtFWSagtuQj+/ImsbKSgyWsN
   rpqWZQn2IL54wBlzTUi81aOKwphFv+wuC6k2kMA1EkhQ5MVLlxOOGLjTY
   uk+ADRvgoVNEHlEa9VrA7VYU8nE8biUv9LKlfNBOjJ9ROfHwsPVLcwF7B
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="265902439"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="265902439"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:16:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="654482425"
Received: from kdjohns3-mobl1.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.212.250.65])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:16:42 -0700
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
Subject: [PATCH net-next v7 02/14] net: skb: introduce skb_data_area_size()
Date:   Thu,  5 May 2022 18:16:04 -0700
Message-Id: <20220506011616.1774805-3-ricardo.martinez@linux.intel.com>
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

Helper to calculate the linear data space in the skb.

Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 include/linux/skbuff.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3270cb72e4d8..bd667c0129ad 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1665,6 +1665,11 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
 }
 #endif
 
+static inline unsigned int skb_data_area_size(struct sk_buff *skb)
+{
+	return skb_end_pointer(skb) - skb->data;
+}
+
 struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size);
 struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 				       struct ubuf_info *uarg);
-- 
2.25.1

