Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D923E34DC25
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhC2WzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:55:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:2470 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhC2Wy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:54:57 -0400
IronPort-SDR: VpTnR7AqzhD6uqmVsokQC1iy+FiGu2j+PMspbsWeK2SPdHrarxenJPM0r4FXXaIK3O8FREHj1o
 toMGdsBgjWJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="189392975"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="189392975"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 15:54:57 -0700
IronPort-SDR: MQrOtb8+/K8j/oW/POmOiUNONXwx7rrCgDNM4PhjG0p5iEbSdQu8nXJmfXbgyd8dpmNG4QUyUU
 YcEJWqr7TBDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="417884012"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2021 15:54:54 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 00/17] AF_XDP selftests improvements & bpf_link
Date:   Tue, 30 Mar 2021 00:42:59 +0200
Message-Id: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v4 (all in patch 6):
- do not close potentially invalid bpf_link fd (Toke)
- fix misspelling in label (Toke)
- mask out XDP_FLAGS_UPDATE_IF_NOEXIST and XDP_FLAGS_REPLACE explicitly when
  creating bpf_link (Toke)

Changes since v3:
- do not unload netlink-based XDP prog when updating map elem failed and
  current socket was not the creator of XDP resources (Toke)
- pull out code paths based on prog_id value within __xsk_setup_xdp_prog
  so that teardown in case of error at any point is more clear

Changes since v2:
- fix c&p failure in veth's get_channels implementation (Magnus)
- provide a backward compatibilty if bpf_link is not supported (Andrii)
- check for a link type while looking up existing bpf_links (Andrii)

Changes since v1:
- selftests improvements and test case for bpf_link persistence itself
- do not unload netlink-based prog when --force flag is set (John)
- simplify return semantics in xsk_link_lookup (John)

v4: https://lore.kernel.org/bpf/20210326230938.49998-1-maciej.fijalkowski@intel.com/
v3: https://lore.kernel.org/bpf/20210322205816.65159-1-maciej.fijalkowski@intel.com/
v2: https://lore.kernel.org/bpf/20210311152910.56760-1-maciej.fijalkowski@intel.com/
v1: https://lore.kernel.org/bpf/20210215154638.4627-1-maciej.fijalkowski@intel.com/

--------------------------------------------------

This set is another approach towards addressing the below issue:

// load xdp prog and xskmap and add entry to xskmap at idx 10
$ sudo ./xdpsock -i ens801f0 -t -q 10

// add entry to xskmap at idx 11
$ sudo ./xdpsock -i ens801f0 -t -q 11

terminate one of the processes and another one is unable to work due to
the fact that the XDP prog was unloaded from interface.

Previous attempt was, to put it mildly, a bit broken, as there was no
synchronization between updates to additional map, as Bjorn pointed out.
See https://lore.kernel.org/netdev/20190603131907.13395-5-maciej.fijalkowski@intel.com/

In the meantime bpf_link was introduced and it seems that it can address
the issue of refcounting the XDP prog on interface.

Although the bpf_link is the meat of the set, selftests improvements are a
bigger part of it. Overall, we've been able to reduce the complexity of xsk
selftests by removing a bunch of synchronization resources and
simplifying logic and structs.

Last but not least, for multiqueue veth working with AF-XDP, ethtool's
get_channels API needs to be implemented, so it's also included in that
set.

Note also that in order to make it work, a commit from bpf tree:
veth: store queue_mapping independently of XDP prog presence
https://lore.kernel.org/bpf/20210303152903.11172-1-maciej.fijalkowski@intel.com/

is needed.

Thanks,
Maciej

Björn Töpel (3):
  selftests: xsk: remove thread attribute
  selftests: xsk: Remove mutex and condition variable
  selftests: xsk: Remove unused defines

Maciej Fijalkowski (14):
  selftests: xsk: don't call worker_pkt_dump() for stats test
  selftests: xsk: remove struct ifaceconfigobj
  selftests: xsk: remove unused function
  selftests: xsk: remove inline keyword from source file
  selftests: xsk: simplify frame traversal in dumping thread
  libbpf: xsk: use bpf_link
  samples: bpf: do not unload prog within xdpsock
  selftests: xsk: remove thread for netns switch
  selftests: xsk: split worker thread
  selftests: xsk: remove Tx synchronization resources
  selftests: xsk: refactor teardown/bidi test cases and testapp_validate
  selftests: xsk: remove sync_mutex_tx and atomic var
  veth: implement ethtool's get_channels() callback
  selftests: xsk: implement bpf_link test

 drivers/net/veth.c                       |  12 +
 samples/bpf/xdpsock_user.c               |  55 +-
 tools/lib/bpf/xsk.c                      | 258 +++++++--
 tools/testing/selftests/bpf/test_xsk.sh  |   3 +-
 tools/testing/selftests/bpf/xdpxceiver.c | 700 ++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  49 +-
 6 files changed, 573 insertions(+), 504 deletions(-)

-- 
2.20.1

