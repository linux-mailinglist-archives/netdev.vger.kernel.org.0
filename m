Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD91602DCB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJROCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiJROCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B38D018F;
        Tue, 18 Oct 2022 07:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101758; x=1697637758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6oDING5vGM3dV4GZO+MbDqq/vJ6YjDIWZVcH2ZWozdQ=;
  b=WmvyLZ/VfJRkAD3gL26gH1dXVfEn34gWER7qqu6RD3XofK8TzYN08G5i
   IKbrwU9vIgqWCTZMt2XJfQlhj+63M8fj0vuw06AJs/s3g6vLBYz6S6jep
   qgJHp95uofE0MvTYjK6TQ/5KV5yp7SSrzo0PYFNHIEpyq3dCQG16XLFz6
   KSXotClnF30M3IGDjrWSxIp6M/tQz/tWeOMDlBH+AAz3J/B7LseRPE0mI
   avcQOo9WFGspcv5h/9kTKRbD/z0a/U13fQyaa6srLaJjlpDb1TiBExHpB
   kSxI6kG6kfvTuTNDbxLxhDyPwnCb3AVSufKeVSBPBT4z1pQ6bsuXF0NaT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502876"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502876"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510405"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510405"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:35 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUP011675;
        Tue, 18 Oct 2022 15:02:34 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@linux.intel.com>
Subject: [PATCH v2 net-next 5/6] bitops: make BYTES_TO_BITS() treewide-available
Date:   Tue, 18 Oct 2022 16:00:26 +0200
Message-Id: <20221018140027.48086-6-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018140027.48086-1-alexandr.lobakin@intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid open-coding that simple expression each time by moving
BYTES_TO_BITS() from the probes code to <linux/bitops.h> to export
it to the rest of the kernel.
Do the same for the tools ecosystem as well (incl. its version of
bitops.h).

Suggested-by: Andy Shevchenko <andy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/bitops.h         | 1 +
 kernel/trace/trace_probe.c     | 2 --
 tools/include/linux/bitops.h   | 1 +
 tools/perf/util/probe-finder.c | 2 --
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 2ba557e067fe..e11f19f96853 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -20,6 +20,7 @@
 #define BITS_TO_U64(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u64))
 #define BITS_TO_U32(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
 #define BITS_TO_BYTES(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_LONG / sizeof(long))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 36dff277de46..89e73eebc72c 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -523,8 +523,6 @@ parse_probe_arg(char *arg, const struct fetch_type *type,
 	return ret;
 }
 
-#define BYTES_TO_BITS(nb)	((BITS_PER_LONG * (nb)) / sizeof(long))
-
 /* Bitfield type needs to be parsed into a fetch function */
 static int __parse_bitfield_probe_arg(const char *bf,
 				      const struct fetch_type *t,
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index f18683b95ea6..aee8667ce941 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -19,6 +19,7 @@
 #define BITS_TO_U64(nr)		DIV_ROUND_UP(nr, BITS_PER_TYPE(u64))
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_LONG / sizeof(long))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 50d861a80f57..2a0b7aacabc0 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -304,8 +304,6 @@ static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
 	return ret2;
 }
 
-#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_LONG / sizeof(long))
-
 static int convert_variable_type(Dwarf_Die *vr_die,
 				 struct probe_trace_arg *tvar,
 				 const char *cast, bool user_access)
-- 
2.37.3

