Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3754C64B0F5
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiLMIVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiLMIVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:21:15 -0500
X-Greylist: delayed 1923 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 00:21:12 PST
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A50910070;
        Tue, 13 Dec 2022 00:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=5ip81
        +wNz5xtBTBVts1Fb1RLCzaC6pg2EyPJm4Juic8=; b=Vfd8zv4SXPKww+w/McsNX
        5Xe8D4dghgGyhdEz0O8lP9FbjAdufk42luNx6/r3tJ5l4H6Sw+lewSFHZthIbMPe
        Q/FAmvPEXAHfoLF+knQ9+Yz9Qqs5yuvI2a8WCU/USvbjg+NCHeho25XqiE6iUAxf
        j9QRdg0UlHj3yBaixrAFwk=
Received: from localhost.localdomain (unknown [223.104.64.131])
        by zwqz-smtp-mta-g0-1 (Coremail) with SMTP id _____wDXNYROLphj12MGAA--.16034S2;
        Tue, 13 Dec 2022 15:48:31 +0800 (CST)
From:   Lixue Liang <lianglixuehao@126.com>
To:     anthony.l.nguyen@intel.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        lianglixue@greatwall.com.cn, kernel test robot <lkp@intel.com>
Subject: [PATCH v7] igb: Assign random MAC address instead of fail in case of invalid one
Date:   Tue, 13 Dec 2022 07:47:26 +0000
Message-Id: <20221213074726.51756-1-lianglixuehao@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDXNYROLphj12MGAA--.16034S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw1ruFWxAr17Ar43tF4xJFb_yoW5uF4Upa
        y0gF43Wryktr47Zw4kWw4xZF95W3WDJ3yfGa9xZw1F9FnIv34DArW8K343Jry0qrZYkayx
        Jr17ZFZ7ua1qva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UmZXwUUUUU=
X-Originating-IP: [223.104.64.131]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/xtbBGgnWFl-HaR-tlAAAsE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
* v7:
  - To group each parameter together
Suggested-by Tony Nguyen <anthony.l.nguyen@intel.com>
* v6:
  - Modify commit messages and naming of module parameters
  - [PATCH v6] link:
    https://lore.kernel.org/netdev/20220610023922.74892-1-lianglixuehao@126.com/
Suggested-by Paul <pmenzel@molgen.mpg.de>
* v5:
  - Through the setting of module parameters, it is allowed to complete
    the loading of the igb network card driver with an invalid MAC address.
  - [PATCH v5] link:
    https://lore.kernel.org/netdev/20220609083904.91778-1-lianglixuehao@126.com/
Suggested-by <alexander.duyck@gmail.com>
* v4:
  - Change the igb_mian in the title to igb
  - Fix dev_err message: replace "already assigned random MAC address"
    with "Invalid MAC address. Assigned random MAC address"
  - [PATCH v4] link:
    https://lore.kernel.org/netdev/20220601150428.33945-1-lianglixuehao@126.com/
Suggested-by Tony <anthony.l.nguyen@intel.com>

* v3:
  - Add space after comma in commit message
  - Correct spelling of MAC address
  - [PATCH v3] link:
    https://lore.kernel.org/netdev/20220530105834.97175-1-lianglixuehao@126.com/
Suggested-by Paul <pmenzel@molgen.mpg.de>

* v2:
  - Change memcpy to ether_addr_copy
  - Change dev_info to dev_err
  - Fix the description of the commit message
  - Change eth_random_addr to eth_hw_addr_random
  - [PATCH v2] link:
    https://lore.kernel.org/netdev/20220512093918.86084-1-lianglixue@greatwall.com.cn/
Reported-by: kernel test robot <lkp@intel.com>

 drivers/net/ethernet/intel/igb/igb_main.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f8e32833226c..8ff0c698383c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -241,6 +241,10 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
+static bool allow_invalid_mac_address;
+module_param(allow_invalid_mac_address, bool, 0);
+MODULE_PARM_DESC(allow_invalid_mac_address, "Allow NIC driver to be loaded with invalid MAC address");
+
 struct igb_reg_info {
 	u32 ofs;
 	char *name;
@@ -3358,9 +3362,16 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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

