Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD153E328C
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 03:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhHGBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 21:16:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:44926 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhHGBQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 21:16:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214197872"
X-IronPort-AV: E=Sophos;i="5.84,301,1620716400"; 
   d="scan'208";a="214197872"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 18:16:12 -0700
X-IronPort-AV: E=Sophos;i="5.84,301,1620716400"; 
   d="scan'208";a="669719516"
Received: from yuhshiua-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.8.244])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 18:16:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        richardcochran@gmail.com, davem@davemloft.net, yangbo.lu@nxp.com
Subject: [PATCH net v1] ptp: Fix possible memory leak caused by invalid cast
Date:   Fri,  6 Aug 2021 18:15:46 -0700
Message-Id: <20210807011546.1400747-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes possible leak of PTP virtual clocks.

The number of PTP virtual clocks to be unregistered is passed as
'u32', but the function that unregister the devices handles that as
'u8'.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
I am calling this "possible" because I only saw that while taking a
look at the code, i.e. I didn't reproduce it. 


 drivers/ptp/ptp_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index b3d96b747292..41b92dc2f011 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -154,7 +154,7 @@ static int unregister_vclock(struct device *dev, void *data)
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
 	struct ptp_clock_info *info = ptp->info;
 	struct ptp_vclock *vclock;
-	u8 *num = data;
+	u32 *num = data;
 
 	vclock = info_to_vclock(info);
 	dev_info(dev->parent, "delete virtual clock ptp%d\n",
-- 
2.32.0

