Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A571C3485
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgEDIev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgEDIeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:34:50 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968D6C061A0E;
        Mon,  4 May 2020 01:34:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d22so2983456pgk.3;
        Mon, 04 May 2020 01:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=59iokotS8iIDb+gGu6n274MbuIuRWgjxTwxL1qAA8wM=;
        b=dmetl9QONWoXGhv00gP8OPuyWeS0oeJPBBtLGuqgRYBpTTz+Z7DNQsYN5C1NttrEkx
         aIidf/us1Aj7cPNlxo4qqIYxv9Ebn9XR/yg/07LtO/62s0FVzr5ZZ41yhanUN2ybmBIv
         4DnlyZbMMQroW2yKPkyfCAin+/ZyHh0KerJYGvJ0X2VNa41CEwsX8VEbdBjfss/E4AOM
         Jt7zqi3P8/p83waC6+9gtp1nJLsLhw8hR0rGKNcdj1FiKvIS1PLFxMvKN4r4tQ+S/+nX
         WYS60PwBvKIFEEHO2J+ixAlX05UqrRylIh9RCJMh6OSOMJAsRiVn01s8KhNm7iHzroCM
         9SPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=59iokotS8iIDb+gGu6n274MbuIuRWgjxTwxL1qAA8wM=;
        b=MYtP5imPNlLnAMpO1THYfkL+T1XaR3xi+ZBDze5Y1g+m0RzFHOoYm4DjDUZqP9HJqd
         3CQoMB7IhyL/2e7+rcdc2IN+j8AKyxqaEtEddNttaH8go6Zy12/xlRbUHe9OaqS0QSbf
         7Or9nVNBJo3ijZOg8W8Qc8RLu0wO8ThoK1HiWUwVk2x6niWPd7bqsU+hmaG6tIqu0Tkf
         iY03Y2+zuon41OkM9kJenSxctrg1Im/D9l7mJGA0VT8rkaoYUQO6KzsOdEMW5AAuc05z
         KLbYiqVWFyCDTEvZHTdDiDE+SH2017lzkgW2fYdGLckb6EI1bEwlqUR0Vr0Iz+9UhS+x
         0MZg==
X-Gm-Message-State: AGi0PuZ3/hpCQEWzwiNpMBlu+WTeIpSwQTY1yv/E4Jo3hEVbtV/Ol3DS
        MWW1ZxB/8YA1UGMyU/RI4n4=
X-Google-Smtp-Source: APiQypLatKpf6OjZyANdh3E9QSCOXHw4Mjs6j1NkKSePjYcjdyDDdPm34oam03X81IYGwmdbINehGQ==
X-Received: by 2002:a63:ea18:: with SMTP id c24mr16252820pgi.62.1588581289997;
        Mon, 04 May 2020 01:34:49 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id j5sm7252650pgi.5.2020.05.04.01.34.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 01:34:49 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        sgruszka@redhat.com, briannorris@chromium.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net v1] net: rtw88: fix an issue about leak system resources
Date:   Mon,  4 May 2020 16:34:42 +0800
Message-Id: <20200504083442.3033-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the related system resources were not released when pci_iomap() return
error in the rtw_pci_io_mapping() function. add pci_release_regions() to
fix it.

Fixes: e3037485c68ec1a ("rtw88: new Realtek 802.11ac driver")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 695c2c0d64b0..a9752c34c9d8 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1102,6 +1102,7 @@ static int rtw_pci_io_mapping(struct rtw_dev *rtwdev,
 	len = pci_resource_len(pdev, bar_id);
 	rtwpci->mmap = pci_iomap(pdev, bar_id, len);
 	if (!rtwpci->mmap) {
+		pci_release_regions(pdev);
 		rtw_err(rtwdev, "failed to map pci memory\n");
 		return -ENOMEM;
 	}
-- 
2.25.0

