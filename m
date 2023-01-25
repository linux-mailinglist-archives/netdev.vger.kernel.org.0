Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344FE67BE30
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbjAYVYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAYVYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:24:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F2846D5B
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674681876; x=1706217876;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4PDYSIc++ACzoGJmePeAyMlNOtTPqBENfHqIzfk7NA4=;
  b=PJRPRveF5KSBTM+lufWMGoXlwMykBORde7m2i4YpG/3hTnggraj1RKz8
   axWrKoVKf3ge9tUYLhc+M9tDdtJt46Us1Y/FDpqOH/ibarUoyR9dXyOvU
   Ok112E2hPUH+poGsIIuS0MCmtzGwS/YMJQA27ilYoOW5z4hlERuWwA/km
   3362ztc+/P1BIAG9eT11Izxkr9tkakyi46znh8WpS1oyTPwzXqw/7zhCw
   bqLc6tUWgYp0UygHdNI2EjKKftQRESfcT4+xKXDXbuDp4me36qt7+qsnS
   QBevT8iDUyaQ/RDg2jeAZpWpeFG4NwlAVtOj/Yh/8u1YMPcu2uAtRosA8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="328767481"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="328767481"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:24:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="770894100"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="770894100"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2023 13:24:35 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com
Subject: [PATCH net-next 0/4][pull request] virtchnl: update and refactor
Date:   Wed, 25 Jan 2023 13:24:37 -0800
Message-Id: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesse Brandeburg says:

The virtchnl.h file is used by i40e/ice physical function (PF) drivers
and irdma when talking to the iavf driver. This series cleans up the
header file by removing unused elements, adding/cleaning some comments,
fixing the data structures so they are explicitly defined, including
padding, and finally does a long overdue rename of the IWARP members in
the structures to RDMA, since the ice driver and it's associated Intel
Ethernet E800 series adapters support both RDMA and IWARP.

The whole series should result in no functional change, but hopefully
clearer code.

The following are changes since commit f5be9caf7bf022ab550f62ea68f1c1bb8f5287ee:
  net: ethtool: fix NULL pointer dereference in pause_prepare_data()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jesse Brandeburg (4):
  virtchnl: remove unused structure declaration
  virtchnl: update header and increase header clarity
  virtchnl: do structure hardening
  virtchnl: i40e/iavf: rename iwarp to rdma

 drivers/net/ethernet/intel/i40e/i40e_client.c |   2 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  63 +++----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |   6 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_client.c |  32 ++--
 drivers/net/ethernet/intel/iavf/iavf_client.h |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_status.h |   2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   6 +-
 include/linux/avf/virtchnl.h                  | 159 ++++++++++--------
 11 files changed, 150 insertions(+), 134 deletions(-)

-- 
2.38.1

