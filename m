Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A6B362B90
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhDPWpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:45:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40444 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhDPWpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 18:45:07 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by linux.microsoft.com (Postfix) with ESMTPSA id 76F3720B83D9;
        Fri, 16 Apr 2021 15:44:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 76F3720B83D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618613082;
        bh=DcAhC6Pj0o6cQMeLdEBYtLThJCE+7vRtA3+eSuXbF38=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cM48Vu8GfY5PqjWuS6NErTqFuDG5RM/9oXR9vQfvKihX/5LfHXpatACVBIv0OCSNC
         jk9e6/kA6xcbsUdiSwWgwWlTxKrAgfj9uXSTdZhlnSIYdvGwvIMaAd7PHkL3TqttqY
         sG4sRqPw+QBkbh+bBTPtG3G33yN34ha1zkS1FcB0=
Received: by mail-pl1-f174.google.com with SMTP id m18so12523862plc.13;
        Fri, 16 Apr 2021 15:44:42 -0700 (PDT)
X-Gm-Message-State: AOAM532+X8dwlLJ6H+6XsrQOTb1Lc2lR7iLmP6qp5kC+AP2ScUxVScLq
        ECVS6XJ0OH91AxYO8mKF2HM3fP738Gv8+bEqAdw=
X-Google-Smtp-Source: ABdhPJw6rB9a6Y6v5jK8I3KJxZFk+syWBHSe63IsrjyZbhtSyB0LIQUZ1KNrgegZRT+HhYQn0Bc6/5XuZdgw8yOJx6A=
X-Received: by 2002:a17:903:3106:b029:e9:15e8:250e with SMTP id
 w6-20020a1709033106b02900e915e8250emr11878892plc.33.1618613082001; Fri, 16
 Apr 2021 15:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210412003802.51613-1-mcroce@linux.microsoft.com> <75045c087db24b6e87b7ed14aa5a721c@AcuMS.aculab.com>
In-Reply-To: <75045c087db24b6e87b7ed14aa5a721c@AcuMS.aculab.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 17 Apr 2021 00:44:06 +0200
X-Gmail-Original-Message-ID: <CAFnufp12=8pDo-GP6BwH72YiH5C9GXOY8Me=xsFo7=+hvfujaQ@mail.gmail.com>
Message-ID: <CAFnufp12=8pDo-GP6BwH72YiH5C9GXOY8Me=xsFo7=+hvfujaQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] introduce skb_for_each_frag()
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 9:53 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Matteo Croce
> > Sent: 12 April 2021 01:38
> >
> > Introduce skb_for_each_frag, an helper macro to iterate over the SKB frags.
>
> The real question is why, the change is:
>
> -       for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +       skb_for_each_frag(skb, i) {
>
> The existing code isn't complicated or obscure and 'does what it
> says on the tin'.
> The 'helper' requires you go and look up its definition to see
> what it is really doing.
>
> Unless you have a cunning plan to change the definition
> there is zero point.
>
> A more interesting change would be something that generated:
>         unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
>         for (i = 0; i < nr_frags; i++) {
> since that will run faster for most loops.
> But that is ~impossible to do since you can't declare
> variables inside the (...) that are scoped to the loop.
>

I don't know how to do it with C90.
It would be nice to have a switch to just allow declaration of
variables inside the (...) instead of enabling the full C99 language
which, as Linus said[1], allows the insane mixing of variables and
code.

[1] https://lore.kernel.org/lkml/CA+55aFzs=DuYibWYMUFiU_R1aJHAr-8hpQhWLew8R5q4nCDraQ@mail.gmail.com/
-- 
per aspera ad upstream
