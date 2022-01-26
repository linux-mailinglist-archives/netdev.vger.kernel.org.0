Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C6849C168
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbiAZCoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiAZCoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:44:17 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8DBC06161C;
        Tue, 25 Jan 2022 18:44:17 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id c24so64549535edy.4;
        Tue, 25 Jan 2022 18:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r0iTquYFV9rwBlxdSQXJviQUxso6ysedSFsXGDHFJvs=;
        b=IjBQbRzrwBKcyOQ2QUWEkWLGSxj4/B536NUW96m+/1CCGmVoCCEUmb01JN9OyppJv6
         cMJp2k4c5Cb08R9/ZsB5IbyZU7liApR3H6CQP3Mu/cMXAs8n2hp+t8vEOQFzeZKQzXWh
         coiGyp2y7p05iVeFtP7ilORZ2in5bfvdKQRof8t3lLVHDZJSV1mHrsCyiQux59Gd1vnb
         lw59+MwlIsteVw0X3RA/0Ceh0l4tkr5uGqoMyiwwTptTIXnw9L7lFiYKvRLHicbcbm0t
         QBN6lpZ5tuzy2BZbrsFiXqr9n8unK1O4m/qKd/sNLTNZstTr8N2ed2YvUimaGtwCEIF8
         mtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r0iTquYFV9rwBlxdSQXJviQUxso6ysedSFsXGDHFJvs=;
        b=2ius4irxmk7VhJK+iG98nVmygzHwimCx9qrBgmCE5yXmbTt+FWbGsWbX5XpJ8p96PC
         sSLw/YZsLbqg/E9l2w1DJgOs1Q6+fHMtuocbrZQB2xO1L69ge+JZ6lA4ED4Z8jkasY7P
         2AY+mWdRAuYCAt5VItgyBcdirLe/xFszR8o168tGigkfPsogBOlulUWQm9hqmS8olTuq
         qJ8eWN7N3k4gKkv2IoLDySQdlSnyotvCfxfFU463DEoKY8qTGvbVkdOtSN3oofVbJk8K
         naqxiA/4CDBixwspVGTKAVPMlCiyLBjFZ/gxhsd9sBGPmkMCE5yYh3lACKTSI7ZB7Gey
         XLmA==
X-Gm-Message-State: AOAM532SyRF0zT5N9nrqpwUQkX9NudaCpoMWEgss5WToE3LAohEyu0vX
        DQz8+9mKdX8OZYhyyNocuTUFyJm0XBoIy0L6p/s=
X-Google-Smtp-Source: ABdhPJyeUQg9qHceUEM62FLYrRYyWgPPQESEMxo5vMqRkqhYcRUKFMmJtLCppOnLO/SPQrHB7BYw3Sw3DpnY++HTqxs=
X-Received: by 2002:a05:6402:b33:: with SMTP id bo19mr22846326edb.70.1643165055733;
 Tue, 25 Jan 2022 18:44:15 -0800 (PST)
MIME-Version: 1.0
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-5-imagedong@tencent.com> <f493e1e7-0fa0-45f6-4bd6-790492055797@gmail.com>
In-Reply-To: <f493e1e7-0fa0-45f6-4bd6-790492055797@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 Jan 2022 10:39:47 +0800
Message-ID: <CADxym3ag-fUL9KJNBd7GVHg=kiA5ZHxP6Mi+wEEQ2e_zOKp9UQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
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

On Wed, Jan 26, 2022 at 10:21 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 8942d32c0657..603f77ef2170 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -328,6 +328,8 @@ enum skb_drop_reason {
>
> It would be worthwhile to document the meaning of these as you add them
> -- long description of the enum.

Yeah, I realize it later. I'll complete these documents.

>
> >       SKB_DROP_REASON_IP_RPFILTER,
> >       SKB_DROP_REASON_EARLY_DEMUX,
> >       SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
>
>         /* xfrm policy check failed */
> > +     SKB_DROP_REASON_XFRM_POLICY,
>
>         /* no support for IP protocol */
> > +     SKB_DROP_REASON_IP_NOPROTO,
> >       SKB_DROP_REASON_MAX,
> >  };
> >
>
>
> If the enum is 1:1 with an SNMP counter, just state that.
