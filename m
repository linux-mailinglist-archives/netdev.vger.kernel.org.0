Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30653A991
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347454AbiFAPGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 11:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353471AbiFAPGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 11:06:03 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 891CD5DE58
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 08:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=HWtXy
        zpTYQi99vLNSN4B9mSWTWB3vA617XDlC71beEg=; b=REGwHbh2ta/WGQSkYIACC
        gSL3byjExvI15fyOzkdsCZNZ7qpTvwJZp8NZt741HlPEN2W+k5rnqHtZYEL4/FgV
        2z/Y8Z/BWyHpjnMoLoYsRMlsjuGnM4+kaJTt1Kq0iVi06L/WAkhUUTeBhtn9XXHW
        maDm0qIxrOMnI4Y/w76VfA=
Received: from localhost.localdomain (unknown [223.104.68.68])
        by smtp7 (Coremail) with SMTP id DsmowAC3mKT9f5dis3x_CQ--.20151S2;
        Wed, 01 Jun 2022 23:04:30 +0800 (CST)
From:   Lixue Liang <lianglixuehao@126.com>
To:     pmenzel@molgen.mpg.de
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
Subject: [PATCH v4] igb: Assign random MAC address instead of fail in case of invalid one
Date:   Wed,  1 Jun 2022 15:04:28 +0000
Message-Id: <20220601150428.33945-1-lianglixuehao@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowAC3mKT9f5dis3x_CQ--.20151S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFW3Ww4xGFW3KrWrAFyxZrb_yoW8Zw1Upa
        yrJa42grWkJr4jqw4kX3WxZas0kan0q345C39Iyw1F93Z0grWDArWrtry7tryrKrZ5Ca13
        Zr17Za1Dua1DAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jU0edUUUUU=
X-Originating-IP: [223.104.68.68]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/xtbBGggTFl-HZMgquAAAsx
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

In some cases, when the user uses igb_set_eeprom to modify the MAC
address to be invalid, the igb driver will fail to load. If there is no
network card device, the user must modify it to a valid MAC address by
other means.

Since the MAC address can be modified, then add a random valid MAC address
to replace the invalid MAC address in the driver can be workable, it can
continue to finish the loading, and output the relevant log reminder.

Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
---
Changelog:
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

 drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..5e3b162e50ac 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		dev_err(&pdev->dev, "Invalid MAC Address\n");
-		err = -EIO;
-		goto err_eeprom;
+		eth_hw_addr_random(netdev);
+		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
+		dev_err(&pdev->dev,
+			"Invalid MAC address. Assigned random MAC address\n");
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

