Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641B96F0A89
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbjD0RKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbjD0RKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:10:37 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE12D5F
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 10:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682615432; x=1714151432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DVDIpe/44i1QuOWSgE4jwx9ZxpNapoWF4gHELVO/JtE=;
  b=AflNo5kAKPR+DKbLSm5xmfAiz4ks8K3t85ROu4VxlJ1SnCpaNHwkjYku
   foRGoLEo5E6rRSKhkqV/y+Vf1qmk0NrTcP545OEzZsSRYsmL6yV1H/+6d
   Q1KXJhBcRmHYxiNpLvkQQLL5aXIvwsfVenhyT6n7cCF1z3nV0EscpH3l6
   A=;
X-IronPort-AV: E=Sophos;i="5.99,230,1677542400"; 
   d="scan'208";a="323656686"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 17:10:29 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id D6A96A104E;
        Thu, 27 Apr 2023 17:10:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 17:10:27 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.45) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 17:10:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <xiyou.wangcong@gmail.com>
CC:     <cong.wang@bytedance.com>, <edumazet@google.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
        <oswalpalash@gmail.com>
Subject: Re: [Patch net v2] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
Date:   Thu, 27 Apr 2023 10:10:13 -0700
Message-ID: <20230427171013.9911-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
References: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.45]
X-ClientProxiedBy: EX19D044UWB001.ant.amazon.com (10.13.139.171) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 26 Apr 2023 23:00:06 -0700
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When a tunnel device is bound with the underlying device, its
> dev->needed_headroom needs to be updated properly. IPv4 tunnels
> already do the same in ip_tunnel_bind_dev(). Otherwise we may
> not have enough header room for skb, especially after commit
> b17f709a2401 ("gue: TX support for using remote checksum offload option").
> 
> Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
> Reported-by: Palash Oswal <oswalpalash@gmail.com>
> Link: https://lore.kernel.org/netdev/CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com/
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
> v2: follow reverse Christmas tree style

nit: less changes needed if we put t_hlen init down.

---8<---
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 70d81bba5093..dce9efba24a9 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1095,6 +1095,7 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 
 static void ipip6_tunnel_bind_dev(struct net_device *dev)
 {
+	int t_hlen, hlen = LL_MAX_HEADER;
 	struct net_device *tdev = NULL;
 	struct ip_tunnel *tunnel;
 	const struct iphdr *iph;
@@ -1122,15 +1123,18 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 	if (!tdev && tunnel->parms.link)
 		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
 
+	t_hlen = tunnel->hlen + sizeof(struct iphdr);
+
 	if (tdev && !netif_is_l3_master(tdev)) {
-		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 		int mtu;
 
 		mtu = tdev->mtu - t_hlen;
 		if (mtu < IPV6_MIN_MTU)
 			mtu = IPV6_MIN_MTU;
 		WRITE_ONCE(dev->mtu, mtu);
+		hlen = tdev->hard_header_len + tdev->needed_headroom;
 	}
+	dev->needed_headroom = hlen + t_hlen;
 }
 
 static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
---8<---

Thanks,
Kuniyuki


> 
> Note, this is targeting for -net and -table, so I'd keep the fix
> small. We can refactor and reuse ip_tunnel_bind_dev() for -net-next.
> 
>  net/ipv6/sit.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 70d81bba5093..3ffb6a5b1f82 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1095,12 +1095,13 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
>  
>  static void ipip6_tunnel_bind_dev(struct net_device *dev)
>  {
> +	struct ip_tunnel *tunnel = netdev_priv(dev);
> +	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
>  	struct net_device *tdev = NULL;
> -	struct ip_tunnel *tunnel;
> +	int hlen = LL_MAX_HEADER;
>  	const struct iphdr *iph;
>  	struct flowi4 fl4;
>  
> -	tunnel = netdev_priv(dev);
>  	iph = &tunnel->parms.iph;
>  
>  	if (iph->daddr) {
> @@ -1123,14 +1124,15 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
>  		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
>  
>  	if (tdev && !netif_is_l3_master(tdev)) {
> -		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
>  		int mtu;
>  
>  		mtu = tdev->mtu - t_hlen;
>  		if (mtu < IPV6_MIN_MTU)
>  			mtu = IPV6_MIN_MTU;
>  		WRITE_ONCE(dev->mtu, mtu);
> +		hlen = tdev->hard_header_len + tdev->needed_headroom;
>  	}
> +	dev->needed_headroom = t_hlen + hlen;
>  }
>  
>  static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
> -- 
> 2.34.1
