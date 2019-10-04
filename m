Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E84CB2A7
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 02:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbfJDAJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 20:09:57 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39440 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729940AbfJDAJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 20:09:57 -0400
Received: by mail-pg1-f193.google.com with SMTP id e1so2705451pgj.6
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 17:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJSnURvrTnKRW7XCAUl3csqPTcgWZWsUjhaWf0zhO5g=;
        b=gSADe+cFeT+SNla0USBTTbchOiQAsLsRGopRcflGKL9W5IS3MZZoAp5zvVcQxKEobL
         0+BvUipTyKtCca0sEjQt7eqoBiJ+flXQzgKMFNQ/N3iKesdiWlqD2Pp7jIcOoWLV4+XB
         FzpHiowmCWE1ZCeO9vMa6CPlQ7XWKtY/kd0+QY+sgpXwGJSt0fLhGaflhT/j+xp8gtd2
         PHvXETltk4MySeO015s3XAkDt/wi8Oo4/N5lw6i8GNafH91OOVZC+4MRN3iOXqdEr0Kl
         GUcxgD4g/eSQkLZfUvO/X9RrLxeGOqsErk1D/MlPz/mv+RVoqwl0i6AVUZ2+2u9KKfLB
         NHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJSnURvrTnKRW7XCAUl3csqPTcgWZWsUjhaWf0zhO5g=;
        b=cgrHcOHz5Wa2DsVo/2eav3HUVttGw+D88JmommJVRZUxyjtz3YE1XXikePI+/gXFF1
         QuIHPjehgwQ3sfRB/IvvVOkpILYZxAH7adSKbpp6lb6hTrpi9uJ8Y0l+jkn0D/wzWWoS
         hd/RRf6BO0EhI04BaFU55vmtFxEATv05X3OTGQSgCrbJ6y0cBFiuDO86jU5CIMitg+gT
         hxbZBByoKDx4qzDKK/i3wS9MJx2MJTPXb7WObXftwFOhcd27bszQS8qte52TylxOjxjo
         KYvPGW/UloR34tBZIqk4bXqV/qoXIA21Rlfxrn6JSkRK/o8TBVb2uq6U1nc9Nf5mkJG7
         1O2Q==
X-Gm-Message-State: APjAAAXl/utZLHqBDAXLE1Y/dRzkwhdhNG5tNNDac1dbReVX19L0oOhu
        1FHmo3If5KMa46UFmgUNZJwVDA==
X-Google-Smtp-Source: APXvYqxCQMs3UqvPro/uqk4/SIPuDqadTVA4fcofBe/lfbWVzELrP9px1CS+soylpvxJoqmS0m7Zjg==
X-Received: by 2002:a62:8749:: with SMTP id i70mr13449404pfe.12.1570147795117;
        Thu, 03 Oct 2019 17:09:55 -0700 (PDT)
Received: from mkorpershoek-XPS-13-9370.hsd1.ca.comcast.net ([2601:647:5700:f97e:44ec:171c:55e2:48])
        by smtp.gmail.com with ESMTPSA id g4sm4267913pfo.33.2019.10.03.17.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 17:09:54 -0700 (PDT)
From:   Mattijs Korpershoek <mkorpershoek@baylibre.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: hci_core: fix init with HCI_QUIRK_NON_PERSISTENT_SETUP
Date:   Thu,  3 Oct 2019 17:09:32 -0700
Message-Id: <20191004000933.24575-1-mkorpershoek@baylibre.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some HCI devices which have the HCI_QUIRK_NON_PERSISTENT_SETUP [1]
require a call to setup() to be ran after every open().

During the setup() stage, these devices expect the chip to acknowledge
its setup() completion via vendor specific frames.

If userspace opens() such HCI device in HCI_USER_CHANNEL [2] mode,
the vendor specific frames are never tranmitted to the driver, as
they are filtered in hci_rx_work().

Allow HCI devices which have HCI_QUIRK_NON_PERSISTENT_SETUP to process
frames if the HCI device is is HCI_INIT state.

[1] https://lore.kernel.org/patchwork/patch/965071/
[2] https://www.spinics.net/lists/linux-bluetooth/msg37345.html

Fixes: 740011cfe948 ("Bluetooth: Add new quirk for non-persistent setup settings")
Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
---
Some more background on the change follows:

The Android bluetooth stack (Bluedroid) also has a HAL implementation
which follows Linux's standard rfkill interface [1].

This implementation relies on the HCI_CHANNEL_USER feature to get
exclusive access to the underlying bluetooth device.

When testing this along with the btkmtksdio driver, the
chip appeared unresponsive when calling the following from userspace:

    struct sockaddr_hci addr;
    int fd;

    fd = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);

    memset(&addr, 0, sizeof(addr));
    addr.hci_family = AF_BLUETOOTH;
    addr.hci_dev = 0;
    addr.hci_channel = HCI_CHANNEL_USER;

    bind(fd, (struct sockaddr *) &addr, sizeof(addr)); # device hangs

In the case of bluetooth drivers exposing QUIRK_NON_PERSISTENT_SETUP
such as btmtksdio, setup() is called each multiple times.
In particular, when userspace calls bind(), the setup() is called again
and vendor specific commands might be send to re-initialize the chip.

Those commands are filtered out by hci_core in HCI_CHANNEL_USER mode,
preventing setup() from completing successfully.

This has been tested on a 4.19 kernel based on Android Common Kernel.
It has also been compile tested on bluetooth-next.

[1] https://android.googlesource.com/platform/system/bt/+/refs/heads/master/vendor_libs/linux/interface/

 net/bluetooth/hci_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 04bc79359a17..5f12e8574d54 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4440,9 +4440,20 @@ static void hci_rx_work(struct work_struct *work)
 			hci_send_to_sock(hdev, skb);
 		}
 
+		/* If the device has been opened in HCI_USER_CHANNEL,
+		 * the userspace has exclusive access to device.
+		 * When HCI_QUIRK_NON_PERSISTENT_SETUP is set and
+		 * device is HCI_INIT,  we still need to process
+		 * the data packets to the driver in order
+		 * to complete its setup().
+		 */
 		if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
-			kfree_skb(skb);
-			continue;
+			if (!test_bit(HCI_QUIRK_NON_PERSISTENT_SETUP,
+				      &hdev->quirks) ||
+			    !test_bit(HCI_INIT, &hdev->flags)) {
+				kfree_skb(skb);
+				continue;
+			}
 		}
 
 		if (test_bit(HCI_INIT, &hdev->flags)) {
-- 
2.20.1

