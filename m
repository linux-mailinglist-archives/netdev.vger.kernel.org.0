Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD70E12460E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfLRLqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:46:53 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40048 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRLqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:46:53 -0500
Received: by mail-pj1-f67.google.com with SMTP id bg7so262124pjb.5;
        Wed, 18 Dec 2019 03:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8Rm3PGAG4ZjJjxffgjZO01XuGdZ5Se+lxRoTd65jV/I=;
        b=ZqdU5bMscFQvm8p09tXvtNABGBJq3yux1pRvAaSqHYWoBHsvLzpx40uJaQXuXESBMy
         uFXxFSZYelsqKFR9u97FntWyBuRrNZSiUzu5UUXshbqPHsStjihAGvW+ajqEG1EbOfPo
         CduQ2IZkIVxIZeAaHojbbW/tuxGxmxAllFCZKTj9CAH1CuO8lkcQszADJvRwU7fQhyzU
         zhkiN/jm65g1GHgd/qp5N+glagyd4JzNwME+ofMcnZvqiltufXLulTwnVoZM4j6hTuWe
         D2NNi9Gtqt/tAooIXZqAb9wUAVNgMtXyikiC/W49ZmSFYqVsituX+OOu/u1AAbxR5XtM
         O3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Rm3PGAG4ZjJjxffgjZO01XuGdZ5Se+lxRoTd65jV/I=;
        b=T/kq+1VwOU6ilo7BaSX9S8t5v4WVpkKCYB6rpGzfrqhmaHpM+QvAM4T52KLDA8x/Kn
         ECp3W8vi643Lyxr4A2LOnrUtKGiq1w+e1pz4prMZKRfDqTmtOAXh9V+3IzRIhJlCBlFI
         ovQWu+Ig1TPVqjVs1Q7/KHQ20nF5WPJvibodvfjTGqSyxj/0XjF2EZu06ZyCmtnlGTx+
         ZmhqkDRp3bbr1UCV07ZK2hhO+1CF2jbVxytb5eCAAmsC0yWuadAYn8hRx9EXgOhyrJoo
         qsWBzY7MlvHdScvrKb2B1SPEQDpUX1s8J7DSUCxN3z0yCQqSliWlCPqDIxN3opwp8kJy
         Hzpw==
X-Gm-Message-State: APjAAAXP+xh6xULQY3yg+9pqglGZuKsTeKKQnUt4Gjpme3pFA/UFmmt4
        a3xtIWq4A+8suFB22TCqEig=
X-Google-Smtp-Source: APXvYqwRkgvw8jDHziQzj693orxCe6AxRD4tkkS6Jhb3GveNfnhdDXtHvoza5yByb4hW1lEpWrgvUA==
X-Received: by 2002:a17:902:bd93:: with SMTP id q19mr52436pls.134.1576669612673;
        Wed, 18 Dec 2019 03:46:52 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id a10sm2913237pgm.81.2019.12.18.03.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:46:52 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] ath9k: fix possible sleep-in-atomic-context bugs in hif_usb_send_regout()
Date:   Wed, 18 Dec 2019 19:45:33 +0800
Message-Id: <20191218114533.9268-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/net/wireless/ath/ath9k/hif_usb.c, 108: 
	usb_alloc_urb(GFP_KERNEL) in hif_usb_send_regout
drivers/net/wireless/ath/ath9k/hif_usb.c, 470: 
	hif_usb_send_regout in hif_usb_send
drivers/net/wireless/ath/ath9k/htc_hst.c, 34: 
	(FUNC_PTR)hif_usb_send in htc_issue_send
drivers/net/wireless/ath/ath9k/htc_hst.c, 295: 
	htc_issue_send in htc_send
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 250: 
	htc_send in ath9k_htc_send_beacon
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 207: 
	spin_lock_bh in ath9k_htc_send_beacon

drivers/net/wireless/ath/ath9k/hif_usb.c, 112: 
	kzalloc(GFP_KERNEL) in hif_usb_send_regout
drivers/net/wireless/ath/ath9k/hif_usb.c, 470: 
	hif_usb_send_regout in hif_usb_send
drivers/net/wireless/ath/ath9k/htc_hst.c, 34: 
	(FUNC_PTR)hif_usb_send in htc_issue_send
drivers/net/wireless/ath/ath9k/htc_hst.c, 295: 
	htc_issue_send in htc_send
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 250: 
	htc_send in ath9k_htc_send_beacon
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 207: 
	spin_lock_bh in ath9k_htc_send_beacon

drivers/net/wireless/ath/ath9k/hif_usb.c, 127: 
	usb_submit_urb(GFP_KERNEL) in hif_usb_send_regout
drivers/net/wireless/ath/ath9k/hif_usb.c, 470: 
	hif_usb_send_regout in hif_usb_send
drivers/net/wireless/ath/ath9k/htc_hst.c, 34: 
	(FUNC_PTR)hif_usb_send in htc_issue_send
drivers/net/wireless/ath/ath9k/htc_hst.c, 295: 
	htc_issue_send in htc_send
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 250: 
	htc_send in ath9k_htc_send_beacon
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 207: 
	spin_lock_bh in ath9k_htc_send_beacon

(FUNC_PTR) means a function pointer is called.

To fix these bugs, GFP_KERNEL is replaced with GFP_ATOMIC.

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index fb649d85b8fc..37231fde102d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -105,11 +105,11 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 	struct cmd_buf *cmd;
 	int ret = 0;
 
-	urb = usb_alloc_urb(0, GFP_KERNEL);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb == NULL)
 		return -ENOMEM;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (cmd == NULL) {
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -124,7 +124,7 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 			 hif_usb_regout_cb, cmd, 1);
 
 	usb_anchor_urb(urb, &hif_dev->regout_submitted);
-	ret = usb_submit_urb(urb, GFP_KERNEL);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
 		usb_unanchor_urb(urb);
 		kfree(cmd);
-- 
2.17.1

