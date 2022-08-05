Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2464358A41F
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiHEAVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 20:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbiHEAVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 20:21:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A920193F2
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 17:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659658894; x=1691194894;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5h9G3puv5t0e/cpch3ti5VOFTvz7VoTSReYqtZl8/sw=;
  b=mGdm1ToCl/T/xzukrtzotvgbwDRqlDper0tqN923al6MbX8ESxTrBkmg
   lR6SXjZMolCtmgmVGsD9yGtvy6D2IIghPPbhHAiaulGgQiGPeYZd0cBZ+
   7GpsGnvvxxnozKzV2wetI7KqC8YAC63c6BFAwhj315HrdmCqhK+PXtdmt
   3Bh5pk4xZm2bpFwGLaD5Gsuu9FBeHpp0P/mGbnrVKfiRl7XZubsrmgLrs
   Dp803a75emnnmSHpRb1sluNLo7qK04Fph+j8grWbSd0+1YyC9B6EkcWf4
   es/Tb0DG0r5+Vbp/GUQLtUp300WCXTiHILsD2cgToPK6dsxplkv3tFFNU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="270467350"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="270467350"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="729810989"
Received: from ramankur-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.169.219])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net, fw@strlen.de,
        dcaratti@redhat.com, mptcp@lists.linux.dev
Subject: [PATCH net 0/3] mptcp: Fixes for mptcp cleanup/close and a selftest
Date:   Thu,  4 Aug 2022 17:21:24 -0700
Message-Id: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes an issue with leaking subflow sockets if there's a failure
in a CGROUP_INET_SOCK_CREATE eBPF program.

Patch 2 fixes a syzkaller-detected race at MPTCP socket close.

Patch 3 is a fix for one mode of the mptcp_connect.sh selftest.


Florian Westphal (1):
  selftests: mptcp: make sendfile selftest work

Paolo Abeni (2):
  mptcp: move subflow cleanup in mptcp_destroy_common()
  mptcp: do not queue data on closed subflows

 net/mptcp/protocol.c                          | 47 +++++++++----------
 net/mptcp/protocol.h                          | 13 +++--
 net/mptcp/subflow.c                           |  3 +-
 .../selftests/net/mptcp/mptcp_connect.c       | 26 ++++++----
 4 files changed, 49 insertions(+), 40 deletions(-)


base-commit: 4ae97cae07e15d41e5c0ebabba64c6eefdeb0bbe
-- 
2.37.1

