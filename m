Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1967414A55
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhIVNRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:17:36 -0400
Received: from mx22.baidu.com ([220.181.50.185]:39452 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229923AbhIVNRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:17:36 -0400
Received: from BC-Mail-Ex24.internal.baidu.com (unknown [172.31.51.18])
        by Forcepoint Email with ESMTPS id 3FED0F5F84628F0995FA;
        Wed, 22 Sep 2021 20:59:54 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex24.internal.baidu.com (172.31.51.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 22 Sep 2021 20:59:53 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 22 Sep 2021 20:59:53 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ice: Make use of the helper function devm_add_action_or_reset()
Date:   Wed, 22 Sep 2021 20:59:46 +0800
Message-ID: <20210922125947.480-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex31.internal.baidu.com (172.31.51.25) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper function devm_add_action_or_reset() will internally
call devm_add_action(), and if devm_add_action() fails then it will
execute the action mentioned and return the error code. So
use devm_add_action_or_reset() instead of devm_add_action()
to simplify the error handling, reduce the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 14afce82ef63..f9d8410f29ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -482,10 +482,8 @@ struct ice_pf *ice_allocate_pf(struct device *dev)
 		return NULL;
 
 	/* Add an action to teardown the devlink when unwinding the driver */
-	if (devm_add_action(dev, ice_devlink_free, devlink)) {
-		devlink_free(devlink);
+	if (devm_add_action_or_reset(dev, ice_devlink_free, devlink))
 		return NULL;
-	}
 
 	return devlink_priv(devlink);
 }
-- 
2.25.1

