Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA5B26D313
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 07:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgIQF3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 01:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQF3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 01:29:50 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9998BC06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:29:50 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id w2so765448qvr.19
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=DZtn9Rr5NAewp1qZv3hmsmsuQTNnLlGeDd7GB4F/76U=;
        b=N5U4fkyXuSJJo80wRUSBbIGDBA3w3e+zfqT8bI/6fqISU81t+RiYolHSLlsTvDD19M
         xjSY3EkS66Pg6nTWAfsAMszpfpx/k1bH0dAwzGAkqAiS35tTV9xqJysEccv+1kZnP/xr
         4LeXHMQXLFZ0mkry9aoUkV0IxLTVIHGv6VoRNyraUdBGsGxjvyrAmEL9+6lCOcbqCU/6
         ffRKh03667e2hOaNrprKQRxp6HeqietvqwpIGd43ki0BKutqaMI9X49iqoLqGYMg+D8z
         cdo5fFARDhZeRM5RlYxWuw3CHSU0ORRCSB21QPhNCZHqjw27+I2yEXQaHlapIcXd84bE
         /yQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=DZtn9Rr5NAewp1qZv3hmsmsuQTNnLlGeDd7GB4F/76U=;
        b=rO7tk2h1wvUsZZLSe3X5fIPEUJF8Sm6RTcCplqoqcqT3pVlTQRst1rJBNnPnYKx2H0
         HOZhr8vhlhJANy0ec+x8JFwVS4t+1vr4xplpsgpuf4S2olaA2zm22klru68RFGsuTttZ
         Gc20rlCyVZDGntG+AAB707yMeotOJNmhEfv8pW+F3nSQtny/4+Eu4I4bCD2FPvXDqR9V
         4L7OCBYLybzmdWivB8sEHeTZez5VY+5uNna7xUIsY3UL1UTnymjyVoWwMlZjUVju8RW5
         fRYj5ULFI8DCQGC3ZaEjUtA4XYydbSIpCuGc8hwiu5C1BdzrQXEZ3u7V1t1LX/z7KB3H
         ENsg==
X-Gm-Message-State: AOAM531MXVYZhtPXTPIb56VjhEDw0fHNhDHuevhmb2PlIgznm9yvIVEa
        xO13aQ+3di5Exlhbmw7XobzNVHdJO1p5vO58Mw==
X-Google-Smtp-Source: ABdhPJxBxxNGWgG//JG92tXqEKNVQMibAYANYD7k1sVUyTqLXpM98PAOyJ1XVSkQqbQ9sd3NjaACQu/QPCpkCcX6lQ==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:fe8b:: with SMTP id
 d11mr10852077qvs.48.1600320588288; Wed, 16 Sep 2020 22:29:48 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:29:38 +0800
Message-Id: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH 1/6] Bluetooth: Update Adv monitor count upon removal
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     mcchou@chromium.org, marcel@holtmann.org, mmandlik@chromium.org,
        howardchung@google.com, luiz.dentz@gmail.com, alainm@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miao-chen Chou <mcchou@chromium.org>

This fixes the count of Adv monitor upon monitor removal.

The following test was performed.
- Start two btmgmt consoles, issue a btmgmt advmon-remove command on one
console and observe a MGMT_EV_ADV_MONITOR_REMOVED event on the other.

Signed-off-by: Howard Chung <howardchung@google.com>
Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 net/bluetooth/hci_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8a2645a833013..f30a1f5950e15 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3061,6 +3061,7 @@ static int free_adv_monitor(int id, void *ptr, void *data)
 
 	idr_remove(&hdev->adv_monitors_idr, monitor->handle);
 	hci_free_adv_monitor(monitor);
+	hdev->adv_monitors_cnt--;
 
 	return 0;
 }
@@ -3077,6 +3078,7 @@ int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
 
 		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
 		hci_free_adv_monitor(monitor);
+		hdev->adv_monitors_cnt--;
 	} else {
 		/* Remove all monitors if handle is 0. */
 		idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
-- 
2.28.0.618.gf4bc123cb7-goog

