Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682D829E3CB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgJ2HV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgJ2HVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:21:01 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD48C08EA6B;
        Thu, 29 Oct 2020 00:05:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i26so1579467pgl.5;
        Thu, 29 Oct 2020 00:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HzhHczRtL69delBJzpCl1jQSUECAnKmwpTvFJI3PgEA=;
        b=T7GQKEyzFtYd8QGnJj0t7UU8TfwNFAzIeLpZvWDcSs5bJRvgfjO9D/MdGelXN4GEYu
         O+wJnGe4ulTj13PK/zCNVR8xu9KHF13iseFJTE3mQMry09AocDDBRM9j9Rl4TAWZv+x4
         v/m7AON4jspfWPwsl7gioBd8pTXUFVpgNrrGxJg1HD+4NKVL21n48/AEBYZdguFQtL8V
         OyKMuaKVJZ50BrppKKE7T4qvUEFTDa3DiMYWoLHBiNwWNI1rKhzpZvV1X8gtPZ6abiyG
         3vWdvIzWqSUxqqJRHZ1nyD55GU51tneZo7ntHQxaomDa7ugxZYrJqtsE9tNTnc7HARZr
         F/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HzhHczRtL69delBJzpCl1jQSUECAnKmwpTvFJI3PgEA=;
        b=FDpAy9f3OtZwukSm+kNX1jPmKnxy5xFfeSyQDYQQFzsUY/HCbCv5uRd0kp4Olx1CLJ
         3qF3LEdloYOUgBDd4pbguU3LXOfeRfNowBgsOfGj5Tw6jpf82aIxhrd+JHNnmsql7AoK
         9mxwkiNqiaHcOl9Ihk7GWfwWxJWZs0AgifHduj1xErQ+1ZGBNbVq7lmPn5HOyrfIii/w
         emlEEq8+pl8psszt7nNaB0jHt78AJ8BsgqpIe1bFyPrTiIlEFIR/gar40fGMbPDcD1zZ
         5xCzU15VArfcpD8DN++/7LGwVw4dySs+iWymVGU7oMZSAZTVoyzGUjUfYMXq1ym3WWuu
         IbDg==
X-Gm-Message-State: AOAM530ph4XgDz84FZNRCar7o6vNoue9JXSv12OOCDq/yyxAP87uK2S5
        o24Orm0q9GYcCNhLEDqsfJT8cXG/rr4=
X-Google-Smtp-Source: ABdhPJxCNH5OlNQ3ejkNT5tXgbyR4gqtESjemW0lgrUq4Fxxsyj6oHfMI/AzR+UYPA1yQDzDnMB64Q==
X-Received: by 2002:a17:90a:f683:: with SMTP id cl3mr2963678pjb.84.1603955144778;
        Thu, 29 Oct 2020 00:05:44 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k77sm1859863pfd.99.2020.10.29.00.05.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:05:44 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 03/16] udp: support sctp over udp in skb_udp_tunnel_segment
Date:   Thu, 29 Oct 2020 15:04:57 +0800
Message-Id: <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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
index e67a66f..b8b1fde 100644
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
+	/* CRC checksum can't be handled by HW when it's a UDP tunneling packet. */
+	features &= ~NETIF_F_SCTP_CRC;
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index 74847d6..ce281a9 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 {
 	skb->ip_summed = CHECKSUM_NONE;
 	skb->csum_not_inet = 0;
-	gso_reset_checksum(skb, ~0);
+	/* csum and csum_start in GSO CB may be needed to do the UDP
+	 * checksum when it's a UDP tunneling packet.
+	 */
+	SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
+	SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
 	return sctp_compute_cksum(skb, skb_transport_offset(skb));
 }
 
-- 
2.1.0

