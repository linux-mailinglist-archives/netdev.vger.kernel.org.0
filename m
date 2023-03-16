Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665186BD789
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjCPRwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjCPRwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:52:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E50865A1;
        Thu, 16 Mar 2023 10:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678989162; x=1710525162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6TaiTLcmKSeve63HxvGNvZdw/WyLdEEKe9rIMAI6pQA=;
  b=SLQA23OmQofHHqQvlNY6U9LmgBpIepMoPxSQmM3tmePEisT7VQ9yPc7E
   ZLYPQJ0ffYwF8zSUpbxqkMPLhm6HuqUqjh4/GJcf5/ou0yg1Pv6W8UJ/d
   uvrh+CPF5XvKcino3u9hhJ4SZDyG8pVBQBeT/vELB66YVjhwXbDA6bHY3
   tdYuQpkTcvUR04MaxWeiqCak8qOlDUAngkIWjZH2u20al/lBk2wdOb+VD
   idGbGaYdzRTz5bfrwr/MoOynyli3Ibk0pa5ZiJEawbFYuR9Z049vySMxr
   aUlaZ4DKz4VXIK4Rj+51Hl/p0gqQFW7Ze0oQMqe2hzwdJKBvZ+4Pa5og7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317721432"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317721432"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823351254"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823351254"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 10:52:02 -0700
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 0/2] double-fix bpf_test_run + XDP_PASS recycling
Date:   Thu, 16 Mar 2023 18:50:49 +0100
Message-Id: <20230316175051.922550-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabling skb PP recycling revealed a couple issues in the bpf_test_run
code. Recycling broke the assumption that the headroom won't ever be
touched during the test_run execution: xdp_scrub_frame() invalidates the
XDP frame at the headroom start, while neigh xmit code overwrites 2 bytes
to the left of the Ethernet header. The first makes the kernel panic in
certain cases, while the second breaks xdp_do_redirect selftest on BE.
test_run is a limited-scope entity, so let's hope no more corner cases
will happen here or at least they will be as easy and pleasant to fix
as those two.

Alexander Lobakin (2):
  bpf, test_run: fix crashes due to XDP frame overwriting/corruption
  selftests/bpf: fix "metadata marker" getting overwritten by the
    netstack

 net/bpf/test_run.c                                   | 12 +++++++++++-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c       |  7 ++++---
 .../selftests/bpf/progs/test_xdp_do_redirect.c       |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.39.2

