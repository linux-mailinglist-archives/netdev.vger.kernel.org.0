Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2290049C171
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbiAZCsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiAZCsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:48:12 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C210C06161C;
        Tue, 25 Jan 2022 18:48:12 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id c24so64561746edy.4;
        Tue, 25 Jan 2022 18:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jMQbxA1zAXJvdF6Vkunl7me5oxpLLXhPxK0QysU74y4=;
        b=C7SAjoifpI9UVWdAdd/fIp3n+iMbRLlMgQq39cANxl3YXlfWjIJYvtRY4i0b5ipJTB
         MJI9CAESZKmtZ+lQW+QnhHsyGk/aN9dBMhuAJIySKyQvpIojF1etZSOm2o+ybVWwt9mK
         MDmmXZHQc5w3yCEDOJG2rbDVeBkSbAKoAnVWtsxPRdHrAZQQdpIKY5mUjk1LsnL0U5lF
         JVcvD/yYZyBG6olTTx02RSBDYHr3KiOSCpMcc9j8QqwmLPqmuIV5GxQqKTFWr1MCORyR
         aDqjwwREJDRN11bCEJ1wYnP4kBhAeWNNYwrtrUSiv5KX5CxmFxM2AYyBpE602IkLQJvS
         ra2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jMQbxA1zAXJvdF6Vkunl7me5oxpLLXhPxK0QysU74y4=;
        b=TVd/jEKqeR8A+94jgdQB+bi/loRFxaaUHxF91HO3H/CrDmfOdqh0C7CjHSdr5hZ3q6
         Ofd6i6iLWF7zI4uVhoFWzL5qOlM1PDYcCl+phFsVOSSIbm/KMJC5TtX0j5S1V+lF2CkK
         s0VsYFhtrTua5Z4BWHooMBT2pbRBV19WLAZnoQVNzyFfoZa7QwZKUn1hoEZ0P5NrNBBQ
         4Bz9T4A45w9pQRsChzmm4NlITxGKBDGMY/iHlAUXmoAEY9ECThzirlnGz65/ShlCcuLa
         hKgC3WYtrIt683m4KVLtp9RojzGoEK0YtD5D3mtivNa0c2xnVYiUabrY5H+abDknSQT/
         dEbA==
X-Gm-Message-State: AOAM532Mlgodty59FFd507NxCRjMJ0CI9HN8kaa9CxUdNpqsj2CYL6bA
        YEXFAr/64pHL/6VbpYX4zMyP49j2mf18jHI4CcvCFiZiLyk=
X-Google-Smtp-Source: ABdhPJzM8JQCTEcGpXMUH8SJRvI9dI9eiIn72u9KNT2EFnU2BGV69ZiMxrcwvaA4t5AEttD0E38rfcvZ4K/V7AIPOh8=
X-Received: by 2002:a05:6402:c8c:: with SMTP id cm12mr22722736edb.78.1643165290523;
 Tue, 25 Jan 2022 18:48:10 -0800 (PST)
MIME-Version: 1.0
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-6-imagedong@tencent.com> <308b88bf-7874-4b04-47f7-51203fef4128@gmail.com>
In-Reply-To: <308b88bf-7874-4b04-47f7-51203fef4128@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 Jan 2022 10:43:42 +0800
Message-ID: <CADxym3aFJcsz=fckaFx9SJh8B7=0Xv-EPz79bbUFW1wG_zNYbw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 10:25 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 603f77ef2170..dd64a4f2ff1d 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -330,6 +330,7 @@ enum skb_drop_reason {
> >       SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
> >       SKB_DROP_REASON_XFRM_POLICY,
> >       SKB_DROP_REASON_IP_NOPROTO,
> > +     SKB_DROP_REASON_UDP_FILTER,
>
> Is there really a need for a UDP and TCP version? why not just:
>
>         /* dropped due to bpf filter on socket */
>         SKB_DROP_REASON_SOCKET_FILTER
>

I realized it, but SKB_DROP_REASON_TCP_FILTER was already
introduced before. Besides, I think maybe
a SKB_DROP_REASON_L4_CSUM is enough for UDP/TCP/ICMP
checksum error?

> >       SKB_DROP_REASON_MAX,
> >  };
> >
>
