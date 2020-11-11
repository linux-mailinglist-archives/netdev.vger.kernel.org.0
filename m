Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDBE2AF9F0
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgKKUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:45:33 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:56125 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKUpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:45:33 -0500
X-Greylist: delayed 161883 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2020 15:45:31 EST
Date:   Wed, 11 Nov 2020 20:45:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605127530; bh=bsLJnkXi8MeTMrm7MqVIftcvsnbFJMQr1qH+ckDYG2k=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=LaabHsZW/4JyVGzDppF9Qsi1NifWmzt017nLH0mUXhbmTxR6qnRwAOmnupAFgxX05
         bbE4t4Yt+Wivm9xgyLaYTnRZoKb7FPOBn+LoAMVV07vZlWgc6qwXD/TOn6uCjup+Xk
         xvGkzzSiKeCgJLCSRujLkdEnJoHCQYo4GKeaEcLS7YwsjM9uMo0W+XnuHaBk4HRUsh
         x9iMux9RfALDHdCeFL+9kR1+jTUPZnwEDTrNYCzp8WJbtE9DO/sGsAI1MOA6mcv7y0
         EZnQfr0XRk/SAPfj1b6ihVHPtw5o1UjxX7cZUGxfofms5gSX96GOjn0Gy8V/G/CWrk
         0/aIc/IkQmrIg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v5 net 1/2] net: udp: fix UDP header access on Fast/frag0 UDP GRO
Message-ID: <BWGqSgvElVUWVBHlyAGeResnioScs0ES23kwzp1JHo@cp4-web-028.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UDP GRO uses udp_hdr(skb) in its .gro_receive() callback. While it's
probably OK for non-frag0 paths (when all headers or even the entire
frame are already in skb head), this inline points to junk when
using Fast GRO (napi_gro_frags() or napi_gro_receive() with only
Ethernet header in skb head and all the rest in the frags) and breaks
GRO packet compilation and the packet flow itself.
To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
are typically used. UDP even has an inline helper that makes use of
them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
to get rid of the out-of-order delivers.

Present since the introduction of plain UDP GRO in 5.0-rc1.

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66fbf27b..13740e9fe6ec 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -366,7 +366,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff=
 *skb,
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 =09=09=09=09=09       struct sk_buff *skb)
 {
-=09struct udphdr *uh =3D udp_hdr(skb);
+=09struct udphdr *uh =3D udp_gro_udphdr(skb);
 =09struct sk_buff *pp =3D NULL;
 =09struct udphdr *uh2;
 =09struct sk_buff *p;
--=20
2.29.2


