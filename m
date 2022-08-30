Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21215A677D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiH3PdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiH3Pc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:32:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCE2155D57;
        Tue, 30 Aug 2022 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661873577; x=1693409577;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ELYRSkSj3v+VRtzRmWlCHo5Qj7Ik37akWpVFF+yCXiI=;
  b=bCiYvWyhgt9dmXTEHgDWcLdfDswe2LBuAowH46TAV57RxHl9BzkDjoxJ
   0WojVAbP6UCe1p6byFiIf5/UUNVNc1YpYxcfjGDvb+wdaCIvqXwfT8ivv
   w67MzZRLXsnqYCe9DOb+R4+a1Ciq/jZ/V6pXwhdVB1x1JG1d/9MxNHO/o
   5+Qtp8rF7sq2WN43RFbl0/wmI4NsVsM6wa8us5hcg0uwzCa+aSPR/Qvg5
   Mlis6vUeIWO1eCHd2FvSAfEzIe9d56w8Y55CJqhx3RR8c6xJ7/C0WxvEu
   j+7+arw3HBRxat9WA11rlo913WBDVhH2hR+f2KMtPUQDa9zUHqMqur33L
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295990324"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295990324"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 08:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="715339370"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 30 Aug 2022 08:32:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 1CF1FAD; Tue, 30 Aug 2022 18:32:50 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: [PATCH 0/5] thunderbolt: net: Enable full end-to-end flow control
Date:   Tue, 30 Aug 2022 18:32:45 +0300
Message-Id: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Thunderbolt/USB4 host controllers support full end-to-end flow control
that prevents dropping packets if there are not enough hardware receive
buffers. So far it has not been enabled for the networking driver yet
but this series changes that. There is one snag though: the second
generation (Intel Falcon Ridge) had a bug that needs special quirk to
get it working. We had that in the early stages of the Thunderbolt/USB4
driver but it got dropped because it was not needed at the time. Now we
add it back as a quirk for the host controller (NHI).

The first patch of this series is a bugfix that I'm planning to push for
v6.0-rc. Rest are v6.1 material. This also includes a patch that shows
the XDomain link type in sysfs the same way we do for USB4 routers and
updates the networking driver module description.

Mika Westerberg (5):
  net: thunderbolt: Enable DMA paths only after rings are enabled
  thunderbolt: Show link type for XDomain connections too
  thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
  net: thunderbolt: Enable full end-to-end flow control
  net: thunderbolt: Update module description with mention of USB4

 drivers/net/thunderbolt.c       | 62 +++++++++++++++++++++------------
 drivers/thunderbolt/nhi.c       | 49 ++++++++++++++++++++++----
 drivers/thunderbolt/tb.c        |  8 ++---
 drivers/thunderbolt/tb.h        |  2 +-
 drivers/thunderbolt/usb4.c      |  8 +++--
 drivers/thunderbolt/usb4_port.c |  2 ++
 include/linux/thunderbolt.h     |  2 ++
 7 files changed, 96 insertions(+), 37 deletions(-)

-- 
2.35.1

