Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1856A5373CA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 05:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiE3Dw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 23:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiE3Dw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 23:52:28 -0400
X-Greylist: delayed 1884 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 May 2022 20:52:24 PDT
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 793C74C7B4
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9thq6
        63oygG9CMTqky7iY/KDoxlJkQXsre85S3OEShQ=; b=BA5tY+30CByxQxHdKKWi5
        DApHrxizW31R5xfC+9tve7ON2HsgzR/L52p85m2YV5gX+m79m5fN4W0WVLX/WAEc
        y3Hc9ccwYxgdB9Af+cUcMTt+1jjisvA/6nNlyUEHuw2H5uTxWHgbt3RlXHrwLu+E
        ugPIcKCA+wLUwjTkJxuKUE=
Received: from localhost.localdomain (unknown [223.104.68.108])
        by smtp2 (Coremail) with SMTP id DMmowABXtPDxN5Ri+ovmCA--.47774S2;
        Mon, 30 May 2022 11:20:20 +0800 (CST)
From:   Lixue Liang <lianglixuehao@126.com>
To:     pmenzel@molgen.mpg.de
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
Subject: [PATCH v3 3/3] igb_main: Assign random MAC address instead of fail in case of invalid one
Date:   Mon, 30 May 2022 03:19:41 +0000
Message-Id: <20220530031941.44006-1-lianglixuehao@126.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
References: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowABXtPDxN5Ri+ovmCA--.47774S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFW3Ww4xGFW3KrWrAFyxZrb_yoW8Gr15pF
        s5JFWxKrykXr4jg3ykXw1xZas0kayDta45GrZxA3WF9Fn0vrWDAr15K347tryrJrZ5ZFsx
        tr47Zw4kuan8JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UvtCcUUUUU=
X-Originating-IP: [223.104.68.108]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbi2hURFluwMFHCzQAAsN
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
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 746233befade..40f43534a3af 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3362,7 +3362,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		eth_hw_addr_random(netdev);
 		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
 		dev_err(&pdev->dev,
-			"Invalid MAC Address, already assigned random MAC Address\n");
+			"Invalid MAC address, already assigned random MAC address\n");
 	}
 
 	igb_set_default_mac_filter(adapter);
-- 
2.27.0

