Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579E6CBDB2
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389377AbfJDOpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:45:53 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37077 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389136AbfJDOpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:45:52 -0400
Received: by mail-lf1-f65.google.com with SMTP id w67so4681330lff.4;
        Fri, 04 Oct 2019 07:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=41QFKhTKVw0r48ZhA+a3ExQuzLOYbcSClKQP6ZHYplY=;
        b=NaCJdxmirxyJP/KpxD50qItbwZDFQIlUdsA5gju1LjFOBei/0mpmX24PiLKH4+jHZt
         Jr5lZ/2/B+mafNMIzNw1eTNGV/Bk2E5AcohEw9J0ViJ93Lzy42uOL13G54n4+YCrdbxz
         NsRCslGUZGhT+Ccf6F0kQK27WHVbkj8n9MrFJuXxNof5kJdD8n09sTt46FPd9ekwRSf/
         VjpZxorAFTi9PVu5cBB9VfdwirMAJGd6xoQjbUkrwUTnYYLXdSsWGGgpPODj3WT7q6Ka
         GQ0mlV4T4rqCagbvyP6yUA+S2S6d9WhONmvvsLMp5JFtdTf30qsnmT6/yjy0w5S9Blh0
         CiUA==
X-Gm-Message-State: APjAAAWCL63Z3nM7htbpoz59iyIpn96mK9tl7gnic6pKO6mPgJsogP8w
        H6/P0rhkxHSAfF9Y/76WIEEsx3k5
X-Google-Smtp-Source: APXvYqwoyp2pDz11DUVf5PxE3ytN1hgT396kAmXEEpx4FfU2SPT2GaaBEfvO/egu9MZI9T25qQkHRA==
X-Received: by 2002:a19:710c:: with SMTP id m12mr9438052lfc.41.1570200349750;
        Fri, 04 Oct 2019 07:45:49 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id g3sm1326422ljj.59.2019.10.04.07.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:45:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iGOqG-0005V1-1n; Fri, 04 Oct 2019 16:46:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 1/2] Revert "rsi: fix potential null dereference in rsi_probe()"
Date:   Fri,  4 Oct 2019 16:44:21 +0200
Message-Id: <20191004144422.13003-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.

USB core will never call a USB-driver probe function with a NULL
device-id pointer.

Reverting before removing the existing checks in order to document this
and prevent the offending commit from being "autoselected" for stable.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 23a1d00b5f38..760eaffeebd6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -793,7 +793,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 		adapter->device_model = RSI_DEV_9116;
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
-			__func__, id ? id->idProduct : 0x0);
+			__func__, id->idProduct);
 		goto err1;
 	}
 
-- 
2.23.0

