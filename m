Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471EF2665D6
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIKRPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgIKRNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:13:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDDFC06179B
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:13:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md22so2881001pjb.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=14bPozYieqfHUM2JtvGo8R2UBkHMLrvThIi182GvG+I=;
        b=bZvtE3QrEvm8CZ8XtYT0Y3OLqPKCw+nNi8kIGhMnpxuYkmxoyoqIipKuS9Eb/YR4H6
         8/qdKimJJ9GnwRRgF0C64ME4K3+1hGiLEqHCg5uqkP0vF8bbt2r9VBiSKZejlhIgJfT0
         /fQ7Wqe0XuM/zM1zWhY8w3Ju63GauXLQn34Vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=14bPozYieqfHUM2JtvGo8R2UBkHMLrvThIi182GvG+I=;
        b=As4Ub3PY7H6JaGwVVsFK0dm65pgm8z7eVaBk8pfkaKPHdUW0Hj7Ac27A8QI7HYwO3Q
         6dHbLUdo/hf31cEHswR8sWmyQlH+ojWdrDx+uhU56ZBif09sPCCxUcvsOU2PCcyaB3NH
         9o+40Q7tBxvmkI5aC4sphMUZj6HZbVJ4BXrU/ErAK321SI/rSRWWCKrmCsFPy4ckInhF
         i0+Yz7qHjnrUmQPSOkFwWp6CFY9J/jWkPpD1xJ65b9tGQWULogzVg0ryskU6YK88sYLT
         mCbhEKih6jtrsewKv9DJp9v4i7zrGbessA25Gk4eFDzpncLIswpPhe49Fbv7uBD6pA0x
         BTcg==
X-Gm-Message-State: AOAM5328p2iDcoPRwGuenUnJvWy7nxUekopH2S0PZ7KRlVralqMO6bw4
        LOiVNDlMNdLGB7ejkWKLshgHvA==
X-Google-Smtp-Source: ABdhPJzrVoLvmYUJt7gXWG+GlxjSZFaqJNgeBictKPSlRR5p3H8wccaZE1GGSiHdeFUEqMvnqkhAuA==
X-Received: by 2002:a17:90a:4803:: with SMTP id a3mr3088770pjh.192.1599844393419;
        Fri, 11 Sep 2020 10:13:13 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id h9sm2787452pfc.28.2020.09.11.10.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 10:13:12 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RESEND PATCH 2/3] Bluetooth: Add suspend reason for device disconnect
Date:   Fri, 11 Sep 2020 10:13:05 -0700
Message-Id: <20200911101255.RESEND.2.Ib9bb75b65362d32104df86ffad479761680bb2cb@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200911171306.3758642-1-abhishekpandit@chromium.org>
References: <20200911171306.3758642-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update device disconnect event with reason 0x5 to indicate that device
disconnected because the controller is suspending.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
---

 include/net/bluetooth/mgmt.h | 1 +
 net/bluetooth/mgmt.c         | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index e19e33c7b65c34..a4b8935e0db97a 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -842,6 +842,7 @@ struct mgmt_ev_device_connected {
 #define MGMT_DEV_DISCONN_LOCAL_HOST	0x02
 #define MGMT_DEV_DISCONN_REMOTE		0x03
 #define MGMT_DEV_DISCONN_AUTH_FAILURE	0x04
+#define MGMT_DEV_DISCONN_LOCAL_HOST_SUSPEND	0x05
 
 #define MGMT_EV_DEVICE_DISCONNECTED	0x000C
 struct mgmt_ev_device_disconnected {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 1475a47edb080b..e33f45e20ed1e7 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8268,6 +8268,10 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	ev.addr.type = link_to_bdaddr(link_type, addr_type);
 	ev.reason = reason;
 
+	/* Report disconnects due to suspend */
+	if (hdev->suspended)
+		ev.reason = MGMT_DEV_DISCONN_LOCAL_HOST_SUSPEND;
+
 	mgmt_event(MGMT_EV_DEVICE_DISCONNECTED, hdev, &ev, sizeof(ev), sk);
 
 	if (sk)
-- 
2.28.0.618.gf4bc123cb7-goog

