Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC966B8448
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCMV45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCMV44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:56:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD2F8C809;
        Mon, 13 Mar 2023 14:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678744615; x=1710280615;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pLr4zyKR9mScniLFymNZ6LCQtLSp1OBPkBpafzPWR8w=;
  b=mOsXbz5TDqndvg4wXIxK2e7SU2/jOBqvcbGDyC22Pqcy7ltJZbHwRmxq
   xeDrO4LZTzFoNIHyYs3DjezYShjjEmdf1ph7Z26Z6E6d8L9VuWOUbjT/5
   lRavEke66gW37MPPparPkIB6czB8TMbJQwvaoDA3VQH6dDV0rl0r/KPUk
   ffN87SG0PODJnKUCXa07f50gNk2sNNmXA7ujrvSy2MnY3RHzQ1OvCDftV
   4ikTZVlJ8Ype5SJZTaqv+wEGll5t+ngj3LQk9bLROxXLrW6Lsv+76ZwDq
   twD8FgPQn/BNjui8lHLDqxXy5cIKsUmCQtSYWH4TVbwHXmalaSxSmzIRh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364928600"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="364928600"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 14:56:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747750966"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="747750966"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 14:56:51 -0700
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Mon, 13 Mar 2023 22:55:49 +0100
Message-Id: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

cpumap redirect (cross-core, w/o leaving its NUMA node) on baseline:

  6.8 Mpps  5.0 Mpps    1.8 Mpps

cpumap redirect with skb PP recycling:

  7.9 Mpps  5.7 Mpps    2.2 Mpps
                       +22% (from cpumap redir on baseline)

[0] https://github.com/alobakin/linux/commits/iavf-xdp

Alexander Lobakin (4):
  selftests/bpf: robustify test_xdp_do_redirect with more payload magics
  net: page_pool, skbuff: make skb_mark_for_recycle() always available
  xdp: recycle Page Pool backed skbs built from XDP frames
  xdp: remove unused {__,}xdp_release_frame()

 include/linux/skbuff.h                        |  4 +--
 include/net/xdp.h                             | 29 ---------------
 net/core/xdp.c                                | 19 ++--------
 .../bpf/progs/test_xdp_do_redirect.c          | 36 +++++++++++++------
 4 files changed, 30 insertions(+), 58 deletions(-)

---
From v2[1]:
* fix the test_xdp_do_redirect selftest failing after the series: it was
  relying on that %XDP_PASS frames can't be recycled on veth
  (BPF CI, Alexei);
* explain "w/o leaving its node" in the cover letter (Jesper).

From v1[2]:
* make skb_mark_for_recycle() always available, otherwise there are build
  failures on non-PP systems (kbuild bot);
* 'Page Pool' -> 'page_pool' when it's about a page_pool instance, not
  API (Jesper);
* expanded test system info a bit in the cover letter (Jesper).

[1] https://lore.kernel.org/bpf/20230303133232.2546004-1-aleksander.lobakin@intel.com
[2] https://lore.kernel.org/bpf/20230301160315.1022488-1-aleksander.lobakin@intel.com
-- 
2.39.2

