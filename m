Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4651B5A65C1
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiH3N52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiH3N46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:56:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE0DF7B39;
        Tue, 30 Aug 2022 06:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867781; x=1693403781;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kVwy+cZgWLzLt/C3cCzBAgjwUtZEaPMQojsqCsqxYGQ=;
  b=i0O4Vp7QwWJ6yVgk0bSin2Xv/obTaYeeOPBMrOSAY7dwSdvGGjriGbBM
   9zXJxwmX9tMfNZseG0nYWKY3Fi9CLIIXTC53+kH5s45Wr4T3/n2aCQoCp
   Uz0kunAckiRgy/vJ/rzOuASasUHhnaE58pwtiPXd3MLofg+1vM9UbBjBJ
   3S/e4r5v6ngDUMYSY5cLwV5vIywff3f7UOPvqlBPVcbiNf+7pJc28ZBmH
   Tm15maW8bEeqieNGXKpIF01kWXf3muMTMT7e8pXl6ZdOwY5qqOIIdWG/r
   RJJZYxseKeiT+B+54RwuqywsqsQVuYLCGdVlhBbyviKSFolYgNPteInTa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295180348"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295180348"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:56:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="562651278"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 06:56:18 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 0/6] selftests: xsk: real device testing support
Date:   Tue, 30 Aug 2022 15:55:58 +0200
Message-Id: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
  selftests: xsk: increase chars for interface name
  selftests: xsk: add support for executing tests on physical device
  selftests: xsk: make sure single threaded test terminates
  selftests: xsk: add support for zero copy testing

 tools/testing/selftests/bpf/test_xsk.sh  |  52 ++-
 tools/testing/selftests/bpf/xskxceiver.c | 399 +++++++++++++++++------
 tools/testing/selftests/bpf/xskxceiver.h |   9 +-
 3 files changed, 339 insertions(+), 121 deletions(-)

-- 
2.34.1

