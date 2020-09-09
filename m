Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5A9262848
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIHSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIIHR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:17:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF3AC061573;
        Wed,  9 Sep 2020 00:17:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l191so1418823pgd.5;
        Wed, 09 Sep 2020 00:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64Bt6kd9gxNJLRVuqcxKj5M+pb5+qbe839Gm0r/zIvo=;
        b=BOZkXJ6/UZfd/Smz8exM0/GCMabLwdZY0S7okls6rxu14xZzEAcX+7DHmsZISbkkg1
         yI+W8ytZ2T8AY61EhOAtxyLw/FXWXvZ8zE3VvXxr0LX0FbUVdMosXzPdv7nuDZzbWrkz
         Mq+leo06/a5x3b+9W+6QJAP+RWsyDJrKakDSaqjR+ch+HTVPMwA9vL25n4E5ufexmJfx
         5RuG0VmZbBZydIVVUfcO+9WXm3igrUCRTWEIvanjZY4RmigvsMwz8KyfXu7TDXj/DuGZ
         6uQ8GIDFcht7e76ccDGhc/3kIpHbgTIfiJpCWNpM8Bqdg88VJuTWxAKDS8rVfZYDUBLN
         YyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64Bt6kd9gxNJLRVuqcxKj5M+pb5+qbe839Gm0r/zIvo=;
        b=Y4UYQGpzbXyxbhQZ1aliF6qPEQZzplLB6I+ccPiRFr1nycbAdokz4qsPJHczBahpXA
         xUXkHHDO1cw3CvGQl/OoHuULY0UPRCs+seMKNEY6ToEREgukGt7CoqpEQxGvGCvM9oHH
         VmDgPQyXFEUiu9WW6UP19dWTdHYjB+/gBwIq8NcljM+nlIDi1kl+n6WyPiiDbu1Qtve0
         rWJ54RgD4ydPjcLTGtNW0Zq96wylaDzp3794Z6kdzAya83DCyKQmzJiOG4goNNVS3Q8F
         5cZ4Vkmv44w4oZ6i7v4PM+yHvRo8yPDXUZCqf9eP13GBAHBEh+tviJgSowQxyBJ1nse5
         YWIQ==
X-Gm-Message-State: AOAM530UuglL65IWHw1WU0h5LWsBEVIuGGPmzlQ+Pn/18I104/MI1wFP
        WZTSA7Ze0ZLyjXW9Hyoo1A==
X-Google-Smtp-Source: ABdhPJxuGhKjFWPHlV7tWVd/A6dvlcDQsvdVZO4mWSI4b/JsVgqaXXITNfUrG/50JWsRL7CjUveweg==
X-Received: by 2002:a17:902:7203:b029:d0:cbe1:e73a with SMTP id ba3-20020a1709027203b02900d0cbe1e73amr2786781plb.21.1599635878103;
        Wed, 09 Sep 2020 00:17:58 -0700 (PDT)
Received: from localhost.localdomain (n11212042027.netvigator.com. [112.120.42.27])
        by smtp.gmail.com with ESMTPSA id y3sm1699661pfb.18.2020.09.09.00.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 00:17:57 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net v2] Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()
Date:   Wed,  9 Sep 2020 03:17:00 -0400
Message-Id: <20200909071700.1100748-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200805180902.684024-1-yepeilin.cs@gmail.com>
References: <20200805180902.684024-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`num_reports` is not being properly checked. A malformed event packet with
a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
of bounds. Fix it.

Cc: stable@vger.kernel.org
Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Change in v2:
    - add "Cc: stable@" tag.

 net/bluetooth/hci_event.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..aec43ae488d1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5863,21 +5863,19 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
 	u8 num_reports = skb->data[0];
-	void *ptr = &skb->data[1];
+	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
 
-	hci_dev_lock(hdev);
+	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
+		return;
 
-	while (num_reports--) {
-		struct hci_ev_le_direct_adv_info *ev = ptr;
+	hci_dev_lock(hdev);
 
+	for (; num_reports; num_reports--, ev++)
 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 				   ev->bdaddr_type, &ev->direct_addr,
 				   ev->direct_addr_type, ev->rssi, NULL, 0,
 				   false);
 
-		ptr += sizeof(*ev);
-	}
-
 	hci_dev_unlock(hdev);
 }
 
-- 
2.25.1

