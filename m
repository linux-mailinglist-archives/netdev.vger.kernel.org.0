Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1A1B0D62
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgDTNvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbgDTNvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:51:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F5FC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:51:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id g30so4970593pfr.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0D5BpEVyHOq1n9UYNGKS1aVJpvlHpe2FWjqRluu1OD8=;
        b=aIe6/FnAEdwn77VqzRABdIcWAIZP4OxjwEUkCTBcu2g5D6fFRyY11PfoAmwT0EKvic
         GhQb/gygYCBvUuxGY9eoZvWhmF9U+oDrwiPM0LT3tt4gjCvqxdNYDUGHUcJH+7b+bYDb
         owLruCGYT7Im/+dTgvbxpTUmWGbAZZ6K4yj2Te2aBqyTlJbPVBdJ21siFad6MTBWo29u
         oJNN0GS2O1fChj9B5JoOQ8NZ9lirWePc07iZaTUDRD2lRNNNbe++UE4fVONbPP191pvS
         9LpLBSA4JhTKRDtBjJaVXrOwVHEYo+8pieYBjn8KazDzbmCkOvsRBBxspZFqWXKjxFbP
         jIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0D5BpEVyHOq1n9UYNGKS1aVJpvlHpe2FWjqRluu1OD8=;
        b=K+MnJKSxu76xcZJ0PK1tb/iFZIo+wpTZyQPl7kyTT8RIieMATs6AhdLv5x71Z8MNTv
         NY5PHMyL9INrKb/Mkv3cvL0aM2yE43oFDiHNInP/t+6GHvAwdcWxKVbUfzCrNz3K4X8O
         gGw0vrGSfd2iguQ7avwP8xFPcsJcA7RnnA2B+OT2HguCXS5SC8itbhprlidlxfqkcAfx
         o43iy37EKoyfxnlKt3kR+J1OEYzUCcKc8fDIyGAQIcQ4hCKWqjAb7mPj8I9ywRZpaAQd
         sQ/JoEodA8dhFeTpq+zrcwexLBJ95gRTcvJaM5ixuGIt9NmsSSwQCZH2QJqHpUpsNBiQ
         EEmw==
X-Gm-Message-State: AGi0PuZ+3+vMiysl6MykhMLigMYYAe6+ukgRATDw5jYaDIXDdqBrhRSc
        ZABlDKprbuJBekmiGdpYZo1hTKNV
X-Google-Smtp-Source: APiQypKmxC6q4WlGU3ajBu3v/ou3zv0s/THZ910FhRtACLDq7xLDMJk5CTuuLtQQmFALNXn/zEMkcg==
X-Received: by 2002:a65:530b:: with SMTP id m11mr16517330pgq.338.1587390677971;
        Mon, 20 Apr 2020 06:51:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g184sm1149654pfb.80.2020.04.20.06.51.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2020 06:51:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
Date:   Mon, 20 Apr 2020 21:51:09 +0800
Message-Id: <79c8488570575776c9e2f776e9f6000f591713b5.1587390669.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/xfrm/xfrm_output.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 2fd3d99..69c33ca 100644
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
2.1.0

