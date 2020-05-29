Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399DA1E7B27
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgE2LEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39492 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2LEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A7F9F205B4;
        Fri, 29 May 2020 13:04:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QMxQJiLi6AbS; Fri, 29 May 2020 13:04:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D991220539;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 32BE03180607;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/15] xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
Date:   Fri, 29 May 2020 13:04:02 +0200
Message-ID: <20200529110408.6349-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

An use-after-free crash can be triggered when sending big packets over
vxlan over esp with esp offload enabled:

  [] BUG: KASAN: use-after-free in ipv6_gso_pull_exthdrs.part.8+0x32c/0x4e0
  [] Call Trace:
  []  dump_stack+0x75/0xa0
  []  kasan_report+0x37/0x50
  []  ipv6_gso_pull_exthdrs.part.8+0x32c/0x4e0
  []  ipv6_gso_segment+0x2c8/0x13c0
  []  skb_mac_gso_segment+0x1cb/0x420
  []  skb_udp_tunnel_segment+0x6b5/0x1c90
  []  inet_gso_segment+0x440/0x1380
  []  skb_mac_gso_segment+0x1cb/0x420
  []  esp4_gso_segment+0xae8/0x1709 [esp4_offload]
  []  inet_gso_segment+0x440/0x1380
  []  skb_mac_gso_segment+0x1cb/0x420
  []  __skb_gso_segment+0x2d7/0x5f0
  []  validate_xmit_skb+0x527/0xb10
  []  __dev_queue_xmit+0x10f8/0x2320 <---
  []  ip_finish_output2+0xa2e/0x1b50
  []  ip_output+0x1a8/0x2f0
  []  xfrm_output_resume+0x110e/0x15f0
  []  __xfrm4_output+0xe1/0x1b0
  []  xfrm4_output+0xa0/0x200
  []  iptunnel_xmit+0x5a7/0x920
  []  vxlan_xmit_one+0x1658/0x37a0 [vxlan]
  []  vxlan_xmit+0x5e4/0x3ec8 [vxlan]
  []  dev_hard_start_xmit+0x125/0x540
  []  __dev_queue_xmit+0x17bd/0x2320  <---
  []  ip6_finish_output2+0xb20/0x1b80
  []  ip6_output+0x1b3/0x390
  []  ip6_xmit+0xb82/0x17e0
  []  inet6_csk_xmit+0x225/0x3d0
  []  __tcp_transmit_skb+0x1763/0x3520
  []  tcp_write_xmit+0xd64/0x5fe0
  []  __tcp_push_pending_frames+0x8c/0x320
  []  tcp_sendmsg_locked+0x2245/0x3500
  []  tcp_sendmsg+0x27/0x40

As on the tx path of vxlan over esp, skb->inner_network_header would be
set on vxlan_xmit() and xfrm4_tunnel_encap_add(), and the later one can
overwrite the former one. It causes skb_udp_tunnel_segment() to use a
wrong skb->inner_network_header, then the issue occurs.

This patch is to fix it by calling xfrm_output_gso() instead when the
inner_protocol is set, in which gso_segment of inner_protocol will be
done first.

While at it, also improve some code around.

Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 2fd3d990d992..69c33cab8f49 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -583,18 +583,20 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		xfrm_state_hold(x);
 
 		if (skb_is_gso(skb)) {
-			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
+			if (skb->inner_protocol)
+				return xfrm_output_gso(net, sk, skb);
 
-			return xfrm_output2(net, sk, skb);
+			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
+			goto out;
 		}
 
 		if (x->xso.dev && x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)
 			goto out;
+	} else {
+		if (skb_is_gso(skb))
+			return xfrm_output_gso(net, sk, skb);
 	}
 
-	if (skb_is_gso(skb))
-		return xfrm_output_gso(net, sk, skb);
-
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		err = skb_checksum_help(skb);
 		if (err) {
-- 
2.17.1

