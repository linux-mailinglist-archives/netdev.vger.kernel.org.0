Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3662B9B42
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgKSTLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgKSTLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:11:00 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B311C0613CF;
        Thu, 19 Nov 2020 11:11:00 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 34so5076919pgp.10;
        Thu, 19 Nov 2020 11:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ET473FpFp3FzmBYHYLYam48z0xHPg334N2d9XOKTrpI=;
        b=M9O64TUOsf61++A5YWBgorUTqsUhConEUSLgnhF2hmpRoMo9gbHMK0Y5lS02yWOQMn
         xrFztSbuLNQ+ucnJjCg73QRIECuWEG+UR2GOfVP2Mi+rJVZf9I83c8TB9KF9Mx0DCQIA
         S5xL24QjlB8rFTuwVcmUY0UFBOak89hVYYiTrzQTOcOr09VZvuHUqOPNvaTHx/uOSWzr
         y5ZKb595uyBSpRpNI0CZNInd4rqqkQmzLNBTRx/yGjwDlJzPes7Gmth90pGXMZKrnfRh
         FJxt8mxU95GAFuC0N0CG+/whmIcWoGZUPxlmWUy8+JWcC8kzHnkSMrOxTotefn/d24i1
         cF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ET473FpFp3FzmBYHYLYam48z0xHPg334N2d9XOKTrpI=;
        b=saAL8lAtYi9pQyFFS6FlAAtdo6kJfCBBe1ZknAiZoZkhnxBCA1AnNXThFI+yssJzfv
         nie7tHjvDJFLXkji5J9pMvxf+LmOEwS0xi0sNsZ8+YtCeiIR+XYHnj1Fqf1JHFlLtX+c
         I0McBcdWFDBdyyDGbCLGosK6mZF9hBkD72CBzIJYCAvGg7a+lA3gCXiZvdaoIhZIi1lw
         J2RQfQ1t96oMqufph44q2zuq/LeZQJKotdFy/erQDLVDNSV8a/trNeqscLaJzopMgRkt
         90COlAU75tWqfIN8K5S6gcgKPwjwlrz3pDZL0uKndNoPVi8ev4ebwBI39c5m/i9WMbnV
         i6kg==
X-Gm-Message-State: AOAM530G382UljjIs/IMy6k8o9j4eFS/0LfE5kQujf94ggrf4ZaI6XSn
        RrXl6Aetj0XpePhuNJj+RC0=
X-Google-Smtp-Source: ABdhPJypWIrTZZnDbwimuxmJITaEMB9QJgxNpUGeZf5bAuv3w+zqFXccFDnDvw5F0qjTUHsJf5qQlQ==
X-Received: by 2002:aa7:8105:0:b029:18e:c8d9:2c24 with SMTP id b5-20020aa781050000b029018ec8d92c24mr10267432pfi.49.1605813059959;
        Thu, 19 Nov 2020 11:10:59 -0800 (PST)
Received: from localhost.localdomain ([45.118.167.196])
        by smtp.googlemail.com with ESMTPSA id x3sm452245pjk.17.2020.11.19.11.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 11:10:58 -0800 (PST)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     saeed@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH v5 net] rose: Fix Null pointer dereference in rose_send_frame()
Date:   Fri, 20 Nov 2020 00:40:43 +0530
Message-Id: <20201119191043.28813-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115114448.GA40574@Thinkpad>
References: <20201115114448.GA40574@Thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rose_send_frame() dereferences `neigh->dev` when called from
rose_transmit_clear_request(), and the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
and it is initialized in rose_add_loopback_neigh() as NULL.
i.e when `rose_loopback_neigh` used in rose_loopback_timer()
its `->dev` was still NULL and rose_loopback_timer() was calling
rose_rx_call_request() without checking for NULL.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Fix it by adding NULL checking for `rose_loopback_neigh->dev`
in rose_loopback_timer().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
Changes in v5:
	- Free `dev` in rose_rx_call_request() and add NULL check for `dev` before freeing it.
	(Suggested-by: Jakub Kicinski <kuba@kernel.org>)
Changes in v4:
	- Free `dev`(on dev_hold()), when neigh->dev is NULL. (Suggested-by: Jakub Kicinski <kuba@kernel.org>)
Changes in v3:
        - Corrected checkpatch warnings and errors (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
        - Added "Fixes:" tag (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
Changes in v2:
        - Added NULL check in rose_loopback_timer() (Suggested-by: Greg KH <gregkh@linuxfoundation.org>)

 net/rose/rose_loopback.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 7b094275ea8b..11c45c8c6c16 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,10 +96,19 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}

 		if (frametype == ROSE_CALL_REQUEST) {
-			if ((dev = rose_dev_get(dest)) != NULL) {
-				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
-					kfree_skb(skb);
-			} else {
+			if (!rose_loopback_neigh->dev) {
+				kfree_skb(skb);
+				continue;
+			}
+
+			dev = rose_dev_get(dest);
+			if (!dev) {
+				kfree_skb(skb);
+				continue;
+			}
+
+			if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0) {
+				dev_put(dev);
 				kfree_skb(skb);
 			}
 		} else {
--
2.29.2

