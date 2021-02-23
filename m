Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC90322938
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhBWLGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:06:32 -0500
Received: from mga07.intel.com ([134.134.136.100]:63299 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231826AbhBWLG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 06:06:28 -0500
IronPort-SDR: Ll1VMecprIu6TL9/qAjzWy6oklBM3FWayPBOgo4etTQM+5V7QiFENymRu8Itui1XH5fnE+fjI6
 qnPkoYfzqt0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="248818637"
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="248818637"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 03:05:47 -0800
IronPort-SDR: Qi2cCw1khEjvatgi7zbpGGtkkks+H4LOrX2Q9/7Nc8y4BNEozGCk9bIz+JSdRIRORsz5fHr72M
 DLK3MezS3AXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="441703434"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 03:05:14 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 0/4] selftests/bpf: xsk improvements and new stats tests
Date:   Tue, 23 Feb 2021 10:35:03 +0000
Message-Id: <20210223103507.10465-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to improve the xsk selftest framework by:
1. making the default output less verbose
2. adding an optional verbose flag to both the test_xsk.sh script and xdpxceiver app.
3. renaming the debug option in the app to to 'dump-pkts' and add a flag to the test_xsk.sh
script which enables the flag in the app.
4. changing how tests are launched - now they are launched from the xdpxceiver app
instead of the script.

Once the improvements are made, a new set of tests are added which test the xsk
statistics.

The output of the test script now looks like:

./test_xsk.sh
PREREQUISITES: [ PASS ]
1..10
ok 1 PASS: SKB NOPOLL 
ok 2 PASS: SKB POLL 
ok 3 PASS: SKB NOPOLL Socket Teardown
ok 4 PASS: SKB NOPOLL Bi-directional Sockets
ok 5 PASS: SKB NOPOLL Stats
ok 6 PASS: DRV NOPOLL 
ok 7 PASS: DRV POLL 
ok 8 PASS: DRV NOPOLL Socket Teardown
ok 9 PASS: DRV NOPOLL Bi-directional Sockets
ok 10 PASS: DRV NOPOLL Stats
# Totals: pass:10 fail:0 xfail:0 xpass:0 skip:0 error:0
XSK KSELFTESTS: [ PASS ]

v1->v2:
* Changed '-d' flag in the shell script to '-D' to be consistent with the xdpxceiver app.
* Renamed debug mode to 'dump-pkts' which better reflects the behaviour.
* Use libpf APIs instead of calls to ss for configuring xdp on the links
* Remove mutex init & destroy for each stats test
* Added a description for each of the new statistics tests
* Distinguish between exiting due to initialisation failure vs test failure

This series applies on commit d310ec03a34e92a77302edb804f7d68ee4f01ba0

Ciara Loftus (3):
  selftests/bpf: expose and rename debug argument
  selftests/bpf: restructure xsk selftests
  selftests/bpf: introduce xsk statistics tests

Magnus Karlsson (1):
  selftest/bpf: make xsk tests less verbose

 tools/testing/selftests/bpf/test_xsk.sh    | 129 ++-----
 tools/testing/selftests/bpf/xdpxceiver.c   | 380 +++++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h   |  57 +++-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
 4 files changed, 336 insertions(+), 260 deletions(-)

-- 
2.17.1

