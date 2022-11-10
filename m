Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2956B624E8E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKJXqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKJXqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:46:17 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD705E9FA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:46:15 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id k84so20370ybk.3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xfLacnantKXRxjNVVHTSBZWsiyUm2oVOFkyo5Ye8vho=;
        b=I9KGe+mgJc+j1KDvmhurUILU8ru31t8U4b7ZhofT6dWsLWSSQ1K/wnxo+ABaWgqM21
         2xL6AQNz1xJnkpacC6f0NdwkQPb9I8NH00rxgAkM6oR92W0Kbh5z69CTFeBFr5dzcEXI
         flhkvmTguhIIVC/gZ+o/vk/1AX3nLFyUt7bRY3m8Jfu9AkkbGqnCfBocqXw8pGJJu3Ip
         FV5NjcouhyqwRzq+K+oW6QxwAAQbxf+PchKV9y89u5tovEfWM2k2TpOYlkaPM1EZOoO2
         JGrZspJM3gWBsVMrNBeC4rHpZD1+ob25F35zg6uPn7q+c0Bdh6XZWmaVKy+BI8jgN5pO
         vElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xfLacnantKXRxjNVVHTSBZWsiyUm2oVOFkyo5Ye8vho=;
        b=b1GIULdO/tLe/V4/ZvnRpYAByogBL0Kikrr2V6z2ZxdqE6tVMQixndJTYc8n7KDF75
         EeAPgWSTLRx2QXMP7uEwGUa483+16mmXhhLf+qu3+eUvhyoJ04/fFY0zocnD5KLPB0eM
         8sO4CtOLAVXFMzcThEaTpymwnPu6usPavCqGQHAuuEd9ccWgb/zkpmAWbXzLkEZA0hBN
         4MbkjKV55w5lNCnj4HV8BOFsBzwAX5mPenA72Gw9GKaklxFlgiBptfub86iJYmUm/xgz
         XLAbeWJNHEiSomPeVraSBYn4DaGT0Rsqq5u6I43QUepwDtAoANShjSQ3wuhPbklu2TcC
         m/mg==
X-Gm-Message-State: ACrzQf2mdz4sFJLMuKu45JwB0bI4l77SQ+bRj8g7KSa2MfICr1S72g61
        mc7O0oEaYLSL/8PmEgCZTVm18DNvOu/9EesdRpehHA==
X-Google-Smtp-Source: AMsMyM6rASrflTYpQi/4v3g0wyNjaDr6ndTy7sEYphieigRagF1X4wJoDjDn0moVGK3plc+txm1UaG1Mu7ITML+np30=
X-Received: by 2002:a25:3ac7:0:b0:6ca:b03:7111 with SMTP id
 h190-20020a253ac7000000b006ca0b037111mr1362050yba.598.1668123974256; Thu, 10
 Nov 2022 15:46:14 -0800 (PST)
MIME-Version: 1.0
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
 <20221110153901.7daa86e1@hermes.local>
In-Reply-To: <20221110153901.7daa86e1@hermes.local>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Nov 2022 15:46:02 -0800
Message-ID: <CANn89i+HgJu_mRptWY85aVBS_gTEaeM+0HPpmw1qcx7vme8YSw@mail.gmail.com>
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 3:39 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 10 Nov 2022 21:21:06 +1100
> Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
>
> > +         xchg(&queue->synflood_warned, 1) == 0) {
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +             if (sk->sk_family == AF_INET6) {
> > +                     net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI6c. %s.  Check SNMP counters.\n",
> > +                                     proto, sk->sk_num,
> > +                                     &sk->sk_v6_rcv_saddr, msg);
> > +             } else
> > +#endif
> > +             {
> > +                     net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI4. %s.  Check SNMP counters.\n",
> > +                                     proto, sk->sk_num, &sk->sk_rcv_saddr, msg);
> > +             }
> > +     }
> >
>
> Port number is unsigned not signed.
> Message also seems overly wordy to me.

Also, it is customary to use  IP.port format (like most tools, see tcpdump)
