Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4467DCE
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 08:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfGNGbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 02:31:08 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:37791 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfGNGbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 02:31:08 -0400
Received: by mail-pl1-f180.google.com with SMTP id b3so6740607plr.4
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 23:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7M6rhSUF/YdfBSS2QEYDsRYhsp031bK7Twdq9oZAWtQ=;
        b=fjMokYOUSzYOfRs5UBl429nqmkLabFUplNqwFhIbTmt4P+6JTp6gm4HeO54qqD/Tar
         qwBoqIkCoXEmUKOTCHyt0ihRnIkkt+TIBioKJ9+LTAbtqZXL7ldTm6EomwJbq2GXCSQ+
         REwBcaXSsfckLsdnciS5MoL3X3WIHfdpqIqV5bcyInsQjdzMlHu/7aKNe+h+9qlW9NbL
         ThJ8DPyC1OtKl/lngy9K6Y2EcLvnjjwc4wdeXP6FX8cfTOXJV7kTto2nTJp5SFoay8fx
         SMOPvgbBNVHPbZOPqpxvcPblVx1gBOdMaoBi1b5Ib9gY1GwcElGdoeSLQA+ZlQrCRK0t
         trNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7M6rhSUF/YdfBSS2QEYDsRYhsp031bK7Twdq9oZAWtQ=;
        b=tr18Oxy8PW2aLQ2n1UIp0pCkP1FDalFoH8LLnf6/2/BjDFbYPh4Xcf88J9sqqhwzEq
         kcwCaIP+TX9mzgc9+oho34n6j+BnSQ4rS8P79/YFZV3OSKUkmccGi99hQ5dB03svzgN9
         oQO/D1bXpC1dPvVtXkoTOxZnUJvTVKr3etvUNcFE2U9pd++f7Nj/lrAsBDAOr52Y57+x
         iPH8O4HRhCu/zqGupSZ1/io8UTqAQrBsyoXsmQcfj2Fsqu2BAzUyBGpWtxL1lcxFbaoP
         CXudFRCCL6rmgrQy7xsyyL3EjdLKFyqwmRbXEqYL9QlxpqC5jVCfgg0Ar69CZppiGRQZ
         5k+w==
X-Gm-Message-State: APjAAAVthLa1/pKatlRsU8s94S1xEvrvaObq+bri3MRkKeFFuuneAWqu
        R+zIZjwlsMLiK9RTkx7/1RR9hOX380zJy+Pq2I8=
X-Google-Smtp-Source: APXvYqxv2ph+1btNQgwjwlk/efIimXNXJkCMfOELaWqiXW+r50UtIvssiV9yx+1RgwGQKjiWI8LR1A/9RtdaXTEYKiI=
X-Received: by 2002:a17:902:a50d:: with SMTP id s13mr21543709plq.12.1563085867012;
 Sat, 13 Jul 2019 23:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190712201749.28421-2-xiyou.wangcong@gmail.com> <8355af23-100f-a3bb-0759-fca8b0aa583b@gmail.com>
In-Reply-To: <8355af23-100f-a3bb-0759-fca8b0aa583b@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Jul 2019 23:30:56 -0700
Message-ID: <CAM_iQpUd44ctMmtGrr4x_uA9UUxUdTzS-3tuySt2-jhM0y950A@mail.gmail.com>
Subject: Re: [Patch net] fib: relax source validation check for loopback packets
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Julian Anastasov <ja@ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 13, 2019 at 3:42 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/12/19 2:17 PM, Cong Wang wrote:
> > diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> > index 317339cd7f03..8662a44a28f9 100644
> > --- a/net/ipv4/fib_frontend.c
> > +++ b/net/ipv4/fib_frontend.c
> > @@ -388,6 +388,12 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
> >       fib_combine_itag(itag, &res);
> >
> >       dev_match = fib_info_nh_uses_dev(res.fi, dev);
> > +     /* This is rare, loopback packets retain skb_dst so normally they
> > +      * would not even hit this slow path.
> > +      */
> > +     dev_match = dev_match || (res.type == RTN_LOCAL &&
> > +                               dev == net->loopback_dev &&
>
> The dev should not be needed. res.type == RTN_LOCAL should be enough, no?
>
> > +                               IN_DEV_ACCEPT_LOCAL(idev));
>
> Why is this check needed? Can you give an example use that is fixed -

I am not sure if I should have this check either, my initial version didn't
have it either, later I add it because I find out it is checked for rp_filter=0
case too.

On the other hand, loopback always accepts local traffic, so it may be
redundant to check it. So, I am not sure.

What do you think?

> and add one to selftests/net/fib_tests.sh?

It's complicated, Mesos network isolation uses this case:
https://cgit.twitter.biz/mesos/tree/src/slave/containerizer/mesos/isolators/network/port_mapping.cpp

Even if I use a simplified case, it still has to use TC filters and mirred
action to redirect the packet, which I am not sure they fit in fib_tests.sh.

Thanks.
