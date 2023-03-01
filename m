Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03B26A7072
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCAQES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCAQER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:04:17 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C0C39CDF;
        Wed,  1 Mar 2023 08:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677686656; x=1709222656;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d/AlPNIfFJMeuNDvXYvovJqMQt5mLfiIJ+uNtGjrJRI=;
  b=GiMg34Y1uahXUqUzlBInkSNneJek05VlWGLI0SNr83jxm1TSkzHoLWdQ
   tWC7+r54hDl9Dx0zIbc+EQT3nK9Bgr3xwJG78ewNYuDJadLLGixaJQDQn
   EqbwL/kkU4QvEE6xly3nNBptQz8DDjNjWq7wZnSkl7xz1jjP3RX2hH4Tn
   LiPFFM0If8W86ctO+IRp2r5zoIWO9rO8u1NBgjs7y0N9EFBF38CSHo+cR
   4RqRRIYOC5WpLqdamgT75Z8ndwpFomxPQImZy4bIMy42oD1i3M8AFVUzR
   0l1+hRkNRYieu3AFQw9zGmj7UShB0A5zJbC5B06Ik26Tt1nENzLl2qvi6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322709877"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="322709877"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:04:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="848686054"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="848686054"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2023 08:04:12 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 34C1336C07;
        Wed,  1 Mar 2023 16:04:11 +0000 (GMT)
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
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v1 0/2] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Wed,  1 Mar 2023 17:03:13 +0100
Message-Id: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
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
became able to recycle skb pages backed by a Page Pool. This was making
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
IPv6 UDP:

Plain %XDP_PASS on baseline, Page Pool driver:

src cpu Rx     drops  dst cpu Rx
  2.1 Mpps       N/A    2.1 Mpps

cpumap redirect (w/o leaving its node) on baseline:

  6.8 Mpps  5.0 Mpps    1.8 Mpps

cpumap redirect with skb PP recycling:

  7.9 Mpps  5.7 Mpps    2.2 Mpps   +22%

Alexander Lobakin (2):
  xdp: recycle Page Pool backed skbs built from XDP frames
  xdp: remove unused {__,}xdp_release_frame()

 include/net/xdp.h | 29 -----------------------------
 net/core/xdp.c    | 19 ++-----------------
 2 files changed, 2 insertions(+), 46 deletions(-)

-- 
2.39.2

