Return-Path: <netdev+bounces-679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A09756F8E8D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 06:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBDD61C21AE1
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F2415CA;
	Sat,  6 May 2023 04:30:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AA77E
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 04:30:00 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1210C7DA7
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683347399; x=1714883399;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kRztacwXfFUHbjrWpRgZmJUk0s6dwckr0HsOvh5WjLI=;
  b=f6dpw7aQhTKtmcb+cYqJa+Vh8quQV3V9rM9Di5n0LOPiyWwbjyxBIRRe
   5ViGC3VOXy292rXPV+eMl+u1N4UbzTS2nPst3J06Xa3EiJOcMoLGkJYEp
   ZOKx83Lxrn7VBAVRbDNj6FtkW425to2gxmLAGNjz1sXFYPEsHPqrXZfxz
   gkzXRWJUU9fVEb5ls2atUX0M8wKn6MT7xFaNzBqEtCWVZfmOPGnbfwL8l
   ULx0PP7v2PABlJy9VaKl/ZYG2FJBRMIWY/xYBwx+c/GEw4p1mwi80hXTL
   31jUWwsrBmBqNWoAdHlCE/Gi03w0HE9EHZmEDE0KBsRrhhAgbGG7U5b0J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="377424888"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="377424888"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 21:29:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="944157218"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="944157218"
Received: from b49691a74c54.jf.intel.com ([10.45.76.121])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2023 21:29:58 -0700
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
Subject: [PATCH 0/2] net: fix memcg overhead caused by sk->sk_forward_alloc size
Date: Fri,  5 May 2023 21:29:56 -0700
Message-Id: <20230506042958.15051-1-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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
RPS gains around 2.01x.

This series also provides a new ABI /proc/sys/net/core/reclaim_threshold
with flexibility to tune the reclaim threshold according to system
running status.

This series is based on the latest tip/master tree.

Thanks for your time to help review and your feedback will be greatly!

Cathy Zhang (2):
  net: Keep sk->sk_forward_alloc as a proper size
  net: Add sysctl_reclaim_threshold

 Documentation/admin-guide/sysctl/net.rst | 12 ++++++++++++
 include/net/sock.h                       | 24 +++++++++++++++++++++++-
 net/core/sysctl_net_core.c               | 14 ++++++++++++++
 3 files changed, 49 insertions(+), 1 deletion(-)

2.34.1


