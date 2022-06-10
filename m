Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A25545A34
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 04:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiFJClC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 22:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243115AbiFJClA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 22:41:00 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF135168D3D
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 19:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=91ux5
        kPCoAamyvRVP7GYhUZHehWVrxoVsAQMzUFDlOg=; b=nh8IXWmkLuJv6B55c+GLN
        3NaOxRpisUQUB9ANqLqaW35T7mjbG9yzcQEAVdfPORqgw92Ihu5Qqkq2i1zIA+io
        SQINq7+d2CIW06nhbF5ker7l2IFJodM3v4eHzcEunCXDMMjGRuZZJhA4iRiuYbx+
        bo+Kx0NgLchZiPsUo6/KjA=
Received: from localhost.localdomain (unknown [117.136.33.145])
        by smtp2 (Coremail) with SMTP id DMmowABHTwPvrqJiJk9+Cw--.18883S2;
        Fri, 10 Jun 2022 10:39:44 +0800 (CST)
From:   Lixue Liang <lianglixuehao@126.com>
To:     pmenzel@molgen.mpg.de
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v6] igb: Assign random MAC address instead of fail in case of invalid one
Date:   Fri, 10 Jun 2022 02:39:22 +0000
Message-Id: <20220610023922.74892-1-lianglixuehao@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowABHTwPvrqJiJk9+Cw--.18883S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw1ruFWxAr17AFy7Gr15Arb_yoW5Xw1kpa
        yUJa43XrWkJr4avaykXw48XFy5CayDJ3y5CFZxZw1F9FnIqw1DArW8t347Xry0grWvka1x
        Jr17Zrs7ua1DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-kucUUUUU=
X-Originating-IP: [117.136.33.145]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbiohccFlx5hnOT2QABsk
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lixue Liang <lianglixue@greatwall.com.cn>

Add the module parameter "allow_invalid_mac_address" to control the
behavior. When set to true, a random MAC address is assigned, and the
driver can be loaded, allowing the user to correct the invalid MAC address.

Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
---
Changelog:
* v6:
  - Modify commit messages and naming of module parameters
Suggested-by Paul <pmenzel@molgen.mpg.de>
* v5:
  - Through the setting of module parameters, it is allowed to complete
    the loading of the igb network card driver with an invalid MAC address.
Suggested-by <alexander.duyck@gmail.com>
* v4:
  - Change the igb_mian in the title to igb
  - Fix dev_err message: replace "already assigned random MAC address"
    with "Invalid MAC address. Assigned random MAC address"
Suggested-by Tony <anthony.l.nguyen@intel.com>

* v3:
  - Add space after comma in commit message
  - Correct spelling of MAC address
Suggested-by Paul <pmenzel@molgen.mpg.de>

* v2:
  - Change memcpy to ether_addr_copy
  - Change dev_info to dev_err
  - Fix the description of the commit message
  - Change eth_random_addr to eth_hw_addr_random
Reported-by: kernel test robot <lkp@intel.com>

 drivers/net/ethernet/intel/igb/igb_main.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..b61f216331da 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -238,8 +238,11 @@ MODULE_LICENSE("GPL v2");
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
+static bool allow_invalid_mac_address;
 module_param(debug, int, 0);
+module_param(allow_invalid_mac_address, bool, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
+MODULE_PARM_DESC(allow_invalid_mac_address, "Allow NIC driver to be loaded with invalid MAC address");
 
 struct igb_reg_info {
 	u32 ofs;
@@ -3359,9 +3362,16 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		dev_err(&pdev->dev, "Invalid MAC Address\n");
-		err = -EIO;
-		goto err_eeprom;
+		if (!allow_invalid_mac_address) {
+			dev_err(&pdev->dev, "Invalid MAC address\n");
+			err = -EIO;
+			goto err_eeprom;
+		} else {
+			eth_hw_addr_random(netdev);
+			ether_addr_copy(hw->mac.addr, netdev->dev_addr);
+			dev_err(&pdev->dev,
+				"Invalid MAC address. Assigned random MAC address\n");
+		}
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

