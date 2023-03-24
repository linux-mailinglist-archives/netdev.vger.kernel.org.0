Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46B96C7977
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjCXIRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCXIRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:17:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7244918AB9;
        Fri, 24 Mar 2023 01:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679645857; x=1711181857;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uYiuGbXVPcmzIv1+ZIORk/VpkKy9DBccDcXlcJ5iQFM=;
  b=JJX3voiSRZUHxH1osOdKZfs2yj9XB7uF8IMuRJ/yvxyBbpxb5PEhV2Op
   cl08Uwh0M+yMWeB0M7C4P0Zr1jhpO/v+q7Y6s6QGyQrjrNynwmg3HqYl+
   d2KiY3GCjdFOOcmjk9RnJxBMbfd/kU7t01S44tLzVAp80A9b7qx5HuSEM
   8ONFIlN4OrCwDrubRO0M1mcem9YJOs1ohfinTaULCJpIwIlL+RnLkeSne
   wHZWSgckoryYmNTmyWqM2DVsHL4ldRUk9buO8wo0PSDJ3CElK0wyheLs4
   F7jQZqgPqwbHa7qekgopyMuSIPEU5b4OCmM3qSCVslbAbJ8MFi1tTGJ/M
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="320116055"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="320116055"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 01:17:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="928574687"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="928574687"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga006.fm.intel.com with ESMTP; 24 Mar 2023 01:17:33 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v3 0/3] Fix PHY handle no longer parsing
Date:   Fri, 24 Mar 2023 16:16:53 +0800
Message-Id: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=AC_FROM_MANY_DOTS,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the fixed link support was introduced, it is observed that PHY
no longer attach to the MAC properly. So we introduce a helper
function to determine if the MAC should expect to connect to a PHY
and proceed accordingly.

Michael Sit Wei Hong (3):
  net: phylink: add phylink_expects_phy() method
  net: stmmac: check if MAC needs to attach to a PHY
  net: stmmac: remove redundant fixup to support fixed-link mode

 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |  1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +++-
 drivers/net/phy/phylink.c                         | 13 +++++++++++++
 include/linux/phylink.h                           |  1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

v2: Initialize fwnode before using the variable
v3: Introduced phylink_expects_phy() method as suggested by Russell King
    remove xpcs_an_inband fixup instead of moving the fixed-link check
    as suggested by Andrew Lunn
-- 
2.34.1

