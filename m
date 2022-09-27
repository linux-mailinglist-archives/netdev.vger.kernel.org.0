Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92675EC9C5
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiI0QmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiI0Qle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:41:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5D41E05D4;
        Tue, 27 Sep 2022 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664296886; x=1695832886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z1+s4VzUdLF8e19QQz1bRbISxthQ3ZMqFG2bviCOyhY=;
  b=SIaXH44u5t6HSH9D9wsgCIP/ENX8zc9MVCp4xed7PfC0tqt/PwJzfQJ2
   /jNkENBd/nd3Efo0g/0BiegqjUZ3vpANjab0/8dqfwlUO0G8GSR0Fp6te
   xgAAPJxWWF6LSCDF6mmVEIgTtabLbF7RLJG/JK8hN90JcD3HInpVdsoAP
   i0SVTy4DhNrSXoN+sjvaqhMnzmPYLOQOqEK24y98irz66jXA8t4/vwttj
   XxYugtvykh/VySxzOYQqReMMhevQNWkKa4mzbapzUv9i6I73Vde5mXBsh
   3qGMmgDI2rhf4F5hWD0SQAokxo4KEFmRVjWdIobiXMGXDH33jG6TxqHYk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="281085136"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="281085136"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 09:41:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="616893057"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="616893057"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 27 Sep 2022 09:41:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net 0/2][pull request] ice: xsk: ZC changes
Date:   Tue, 27 Sep 2022 09:41:10 -0700
Message-Id: <20220927164112.4011983-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski says:

This set consists of two fixes to issues that were either pointed out on
indirectly (John was reviewing AF_XDP selftests that were testing ice's
ZC support) mailing list or were directly reported by customers.

First patch allows user space to see done descriptor in CQ even after a
single frame being transmitted and second patch removes the need for
having HW rings sized to power of 2 number of descriptors when used
against AF_XDP.

I also forgot to mention that due to the current Tx cleaning algorithm,
4k HW ring was broken and these two patches bring it back to life, so we
kill two birds with one stone.

The following are changes since commit 797666cd5af041ffb66642fff62f7389f08566a2:
  net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Maciej Fijalkowski (2):
  ice: xsk: change batched Tx descriptor cleaning
  ice: xsk: drop power of 2 ring size restriction for AF_XDP

 drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 163 +++++++++-------------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |   7 +-
 3 files changed, 71 insertions(+), 101 deletions(-)

-- 
2.35.1

