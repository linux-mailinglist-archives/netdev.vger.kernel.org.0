Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396D24F9DBA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiDHTsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiDHTsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:48:15 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B931E114
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649447169; x=1680983169;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aAY7M9Eggank8rLYdGj6a7pOLBcPlDN75BYJHR1AO8o=;
  b=fSWi0cIYqk3WjMVFMH8XXdcF3xb9YNabLZEf3sdOtnf41bmTb6mLqqcH
   aOwbKtHv/NvQ4SZzqYPb+BgezCT1fY/dEyeGoIeKisNomOJ3uT6hT2bkc
   4rhveYp7sf6q2oq2ksoy0u9xvjXhDISjiY+q/A3PVJdYM18ka/9THevr2
   qbyzQN0PvMNF5t//snF8BeF9QSGZ1k/1glQzm0FLV6o2BHkjif+upW7Tj
   UIo3oYLdqqsO/b8qfyTTRbfMdVQHC5XwLjmfr0uJNodLs88jhejRJMaw1
   tSGNszlBI/9BEhyUTDlWgK9HdjxHvtZ6CWe1Z8pb07pfTK9qvc57/x9Kx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="322365288"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="322365288"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="659602144"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.134.75.99])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/8] mptcp: Miscellaneous changes for 5.19
Date:   Fri,  8 Apr 2022 12:45:53 -0700
Message-Id: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Four separate groups of patches here:

Patch 1 optimizes flag checking when releasing mptcp socket locks.

Patches 2 and 3 update the packet scheduler when subflow priorities
change.

Patch 4 adds some pernet helper functions for MPTCP.

Patches 5-8 add diag support for MPTCP listeners, including a selftest.


Florian Westphal (4):
  mptcp: diag: switch to context structure
  mptcp: remove locking in mptcp_diag_fill_info
  mptcp: listen diag dump support
  selftests/mptcp: add diag listen tests

Geliang Tang (1):
  mptcp: add pm_nl_pernet helpers

Paolo Abeni (3):
  mptcp: optimize release_cb for the common case
  mptcp: reset the packet scheduler on incoming MP_PRIO
  mptcp: reset the packet scheduler on PRIO change

 net/mptcp/mptcp_diag.c                    | 105 +++++++++++++++++++++-
 net/mptcp/pm.c                            |  19 +++-
 net/mptcp/pm_netlink.c                    |  43 +++++----
 net/mptcp/protocol.c                      |  18 ++--
 net/mptcp/protocol.h                      |   1 +
 net/mptcp/sockopt.c                       |   6 --
 tools/testing/selftests/net/mptcp/diag.sh |  38 ++++++++
 7 files changed, 193 insertions(+), 37 deletions(-)


base-commit: 85b15c268f29263658dc9e9dff5847be935d4f0f
-- 
2.35.1

