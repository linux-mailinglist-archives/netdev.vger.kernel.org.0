Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3CD5ECCF4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiI0Tdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiI0Tdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:33:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD22F1628
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664307216; x=1695843216;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TNynad7WHchlnr6dBc498lQX/b1g9UiDwQW5y223KoE=;
  b=ZRvmwodU+m7HTLuW+FIczb6wLGV/aGcKhqD/37diHw0Hi5esL/Tn+jGW
   M/dOPACD5PnQSdR72KBuCCHGDC5D9fwcAF5FsKTwRz8e/xrn240dFk+uo
   b4cw00RF97tWi6tkIGRwzMugbl9p41yHMxRTzd3qk1ohWQDnTgzPzz9gj
   uRodovCwru0KpytG+lkrigWusP5gGqwZ/tW+3zrpFhzfLWFKb+5NaRjAF
   ENIT2BJpskDNdNKJKT/YEl8pOAs6BXp7O2uKF1HYMl9epT5YW7FyUguvU
   BsqcshmYIFAHK75DPbaGbNuUbAKboKHO2bDxhW+LCuUHpA2hYrDXIUKlw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="299010386"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="299010386"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:32:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="652399446"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="652399446"
Received: from soumiban-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.98])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:32:03 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/2] mptcp: Properly clean up unaccepted subflows
Date:   Tue, 27 Sep 2022 12:31:56 -0700
Message-Id: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 factors out part of the mptcp_close() function for use by a caller
that already owns the socket lock. This is a prerequisite for patch 2.

Patch 2 is the fix that fully cleans up the unaccepted subflow sockets.

Menglong Dong (2):
  mptcp: factor out __mptcp_close() without socket lock
  mptcp: fix unreleased socket in accept queue

 net/mptcp/protocol.c | 16 +++++++++++++---
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 33 +++++++--------------------------
 3 files changed, 22 insertions(+), 29 deletions(-)


base-commit: 797666cd5af041ffb66642fff62f7389f08566a2
-- 
2.37.3

