Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9D925D032
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 06:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgIDEFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 00:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgIDEFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 00:05:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE30BC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 21:05:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id y7so2719777pjt.1
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 21:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=MXO78SgvM84Gs6K+9ENMwYPEaoByjHp37K3hV3V71RA=;
        b=vHCV0yRSCuX+IQBLhgPqB/bChBLQ9BVdbpS5na7gF+WPtRgf1fB2NIqd2zbJ5hPC/w
         NnLFAh7yQDsBUfq9rrzyysvy42fKbuV8AgnYBkGZsrMCZsmQzqtKc2vDvcHv9t0DogAr
         GXdlgtQCHCqrLz5U9/7mBJBqwHtJd/Nj01kwQCDZo3UKkU1pJ3mvYbfxcp4Lxcc+OiLS
         sEYhjvNIYfA63tVl70rCc+7nSvHAXYXaNCUSQWqYS3zzVf4cm6njGc5cM6w3I7zW++df
         WriCppYPLMnOZ9eVju4tqPBOlkcK1MHs807xuBN7/WHoZ/ISmMR+n5sDFllqVARNTK/H
         8V3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=MXO78SgvM84Gs6K+9ENMwYPEaoByjHp37K3hV3V71RA=;
        b=Lm2neiMZRssHn6rPJQXmWyij0miDqy4ncbFWvHgVp2ptLUY/7QbTj97XD5faiqv/F4
         p4EL8UIbgT860jkZrwcwtdJv8+TlgaDVYNzGqqcTV4e6vNYAT4pwOiGX6YYTR28vcI+W
         u26BR/4tEmzMkwQXY7kE7qHB325bHvHqX0lT5/VH0wEzFbiCsbZ+tnYUKzm+UC9qCpre
         46Q0Javg+JxwcG2J8aPcR9pnTbf82pCyEL5227xRAsvRzVumyUNu+8WwE9caIQIKsaZZ
         24TH8iUVg20fN+ejmdNsgeeaWVasYCAsuPVpCDRs5jqoeb+C7IqWS0NBUYphtU9FTyUy
         tthg==
X-Gm-Message-State: AOAM531x1M7MmvwUBhd2POGS3IWh039rj5Pyk+4hnWv4NHbGczSlcghm
        QJDZ8WLq5ORbtOwOpcUOKPosCrRTAJttJA==
X-Google-Smtp-Source: ABdhPJyaJilo19xbefiHSk4xNbva3Cgs+S1CY0Chq8OUREAiTng1AYIpxqrxXDrHJElW5kENURch+C39tT/M+w==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a65:4389:: with SMTP id
 m9mr5490329pgp.127.1599192337138; Thu, 03 Sep 2020 21:05:37 -0700 (PDT)
Date:   Thu,  3 Sep 2020 21:05:28 -0700
Message-Id: <20200904040528.3635711-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net] net/packet: fix overflow in tpacket_rcv
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Or Cohen <orcohen@paloaltonetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Cohen <orcohen@paloaltonetworks.com>

Using tp_reserve to calculate netoff can overflow as
tp_reserve is unsigned int and netoff is unsigned short.

This may lead to macoff receving a smaller value then
sizeof(struct virtio_net_hdr), and if po->has_vnet_hdr
is set, an out-of-bounds write will occur when
calling virtio_net_hdr_from_skb.

The bug is fixed by converting netoff to unsigned int
and checking if it exceeds USHRT_MAX.

This addresses CVE-2020-14386

Fixes: 8913336a7e8d ("packet: add PACKET_RESERVE sockopt")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 479c257ded7335616da35aa5f7880b54aa2f9fe0..1377a485d45109da8e5f241ff8f64d4f37180592 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2170,7 +2170,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	int skb_len = skb->len;
 	unsigned int snaplen, res;
 	unsigned long status = TP_STATUS_USER;
-	unsigned short macoff, netoff, hdrlen;
+	unsigned short macoff, hdrlen;
+	unsigned int netoff;
 	struct sk_buff *copy_skb = NULL;
 	struct timespec64 ts;
 	__u32 ts_status;
@@ -2239,6 +2240,10 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		}
 		macoff = netoff - maclen;
 	}
+	if (netoff > USHRT_MAX) {
+		atomic_inc(&po->tp_drops);
+		goto drop_n_restore;
+	}
 	if (po->tp_version <= TPACKET_V2) {
 		if (macoff + snaplen > po->rx_ring.frame_size) {
 			if (po->copy_thresh &&
-- 
2.28.0.526.ge36021eeef-goog

