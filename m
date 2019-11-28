Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B804A10CDC0
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfK1RYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:24:47 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44516 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfK1RYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:24:46 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so19533332lfa.11;
        Thu, 28 Nov 2019 09:24:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0k/whkObdvFEbr6P8BAMIPbGI3mpivEYyevE4zbpz+U=;
        b=YTnLBVxZmcA1S1GTv5vEk7bJZXnWjMCDCsAmEyrDJiEDDlhkDfV15S/ZN4Hm8aGOi6
         g9vvRgAq4hV35JXUDcAFlRkL76AHO8/MKFrYzt6d8qycJuWpvNfTQOg9/L55l5T9A57Y
         Xz7jfyVCdngQxT+XCzW81vT3/V+BlL5hvS2p8ZqdGzJ+lMwGZSODFHGzzcQRPX1JHwuC
         wCSWTKuO8xtr9wmRPfWYg3THCaM0srPMPs7gZimBg8XM6jsWdkggElYEmj68ECFvw3FY
         /Yt8p1IVLqMZlHfEwo1RNU1fQO2k+CgvYCygvkxQQJKgaWlvJ9Ml8AKKpLsR6NisqoP6
         6cUQ==
X-Gm-Message-State: APjAAAVDnT714kj/1J0een5/etlGE69B73RaWLv5UfWplv+8eGHBNwpp
        wPEtHzLy2j2DSijXkNbs9zHb6/Us
X-Google-Smtp-Source: APXvYqx07QR8XJ8G7WRnoRgk6KFeYR3k/7eUV4xZpOE+oly6I6TehZvJEdoQ6FJhKcL8PMi2nHK23Q==
X-Received: by 2002:ac2:41d8:: with SMTP id d24mr17717001lfi.98.1574961883138;
        Thu, 28 Nov 2019 09:24:43 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id v28sm4310765lfd.93.2019.11.28.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:24:41 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaNWz-0006wW-Jv; Thu, 28 Nov 2019 18:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 2/5] rsi: fix use-after-free on probe errors
Date:   Thu, 28 Nov 2019 18:22:01 +0100
Message-Id: <20191128172204.26600-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191128172204.26600-1-johan@kernel.org>
References: <20191128172204.26600-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver would fail to stop the command timer in most error paths,
something which specifically could lead to the timer being freed while
still active on I/O errors during probe.

Fix this by making sure that each function starting the timer also stops
it in all relevant error paths.

Reported-by: syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com
Fixes: b78e91bcfb33 ("rsi: Add new firmware loading method")
Cc: stable <stable@vger.kernel.org>     # 4.12
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index f84250bdb8cf..6f8d5f9a9f7e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -622,6 +622,7 @@ static int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
 	bl_start_cmd_timer(adapter, timeout);
 	status = bl_write_cmd(adapter, cmd, exp_resp, &regout_val);
 	if (status < 0) {
+		bl_stop_cmd_timer(adapter);
 		rsi_dbg(ERR_ZONE,
 			"%s: Command %s (%0x) writing failed..\n",
 			__func__, str, cmd);
@@ -737,10 +738,9 @@ static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
 	}
 
 	status = bl_cmd(adapter, cmd_req, cmd_resp, str);
-	if (status) {
-		bl_stop_cmd_timer(adapter);
+	if (status)
 		return status;
-	}
+
 	return 0;
 }
 
@@ -828,10 +828,9 @@ static int auto_fw_upgrade(struct rsi_hw *adapter, u8 *flash_content,
 
 	status = bl_cmd(adapter, EOF_REACHED, FW_LOADING_SUCCESSFUL,
 			"EOF_REACHED");
-	if (status) {
-		bl_stop_cmd_timer(adapter);
+	if (status)
 		return status;
-	}
+
 	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
 	return 0;
 }
@@ -849,6 +848,7 @@ static int rsi_hal_prepare_fwload(struct rsi_hw *adapter)
 						  &regout_val,
 						  RSI_COMMON_REG_SIZE);
 		if (status < 0) {
+			bl_stop_cmd_timer(adapter);
 			rsi_dbg(ERR_ZONE,
 				"%s: REGOUT read failed\n", __func__);
 			return status;
-- 
2.24.0

