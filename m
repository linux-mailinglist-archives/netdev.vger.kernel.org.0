Return-Path: <netdev+bounces-771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1196F9D9D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 04:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B69671C2093F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 02:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE6F125BA;
	Mon,  8 May 2023 02:08:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD5E33FF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 02:08:03 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D3C1724
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 19:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683511681; x=1715047681;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/+cvxz6Nch2t/awpzL90DYmlQpD53kXD3rzf6rWXKls=;
  b=aETshEJE0fNaEj9xtPaJhq+nSQBsLlYbF7Jmfsz+0VLwp/q425drX7ho
   6iUv7IVoekJFchoLCqjmG5fJVxad+GP1MB450dDyvO9s3l9K1JFvXHqsy
   ih66Jql2g7ZgJSZ48jHbcRzgN+6bEeyQ7rg0dWw+YNZDDt+bTra7V2HbM
   Sg2SILpvjaoSgXZHeqa1HYfufgZdaq4B9t5Vog+0MjrRxIP3xWHPdUwx+
   5XkflnyzooKwg3lcTAHZiWiz75iAMKHeTLpDvu2gflSwLhF2+j72nhl/h
   blJA7DlwCN5YuSXSSVh0HLB8tnOZlK0/4Zn8tSTyzfQO21ltr3X+P8eix
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="348362358"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="348362358"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 19:08:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="728880984"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="728880984"
Received: from b49691a74c54.jf.intel.com ([10.45.76.121])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2023 19:08:01 -0700
From: Cathy Zhang <cathy.zhang@intel.com>
To: edumazet@google.com,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: jesse.brandeburg@intel.com,
	suresh.srinivas@intel.com,
	tim.c.chen@intel.com,
	lizhen.you@intel.com,
	cathy.zhang@intel.com,
	eric.dumazet@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: fix memcg overhead caused by sk->sk_forward_alloc size
Date: Sun,  7 May 2023 19:07:59 -0700
Message-Id: <20230508020801.10702-1-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Reviewers,

memcg charge overhead is observed while we benchmark memcached with
memtier by running containers. It's caused by commit 4890b686f408 ("net:
Keep sk->sk_forward_alloc as small as possible"), which aims to reduce
system memory pressure, but makes the per-socket forward allocated
memory too small. The impact of this change is to trigger more
frequently memory allocation during TCP connection lifecycle and leads
to memcg charge overhead finally.

To avoid memcg charge overhead mentioned above, this series defines 64KB
as reclaim threshold when uncharging per-socket memory. It reduces the
frequency of memory allocation and charging during TCP connection, and
it's much less than the original 2MB per-socket reserved memory before
commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
possibile"). Run memcached/memtier test with the 64KB reclaim threshold,
RPS gains around 2.07x.

This series also provides a new ABI /proc/sys/net/core/reclaim_threshold
with flexibility to tune the reclaim threshold according to system
running status.

This series is based on the latest net-next/main tree.

Thanks for your time to help review and your feedback will be greatly!

Cathy Zhang (2):
  net: Keep sk->sk_forward_alloc as a proper size
  net: Add sysctl_reclaim_threshold

 Documentation/admin-guide/sysctl/net.rst | 12 +++++++++
 include/net/sock.h                       | 32 +++++++++++++++++++++++-
 net/core/sysctl_net_core.c               | 14 +++++++++++
 3 files changed, 57 insertions(+), 1 deletion(-)


base-commit: ed23734c23d2fc1e6a1ff80f8c2b82faeed0ed0c
2.34.1


