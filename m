Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3E305834
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314272AbhAZXC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbhAZRQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:16:47 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A88C061352;
        Tue, 26 Jan 2021 09:16:07 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ox12so24101109ejb.2;
        Tue, 26 Jan 2021 09:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lr7TRr5ybLv57MYeVSWFh/csc4/2QYh3XPd9jhyIC78=;
        b=PtJzM0hZaAS6/hkwv1qr+GiEDC6Y5XkpDO4px6qOx6rszb7u/qbkOpDrwHPrvq1ITI
         YHRSk3i1lldKme3bpCaLN0xadQ05qZtwk/y5aeyDMLBN/cLeJ9fWszwe4IUMj26p0m1c
         ym16VW5+6GTgSGiuJoFgmRsyJYamkUljbsI1qKIZOueETECXMX0mhOA4AZ1dUFs5/0kU
         OWhcsdK6j5FODhq5AqFyV9/Dd3exGOGmXJS3YFUbebFccu5kGKGWgZDj9+ywl6ilcGCh
         cOfzeZakQAeSpdMhjJs6Oef2Af5sKma0HqEYPPv2y0T6/ntq6QL++Ux4whLBMfrWzYCH
         z3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=lr7TRr5ybLv57MYeVSWFh/csc4/2QYh3XPd9jhyIC78=;
        b=fPfVUOTmkKa1U4w4VKDTrhTaGqOFIVDJYo/fV3CXT/wgP08Se55wPM+eq0P2tlVp39
         BGM/Otf9ZnpL1hHH+JeWbjnNnUOAKNTsBHRy70P6KI4j1IKrhFvm3IJXgHzFTQ0Fs2Bo
         XPlhnaD0nVGx1mOZgG1sNm33UEfs7DCyvbugiyTNADlQHOC5KPxwOLjIb05jy7rFeSV4
         7jgzNQ9AlM9w8U9G8JCFSjm1Ec9wGoth0/WrOVBE8ytPCFIM/6ggvKLTjgLAwTMDYgn5
         fR5M+zhjeYwFKpAB9QQS8z2ydfCwhUJqaFoE/RYc1eXF7xrCxXMyekRVrlB54hZ8Orbb
         jh4Q==
X-Gm-Message-State: AOAM532y8JgJofKBN5w/PyG8LcZX2i9JdYdvyWddlUy3gBVccgvy4Bzz
        jyLwice7rz4G+2qBvgdr0UZ9v1BRx2843g==
X-Google-Smtp-Source: ABdhPJxata7MyXo38nLL9zYdQ4yXF/1FOfOE1JuQrL1YF5XKVkuT2U68o8fAY+4InoDVKOkRwuitDQ==
X-Received: by 2002:a17:906:ce49:: with SMTP id se9mr4136989ejb.341.1611681366244;
        Tue, 26 Jan 2021 09:16:06 -0800 (PST)
Received: from stitch.. ([2a01:4262:1ab:c:f1a3:95f9:9758:8995])
        by smtp.gmail.com with ESMTPSA id p26sm12970046edq.94.2021.01.26.09.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 09:16:05 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: use tasklet_setup to initialize rx_work_tasklet
Date:   Tue, 26 Jan 2021 18:15:50 +0100
Message-Id: <20210126171550.3066-1-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit d3ccc14dfe95 most of the tasklets in this driver was
updated to the new API. However for the rx_work_tasklet only the
type of the callback was changed from
  void _rtl_rx_work(unsigned long data)
to
  void _rtl_rx_work(struct tasklet_struct *t).

The initialization of rx_work_tasklet was still open-coded and the
function pointer just cast into the old type, and hence nothing sets
rx_work_tasklet.use_callback = true and the callback was still called as

  t->func(t->data);

with uninitialized/zero t->data.

Commit 6b8c7574a5f8 changed the casting of _rtl_rx_work a bit and
initialized t->data to a pointer to the tasklet cast to an unsigned
long.

This way calling t->func(t->data) might actually work through all the
casting, but it still doesn't update the code to use the new tasklet
API.

Let's use the new tasklet_setup to initialize rx_work_tasklet properly
and set rx_work_tasklet.use_callback = true so that the callback is
called as

  t->callback(t);

without all the casting.

Fixes: 6b8c7574a5f8 ("rtlwifi: fix build warning")
Fixes: d3ccc14dfe95 ("rtlwifi/rtw88: convert tasklets to use new tasklet_setup() API")
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index d62b87f010c9..6c5e242b1bc5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -310,8 +310,7 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 	init_usb_anchor(&rtlusb->rx_cleanup_urbs);
 
 	skb_queue_head_init(&rtlusb->rx_queue);
-	rtlusb->rx_work_tasklet.func = (void(*))_rtl_rx_work;
-	rtlusb->rx_work_tasklet.data = (unsigned long)&rtlusb->rx_work_tasklet;
+	tasklet_setup(&rtlusb->rx_work_tasklet, _rtl_rx_work);
 
 	return 0;
 }
-- 
2.30.0

