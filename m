Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE79237F8
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfETNYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:24:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38887 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731636AbfETNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:24:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so7237410pfb.5
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XKZ6vquG56+dlmQjhRNeYETQVFMKBVL6hYFPUpnu77I=;
        b=RGgIvm9H2K2nJDyEqPp1SzCObbs6YE4RsG2Pys+nd9gtiNyV/MY5v0K73i2EPQQ2kO
         MThUXZ7/q8XBKsfMmepF/5zjLHvX+f2q8gNbslO4OUl/exSebm9CzSNX/ydSL9DbSgkF
         bYrvJLXopCbZDnpqys4IxQXP0kwqzqXeDmncvbeGA/z2UxEo234/IZwuLbeJ0SKQM/dm
         XUp83A2zJiUHZUiN+ThBuVnOxFnnO7y4lRLktg7I1dsVGSyVhIfMf81mUseyQuTREu4p
         En3bn1pRiXhuwgSQ6FVaUj/7j4nN+XzbuiQ01oBJL/hexLG6T+MqVuyc+OUmnRDfrP0Y
         BQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XKZ6vquG56+dlmQjhRNeYETQVFMKBVL6hYFPUpnu77I=;
        b=sWOTHKypzmE+1qy1XX+gDoc5xXHHhu7nw/vosTnbofz/fe6Ap3n/CdJFggm8U69t+e
         EhVu64tXKVexaQgDM8yT6U6hnHcnPQ7SYynjIB1NTcSx3r+4Q99BF8U/RrBWvCeqsnrQ
         8L9+RWiBZQlkxdbqE2jPK7rFDw6TzGUJJsFGoMPiB1CHkrhSx+wTNSBBcJZrCGjtbTOb
         olu0eQ3iN4KxyzDsHk5JyJHg1PL0TgKfA9lSZqu8stxewsnxUVETSBw+fADlwFAf8wM2
         aMeAizqP0uoBPt5TkUpmadeUW4Y2sDoFDbLckZivawmnvo85Ygj2YIWnOc3ClP7fnRh8
         x1Wg==
X-Gm-Message-State: APjAAAU0CEAb293g3J44TN+GHE267K+C92lT7IcmCboN4sbeg9MDDiJw
        yakNXkI1Hs3xtFToY7jM9X50w5zX
X-Google-Smtp-Source: APXvYqynIZ07Kw+3R1EEBMrLZIlpZ/6hpnnNTjdYsmR8tZgR8Wl9IfUTjLBedGLKW1mbBfLDOffKDQ==
X-Received: by 2002:aa7:8289:: with SMTP id s9mr79625122pfm.208.1558358672763;
        Mon, 20 May 2019 06:24:32 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id f5sm11235325pgc.7.2019.05.20.06.24.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:24:32 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net: vxlan: disallow removing to other namespace
Date:   Fri, 17 May 2019 19:42:23 -0700
Message-Id: <1558147343-93724-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Don't allow to remove the vxlan device to other namesapce,
because we maintain the data of vxlan net device on original
net-namespace.

    $ ip netns add ns100
    $ ip link add vxlan100 type vxlan dstport 4789 external
    $ ip link set dev vxlan100 netns ns100
    $ ip netns exec ns100 ip link add vxlan200 type vxlan dstport 4789 external
    $ ip netns exec ns100 ip link
    ...
    vxlan200: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    vxlan100: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000

And we should create it on new net-namespace, so disallow removing it.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/vxlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5994d54..63add28 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2998,6 +2998,7 @@ static void vxlan_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
+	dev->features	|= NETIF_F_NETNS_LOCAL;
 	dev->features	|= NETIF_F_LLTX;
 	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
 	dev->features   |= NETIF_F_RXCSUM;
-- 
1.8.3.1

