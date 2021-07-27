Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8FA3D7FE8
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhG0U70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhG0U7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C229C061389
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so6604179pjb.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FMXWh89VZYemVKOC1nOMHXOf0EkNJ7d1gpgnv25tUVA=;
        b=VRjvQdRR4aWGRSvNdQEtPfrWzojFlNd/kN7JaBE0aAlIVG9EG9aSiA5zFyLXywoXt3
         +qqqc4cni+Gj9eLUu/BZwo+sCP7HeCZeq91ihwiuys76/CIV8Ybwd80dGbzhsPOcK3Na
         Vv6raW0jAps59OM68d7PMk4c9UpnIfccBTXeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FMXWh89VZYemVKOC1nOMHXOf0EkNJ7d1gpgnv25tUVA=;
        b=EYvJj527rj2VYNx5uGRcFpU4FjJYc3U9TfIoNt7K5doK1vhGKU4BJRPQiV8SZRi6yi
         vP73RK6d1W2/Ds1hqLBtwj/g9NO++rZ44Z8ckMNTvRXSAP5DUqtTTldSmIUUr7r/10yl
         AV1GVIKx9I2ULGrBfW6EgGtVVb7WSA3Kqadwy7jRVYOy5zqckzLUVyWvZgnatrxcgiei
         SaTZPX5BrP48rEA3zKEPWRcrk8r5KyrJPtlLWfQv0kF6miksg2CYneHClRhTDeA3bBYL
         dMw3miYXTedEykNtxrmiiRC7yBWBnnd2Fqz0Lxz06z94hsX0ogArWcFbbfemmd95nYKX
         WJxQ==
X-Gm-Message-State: AOAM5331UmHbgsbXPpJPTiKEnch4niAwr/wPdzIMw1k4nUXuaUebq5Xq
        PH/P1+OATbX7tlPqthSYSCpmOQ==
X-Google-Smtp-Source: ABdhPJzSeSwp5iNUhGXFiFamEkbeo056S644ilZ1zvFJzJMMaOdru3STU1CRfSSuOGy0ZoKVoFjAMw==
X-Received: by 2002:a17:902:ce86:b029:12b:b41b:2e68 with SMTP id f6-20020a170902ce86b029012bb41b2e68mr20161809plg.1.1627419550186;
        Tue, 27 Jul 2021 13:59:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f3sm4853027pfk.206.2021.07.27.13.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 13/64] libertas: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:04 -0700
Message-Id: <20210727205855.411487-14-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2740; h=from:subject; bh=aefCoJhV9lyPmgKpvdOWTp1eHgAAy3wtBLWPOfGvPCw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHODxcQA7hFiK/M9yqFXiZTlrkWV9wESsqNUkUC3 ENS25TmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgwAKCRCJcvTf3G3AJuWXD/ 9EEbIRmE0Sf3w/qtDGyQLeiBdvitwed0MqGCR54+cy4POmCGJEXkXMe+UsA2tUg7eala8PPngaqDKo 0ERL1ewBHx4UD7R+AEvkOFXcZagB1d42rFbOcpPOwrftFS6pqkon4FdosW0+MyMEf2BnIg95MZ48pZ 0dyeZPhVPj/CifetiJMIUTfVMkOMyMFLrj4I1QaTdWSnw1H4W62BrhGDAQc0wtIpxRE3GRSS+57J5X fda42m/AefAnCJ25BDnCSuL0nNlmXnB10fFKxeWoEU48gScMVd36kIeusvAI4E8KSAHUIX/SsSfg4B C6cdu9pXjtZk6na7YL3clAWf2vJ0C5dLpU7vyJPM1wtNB90psbKGHH8XsK/Wi5Hiz48C37rTTkjItG tWxOfN33ZRWxmjHBixtvVsX+hOU3m3jebrGd1IBvwiRCt1lQFTvO8wTdpkLEdT/hBZ37SfUrP7i2CN h/zVNAg6ocxkPF5UNjetoviDaRQ6L+oQKTilzpJlOBKdctAfQ7AqO0hQ5/FkXTjkMxSrVzFGsjpZaa uoeBKt0sZu+bCO/t4+qslxRaHXCvklEy7nB6J3q5w8GbuK2nmOkzeGHgppPq7LknjTN298gn73rfUn 3C7Wt5tq8d4a2uxndbXu1sQkSynV2tVH5+7XlKmxnZyCRO6ToCcX/c2fNkoQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct txpd around members tx_dest_addr_high
and tx_dest_addr_low so they can be referenced together. This will
allow memcpy() and sizeof() to more easily reason about sizes, improve
readability, and avoid future warnings about writing beyond the end
of queue_id.

"pahole" shows no size nor member offset changes to struct txpd.
"objdump -d" shows no object code changes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/libertas/host.h | 10 ++++++----
 drivers/net/wireless/marvell/libertas/tx.c   |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/host.h b/drivers/net/wireless/marvell/libertas/host.h
index dfa22468b14a..af96bdba3b2b 100644
--- a/drivers/net/wireless/marvell/libertas/host.h
+++ b/drivers/net/wireless/marvell/libertas/host.h
@@ -308,10 +308,12 @@ struct txpd {
 	__le32 tx_packet_location;
 	/* Tx packet length */
 	__le16 tx_packet_length;
-	/* First 2 byte of destination MAC address */
-	u8 tx_dest_addr_high[2];
-	/* Last 4 byte of destination MAC address */
-	u8 tx_dest_addr_low[4];
+	struct_group(tx_dest_addr,
+		/* First 2 byte of destination MAC address */
+		u8 tx_dest_addr_high[2];
+		/* Last 4 byte of destination MAC address */
+		u8 tx_dest_addr_low[4];
+	);
 	/* Pkt Priority */
 	u8 priority;
 	/* Pkt Trasnit Power control */
diff --git a/drivers/net/wireless/marvell/libertas/tx.c b/drivers/net/wireless/marvell/libertas/tx.c
index aeb481740df6..27304a98787d 100644
--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -113,6 +113,7 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	p802x_hdr = skb->data;
 	pkt_len = skb->len;
 
+	BUILD_BUG_ON(sizeof(txpd->tx_dest_addr) != ETH_ALEN);
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
@@ -124,10 +125,10 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		pkt_len -= sizeof(*rtap_hdr);
 
 		/* copy destination address from 802.11 header */
-		memcpy(txpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
+		memcpy(&txpd->tx_dest_addr, p802x_hdr + 4, ETH_ALEN);
 	} else {
 		/* copy destination address from 802.3 header */
-		memcpy(txpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
+		memcpy(&txpd->tx_dest_addr, p802x_hdr, ETH_ALEN);
 	}
 
 	txpd->tx_packet_length = cpu_to_le16(pkt_len);
-- 
2.30.2

