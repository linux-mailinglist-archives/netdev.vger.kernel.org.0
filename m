Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945D23037D4
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389966AbhAZIZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:25:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:61804 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389899AbhAZIX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:23:28 -0500
IronPort-SDR: qF4snHF/SGjf6ypwfMx6DvfRei7EaCU2+nCdTd37V1l645Kk+L5Y3RoDkg+G3Alj+WvRAk+CxN
 0QbJWkdiONww==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="177298550"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="177298550"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 00:22:40 -0800
IronPort-SDR: e0caeeVkEdwiT5do/YeoVxH8vGJ7nvneHHRlccWDt8bOyqMfCpiaFbnWrfy6l5F3lmQb3+cabU
 3033dhUTBSJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="361901075"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2021 00:22:23 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 0/6] AF_XDP Packet Drop Tracing
Date:   Tue, 26 Jan 2021 07:52:33 +0000
Message-Id: <20210126075239.25378-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces tracing infrastructure for AF_XDP sockets (xsks).
A trace event 'xsk_packet_drop' is created which can be enabled by toggling

/sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable

When enabled and packets are dropped in the kernel, traces are generated
which describe the reason for the packet drop as well as the netdev and
qid information of the xsk which encountered the drop.

Example traces:

507.588563: xsk_packet_drop: netdev: eth0 qid 0 reason: rxq full
507.588567: xsk_packet_drop: netdev: eth0 qid 0 reason: packet too big
507.588568: xsk_packet_drop: netdev: eth0 qid 0 reason: fq empty

The event can also be monitored using perf:

perf stat -a -e xsk:xsk_packet_drop

Three selftests are added which each ensure the appropriate traces are
generated for the following scenarios:
* rx queue full
* packet too big
* fill queue empty

v1->v2:
* Rebase on top of Björn's cleanup series.
* Fixed packet count for trace tests which don't need EOT frame.

This series applies on commit 190d1c921ad0862da14807e1670f54020f48e889

Ciara Loftus (6):
  xsk: add tracepoints for packet drops
  selftests/bpf: restructure setting the packet count
  selftests/bpf: add framework for xsk selftests
  selftests/bpf: XSK_TRACE_DROP_RXQ_FULL test
  selftests/bpf: XSK_TRACE_DROP_PKT_TOO_BIG test
  selftests/bpf: XSK_TRACE_DROP_FQ_EMPTY test

 MAINTAINERS                                |   1 +
 include/linux/bpf_trace.h                  |   1 +
 include/trace/events/xsk.h                 |  45 +++++
 include/uapi/linux/if_xdp.h                |   8 +
 kernel/bpf/core.c                          |   1 +
 net/xdp/xsk.c                              |   5 +
 net/xdp/xsk_buff_pool.c                    |   8 +-
 tools/include/uapi/linux/if_xdp.h          |   8 +
 tools/testing/selftests/bpf/test_xsk.sh    |  90 +++++++++-
 tools/testing/selftests/bpf/xdpxceiver.c   | 192 +++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h   |  10 ++
 tools/testing/selftests/bpf/xsk_prereqs.sh |   3 +-
 12 files changed, 348 insertions(+), 24 deletions(-)
 create mode 100644 include/trace/events/xsk.h

-- 
2.17.1

