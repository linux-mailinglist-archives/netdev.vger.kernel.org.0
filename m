Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0715BFF91
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIUOKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUOKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:10:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1735486FFE;
        Wed, 21 Sep 2022 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663769414; x=1695305414;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cHpJL1jDSaLbpUNmcyBnFjpVbyv9OT9XB+huC/h6uP8=;
  b=AFTCwRvQ+zWlvNHWusD3MxstWp8IoHBl7fDgpai1PHRF1CRwos0KPG4I
   tlWotrxc6L/2Pz6QNncCLuBoIb8abqCNb6znf3GnSj/RcUXpPwTgbG2z1
   iqoDRi6St//35Ea6PNjOcv4ToEzrx9zfCLqmlY7kxCfENW+vi2Tj267Mq
   fsnXN2Ygy3fBVsoIUL3Ej5bR+hFaQ7QpdkJf+SB4+T0GGc1VqtcCoTt8W
   ptGIiYKko6FRS8QBbLwwv6VpMSz+khnMS9xx5gAMcrZG3sa/yGU1yGPme
   mOPGXyT+ztf8L8M9e3Q0I5AM+0ZZT31tckSSoKsc33SIoClIpz6Nzkv7J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301412655"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="301412655"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 07:09:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="864437723"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 21 Sep 2022 07:09:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C3F2BF7; Wed, 21 Sep 2022 17:10:06 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] ptp_ocp: use device_find_any_child() instead of custom approach
Date:   Wed, 21 Sep 2022 17:10:05 +0300
Message-Id: <20220921141005.2443-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have already a helper to get the first child device, use it and
drop custom approach.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 83da36e69361..ebed0161879e 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1311,12 +1311,6 @@ ptp_ocp_read_eeprom(struct ptp_ocp *bp)
 	goto out;
 }
 
-static int
-ptp_ocp_firstchild(struct device *dev, void *data)
-{
-	return 1;
-}
-
 static struct device *
 ptp_ocp_find_flash(struct ptp_ocp *bp)
 {
@@ -1325,7 +1319,7 @@ ptp_ocp_find_flash(struct ptp_ocp *bp)
 	last = NULL;
 	dev = &bp->spi_flash->dev;
 
-	while ((dev = device_find_child(dev, NULL, ptp_ocp_firstchild))) {
+	while ((dev = device_find_any_child(dev))) {
 		if (!strcmp("mtd", dev_bus_name(dev)))
 			break;
 		put_device(last);
-- 
2.35.1

