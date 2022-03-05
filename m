Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32A34CE3B0
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiCEIz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCEIz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:55:27 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5A124A137;
        Sat,  5 Mar 2022 00:54:36 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K9dhG5jcSzbbwp;
        Sat,  5 Mar 2022 16:49:50 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 5 Mar 2022 16:54:34 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 5 Mar
 2022 16:54:34 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>, <karol.kolacinski@intel.com>
Subject: [PATCH -next] ice: fix return value check in ice_gnss.c
Date:   Sat, 5 Mar 2022 17:04:30 +0800
Message-ID: <20220305090430.3078757-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kthread_create_worker() and tty_alloc_driver() return ERR_PTR()
and never return NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 755e1580f368..35579cf4283f 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -125,7 +125,7 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
 	 * writes.
 	 */
 	kworker = kthread_create_worker(0, "ice-gnss-%s", dev_name(dev));
-	if (!kworker) {
+	if (IS_ERR(kworker)) {
 		kfree(gnss);
 		return NULL;
 	}
@@ -253,7 +253,7 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	int err;
 
 	tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW);
-	if (!tty_driver) {
+	if (IS_ERR(tty_driver)) {
 		dev_err(ice_pf_to_dev(pf), "Failed to allocate memory for GNSS TTY\n");
 		return NULL;
 	}
-- 
2.25.1

