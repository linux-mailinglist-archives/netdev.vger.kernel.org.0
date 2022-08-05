Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334CE58ADA4
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiHEPwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbiHEPvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312D56AA26;
        Fri,  5 Aug 2022 08:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659714564; x=1691250564;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gqNuEVUhBCL0H7kHU+gOp/djo7FF1HWO1qrDMH826Oo=;
  b=efHFobDQCo2p4/Zd0IIKCI87IT2mMVtEm0gUPgsamMQqAA9atZLNjRO8
   S/gIBNQUmQ3IdyicXpWfUrsiWFSVjmx8WyBYo9Te+CcBJWtYmcTJO/Scc
   U32GQq72KA5kEU85HAP/kZDWWfRGSMit9FE5WtrmTkypliAGsQDxNWtrr
   7aYh0UmpQsZ0Ff9x2nvTnnyILs/eN7nKZDYwDwB5yiB7jNHLyiALtJZjB
   QnK0JMLs//WKxylsb+dd/CVQ/Of8qYYvzCW/Hyjzur2dQ2aLPhxEBrZCz
   m2sjk21zdjDSESEylIHauT9LRHd1YECYWuE2+SWiZEJBatQD0MoK7010Z
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="288988400"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="288988400"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 08:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="693037565"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Aug 2022 08:49:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 899CAF7; Fri,  5 Aug 2022 18:49:16 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Eddie James <eajames@linux.ibm.com>,
        Denis Osterland-Heim <Denis.Osterland@diehl.com>,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 00/11] leds: deduplicate led_init_default_state_get()
Date:   Fri,  5 Aug 2022 18:48:56 +0300
Message-Id: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several users of LED framework that reimplement the
functionality of led_init_default_state_get(). In order to 
deduplicate them move the declaration to the global header
(patch 2) and convert users (patche 3-11).

Chnagelog v2:
- added missed patch 2 and hence make it the series
- appended tag to patch 7
- new patch 1

Andy Shevchenko (11):
  leds: add missing includes and forward declarations in leds.h
  leds: Move led_init_default_state_get() to the global header
  leds: an30259a: Get rid of custom led_init_default_state_get()
  leds: bcm6328: Get rid of custom led_init_default_state_get()
  leds: bcm6358: Get rid of custom led_init_default_state_get()
  leds: mt6323: Get rid of custom led_init_default_state_get()
  leds: mt6360: Get rid of custom led_init_default_state_get()
  leds: pca955x: Get rid of custom led_init_default_state_get()
  leds: pm8058: Get rid of custom led_init_default_state_get()
  leds: syscon: Get rid of custom led_init_default_state_get()
  net: dsa: hellcreek: Get rid of custom led_init_default_state_get()

 drivers/leds/flash/leds-mt6360.c           | 38 +++--------------
 drivers/leds/leds-an30259a.c               | 21 ++--------
 drivers/leds/leds-bcm6328.c                | 49 +++++++++++-----------
 drivers/leds/leds-bcm6358.c                | 32 +++++++-------
 drivers/leds/leds-mt6323.c                 | 30 ++++++-------
 drivers/leds/leds-pca955x.c                | 26 +++---------
 drivers/leds/leds-pm8058.c                 | 29 ++++++-------
 drivers/leds/leds-syscon.c                 | 49 ++++++++++------------
 drivers/leds/leds.h                        |  1 -
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++----------
 include/linux/leds.h                       | 15 ++++---
 11 files changed, 143 insertions(+), 192 deletions(-)

-- 
2.35.1

