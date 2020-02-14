Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645F915D24A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 07:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgBNGiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 01:38:21 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:40703 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgBNGiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 01:38:21 -0500
Received: by mail-pf1-f201.google.com with SMTP id d127so5421602pfa.7
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 22:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=15Oh/b5UlnlqSbCYGajhNHvD7yZz1G+Vfp01MWjB8G0=;
        b=JQraWRX0aSTtIzEtUDRKFNY6JXU5rRcQC4nto+FbHPwl5b2yCz8hnuV5ew6trIs0R+
         KECa8RU1AAo8QUQOJaVHkgRvYzfaJmJVRUowDZP2XrRgNky9s2TuYHayVqmJ/SXvKtwe
         PzBBWTQYQmYhtsz2rRWwpMgsjQtlCJqwdX3uDkr/D1dvouuM5frNdjmYjt5PBEHmzvPc
         gqq0AC5R+I/eNSmVODe/QnMO9Aj/XZhBNlCMBghi1GzE+GSh/+G20D6utdqzQEmlIAJB
         ZprwE+sPzQk4QaKCk/21ve7xRRbu9cO6yf5r+exL0WUs3JrpH1n/ggjL7E/VnxA9/j+u
         QbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=15Oh/b5UlnlqSbCYGajhNHvD7yZz1G+Vfp01MWjB8G0=;
        b=C7bBvIb1GFY3/7Xdtvko6I6/+7JJHTZEdWQKEJIpiS057eEk4dVGvVLKLv0ceITcJu
         Qmj1f4woFil1X/Bmq/h4ztCPVsRQgiL7j1rLOvg+XxiqV14XS0t7Jt0mMAR3BV6lpFko
         2Bod7qkqfcpct4BHtxbMK8gyi7HUCrLtiPPtCJoYy+oPjboKNd8lmJdsLN3A5q5C6jon
         uIABbigfF7amZ1Vm2UaHK2/KJzcUK5i095YPf8YADxiBG4imS59BBYPpN/6PcaixAshG
         vm1gXsWbEEPzDTdvJ0ewE8dTkQYw6XHPwKSD5myXYH+UFUCIqHdWwaE8zfQshi+X1wEl
         S/DA==
X-Gm-Message-State: APjAAAV80pXqhY802nEk0i+6mKeL6rlh9lmvK1JCTiGPBfil4srlA31y
        f5V4SdTwWZSqo9k0C2IY1vX9uH+7tINIiA==
X-Google-Smtp-Source: APXvYqwWOIGizTHAG6Q+UXlQhrV3mXYkpyApBDFUdM9Mf7R9aHmvn5JUSZHrLul92CsstYdbml93qzMGwgoPMQ==
X-Received: by 2002:a63:3349:: with SMTP id z70mr1837863pgz.408.1581662299323;
 Thu, 13 Feb 2020 22:38:19 -0800 (PST)
Date:   Thu, 13 Feb 2020 22:38:14 -0800
Message-Id: <20200214063814.229451-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH net] wireguard: device: provide sane limits for mtu setting
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If wireguard device mtu is set to zero, a divide by zero
crash happens in calculate_skb_padding().

This patch provides dev->min_mtu and dev->max_mtu bounds.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: wireguard@lists.zx2c4.com
---
 drivers/net/wireguard/device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 43db442b1373073eaf5e805cfe6cfee15875437a..c02b84cca122d92ee8a81c5efdcf67aada2554d6 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -271,9 +271,14 @@ static void wg_setup(struct net_device *dev)
 	dev->features |= WG_NETDEV_FEATURES;
 	dev->hw_features |= WG_NETDEV_FEATURES;
 	dev->hw_enc_features |= WG_NETDEV_FEATURES;
+
 	dev->mtu = ETH_DATA_LEN - MESSAGE_MINIMUM_LENGTH -
 		   sizeof(struct udphdr) -
 		   max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
+	dev->min_mtu = MESSAGE_PADDING_MULTIPLE;
+	dev->max_mtu = ETH_MAX_MTU - MESSAGE_MINIMUM_LENGTH -
+		       sizeof(struct udphdr) -
+		       max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
 
 	SET_NETDEV_DEVTYPE(dev, &device_type);
 
-- 
2.25.0.265.gbab2e86ba0-goog

