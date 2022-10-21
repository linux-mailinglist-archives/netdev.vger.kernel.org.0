Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056C66081E8
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 00:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJUW7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 18:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJUW7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 18:59:04 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1AA2AD9DC
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 15:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666393142; x=1697929142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CHMtahEpEz5Zi5dx1eMAFpy1kqoG1TwtUkIb6zRQVQA=;
  b=XK0VaMFj8MRLUr1GPbdAlJKhP17mz1ZWULUOaDOopXdFayc6hfpxlhBB
   KqnwhfXrTIrpaHT0ShgXuqAV5dXFL928arKYyv2JyBeAagFWy17i19xtT
   CY6tx7mESUh3dJeNzbVuouDW3ONbaMyimDJ1XV17Dph7yc+zapNFO69FK
   qq55WnMSE143CuNaclBykbf9XtTT2WkXGt45Flcp8JiFGD0rVC4O8QjMu
   BFJuzQGy7wFjO1H6XGW/k/1WPctdSn20qy/xkm8epCG06TNmUbyncLe5S
   CAah+2FDF8kxeLmgjOwyfnDLOkUQIe5/mThLcNFpeNXMvjfqnHVG4NL14
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="369186385"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="369186385"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 15:59:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="663928729"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="663928729"
Received: from tremple-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.81])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 15:59:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmytro@shytyi.net,
        benjamin.hesmans@tessares.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/3] mptcp: Fixes for 6.1
Date:   Fri, 21 Oct 2022 15:58:53 -0700
Message-Id: <20221021225856.88119-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes an issue with assigning subflow IDs in cases where an
incoming MP_JOIN is processed before accept() completes on the MPTCP
socket.

Patches 2 and 3 fix a deadlock issue with fastopen code (new for 6.1) at
connection time.

Paolo Abeni (3):
  mptcp: set msk local address earlier
  mptcp: factor out mptcp_connect()
  mptcp: fix abba deadlock on fastopen

 net/mptcp/protocol.c | 182 ++++++++++++++++++++++++-------------------
 net/mptcp/protocol.h |   5 +-
 net/mptcp/subflow.c  |   7 ++
 3 files changed, 113 insertions(+), 81 deletions(-)


base-commit: 4d814b329a4d54cd10eee4bd2ce5a8175646cc16
-- 
2.38.1

