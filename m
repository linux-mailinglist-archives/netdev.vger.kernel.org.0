Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEECE18C41A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgCTAHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:07:33 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36362 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgCTAHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:07:32 -0400
Received: by mail-pj1-f68.google.com with SMTP id nu11so1716719pjb.1
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=acxg8uMg4NFbDr08SQGvm9+PmwMFAk5ItZG8WlsBwhw=;
        b=U4pH9P4lw7V4TqqJGAC4rzIvCYDIBC4taKiNw5Voc2CjmHjW4dcSzroKQPrU/tO2eT
         qcpTnDOVDZ+oxU/PyLmsccmdzJ50qp5U6+KNCvmiv5I04k5+vqgG56i1XfP/o2zpDkn+
         tkv+FKCH6rSJiCeQj86PLhl5xNyh4cFBuN/zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=acxg8uMg4NFbDr08SQGvm9+PmwMFAk5ItZG8WlsBwhw=;
        b=hINyGkVfVHN0DDQI/na36kPjIGM5Yzbe1oBlEXJObv/Kg0ijdZFgOSEjHJuwsPDWBh
         2xBtbGUT40St/K7qCSwT1NztyTSm0IOy1ZkiV3xyRZW9yY22SB4r49KBc/lsafPyK4ZN
         IfH99FNgwrk7TjZOBum+B9UiSoWK7cbZ5snn9demdcF+mBtiCW2lZ2Pdfzo4lne0OMQw
         p3NFqSkf4fZRaeAeOoBojSFoaYSKar7r5eeIGNgNvKUvjvYX7EMVgACwcRweNH0qWiHY
         7hxibVU8jLqnQIG+0nqj+5dnmfSPrAclCe1ITUUaCNwuId3opH4IzuYcB151rVtEAkCV
         oqkA==
X-Gm-Message-State: ANhLgQ2w8pmt9MN0g3+WccuaMBKJ5GkM1ZOyQmFiOM4kJjKwmXrpmNjo
        AI/zX+LyuwnzziCBpGJ4VVx6Kg==
X-Google-Smtp-Source: ADFU+vv/toBfL9yTu+DqZU5VqPE3K2kICxRTYJk9CvoYTLtFLKPYYBMa9YYsnozfeUZtqI5h333lRg==
X-Received: by 2002:a17:90a:368f:: with SMTP id t15mr6699247pjb.23.1584662851250;
        Thu, 19 Mar 2020 17:07:31 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id m12sm2928292pjf.25.2020.03.19.17.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:07:30 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/2] Bluetooth: Fix incorrect branch in connection complete
Date:   Thu, 19 Mar 2020 17:07:13 -0700
Message-Id: <20200319170708.2.Ibcb4900b4d77c3f1df9e43e4c951bf230d65f12d@changeid>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <20200320000713.32899-1-abhishekpandit@chromium.org>
References: <20200320000713.32899-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When handling auto-connected devices, we should execute the rest of the
connection complete when it was previously discovered and it is an ACL
connection.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 net/bluetooth/hci_event.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 20408d386268..cd3d7d90029b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2539,16 +2539,17 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 				bt_dev_err(hdev, "no memory for new conn");
 				goto unlock;
 			}
-		}
-
-		if (ev->link_type != SCO_LINK)
-			goto unlock;
+		} else {
+			if (ev->link_type != SCO_LINK)
+				goto unlock;
 
-		conn = hci_conn_hash_lookup_ba(hdev, ESCO_LINK, &ev->bdaddr);
-		if (!conn)
-			goto unlock;
+			conn = hci_conn_hash_lookup_ba(hdev, ESCO_LINK,
+						       &ev->bdaddr);
+			if (!conn)
+				goto unlock;
 
-		conn->type = SCO_LINK;
+			conn->type = SCO_LINK;
+		}
 	}
 
 	if (!ev->status) {
-- 
2.25.1.696.g5e7596f4ac-goog

