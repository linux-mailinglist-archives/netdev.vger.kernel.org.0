Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71426BC8FF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjCPIZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjCPIYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:24:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A81AFB84;
        Thu, 16 Mar 2023 01:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678955088; x=1710491088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g5nPL1hfwFccNcFtYw7ZevITqww5GF47MwYYKvo0Lf4=;
  b=Zf0dDpdL0my5r1ooZvYtyqyy5XD6YM9N8t5sj9tcMpyFJAC6iDOT6jrV
   WjeElW7kV/UPrm+InyhI8jHBmhKnOXdfv+JG3IheSiIU4gXogu+sPyyWs
   MGGh7hIf3G+I27ISi9pblSXbIgREO4f80HpelGhEOEQlQdK788gbdfvOt
   YJfv+cxS6TiiSBfK0HIiB+9b7IbRhk9VeeopRtZfxNC3Xq5iKXI9RSRY1
   sDWWfbHCoK5BGCs3nY9P6zTlKTqB6xIXrAsGN4HsYa1GeM+qQNiKIVeIr
   G42weI41acF6BiVSZp4L859J5JEzCEZJLlpQdegH2hVyRN4GJeCylnMfv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="402794233"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402794233"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 01:24:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="823141552"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823141552"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 01:24:43 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 5A0F275261;
        Mon, 13 Mar 2023 19:09:42 +0000 (GMT)
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
Date:   Mon, 13 Mar 2023 20:08:11 +0100
Message-Id: <20230313190813.1036595-3-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313190813.1036595-1-aleksander.lobakin@intel.com>
References: <20230313190813.1036595-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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

