Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8376A9874
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjCCNdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjCCNdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:33:40 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7C411173;
        Fri,  3 Mar 2023 05:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677850419; x=1709386419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DL/6eDQ7YyAxU1AXYV7e9LB+t2Wuqp5AFFnDG4qMMS8=;
  b=NyU6Lr+PuAOJ3vYBcNv6/id9VDdbec4gCCKNmd6VNKZAdShvKkgC1+uR
   uoy/rIByBCQofyd1yyDHrOVyouqDX7N2v9VLglN+eB242gJXLY28DRsAn
   rOnkXCpgjQTHASO88QRSuRpo4W1OJzcQRBrXlpGI+VJ0KLHi5XAtW6ztY
   YHEHbAzNty8M1+Tt8TtF3RCQOQBcNgMbHeVlsykKsVAJF9xlGwHYgUZmg
   cl8AZgf9z2U2wuwZEa9VaCu1meCB403vglsbNrrLmAaLle5If39ElDAAI
   D2RE9sQ6WDo69KavyfX7Hbd7D1qrZm4z1un2AuRn9YS5pYw4IqWiR2SR8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="421314253"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="421314253"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 05:33:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="625347416"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="625347416"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2023 05:33:35 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 7690B3557F;
        Fri,  3 Mar 2023 13:33:33 +0000 (GMT)
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 0/3] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Fri,  3 Mar 2023 14:32:29 +0100
Message-Id: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
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

Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.

__xdp_build_skb_from_frame() missed the moment when the networking stack
became able to recycle skb pages backed by a page_pool. This was making
e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
also affected in some scenarios.
A lot of drivers use skb_mark_for_recycle() already, it's been almost
two years and seems like there are no issues in using it in the generic
code too. {__,}xdp_release_frame() can be then removed as it losts its
last user.
Page Pool becomes then zero-alloc (or almost) in the abovementioned
cases, too. Other memory type models (who needs them at this point)
have no changes.

Some numbers on 1 Xeon Platinum core bombed with 27 Mpps of 64-byte
IPv6 UDP, iavf w/XDP[0] (CONFIG_PAGE_POOL_STATS is enabled):

Plain %XDP_PASS on baseline, Page Pool driver:

src cpu Rx     drops  dst cpu Rx
  2.1 Mpps       N/A    2.1 Mpps

cpumap redirect (w/o leaving its node) on baseline:

  6.8 Mpps  5.0 Mpps    1.8 Mpps

cpumap redirect with skb PP recycling:

  7.9 Mpps  5.7 Mpps    2.2 Mpps
                       +22% (from cpumap redir on baseline)

[0] https://github.com/alobakin/linux/commits/iavf-xdp

Alexander Lobakin (3):
  net: page_pool, skbuff: make skb_mark_for_recycle() always available
  xdp: recycle Page Pool backed skbs built from XDP frames
  xdp: remove unused {__,}xdp_release_frame()

 include/linux/skbuff.h |  4 ++--
 include/net/xdp.h      | 29 -----------------------------
 net/core/xdp.c         | 19 ++-----------------
 3 files changed, 4 insertions(+), 48 deletions(-)

---
From v1[1]:
* make skb_mark_for_recycle() always available, otherwise there are build
  failures on non-PP systems (kbuild bot);
* 'Page Pool' -> 'page_pool' when it's about a page_pool instance, not
  API (Jesper);
* expanded test system info a bit in the cover letter (Jesper).

[1] https://lore.kernel.org/bpf/20230301160315.1022488-1-aleksander.lobakin@intel.com
-- 
2.39.2

