Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10523C20FE
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhGIIqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbhGIIqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 04:46:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8DCC0613DD;
        Fri,  9 Jul 2021 01:44:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o4so4662659plg.1;
        Fri, 09 Jul 2021 01:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7W/RXc+IBJu2j+yc4eqfnO/B+uIUaANtmNbBhY5N0bo=;
        b=ssESuozzwrDfjs4SsestEH430LqnlOFIK4vttayikK1q0lOy53kSobtDETx1BZvA93
         5IaLHRcJj11j3YH8WiqfYihNgWdtB0gRDLtWZMh0MvxDGzOOPERFcRfZSxdZtsKPbyhc
         ZoT0+78m4DWWCPiFxWxLlu4iBFNJhaMOf2J18/EhD/dQA/ZjrQbbB5hTXkBm8vhaSbma
         1swfVI6kpwLG7fzXZTkfF5+UCEaM1ytI3jVuTw1e62WyDJiPIQY68POjnVJeKhA929v3
         ICcX1HIkikYDAd5uHngkIDKIefDlLe9KsCQnLeWHxdtMxw9LsAedeYMjv0iyZPM/n1RX
         LjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7W/RXc+IBJu2j+yc4eqfnO/B+uIUaANtmNbBhY5N0bo=;
        b=OMn+YMR8AZ/y00NDvuYJU5VpC4oNppcw7TTOxRTClzSZZso0/zaFUapMgD7I/1REba
         j5lWhpqxS/92ziJcWhRwRcTGHDBHXB/8xhRMgUOiKe9HFfpMG+zVuntNZ+KkqDE8CK0I
         aABYF3PpD44ZW3KJIH5AoWFmGffSxE8UUNr0i/Xye0iKmuVNqiZs6U81xWmA04CPogMt
         pfZETC8s0DZxqLfDdhOzdbLoSq+SROIMLrx/fe+Evydt1u9GdqnmRi1PQcCsE/dj4O2W
         iGKzapmeNToJlZ0DvtTHCsJi8L3/91ZJu0NxC3bui29EyzVXZIBwaDtJTwluAu9QkfD5
         yL+A==
X-Gm-Message-State: AOAM531wzdDhPcg5b0pBZ9Bgfc/gZJW1GTzz20uXYi9/XSzD7HFXlLju
        uPpqsEyVlA1QgKpQPXUzdjk=
X-Google-Smtp-Source: ABdhPJyHHifuowhUFMdA+aX3uQQ86aA3zYGue1JjUk98DE9FLG4ZQOg4RRFDBOmCZIj7aYrQJMaabg==
X-Received: by 2002:a17:902:aa92:b029:127:a70e:3197 with SMTP id d18-20020a170902aa92b0290127a70e3197mr30061236plr.30.1625820249319;
        Fri, 09 Jul 2021 01:44:09 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.216])
        by smtp.gmail.com with ESMTPSA id x10sm5737169pfd.175.2021.07.09.01.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 01:44:08 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brooke Basile <brookebasile@gmail.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: hif_usb: fix memory leak in ath9k_hif_usb_firmware_cb
Date:   Fri,  9 Jul 2021 16:43:51 +0800
Message-Id: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 03fb92a432ea ("ath9k: hif_usb: fix race condition between
usb_get_urb() and usb_kill_anchored_urbs()") adds three usb_get_urb
in ath9k_hif_usb_dealloc_tx_urbs and usb_free_urb.

Fix this bug by adding corresponding usb_free_urb in
ath9k_hif_usb_dealloc_tx_urbs other and hif_usb_stop.

Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 860da13bfb6a..bda91ff3289b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -457,6 +457,7 @@ static void hif_usb_stop(void *hif_handle)
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
+		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
 		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
@@ -779,6 +780,7 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
+		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
 		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
@@ -797,6 +799,7 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
+		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
 		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
-- 
2.25.1

