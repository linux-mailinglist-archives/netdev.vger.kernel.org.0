Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548653DA4A9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhG2Nsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbhG2Ns1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:48:27 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9EAC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:48:23 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y34so11140553lfa.8
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 06:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvq22uFbZBbH05d02LPltuuc9/z/qt5IMW2Adx7JReg=;
        b=BfT9rNZq6nzHh6q0JS2WCLNljBdUJ5o841WUobBDH4F/TpNlybHfv4jtxrm2m98Ajo
         MubZ/fQElfa2N3AI/f/ZTJGYrq1JzrOX6A+ElmCYtoV+k19dodrpcDMlLJ91xqnERrfF
         IRpNO1jAYjcteUfqUOWj1K0AM9vJ2eART7vaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvq22uFbZBbH05d02LPltuuc9/z/qt5IMW2Adx7JReg=;
        b=qrOLwxVmGfySbDSfU7zvX3rxu9BrJXacDWyn8IMGfGxJ6/2ahBTv0h6cw/xCcLmn8z
         9W8ve7xJX9fqium/iBCB5rhLjLH9eeMTqENxz4Sc9TdEE4TKBX3VBNXdmFC/CrPiobC8
         k2MpN30mthOh3iWfr+k+eLV1axCI7FMyIjPoxTqNYtfnshSr3TDviWUPDWNBhou1Y7xS
         hB3tTAOIbzItazS1jyj6ip/M3MU6ptVrcbKJKF+5m8Z8naBFBJf3q5P29LQPq/YP1MT6
         RBgwPk8P1peli6s/TxLmHVR6hu8+qNCQwrIKe8L1td7BZGlY6RBwAu1gC6CR/7UF8ysG
         2NCw==
X-Gm-Message-State: AOAM533DPkCXRDiX7+QCweaoqsPIDUPy9n1eudqHd7TZxZjqeHKloAIg
        VBaQhjt2NK6baqKLJ4tHFwxjZvIKL2VkvA==
X-Google-Smtp-Source: ABdhPJyt3UAMdsmLj1lm4pVxha5AaunQCqj4G6kg/ArLe5xdV4G2oFGv/4R4ZAWicfBenXlDORvFCQ==
X-Received: by 2002:a19:f51a:: with SMTP id j26mr3753073lfb.319.1627566501540;
        Thu, 29 Jul 2021 06:48:21 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id c23sm312849lfc.79.2021.07.29.06.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 06:48:20 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Alex Forster <aforster@cloudflare.com>
Subject: [PATCH net] net, gro: Set inner transport header offset in tcp/udp GRO hook
Date:   Thu, 29 Jul 2021 15:48:20 +0200
Message-Id: <20210729134820.221151-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GSO expects inner transport header offset to be valid when
skb->encapsulation flag is set. GSO uses this value to calculate the length
of an individual segment of a GSO packet in skb_gso_transport_seglen().

However, tcp/udp gro_complete callbacks don't update the
skb->inner_transport_header when processing an encapsulated TCP/UDP
segment. As a result a GRO skb has ->inner_transport_header set to a value
carried over from earlier skb processing.

This can have mild to tragic consequences. From miscalculating the GSO
segment length to triggering a page fault [1], when trying to read TCP/UDP
header at an address past the skb->data page.

The latter scenario leads to an oops report like so:

  BUG: unable to handle page fault for address: ffff9fa7ec00d008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 123f201067 P4D 123f201067 PUD 123f209067 PMD 0
  Oops: 0000 [#1] SMP NOPTI
  CPU: 44 PID: 0 Comm: swapper/44 Not tainted 5.4.53-cloudflare-2020.7.21 #1
  Hardware name: HYVE EDGE-METAL-GEN10/HS-1811DLite1, BIOS V2.15 02/21/2020
  RIP: 0010:skb_gso_transport_seglen+0x44/0xa0
  Code: c0 41 83 e0 11 f6 87 81 00 00 00 20 74 30 0f b7 87 aa 00 00 00 0f [...]
  RSP: 0018:ffffad8640bacbb8 EFLAGS: 00010202
  RAX: 000000000000feda RBX: ffff9fcc8d31bc00 RCX: ffff9fa7ec00cffc
  RDX: ffff9fa7ebffdec0 RSI: 000000000000feda RDI: 0000000000000122
  RBP: 00000000000005c4 R08: 0000000000000001 R09: 0000000000000000
  R10: ffff9fe588ae3800 R11: ffff9fe011fc92f0 R12: ffff9fcc8d31bc00
  R13: ffff9fe0119d4300 R14: 00000000000005c4 R15: ffff9fba57d70900
  FS:  0000000000000000(0000) GS:ffff9fe68df00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff9fa7ec00d008 CR3: 0000003e99b1c000 CR4: 0000000000340ee0
  Call Trace:
   <IRQ>
   skb_gso_validate_network_len+0x11/0x70
   __ip_finish_output+0x109/0x1c0
   ip_sublist_rcv_finish+0x57/0x70
   ip_sublist_rcv+0x2aa/0x2d0
   ? ip_rcv_finish_core.constprop.0+0x390/0x390
   ip_list_rcv+0x12b/0x14f
   __netif_receive_skb_list_core+0x2a9/0x2d0
   netif_receive_skb_list_internal+0x1b5/0x2e0
   napi_complete_done+0x93/0x140
   veth_poll+0xc0/0x19f [veth]
   ? mlx5e_napi_poll+0x221/0x610 [mlx5_core]
   net_rx_action+0x1f8/0x790
   __do_softirq+0xe1/0x2bf
   irq_exit+0x8e/0xc0
   do_IRQ+0x58/0xe0
   common_interrupt+0xf/0xf
   </IRQ>

The bug can be observed in a simple setup where we send IP/GRE/IP/TCP
packets into a netns over a veth pair. Inside the netns, packets are
forwarded to dummy device:

  trafgen -> [veth A]--[veth B] -forward-> [dummy]

For veth B to GRO aggregate packets on receive, it needs to have an XDP
program attached (for example, a trivial XDP_PASS). Additionally, for UDP,
we need to enable GSO_UDP_L4 feature on the device:

  ip netns exec A ethtool -K AB rx-udp-gro-forwarding on

The last component is an artificial delay to increase the chances of GRO
batching happening:

  ip netns exec A tc qdisc add dev AB root \
     netem delay 200us slot 5ms 10ms packets 2 bytes 64k

With such a setup in place, the bug can be observed by tracing the skb
outer and inner offsets when GSO skb is transmitted from the dummy device:

tcp:

FUNC              DEV   SKB_LEN  NH  TH ENC INH ITH GSO_SIZE GSO_TYPE
ip_finish_output  dumB     2830 270 290   1 294 254     1383 (tcpv4,gre,)
                                                ^^^
udp:

FUNC              DEV   SKB_LEN  NH  TH ENC INH ITH GSO_SIZE GSO_TYPE
ip_finish_output  dumB     2818 270 290   1 294 254     1383 (gre,udp_l4,)
                                                ^^^

Fix it by updating the inner transport header offset in tcp/udp
gro_complete callbacks, similar to how {inet,ipv6}_gro_complete callbacks
update the inner network header offset, when skb->encapsulation flag is
set.

[1] https://lore.kernel.org/netdev/CAKxSbF01cLpZem2GFaUaifh0S-5WYViZemTicAg7FCHOnh6kug@mail.gmail.com/

Fixes: bf296b125b21 ("tcp: Add GRO support")
Fixes: f993bc25e519 ("net: core: handle encapsulation offloads when computing segment lengths")
Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Reported-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/tcp_offload.c | 3 +++
 net/ipv4/udp_offload.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index e09147ac9a99..fc61cd3fea65 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -298,6 +298,9 @@ int tcp_gro_complete(struct sk_buff *skb)
 	if (th->cwr)
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
 
+	if (skb->encapsulation)
+		skb->inner_transport_header = skb->transport_header;
+
 	return 0;
 }
 EXPORT_SYMBOL(tcp_gro_complete);
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 9dde1e5fb449..1380a6b6f4ff 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -624,6 +624,10 @@ static int udp_gro_complete_segment(struct sk_buff *skb)
 
 	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 	skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_L4;
+
+	if (skb->encapsulation)
+		skb->inner_transport_header = skb->transport_header;
+
 	return 0;
 }
 
-- 
2.31.1

