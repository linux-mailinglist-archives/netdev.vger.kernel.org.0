Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D708A48F6D1
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiAOM1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiAOM1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:27:42 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E976DC06173F;
        Sat, 15 Jan 2022 04:27:41 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id x7so39366744lfu.8;
        Sat, 15 Jan 2022 04:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JJbm/APZKQh33EDDJ0deCmvbxjw0T/eT+AvAf6q6Q50=;
        b=aRmsLlOM/p+Nex8FP09SSjq/DCDIYJlqBECcM2RlTvaQziXt2ou5pklx2rstPVOoPZ
         afP5n+NvQpgoB8mrd8tBJ16NpNBJRDiQKGd4RyOG7VbF3vAU1I/TSbZOVJdkqSHA9JMV
         3wjCT9A4/9r+h7PgMHFtD87EiGMl0ClOJPG2LHdJ2w9Zi4SdWJqTooikoPInWPVtiMbg
         eoCTNqiCyB1t5eshA5iMnG6Hqogc0ZMfg/EoUHBEODI92VGXvOi2L2LWbyeYpOQPDI/P
         6UQdoCunlO1M2H1QGkPz8kVsfAKqxIhLWuADTvkreFFLn4IlC2jGD/NBB3hHILa7fGVX
         T6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JJbm/APZKQh33EDDJ0deCmvbxjw0T/eT+AvAf6q6Q50=;
        b=VOP850A+LaxiImgP3OvqmUx6fDX1ELYb4ZP+fVFxbkU8VEzmOiyME+t3AmeEvhd5iW
         O+91QfKm+LiKWZo1mNcG56dZSws5SxklP08YdOXlsvpo3+j8trOBE2pOqYNFthvLgqSb
         eLSuzujFjt6XWkEa9yThFZPFj3eFWRazxScMhBad8Ez+hCsDso4SDXsXETOZgF02/Xxm
         p1YLPQ9+bxhvEkOru4kbEMiii+RRDslzeVPPLNtPA1xfMRcEu2QGW0vFNcXQcjNwixCD
         Ay7AGJyq5Mjoa5bU4lqVVY8zOjiTUDy46NtpfZ39VY86TFe3K88riinP4ugbiOTU5h1n
         Jofw==
X-Gm-Message-State: AOAM532Uw+WBJKmCyEh2tr46SvNmNqMoOMeZnecYzOLr96eCXfOfldFa
        o1YWd7wMqcJxSBJ47PanYzI=
X-Google-Smtp-Source: ABdhPJxVwovjSBNmo+0FrBrzSimp8hZMZDwYn4WjWcvnXetAK3K/WKqhxb81sKEelOYcX8LMox9G+g==
X-Received: by 2002:ac2:5459:: with SMTP id d25mr10026879lfn.231.1642249660225;
        Sat, 15 Jan 2022 04:27:40 -0800 (PST)
Received: from localhost.localdomain ([217.117.245.67])
        by smtp.gmail.com with ESMTPSA id c21sm857160lfj.128.2022.01.15.04.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 04:27:39 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com,
        vasanth@atheros.com, Sujith.Manoharan@atheros.com,
        senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
Subject: [PATCH] ath9k_htc: fix uninit value bugs
Date:   Sat, 15 Jan 2022 15:27:33 +0300
Message-Id: <20220115122733.11160-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported 2 KMSAN bugs in ath9k. All of them are caused by missing
field initialization.

In htc_connect_service() svc_meta_len and pad are not initialized. Based
on code it looks like in current skb there is no service data, so simply
initialize svc_meta_len to 0.

htc_issue_send() does not initialize htc_frame_hdr::control array. Based
on firmware code, it will initialize it by itself, so simply zero whole
array to make KMSAN happy

Fail logs:

BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 hif_usb_send_regout drivers/net/wireless/ath/ath9k/hif_usb.c:127 [inline]
 hif_usb_send+0x5f0/0x16f0 drivers/net/wireless/ath/ath9k/hif_usb.c:479
 htc_issue_send drivers/net/wireless/ath/ath9k/htc_hst.c:34 [inline]
 htc_connect_service+0x143e/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:275
...

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 htc_connect_service+0x1029/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:258
...

Bytes 4-7 of 18 are uninitialized
Memory access of size 18 starts at ffff888027377e00

BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 hif_usb_send_regout drivers/net/wireless/ath/ath9k/hif_usb.c:127 [inline]
 hif_usb_send+0x5f0/0x16f0 drivers/net/wireless/ath/ath9k/hif_usb.c:479
 htc_issue_send drivers/net/wireless/ath/ath9k/htc_hst.c:34 [inline]
 htc_connect_service+0x143e/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:275
...

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 htc_connect_service+0x1029/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:258
...

Bytes 16-17 of 18 are uninitialized
Memory access of size 18 starts at ffff888027377e00

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-by: syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 510e61e97dbc..994ec48b2f66 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -30,6 +30,7 @@ static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
 	hdr->endpoint_id = epid;
 	hdr->flags = flags;
 	hdr->payload_len = cpu_to_be16(len);
+	memset(hdr->control, 0, sizeof(hdr->control));
 
 	status = target->hif->send(target->hif_dev, endpoint->ul_pipeid, skb);
 
@@ -272,6 +273,10 @@ int htc_connect_service(struct htc_target *target,
 	conn_msg->dl_pipeid = endpoint->dl_pipeid;
 	conn_msg->ul_pipeid = endpoint->ul_pipeid;
 
+	/* To prevent infoleak */
+	conn_msg->svc_meta_len = 0;
+	conn_msg->pad = 0;
+
 	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0);
 	if (ret)
 		goto err;
-- 
2.34.1

