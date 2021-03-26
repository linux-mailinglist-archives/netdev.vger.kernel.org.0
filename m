Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEDE34B2E2
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhCZXVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:21:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:11388 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhCZXVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:21:32 -0400
IronPort-SDR: md6953BnPV+hFOlMoi7hZFCXh8uysa/VxEtx/IVdk+jnAWbU41+DIMRRa0jAvCCJXRT5FbeCUF
 D6xNp+b980vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190681400"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="190681400"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 16:20:59 -0700
IronPort-SDR: AwWGci0zNtzr8MX2mLV9H9Q4TZFUSSybGA7ED5bsM5qmhoZGwo/nqg+yEn7nE8eGlS3Ed2W2q8
 XqyUZPja5YWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="410113137"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 26 Mar 2021 16:20:57 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 00/17] AF_XDP selftests improvements & bpf_link
Date:   Sat, 27 Mar 2021 00:09:21 +0100
Message-Id: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 tools/lib/bpf/xsk.c                      | 259 +++++++--
 tools/testing/selftests/bpf/test_xsk.sh  |   3 +-
 tools/testing/selftests/bpf/xdpxceiver.c | 700 ++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  49 +-
 6 files changed, 574 insertions(+), 504 deletions(-)

-- 
2.20.1

