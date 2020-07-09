Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751462197C9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 07:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGIFUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgGIFUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 01:20:00 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B8AC08C5CE;
        Wed,  8 Jul 2020 22:20:00 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t7so432913qvl.8;
        Wed, 08 Jul 2020 22:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h2ey5u0rQyusT9d/zc6U5JsDDVWxF+R85sT24kpAB5c=;
        b=rR8wMB0WbQzJVmK1fG6vrA9QgvikGKfYsQl+iy+CoUKQ+prDnqBeSkuG178FVewnNR
         n7PpgaXv02dMHyYy29chR5Ui46SVLx5QcQvAiSauy9uNwq9Tzt47WxTO3BVMOODMgwaL
         6MHRhl0+ZwymBPoWbQqUVhWwbqvIjmy86Et/RPKmPJ/ZSKZBZTT/KXXhnS+A6U4IDEfw
         INW6hYTuqzC+srHq80xDOjEV1TEzQbZ1QSWcY9DZzOLwcZzmJDfvKjHy5KbAP3Ll8FgO
         2aWwhwUq9duT2DQ7p5SbWR3qalA0C9DtOShUzl2J76jUBmG+sDac0gyA0cTw6Y45/Pm4
         yLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h2ey5u0rQyusT9d/zc6U5JsDDVWxF+R85sT24kpAB5c=;
        b=EUwJWHeyHjK5GBDGz1PD8PVHXIeURKxZNpFXGc5Qp61ai9T2WmBNanoVlSHSUITcL+
         YkIbIvGVP/ioIpKIoHets4qtwP6fCN6TWpIfDlZyjWWPcPiL14MD1qOrj+x8EpMSxEYZ
         o9Zkxhi4ljF+yRROi26yxeby35USOwmXPluPsjJQPWNpC863yRtjqBNJRR7qNucL2sJz
         zd1VwxOFJn1pGOO1PaFJpN7oue+4nTV1On09ZvbZfICtl4oKVxPQX29OP7b83myeX+OM
         UtQcmw1OmDsps5anJzff6ofFeznwyPUWaq9novPan81Xhzwu0wuqEVv0x/inH/oC1yg+
         uP5A==
X-Gm-Message-State: AOAM533dZ5XMFb6b6Q9Omgoc+I5cowRughxYQMbLcbvT4dOt1P+tSJXz
        wZTMx/CM+2a6n/Cvo2O8bk9MrwWDHInM
X-Google-Smtp-Source: ABdhPJysCYkfIBcts8kENFrUYmdr3eXiSmrlK8fWILE44f0rLD8RRzITYv0N2MTnGAM7xAIdtT++8g==
X-Received: by 2002:a05:6214:4c4:: with SMTP id ck4mr59679790qvb.202.1594271999346;
        Wed, 08 Jul 2020 22:19:59 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id p7sm2502952qki.61.2020.07.08.22.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 22:19:58 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH] net/bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
Date:   Thu,  9 Jul 2020 01:18:02 -0400
Message-Id: <20200709051802.185168-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check upon `num_rsp` is insufficient. A malformed event packet with a
large `num_rsp` number makes hci_extended_inquiry_result_evt() go out
of bounds. Fix it. Also, make `num_rsp` unsigned.

This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=4bf11aa05c4ca51ce0df86e500fce486552dc8d2

Reported-by: syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/bluetooth/hci_event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 03a0759f2fc2..29aff5e7dec2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4369,13 +4369,13 @@ static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
 					    struct sk_buff *skb)
 {
 	struct inquiry_data data;
-	struct extended_inquiry_info *info = (void *) (skb->data + 1);
-	int num_rsp = *((__u8 *) skb->data);
+	struct extended_inquiry_info *info = (void *)(skb->data + 1);
+	__u8 num_rsp = *((__u8 *)skb->data);
 	size_t eir_len;
 
 	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
 
-	if (!num_rsp)
+	if (!num_rsp || num_rsp * sizeof(*info) > skb->truesize)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))
-- 
2.25.1

