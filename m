Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C0E476885
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 04:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhLPDMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 22:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbhLPDMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 22:12:45 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBD6C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 19:12:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v16so6041432pjn.1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 19:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dBM19LcQ01EOL1teiqLVNHuwJHdfmzghxMPx2TADl7I=;
        b=OP3oyNjPWr8trMDrWnkDU+KR7+tT1Od1ZsR8zIVi042GshUO1hw+MVnNpKz8oYDYYy
         j2rAXpYp3GBUagy+biiiXk88h7WmHleCqjBvGWddtOnPonCFYr0NUx09ew6Wk9D1AvkB
         gFnGZ28j+fqHEiV8wMeXrI/CkZaPoHJuZ0Jabuu4m1uisO3sYbevEoPjjv3zLWyS7hHY
         1YKyBI9vN6lhMgsBdrk9+RYvFXSjSY03X2nh5VP0QPycERWRiVJqSX6DVdpShpIy/+X9
         9A4zBm6I0O4qXXvmpgOzIVutPCO0SyLe5cjMuOeOtQJsHWI+gINn3N9foI5jgWP2jpaB
         zQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dBM19LcQ01EOL1teiqLVNHuwJHdfmzghxMPx2TADl7I=;
        b=rrqUKe92FZJeGN6icKfeSzs1yBonogwxRgPLG62FmNYsvmpAMfP3unDEDoR/NmJx0+
         dS0Ju15TFW2M2rL/PWXeKzzcxQptDXBCL4HSC8OFylJ/I9DN3mKbMM2tvXRXTYCFuOBr
         4lQM681Ki35oD+MAwc4ky60NiLdLSfXi3cRTF7FcOxnnmeQLJX3oQK6dv3OJ2NkmF1M4
         i9SLBwWIAyWrhzuBIxqFme2rhgPI92fYPI3hc3nj9gK/I4v4cdW6RIcBlA/WMO4vYcbk
         dl65sWdrb2JIZpk+LV9Ln0OL7rgW4COb9FlR2eOPLe9RrmtSa4MQz1dRseHCvCo0hj+u
         XBmg==
X-Gm-Message-State: AOAM533yMpxnPtRkDI/S3FgB9UrUi+yReCWSdJxoKtlhzsiQUwb24+XO
        PoOpYisgDyKYhe7Otfrjr2fwZ3gP/PMnjw==
X-Google-Smtp-Source: ABdhPJyLtXGTudGYZIMvvzM5tjz/tVxh+mNzS7Uy0YKouhZVbCQJ7m6zFXkRoCWaCABWI5CtPSVfmA==
X-Received: by 2002:a17:902:bb87:b0:148:a2e7:fb52 with SMTP id m7-20020a170902bb8700b00148a2e7fb52mr7613675pls.147.1639624364736;
        Wed, 15 Dec 2021 19:12:44 -0800 (PST)
Received: from debian.bytedance.net ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id p49sm3777823pfw.43.2021.12.15.19.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 19:12:44 -0800 (PST)
From:   Wenliang Wang <wangwenliang.1995@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wenliang Wang <wangwenliang.1995@bytedance.com>
Subject: [PATCH] virtio_net: fix rx_drops stat for small pkts
Date:   Thu, 16 Dec 2021 11:11:35 +0800
Message-Id: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found the stat of rx drops for small pkts does not increment when
build_skb fail, it's not coherent with other mode's rx drops stat.

Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
---
 drivers/net/virtio_net.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 55db6a336f7e..b107835242ad 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -733,7 +733,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		pr_debug("%s: rx error: len %u exceeds max size %d\n",
 			 dev->name, len, GOOD_PACKET_LEN);
 		dev->stats.rx_length_errors++;
-		goto err_len;
+		goto err;
 	}
 
 	if (likely(!vi->xdp_enabled)) {
@@ -825,10 +825,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 skip_xdp:
 	skb = build_skb(buf, buflen);
-	if (!skb) {
-		put_page(page);
+	if (!skb)
 		goto err;
-	}
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
 	if (!xdp_prog) {
@@ -839,13 +837,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-err:
 	return skb;
 
 err_xdp:
 	rcu_read_unlock();
 	stats->xdp_drops++;
-err_len:
+err:
 	stats->drops++;
 	put_page(page);
 xdp_xmit:
-- 
2.30.2

