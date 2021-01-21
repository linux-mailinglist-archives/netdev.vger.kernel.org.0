Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4214E2FE824
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 11:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbhAUKyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 05:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbhAUKxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:53:43 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72698C061575;
        Thu, 21 Jan 2021 02:53:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e6so1422438pjj.1;
        Thu, 21 Jan 2021 02:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXqWKoPlu1jYTrtC0qymG93dIZpDOfjvB7EF1G9KMn8=;
        b=cGK7qU0PCTi2Kd4/IyeTKNAlCRGe6UNqfxj/BeKqlxWZkpa+/Vj09u1nZFiWGoULy7
         p8TVMKHztsP5QgF5h0wkNeS79LIytawsCQEpR/yQWW0vybv4TDVfCLgdvrQa3RmYBqZ+
         M2CAjecDt9bp7Bqmpkha+T5CoikvRHoRNW+wzfUDolW2oVarXBCFptKMjHdkccsqu+9Y
         H41GasmHjAjhRg+TsSbGkdgqS1iXb1qrnffZ/88eou1yYeP7a2PQ5g4G5oZROpmHLkUn
         k9vr2TAm/+LE5vCrJOq5Vo/KgkxPAJUKpyF4pMyVW60W6nKaH/tE/V9yTuLflTYoLTQV
         QRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXqWKoPlu1jYTrtC0qymG93dIZpDOfjvB7EF1G9KMn8=;
        b=D6FgCiE/+TIkDpESNVN5hMo+Zr5ZO5bcPe9HJAK77lTxnxa4vYinwCi3gxLeUdURQD
         jYflODv8shsxbVa3ok8H9Rs+cKJ5rleI/+lhmsgTiXpRi/X4kIEvcSqfrPT13Zm7xSxM
         ScPJpD/1o8HHZ82ZHPEvMMd09TcOW5QshM2BgHZb3KtI6IVVFBr9OsJTg1QjXa+VXD+s
         oDWKVivJnSiAlAkrHmeXhOqdEwASZu/OJxnmcNQRnF1hxmLISwGFzs8XuYkQy9i6/BER
         nXjIAE7dFY7HsihmwRjctzHxZ4+ifMVXRwk+9Di/MQnLMQqVMEL3S24aOFgQyBgHWY4F
         7TAA==
X-Gm-Message-State: AOAM530u9IQx5bS9P9pEeOBQrbaKBue3Lx1l3iugYmBhONDl3sviLAn+
        6d6w5ABYSlogTioEERd8p0w=
X-Google-Smtp-Source: ABdhPJxK1/TL355nnK0SiPqwI9ZoDzRpL4U8xMBcTCwfQbKwJTiN+y1ErDXisKwqybXiXznGLagZcw==
X-Received: by 2002:a17:90a:4598:: with SMTP id v24mr11103928pjg.135.1611226382897;
        Thu, 21 Jan 2021 02:53:02 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.69])
        by smtp.gmail.com with ESMTPSA id jx15sm5577353pjb.17.2021.01.21.02.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 02:53:02 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, sgruszka@redhat.com,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
Date:   Thu, 21 Jan 2021 18:52:46 +0800
Message-Id: <20210121105246.3262768-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function rt2500usb_register_read(_lock), reg is uninitialized
in some situation. Then KMSAN reports uninit-value at its first memory
access. To fix this issue, initialize reg with zero in the function
rt2500usb_register_read and rt2500usb_register_read_lock

BUG: KMSAN: uninit-value in rt2500usb_init_eeprom rt2500usb.c:1443 [inline]
BUG: KMSAN: uninit-value in rt2500usb_probe_hw+0xb5e/0x22a0 rt2500usb.c:1757
CPU: 0 PID: 3369 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Compute Engine
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
 __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
 rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1443 [inline]
 rt2500usb_probe_hw+0xb5e/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
 rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
 rt2x00usb_probe+0x7ae/0xf60 wireless/ralink/rt2x00/rt2x00usb.c:842
 rt2500usb_probe+0x50/0x60 wireless/ralink/rt2x00/rt2500usb.c:1966
 ......

Local variable description: ----reg.i.i@rt2500usb_probe_hw
Variable was created at:
 rt2500usb_register_read wireless/ralink/rt2x00/rt2500usb.c:51 [inline]
 rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1440 [inline]
 rt2500usb_probe_hw+0x774/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
 rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index fce05fc88aaf..98567dc96415 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int offset)
 {
-	__le16 reg;
+	__le16 reg = 0;
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
 				      &reg, sizeof(reg));
@@ -57,7 +57,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 static u16 rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset)
 {
-	__le16 reg;
+	__le16 reg = 0;
 	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
 				       USB_VENDOR_REQUEST_IN, offset,
 				       &reg, sizeof(reg), REGISTER_TIMEOUT);
-- 
2.25.1

