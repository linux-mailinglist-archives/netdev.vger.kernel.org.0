Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909886CC17
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 11:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389549AbfGRJmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 05:42:49 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45997 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfGRJmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 05:42:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id u10so18688970lfm.12;
        Thu, 18 Jul 2019 02:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5gpt/zcvafN1FXFMWf3dMVSAEfdVCbW03VkO8WwV5vo=;
        b=S2WE0InyJmLKEBoGNgjlrk3QaZPdurWS35GRbBRPUi7+l+dLipZr1X4zFxoapUPCsg
         /DNCxvrXLyHASE0MKWonphIUU1E/bo2xtV71nXxuQDn37bXqljdBcirjwttzgbme3F7a
         D8+an2rOKh+uqE5pUdnEoZqNIZozFqnx3cDL/mYNzqDpcEb5NSzWdCniulaXhA6BhBn5
         +NzL1B/1JUMZiBlEF9eU6hA0tudvfnLN2CEaPiqvs2TegupPANrdWagcSuWTZYFWw4ut
         hFzVdExQEbska1S12lXRqUL2xPyDDQXmKk73l0IDjUAtLUyIrkF/72pJcQS0gbOxGg97
         VliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5gpt/zcvafN1FXFMWf3dMVSAEfdVCbW03VkO8WwV5vo=;
        b=MbmbOd+QjMXh5rVfbXk9FGHlrUzZrXpFNO396LCNMv4VxM3sPeucqu1F6XnF7Vom0m
         rcIhB/Th5uYhTgqWeyTQ0ExZSBMrsH4aNYDwzs3UgNP+7VjkEWJSfIyX/jL1Fm+UwIzX
         0s6sNV22LDgOrTO3/tL8osQWXP9ONR8PrgMtvXPsd9knfQ/TcjS6NaW6mrxIahdpy0KL
         wUpR8mKbbMeBoHBbQK3TJUETsxCcFWHcDoBLJ0hGe64hiJg7Wjlh6i4uGgXLZWhXo7PD
         shBQgiOsLkDYFeE728SsekgvmS0jQ8OIjmfvSjYWGv1DAMozU7lh6oOh0Zn7W/sQr9LZ
         pOsg==
X-Gm-Message-State: APjAAAWwGgRYQa7wExPsMyXj5ufYBwJeUr+crZSVcQNn+OAhQUlFqior
        l7r7O+x1PA26aBUAWE/DusI=
X-Google-Smtp-Source: APXvYqyA1yFFPTV8h5ZXJHEmv9lw2X1Fq4eve3kn8IkgNRYpOvoZ41FJTupm0GNqOSNec1JehdsM3w==
X-Received: by 2002:ac2:414d:: with SMTP id c13mr2767424lfi.47.1563442966991;
        Thu, 18 Jul 2019 02:42:46 -0700 (PDT)
Received: from peter.cuba.int. ([83.220.32.68])
        by smtp.googlemail.com with ESMTPSA id e87sm5675260ljf.54.2019.07.18.02.42.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 02:42:46 -0700 (PDT)
From:   Peter Kosyh <p.kosyh@gmail.com>
To:     p.kosyh@gmail.com
Cc:     davem@davemloft.net, David Ahern <dsa@cumulusnetworks.com>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
Date:   Thu, 18 Jul 2019 12:41:14 +0300
Message-Id: <20190718094114.13718-1-p.kosyh@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vrf_process_v4_outbound() and vrf_process_v6_outbound() do routing
using ip/ipv6 addresses, but don't make sure the header is available in
skb->data[] (skb_headlen() is less then header size).

The situation may occures while forwarding from MPLS layer to vrf, for
example.

So, this patch adds pskb_may_pull() calls in is_ip_tx_frame(), just before
call to vrf_process_... functions.

Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
---
 drivers/net/vrf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 54edf8956a25..d552f29a58d1 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -292,13 +292,16 @@ static netdev_tx_t is_ip_tx_frame(struct sk_buff *skb, struct net_device *dev)
 {
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr))
+			break;
 		return vrf_process_v4_outbound(skb, dev);
 	case htons(ETH_P_IPV6):
+		if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr))
+			break;
 		return vrf_process_v6_outbound(skb, dev);
-	default:
-		vrf_tx_error(dev, skb);
-		return NET_XMIT_DROP;
 	}
+	vrf_tx_error(dev, skb);
+	return NET_XMIT_DROP;
 }
 
 static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
2.11.0

