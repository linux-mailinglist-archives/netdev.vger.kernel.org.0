Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3B26369BA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbiKWTQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbiKWTQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:16:42 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC852C5611
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:16:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h16-20020a255f50000000b006e880b47e6fso14010428ybm.6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXrL4mXjPPRNXGN8jBngxsBYSqmiNdb+yw7fcajaaOY=;
        b=IB+ar8WmQFgm8e6yBH0P9Orz+hB2yaIz/otrVtei4QWtyj59kJt1c7tiuX7/fBPoSL
         RdX4ca0AUITSv5FsjskmtSgYK/c7CwNua3yClFXeyWHsalnTdTuBgQk9dm52CNntiRmP
         cv/RPUbgGsbuNJFjjlCSXaE7Fs/k8DHDPB68UqRo/Mq59Vn2bLRPRrnvc9vFw15DkI95
         wpbaxjxkegzhABrjskD/Esv5IuLITp0Om7jyukeXKmUeMDELC8F4UGu2fj1Y2M390d9l
         IwxU520sbdiwpnZrKzvLOrta6O7+W6d0vXuGWC9fbjW9L6os3L8z2k85Za30Djjrtc3S
         jb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXrL4mXjPPRNXGN8jBngxsBYSqmiNdb+yw7fcajaaOY=;
        b=sk0H2xbRrYwCsDTADQYSYRD2GtYOQUskPPuC8m05AYa3/uezbJVAzd2T6xcKsQ4bmd
         Nuu+rq3q4SMw1RYI2GK3kOcbJ4LirZaDW7n5sCLuHfleX/rsIA+p9vqOvIZjKO0vaWd3
         U6JFUBiqnHoB7R5XpKQz/QYcEqLbG1eiF+M/8cEc/TKcwZjHf1Y86Azb9zqTISN8b7Jl
         lpoSNcT87YmSbm5Q0PH+eon8liwwUHmfEfocuBzzUh82kDGubyC6au3APfY9F5Xibso2
         0Bh3hKvPAOqJ14aHh1FLOYcQ+1rvqNMuVPTUunFMBFQXfRQIDXINun1PBa7Fhb6LJOoq
         uJHg==
X-Gm-Message-State: ANoB5pnHmjUdSjXcW2guyL5BWml+YEHY9xOGm9ktlIxtp893pt61dQ0u
        hBlYxQwOEfCKbjJYKZd3Vus7RSo6Y96dorI=
X-Google-Smtp-Source: AA0mqf5CBy/naBa071rb29doXzGpvLUmgLnuknLOM8LCpJQ+bITY+DJ5e195+ppfVdRuYe21OioolEzmR70hEgM=
X-Received: from lixiaoyan-desktop.svl.corp.google.com ([2620:15c:2c4:201:d403:2d3e:7222:9b9c])
 (user=lixiaoyan job=sendgmr) by 2002:a25:84cc:0:b0:6e6:b5f0:3ae0 with SMTP id
 x12-20020a2584cc000000b006e6b5f03ae0mr28492403ybm.439.1669231000212; Wed, 23
 Nov 2022 11:16:40 -0800 (PST)
Date:   Wed, 23 Nov 2022 11:16:27 -0800
In-Reply-To: <20221123191627.3442831-1-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20221123191627.3442831-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221123191627.3442831-2-lixiaoyan@google.com>
Subject: [RFC net-next v2 2/2] bnxt: Use generic HBH removal helper in tx path
From:   Coco Li <lixiaoyan@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
for IPv6 traffic. See patch series:
'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'

This reduces the number of packets traversing the networking stack and
should usually improves performance. However, it also inserts a
temporary Hop-by-hop IPv6 extension header.

Using the HBH header removal method in the previous path, the extra header
be removed in bnxt drivers to allow it to send big TCP packets (bigger
TSO packets) as well.

Tested:
Compiled locally

To further test functional correctness, update the GSO/GRO limit on the
physical NIC:

ip link set eth0 gso_max_size 181000
ip link set eth0 gro_max_size 181000

Note that if there are bonding or ipvan devices on top of the physical
NIC, their GSO sizes need to be updated as well.

Then, IPv6/TCP packets with sizes larger than 64k can be observed.

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0fe164b42c5d..2bfa5e9fb179 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_BUSY;
 	}
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto tx_free;
+
 	length = skb->len;
 	len = skb_headlen(skb);
 	last_frag = skb_shinfo(skb)->nr_frags;
@@ -13657,6 +13660,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->features &= ~NETIF_F_LRO;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
 #endif
-- 
2.38.1.584.g0f3c55d4c2-goog

