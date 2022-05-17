Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3483B52A9CF
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241843AbiEQSCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiEQSCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:02:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC113FBC3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652810541; x=1684346541;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hUIHED+FQ98pTjGesxJQFWoxjja0CiSPbNhECuXi4/Y=;
  b=lJYdc61dphhMtnzEek0xT7F949n8TA31m3gC1ye2p0paoam12zMp1d9K
   tCMsMYeadIIfNK1biCQmq5K/OwvtZ/EVGcjB72QvGCgcV3gVsA+DXOd8/
   NDlJptEdfCwbCOZeRLhDZFQtANnqvkYxN/zj50LYr9xtHJflYkB6I80Rv
   t4XSz1mlniFCP0cQIgGMVlmS+QcaY6BzM3YuqTA6jAAXoZM2wnyduw1MY
   h1lAROxkWgfKUhCUJ4Dqu5XqJBaz4Ba2RwnWK+uuOpiS63vg/ytUw3HKv
   8yOGbM2cfxvsCUoXoQF5rXif2PW/fYFhvf+VjG3OV+NHSZX/87Iz0RXq5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="268854857"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="268854857"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 11:02:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="523080350"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.6.57])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 11:02:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/2] mptcp: Fix checksum byte order on little-endian
Date:   Tue, 17 May 2022 11:02:10 -0700
Message-Id: <20220517180212.92597-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches address a bug in the byte ordering of MPTCP checksums on
little-endian architectures. The __sum16 type is always big endian, but
was being cast to u16 and then byte-swapped (on little-endian archs)
when reading/writing the checksum field in MPTCP option headers.

MPTCP checksums are off by default, but are enabled if one or both peers
request it in the SYN/SYNACK handshake.

The corrected code is verified to interoperate between big-endian and
little-endian machines.

Patch 1 fixes the checksum byte order, patch 2 partially mitigates
interoperation with peers sending bad checksums by falling back to TCP
instead of resetting the connection.

Mat Martineau (1):
  mptcp: Do TCP fallback on early DSS checksum failure

Paolo Abeni (1):
  mptcp: fix checksum byte order

 net/mptcp/options.c  | 36 ++++++++++++++++++++++++------------
 net/mptcp/protocol.h |  5 +++--
 net/mptcp/subflow.c  | 23 +++++++++++++++++++----
 3 files changed, 46 insertions(+), 18 deletions(-)


base-commit: edf410cb74dc612fd47ef5be319c5a0bcd6e6ccd
-- 
2.36.1

