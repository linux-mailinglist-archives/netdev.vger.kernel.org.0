Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375A757D4C9
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiGUUbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGUUbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:31:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1301F9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658435507; x=1689971507;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4g8fwzM/UGELCADnzaHMl8HH6MgxDydj9FSxAcyUb8M=;
  b=kF6mrpF3ZvoVf9/BB17yyNtPnvTv9xOkUYq8BFlpcUG6c1VTJEA66RVT
   ElGWAZtNoDPLCY28rII52+uS5RuTUvyIDRUlwvp2aXPTNaNOFa/7WNhTX
   Qbk1md5rrgFSP3r0tHfVosdIVnH+0cMdLAwdRkN0kSYIjMs0gFi43OuzF
   2DmHn61QTxN8qcKBqYYbODxHI+R6c5xrTPpj6pNqPe3zlFLmBn3qtrf24
   Lk02neyxBIjssm/NpEeGxiTPRR69XfupyE9GRlmNywDuuCIqlM+Cpgkks
   zOX/fXJMHF8YdlUs8U71qkVoEFs/Z7mR5ZpwxzHFRI/ZcBL3uIG/HneoK
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="266941692"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="266941692"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 13:31:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="666432310"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2022 13:31:46 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net-next v2 0/2][pull request] 100GbE Intel Wired LAN Driver Updates 2022-07-21
Date:   Thu, 21 Jul 2022 13:28:40 -0700
Message-Id: <20220721202842.3276257-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Karol adds implementation for GNSS write; data is written to the GNSS
module through TTY device using u-blox UBX protocol.
---
v2:
- Replace looped copy with memcpy() in ice_aq_write_i2c()
- Adjust goto/return in ice_gnss_do_write() for readability
- Add information to documentation
- Drop, previous, patch 1; it was already accepted in another pull
request.

The following are changes since commit 5588d628027092e66195097bdf6835ddf64418b3:
  net/cdc_ncm: Increase NTB max RX/TX values to 64kb
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Karol Kolacinski (2):
  ice: add i2c write command
  ice: add write functionality for GNSS TTY

 .../device_drivers/ethernet/intel/ice.rst     |   9 +
 drivers/net/ethernet/intel/ice/ice.h          |   4 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   7 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  47 +++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 242 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  30 ++-
 7 files changed, 308 insertions(+), 35 deletions(-)

-- 
2.35.1

