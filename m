Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44F535FC50
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhDNUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhDNUHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:07:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80589C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:07:12 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c2so3321002plz.0
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=In6huv6Y9HCt6IEgW+jAUjzWZLosViGBVtLJdDO7NQI=;
        b=E6UJNk+xklDwv6KHS3uu2PLcPkqMEktiMgU9hERXpQZGeRenngpLUNRG8c4hHPU8FJ
         WpLqS4WmEdS3wN5ooiLqa+sOdlbIrI8a7GYI973aCekWj07JyP4IcU1Z/SIlbZZ+l2Jc
         rBUnyF9mirXP9H4Nj74gHy6egQHP//FFqHRKcl7re7DYjYUbTFBgsKd4IIq9DqnMnF4W
         3MrtdGDUP1Ev2tDEqv92YMxOqgEjWi4+bBhYbqlhad0tcrlprRFqznJYGCGMgeHzdKn7
         3hoL8I0BAs3Ojj08LIWeUPePLyjGTRCSV9ps/dOG+ZaPPsaswAQ12qGYtRSsmS0CTNVb
         KT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=In6huv6Y9HCt6IEgW+jAUjzWZLosViGBVtLJdDO7NQI=;
        b=uGakWDFQidQGICwkVt5eVJ1/DoKhG2Bj2A24N+GBAb6ezgyc2hurnkWbmmLTjwHsVI
         S9HMrnBes4as77FDJI8nfVzvLC4T7XlQhqRQ4U+6F42x/LSxt26aXI4M9omsoYwvkvsR
         uXn4AG5pd4f3j0NGj/I18hYWiHHg+FIjnp05qxIV8Vu4QAsUal16PHLm/d4GRzm3BKSJ
         UbEE+B1H7R/Xm5bY5TO3j2/KP6fjHYTaUO30SGezBeZnMoEH5MlpbvmalkdTJHZuOGPe
         SzF8rT6pDJ3hlRtygtevXPFynlHWkWhpc4x3UWlDY1GJkwc39cFn07EAQyS3Rsj8Aw6I
         JhSg==
X-Gm-Message-State: AOAM531vqUQL9Ab4K8XneSm1gY6bWPLtVTuAg3kkFnMCEtE0TH6qThVm
        vTDssA6+SBNk8tYKPoqogEVD8rn3u5RO1s3TZyk=
X-Google-Smtp-Source: ABdhPJzRXtXeDcKnQ85ali1CLqKtfp/Yu1PFqqAVhVGq/MBPHGN2wad9SsTqMtQy5qbCeLB/c8MSMdQP1QkwmObsGWE=
X-Received: by 2002:a17:902:c407:b029:e7:3568:9604 with SMTP id
 k7-20020a170902c407b02900e735689604mr39227222plk.31.1618430832147; Wed, 14
 Apr 2021 13:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <400E2FE1-A1E7-43EE-9ABA-41C65601C6EB@purdue.edu>
In-Reply-To: <400E2FE1-A1E7-43EE-9ABA-41C65601C6EB@purdue.edu>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Apr 2021 13:07:01 -0700
Message-ID: <CAM_iQpWs+T+ps3N7XD2s3YWrqAbQ0zqO_pmFpiFOG5y84Nku0Q@mail.gmail.com>
Subject: Re: A concurrency bug between l2tp_tunnel_register() and l2tp_xmit_core()
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "jchapman@katalix.com" <jchapman@katalix.com>,
        "tparkin@katalix.com" <tparkin@katalix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 3:10 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
>
> Hi,
>
> We found a concurrency bug in linux 5.12-rc3 and we are able to reproduce=
 it under x86. This bug happens when two l2tp functions l2tp_tunnel_registe=
r() and l2tp_xmit_core() are running in parallel. In general, l2tp_tunnel_r=
egister() registered a tunnel that hasn=E2=80=99t been fully initialized an=
d then l2tp_xmit_core() tries to access an uninitialized attribute. The int=
erleaving is shown below..
>
> ------------------------------------------
> Execution interleaving
>
> Thread 1                                                                 =
                               Thread 2
>
> l2tp_tunnel_register()
>         spin_lock_bh(&pn->l2tp_tunnel_list_lock);
>                 =E2=80=A6
>                 list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>                 // tunnel becomes visible
>         spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
>                                                                          =
                               pppol2tp_connect()
>                                                                          =
                                       =E2=80=A6
>                                                                          =
                                       tunnel =3D l2tp_tunnel_get(sock_net(=
sk), info.tunnel_id);
>                                                                          =
                                       // Successfully get the new tunnel
>                                                                          =
                               =E2=80=A6
>                                                                          =
                               l2tp_xmit_core()
>                                                                          =
                                       struct sock *sk =3D tunnel->sock;
>                                                                          =
                                       // uninitialized, sk=3D0
>                                                                          =
                                       =E2=80=A6
>                                                                          =
                                       bh_lock_sock(sk);
>                                                                          =
                                       // Null-pointer exception happens
>         =E2=80=A6
>         tunnel->sock =3D sk;
>
> ------------------------------------------
> Impact & fix
>
> This bug causes a kernel NULL pointer deference error, as attached below.=
 Currently, we think a potential fix is to initialize tunnel->sock before a=
dding the tunnel into l2tp_tunnel_list.

I think this is the right fix. Please submit a patch formally.

Thanks.
