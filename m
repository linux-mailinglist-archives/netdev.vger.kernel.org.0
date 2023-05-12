Return-Path: <netdev+bounces-2201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5AD700B9B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 672361C212D5
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70DD2415C;
	Fri, 12 May 2023 15:28:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D2124126;
	Fri, 12 May 2023 15:28:33 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D4812A;
	Fri, 12 May 2023 08:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905312; x=1715441312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AEHmn3N8eoQi8YuZE7vwKcyyiqTTaYlvbYO6EcoCop8=;
  b=nNUNzJ7nr5CdvAzQDnBtw2Tb9BHPQ4HTE7oWft9oXHVMHptO+/98sXb6
   XNskRFcfeMlQy8cZgnJNyci4QiSkYEA9IBwN9XN+Jdnuz2wbUiXQGMpIK
   HovC9JMoVT+ffaWActPWv7B8mxFscU6vvXbbqi+0qNfsYcnwme4qxceVM
   8iNOdrTzChIvooNHhOGcMiBa8yVAxOmXtN4s8z6xEy8c7JDYIJGTjQZ4b
   oLgDPThYtX2IOqrFwB38EGd/bzw9XNCA0OFZk62Ur0GC13qlJluqrp4hw
   FANT0qaHmmJ1BxKynIijNlrb9mc96yqaUnoOytjTEF8o5AZc7phSPt47a
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="349653187"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="349653187"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:28:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="1030124377"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="1030124377"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2023 08:28:27 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 4277835FB7;
	Fri, 12 May 2023 16:28:25 +0100 (IST)
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: bpf@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>,
	xdp-hints@xdp-project.net,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND bpf-next 00/15] new kfunc XDP hints and ice implementation
Date: Fri, 12 May 2023 17:25:52 +0200
Message-Id: <20230512152607.992209-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series introduces XDP hints support into ice driver and adds new kfunc
hints that utilize hardware capabilities.

- patches 01-04 refactors driver descriptor to skb fields processing code,
  making it more reusable without changing any behavior.

- patches 05-08 add support add support for existing hints (timestamp and 
  hash) in ice driver.

- patches 09-12 introduce new kfunc hints, namely 2 VLAN tag hints 
  (ctag & stag separately) and "checksum level", which is basically
  a CHECKSUM_UNNECESSARY indicator. Then those hints are implemented in
  ice driver.

- patches 13-15 adjust xdp_hw_metadata to account for new hints.

- in particular, patch 14 lifts the limitation on data_meta size to be
  32 or lower, because all the information that needs to be passed into
  AF_XDP from XDP in xdp_hw_metadata no longer fits into 32 bytes.

Aleksander Lobakin (1):
  net, xdp: allow metadata > 32

Larysa Zaremba (14):
  ice: make RX hash reading code more reusable
  ice: make RX HW timestamp reading code more reusable
  ice: make RX checksum checking code more reusable
  ice: Make ptype internal to descriptor info processing
  ice: Introduce ice_xdp_buff
  ice: Support HW timestamp hint
  ice: Support RX hash XDP hint
  ice: Support XDP hints in AF_XDP ZC mode
  xdp: Add VLAN tag hint
  ice: Implement VLAN tag hint
  xdp: Add checksum level hint
  ice: Implement checksum level hint
  selftests/bpf: Allow VLAN packets in xdp_hw_metadata
  selftests/bpf: Add flags and new hints to xdp_hw_metadata

 Documentation/networking/xdp-rx-metadata.rst  |  14 +-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 412 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_main.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  23 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  18 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  13 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  23 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 311 +++++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  13 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  16 +-
 include/linux/netdevice.h                     |   3 +
 include/linux/skbuff.h                        |  13 +-
 include/net/xdp.h                             |  16 +-
 kernel/bpf/offload.c                          |   6 +
 net/core/xdp.c                                |  36 ++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  49 ++-
 tools/testing/selftests/bpf/xdp_hw_metadata.c |  29 +-
 tools/testing/selftests/bpf/xdp_metadata.h    |  36 +-
 19 files changed, 738 insertions(+), 296 deletions(-)

-- 
2.35.3


