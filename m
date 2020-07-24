Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0C222CB20
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXQeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:34:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092ACC0619D3;
        Fri, 24 Jul 2020 09:34:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so4744080pls.5;
        Fri, 24 Jul 2020 09:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tleO8aHfa26cflMwMSnhPp+xAxg7WwjI5PBYDPHCheU=;
        b=Qylaa520Hj/O37egAj+G+sflQYcdH7NLiPNI3wt4S2q/G4DmrIlCE+Xq/avII/pdHG
         H4t3ZhBnKc6OsGE8P8UIpqi9PG4sj0YAewaT7LJShrFb5xyMrcR3SKN1pe5wek5Nc75g
         CEi/iVj4m4IesZzmVHw/1DJRPnxq7e11IEMNmEMHtA3q6k1nWhcVEGAcsw3aqJCkENIl
         PKqeoTJ4R8jw2oCT+B8xn/8TMXAjISjYUwDbnOONzZHTGE3+5L0njzWgn3995Zbp9lPx
         oYt8ozGiPEsAq6apS+O+yCSQ8eBMiHsXLwzlAC/LUqum3cLbJ6/FaLeKgaIlUrWKNpTz
         JnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tleO8aHfa26cflMwMSnhPp+xAxg7WwjI5PBYDPHCheU=;
        b=q+CeK5xge3g3HdLFlQUzaKxRgXlmhYLiMRdjFsCtsf5lur2rlWlDBYL24Ok86BpUhF
         cy2IAAcDuedusuuZSqFrXzcuZGqhxT6VbkDeF2afqmOdy4Cv6xNFTk4DChyr3sZmrCc+
         v2J2JUdQQHPONlwxlMtvo5FIwGfIgdc/iDSd6ChRz+rmZKFbvVEazdHoCWYLfu6lobc+
         zacysMIV7olFrVcQf3ceWLNDxqfwJXLJwo6HlgpBXKMuR3Z2voKPreHRnDgsUhd0L3KE
         s/72PF61bsRHWZevwwKhVP2eDJ0lZJLl3iG1TkEmkvmiJRR4aJIiTqqyEL0PqpNvKdbJ
         NpUQ==
X-Gm-Message-State: AOAM533+sGxNYzpJINynoxaElXK5j3uISrmAfGj/zeuxJM0Y9UNcAA9i
        ZZTBnOtyqcx6XYQO4nIN4EI=
X-Google-Smtp-Source: ABdhPJytZCyVPJi5TSQoqP4Ledc7YVOgh+gWU6Myty60Q9uEG7msRL3dz0q+ZUi5xpptQ0RVX7uqxw==
X-Received: by 2002:a17:90b:2285:: with SMTP id kx5mr6572659pjb.83.1595608442414;
        Fri, 24 Jul 2020 09:34:02 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:bc56:3377:e9ed:63f0])
        by smtp.gmail.com with ESMTPSA id b8sm6138393pjd.5.2020.07.24.09.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 09:34:01 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin Schiller <ms@dev.tdt.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH] drivers/net/wan: lapb: Corrected the usage of skb_cow
Date:   Fri, 24 Jul 2020 09:33:47 -0700
Message-Id: <20200724163347.57213-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixed 2 issues with the usage of skb_cow in LAPB drivers
"lapbether" and "hdlc_x25":

1) After skb_cow fails, kfree_skb should be called to drop a reference
to the skb. But in both drivers, kfree_skb is not called.

2) skb_cow should be called before skb_push so that is can ensure the
safety of skb_push. But in "lapbether", it is incorrectly called after
skb_push.

More details about these 2 issues:

1) The behavior of calling kfree_skb on failure is also the behavior of
netif_rx, which is called by this function with "return netif_rx(skb);".
So this function should follow this behavior, too.

2) In "lapbether", skb_cow is called after skb_push. This results in 2
logical issues:
   a) skb_push is not protected by skb_cow;
   b) An extra headroom of 1 byte is ensured after skb_push. This extra
      headroom has no use in this function. It also has no use in the
      upper-layer function that this function passes the skb to
      (x25_lapb_receive_frame in net/x25/x25_dev.c).
So logically skb_cow should instead be called before skb_push.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_x25.c  | 4 +++-
 drivers/net/wan/lapbether.c | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index c84536b03aa8..f70336bb6f52 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -71,8 +71,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	if (skb_cow(skb, 1))
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 	skb_reset_network_header(skb);
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 284832314f31..b2868433718f 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -128,10 +128,12 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	skb_push(skb, 1);
-
-	if (skb_cow(skb, 1))
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
+
+	skb_push(skb, 1);
 
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
-- 
2.25.1

