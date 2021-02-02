Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56B830C8AD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbhBBR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:57:25 -0500
Received: from mga06.intel.com ([134.134.136.31]:52438 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233617AbhBBOIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:08:38 -0500
IronPort-SDR: uuWQrAJv6HznOcPUXDmNRhQCMNFLNjmmGAcRFuP5brHlwg1etL7X+ZjP1eeFbCd+AhbTIEEWAM
 YiNGxwvkW0MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="242371356"
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="242371356"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 06:06:41 -0800
IronPort-SDR: ps3hgjD1G3sVoi9k7wIiBWgO8svlPpNyykoQuHcZDvUISEXCSHeBtCqr4/cFV4tZBPNcgYwHfX
 KJ87Ng6khMFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="479774614"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 02 Feb 2021 06:06:39 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     daniel@iogearbox.net, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 0/6] AF_XDP Packet Drop Tracing
Date:   Tue,  2 Feb 2021 13:36:36 +0000
Message-Id: <20210202133642.8562-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces tracing infrastructure for AF_XDP sockets (xsk).
A trace event 'xsk_packet_drop' is created which can be enabled by toggling

/sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable

When enabled and packets or empty packet buffers are dropped in the kernel,
traces are generated which describe the reason for the packet drop, the netdev
and qid information of the xsk which encountered the drop, and some more
information depending on what type of drop was encountered that will tell
the user why the packet was dropped.  This information should help a user
troubleshoot packet drops by providing an extra level of detail which is not
available through use of simple counters

Example traces:
xsk_packet_drop: netdev: ve3213 qid 0 reason: packet too big: len 3000 max 2048 not_used 0
xsk_packet_drop: netdev: ve3213 qid 0 reason: invalid fill addr: addr 520192 not_used 0 not_used 0
xsk_packet_drop: netdev: ve9266 qid 0 reason: invalid tx desc: addr 0 len 4097 options 0

It was decided to use a single event 'xsk_packet_drop' to capture these three
drop types. This means that for some of them, there is some redundant information
in the trace marked as 'not_used'. An alternative to this would be to introduce 3
separate event types under xsk, each with their own appropriate trace format.
Suggestions are welcome on which approach would be better to take.

The event can be monitored using perf:
perf stat -a -e xsk:xsk_packet_drop

A selftest is added for each drop type. These tests provide the conditions to
trigger the traces and ensure that the appropriate traces are generated.

v2->v3:
* Removed some traces which traced events which were not technically drops eg.
when the rxq is full.
* Introduced traces for descriptor validation on RX and TX and selftests for both

v1->v2:
* Rebase on top of Björn's cleanup series.
* Fixed packet count for trace tests which don't need EOT frame.

This series applies on commit 61ca36c8c4eb3bae35a285b1ae18c514cde65439

Ciara Loftus (6):
  xsk: add tracepoints for packet drops
  selftests/bpf: restructure setting the packet count
  selftests/bpf: add framework for xsk selftests
  selftests/bpf: XSK_TRACE_DROP_PKT_TOO_BIG test
  selftests/bpf: XSK_TRACE_INVALID_FILLADDR test
  selftests/bpf: XSK_TRACE_INVALID_DESC_TX test

 MAINTAINERS                                |   1 +
 include/linux/bpf_trace.h                  |   1 +
 include/trace/events/xsk.h                 |  73 ++++++++
 include/uapi/linux/if_xdp.h                |   6 +
 kernel/bpf/core.c                          |   1 +
 net/xdp/xsk.c                              |   7 +-
 net/xdp/xsk_buff_pool.c                    |   3 +
 net/xdp/xsk_queue.h                        |   4 +
 tools/include/uapi/linux/if_xdp.h          |   6 +
 tools/testing/selftests/bpf/test_xsk.sh    |  90 ++++++++-
 tools/testing/selftests/bpf/xdpxceiver.c   | 206 +++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h   |   9 +
 tools/testing/selftests/bpf/xsk_prereqs.sh |   3 +-
 13 files changed, 381 insertions(+), 29 deletions(-)
 create mode 100644 include/trace/events/xsk.h

-- 
2.17.1

