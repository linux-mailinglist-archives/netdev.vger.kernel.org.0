Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0ED1544637
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiFIInG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242359AbiFIIlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:41:01 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C9AB1A809
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=TTVHM
        YekiVzHqVSZZqlsEXzEIs7mbYbLei3TTp2AbsY=; b=XioNkFUgJEn/eZayWzv7M
        XOJJ2+Y8+3Sukxjc2zdNBckBVwrA3t82OiT+gdLAqpL6bhXSyVQKPSPVkmve9QiK
        WAFs4pPQM2MKo9V8O+IdrGxlXCcNITas/XDJIQWdSEbbOvjAKAuxXzvUZMfERz6S
        jESiYXby/WJf4D16FkNTr0=
Received: from localhost.localdomain (unknown [223.104.63.29])
        by smtp2 (Coremail) with SMTP id DMmowADX3wO+saFiyuE9Cw--.2894S2;
        Thu, 09 Jun 2022 16:39:28 +0800 (CST)
From:   Lixue Liang <lianglixuehao@126.com>
To:     pmenzel@molgen.mpg.de
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
Subject: [PATCH v5] igb: Assign random MAC address instead of fail in case of invalid one
Date:   Thu,  9 Jun 2022 08:39:04 +0000
Message-Id: <20220609083904.91778-1-lianglixuehao@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowADX3wO+saFiyuE9Cw--.2894S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrWUuw1kKrWkGry8CFW3KFg_yoW5Aw13pa
        yUJayaqrykJr42q3ykXw48Xa45Ca4qqw45CrZxAw1F9Fn0qr4DArW8try7tryrGrWkCa17
        tr17ZFsrua1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8HUDUUUUU=
X-Originating-IP: [223.104.63.29]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbizgcbFl8RPQHANAABsD
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

In some cases, when the user uses igb_set_eeprom to modify the MAC address
to be invalid, or an invalid MAC address appears when with uninitialized
samples, the igb driver will fail to load. If there is no network card
device, the user could not conveniently modify it to a valid MAC address,
for example using ethtool to modify.

Through module parameter to set，when the MAC address is invalid, a random
valid MAC address can be used to continue loading and output relevant log
reminders. In this way, users can conveniently correct invalid MAC address.

Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
---
Changelog:
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
index 34b33b21e0dc..8162e8999ccb 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -238,8 +238,11 @@ MODULE_LICENSE("GPL v2");
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
+static unsigned int invalid_mac_address_allow;
 module_param(debug, int, 0);
+module_param(invalid_mac_address_allow, uint, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
+MODULE_PARM_DESC(invalid_mac_address_allow, "Allow NIC driver to be loaded with invalid MAC address");
 
 struct igb_reg_info {
 	u32 ofs;
@@ -3359,9 +3362,16 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		dev_err(&pdev->dev, "Invalid MAC Address\n");
-		err = -EIO;
-		goto err_eeprom;
+		if (!invalid_mac_address_allow) {
+			dev_err(&pdev->dev, "Invalid MAC Address\n");
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

