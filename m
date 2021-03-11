Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B87337E63
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCKTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:45:26 -0500
Received: from mail-ej1-f48.google.com ([209.85.218.48]:34560 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhCKTpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:45:04 -0500
Received: by mail-ej1-f48.google.com with SMTP id hs11so48729890ejc.1;
        Thu, 11 Mar 2021 11:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMFS85E++MtJu6DPvW2faFFNVv0MWXjZS7ayxkiJF4k=;
        b=TXg8gvWOTvr4xHzVUJey7ngFehYDdDZvCOCQasoyIsigVlRtTlAVoU2euoIZc0j7Vu
         4D/CPYIvJuw+MzjJ6AkESjGfZyMhH6gYi+AXyGMKsl0yZYQXQr0gO7NZkDM7EeAqFAJ+
         WGJ+6liCqKJjsPYLXTemFdPJF12BxOII3UOf0uIGyg+zVRmL/MdEUXR2j4kb1vQf01RO
         yPeNr8zUj7Wvxt7SRp0Mg6AQ5XjmKI6ZsNChzltXwfVF7UFE369vfbOfCV5TcZFyWK3D
         o6D3qgaDqIbGYszHxqXDGq4kFkUSjFYlbUUWbGIfxOVxzntrEg+YgPzqDeGiLidkt/pK
         kP3A==
X-Gm-Message-State: AOAM530q1LS93ypudaYSjdWegc3G0lbAQSU24/J84tNwLrmsHKUlVp7E
        sXDD6h7R4RfphpH9k7ORxf+IkxKDjxg=
X-Google-Smtp-Source: ABdhPJwJWOhcKK+WQS3p2XQBvog0we7o7D1g0OEz16whZIJHwOP9k7gV80MUljLtN4HG9553RMryTQ==
X-Received: by 2002:a17:906:d797:: with SMTP id pj23mr4725222ejb.367.1615491903026;
        Thu, 11 Mar 2021 11:45:03 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-188-216-41-250.cust.vodafonedsl.it. [188.216.41.250])
        by smtp.gmail.com with ESMTPSA id t16sm1875652edi.60.2021.03.11.11.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:45:02 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [RFC net-next 4/6] net: change users of __skb_frag_unref() and add an extra argument
Date:   Thu, 11 Mar 2021 20:42:54 +0100
Message-Id: <20210311194256.53706-5-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311194256.53706-1-mcroce@linux.microsoft.com>
References: <20210311194256.53706-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

On a previous patch we added an extra argument on __skb_frag_unref() to
handle recycling. Update the current users of the function with that.

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
 drivers/net/ethernet/marvell/sky2.c                            | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                     | 2 +-
 net/tls/tls_device.c                                           | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 169e10c91378..cbcff5518965 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -2125,7 +2125,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* clear the frag ref count which increased locally before */
 		for (i = 0; i < record->num_frags; i++) {
 			/* clear the frag ref count */
-			__skb_frag_unref(&record->frags[i]);
+			__skb_frag_unref(&record->frags[i], false);
 		}
 		/* if any failure, come out from the loop. */
 		if (ret) {
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index dbec8e187a68..5dc4aee56fa1 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2501,7 +2501,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__skb_frag_unref(frag);
+			__skb_frag_unref(frag, false);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index e35e4d7ef4d1..cea62b8f554c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -526,7 +526,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_priv *priv,
 fail:
 	while (nr > 0) {
 		nr--;
-		__skb_frag_unref(skb_shinfo(skb)->frags + nr);
+		__skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
 	}
 	return 0;
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index d9cd229aa111..2a32a547e51a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -127,7 +127,7 @@ static void destroy_record(struct tls_record_info *record)
 	int i;
 
 	for (i = 0; i < record->num_frags; i++)
-		__skb_frag_unref(&record->frags[i]);
+		__skb_frag_unref(&record->frags[i], false);
 	kfree(record);
 }
 
-- 
2.29.2

