Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFE1537984
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiE3K7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbiE3K7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:59:04 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B67445640F
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 03:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=sF0xs
        3i6VUMYYdYuJHXE3WrD0C3bHhq1LujyIez1SnQ=; b=o3nenJJYUueaOa2P1ka6s
        0Cf0V9t0+ojUwe8ybpFNGeMvtzZtVdKkVro4Zzxx1zQVhKRZzmg0CaqUglDRe9S+
        5y55tZ5r7SvhNW/wgFwwYylkahrJX0QGKVQsrr4JHmCjCpkLDJEvPXDglw4IMY+E
        0uOJfwG6vWIG83qwCOrR+k=
Received: from localhost.localdomain (unknown [223.104.68.80])
        by smtp2 (Coremail) with SMTP id DMmowAB3fwNbo5RiPi31CA--.52866S2;
        Mon, 30 May 2022 18:58:37 +0800 (CST)
From:   Lixue Liang <lianglixuehao@126.com>
To:     pmenzel@molgen.mpg.de
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
Subject: [PATCH v3] igb_main: Assign random MAC address instead of fail in case of invalid one
Date:   Mon, 30 May 2022 10:58:34 +0000
Message-Id: <20220530105834.97175-1-lianglixuehao@126.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
References: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowAB3fwNbo5RiPi31CA--.52866S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFW3Ww4xGFW3KrWrAFyxZrb_yoW8Xr13pa
        n5Xa4Igr1kXr4jq3ykJa18Za4Ykayjq345CrZxA3WF9Fn0vrWDAr4Ut347tryrGrZ5uFsx
        tr47Za1kuan8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07URwZxUUUUU=
X-Originating-IP: [223.104.68.80]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/xtbBGg4RFl-HZLYkDgAAsz
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
 drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..40f43534a3af 100644
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
+			"Invalid MAC address, already assigned random MAC address\n");
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

