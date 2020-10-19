Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3BE292736
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgJSM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJSM0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BDFC0613CE;
        Mon, 19 Oct 2020 05:26:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j8so5621057pjy.5;
        Mon, 19 Oct 2020 05:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HzhHczRtL69delBJzpCl1jQSUECAnKmwpTvFJI3PgEA=;
        b=e6ziUfIm/yomxmVAsxpRYjdZ19zKQ+CLYxg8Us2gdyRRLUBvQA+PSpcBLay2C41qKO
         gOEJ3x3ir1sujXNc/NRhOlcjOkMIOL1LI3KeBq5AR79OKS79BtAIBCk+EAkuxR3wTYHc
         TWFewjy+ySg7J6Ja43GsErYCpsriwxo1aF1ghfI7lnS7lwBYIlhms45IEoyWRyVB/P86
         cOzBqR8gTFVqBGB2glLUsuwtruhAsaIWSAgeRwoSuBpKWwiuuU6RmWicfqh2Ip0Y3Qaj
         FyBXXyOHVzj+6u5SgbKk9oikySps381dUzef5Y/PQe85PscpiS74HcvPRLLkftISVenF
         k32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HzhHczRtL69delBJzpCl1jQSUECAnKmwpTvFJI3PgEA=;
        b=IHZDzGIgzwe7BTtbrZ3o/fGlrAE1blT1djZU7xBDnx3477UYO4vF2iBqakmGdHzckx
         u+ku+cjo+ae1qfxrTWb+k0VqymJn+pkV88wzpy1TpltA4FwfaxGxGMHaJhHHwA2Xvtl5
         +DHVWisli+WHfHCJ/8vp9xmkhh9zV+8SttU+Xcs4nSZs12zKB/ppBRryWljwsPrYQvxw
         mPGL4stwwuh7XAXL3Q5/q4MVAcxB1Ko9L8zUhtBRmxdr0UP21xTofUYTZPMqEAGmcU+I
         wXcfAPNqjvOZmZO7wWhfJn0WZox4oxDpHLxGAM1BoiQjI99sYWvSmjAO28AvBEI4Egcr
         kWKA==
X-Gm-Message-State: AOAM530scCcsXrinXFSrS4kixAL6rT29U0ZSYbx2Nc/Y2fneQ2qGFwb8
        nMirUtEAazOSt06SxdVVjGIhGGWUYQg=
X-Google-Smtp-Source: ABdhPJwWcxr1s1orKJlC4mu+PfxMIHUse6md0oJlVwBhwpcKTGHS8Hx+vkg5J5NdiEQLoMtaBw4Apw==
X-Received: by 2002:a17:90a:a10e:: with SMTP id s14mr16338001pjp.62.1603110367143;
        Mon, 19 Oct 2020 05:26:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z73sm12142034pfc.75.2020.10.19.05.26.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 03/16] udp: support sctp over udp in skb_udp_tunnel_segment
Date:   Mon, 19 Oct 2020 20:25:20 +0800
Message-Id: <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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

