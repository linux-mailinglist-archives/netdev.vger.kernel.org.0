Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3B5AEC2C
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241866AbiIFOW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241286AbiIFOUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:20:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0C68D3CA;
        Tue,  6 Sep 2022 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472309; x=1694008309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rwhdBcttY6XbD0bTBSztCf3q0tCwh4tn8f0UydnY7uY=;
  b=dJiNbaLATGiVMCJu3YKLSZl9dsxrXXAlkaicDUSefSUXQ1tS2BrXU2+D
   YJls9ih4v28PLutdS4ejeGEcr4pBryKxxMvMiyN1WrL1Yxt7ucu6cHgEq
   K7MAL6fWyfrP4jZaNSQhbuTR80SV/BzKsKlEDpNrEgTYG+0hXC1I9asR6
   agTHw24wCNbe8cwrZGJIA91Hfey/3pJX1LZdb94UOuc0issEsoraKtEO7
   2BlCInROWXhQv3VrdjLg2WayVGxxk9M3KyiDMMvctIfQ39L/eCpnOeN1l
   lGYEXD0dFaYioiHjrDJ5i6ivq4pwS1JgsD+CcCZ7Tsv0MhwKdID/WrNqA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="297908818"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="297908818"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:50:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="756372521"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 06 Sep 2022 06:49:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 49DEC235; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
Subject: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Date:   Tue,  6 Sep 2022 16:49:53 +0300
Message-Id: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Changelog v3:
- added tag to patch 11 (Kurt)
- Cc'ed to Lee, who might help with LED subsystem maintenance

Changelog v2:
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

