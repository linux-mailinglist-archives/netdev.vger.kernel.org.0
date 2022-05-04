Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1342A51B167
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbiEDV5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDV5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:57:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775055007E
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701256; x=1683237256;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KdM3lp/DhazZUn4xm4CRFy23Msgw+tObg/KorAQfreg=;
  b=MhLJIo9MqGRv92NmvR3cn0726bUpCRGC6CBs9yxdPNty7cOnPV7dr023
   9bpZjK3tihHiNVjkQu72THnsqubBLqSWWbbv+38s7OZXAjXEUEeFSRnDn
   jHg2TSjpHde7wKhWjoG2RJOAhB+U2UziKX/sgeUcXLs7u9dPuWXeK1qVi
   l/IOOLQ/n85N66EEY54UCNx3+5RanGOb2ISvmSOOt/dMcS4+2Pdsc9RjU
   t/ellztktr9W4GCTmW5wrtB9x/XY7HevcFmUWtvG7wCatvIwVlutW/uR2
   6UBgsm7yXMLAZn9IgQySv/S4dv06N5dCdQ/6qsz1X9CFj6UH0tG/8xWFT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248445421"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="248445421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621000348"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.251.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/5] mptcp: Improve MPTCP-level window tracking
Date:   Wed,  4 May 2022 14:54:03 -0700
Message-Id: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves MPTCP receive window compliance with RFC 8684 and
helps increase throughput on high-speed links. Note that patch 3 makes a
change in tcp_output.c

For the details, Paolo says:

I've been chasing bad/unstable performance with multiple subflows
on very high speed links.

It looks like the root cause is due to the current mptcp-level
congestion window handling. There are apparently a few different
sub-issues:

- the rcv_wnd is not effectively shared on the tx side, as each
  subflow takes in account only the value received by the underlaying
  TCP connection. This is addressed in patch 1/4

- The mptcp-level offered wnd right edge is currently allowed to shrink.
  Reading section 3.3.4.:

"""
   The receive window is relative to the DATA_ACK.  As in TCP, a
   receiver MUST NOT shrink the right edge of the receive window (i.e.,
   DATA_ACK + receive window).  The receiver will use the data sequence
   number to tell if a packet should be accepted at the connection
   level.
"""

I read the above as we need to reflect window right-edge tracking
on the wire, see patch 4/5.

- The offered window right edge tracking can happen concurrently on
  multiple subflows, but there is no mutex protection. We need an
  additional atomic operation - still patch 3/4

This series additionally bumps a few new MIBs to track all the above
(ensure/observe that the suspected races actually take place).

I could not access again the host where the issue was so
noticeable, still in the current setup the tput changes from
[6-18] Gbps to 19Gbps very stable.


Paolo Abeni (5):
  mptcp: really share subflow snd_wnd
  mptcp: add mib for xmit window sharing
  tcp: allow MPTCP to update the announced window
  mptcp: never shrink offered window
  mptcp: add more offered MIBs counter

 include/net/mptcp.h   |  2 +-
 net/ipv4/tcp_output.c | 14 ++++++-----
 net/mptcp/mib.c       |  4 +++
 net/mptcp/mib.h       |  6 +++++
 net/mptcp/options.c   | 58 +++++++++++++++++++++++++++++++++++++------
 net/mptcp/protocol.c  | 32 +++++++++++++++---------
 net/mptcp/protocol.h  |  2 +-
 7 files changed, 90 insertions(+), 28 deletions(-)


base-commit: a37f37a2e7f5ea3ae2a1278f552aa21a8e32c221
-- 
2.36.0

