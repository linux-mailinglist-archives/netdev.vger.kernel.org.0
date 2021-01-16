Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD82F8BC6
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAPGAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbhAPGAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:00:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C3DC061757;
        Fri, 15 Jan 2021 21:59:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x20so1072625pjh.3;
        Fri, 15 Jan 2021 21:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1VdsmithXQSYVVgov2ysn73EQq0eJMwp9npyuaEfZvU=;
        b=LE2kg/3OYtWCgKN+i4fwOm7reksQzRXd48C1fGNrM2n+LvfhHTfcmANFb7+DgXTAd1
         rDdwYke6HBakJS6nqat2NVFsICoydctsp5FXoL6Q6SvHG1X+zYHZDi1I4rNho7toM9qx
         pk4ajIkb42u3hZ0CoHeD434tqH7Y4mfsRWsoIADBTfqZx5NmefTeQJGODB1JpVzba0F6
         UMQClFNj79/IeNq77iEDHcY4kEK0XlyQpoKdWRtZzE+Iw+D0qv1T7bvYE5ZSzoOgsutg
         XnFtLskbKo48mX7a+5CtwLh3mKm0miTqMZfogMudiAWb2GzPOvMwd8b7SejjZc1aRyXL
         86/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1VdsmithXQSYVVgov2ysn73EQq0eJMwp9npyuaEfZvU=;
        b=f/eqyaBV3saTCFoEVDGgut/4krNMQ0OGLkUxKKEKFu/R6b56sG50ioZ8Cg/XeNmv57
         6yOd46xaHegF/RCbkPRSi+S/XjgmrmqPKJdkPwjt3COg/+eirtwKnVR5LdaujZJbXno6
         O/doirOzhKT3Z9xegNL9BLaqgSWlgqiZXucoQhfDq34bPbtWmbm28v6v8ysZ0tQhhjEw
         Rk/TGHunA+qAV9Akfp6ZAe7PQMhQfheAtejZfZUXssT8TLyLLOBlZrB4YdSFWFvPwuh0
         ao/hj/Aqe6yWgSDecmnfgNfHoEzxRPnZIlvCcDf9oFVtTmKiqV3McL+9cwXEPbX0jkcQ
         +rXg==
X-Gm-Message-State: AOAM532rxPiFx7KW+7gX0fIm5XHcdBXQDRmaNTbDzqlnIZDcIZpkhpRc
        i3p/u666VV28SpkxOVd7G+2EMEEBil7I0Q==
X-Google-Smtp-Source: ABdhPJzju3eEm6MvLo7UNONF5YYLLboTZ2TKvDhyaG6VbkvZr26+YKZZG+MxodUn52pX4w/EwOCaxA==
X-Received: by 2002:a17:902:7b98:b029:db:fab3:e74b with SMTP id w24-20020a1709027b98b02900dbfab3e74bmr16027065pll.27.1610776765566;
        Fri, 15 Jan 2021 21:59:25 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 68sm9582889pfe.33.2021.01.15.21.59.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 21:59:24 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next] udp: not remove the CRC flag from dev features when need_csum is false
Date:   Sat, 16 Jan 2021 13:59:17 +0800
Message-Id: <1e81b700642498546eaa3f298e023fd7ad394f85.1610776757.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __skb_udp_tunnel_segment(), when it's a SCTP over VxLAN/GENEVE
packet and need_csum is false, which means the outer udp checksum
doesn't need to be computed, csum_start and csum_offset could be
used by the inner SCTP CRC CSUM for SCTP HW CRC offload.

So this patch is to not remove the CRC flag from dev features when
need_csum is false.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94..1168d18 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -68,8 +68,8 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 				      (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM))));
 
 	features &= skb->dev->hw_enc_features;
-	/* CRC checksum can't be handled by HW when it's a UDP tunneling packet. */
-	features &= ~NETIF_F_SCTP_CRC;
+	if (need_csum)
+		features &= ~NETIF_F_SCTP_CRC;
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
-- 
2.1.0

