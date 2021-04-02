Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015A2352AD9
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhDBMxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbhDBMxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:53:42 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016D8C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 05:53:40 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 8so4994361ybc.13
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 05:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9469ZYNpdGZ4d4goAIgkRn6//bZ4GZU80wco2rQYYPI=;
        b=V/OWO5wUYp0ObOMz3l5gzKa2I+n/kpm+Il0wome4pEpMJe9USrqaG7gKQKrBXz0zzp
         1YiSp7VvD3l0XnkDfCwqDaGV4jy/s9EvXwehPYDgz0M/1xcle9sRhJowjdIDsJCsUNZ3
         2UL4Pf+WZR0CfsnJrsHfH2jCVVY26X19Eiz9+E69HEnSPK3uqqfVAXaXteT0JdJlt2Nr
         xzY6EF6vOQEccUjbTV0bzmwNSs07pxQ2A9Ts7l/OXdE/JKoJtcWZJb5EMsUCBBxaL1xl
         V8g9mY/pTM6S8M+vfN2U84vvS9XAIL4gVePfId/dT+AciWVv5zHwQBKnQOtC1GQHCVt3
         hxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9469ZYNpdGZ4d4goAIgkRn6//bZ4GZU80wco2rQYYPI=;
        b=TtOEX3Ofq8kykqS0/GHVQZ5sEg8gWW2MhoSfZxEe8j/wWCDFta/DSfHyStt7YAZ5p2
         EF8x0KuuFNay3Yt5P6qeJDeyrCioa29jDxO+mfm/MHGWa7eClwywV0zdg7FewWPrVLaS
         V+iyXzMlCBDAH/d376Cmc+z2xip49/VFU7kPnOO7c5oLm9ewaWY/JT3pKYRdqM/M8ax5
         4T3VS67HO/2VmP02hR2iPH0/dJwnFchonUn4B3bs89jBpcTLGntnjuxyb5rbVlO5C3cb
         mrwcSeitOZzSE5A5zq7/ITnQmyGamc1/Sk4eyoskxMDILYb9yWRDqvlE6FLQEkWhbav+
         /ZZQ==
X-Gm-Message-State: AOAM530q+fXLV6uS0xAYwqUZypdbUyQCSdK84Gm8CVVRh+NP22iC1Wn0
        4R62zUh4Eaid7KTyDoz7XvjcOSZtgul1AOA9izW3TA==
X-Google-Smtp-Source: ABdhPJxlDQfPe4LCqau/qOhgyqthfiQc2Tfcf/2DSyQIoT7hSfeRamFQO3I3HscagLzUVbhOAiXtC/5gqYtDiX6IXw4=
X-Received: by 2002:a05:6902:4d2:: with SMTP id v18mr4473811ybs.303.1617368018972;
 Fri, 02 Apr 2021 05:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <4a29cb99-749d-e697-34a6-db50361cedff@redhat.com> <1617361253.1788838-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1617361253.1788838-2-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Apr 2021 14:53:27 +0200
Message-ID: <CANn89i+c6k+dXwz49w7hRmuCx_4stoab5E_WmtofjNY0DRvG7g@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 1:08 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Fri, 2 Apr 2021 10:52:12 +0800, Jason Wang <jasowang@redhat.com> wrote:
> >
> > So I wonder something like the following like this help. We know the
> > frag size, that means, if we know there's sufficient tailroom we can use
> > build_skb() without reserving dedicated room for skb_shared_info.
> >
> > Thanks
> >
> >
>
> Do you mean so?
>
> I have also considered this scenario, although build_skb is not always used, but
> it is also very good for the right situation.
>
> Thanks.
>

I prefer doing such experiments for net-next kernels.

Lets keep a simple patch for stable kernels.
