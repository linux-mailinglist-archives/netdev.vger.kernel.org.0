Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6126BCE77
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCPLhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCPLhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:37:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEA6C97DC;
        Thu, 16 Mar 2023 04:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678966649; x=1710502649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g5nPL1hfwFccNcFtYw7ZevITqww5GF47MwYYKvo0Lf4=;
  b=a/AEq4Cscfqgxmz08a7zmzea0EubpN0ZZRQIa5pPPSi0Md9JhfL18j+g
   RaBDANv+KTESvwdlx8vuZyyo59KAfH0evXjlLh7gnEvhEGaVb+x2HGmH7
   +k0A2LGl8onP63xjtFUgzSaE07p84Kd+mams/bTgc9Eo28HRTWuQ3NlFx
   7pE7CNeJeQyCuydTaDOZ4HkT5m4qbZCXuhJk73vD8voZoiA0Vi9NDE+9+
   +Hn4GtAK+lXirZh/3+X3yBACRWL3OqNLfPMdb6rrWbAuIq0JGHcXGUEGC
   sHe4C2w+g+Jru4SG26k/rOG4ep3Tb2MGVfnmgw5+gza16FE/5OJ9Zs7bf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="340320609"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="340320609"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 04:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="1009190188"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009190188"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 04:37:18 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 7800D4FEA2;
        Mon, 13 Mar 2023 21:44:01 +0000 (GMT)
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
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf-next v3 2/4] net: page_pool, skbuff: make skb_mark_for_recycle() always available
Date:   Mon, 13 Mar 2023 22:42:58 +0100
Message-Id: <20230313214300.1043280-3-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313214300.1043280-1-aleksander.lobakin@intel.com>
References: <20230313214300.1043280-1-aleksander.lobakin@intel.com>
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
index fe661011644b..3f3a2a82a86b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5069,12 +5069,12 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
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

