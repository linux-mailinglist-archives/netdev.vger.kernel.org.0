Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B13321A070
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGINEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgGINEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:04:09 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90CAC061A0B;
        Thu,  9 Jul 2020 06:04:09 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e12so1535600qtr.9;
        Thu, 09 Jul 2020 06:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QGEwhK7+HOB5UDgh/+KiU6/EDHzIv+5VNqxy139wdGM=;
        b=sdQvfSnDRAJBUsy+ESk4398OyprIdU0M5hUcZa+PA922C/+M4v0Z9UQNrEC4+TYTfA
         tYneGiD04EOzzYC+Wkznu3Illuf9QZVpbClghcgrU7TSFQQyCuPQpLR/6axtrYtHm8nN
         LhQNtvhdmlwyLWO1ggwMrTITgwSXREje0yQ7kTRWIE0N7pr1c9LgHgsaetzb0pTI8cA1
         12xew+zGAloXiRL9HDVvy3Tn8A1y0+bpLIgG0SGtaA8Q89Zyosc3trGCo5iDVkGV3D49
         TQWx0H/rl1dGETXFQgt7j2/rY/bO/iPkk4a7Qv7syqb8RycQ7I7GRnsXSDomWmElG3Hf
         ditw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QGEwhK7+HOB5UDgh/+KiU6/EDHzIv+5VNqxy139wdGM=;
        b=As9XFwq/lVKGnZ2TyWw8+5TxrsMLQAIpizOaA2q1AC/Q1lZz9T8k6tvIQkqxhc+0/Z
         /se379FSuEdWNK+uqTSl20r6BuFwA9bhAXKZZ0F+kThs7atMZOAgxQsecEMmCYa2w86C
         afDk9G7qUt1cOwz7Oxz6kqxX0WFBlROPHcyKMIfFM50JBVGMkmmzgI49R1XMLOA6Dgkp
         zROAKk14qhTyJgVAvPgDwxuxLXBMbrjXcjBqF8sAiHRKBbdXpcDs4vshAShbiJ1kOGWZ
         pwQXzPANWIpjBW5328xMnxJr7uqt3OIWsEnC/RmnoPCAusZMdbmrGgcw4v9CUCdLSiiZ
         Se2Q==
X-Gm-Message-State: AOAM532etSLmIaRbBg6B4sbDgC0m9XEnnQzRBCDSEgg0VuPoeXS/4bTT
        lMzYRjxz7IYehC7i9bbU8mOr9wjzsBHa
X-Google-Smtp-Source: ABdhPJw73GzxPHh95KuS+8iUpcn45BCe3CRu5/OTi7CJ2JO0fCvf4YVaQIXayVOeIH8DOPuKW38axQ==
X-Received: by 2002:ac8:47d0:: with SMTP id d16mr65906935qtr.349.1594299848927;
        Thu, 09 Jul 2020 06:04:08 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id v62sm3882456qkb.81.2020.07.09.06.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 06:04:08 -0700 (PDT)
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
Subject: [Linux-kernel-mentees] [PATCH v2] net/bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
Date:   Thu,  9 Jul 2020 09:02:24 -0400
Message-Id: <20200709130224.214204-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709051802.185168-1-yepeilin.cs@gmail.com>
References: <20200709051802.185168-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check upon `num_rsp` is insufficient. A malformed event packet with a
large `num_rsp` number makes hci_extended_inquiry_result_evt() go out
of bounds. Fix it.

This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=4bf11aa05c4ca51ce0df86e500fce486552dc8d2

Reported-by: syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Changes in v2:
    - Use `skb->len` instead of `skb->truesize` as the length limit.
    - Leave `num_rsp` as of type `int`.

 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 03a0759f2fc2..91cb3707d20a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4375,7 +4375,7 @@ static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
 
 	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
 
-	if (!num_rsp)
+	if (!num_rsp || skb->len < num_rsp * sizeof(*info))
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))
-- 
2.25.1

