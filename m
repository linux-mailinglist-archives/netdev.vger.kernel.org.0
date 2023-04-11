Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9D6DD988
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjDKLja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjDKLj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:39:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A343A90;
        Tue, 11 Apr 2023 04:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681213168; x=1712749168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r0qqKJ4nkKA5foVlIR6UdPxdVJCmJH48u1jn3damEbI=;
  b=uZYuTWCIEWnEC0sOGBQ8RZ+N0eFdgVENhtdxUWxpsmPWXmahzx0MAJWL
   qLXyQTGU0+mvw42N8MzE9/W1Z2qgcAxriiyXGeyoSicDLoTBszKgKHjw/
   JVo6R1ZuHSxVxENp599IhuLKmOTEK7E4slh0JSpA/pZWWcoKG2l7FkMOe
   Qa+gemf4x/f9eZPGk8nYlrymSKFM6ILHKMgdE8p+ozAf71n7QLn9/Dgws
   1Wz8oX9UfLj9XMcyyjRfanPo7m8UAUbQ1c/FStW5jOpUX8WLBPgpybjx8
   BN5myXbvd5OTfmyDHh8jvfuQjwjKcjYr8OzTy0OYzZJLlGpvuzlvJA5UI
   A==;
X-IronPort-AV: E=Sophos;i="5.98,336,1673938800"; 
   d="scan'208";a="205927076"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2023 04:39:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 11 Apr 2023 04:39:25 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 11 Apr 2023 04:39:25 -0700
Date:   Tue, 11 Apr 2023 13:39:24 +0200
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
Subject: Re: [PATCH nf-next v2 1/4] ipvs: Update width of source for
 ip_vs_sync_conn_options
Message-ID: <20230411113924.6vhibpekifbyjksg@soft-dev3-1>
References: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
 <20230409-ipvs-cleanup-v2-1-204cd17da708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230409-ipvs-cleanup-v2-1-204cd17da708@kernel.org>
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
> In ip_vs_sync_conn_v0() copy is made to struct ip_vs_sync_conn_options.
> That structure looks like this:
> 
> struct ip_vs_sync_conn_options {
>         struct ip_vs_seq        in_seq;
>         struct ip_vs_seq        out_seq;
> };
> 
> The source of the copy is the in_seq field of struct ip_vs_conn.  Whose
> type is struct ip_vs_seq. Thus we can see that the source - is not as
> wide as the amount of data copied, which is the width of struct
> ip_vs_sync_conn_option.
> 
> The copy is safe because the next field in is another struct ip_vs_seq.
> Make use of struct_group() to annotate this.
> 
> Flagged by gcc-13 as:
> 
>  In file included from ./include/linux/string.h:254,
>                   from ./include/linux/bitmap.h:11,
>                   from ./include/linux/cpumask.h:12,
>                   from ./arch/x86/include/asm/paravirt.h:17,
>                   from ./arch/x86/include/asm/cpuid.h:62,
>                   from ./arch/x86/include/asm/processor.h:19,
>                   from ./arch/x86/include/asm/timex.h:5,
>                   from ./include/linux/timex.h:67,
>                   from ./include/linux/time32.h:13,
>                   from ./include/linux/time.h:60,
>                   from ./include/linux/stat.h:19,
>                   from ./include/linux/module.h:13,
>                   from net/netfilter/ipvs/ip_vs_sync.c:38:
>  In function 'fortify_memcpy_chk',
>      inlined from 'ip_vs_sync_conn_v0' at net/netfilter/ipvs/ip_vs_sync.c:606:3:
>  ./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
>    529 |                         __read_overflow2_field(q_size_field, size);
>        |
> 
> Compile tested only.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
> v2
> * Correct spelling of 'conn' in subject
> ---
>  include/net/ip_vs.h             | 6 ++++--
>  net/netfilter/ipvs/ip_vs_sync.c | 2 +-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 6d71a5ff52df..e20f1f92066d 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -630,8 +630,10 @@ struct ip_vs_conn {
>          */
>         struct ip_vs_app        *app;           /* bound ip_vs_app object */
>         void                    *app_data;      /* Application private data */
> -       struct ip_vs_seq        in_seq;         /* incoming seq. struct */
> -       struct ip_vs_seq        out_seq;        /* outgoing seq. struct */
> +       struct_group(sync_conn_opt,
> +               struct ip_vs_seq  in_seq;       /* incoming seq. struct */
> +               struct ip_vs_seq  out_seq;      /* outgoing seq. struct */
> +       );
> 
>         const struct ip_vs_pe   *pe;
>         char                    *pe_data;
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 4963fec815da..d4fe7bb4f853 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -603,7 +603,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
>         if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
>                 struct ip_vs_sync_conn_options *opt =
>                         (struct ip_vs_sync_conn_options *)&s[1];
> -               memcpy(opt, &cp->in_seq, sizeof(*opt));
> +               memcpy(opt, &cp->sync_conn_opt, sizeof(*opt));
>         }
> 
>         m->nr_conns++;
> 
> --
> 2.30.2
> 

-- 
/Horatiu
