Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4356606CB
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjAFS6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbjAFS5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:57:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403FF7DE39
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031454; x=1704567454;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7TIumUDPpEAOEBg0s828TzSxiiXHZj89eU4D6tJcElg=;
  b=RYD9dJGvGVs0aKpDltefeYwOA1XJzidNL5V7T0mCKAYmfYS75VUIqTE6
   Lg4ewqIHJKa32KwyT+5NgpXXMTM56y9zjZ5MfRbh9tISiF5+kpfMn1eoj
   wFBz9tjB2hMTLxaiPi3DOV1gxOeyIHu8JgBgZwAzQ5ZVJSQpfiYcBxm9O
   TIyxjsKLkHwwZ8dEgoZeKFC4BDRvsFqT1eB6R2xjzPstum+IFM/RXMaLn
   yl2cqCq0CRnmgldKz9Lq61bsrIgMBKNd0F+KNabLTRq/phIAjkjx+ub1f
   PtA8xjVvKRBe7X5qvWom61B8ppq9e+/37WqoSgmYt5wioXUtmDBG7Ps1p
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322611199"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="322611199"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688383426"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688383426"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/9] mptcp: Protocol in-use tracking and code cleanup
Date:   Fri,  6 Jan 2023 10:57:16 -0800
Message-Id: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a collection of commits from the MPTCP tree:

Patches 1-4 and 6 contain miscellaneous code cleanup for more consistent
use of helper functions, existing local variables, and better naming.

Patches 5, 7, and 9 add sock_prot_inuse tracking for MPTCP and an
associated self test.

Patch 8 modifies the mptcp_connect self test tool to exit on SIGUSR1
when in "slow mode".

Geliang Tang (3):
  mptcp: use msk_owned_by_me helper
  mptcp: use net instead of sock_net
  mptcp: use local variable ssk in write_options

Menglong Dong (6):
  mptcp: introduce 'sk' to replace 'sock->sk' in mptcp_listen()
  mptcp: init sk->sk_prot in build_msk()
  mptcp: rename 'sk' to 'ssk' in mptcp_token_new_connect()
  mptcp: add statistics for mptcp socket in use
  selftest: mptcp: exit from copyfd_io_poll() when receive SIGUSR1
  selftest: mptcp: add test for mptcp socket in use

 net/mptcp/options.c                           |  3 +-
 net/mptcp/pm_netlink.c                        |  5 +-
 net/mptcp/protocol.c                          | 38 ++++++++-----
 net/mptcp/protocol.h                          |  2 +-
 net/mptcp/sockopt.c                           |  2 +-
 net/mptcp/token.c                             | 14 +++--
 net/mptcp/token_test.c                        |  3 +
 tools/testing/selftests/net/mptcp/diag.sh     | 56 +++++++++++++++++--
 .../selftests/net/mptcp/mptcp_connect.c       |  4 +-
 9 files changed, 95 insertions(+), 32 deletions(-)


base-commit: 6bd4755c7c499dbcef46eaaeafa1a319da583b29
-- 
2.39.0

