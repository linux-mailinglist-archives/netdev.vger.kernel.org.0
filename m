Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4725A6DD978
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDKLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKLfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:35:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925B4E60;
        Tue, 11 Apr 2023 04:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681212901; x=1712748901;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rCpRx8zrwmywWfUW2YxiAvJ2J1O/eklkQmlDcOmjNXM=;
  b=fhAKYZ41cHJHfbwdsQOuVm7zIQzmM1Y7NfILam97srLnMnG72a/IPMyU
   MUOpFIDgdIKKA8C5LdKLc5Ioz366hcEP0y4fCWCEnEd19VKwVPUQf3dtq
   1Gs933GhUxvw0vargbJM0E8xIeReVkfw3XkqxW/XcSVNBa2F9e7l28xUf
   GlZxFmxv+JRIe4jKjtMkA9jGPAnZ2dFnxvFDb9H0xfbEWMSXFfHsmgEv/
   UtKsHU/VGNa8BGi7UCVfTzbYWuLT04FtyBfAACya6KPbcwOfABlqSuJhN
   PDRTI78UeJKJIpwDGfGIIEGz/qGu4OLEZ0pZKFK+06yAEP5iZHZ9ysP8q
   w==;
X-IronPort-AV: E=Sophos;i="5.98,336,1673938800"; 
   d="scan'208";a="209023260"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2023 04:34:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 11 Apr 2023 04:34:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 11 Apr 2023 04:34:50 -0700
Date:   Tue, 11 Apr 2023 13:34:50 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Simon Horman <horms@kernel.org>
CC:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <lvs-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/4] ipvs: Consistently use array_size() in
 ip_vs_conn_init()
Message-ID: <20230411113450.ky4jp6jsptvlzrtx@soft-dev3-1>
References: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
 <20230409-ipvs-cleanup-v2-2-204cd17da708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230409-ipvs-cleanup-v2-2-204cd17da708@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/11/2023 09:10, Simon Horman wrote:
> 
> Consistently use array_size() to calculate the size of ip_vs_conn_tab
> in bytes.
> 
> Flagged by Coccinelle:
>  WARNING: array_size is already used (line 1498) to compute the same size
> 
> No functional change intended.
> Compile tested only.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
> v2
> * Retain division by 1024, which was lost in v1
> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 13534e02346c..84d273a84dc8 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1481,6 +1481,7 @@ void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
> 
>  int __init ip_vs_conn_init(void)
>  {
> +       size_t tab_array_size;
>         int idx;
> 
>         /* Compute size and mask */
> @@ -1494,8 +1495,9 @@ int __init ip_vs_conn_init(void)
>         /*
>          * Allocate the connection hash table and initialize its list heads
>          */
> -       ip_vs_conn_tab = vmalloc(array_size(ip_vs_conn_tab_size,
> -                                           sizeof(*ip_vs_conn_tab)));
> +       tab_array_size = array_size(ip_vs_conn_tab_size,
> +                                   sizeof(*ip_vs_conn_tab));
> +       ip_vs_conn_tab = vmalloc(tab_array_size);
>         if (!ip_vs_conn_tab)
>                 return -ENOMEM;
> 
> @@ -1508,10 +1510,8 @@ int __init ip_vs_conn_init(void)
>                 return -ENOMEM;
>         }
> 
> -       pr_info("Connection hash table configured "
> -               "(size=%d, memory=%ldKbytes)\n",
> -               ip_vs_conn_tab_size,
> -               (long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
> +       pr_info("Connection hash table configured (size=%d, memory=%zdKbytes)\n",
> +               ip_vs_conn_tab_size / 1024, tab_array_size);
>         IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
>                   sizeof(struct ip_vs_conn));
> 
> 
> --
> 2.30.2
> 

-- 
/Horatiu
