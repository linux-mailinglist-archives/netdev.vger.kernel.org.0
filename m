Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF7B23D532
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 03:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgHFBvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 21:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgHFBvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 21:51:04 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C8C061574;
        Wed,  5 Aug 2020 18:51:04 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mw10so1957148pjb.2;
        Wed, 05 Aug 2020 18:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7qgvGoGJ/RGVSfdKbMsEFKwg8apV6p2sE/5Kdluv/M=;
        b=oxNnsnxt/6vP6yiDtEclyzwcrnpNndJDHOtveoyjVZGe/SccV1U5ZjFpVCsTGkG4aM
         Un8s5QqLNRmTsxhnqa5wp6s5y4Es6/0ByrIq9lsLmh1Ky6/23Crw3mBt8xU2XHRHhp2z
         guosVzJ6/F4imnpqLp09VfJfQsiMAUcIR33InKI7EP6PB3s4CrvqHCrgH5m1T60v/nFt
         0SrBhErh4PYM6l5bY0FTKyNzCrmO5KyOrTR7fpFF1zWclpMLFQUceQhmkmNHgqKAFAQ3
         ZGSqvk+YXINV+f+54DN6JwViAd2HAZKXZcKYFdSLghH+HSNgkhylPeKXOFpH1NfRRSHp
         N4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7qgvGoGJ/RGVSfdKbMsEFKwg8apV6p2sE/5Kdluv/M=;
        b=R7OE7eRCc1nOPBHcTIP86KuHbc8tSN63BCQ8Fd6aB/dPJ7t26zbSuhpCp41NGO6rgp
         GYQRx0SMU09oXEF6E62Uhjh3GwAiEhbY/PagoCzFjma7WYJjCo/h/O3SE3TIc+yhvPXz
         QM1Dkb/xV7xCPag59fUKz7xcAzEZjfcIOxs2ni39FMjyPqe/WoAV/IFaYwLihwUICKPm
         Ccn/TP2GkMWHDY4YwD+876mDC84hwZ381YfDf8F8hQ22g+i+7cpoJlxypgb9TTTyf/4q
         p/YsIQ5nXhhPHda57nVmtnBSFqZkeAZgWt5qHVFRSYj+X5is4h9ewaBWD9DLeiKT9qnQ
         +mag==
X-Gm-Message-State: AOAM530KoAU5WS7fIWsa24Yig1x5UH90VqXd5p0W8gX5BARJsYva+Ehp
        bEDU8rhQJw6ZxTvs/qp5bvE=
X-Google-Smtp-Source: ABdhPJzQFukfZk3y0bJJVnzC7wLxBmCVbKJapj/E8kdoYTrDWfwN/BTRIRgO6gPJOTUYcIjcP6mC5Q==
X-Received: by 2002:a17:902:ab96:: with SMTP id f22mr5714651plr.155.1596678663448;
        Wed, 05 Aug 2020 18:51:03 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:985d:3e31:b954:7ccf])
        by smtp.gmail.com with ESMTPSA id m26sm5375622pff.84.2020.08.05.18.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 18:51:03 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] drivers/net/wan/lapbether: Added needed_headroom and a skb->len check
Date:   Wed,  5 Aug 2020 18:50:40 -0700
Message-Id: <20200806015040.98379-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Added a skb->len check

This driver expects upper layers to include a pseudo header of 1 byte
when passing down a skb for transmission. This driver will read this
1-byte header. This patch added a skb->len check before reading the
header to make sure the header exists.

2. Changed to use needed_headroom instead of hard_header_len to request
necessary headroom to be allocated

In net/packet/af_packet.c, the function packet_snd first reserves a
headroom of length (dev->hard_header_len + dev->needed_headroom).
Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
which calls dev->header_ops->create, to create the link layer header.
If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
length (dev->hard_header_len), and assumes the user to provide the
appropriate link layer header.

So according to the logic of af_packet.c, dev->hard_header_len should
be the length of the header that would be created by
dev->header_ops->create.

However, this driver doesn't provide dev->header_ops, so logically
dev->hard_header_len should be 0.

So we should use dev->needed_headroom instead of dev->hard_header_len
to request necessary headroom to be allocated.

This change fixes kernel panic when this driver is used with AF_PACKET
SOCK_RAW sockets.

Call stack when panic:

[  168.399197] skbuff: skb_under_panic: text:ffffffff819d95fb len:20
put:14 head:ffff8882704c0a00 data:ffff8882704c09fd tail:0x11 end:0xc0
dev:veth0
...
[  168.399255] Call Trace:
[  168.399259]  skb_push.cold+0x14/0x24
[  168.399262]  eth_header+0x2b/0xc0
[  168.399267]  lapbeth_data_transmit+0x9a/0xb0 [lapbether]
[  168.399275]  lapb_data_transmit+0x22/0x2c [lapb]
[  168.399277]  lapb_transmit_buffer+0x71/0xb0 [lapb]
[  168.399279]  lapb_kick+0xe3/0x1c0 [lapb]
[  168.399281]  lapb_data_request+0x76/0xc0 [lapb]
[  168.399283]  lapbeth_xmit+0x56/0x90 [lapbether]
[  168.399286]  dev_hard_start_xmit+0x91/0x1f0
[  168.399289]  ? irq_init_percpu_irqstack+0xc0/0x100
[  168.399291]  __dev_queue_xmit+0x721/0x8e0
[  168.399295]  ? packet_parse_headers.isra.0+0xd2/0x110
[  168.399297]  dev_queue_xmit+0x10/0x20
[  168.399298]  packet_sendmsg+0xbf0/0x19b0
......

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index b2868433718f..1ea15f2123ed 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -157,6 +157,12 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 	if (!netif_running(dev))
 		goto drop;
 
+	/* There should be a pseudo header of 1 byte added by upper layers.
+	 * Check to make sure it is there before reading it.
+	 */
+	if (skb->len < 1)
+		goto drop;
+
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:
 		break;
@@ -305,6 +311,7 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->type            = ARPHRD_X25;
+	dev->hard_header_len = 0;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -331,7 +338,8 @@ static int lapbeth_new_device(struct net_device *dev)
 	 * then this driver prepends a length field of 2 bytes,
 	 * then the underlying Ethernet device prepends its own header.
 	 */
-	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+	ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
+					   + dev->needed_headroom;
 
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
-- 
2.25.1

