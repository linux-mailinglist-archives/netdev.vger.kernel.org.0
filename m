Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889FA25BD6
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 04:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfEVCCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 22:02:15 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44492 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVCCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 22:02:15 -0400
Received: by mail-qk1-f193.google.com with SMTP id w25so492713qkj.11
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 19:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PYb1Qt4mHPM6qViQCzTU+WXXiTO1LdEJqqI2GVJiDqQ=;
        b=aAs2ITJNM8uavOYS/RRgYc2SiKG7UQSw51EYO/E+ifEtB30zlku8nSNGXrmElRCOfG
         MhV38M9Bd/8PUI//9SrZFosALiJ4xqjQu7/guDEUDwioISbGzbXKyRE/7t7l+qnKTIUN
         rXiuyS0ba6GhvVjmXYgSASV8GiyESu9m4Qd+2t+exRWyaaLgBzXT8dqUX0sAmBsFzd7y
         uktrR5cSEFJx/QR/2wb4slfW+kWz/qQLOTiEn2a6+b+wMrF9Cy/+A2/qGtpX+IGqEl1i
         JnQJy04R4rUcXEJR8ghkffoYB434LwfUxPI98Qkc0/yqnSjRLQlbgrCpr45Bf+h6gqH/
         z4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PYb1Qt4mHPM6qViQCzTU+WXXiTO1LdEJqqI2GVJiDqQ=;
        b=L4P3g3lVwQBpH7LSssskevHX76hZCnUZFcVmKcPuAjyJsVKEJD6L3TCcomgVV9JXMb
         dg9Oy1+55UA4OHiRvhExDrzuLIKQ35Kbf1TQxyYZTzOweU1fbd03xIOEZKedSG8yb4qT
         2H7AE5630u4jEKENgvS8nPfNnw+y/7HMNPGvNx78jHZOVDy+wjfkPNhkiQh6xNhlsn6B
         bDvgt0CbocAl8OttOARCkjBXbLxkLDpiPuvwo6guKDOVWdH4FmVQ+MXlE3LSIiP9dMzU
         81AKe1UC0lsG/KdUs79kco9mplgOATzY8bIhANN2Lxu6DupWqwt4PyC6zngXfgg5x4Wv
         3R5g==
X-Gm-Message-State: APjAAAUpiUVvyW4AxWmY08keLeyh8t7LN3qWHDVsONYtNl6FEmWVfrcK
        GTryD8FQTmwweSXcwUmtIAzsDg==
X-Google-Smtp-Source: APXvYqzjEoLqVW0iley2vo2Pm81haNDMgY4jpFoFvj0uEGK4lq7a+vcCfDEYaEjU15SDiDlKyPUwFQ==
X-Received: by 2002:a37:a44f:: with SMTP id n76mr35651116qke.148.1558490534292;
        Tue, 21 May 2019 19:02:14 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w195sm11440663qkb.54.2019.05.21.19.02.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 19:02:13 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 1/3] net/tls: avoid NULL-deref on resync during device removal
Date:   Tue, 21 May 2019 19:02:00 -0700
Message-Id: <20190522020202.4792-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522020202.4792-1-jakub.kicinski@netronome.com>
References: <20190522020202.4792-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netdev with active kTLS sockets in unregistered
notifier callback walks the offloaded sockets and
cleans up offload state.  RX data may still be processed,
however, and if resync was requested prior to device
removal we would hit a NULL pointer dereference on
ctx->netdev use.

Make sure resync is under the device offload lock
and NULL-check the netdev pointer.

This should be safe, because the pointer is set to
NULL either in the netdev notifier (under said lock)
or when socket is completely dead and no resync can
happen.

The other access to ctx->netdev in tls_validate_xmit_skb()
does not dereference the pointer, it just checks it against
other device pointer, so it should be pretty safe (perhaps
we can add a READ_ONCE/WRITE_ONCE there, if paranoid).

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index ca54a7c7ec81..aa33e4accc32 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -553,8 +553,8 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct net_device *netdev = tls_ctx->netdev;
 	struct tls_offload_context_rx *rx_ctx;
+	struct net_device *netdev;
 	u32 is_req_pending;
 	s64 resync_req;
 	u32 req_seq;
@@ -568,10 +568,15 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 	is_req_pending = resync_req;
 
 	if (unlikely(is_req_pending) && req_seq == seq &&
-	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
-		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk,
-						      seq + TLS_HEADER_SIZE - 1,
-						      rcd_sn);
+	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0)) {
+		seq += TLS_HEADER_SIZE - 1;
+		down_read(&device_offload_lock);
+		netdev = tls_ctx->netdev;
+		if (netdev)
+			netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk, seq,
+							      rcd_sn);
+		up_read(&device_offload_lock);
+	}
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
-- 
2.21.0

