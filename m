Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF165560323
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiF2OfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiF2OfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:35:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC9A2EA28;
        Wed, 29 Jun 2022 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513322; x=1688049322;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t1omApgdYLAwVDFagRYMERfvI9zuc5mv6LuCfvvhcBU=;
  b=EjFwWZ+6blaCcc8B6jitoYpyq+VBd0YN8QJgX+srRYbFBcjkCHJbYXsB
   ozOZqqqTIq8iTsd2936D1/3QHGZKysZbON/Kk+xp3C53eL1HuzVn/oWTN
   p6aHTCG88awo4dDIFbVRQ+UUU8dysV7aq4A6eRMkzqItzInR/9s/7Vlgl
   GA8ajzjD5ilHANgtO93pjkvnFbeXf5I4hac1UuXzaF8EeiuWDmX1j4/mt
   Wl5MwnvXYLpi0035kRqBGyCZ9usB96vdpPa81PHEf+R1HYaYBh9csjmKc
   zaxakQH/8BH0HPesP53NuOp0RcJwM+Xh91ttHiPploI5xOaS5bJwJ0Des
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368357913"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368357913"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:35:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="590765131"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2022 07:35:20 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/4] selftests: xsk: fix TEST_MODE_SKB in xdpxceiver
Date:   Wed, 29 Jun 2022 16:34:54 +0200
Message-Id: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

First of all, this might look incorrect as title has a 'fix' keyword and
is sent to bpf-next, but this is due to the fact that Andrii moved xsk
part of libbpf to selftests yesterday, so it's just not in the bpf tree
yet. Also, no new API to libbpf's xsk would be accepted, so that's the
only way to go with fixing xdpxceiver currently. Besides fixes (#2 and
#4), #1 is a small optimization to reduce times we query bpf_link
capability and #3 is a protection against the thing we're fixing here.

This set is about fixing TEST_MODE_SKB in xdpxceiver. Current function
for loading XDP prog independently from AF_XDP socket ignores the flags
from user, such as XDP_FLAGS_SKB_MODE, which makes it impossible to test
generic XDP.  TEST_MODE_SKB was running with XDP prog in native mode,
which is not a thing that we want.

Had it been correctly in the first place, we would see that
refcounting/deleting XSK socket had issues as well. We need to free BPF
resources only when context refcount drops to zero. If its higher then
it means that we should not touch prog/map as other sockets are still
active.

Thanks,
Maciej

Maciej Fijalkowski (4):
  selftests: xsk: avoid bpf_link probe for existing xsk
  selftests: xsk: introduce XDP prog load based on existing AF_XDP
    socket
  selftests: xsk: verify correctness of XDP prog attach point
  selftests: xsk: destroy BPF resources only when ctx refcount drops to
    0

 tools/testing/selftests/bpf/xdpxceiver.c | 19 ++++++++++++++++++-
 tools/testing/selftests/bpf/xsk.c        | 15 ++++++++++-----
 tools/testing/selftests/bpf/xsk.h        |  1 +
 3 files changed, 29 insertions(+), 6 deletions(-)

-- 
2.27.0

