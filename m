Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504066ED366
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjDXRTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjDXRTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:19:04 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0654C6187
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682356744; x=1713892744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FzwNieiz7tJOpbcPXWnRfCYmAPQzcEupQEmpSgjJLHU=;
  b=QaTCU7LYjAUNIh8eDsOjkjF51nmodDjiucJ7m6Yvjf104WUl/64QkLlz
   mJqy/cEHKPClJswp7vqZAZw3CxkiTFDmIk3fDufR9k+96MBW3pqf1coZX
   2C0H2/Trb6SI7o8/hRRAiriyrUHsdl1Bn3/ERDUjtpDodCTJWsiRkmn8L
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,223,1677542400"; 
   d="scan'208";a="207730173"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 17:19:01 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id B3D6CC1CE5;
        Mon, 24 Apr 2023 17:18:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 24 Apr 2023 17:18:44 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.42) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 24 Apr 2023 17:18:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <xiyou.wangcong@gmail.com>
CC:     <cong.wang@bytedance.com>, <edumazet@google.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
        <oswalpalash@gmail.com>
Subject: Re: [Patch net] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
Date:   Mon, 24 Apr 2023 10:18:31 -0700
Message-ID: <20230424171831.89283-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230424003414.630339-1-xiyou.wangcong@gmail.com>
References: <20230424003414.630339-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.42]
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
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
Date:   Sun, 23 Apr 2023 17:34:14 -0700
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When a tunnel device is bound with the underlying device, its
> dev->needed_headroom needs to be updated properly. IPv4 tunnels
> already do the same in ip_tunnel_bind_dev().
> 
> Note, this is targeting for -net and -table, so I'd keep the fix
> small. We can refactor and reuse ip_tunnel_bind_dev() for -net-next.
> 
> Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
> Reported-by: Palash Oswal <oswalpalash@gmail.com>
> Link: https://lore.kernel.org/netdev/CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com/

I was about to post almost same patch today :)

Just for record, the repro was doing like this and with encap-remcsum,
encap_hlen included in hlen overflows the headroom.

  # ip link add sit1 type sit encap gue encap-remcsum mode any dev sit0
  # ip link set sit1 up
  # 
  # python3
  >>> from socket import *
  >>> s = socket(AF_INET, SOCK_DGRAM, 0)
  >>> s.setsockopt(SOL_SOCKET, SO_BINDTODEVICE, b'sit1')
  >>> s.sendto(b'hello', ('192.168.0.1', 10000))

So, I think it's worth mentioning b17f709a2401 ("gue: TX support for
using remote checksum offload option").


> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/ipv6/sit.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 70d81bba5093..3a8f04ba4947 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1096,11 +1096,12 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
>  static void ipip6_tunnel_bind_dev(struct net_device *dev)
>  {
>  	struct net_device *tdev = NULL;
> -	struct ip_tunnel *tunnel;
> +	struct ip_tunnel *tunnel = netdev_priv(dev);
>  	const struct iphdr *iph;
>  	struct flowi4 fl4;
> +	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
> +	int hlen = LL_MAX_HEADER;
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
