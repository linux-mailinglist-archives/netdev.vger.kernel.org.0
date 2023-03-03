Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19996A9870
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCCNdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjCCNdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:33:41 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839511043A;
        Fri,  3 Mar 2023 05:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677850420; x=1709386420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gkP8YSGL/x3nylTZPZvFPOewgh3s/bhW36zHGcB17/E=;
  b=nxNH7L6mzCBtkYrbzxNrwD9cf92XXOuwtwl9tt96rCJZZU5bqHDzrsNx
   Gu1JWkM2Y2D1Al2uiDMVvePdavALlx74Tqwz79gJsNgVpDA1rCUVgF/WS
   OzBxc+ufUCwMSfzF5gkewAbGKabfsbAYe/uoTc/GkMeQCZ+CYMaoHRek9
   3ASnkg/lYhjnrlxFVMFSHQZcvWWG+P3wg6D1aKGRBCFzNT5A+D2esqw+q
   nKw9GrCq7a6VgZHIdOTPXOVX3VwrH6OvGhMWHj0/BVcneI+DuVe0a1Plx
   FdEQQSSfYpJ66fI9Mh0mxSnJpe7IdjZsc1FI6jl89lT9J3zfmkrYzufd+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="421314262"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="421314262"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 05:33:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="625347421"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="625347421"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2023 05:33:35 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 6DAE535FBF;
        Fri,  3 Mar 2023 13:33:34 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf-next v2 1/3] net: page_pool, skbuff: make skb_mark_for_recycle() always available
Date:   Fri,  3 Mar 2023 14:32:30 +0100
Message-Id: <20230303133232.2546004-2-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mark_for_recycle() is guarded with CONFIG_PAGE_POOL, this creates
unneeded complication when using it in the generic code. For now, it's
only used in the drivers always selecting Page Pool, so this works.
Move the guards so that preprocessor will cut out only the operation
itself and the function will still be a noop on !PAGE_POOL systems,
but available there as well.
No functional changes.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202303020342.Wi2PRFFH-lkp@intel.com
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ff7ad331fb82..5cc1b4606b69 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5071,12 +5071,12 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 #endif
 }
 
-#ifdef CONFIG_PAGE_POOL
 static inline void skb_mark_for_recycle(struct sk_buff *skb)
 {
+#ifdef CONFIG_PAGE_POOL
 	skb->pp_recycle = 1;
-}
 #endif
+}
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
-- 
2.39.2

