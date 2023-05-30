Return-Path: <netdev+bounces-6505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A64716B9A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3039A2808F1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F4C28C33;
	Tue, 30 May 2023 17:53:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CCB1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:53:41 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CDFA3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685469219; x=1717005219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ihCURC7BYgW6pihCzLwuC7i61/SQkMIfxihZ3cvFEi8=;
  b=I6QUX/SnCPx8b7rMy09HBq3ZvQpLtdFnyu8QkDhFeqmKIWCTtHgF4wDU
   BG9M/jRmfRxlGSpEzcpAgPiZu/Cxr1vb2Wjk7vDxlFq0Evt4elyDb4jpn
   pGuH9XE9lO+bqOrDEsgdC5VfbpB9/O7ykNi27f9Uovp7aiQqMHLZFNm4Z
   k9jIAbUp/gMJh/39Q4SoUXVhkhVVKUCec0Y2wQgGLuCKenTUbKzUOVqj8
   kVgzLEENFWqOWV2wVZU8n9tGfIy8FiNUxsuzrBSKoqmwXwe3u3E8yNh/M
   QxeFWCvq3b2GcDF507G3sNg2QCLryNdaWq/+rF9ZoHlAahJri5X0apQo2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418488152"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="418488152"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 10:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="706525006"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="706525006"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 30 May 2023 10:53:38 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	vinicius.gomes@intel.com,
	sasha.neftin@intel.com,
	richardcochran@gmail.com
Subject: [PATCH net 0/4][pull request] igc: TX timestamping fixes
Date: Tue, 30 May 2023 10:49:24 -0700
Message-Id: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is the fixes part of the series intended to add support for using
the 4 timestamp registers present in i225/i226.

Moving the timestamp handling to be inline with the interrupt handling
has the advantage of improving the TX timestamping retrieval latency,
here are some numbers using ntpperf:

Before:

$ sudo ./ntpperf -i enp3s0 -m 10:22:22:22:22:21 -d 192.168.1.3 -s 172.18.0.0/16 -I -H -o -37
               |          responses            |     TX timestamp offset (ns)
rate   clients |  lost invalid   basic  xleave |    min    mean     max stddev
1000       100   0.00%   0.00%   0.00% 100.00%      -56      +9     +52     19
1500       150   0.00%   0.00%   0.00% 100.00%      -40     +30     +75     22
2250       225   0.00%   0.00%   0.00% 100.00%      -11     +29     +72     15
3375       337   0.00%   0.00%   0.00% 100.00%      -18     +40     +88     22
5062       506   0.00%   0.00%   0.00% 100.00%      -19     +23     +77     15
7593       759   0.00%   0.00%   0.00% 100.00%       +7     +47   +5168     43
11389     1138   0.00%   0.00%   0.00% 100.00%      -11     +41   +5240     39
17083     1708   0.00%   0.00%   0.00% 100.00%      +19     +60   +5288     50
25624     2562   0.00%   0.00%   0.00% 100.00%       +1     +56   +5368     58
38436     3843   0.00%   0.00%   0.00% 100.00%      -84     +12   +8847     66
57654     5765   0.00%   0.00% 100.00%   0.00%
86481     8648   0.00%   0.00% 100.00%   0.00%
129721   12972   0.00%   0.00% 100.00%   0.00%
194581   16384   0.00%   0.00% 100.00%   0.00%
291871   16384  27.35%   0.00%  72.65%   0.00%
437806   16384  50.05%   0.00%  49.95%   0.00%

After:

$ sudo ./ntpperf -i enp3s0 -m 10:22:22:22:22:21 -d 192.168.1.3 -s 172.18.0.0/16 -I -H -o -37
               |          responses            |     TX timestamp offset (ns)
rate   clients |  lost invalid   basic  xleave |    min    mean     max stddev
1000       100   0.00%   0.00%   0.00% 100.00%      -44      +0     +61     19
1500       150   0.00%   0.00%   0.00% 100.00%       -6     +39     +81     16
2250       225   0.00%   0.00%   0.00% 100.00%      -22     +25     +69     15
3375       337   0.00%   0.00%   0.00% 100.00%      -28     +15     +56     14
5062       506   0.00%   0.00%   0.00% 100.00%       +7     +78    +143     27
7593       759   0.00%   0.00%   0.00% 100.00%      -54     +24    +144     47
11389     1138   0.00%   0.00%   0.00% 100.00%      -90     -33     +28     21
17083     1708   0.00%   0.00%   0.00% 100.00%      -50      -2     +35     14
25624     2562   0.00%   0.00%   0.00% 100.00%      -62      +7     +66     23
38436     3843   0.00%   0.00%   0.00% 100.00%      -33     +30   +5395     36
57654     5765   0.00%   0.00% 100.00%   0.00%
86481     8648   0.00%   0.00% 100.00%   0.00%
129721   12972   0.00%   0.00% 100.00%   0.00%
194581   16384  19.50%   0.00%  80.50%   0.00%
291871   16384  35.81%   0.00%  64.19%   0.00%
437806   16384  55.40%   0.00%  44.60%   0.00%

During this series, and to show that as is always the case, things are
never easy as they should be, a hardware issue was found, and it took
some time to find the workaround(s). The bug and workaround are better
explained in patch 4/4.

Note: the workaround has a simpler alternative, but it would involve
adding support for the other timestamp registers, and only using the
TXSTMP{H/L}_0 as a way to clear the interrupt. But I feel bad about
throwing this kind of resources away. Didn't test this extensively but
it should work.

Also, as Marc Kleine-Budde suggested, after some consensus is reached
on this series, most parts of it will be proposed for igb.

The following are changes since commit 7ba0732c805fdc623494ff36245d84222ba893e3:
  Merge branch 'selftests-mptcp-skip-tests-not-supported-by-old-kernels-part-1'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Vinicius Costa Gomes (4):
  igc: Fix race condition in PTP tx code
  igc: Check if hardware TX timestamping is enabled earlier
  igc: Retrieve TX timestamp during interrupt handling
  igc: Add workaround for missing timestamps

 drivers/net/ethernet/intel/igc/igc.h      |   7 +-
 drivers/net/ethernet/intel/igc/igc_main.c |  14 ++-
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 119 +++++++++++++++-------
 3 files changed, 95 insertions(+), 45 deletions(-)

-- 
2.38.1


