Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497606BC8F7
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCPIYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCPIYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:24:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DE65584;
        Thu, 16 Mar 2023 01:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678955077; x=1710491077;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pLr4zyKR9mScniLFymNZ6LCQtLSp1OBPkBpafzPWR8w=;
  b=KWZp8iROh9hHs7mGb26lzr7AaWlUzV6ncxnTziBXvu7GdrHhePoWPcSu
   iDVRpdElIju/9OpEDJCW/2p/sovg+5BfHxMSY5NTlmwtcAhUjjhs4sqjV
   O1SdtQBg1B/9pDbMaX8QHmeGLmnEMy6XA4zza5/iskbsuAaUeEhapkk3a
   DF+8L3faGL4xSdWBTf6zkq7KRJAdHjF5QiwFCk3d9FsB/1M0psDT6uDDY
   axay+5CnKW/FBKDXatG8Zkm/2Rl6ZzJpSU/GTQqDOy7+r4PNqvo9Fc6Z5
   p/+ujZ79DR/ROe9ixtn1sCeoTPrvMmJ7WnVPlg3UY/FFkfoQvvelfcmwi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="402794202"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402794202"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 01:24:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="823141544"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823141544"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 01:24:32 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id CE2F17525B;
        Mon, 13 Mar 2023 19:09:39 +0000 (GMT)
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
Date:   Mon, 13 Mar 2023 20:08:09 +0100
Message-Id: <20230313190813.1036595-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
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

