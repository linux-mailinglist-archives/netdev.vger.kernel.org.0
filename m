Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64016438BC4
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhJXUTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:19:23 -0400
Received: from smtp.skoda.cz ([185.50.127.80]:38868 "EHLO smtp.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJXUTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 16:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenaugust2021; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1635106619; x=1635711419;
        h=From:Sender:Reply-To:Subject:Date:Message-Id:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dL7ig5f91ceHpdYenapsZAoHOlbl4yJxodwkpIUiazE=;
        b=J7y4bkRAIMoMsTctE7jmxG6u6GTzeOpgnxSQQkW3WpbOJpUZOO7kgXXuRb42Cjt9
        wNjg3Eh8rYPiNQ0iX00cTHodMFnDHJW9ETI63Pn6mQevGuev5+LiSQ3nsDpKYfBY
        yfJkCvo3ZQVCpvOvAUJMCfttUaW1Qnlj139pwat27RAooS8QYYNiJDFmVQ8QJQ4z
        FYf80oihZgPw8oLHTZi2AcWRSzaj5ih4KWONUvgS+xwFYfuPPAnyc7IDs1cDRLH8
        pzmluKNNRXO9iz7WTvOmbheoOmEPpwGtKFeJOTpRu3V4l8i1HsgZb0008ZfkdMNf
        +290x7OhSywpn3FC1fJ+Lg==;
X-AuditID: 0a2a0137-1666f70000011b28-d0-6175bf3b1a4c
Received: from trnn1532h.skoda.cz (TRNN1501.skoda.cz [10.99.100.53])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp.skoda.cz (Mail Gateway) with SMTP id BA.6A.06952.B3FB5716; Sun, 24 Oct 2021 22:16:59 +0200 (CEST)
From:   Cyril Strejc <cyril.strejc@skoda.cz>
To:     davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, cyril.strejc@skoda.cz
Subject: [PATCH v2] net: multicast: calculate csum of looped-back and forwarded packets
Date:   Sun, 24 Oct 2021 22:14:25 +0200
Message-Id: <20211024201423.1367844-1-cyril.strejc@skoda.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019114441.1943131-1-cyril.strejc@skoda.cz>
References: <20211019114441.1943131-1-cyril.strejc@skoda.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42LhSk4x1bXeX5po8PqmicXe11vZLeacb2Gx
        uLCtj9Xi2AIxi8U/NzA5sHpsWXmTyWPnrLvsHptWdbJ5vLhxkdXj8ya5ANYoLpuU1JzMstQi
        fbsEroyGz33sBb3SFWsO97A0MH4X7WLk5JAQMJG4vegcUxcjF4eQwDwmiUuXTzGCJNgEtCTm
        dk5mBrFFBHwlTvYfYwOxmQWMJRZ9WckOYgsLhEtc278ezGYRUJV4/ecuE4jNK2AjcX3/HmaI
        BfISMy99B6vhFLCVOPtsLZgtBFQz98oeqHpBiZMzn7BAzJeXaN46m3kCI+8sJKlZSFILGJlW
        MfIW55YU6BVn56ck6iVXbWIEhZcWo/kOxhun3A4xMnEwHmKU4GBWEuG1+VSSKMSbklhZlVqU
        H19UmpNafIhRmoNFSZzXfa5OopBAemJJanZqakFqEUyWiYNTqoExP/xSSWkbE2+B2/bSMv+E
        5Rfr3TpF8zQ+t2yx69n17azGbe6UjR1h6nOerPCYuIQ758HF+V5C6/l360UmX+ad4LjomJzy
        KdcFdxYqnebN+K9qyFTdWOYc/DDjzqv28IgTE3Imzt7Ba6Puf2VBgOaHNx+8nl2WjbjPmK33
        sucn5z6+lRZ6OwKVWIozEg21mIuKEwGSi0KeHQIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During a testing of an user-space application which transmits UDP
multicast datagrams and utilizes multicast routing to send the UDP
datagrams out of defined network interfaces, I've found a multicast
router does not fill-in UDP checksum into locally produced, looped-back
and forwarded UDP datagrams, if an original output NIC the datagrams
are sent to has UDP TX checksum offload enabled.

The datagrams are sent malformed out of the NIC the datagrams have been
forwarded to.

It is because:

1. If TX checksum offload is enabled on the output NIC, UDP checksum
   is not calculated by kernel and is not filled into skb data.

2. dev_loopback_xmit(), which is called solely by
   ip_mc_finish_output(), sets skb->ip_summed = CHECKSUM_UNNECESSARY
   unconditionally.

3. Since 35fc92a9 ("[NET]: Allow forwarding of ip_summed except
   CHECKSUM_COMPLETE"), the ip_summed value is preserved during
   forwarding.

4. If ip_summed != CHECKSUM_PARTIAL, checksum is not calculated during
   a packet egress.

The minimum fix in dev_loopback_xmit():

1. Preserves skb->ip_summed CHECKSUM_PARTIAL. This is the
   case when the original output NIC has TX checksum offload enabled.
   The effects are:

     a) If the forwarding destination interface supports TX checksum
        offloading, the NIC driver is responsible to fill-in the
        checksum.

     b) If the forwarding destination interface does NOT support TX
        checksum offloading, checksums are filled-in by kernel before
        skb is submitted to the NIC driver.

     c) For local delivery, checksum validation is skipped as in the
        case of CHECKSUM_UNNECESSARY, thanks to skb_csum_unnecessary().

2. Translates ip_summed CHECKSUM_NONE to CHECKSUM_UNNECESSARY. It
   means, for CHECKSUM_NONE, the behavior is unmodified and is there
   to skip a looped-back packet local delivery checksum validation.

Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>
---
 include/net/udp.h | 5 +++--
 net/core/dev.c    | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 360df454356c..909ecf447e0f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -494,8 +494,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
 	 * packets in udp_gro_complete_segment. As does UDP GSO, verified by
 	 * udp_send_skb. But when those packets are looped in dev_loopback_xmit
-	 * their ip_summed is set to CHECKSUM_UNNECESSARY. Reset in this
-	 * specific case, where PARTIAL is both correct and required.
+	 * their ip_summed CHECKSUM_NONE is changed to CHECKSUM_UNNECESSARY.
+	 * Reset in this specific case, where PARTIAL is both correct and
+	 * required.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		skb->ip_summed = CHECKSUM_PARTIAL;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ee9fecd3aff..c0009c3f88a0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3906,7 +3906,8 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb_reset_mac_header(skb);
 	__skb_pull(skb, skb_network_offset(skb));
 	skb->pkt_type = PACKET_LOOPBACK;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	if (skb->ip_summed == CHECKSUM_NONE)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	WARN_ON(!skb_dst(skb));
 	skb_dst_force(skb);
 	netif_rx_ni(skb);
-- 
2.25.1

