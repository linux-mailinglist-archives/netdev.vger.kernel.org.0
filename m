Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2226D727
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgIQIuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgIQIrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:47:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BE4C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:47:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r4so981838pgl.20
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=TA6OcLEDFUQ9qpFM/VfmsZehtp68guNS6V1Wug38hMA=;
        b=HG/p8OtMNJt3DU2dQ9qbZrDYYfxtJ1yHfmzDGy2+DvKn5KAtYBklDNcgaWqriMJR7T
         QKi/tQrMIzGJUomQakhUysfJPgrC3N/hmHFw+jMpo6aaRYRQU3PBn0OtGDpqVDPaRyV1
         K64lZnsIL4rAsvBvNsjRsRVWVDTYU2UeqxcCAFuloKVKMXiUuaVUAYQk+bWGK0FBpLtX
         qMMxxjVsIn7aEdaeYEDjYGjKJJkdH8hblUgpPbwFrg6UpeMF+MP+4GU+gWDvwGRcVlHa
         IFkTYGGulSgbqwlFsRZXAjoE9Wn81CYYbQfvyhbTZ6WjrETt0igM0XKNY5RWIkQC5Qqv
         fPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=TA6OcLEDFUQ9qpFM/VfmsZehtp68guNS6V1Wug38hMA=;
        b=qmVgwfHXlYZpu/J5U+HXN/2/Y1B6xiWrWlzNcb7SvPGdLTKfZoAs7E9c9TngezjMl6
         rR8OqMmc2u2OWz7s1Sx+JbKd3ANbcw7dCAWFw4dOYo/cQFlPONSQepWeNhstrNkwoS1Y
         GiLCnrPHQ81lT53IwbYBQisft/q1pe31pHPs6dtrJlTpsc7lu8jVSIxy+6cGinxcLAHX
         8HuucDw1Ta1bmmnKR9WriFQtzrJbbCiToXbomXpGQmrj5xqGO6ktPFTiyDw2Y2C02LvT
         ls6oLOgcIwBKTuhAwx+iWBwIIHchYP0iMVYxnLJRNzhzlZzFO5RYdc8Qp00LEAanVIvy
         PCbg==
X-Gm-Message-State: AOAM532mv8eS1LoLV955AuRjG1E+t/Rtwd/eh0B1xBRVMiGc7zEqH74b
        u3dxXDmYfA67A7dfbQqzYuciKU7Xe5M1FZbVMw==
X-Google-Smtp-Source: ABdhPJy+2YhIYObzfV77phmcp2UmHDPK1RrJqmYemdv0On6uAglDARSoIJlhbey92KAYkU+onC3EkUEhGJ6zxG2F6g==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:90b:15c6:: with SMTP id
 lh6mr715470pjb.0.1600332441228; Thu, 17 Sep 2020 01:47:21 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:47:10 +0800
Message-Id: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH v2 1/6] Bluetooth: Update Adv monitor count upon removal
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com, mmandlik@chromium.org,
        mcchou@chromium.org, howardchung@google.com, alainm@chromium.org,
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

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

Changes in v2:
- delete 'case 0x001c' in mgmt_config.c

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

