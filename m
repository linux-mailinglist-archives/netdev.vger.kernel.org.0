Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A577136988B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhDWRje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhDWRjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:39:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DB3C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 10:38:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p16so21612986plf.12
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 10:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5KC9dBT3Y+K2BB/kDTuRM45iOu12g2XNZQIMZ9T1Ew=;
        b=m9Um1m76vxaMV55lQz1PjgjUXrUzJOex9LjfOGjWAHWvEiRr0ZxkczFkwTcMt+r1Av
         Cb+irP23f7V1bUzLR82e/ejYoY5rYxY0QULmvtL7n+4Q0LzqiyCMaV9ZvZHn0Hi6wB6X
         i7O+ocTpK6Ny0oSdAc9Li5yOeyOT+kStuBvx5/shGE/iSX4izKKeyiL9475c6avGq/68
         2QESDCF5u3Tj6QyN0ntSc+OKLayEALOqMqqZdLu+dm2xzNIcALO6xrOc4FmwMu80nlZd
         M+n9Am1Tp/c9+Hp7sXPd7DLnZ3bu4hKul57tKTc13l8yCd3gyUHXt6v8F1ifXIBFNGio
         LUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5KC9dBT3Y+K2BB/kDTuRM45iOu12g2XNZQIMZ9T1Ew=;
        b=fm4x85gK5IdGdguT6bT0E32TRq4SgLYkel5rEB3U8QOJfIIATvqdrRw8hsfHRShBcj
         Opx3OiLE5QxluC5a2uoGvjhz0dzpvon+vDsjo2Nsa1BB3BRuA9dHAyWDPNddk0H2BrZd
         GRJWsDW3yRRAqFQQ+ptoxQC8/i1qIRCgOADD1VsDiYGKerQArcQQbrIFniiBSSea++QH
         digIYnoVddvhHn7CGT2nyaDraYJbmgzOEIgcAhbhdufLaDLkBdSL7rLJY4kfapNvuQ7o
         hKNX+xrHteoro7S5j7JRo2V7ZGMaeY0109t/3aXKQICv5z0TH0n66GgO8TAhv46SeKT4
         wtVA==
X-Gm-Message-State: AOAM530bZ61KV+iWDmwxza4LiKX4OrU/jMuIUx9ptdx5TBokRwQiWDJk
        kBH6LZrPEmO5fDxGOaSAsJDQGORKZhEBBSNhK4RlnGLULofBgA==
X-Google-Smtp-Source: ABdhPJxfB4VgdZCn/wtru2NOCUtj/+eb9ZZnOP8sxZCwEnKu1iKJNkQs1UaHmzKCsbJJqkMeBASCipw/jW463Olz/K4=
X-Received: by 2002:a17:903:18e:b029:ec:7e58:fbe1 with SMTP id
 z14-20020a170903018eb02900ec7e58fbe1mr5014968plg.70.1619199536078; Fri, 23
 Apr 2021 10:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210421192430.3036-1-sishuai@purdue.edu>
In-Reply-To: <20210421192430.3036-1-sishuai@purdue.edu>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 23 Apr 2021 10:38:45 -0700
Message-ID: <CAM_iQpUV-rmGdn1g7jn==53wLQ0MvM_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>
Subject: Re: [PATCH v3] net: fix a concurrency bug in l2tp_tunnel_register()
To:     Sishuai Gong <sishuai@purdue.edu>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tparkin@katalix.com,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 12:25 PM Sishuai Gong <sishuai@purdue.edu> wrote:
>
> l2tp_tunnel_register() registers a tunnel without fully
> initializing its attribute. This can allow another kernel thread
> running l2tp_xmit_core() to access the uninitialized data and
> then cause a kernel NULL pointer dereference error, as shown below.
>
> Thread 1    Thread 2
> //l2tp_tunnel_register()
> list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>             //pppol2tp_connect()
>             tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
>             // Fetch the new tunnel
>             ...
>             //l2tp_xmit_core()
>             struct sock *sk = tunnel->sock;
>             ...
>             bh_lock_sock(sk);
>             //Null pointer error happens
> tunnel->sock = sk;
>
> Fix this bug by initializing tunnel->sock before adding the
> tunnel into l2tp_tunnel_list.
>
> Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
> Reported-by: Sishuai Gong <sishuai@purdue.edu>

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
