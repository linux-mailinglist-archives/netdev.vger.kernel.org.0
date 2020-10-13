Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E6F28C940
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390129AbgJMH2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D72C0613D0;
        Tue, 13 Oct 2020 00:28:15 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d23so10200440pll.7;
        Tue, 13 Oct 2020 00:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=5n9MDJ2fdPNgSTG4tMoW/SRIt8/WSpHVsbv6RmWVU3Y=;
        b=IneJXeAP2AYogjJidckSS6L0uH6PzRtuh2cbtkEIe+QHUxglenWggeRo9YbTCQKGFD
         ZAJRVJEYSm/jajfnXKgdqb8QGBQvWUYlCdpihA2cnkFhyEMnIIz3ZKXI/g20reV8LIwD
         05lULbBQ+TVleetRadD+/ruiC3jxeWMiCdOgtXSrp2nNrPBqc3b0UcN0izVZf8qyO967
         8h2lBr9AfvKNL95rTZO8PBHv+/BDq23/oA03PMeveySDOfK1rI23EyfAErqpuUltU/rB
         qj3djH53VHvR38OE+2jgR1C5jjmruEzbdR01Jza8T90/ZS+1Fp+jVv+ht+XFdlzUzoln
         Dd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=5n9MDJ2fdPNgSTG4tMoW/SRIt8/WSpHVsbv6RmWVU3Y=;
        b=iM6UOh0EEngvDEP94U7fNQkPvB/mEuJk3FY8Iq5vLDvvUlSA5idNAMCubnBvfgI8a7
         /cCnJEFDg3MIvDvd5ptjaKHt1fyybUD40VO2NDZvW95t1o3eWNAJN/eOHY63Hl+VYqhl
         UChPZb8XdzCOdbYipatleBnODGE7024NIztf2MkUjAEXMsiKe/P95ukfCfRFTei+qthG
         ftKqGfQKHPaI3EAObPZaLl7WmGpMfRMRemUP+keqmn5vCvIPINBIotG+l8pci5q7UELn
         dZSZ+ZoHDrbDlKEs+9XAKBAECRjG4bX+lMXQnK1+LFPTo99CatZHdx5zC8Vf4keaBO5G
         zV9Q==
X-Gm-Message-State: AOAM531f0TqGSWhAyfZ2RFOCTEHOEblAvlg+bnSm5T4mmWGtJVuGi5ac
        72l5P17tAinqmFqgXCuIc5LeyxcmH/g=
X-Google-Smtp-Source: ABdhPJxo+/Jpy23MnxFz6eP3WmtW9zAnNtIjs6ZxK8+xmMCYe2/HmmfkIiIzxSRHcWEhyzTUwpYWrg==
X-Received: by 2002:a17:90a:1903:: with SMTP id 3mr24682806pjg.74.1602574095104;
        Tue, 13 Oct 2020 00:28:15 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n19sm21961236pfu.24.2020.10.13.00.28.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 03/16] udp: support sctp over udp in skb_udp_tunnel_segment
Date:   Tue, 13 Oct 2020 15:27:28 +0800
Message-Id: <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the gso of sctp over udp packets, sctp_gso_segment() will be called in
skb_udp_tunnel_segment(), we need to set transport_header to sctp header.

As all the current HWs can't handle both crc checksum and udp checksum at
the same time, the crc checksum has to be done in sctp_gso_segment() by
removing the NETIF_F_SCTP_CRC flag from the features.

Meanwhile, if the HW can't do udp checksum, csum and csum_start has to be
set correctly, and udp checksum will be done in __skb_udp_tunnel_segment()
by calling gso_make_checksum().

Thanks to Paolo, Marcelo and Guillaume for helping with this one.

v1->v2:
  - no change.
v2->v3:
  - remove the he NETIF_F_SCTP_CRC flag from the features.
  - set csum and csum_start in sctp_gso_make_checksum().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 3 +++
 net/sctp/offload.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66f..4d31255 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -49,6 +49,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	__skb_pull(skb, tnl_hlen);
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb_inner_network_offset(skb));
+	skb_set_transport_header(skb, skb_inner_transport_offset(skb));
 	skb->mac_len = skb_inner_network_offset(skb);
 	skb->protocol = new_protocol;
 
@@ -67,6 +68,8 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 				      (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM))));
 
 	features &= skb->dev->hw_enc_features;
+	/* CRC checksum can't be handled by HW when it's a udp tunneling packet. */
+	features &= ~NETIF_F_SCTP_CRC;
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index 74847d6..9f6f818 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 {
 	skb->ip_summed = CHECKSUM_NONE;
 	skb->csum_not_inet = 0;
-	gso_reset_checksum(skb, ~0);
+	/* csum and csum_start in gso cb may be needed to do the udp
+	 * checksum when it's a udp tunneling packet.
+	 */
+	SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
+	SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
 	return sctp_compute_cksum(skb, skb_transport_offset(skb));
 }
 
-- 
2.1.0

