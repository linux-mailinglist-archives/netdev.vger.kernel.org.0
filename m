Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A77652760
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiLTTwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiLTTwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:52:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F6C1A81B
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671565952; x=1703101952;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Tdwr4tSuEEph9K5A0iUIg96ixLr3HopsgYZRUV8gxs4=;
  b=mfnZ10LqYs7p0CVczFSH4WNZpyoH7Vy3Za9pkuC6p3ijQX4yDnNJn4Vu
   3KYlOLRaVrApA+GBT5cdBHYloqSgOUVsBvM6DsF8itzd131F3HRSe0Lln
   vcxwgkN1WQFv3Z5H9GdP4nJq0D2DFUym/phVR7yHdU38L4JtAwUZ1RxJo
   qmqOPkw4hniVkwVoC6bOg7SCbxjtOZHg72zJCEjy0UPAASFE65bsOp9lj
   dhVVn5fS5O7VW9uPg5axUehgBsmeHV4BD4ISwz2Oq0C99H18pzdTwXjzH
   M85ePN/+jFPzaFSuK1jsIB+TEDYNiYmgJznzzXEvSEpK/mU0YnBjwtWU/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299376683"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299376683"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 11:52:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681780963"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="681780963"
Received: from mdaugher-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.232.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 11:52:21 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, imagedong@tencent.com, mptcp@lists.linux.dev
Subject: [PATCH net 0/2] mptcp: Locking fixes
Date:   Tue, 20 Dec 2022 11:52:13 -0800
Message-Id: <20221220195215.238353-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two separate locking fixes for the networking tree:

Patch 1 addresses a MPTCP fastopen error-path deadlock that was found
with syzkaller.

Patch 2 works around a lockdep false-positive between MPTCP listening and
non-listening sockets at socket destruct time.


Paolo Abeni (2):
  mptcp: fix deadlock in fastopen error path
  mptcp: fix lockdep false positive

 net/mptcp/protocol.c | 20 ++++++++++++++++----
 net/mptcp/protocol.h |  4 ++--
 net/mptcp/subflow.c  | 19 +++++++++++++++++--
 3 files changed, 35 insertions(+), 8 deletions(-)


base-commit: 4be84df38a6f49b81e5909ede78242ba1538c1e6
-- 
2.39.0

