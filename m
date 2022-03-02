Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6174CACB3
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244029AbiCBSAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiCBSAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:00:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3185ECA716;
        Wed,  2 Mar 2022 09:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646243960; x=1677779960;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o1sOw8MbrRf1lb7YiLa+Xb9jmU5kGhH5OtK2OB/80JM=;
  b=n13nTENcoqKc3NpUlfGUtyYehS3tL+yu2NhyDFdTaopgCx2fEdXpe2d2
   hiRwzArAWAoiHR1ppyHtGqPQUY+Kkzt23Ue2HXXML689gam4CWzUHetYO
   qIAZmmKlZP6m1mopJgb03pcGnuHQBxgwNWTxnG/RVlLHPAHVwygxB2/ux
   Jzw+444AcD+FbX1eW6nrIZq+Z5XdbyIFhEL4zl4rOmiogKmTi5CGzxq2T
   62VI6DE2l2+nYDHsdnkPSsF7mSYYdhYnfvhZeqbdaqle466bV9HIz0d8g
   5oqZhe4rrxRQSEBdTJiOOCdqzcaZ4cJN3okixU0B5ayAtDDcjc8QGrGb8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251041188"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="251041188"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:59:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="630492505"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Mar 2022 09:59:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com, songliubraving@fb.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-03-02
Date:   Wed,  2 Mar 2022 09:59:26 -0800
Message-Id: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ice drivers.

Maciej fixes an issue that occurs when carrier is not ok and xsk_pool
is present that will cause ksoftirqd to consume 100% CPU by changing
the value returned when the carrier state is not ok for ixgbe. He also
removes checks against ice_ring_is_xdp() that can't occur for ice.

The following are changes since commit 4761df52f1549cc8c5ffcad0b2095fffe2c5435d:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Maciej Fijalkowski (2):
  ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()
  ice: avoid XDP checks in ice_clean_tx_irq()

 drivers/net/ethernet/intel/ice/ice_txrx.c    | 7 +------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 6 ++++--
 2 files changed, 5 insertions(+), 8 deletions(-)

-- 
2.31.1

