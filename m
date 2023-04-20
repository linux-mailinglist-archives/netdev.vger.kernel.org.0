Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F926EA048
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjDTXxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjDTXxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6F85586
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034801; x=1713570801;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bTfQ6WNIOmfqJdBGj4zmKiQNd/gLRefbw/GvIHEITS0=;
  b=mRW+kPyL5SrNPuJeB9MM0vK4Pmwvt348Il5LuSsamqNF9CxgNWeq5b5q
   uBxwBGNY8Md5Nnp7DprguKD4TcCji0uprvO9LA+uHJM7q08RVkZfmoJs6
   HIAjPPmA4E2NsEMjlRKvTEjYQN5xIn5wnEGQ/MqBRxaPub+ikQGEnLMVV
   OibsdRDBos3n/NdvXzh6UQywdkRLvUR9hm53YjxKfVdMxAP7KWjKFpk8N
   zQ2f1Remwnxmt1FI8l2ddw5OYq/uMgDgEpn+iPU4FGNn56AGH/zlFe/oJ
   m8JiMcCvbfnKQ7Y5P9BhGSXzQOjt/4UWx7cyiWVxTkgXbrcltdiaVMzzL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368425"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368425"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714228"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714228"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, mschmidt@redhat.com,
        johan@kernel.org
Subject: [PATCH net-next 0/6][pull request] ice: lower CPU usage with GNSS
Date:   Thu, 20 Apr 2023 16:50:27 -0700
Message-Id: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Schmidt says:

This series lowers the CPU usage of the ice driver when using its
provided /dev/gnss*.

The following are changes since commit e315e7b83a22043bffee450437d7089ef373cbf6:
  net: libwx: fix memory leak in wx_setup_rx_resources
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Michal Schmidt (6):
  ice: do not busy-wait to read GNSS data
  ice: increase the GNSS data polling interval to 20 ms
  ice: remove ice_ctl_q_info::sq_cmd_timeout
  ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
  ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
  ice: sleep, don't busy-wait, in the SQ send retry loop

 drivers/net/ethernet/intel/ice/ice_common.c   | 29 +++++--------
 drivers/net/ethernet/intel/ice/ice_controlq.c | 12 +++---
 drivers/net/ethernet/intel/ice/ice_controlq.h |  3 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 42 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  3 +-
 5 files changed, 36 insertions(+), 53 deletions(-)

-- 
2.38.1

