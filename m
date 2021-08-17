Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB123EEAFF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 12:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbhHQKbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 06:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhHQKbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 06:31:50 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272DCC06179A;
        Tue, 17 Aug 2021 03:31:17 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w20so40435722lfu.7;
        Tue, 17 Aug 2021 03:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qMZOt5ueMN6fg1XgUmhU0282KCRD6RMSAKl1MQqd8U8=;
        b=hd2QvJ0U+Lcn6l8mKOtXOKCcXnW4/nG6Be8smA6IJf/AmJMVuZG/A5jO9cQvnj70oV
         6vCk0bmCKVFrEQ+x48N1CeUT1p64dz0uagrMWVZ1JkvaIAl8yxatXT1+Kvn5z89rABGF
         gRhElFWJXVAQh++1aG7z9I+WciHBJG+YVSP4Mx7FDT0Gf/v5msQKTomjW6bAtk9yztMo
         Pz/SrJdP0SbIXE2PpwlKL2xq6K0U1U+urS/vVXx8SV8I7yHbDkzowTl0nQKyWE6o7HKN
         cruoMMZyv8gNwp8B3FmB2Rk5nyWfQR2MOlfALaQBdoLn27bZiCgrlt/jUnkCp56p46mA
         BH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qMZOt5ueMN6fg1XgUmhU0282KCRD6RMSAKl1MQqd8U8=;
        b=gCeYZ1Rkyy6Hif9wWgn7QGdgFdLqTuPK3RB3T9hiv6yfQHlIa5hf4RqPzieeHcMZR7
         /Aif9UTEhdO2j8Nk3awm5nxsFYphwpzk0gdmR+qpc5Kl5rEYfumh4cI5x4cG8V8t03rq
         3cQxO+vQfnOrptMmbo94CFnEWIEyD7fyrMic4vkyZfZulk7wlJGZzPxt0Pkcyd63c5ON
         frivk/owDXSdpcTHXzprj0qP7mogUJbot2IACyNJQ0QmFXdlLstz5yyU3jDHte/qNt4l
         rmSTvcZwdvtiR5kcoTP4rM7O+cTBKPzZPhvQBtEWw8mMXd1hz41V7UqMFIlnsfE7EqaB
         xCyQ==
X-Gm-Message-State: AOAM532T0SswnLnTyRF9PL/zWGw6X5h/QXKDtT8V6WYsnwCEgGtOQ4rN
        PreYJOCLx+shzy+RiHa+AD4i18ZKQoVdS2/c
X-Google-Smtp-Source: ABdhPJwoWbG83NrILDBrdTVFNpU3zS+CDvxpw6b1IS8FPovIvgEu/VXweXWMoo4FeLjjCu59rALz+Q==
X-Received: by 2002:a05:6512:3889:: with SMTP id n9mr1861128lft.589.1629196275367;
        Tue, 17 Aug 2021 03:31:15 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id h8sm136335ljh.27.2021.08.17.03.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 03:31:14 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Subject: [PATCH] Bluetooth: add timeout sanity check to hci_inquiry
Date:   Tue, 17 Aug 2021 13:31:08 +0300
Message-Id: <20210817103108.1160-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot hit "task hung" bug in hci_req_sync(). The problem was in
unreasonable huge inquiry timeout passed from userspace.
Fix it by adding sanity check for timeout value and add constant to
hsi_sock.h to inform userspace, that hci_inquiry_req::length field has
maximum possible value.

Since hci_inquiry() is the only user of hci_req_sync() with user
controlled timeout value, it makes sense to check timeout value in
hci_inquiry() and don't touch hci_req_sync().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Hi, Bluetooth maintainers/reviewers!

I believe, 60 seconds will be more than enough for inquiry request. I've
searched for examples on the internet and maximum ir.length I found was 
8. Maybe, we have users, which need more than 60 seconds... I look forward
to receiving your views on this value.

---
 include/net/bluetooth/hci_sock.h | 1 +
 net/bluetooth/hci_core.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/bluetooth/hci_sock.h b/include/net/bluetooth/hci_sock.h
index 9949870f7d78..1cd63d4da00b 100644
--- a/include/net/bluetooth/hci_sock.h
+++ b/include/net/bluetooth/hci_sock.h
@@ -168,6 +168,7 @@ struct hci_inquiry_req {
 	__u16 dev_id;
 	__u16 flags;
 	__u8  lap[3];
+#define HCI_INQUIRY_MAX_TIMEOUT		30
 	__u8  length;
 	__u8  num_rsp;
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..104babf67351 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1343,6 +1343,11 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	if (ir.length > HCI_INQUIRY_MAX_TIMEOUT) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
-- 
2.32.0

