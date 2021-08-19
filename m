Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD13F1C6B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbhHSPQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhHSPQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:16:06 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F1BC061575;
        Thu, 19 Aug 2021 08:15:28 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id c12so12150528ljr.5;
        Thu, 19 Aug 2021 08:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vZjXPmOCbplWUcGOomjfHqgKyvdCopt0JA72wssuj18=;
        b=qIY/kbWXI66jpRCw0g3aG654Q0g3cTSO8/Gc+/KbOiUuKcq1KvHgOn0PebKOA038o5
         3k8lPgXmhG9O/nHDJMsFkEo7XRKFt4AS8jEJDyTmVQ7ELbZoGJlwuDrgoagiox71Ko/y
         cI2h/DicOTZJRlGA9nPeYMp3M5mWeF9mjQ3hsPr7MRFr3dWK1YPGjVsDwdqwN9ejjy8n
         2Ncq3D/mnYsf8TenPmorYaUJj2cW/0MuAtja7TCJKOLBEU/+SXolsAZz/g7dEIeeQyyq
         pb/0rA4MfdCDK1jY7pnjTyx9HEhr2WMH8cVTzMSSJYvotOF6lcykoBHAszN6WOxWtfC5
         XxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZjXPmOCbplWUcGOomjfHqgKyvdCopt0JA72wssuj18=;
        b=Vrd5B5q/dUS2nsJC41hlp4VeyEwuO0jrqlu9u8JYwOZ6Xe2LLP1+MK36URm9f9YIeG
         cxeLwWbkafsqQMlWOZEOKwyP7MXOYP7D2AQNJ+ORdqoJOgK4j9/vfpKj2bqNkJA74yDs
         lYi89WRA7Q4CzkrHacBFgJj6hxWGC3jZtkEFWOJrb0AcM/g3c4bNlogay6F39GgqdWn4
         mVMD8YdoBEObY8mYyiKuOho8Zmc8sB0izRUc4QPvbwHrd18YmRHynUjx560zwu73XO/0
         6SSO55Cl6rh3vByS8fF7zEQkVAuQxktdp5TJdnGznuvN3jjBxNgDhvDPAdaX1pz7T5vB
         bI0g==
X-Gm-Message-State: AOAM530isGLb7MN630ZU3y7ROwP3IVfGZ1pB17muaRfGEwnn5LYoMxya
        8oksDwOHm8RbKBavCzGe4Jo=
X-Google-Smtp-Source: ABdhPJyAvTUD4BUAIU3FuCccZygogstrXmZzgehkWq/i4HWe50f4H9ujcTO+s3wFDonDLj7w6WFo+A==
X-Received: by 2002:a2e:a54c:: with SMTP id e12mr12894890ljn.139.1629386127253;
        Thu, 19 Aug 2021 08:15:27 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id br33sm334616lfb.46.2021.08.19.08.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 08:15:26 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Subject: [PATCH v2] Bluetooth: add timeout sanity check to hci_inquiry
Date:   Thu, 19 Aug 2021 18:15:21 +0300
Message-Id: <20210819151521.17380-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <0038C6D9-DEAF-4CB2-874C-00F6CEFCF26C@holtmann.org>
References: <0038C6D9-DEAF-4CB2-874C-00F6CEFCF26C@holtmann.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot hit "task hung" bug in hci_req_sync(). The problem was in
unreasonable huge inquiry timeout passed from userspace.
Fix it by adding sanity check for timeout value to hci_inquiry().

Since hci_inquiry() is the only user of hci_req_sync() with user
controlled timeout value, it makes sense to check timeout value in
hci_inquiry() and don't touch hci_req_sync().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Removed define + added comment suggested by Marcel

---
 net/bluetooth/hci_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..170f513efa86 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1343,6 +1343,12 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	/* Restrict maximum inquiry length to 60 seconds */
+	if (ir.length > 60) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
-- 
2.32.0

