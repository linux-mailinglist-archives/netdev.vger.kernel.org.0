Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2E50190C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbiDNQug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbiDNQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:50:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E39CD32C
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649953092; x=1681489092;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0gg526jrlEHe9Ofg3uzTnmjmhk4ZEf/K4tUV0iRT2i4=;
  b=kOQ56tg8Z0uhFbNdxpVMDEOX3RwDjbLunLztNepV0Tx0IUyJKK55We+l
   RX4vXQfw3bbfojdj+0rd9zBKpJVFKMLXGRX7KbXK94c3JhVnvjkqo+wr3
   9BrNEVXPN25SYinzgMRQitKJiWJzQZ9M9w4LpftpUEXWfaYPCBS3ZJvtZ
   JFcWPmstta2BWN8oatDinMdWKK+O1k+OJRLLq5Fl8C2k6+9d0bbNLZ4q+
   PRRhb6mkJvw+u6j/pJJ0TqN+GKxFVPF0K+Tn7SKNiwW4WWT5Q/fjJu7Jy
   r6ODMNYaApGJxAmsTCOQdjqclRK9IJ36VDgHN2d77SbrrCU9hYNVGLhKh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="242901613"
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="242901613"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 09:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="526970475"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2022 09:18:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-04-14
Date:   Thu, 14 Apr 2022 09:15:18 -0700
Message-Id: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Maciej adjusts implementation in __ice_alloc_rx_bufs_zc() for when
ice_fill_rx_descs() does not return the entire buffer request and fixes a
return value for !CONFIG_NET_SWITCHDEV configuration which was preventing
VF creation.

Wojciech prevents eswitch transmit when VFs are being removed which was
causing NULL pointer dereference.

Jianglei Nie fixes a memory leak on error path of getting OROM data.

The following are changes since commit 2df3fc4a84e917a422935cc5bae18f43f9955d31:
  net: bcmgenet: Revert "Use stronger register read/writes to assure ordering"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Jianglei Nie (1):
  ice: Fix memory leak in ice_get_orom_civd_data()

Maciej Fijalkowski (2):
  ice: xsk: check if Rx ring was filled up to the end
  ice: allow creating VFs for !CONFIG_NET_SWITCHDEV

Wojciech Drewek (1):
  ice: fix crash in switchdev mode

 drivers/net/ethernet/intel/ice/ice_eswitch.c | 3 ++-
 drivers/net/ethernet/intel/ice/ice_eswitch.h | 2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 7 ++++++-
 4 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.31.1

