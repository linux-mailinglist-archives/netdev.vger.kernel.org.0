Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2F5A95ED
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiIALsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiIALsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:48:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E2613A7C2;
        Thu,  1 Sep 2022 04:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662032897; x=1693568897;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P27EPnIzqpU6RwWBQixwKJlpZ+ZGv6BjVXx8T7VYhF8=;
  b=b/vpoJf6Tit1yHXkrDgxeDoXZGgMTFucqUxeb8KE3VMU3lo9hMJllwhv
   psbWHhhfcBgBjfRC3MvdPqVjyTqN+fwyCO7vwfZDL7xQZEy74kIjSGMZu
   bavYAkNgdMTPV3v+yNYqo3zIQytS+bTzE02n9ahiC0Ql7cBpHooIKKXBB
   7pOZ0cwtup0wfFlXacA1z+O7upyNKT4lSMwcaDw1LZDU/YpFhGFMd/2Zn
   PZ8kWun1FB+qnmtWVQsb2tjqAyyTqE7rmPWQIJa8Y3XzrGotRMe7KI3kU
   9qR3+G9csMVt7SpPysFT1bflhsx/vVcylpTo2KZyflhXbAAToBrs8gqz0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="357410331"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="357410331"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 04:48:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673814318"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 04:48:14 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v6 bpf-next 0/6] selftests: xsk: real device testing support
Date:   Thu,  1 Sep 2022 13:48:07 +0200
Message-Id: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5->v6:
* rebase properly
* collect acks (Magnus)
* extend char limit for iface/netns to 16 (Magnus)

v4->v5:
* ice patches have gone through its own way, so they are out of this
  revision
* rebase
* close prog fd on error path in patch 1 (John)
* pull out patch for closing netns fd and send it separately (John)
* remove a patch that made Tx completion rely on pkts_in_flight (John)

v3->v4:
* use ice_{down,up} rather than ice_{stop,open} and check retvals
  when toggling loopback mode (Jakub)
* Remove patch that was throwing away xsk->outstanding_tx (Magnus)

v2->v3:
* split loopback patch to ice_set_features() refactor part and other
  part with actual loopback toggling support (Alexandr)
* collect more acks from Magnus

v1->v2:
* collect acks from Magnus
* drop redundant 'ret' variable in patch 4 (Magnus)
* drop redundant assignments to ifobject->xdp_flags in patch 10 (Magnus)
* use NETIF_F_LOOPBACK instead of introducing priv-flag (Alexandr)

Hi!

This set makes it possible to use xskxceiver against real devices that
support MAC loopback. Currently, xskxceiver assumes that underlying
device supports native XDP. It is true for veth, but might not be for
other device that might be used with xskxceiver once this patch set
land. So, first patch adds a logic to find out if underlying device
supports XDP so that TEST_MODE_DRV can be used for test suite.

In patch 2, default Rx pkt stream is added so physical device testing
will be able to use shared UMEM in a way that Tx will utilize first half
of buffer space and Rx second one. Then, patch 4 adds support for running
xskxceiver on physical devices.

Patch 6 finally adds new TEST_MODE_ZC for testing zero copy AF_XDP
driver support.

This work already allowed us to spot and fix two bugs in AF_XDP kernel
side ([0], [1]).

v1 is here [2].
v2 is here [3].
v3 is here [4].
v4 is here [5].
v5 is not worth including in here.

[0]: https://lore.kernel.org/bpf/20220425153745.481322-1-maciej.fijalkowski@intel.com/
[1]: https://lore.kernel.org/bpf/20220607142200.576735-1-maciej.fijalkowski@intel.com/
[2]: https://lore.kernel.org/bpf/20220610150923.583202-1-maciej.fijalkowski@intel.com/
[3]: https://lore.kernel.org/bpf/20220614174749.901044-1-maciej.fijalkowski@intel.com/
[4]: https://lore.kernel.org/bpf/20220615161041.902916-1-maciej.fijalkowski@intel.com/
[5]: https://lore.kernel.org/bpf/20220616180609.905015-1-maciej.fijalkowski@intel.com/

Thank you.

Maciej Fijalkowski (6):
  selftests: xsk: query for native XDP support
  selftests: xsk: introduce default Rx pkt stream
  selftests: xsk: increase chars for interface name to 16
  selftests: xsk: add support for executing tests on physical device
  selftests: xsk: make sure single threaded test terminates
  selftests: xsk: add support for zero copy testing

 tools/testing/selftests/bpf/test_xsk.sh  |  52 ++-
 tools/testing/selftests/bpf/xskxceiver.c | 398 +++++++++++++++++------
 tools/testing/selftests/bpf/xskxceiver.h |  11 +-
 3 files changed, 340 insertions(+), 121 deletions(-)

-- 
2.34.1

