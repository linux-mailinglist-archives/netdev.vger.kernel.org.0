Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F636CFE98
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjC3Ikz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjC3Ikx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:40:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FCB5B92;
        Thu, 30 Mar 2023 01:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680165652; x=1711701652;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E/3JzKj/ftYcVD0rt0pT36PrSlnk43aIECQPEWDRFIQ=;
  b=JzOZt2KAvux5JvhmzLaD49g9OsmPW1NlqS614U/OhUtOKB0ucZmwGVZb
   DQM0qYQ261UnYGAKP6QYC+jxAmbesyRwBuLWy/f8CPV0woDtn8apC0/PP
   XvuLiybS6AEOqRp/uCSziOSvQGYLJrAkiXCRi9U4mnt6gvM+53ykOnwz7
   Bmsj9Rl4nZdNaVEyCOvNYfiXh71eF0Y8ZGdMACBd2mAtv7jy74HjPfhxf
   dsGlzedwvC961EtrystnMTBFzD3333Wr9JyV+cJvb/evW30WneRY3F1Yv
   dkuUfqZ1AKdoQlclVoq6Uxg0QQ6RzZxCY617n55me/f5WSCrD0E9xc7TT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="343559359"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="343559359"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 01:40:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684618810"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="684618810"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga002.jf.intel.com with ESMTP; 30 Mar 2023 01:40:46 -0700
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
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v4 0/3]  Fix PHY handle no longer parsing
Date:   Thu, 30 Mar 2023 16:39:57 +0800
Message-Id: <20230330084000.3292487-1-michael.wei.hong.sit@intel.com>
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

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c   |  1 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   |  4 +++-
 drivers/net/phy/phylink.c                       | 17 +++++++++++++++++
 include/linux/phylink.h                         |  1 +
 4 files changed, 21 insertions(+), 2 deletions(-)

v2: Initialize fwnode before using the variable
v3: Introduced phylink_expects_phy() method as suggested by Russell King
    remove xpcs_an_inband fixup instead of moving the fixed-link check
    as suggested by Andrew Lunn
v4: Modify phylink_expects_phy() to check for more complete set of
    conditions when no PHY is needed and return false if met.
-- 
2.34.1

