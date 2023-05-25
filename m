Return-Path: <netdev+bounces-5318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA67710CBC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E06802814E3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2455101D3;
	Thu, 25 May 2023 12:59:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8F4D534
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:59:43 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E6195;
	Thu, 25 May 2023 05:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685019557; x=1716555557;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f0lF9njkggtpBf9SpDur9tx299D0+TkDV/kEtNrSjqI=;
  b=azvFNd0GhGCULkCjASrsxmOScchdduz3pzAiK1JijYWTdUDP7S29l0Aj
   cxwXhw8AKZbrr2Ylpt6MvRw15I3O2vsBILED8wA1aXMmBL+AJQ/DSUgX6
   Np6LYh1Qrt8lGzAnhSJyKOZoCCuynubEss86KR2+S7awZo8hL0xJntzwy
   TPp2CIqfhBehvXN83Z7RzxKqTaB1y5uJbykM4PAAXxMpoDjXkvz5siCzr
   3/W3u3KZb9Y6xhixauivrWvCgNynvT1XwERH8BKcT988y6xeY/RbFIk34
   R35t46Wu/sCkTBHCxWpxzB8MPlxzhHc1DjyssWeIZjjslSki7dWh76G2Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351384299"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="351384299"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 05:58:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="817075070"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="817075070"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga002.fm.intel.com with ESMTP; 25 May 2023 05:58:29 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 00/12] net: intel: start The Great Code Dedup + Page Pool for iavf
Date: Thu, 25 May 2023 14:57:34 +0200
Message-Id: <20230525125746.553874-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here's a two-shot: introduce Intel Ethernet common library (libie) and
switch iavf to Page Pool. Details in the commit messages; here's
summary:

Not a secret there's a ton of code duplication between two and more Intel
ethernet modules. Before introducing new changes, which would need to be
copied over again, start decoupling the already existing duplicate
functionality into a new module, which will be shared between several
Intel Ethernet drivers.
The first thing that came to my mind was "libie" -- "Intel Ethernet
common library". Also this sounds like "lovelie" and can be expanded as
"lib Internet Explorer" :P I'm open for anything else (but justified).
The series is only the beginning. From now on, adding every new feature
or doing any good driver refactoring will remove much more lines than add
for quite some time. There's a basic roadmap with some deduplications
planned already, not speaking of that touching every line now asks: "can
I share this?".
PP conversion for iavf lands within the same series as these two are tied
closely. libie will support Page Pool model only, so a driver can't use
much of the lib until it's converted. iavf is only the example, the rest
will eventually be converted soon on a per-driver basis. That is when it
gets really interesting. Stay tech.

Alexander Lobakin (12):
  net: intel: introduce Intel Ethernet common library
  iavf: kill "legacy-rx" for good
  iavf: optimize Rx buffer allocation a bunch
  iavf: remove page splitting/recycling
  iavf: always use a full order-0 page
  net: skbuff: don't include <net/page_pool.h> into <linux/skbuff.h>
  net: page_pool: avoid calling no-op externals when possible
  net: page_pool: add DMA-sync-for-CPU inline helpers
  iavf: switch to Page Pool
  libie: add common queue stats
  libie: add per-queue Page Pool stats
  iavf: switch queue stats to libie

 MAINTAINERS                                   |   3 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |   1 +
 drivers/net/ethernet/freescale/fec_main.c     |   1 +
 drivers/net/ethernet/intel/Kconfig            |  12 +-
 drivers/net/ethernet/intel/Makefile           |   1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c | 253 -------
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
 .../net/ethernet/intel/i40e/i40e_prototype.h  |   7 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  74 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  88 ---
 drivers/net/ethernet/intel/iavf/iavf.h        |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c | 253 -------
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 227 +-----
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  45 +-
 .../net/ethernet/intel/iavf/iavf_prototype.h  |   7 -
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 715 +++++-------------
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   | 185 +----
 drivers/net/ethernet/intel/iavf/iavf_type.h   |  90 ---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  16 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 316 --------
 drivers/net/ethernet/intel/ice/ice_main.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  74 +-
 drivers/net/ethernet/intel/libie/Makefile     |   7 +
 drivers/net/ethernet/intel/libie/internal.h   |  23 +
 drivers/net/ethernet/intel/libie/rx.c         | 158 ++++
 drivers/net/ethernet/intel/libie/stats.c      | 190 +++++
 .../ethernet/mellanox/mlx5/core/en/params.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   1 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 include/linux/net/intel/libie/rx.h            | 170 +++++
 include/linux/net/intel/libie/stats.h         | 214 ++++++
 include/linux/skbuff.h                        |   4 +-
 include/net/page_pool.h                       |  69 +-
 net/core/page_pool.c                          |  10 +
 34 files changed, 1139 insertions(+), 2081 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/libie/Makefile
 create mode 100644 drivers/net/ethernet/intel/libie/internal.h
 create mode 100644 drivers/net/ethernet/intel/libie/rx.c
 create mode 100644 drivers/net/ethernet/intel/libie/stats.c
 create mode 100644 include/linux/net/intel/libie/rx.h
 create mode 100644 include/linux/net/intel/libie/stats.h

---
Directly to net-next, has non-Intel code changes (0006-0008).

From v1[0]:
* 0006: new (me, Jakub);
* 0008: give the helpers more intuitive names (Jakub, Ilias);
*  -^-: also expand their kdoc a bit for the same reason;
*  -^-: fix kdoc copy-paste issue (Patchwork, Jakub);
* 0011: drop `inline` from C file (Patchwork, Jakub).

[0] https://lore.kernel.org/netdev/20230516161841.37138-1-aleksander.lobakin@intel.com

-- 
2.40.1


