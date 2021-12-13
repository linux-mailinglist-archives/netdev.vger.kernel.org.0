Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0627472228
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 09:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhLMILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 03:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhLMILj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 03:11:39 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412E9C061748
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 00:11:39 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id k4so13879181pgb.8
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 00:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcoQMqd+/7idFnoLa/h3loZdpkZ7uYITYIobfbm2fno=;
        b=FtLB4DFgjXiXbPPZmctl9E3CBZhMrLsdASxfimI2fewhXgqjOQ98jbXCY19GSfQQJ9
         BTEg9+ixPdR/FTmGYvlYaAovkYXF3mV28BLfxxu4XJEdZj5V6iU7uNQWyQEi6PNfuSN1
         kKspFKlbcEwjGxzYbx8LdAuoAhbH6lc2JqQHa8iOLDP8dXHNhs6Kyo16C/YUgCs8g73f
         eBdG5Mu/waxbSwnUpMROW5cbPHcXKW+DkE0MqylHf4GgsQOQ0duxE6l8oEHBteIhOBvP
         473RAkg+lHfNdIyNiSlKqxicdDVjDv5DbYnYZol3jHCSQguVJKCL/sOdpS/0bIG4hu8n
         bHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcoQMqd+/7idFnoLa/h3loZdpkZ7uYITYIobfbm2fno=;
        b=21CmCsnLnbzgAipKj0+10Pvoz+hwZNwb6iJdPKbuTThjf3+EHxvlTfCw3/yUg3zGKG
         y5XOXPJCvVhip62bYLmRGDhLSs37oABKcBqQoWlqx41qsFhb57p35BAwgtdLVTAIYt0Q
         E0yhYagCK2yhFq7vJLdcH4Ck/46Ptjf3bR26UN0BfoBfWcWW6xTTJxI1GzV9bzqI6bMu
         6aVhoLjDA5n8V2ISY0yAPpojkxq61cdkc3IiI5TOxyF5rUyUskm8Gu9XuEQJrcAqJy0A
         V2qAxZ/HWw4XoMJ7DmNEtfvwNFFbl8WzU9XlbH4svJ+OMjFeS8qh+tgruRsy3nLsnCfb
         palg==
X-Gm-Message-State: AOAM533Z1WdMBr6U/XWOp0Dp34/WCHe9VxGDyff26ajU1zthb0Elhk90
        +ySn7n65WTob2ISFjuVxrbwsow==
X-Google-Smtp-Source: ABdhPJzJfbSUnqsF2VuNRqwFqUzId12IVk3eBZOc+GRGAyTmqs+N/+kfbVZmf4ft6xhp7UPlcKsxaQ==
X-Received: by 2002:a63:8bca:: with SMTP id j193mr13933826pge.293.1639383098719;
        Mon, 13 Dec 2021 00:11:38 -0800 (PST)
Received: from starnight.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.googlemail.com with ESMTPSA id p15sm6097378pjh.1.2021.12.13.00.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 00:11:38 -0800 (PST)
From:   Jian-Hong Pan <jhp@endlessos.org>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Po-Hao Huang <phhuang@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH] rtw88: pci: turn off PCI ASPM during NAPI polling
Date:   Mon, 13 Dec 2021 16:09:09 +0800
Message-Id: <20211213080908.80723-1-jhp@endlessos.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The system on the machines equipped with RTL8821CE freezes randomly
until the PCI ASPM is disabled during NAPI poll function.

Link: https://www.spinics.net/lists/linux-wireless/msg218387.html
Fixes: 9e2fd29864c5 ("rtw88: add napi support")
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203..a6fdddecd37d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1658,6 +1658,7 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 					      priv);
 	int work_done = 0;
 
+	rtw_pci_link_ps(rtwdev, false);
 	while (work_done < budget) {
 		u32 work_done_once;
 
@@ -1681,6 +1682,7 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 		if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
 			napi_schedule(napi);
 	}
+	rtw_pci_link_ps(rtwdev, true);
 
 	return work_done;
 }
-- 
2.34.1

