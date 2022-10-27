Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D35560FA10
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiJ0OEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiJ0OEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:04:39 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E106313D29
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:04:33 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MynNn1fPzz15Lwn;
        Thu, 27 Oct 2022 21:59:37 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 22:04:30 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>,
        <sebastian.reichel@collabora.com>, <peda@axentia.se>,
        <khalasa@piap.pl>, <kuba@kernel.org>,
        <u.kleine-koenig@pengutronix.de>, <michael@walle.cc>,
        <sameo@linux.intel.com>, <robert.dolca@intel.com>,
        <clement.perrochaud@nxp.com>, <r.baldyga@samsung.com>,
        <cuissard@marvell.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 0/4] nfc: Fix potential memory leak of skb
Date:   Thu, 27 Oct 2022 22:03:28 +0800
Message-ID: <20221027140332.18336-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 6 kinds of send functions can be called by nci_send_frame():
	virtual_nci_send(),
	fdp_nci_send(),
	nxp_nci_send(),
	s3fwrn5_nci_send(),
	nfcmrvl_nci_send(),
	st_nci_send();

1. virtual_nci_send() will memleak the skb, and has been fixed before.

2. fdp_nci_send() won't free the skb no matter whether write() succeed.

3-4. nxp_nci_send() and s3fwrn5_nci_send() will only free the skb when
write() failed, however write() will not free the skb by itself for when
succeeds.

5. nfcmrvl_nci_send() will call nfcmrvl_XXX_nci_send(), where some of
them will free the skb, but nfcmrvl_i2c_nci_send() only free the skb
when i2c_master_send() return >=0, and memleak will happen when
i2c_master_send() failed in nfcmrvl_i2c_nci_send().

6. st_nci_send() will queue the skb into other list and finally be
freed.

Fix the potential memory leak of skb.

Shang XiaoJing (4):
  nfc: fdp: Fix potential memory leak in fdp_nci_send()
  nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
  nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
  nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

 drivers/nfc/fdp/fdp.c      | 10 +++++++++-
 drivers/nfc/nfcmrvl/i2c.c  |  7 ++++++-
 drivers/nfc/nxp-nci/core.c |  7 +++++--
 drivers/nfc/s3fwrn5/core.c |  8 ++++++--
 4 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.17.1

