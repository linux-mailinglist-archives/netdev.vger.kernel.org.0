Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106B5441400
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhKAHOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhKAHOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:14:50 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40104C061714;
        Mon,  1 Nov 2021 00:12:17 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c28so34467378lfv.13;
        Mon, 01 Nov 2021 00:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAdK55O7gEHo+pkBc9rxNK8WH20VAByP8Fus4O97/Pw=;
        b=KywsUhhWd1hNW7bYL/HujtVkCusL2fwJotraYxpqStyfpFUHlO9t09gmbEecOwBnrN
         +c1vA/8YvGeevokw5fZXjEogXh588SUmPvhDXqtZhe0y9Kq7TTLO2ciuermgkeWT+XFa
         K40pGfSysLZ2v0nn5JDTBoW86J8HjtV6EwlJ6NOfQ1MEEemFzHrjinvzKfDwHHkjYB8n
         xXguRYFF8bJAn69ZfXnzqi8fnjPk64n+hoSIHzN0Mthi0URjGD0GqXTt8MS6KyJ9CIH5
         oP9GULBFhWzIrh8RSH9Z2RkaomDTF/OF/EmZO7JxBkLYqd7mLasBjVqPEXUAoamctjp7
         bGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAdK55O7gEHo+pkBc9rxNK8WH20VAByP8Fus4O97/Pw=;
        b=mJyER/BUE0aZ7sso+Ae3vVp3heXa/DFyi6PPZ/7ESydyMJ6/yROc/O3ZkXAq1WAiYb
         w+vPMgCkjtpVTrshdI39+WLgjR+s4BWwwXzSGrXGByhVcugdHgxJLqP1rGNBdruDg3N6
         KIu13pYwWBIcP+ABOVD/tCH+a4KROuEeVBcnfhw1b1urwsiQR/OAj2nSMm3Ert7u8zls
         oZKRbCE92EogGqJ3heH5vzA438rPX0uV1txjIwThzaPH+jXpxMpNYkNhMfBu8zsQtMF5
         9XOtNVDbRBmc0eCtS5t4rsDha+mkx0f9jfBdD3kUSV+r9QgKhs5n3pThCE3YO5183GtV
         WXYg==
X-Gm-Message-State: AOAM531bgO6wcjqBOAnSKkYxVCWphpsRKY0+5F/GEtr9MLyKXAfZ7G6h
        u1GMGH4zmGC+iF70aglbiLE=
X-Google-Smtp-Source: ABdhPJwBCzaryZ0+PQJNzdkLgLXr91POiZHJDvsYiiYCWsWDGgFA1IJZTkS885lOfynQF7zbajHDkw==
X-Received: by 2002:a05:6512:3f0f:: with SMTP id y15mr26917928lfa.263.1635750735528;
        Mon, 01 Nov 2021 00:12:15 -0700 (PDT)
Received: from localhost.localdomain ([94.103.235.8])
        by smtp.gmail.com with ESMTPSA id n7sm1325933lft.309.2021.11.01.00.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 00:12:15 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
Subject: [PATCH] Bluetooth: stop proccessing malicious adv data
Date:   Mon,  1 Nov 2021 10:12:12 +0300
Message-Id: <20211101071212.15355-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported slab-out-of-bounds read in hci_le_adv_report_evt(). The
problem was in missing validaion check.

We should check if data is not malicious and we can read next data block.
If we won't check ptr validness, code can read a way beyond skb->end and
it can cause problems, of course.

Fixes: e95beb414168 ("Bluetooth: hci_le_adv_report_evt code refactoring")
Reported-and-tested-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/bluetooth/hci_event.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0bca035bf2dc..50d1d62c15ec 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5780,7 +5780,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
-		if (ev->length <= HCI_MAX_AD_LENGTH) {
+		if (ev->length <= HCI_MAX_AD_LENGTH &&
+		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
 			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 					   ev->bdaddr_type, NULL, 0, rssi,
@@ -5790,6 +5791,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
+
+		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
+			break;
+		}
 	}
 
 	hci_dev_unlock(hdev);
-- 
2.33.1

