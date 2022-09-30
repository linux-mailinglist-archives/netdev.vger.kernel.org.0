Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B78C5F0F71
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiI3QBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiI3QAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:00:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C1F73304
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664553628; x=1696089628;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dQ8gHgXfrlWUWr09xMTVaafO69+hUvU9xOkm3ErfMoQ=;
  b=dtLIby4bbKdB5qpksqj2+W7KIReDtuy0xZzXkoVVokimYd7pfGidfHm1
   VKjee4wcWoRR8X06Hb+uo7q1pgYNgmiaNxqjgSxCaBm9wrJs8R+f/4vF5
   xssgOFSrLxCv7MxsEm4d/JZXwdRE/Txams0twCOGrXbIqllsYprxZs2TH
   xVB0xPAWrue1SJsGWuy0WncQSYDtPQMEoN4i1ZqmAvnz1L59mF9PryAMy
   e8mf1ovuYaEd/Q3XdHYr6gWJNoGrWlo2DsILO5wHDlRPd11QoWaI/LQRo
   PpVmsSmE+una2aiRsUsURl7aK8abxsJKkbx/Tf+oVuv01MtubaP/gjGKG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="303132488"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="303132488"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:00:27 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="655996107"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="655996107"
Received: from cmforest-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.22.5])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:00:27 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] mptcp: Fastclose edge cases and error handling
Date:   Fri, 30 Sep 2022 08:59:30 -0700
Message-Id: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP has existing code to use the MP_FASTCLOSE option header, which
works like a RST for the MPTCP-level connection (regular RSTs only
affect specific subflows in MPTCP). This series has some improvements
for fastclose.

Patch 1 aligns fastclose socket error handling with TCP RST behavior on
TCP sockets.

Patch 2 adds use of MP_FASTCLOSE in some more edge cases, like file
descriptor close, FIN_WAIT timeout, and when the socket has unread data.

Patch 3 updates the fastclose self tests.

Patch 4 does not change any code, just fixes some outdated comments.

Paolo Abeni (4):
  mptcp: propagate fastclose error
  mptcp: use fastclose on more edge scenarios
  selftests: mptcp: update and extend fastclose test-cases
  mptcp: update misleading comments.

 net/mptcp/protocol.c                          | 124 ++++++++++++------
 .../selftests/net/mptcp/mptcp_connect.c       |  65 +++++++--
 .../testing/selftests/net/mptcp/mptcp_join.sh |  90 ++++++++++---
 3 files changed, 217 insertions(+), 62 deletions(-)


base-commit: 0f5ef005310d4820926c76bc1e94d4d2a0e49d97
-- 
2.37.3

