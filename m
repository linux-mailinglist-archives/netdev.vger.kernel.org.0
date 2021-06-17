Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3473ABFAD
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhFQXsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:13468 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhFQXsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:37 -0400
IronPort-SDR: jf28nziMWF+wQOVyMV6sogp8vD5EGaPWoTvc6tqVNMyq3zaAxzMK2T9vsTnaVBgc3H37G+t10x
 MUhogEtX5SFA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506623"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506623"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:28 -0700
IronPort-SDR: 9fZzV1XZRp6M+GPl0wwqtPB4aMz8XFqbo6o/mValoeftoBN1UhDYZcE3jKagGFqmGBj/Q0yVCA
 uVeprSy+DGYQ==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943896"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:27 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, geliangtang@gmail.com, pabeni@redhat.com
Subject: [PATCH net-next 00/16] mptcp: DSS checksum support
Date:   Thu, 17 Jun 2021 16:46:06 -0700
Message-Id: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684 defines a DSS checksum feature that allows MPTCP to detect
middlebox interference with the MPTCP DSS header and the portion of the
data stream associated with that header. So far, the MPTCP
implementation in the Linux kernel has not supported this feature.

This patch series adds DSS checksum support. By default, the kernel will
not request checksums when sending SYN or SYN/ACK packets for MPTCP
connections. Outgoing checksum requests can be enabled with a
per-namespace net.mptcp.checksum_enabled sysctl. MPTCP connections will
now proceed with DSS checksums when the peer requests them, whether the
sysctl is enabled or not.


Patches 1-5 add checksum bits to the outgoing SYN, SYN/ACK, and data
packet headers. This includes calculating the checksum using a range of
data and the MPTCP DSS mapping for that data.

Patches 6-10 handle the checksum request in the SYN or SYN/ACK, and
receiving and verifying the DSS checksum on data packets.

Patch 11 adjusts the MPTCP-level retransmission process for checksum
compatibility.

Patches 12-14 add checksum-related MIBs, the net.mptcp.checksum_enabled
sysctl, and a checksum field to debug trace output.

Patches 15 & 16 add selftests.


The series is slightly longer than the preferred 15-patch limit that
patchwork warns about. I do try to stay below that whenever possible -
this series does implement one feature and is, I think, cohesive enough
to justify keeping it together. If it's at all problematic please let me
know!

A trivial merge conflict with net/master is introduced in patch 15: a
commit in net/master removes a couple of nearby lines of code.


Geliang Tang (14):
  mptcp: add csum_enabled in mptcp_sock
  mptcp: generate the data checksum
  mptcp: add csum_reqd in mptcp_out_options
  mptcp: send out checksum for MP_CAPABLE with data
  mptcp: send out checksum for DSS
  mptcp: add sk parameter for mptcp_get_options
  mptcp: add csum_reqd in mptcp_options_received
  mptcp: receive checksum for MP_CAPABLE with data
  mptcp: receive checksum for DSS
  mptcp: add the mib for data checksum
  mptcp: add a new sysctl checksum_enabled
  mptcp: dump csum fields in mptcp_dump_mpext
  selftests: mptcp: enable checksum in mptcp_connect.sh
  selftests: mptcp: enable checksum in mptcp_join.sh

Paolo Abeni (2):
  mptcp: validate the data checksum
  mptcp: tune re-injections for csum enabled mode

 Documentation/networking/mptcp-sysctl.rst     |   8 +
 include/net/mptcp.h                           |   9 +-
 include/trace/events/mptcp.h                  |  17 +-
 include/uapi/linux/mptcp.h                    |   1 +
 net/mptcp/ctrl.c                              |  16 ++
 net/mptcp/mib.c                               |   1 +
 net/mptcp/mib.h                               |   1 +
 net/mptcp/mptcp_diag.c                        |   1 +
 net/mptcp/options.c                           | 154 +++++++++++++-----
 net/mptcp/protocol.c                          |  29 +++-
 net/mptcp/protocol.h                          |  23 ++-
 net/mptcp/subflow.c                           | 120 ++++++++++++--
 .../selftests/net/mptcp/mptcp_connect.sh      |  13 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 107 +++++++++++-
 14 files changed, 431 insertions(+), 69 deletions(-)


base-commit: 8fe088bd4fd12f4c8899b51d5bc3daad98767d49
-- 
2.32.0

