Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C99344CB3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhCVREb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:04:31 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:40704 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbhCVREN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:04:13 -0400
Received: by mail-ej1-f50.google.com with SMTP id u9so22493180ejj.7;
        Mon, 22 Mar 2021 10:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbX+25IhtGxUxG75ZUNY2+6T7jBsgS7En6v4O7pc9lg=;
        b=Kgc5EtGIsxAH9YA8qnZ7LZZ5q9gfka6DUdUgFtmsOWpBqRmnea0gUVMzzate2ospzb
         NBKG22jFqgJPl827C5ZSTQj+IOORoz35t/abVUx1bL0j6xk/4rSUv1XrKN1sgqdSCM0j
         I6ZQ07yDdIXowvIsVkzXQAVcUDMfajAl9jD3BoNAs/tkhnJrZRiaNQLt7y2OmDhjrGNa
         loPwOpcbV4XZPxiNTLSt0Z3PapocIPuJyAdnpTWp0qmmbXowW4HOEKFkHkKPlr6z5tvq
         HomNoXzGzzk0qFAehxJUM0qITU/d7ZAQLsGBUWHtM6uZjvv6wza7eNAwFwuklbuiToZ1
         y8Zg==
X-Gm-Message-State: AOAM531TMNJKpHe/gsc0/zRrLwkMb1ZJiBUyWHddmlis8/henXgFctAW
        i1rHYgsEZM4Wmqon7v2mGG36TvvEqZk=
X-Google-Smtp-Source: ABdhPJwMnCjHMCYCYTsTuTMec+ggbYvQT5m7rmd3ISvi2eHsMoBHe97QYnp1Zk6QZMplCB32R6St/Q==
X-Received: by 2002:a17:906:4a50:: with SMTP id a16mr821098ejv.256.1616432651829;
        Mon, 22 Mar 2021 10:04:11 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id h22sm9891589eji.80.2021.03.22.10.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:04:11 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/6] net: change users of __skb_frag_unref() and add an extra argument
Date:   Mon, 22 Mar 2021 18:02:59 +0100
Message-Id: <20210322170301.26017-5-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
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
index 2a752fb6b758..1cc646fb4fe4 100644
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
2.30.2

