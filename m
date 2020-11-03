Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAA2A5738
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbgKCVkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731573AbgKCVkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:40:03 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996D7C0613D1;
        Tue,  3 Nov 2020 13:40:01 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 13so15467038pfy.4;
        Tue, 03 Nov 2020 13:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYxyrhJUyD7xUDhPMGT9KbQkgLtBSXjotD//z5c9IGM=;
        b=uBcqtXxCIT7OQTiJdT+Qnn+S0FnPXZBeM86TpyoW967BncdTfodSmN8/R+yRaV1MJQ
         PDw1MVYyBj2oyt+NREUIyk6viRXgbJqLHlw2l10HkuyyplZ+5K1VVP6ObwjesMPZjMTN
         wYEIXqB6tk0TAJqiI6in56jENXYlR8fBJkitzcc0Fcv2uTHwQQwvNXm9/AMm9wbNJ8ZJ
         DbWRyih0sWmnJDfAllXmXM1YOJmiMzm9oqcr2CXQW2ujcrARs/xjkH9KUsotrc1QmgAd
         GPi195xiIdqJVS22MVHxmvwK2KSeT/nq8gHxkM1uMDgMGrsWn5tMxUG+t8JPnJfRX0Vy
         YzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYxyrhJUyD7xUDhPMGT9KbQkgLtBSXjotD//z5c9IGM=;
        b=V9oGW2ZyErXifScT+kVFsgFcTFZ6i3w4hwQplFmwtH5x4OZfiVHdLVo4iycwdPmpbb
         J9I9R8ZUGbNz8sHim+PoRhFVTGM1odmAVUpF1ZL+oiPd4UClxRTCAw6qAVXRmYgcVkpp
         WW0U0a/lT9It0GkUGcS7caNhp8EJX485gW41JOxStcepiyllIYIyTYrIcBUrGbFph7eC
         U44DXGKV2jJAgQgqOiRzk89c4fA4OGEuNyn7g22ttnH6peVreLwNFBEY2XRu7UoWcWKm
         0atsPoAvZhxKxhMNa3fphNP0EEZPnUHb/mDfXWWo7cu9rwKMK/RSsrXVFMEltsc8UFUR
         VqOg==
X-Gm-Message-State: AOAM531DD7ymDJNShCMZ+dTFRMoZKow/tWjI9VYdjITMpo3pIT2N5qqN
        M4Xk6S6f6bJKkfP/4wXljhydGIDias7sha1Hc/0=
X-Google-Smtp-Source: ABdhPJxGpC6zBdyx3WueMwpRhFVGrjpu+F+vENteUwE9jvq/wTmHenoZXXtA4WUWxTPWpLBili+/HA==
X-Received: by 2002:a17:90a:160f:: with SMTP id n15mr1193792pja.75.1604439596052;
        Tue, 03 Nov 2020 13:39:56 -0800 (PST)
Received: from localhost.localdomain ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id 15sm16420108pgs.52.2020.11.03.13.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:39:55 -0800 (PST)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
Subject: [PATCH 1/2] can: af_can: prevent potential access of uninitialized member in can_rcv()
Date:   Wed,  4 Nov 2020 03:09:05 +0530
Message-Id: <20201103213906.24219-2-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103213906.24219-1-anant.thazhemadam@gmail.com>
References: <20201103213906.24219-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In can_rcv(), cfd->len is uninitialized when skb->len = 0, and this
uninitialized cfd->len is accessed nonetheless by pr_warn_once().

Fix this uninitialized variable access by checking cfd->len's validity
condition (cfd->len > CAN_MAX_DLEN) separately after the skb->len's
condition is checked, and appropriately modify the log messages that
are generated as well.
In case either of the required conditions fail, the skb is freed and
NET_RX_DROP is returned, same as before.

Fixes: 8cb68751c115 ("can: af_can: can_rcv(): replace WARN_ONCE by pr_warn_once")
Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
Tested-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 net/can/af_can.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index ea29a6d97ef5..8ea01524f062 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -677,16 +677,25 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU ||
-		     cfd->len > CAN_MAX_DLEN)) {
-		pr_warn_once("PF_CAN: dropped non conform CAN skbuf: dev type %d, len %d, datalen %d\n",
+	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
+			     dev->type, skb->len);
+		goto free_skb;
+	}
+
+	/* This check is made separately since cfd->len would be uninitialized if skb->len = 0. */
+	if (unlikely(cfd->len > CAN_MAX_DLEN)) {
+		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d, datalen %d\n",
 			     dev->type, skb->len, cfd->len);
-		kfree_skb(skb);
-		return NET_RX_DROP;
+		goto free_skb;
 	}
 
 	can_receive(skb, dev);
 	return NET_RX_SUCCESS;
+
+free_skb:
+	kfree_skb(skb);
+	return NET_RX_DROP;
 }
 
 static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
2.25.1

