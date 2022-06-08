Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE84A542FA9
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbiFHMEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238591AbiFHMEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:04:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F1412296A;
        Wed,  8 Jun 2022 05:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654689840; x=1686225840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7mwdJlzZnKa7PggcpT5MZpyo4vsvD9fXoagVYkh/obk=;
  b=fZWKYlmHKRWFaMbKa1Xy7BZY0EULjp3C+mN3FwWZ/l4DGGSZ11yTGa9h
   9tnuJFR/oFuwh6HC92klrDDWu/hutnSB0yt7IwDQLKR2doZ0vu9+T/t1O
   Y/LSXent88KHl6c/h3EJ0fgkrUoDDhi2K30EHnZTGwCY7RMEiy3RxTrrE
   k6Qm0mizTnnPJJHZc5kFftNESmdObvW0MMBeLdmt0vX8x3K+Sstjb+/wr
   gfVBcWSJc2S5/Y1L5FfOIjC5Mn5UMpY8MV4t/AtOD/+aY27CJuut/4Tjf
   52qYZeM1M35Qk2rcrmdJjRLYumxOVMm4P6I7AplQqBu2RN4R5u7ExNVnW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="265675615"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="265675615"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:04:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670517792"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:03:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D901056B; Wed,  8 Jun 2022 15:03:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 net-next 5/5] ptp_ocp: replace kzalloc(x*y) by kcalloc(y, x)
Date:   Wed,  8 Jun 2022 15:03:58 +0300
Message-Id: <20220608120358.81147-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While here it may be no difference, the kcalloc() has some checks
against overflow and it's logically correct to call it for an array.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 857e35c68a04..83da36e69361 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2155,7 +2155,7 @@ ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
 	struct ptp_pin_desc *config;
 	int i;
 
-	config = kzalloc(sizeof(*config) * 4, GFP_KERNEL);
+	config = kcalloc(4, sizeof(*config), GFP_KERNEL);
 	if (!config)
 		return -ENOMEM;
 
-- 
2.35.1

