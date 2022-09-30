Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27EF5F0D24
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiI3OLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiI3OL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:11:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4CD74DCB
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664547055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZIrmRlHt6CUtM4OHrYqApHlFAK6CsAbUsM0EgTkkUx4=;
        b=RtpRgHj+GEVnIGQwW7kSgPpcI8QCBNzAiItEJfFHfMpZxhzsvGEO8ReAsm7IbO24YdUK3L
        6VgdAJ42dLew3bvQUBW1zTkpi7wKLC24ovEAQJBPriTFDD+0Ojj40AWJhxyIUUUX3rhU9T
        EPcXl0e6PDOj8PoDsAUbHJNwAOi1uYk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-425-3f6p7tI-O7ySxfXTLYXdTQ-1; Fri, 30 Sep 2022 10:10:53 -0400
X-MC-Unique: 3f6p7tI-O7ySxfXTLYXdTQ-1
Received: by mail-wr1-f69.google.com with SMTP id s5-20020adf9785000000b0022e1af0e7e8so49271wrb.11
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZIrmRlHt6CUtM4OHrYqApHlFAK6CsAbUsM0EgTkkUx4=;
        b=mxXo2oN425fgs/lE2Dlx5JHn8HZK5eMaZzyQpuWIJr2ZQxEnWIWhPtXyIpMJGS/8qx
         oU9rQ78ltfJ+BY/BbEzqHlCGWlhu3xfRoYTzCHrxgvwtszeX87NiUQhtyF5yJ5CgXngg
         ktcEmwI+j9VspaoGUkYMqSLwXHC+p0QyzWVPYFhmDAq1oUDnSRsVfMhdUa118piFerP4
         l68bO4YChIrvgDldXLNxtAHBl9WYUUELcBQMRay5n6cG1X4asOgLYf7WdVon20RzLZeu
         rv+vFMnUXT+Ia/a0XyIpeFNzu6VGI4PxMxXdvyeHkIl2ivqF4UuZQEEDvdshT7umM/0d
         4VDw==
X-Gm-Message-State: ACrzQf1R9uTG7ExyVjAniF3aXFqOVcnC1FbYDeUY92mUxyjuT7qSjVRt
        TpbtmS4ph0urUQH+Va02FyUrRuPSUWPs9dCBCXf/DzMFGz+D5FFvTGYrLDUaOBDis0R5GyIgKpV
        OKx59Ut0K/3J32Blm
X-Received: by 2002:a05:600c:2c47:b0:3b4:fcdf:d783 with SMTP id r7-20020a05600c2c4700b003b4fcdfd783mr5948859wmg.157.1664547052178;
        Fri, 30 Sep 2022 07:10:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4JNxaVGxuvhLvu/AUBRD87vCu82rFFte6PnWHKFwh5YRTGDuxFe9rTAJmxoGcAI9utytfY5A==
X-Received: by 2002:a05:600c:2c47:b0:3b4:fcdf:d783 with SMTP id r7-20020a05600c2c4700b003b4fcdfd783mr5948851wmg.157.1664547051977;
        Fri, 30 Sep 2022 07:10:51 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id e14-20020adfdbce000000b0022b014fb0b7sm2001739wrj.110.2022.09.30.07.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:10:51 -0700 (PDT)
Date:   Fri, 30 Sep 2022 16:10:48 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220930141048.GA10057@localhost.localdomain>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928113908.4525-2-fw@strlen.de>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 8970d0b4faeb..1d7e520d9966 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
>  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> +	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
> +		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
> +		fl6->flowi6_oif = dev->ifindex;
>  	}

I'm not very familiar with nft code, but it seems dev can be NULL here,
so netif_is_l3_master() can dereference a NULL pointer.

Shouldn't we test dev in the 'else if' condition?

