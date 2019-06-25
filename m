Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F11553F8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbfFYQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:07:11 -0400
Received: from secure28f.mail.yandex.net ([77.88.29.112]:49691 "EHLO
        secure28f.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfFYQHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 12:07:11 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 12:07:08 EDT
Received: from secure28f.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by secure28f.mail.yandex.net (Yandex) with ESMTP id 7BAE431C1C5F;
        Tue, 25 Jun 2019 18:59:56 +0300 (MSK)
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:401:eef4:bbff:fe29:83c4])
        by secure28f.mail.yandex.net (nwsmtp/Yandex) with ESMTPS id 8CrruufDXQ-xsWCNWSZ;
        Tue, 25 Jun 2019 18:59:54 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Front: secure28f.mail.yandex.net
X-Yandex-TimeMark: 1561478394.768
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1561478394; bh=j3Za4mwvXNVcqNaWOAH0WO4UYFFwM7tME+Ca1jP3/m0=;
        h=Date:Message-ID:Cc:To:Subject:From;
        b=zdMjhoD1ItE+n+mm0424Eh2c5rsUgNs0S4yXnHpec/RINRbh3pKznPMhwKGZA1RQO
         OrxMd8r2BHN6auHwuIEqQ28kJsSnp3RpIu17KtfogJJLh9K56l0bMOPJ4KhKJlBRlJ
         z6bWE/k9n35Pwb8JuAXWCu2AeRF75HU8kmevyW3Q=
X-Yandex-Suid-Status: 1 0,1 0,1 0,1 0,1 0,1 0,1 0,1 0,1 0,1 0
X-Yandex-Spam: 1
X-Yandex-Envelope: aGVsbz1bSVB2NjoyYTAyOjZiODowOjQwMTplZWY0OmJiZmY6ZmUyOTo4M2M0XQptYWlsX2Zyb209dmZlZG9yZW5rb0B5YW5kZXgtdGVhbS5ydQpyY3B0X3RvPW5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcKcmNwdF90bz1sdnMtZGV2ZWxAdmdlci5rZXJuZWwub3JnCnJjcHRfdG89bmV0ZGV2QHZnZXIua2VybmVsLm9yZwpyY3B0X3RvPWRhdmVtQGRhdmVtbG9mdC5uZXQKcmNwdF90bz1md0BzdHJsZW4uZGUKcmNwdF90bz1rYWRsZWNAYmxhY2tob2xlLmtma2kuaHUKcmNwdF90bz1qYUBzc2kuYmcKcmNwdF90bz13ZW5zb25nQGxpbnV4LXZzLm9yZwpyY3B0X3RvPWtobGVibmlrb3ZAeWFuZGV4LXRlYW0ucnUKcmNwdF90bz1wYWJsb0BuZXRmaWx0ZXIub3JnCnJlbW90ZV9ob3N0PWR5bmFtaWMtcmVkLmRoY3AueW5keC5uZXQKcmVtb3RlX2lwPTJhMDI6NmI4OjA6NDAxOmVlZjQ6YmJmZjpmZTI5OjgzYzQK
X-Yandex-Hint: bGFiZWw9U3lzdE1ldGthU086cGVvcGxlCmxhYmVsPVN5c3RNZXRrYVNPOnRydXN0XzYKbGFiZWw9U3lzdE1ldGthU086dF9wZW9wbGUKc2Vzc2lvbl9pZD04Q3JydXVmRFhRLXhzV0NOV1NaCmxhYmVsPXN5bWJvbDplbmNyeXB0ZWRfbGFiZWwKaXBmcm9tPTJhMDI6NmI4OjA6NDAxOmVlZjQ6YmJmZjpmZTI5OjgzYzQK
From:   Vadim Fedorenko <vfedorenko@yandex-team.ru>
Subject: [PATCH] ipvs: allow tunneling with gre encapsulation
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Message-ID: <2caa3152-f90d-1ad6-3f98-b07960fed171@yandex-team.ru>
Date:   Tue, 25 Jun 2019 18:59:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

windows real servers can handle gre tunnels, this patch allows
gre encapsulation with the tunneling method, thereby letting ipvs
be load balancer for windows-based services

Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
---
  include/uapi/linux/ip_vs.h      |  1 +
  net/netfilter/ipvs/ip_vs_xmit.c | 76 +++++++++++++++++++++++++++++++++++++++++
  2 files changed, 77 insertions(+)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index e4f1806..4102ddc 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -128,6 +128,7 @@
  enum {
  	IP_VS_CONN_F_TUNNEL_TYPE_IPIP = 0,	/* IPIP */
  	IP_VS_CONN_F_TUNNEL_TYPE_GUE,		/* GUE */
+	IP_VS_CONN_F_TUNNEL_TYPE_GRE,		/* GRE */
  	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
  };

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 71fc6d6..fad3f33 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -29,6 +29,7 @@
  #include <linux/tcp.h>                  /* for tcphdr */
  #include <net/ip.h>
  #include <net/gue.h>
+#include <net/gre.h>
  #include <net/tcp.h>                    /* for csum_tcpudp_magic */
  #include <net/udp.h>
  #include <net/icmp.h>                   /* for icmp_send */
@@ -389,6 +390,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
  			    skb->ip_summed == CHECKSUM_PARTIAL)
  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
  		}
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+			__be16 tflags = 0;
+			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+				tflags |= TUNNEL_CSUM;
+			mtu -= gre_calc_hlen(tflags);
+		}
  		if (mtu < 68) {
  			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
  			goto err_put;
@@ -549,6 +556,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
  			    skb->ip_summed == CHECKSUM_PARTIAL)
  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
  		}
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+			__be16 tflags = 0;
+			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+				tflags |= TUNNEL_CSUM;
+			mtu -= gre_calc_hlen(tflags);
+		}
  		if (mtu < IPV6_MIN_MTU) {
  			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
  				     IPV6_MIN_MTU);
@@ -1079,6 +1092,24 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  	return 0;
  }

+static void
+ipvs_gre_encap(struct net *net, struct sk_buff *skb,
+	       struct ip_vs_conn *cp, __u8 *next_protocol)
+{
+	size_t hdrlen;
+	__be16 tflags = 0;
+	__be16 proto = *next_protocol == IPPROTO_IPIP ? htons(ETH_P_IP) : 
htons(ETH_P_IPV6);
+
+	if (cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+		tflags |= TUNNEL_CSUM;
+
+	hdrlen = gre_calc_hlen(tflags);
+
+	gre_build_header(skb, hdrlen, tflags, proto, 0, 0);
+
+	*next_protocol = IPPROTO_GRE;
+}
+
  /*
   *   IP Tunneling transmitter
   *
@@ -1153,6 +1184,18 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
  	}

+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		size_t gre_hdrlen;
+		__be16 tflags = 0;
+
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			tflags |= TUNNEL_CSUM;
+
+		gre_hdrlen = gre_calc_hlen(tflags);
+
+		max_headroom += gre_hdrlen;
+	}
+
  	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
  	dfp = sysctl_pmtu_disc(ipvs) ? &df : NULL;
  	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
@@ -1174,6 +1217,13 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  		}
  	}

+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			gso_type |= SKB_GSO_GRE_CSUM;
+		else
+			gso_type |= SKB_GSO_GRE;
+	}
+
  	if (iptunnel_handle_offloads(skb, gso_type))
  		goto tx_error;

@@ -1194,6 +1244,9 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  		udp_set_csum(!check, skb, saddr, cp->daddr.ip, skb->len);
  	}

+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		ipvs_gre_encap(net, skb, cp, &next_protocol);
+	}

  	skb_push(skb, sizeof(struct iphdr));
  	skb_reset_network_header(skb);
@@ -1289,6 +1342,18 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
  	}

+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		size_t gre_hdrlen;
+		__be16 tflags = 0;
+
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			tflags |= TUNNEL_CSUM;
+
+		gre_hdrlen = gre_calc_hlen(tflags);
+
+		max_headroom += gre_hdrlen;
+	}
+
  	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
  					 &next_protocol, &payload_len,
  					 &dsfield, &ttl, NULL);
@@ -1308,6 +1373,13 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  		}
  	}

+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			gso_type |= SKB_GSO_GRE_CSUM;
+		else
+			gso_type |= SKB_GSO_GRE;
+	}
+
  	if (iptunnel_handle_offloads(skb, gso_type))
  		goto tx_error;

@@ -1328,6 +1400,10 @@ static inline int __tun_gso_type_mask(int encaps_af, int 
orig_af)
  		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
  	}

+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		ipvs_gre_encap(net, skb, cp, &next_protocol);
+	}
+
  	skb_push(skb, sizeof(struct ipv6hdr));
  	skb_reset_network_header(skb);
  	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-- 
1.9.1
