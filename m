Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E0E57E8B6
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiGVVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVVKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:10:11 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86565115C
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 14:10:09 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j22so10593777ejs.2
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 14:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C9kAKBr0M6kI73XVSIvwsHYKjO3S+2hBFzJARdNfeqA=;
        b=R0WCcp5TCQ5Ph8BL2j7d7B1kLjuBrkS+2jDqu/D+xiSTwdM8EqWmUEsgA24X82dLpc
         JdV0de7BOgrO0GA81evbaOlpMJoePnUZ6NjXFtzAfVcJyb7X6zhLNnB/mCeOLVmFza56
         ldtek+1ZW2ozxgpmtk0a8GpRPydrlmrGm6068/smLGBAFz1g1vp8fUMJIEOn2VM+9YMc
         Hw6z9M67Qtm/xgsyWqYfprEHnJtaakJdxUex3PRhjAbYuzgb39i0Mt8kG0/4zx1yNSuZ
         J2ewm0diup4xFkMLw1Bvzu10i//vaetBXbqktjEUIx3JsxnwCXVAq3eEQ66/BPVxJIkg
         HBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C9kAKBr0M6kI73XVSIvwsHYKjO3S+2hBFzJARdNfeqA=;
        b=3XPwnreho7YDMuy2EfMvAOjsAl2DitxI9ZBKks+TsFxyoFfyfK3a4DyC+G8G8Paljg
         CDFTtiB9L7Gg8dpJlKVuGoUP6GFOS4u0G0z4zQtdJCuWpiO211H8FzoLeoJBcaE/cj5H
         blTmKR6d1DFvQ8wuamYEoMSljv7ky6KEx85tPn5ofsOxuvdWg8ppBrHhKAkhSBv2Abf8
         UYdhc9I73kAxzSPOPUGDpCLIS+xBHN3zizHJrPJ3Q0oeIC0V+46O3MOno2IB/Ab3a6R9
         V/07HG9r2sIKIoM1SPbR5PhhHPPYBjMT2ZmAxRzDouC3nKNcxxyAtPIK746/SSp7qSNS
         PsVg==
X-Gm-Message-State: AJIora/18NSPvnFJP6kmtvWkneAokBfHeYgbxUnG+It8NiC6d6W1Kyrl
        f8HEyi0Hi2xE7iYe07b2HGM=
X-Google-Smtp-Source: AGRyM1ti7qaTJvVXC0/iNE6mqrI8v9U2pw2ooBOm+f0pxEz5qMhPZzp9iDuTgOGDq59WP8i9r4Sn/A==
X-Received: by 2002:a17:907:734a:b0:72b:7c72:e6b3 with SMTP id dq10-20020a170907734a00b0072b7c72e6b3mr1332610ejc.608.1658524207950;
        Fri, 22 Jul 2022 14:10:07 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906308400b0072f9dc2c246sm1984736ejv.133.2022.07.22.14.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 14:10:07 -0700 (PDT)
Date:   Sat, 23 Jul 2022 00:10:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 net-next 08/19] ipmr: do not acquire mrt_lock while
 calling ip_mr_forward()
Message-ID: <20220722211005.p2pfvy4qwdvolxi3@skbuf>
References: <20220623043449.1217288-1-edumazet@google.com>
 <20220623043449.1217288-9-edumazet@google.com>
 <20220722193432.zdcnnxyigq2yozok@skbuf>
 <CANn89iK+UO=FevJxnHN0ua17jwR__MfB_RZ_DavLdJz79eyCBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK+UO=FevJxnHN0ua17jwR__MfB_RZ_DavLdJz79eyCBw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 10:37:24PM +0200, Eric Dumazet wrote:
> Thanks for the report.
> 
> I guess there are multiple ways to solve this issue, one being:
> 
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 73651d17e51f31c8755da6ac3c1c2763a99b1117..1c288a7b60132365c072874d1f811b70679a2bcb
> 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1004,7 +1004,9 @@ static void ipmr_cache_resolve(struct net *net,
> struct mr_table *mrt,
> 
>                         rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
>                 } else {
> +                       rcu_read_lock();
>                         ip_mr_forward(net, mrt, skb->dev, skb, c, 0);
> +                       rcu_read_unlock();
>                 }
>         }
>  }
> @@ -1933,7 +1935,7 @@ static int ipmr_find_vif(const struct mr_table
> *mrt, struct net_device *dev)
>  }
> 
>  /* "local" means that we should preserve one skb (for local delivery) */
> -/* Called uner rcu_read_lock() */
> +/* Called under rcu_read_lock() */
>  static void ip_mr_forward(struct net *net, struct mr_table *mrt,
>                           struct net_device *dev, struct sk_buff *skb,
>                           struct mfc_cache *c, int local)

It sure makes lockdep stop complaining...

I just noticed that we appear to have the same problem with the
equivalent call path for ipv6: ip6mr_mfc_add -> ip6mr_cache_resolve ->
ip6_mr_forward, although I don't have smcroute or the kernel configured
for any IPv6 multicast routes right now, so I can't say for sure.
