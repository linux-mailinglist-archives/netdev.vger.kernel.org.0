Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D1322F1B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhBWQyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:54:32 -0500
Received: from mga04.intel.com ([192.55.52.120]:46446 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhBWQyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:54:31 -0500
IronPort-SDR: fbZi/mknG8LjoKjZlN1MfensgkqEZTAEdH4GhXVU7K3u9o+P4yTLWTXYfzvsMT0VRb+gALTqUP
 Fi1DTiMngyzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9904"; a="182390358"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="182390358"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 08:53:50 -0800
IronPort-SDR: GAYxKm6NFPUDsb2XEr/M1hUVAIb8oq/oCjDb8s9xSHwtm2b42Z1Iu3Nf88r3aa8GRqibuawSDa
 vteMZNDFqhMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="441792086"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 08:53:10 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 0/4] selftests/bpf: xsk improvements and new stats tests
Date:   Tue, 23 Feb 2021 16:23:00 +0000
Message-Id: <20210223162304.7450-1-ciara.loftus@intel.com>
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

v2->v3:
* Rename dump-pkts to dump_pkts in test_xsk.sh
* Add examples of flag usage to test_xsk.sh 

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

 tools/testing/selftests/bpf/test_xsk.sh    | 135 ++------
 tools/testing/selftests/bpf/xdpxceiver.c   | 380 +++++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h   |  57 +++-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
 4 files changed, 342 insertions(+), 260 deletions(-)

-- 
2.17.1

