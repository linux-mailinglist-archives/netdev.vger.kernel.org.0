Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D0F542FA8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiFHMEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238557AbiFHMEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:04:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DCE1A89B9;
        Wed,  8 Jun 2022 05:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654689839; x=1686225839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ehcThqPPJkr7iIdF60kt5vvA2SeRoEoSO1WpbnPOAM=;
  b=QIDNvniuG4dH6N3eHbw3pOW6Ywbhm31QQh157z7HDSv9lXCf9x/wqIEk
   LweNvBmU5q3dJoEJgOGaFyY0TDZQ1ai3Xa6exbYpHYDx9JBPl6lAs2B6C
   Cx/QaiklEOIWOxsEDonF1LVacxUjq2AYKDg32pe5NOp8E+Vo64OEhyqH7
   BCYg7KWmiAeXNhur/E4lUW+fjbR0ooI97m1T3ElpvsP7NkwajK77bYdb1
   6aNmjiE+NoDxuBwQs8hJp49WhMnQNwywsIlDPAKxoMx7LuuW8sTgj5C7q
   FEpoLd3o1tZErxl3y9jM18LslKM9ul+YSnyrv7UwXFhJ8AaUg4syT+g6L
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256701614"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="256701614"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="533067581"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 08 Jun 2022 05:03:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id CAE14450; Wed,  8 Jun 2022 15:03:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 net-next 4/5] ptp_ocp: do not call pci_set_drvdata(pdev, NULL)
Date:   Wed,  8 Jun 2022 15:03:57 +0300
Message-Id: <20220608120358.81147-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleaning up driver data is actually already handled by driver core,
so there is no need to do it manually.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4e237f806085..857e35c68a04 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3769,7 +3769,6 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out:
 	ptp_ocp_detach(bp);
-	pci_set_drvdata(pdev, NULL);
 out_disable:
 	pci_disable_device(pdev);
 out_free:
@@ -3785,7 +3784,6 @@ ptp_ocp_remove(struct pci_dev *pdev)
 
 	devlink_unregister(devlink);
 	ptp_ocp_detach(bp);
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 
 	devlink_free(devlink);
-- 
2.35.1

