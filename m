Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DCC304D9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfE3Wih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:38:37 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:57195 "EHLO
        cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3Wih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:38:37 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50])
        by cassarossa.samfundet.no with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sesse@samfundet.no>)
        id 1hWTgv-0003q9-9T; Fri, 31 May 2019 00:38:34 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1hWTgu-0003Xb-W4; Fri, 31 May 2019 00:38:33 +0200
Date:   Fri, 31 May 2019 00:38:32 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc:     netdev@vger.kernel.org
Subject: Re: EoGRE sends undersized frames without padding
Message-ID: <20190530223832.kwoh4yvbbftl4vwc@sesse.net>
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190530083508.i52z5u25f2o7yigu@sesse.net>
X-Operating-System: Linux 5.1.2 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:35:08AM +0200, Steinar H. Gunderson wrote:
> After looking at the GRE packets in Wireshark, it turns out the Ethernet
> packets within the EoGRE packet is undersized (under 60 bytes), and Linux
> doesn't pad them. I haven't found anything in RFC 7637 that says anything
> about padding, so I would assume it should conform to the usual Ethernet
> padding rules, ie., pad to at least ETH_ZLEN. However, nothing in Linux' IP
> stack seems to actually do this, which means that when the packet is
> decapsulated in the other end and put on the (potentially virtual) wire,
> it gets dropped. The other system properly pads its small frames when sending
> them.

As a proof of concept (no error handling, probably poor performance, not
implemented for IPv6, other issues?), this patch works and fixes my problem:

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 4b0526441476..00be99d23e5c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -441,6 +441,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (tunnel->parms.o_flags & TUNNEL_SEQ)
 		tunnel->o_seqno++;
 
+	if (proto == htons(ETH_P_TEB) && skb->len < ETH_ZLEN) {
+		skb_cow(skb, dev->needed_headroom + ETH_ZLEN - skb->len);
+		skb_put_zero(skb, ETH_ZLEN - skb->len);
+	}
+
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
 			 tunnel->parms.o_flags, proto, tunnel->parms.o_key,

If I apply the patch on the side with the gretap tunnel, the ARP packets are
properly padded, and seen by the host in the other end.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
