Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4C337826
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhCKPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:41:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:60959 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234223AbhCKPlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:00 -0500
IronPort-SDR: sKsdBe5YeeA/e7q3thTMGxjcM4GlvJlK5VWswJDERXUGsMcLBziSBDHMxIDwxO/QxhT1d2Rcd9
 LuT0wdclmHYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="250048414"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="250048414"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:00 -0800
IronPort-SDR: OGQBeM47BRtoqt5AjathkYZz4NgGdDbldEPTb5xEmuNh0i7Ln5OSsXOjUXWNzUcI/Zzr2iGMAp
 59Lk8yL2qaaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253400"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:40:57 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 00/17] AF_XDP selftests improvements & bpf_link
Date:   Thu, 11 Mar 2021 16:28:53 +0100
Message-Id: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------------------------------------------
v1 of xsk's bpf_link support can be found here:
https://lore.kernel.org/bpf/20210215154638.4627-1-maciej.fijalkowski@intel.com/

Changes since v1:
- selftests improvements and test case for bpf_link persistence itself
- do not unload netlink-based prog when --force flag is set (John)
- simplify return semantics in xsk_link_lookup (John)
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
  selftest: xsk: Remove mutex and condition variable
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
 tools/lib/bpf/xsk.c                      | 139 ++++-
 tools/testing/selftests/bpf/test_xsk.sh  |   2 +-
 tools/testing/selftests/bpf/xdpxceiver.c | 699 ++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  49 +-
 6 files changed, 479 insertions(+), 477 deletions(-)

-- 
2.20.1

