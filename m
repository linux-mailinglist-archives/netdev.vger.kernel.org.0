Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1F5B27A7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiIHUXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIHUXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:23:33 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50B8A3D45
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:23:31 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id e3-20020a4aaac3000000b004729a45cdf2so206979oon.3
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 13:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ejDQxdZ4Qg5U+Lwtd5v3XArCobKY1X4cdGX+F5+IEYg=;
        b=jKhP/Ykfjcogl0cntL3IZHZafWe4kkcaNAAoHe0fvpVmVx5N9BTq5VDUXackqIxa9X
         jKQ5MZ7rXs/IDfIGIIj9hdY9SXXRjMk9avJupj888NQKwtDEoApnjbGpJhSzwvk9kuIC
         OR4L5D/e51/aj/ul5ZYCcxQSf1NJurMt6JnnBq5kGSiwsJ0TeahAJtUq9oktlA0vK2Rc
         9ac1VrTBcsDD4RYA2M5GslqPiekWgf37oJx34paM7sjXGuNKTHQqyCgkrlsuia+5AbcQ
         LUCYj+cgFOhLM6w8iuXvYXQ6rFi6+2QtjfdYEs+zSaXbj9ASjc0bURVUJsdXhbbnjXdd
         0ixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ejDQxdZ4Qg5U+Lwtd5v3XArCobKY1X4cdGX+F5+IEYg=;
        b=dlziRPnlzsA7Gq3x0rO3r0MRvPweITEtpHh++RjKWHDy8mZ3K24ZRlphRdc9LeAQB8
         6rKP9bfbaao0bXkKwLw+Jc6SU1t+b4SrxzQIhxR1Rc2SWKTX2TquKI7R1zjL1I5qdmND
         VPsbSascOP6OdQQXbfJxg/wCdFftYxq47yR+6fdAqbSnfy38rkXNCApyHVVWSWGHCX+o
         SKAYNpwkF19qcPVtoZFs/6wO6aVEPv83Ljv+DTzzRKQXlV5RKU1ozxUFER8GImm907DG
         +Me61sdeWa7wAdE+Vxs63/px4VpUP2qKldo+jD/1pETFCnLnhcKfdwscWGch/XM4H6OT
         NxCQ==
X-Gm-Message-State: ACgBeo1VggX57MEpm1tAo/5+bMp7jSS8prdUo0UT6EYfNhl7n/cxlyow
        ZWIrFrDeXtfYml2L7IpzSIjJNR9THCpVZV0tsrLSAA==
X-Google-Smtp-Source: AA6agR5IagjO74tDyXGwM67VEwLddpkc8dPouPyHGcwzWBoYBX5/0Nn4OrrCdKdqm1H9X247p/t1NLtV1atfoLbgCQE=
X-Received: by 2002:a4a:e1ad:0:b0:448:b28c:5fe3 with SMTP id
 13-20020a4ae1ad000000b00448b28c5fe3mr3639821ooy.21.1662668610979; Thu, 08 Sep
 2022 13:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220907125048.396126-1-andrew@daynix.com> <20220907125048.396126-2-andrew@daynix.com>
 <f59a8400-54ba-62eb-2e9b-b8a6b7533f90@kernel.org>
In-Reply-To: <f59a8400-54ba-62eb-2e9b-b8a6b7533f90@kernel.org>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Thu, 8 Sep 2022 23:10:14 +0300
Message-ID: <CABcq3pGKN5ovHC77HZJOK6sjpzsOKStmy4sTmaMq2EMkc0CoQg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] udp: allow header check for dodgy GSO_UDP_L4 packets.
To:     David Ahern <dsahern@kernel.org>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, yan@daynix.com,
        yuri.benditovich@daynix.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Thu, Sep 8, 2022 at 3:40 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 9/7/22 6:50 AM, Andrew Melnychenko wrote:
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index 6d1a4bec2614..8e002419b4d5 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -387,7 +387,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >       if (!pskb_may_pull(skb, sizeof(struct udphdr)))
> >               goto out;
> >
> > -     if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> > +     if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST))
>
> that line needs to be wrapped.

Ok, I'll wrap it.

>
> >               return __udp_gso_segment(skb, features, false);
> >
> >       mss = skb_shinfo(skb)->gso_size;
>
