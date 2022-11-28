Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF8963A649
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiK1KnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiK1KnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:43:15 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 02:43:13 PST
Received: from mail.rosalinux.ru (mail.rosalinux.ru [195.19.76.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7890DF1D;
        Mon, 28 Nov 2022 02:43:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rosalinux.ru (Postfix) with ESMTP id 5BDD218FF2A5;
        Mon, 28 Nov 2022 13:26:51 +0300 (MSK)
Received: from mail.rosalinux.ru ([127.0.0.1])
        by localhost (mail.rosalinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RD-LcpDkVy8X; Mon, 28 Nov 2022 13:26:51 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.rosalinux.ru (Postfix) with ESMTP id 251BC1C969EF;
        Mon, 28 Nov 2022 13:26:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rosalinux.ru 251BC1C969EF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosalinux.ru;
        s=1D4BB666-A0F1-11EB-A1A2-F53579C7F503; t=1669631211;
        bh=DarpytoYn3kYclkB5n7ZONEDXs6eBEyuuiBCU4Eg+Lc=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=k1BeX7vo4cVZMlrEiZ+3/Qvnlx2qHOxG0cAqETkanCDABZe49Qr77n8At8Fs6w70x
         AJ4hhllONcOOrcdJR9V5F7s7va8jQhzyc4szZBAMGxakeEgwS6usg9Z+ClMG4m8l2T
         W9cGblJHvO809Rcg2r3VuO8V4v7D3vLpcpGuxHY3upL2l8TwdcD+yRjQ6EQV5+J0Rb
         o3EeXGsxiEB60q6xO59MRNXugFuX6VeQdcibXmA/HTzBLy77Ftxy5b48F2cPF4nV/7
         PgqxQPfTlCipeYTnQrQmRaT1CML60b8uIyGVir6czYlo9Q6Ir1LpmgfBCK8b8KxjDm
         beUkodERTZczg==
X-Virus-Scanned: amavisd-new at rosalinux.ru
Received: from mail.rosalinux.ru ([127.0.0.1])
        by localhost (mail.rosalinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5O0AoDT4in66; Mon, 28 Nov 2022 13:26:50 +0300 (MSK)
Received: from ubuntu.localdomain (unknown [144.206.93.23])
        by mail.rosalinux.ru (Postfix) with ESMTPSA id 91C1618FF2A5;
        Mon, 28 Nov 2022 13:26:50 +0300 (MSK)
From:   Aleksandr Burakov <a.burakov@rosalinux.ru>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>
Cc:     Aleksandr Burakov <a.burakov@rosalinux.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] liquidio: avoid NULL pointer dereference in lio_vf_rep_copy_packet()
Date:   Mon, 28 Nov 2022 13:26:59 +0300
Message-Id: <20221128102659.4946-1-a.burakov@rosalinux.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lio_vf_rep_copy_packet() passes pg_info->page to skb_add_rx_frag()
that dereferences it without any check. So, it does not make sense
to call skb_add_rx_frag() when pg_info->page is NULL to avoid an segfault=
.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Fixes: 1f233f327913 ("liquidio: switchdev support for LiquidIO NIC")
---
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/=
net/ethernet/cavium/liquidio/lio_vf_rep.c
index 600de587d7a9..e70b9ccca380 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -272,13 +272,12 @@ lio_vf_rep_copy_packet(struct octeon_device *oct,
 				pg_info->page_offset;
 			memcpy(skb->data, va, MIN_SKB_SIZE);
 			skb_put(skb, MIN_SKB_SIZE);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					pg_info->page,
+					pg_info->page_offset + MIN_SKB_SIZE,
+					len - MIN_SKB_SIZE,
+					LIO_RXBUFFER_SZ);
 		}
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				pg_info->page,
-				pg_info->page_offset + MIN_SKB_SIZE,
-				len - MIN_SKB_SIZE,
-				LIO_RXBUFFER_SZ);
 	} else {
 		struct octeon_skb_page_info *pg_info =3D
 			((struct octeon_skb_page_info *)(skb->cb));
--=20
2.25.1
