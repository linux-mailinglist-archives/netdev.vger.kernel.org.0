Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727234BEFD
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfFSQvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:51:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37482 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFSQvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:51:42 -0400
Received: by mail-io1-f65.google.com with SMTP id e5so115990iok.4
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CbQ6fOuQmgLNSHpyYdf+NRAIyiJLwuCO10kZvh4pIh4=;
        b=riIIl32O4c6VEvYwgxKFshQTAqUhYNyuF1RQW4zf9Mw7Cr+FdfeuQ8lIDFhmK1O9mD
         mwWRqcq4GcDoDulI269o4bIEagKi7/dhOyGf4JEo2vVPdLHYWPwHhQBR1bg6HHkGzP86
         SZWBoPfa340JMKPi7262NJ5XDHF74yRbyemMUEk6Wd+07ZhCnnNW+fRz87ivqTDewW04
         EB8NQ9fWagckQVauIMN7ur8VSAZDv/rl6S+4ByyD7VgitBKZtWSSv4YpheHKZDuwVIs3
         8V27Prt2fyicyTm8uLGhLF0yLg1RbxK8Y078ANJM8o1PRPq1w+Vs8kjd7RNBNvLQhaNn
         o4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CbQ6fOuQmgLNSHpyYdf+NRAIyiJLwuCO10kZvh4pIh4=;
        b=LcOnCaBX++Fpe2AGVUt2OJKaZThXDAFMYRLvVGgGJR1wyIk2R4XABWES/uwbwMuCQ0
         Z6PdU9UOf1L6o215o6iqehqI4A99pjYoqZfuvGUG1PepVbZlK09DosUWSKYoYfj6SzTZ
         xFmXs0HvhwVObGPCK7borWeQYFZH2lwyrck2XEVXhjKaznSPwRlZkvOaZkCiy6c+asQg
         VHKASyUqvihfCJX2RDMS/FW2qQ4FX0840UE+Bog74ojtbcmL2atGGKHwLJRpqJ1iLtsH
         g9Lkmuze83SFiw59w8URfR1HnpnDpbr0ZJ8vJNqfI4JZ6RlA84uXcvzi2LwsjtpD/MIg
         MfLw==
X-Gm-Message-State: APjAAAUGsLowXRX0e3W1cRuaC+76ruPwlbzrynyc5J5ne+N/qjwPIy5b
        LNT/nVCtDlT28oaJ2/EMMStVOo5jFWVUnrMUYqteZQ==
X-Google-Smtp-Source: APXvYqymzHkSXUPND/qw5VEeMpvA54/kQa+UsosyNoHtAdYk4UgaBfWjP2vCaHUDyLmTZEBKkvkZlkkJtYcN02tbG6o=
X-Received: by 2002:a02:394c:: with SMTP id w12mr11537380jae.126.1560963101367;
 Wed, 19 Jun 2019 09:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190618182543.65477-1-tracywwnj@gmail.com> <20190618182543.65477-4-tracywwnj@gmail.com>
 <20190619.120726.374612750372065747.davem@davemloft.net>
In-Reply-To: <20190619.120726.374612750372065747.davem@davemloft.net>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 19 Jun 2019 09:51:30 -0700
Message-ID: <CAEA6p_Cz31v798F=9+54hnf7yy8diPzXR2FjPuANeaWu0xD7YQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule
 lookup logic
To:     David Miller <davem@davemloft.net>
Cc:     =?UTF-8?B?546L6JSa?= <tracywwnj@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 9:07 AM David Miller <davem@davemloft.net> wrote:
>
> From: Wei Wang <tracywwnj@gmail.com>
> Date: Tue, 18 Jun 2019 11:25:41 -0700
>
> > @@ -237,13 +240,16 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
> >                       goto out;
> >       }
> >  again:
> > -     ip6_rt_put(rt);
> > +     if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
> > +         !list_empty(&rt->rt6i_uncached))
> > +             ip6_rt_put(rt);
>
> This conditional release logic, with the special treatment of uncache items
> when using DST_NOREF, seems error prone.
>
> Maybe you can put this logic into a helper like ip6_rt_put_any() and do the
> list empty test etc. there?
>
>         ip6_rt_put_any(struct rt6_info *rt, int flags);
>
> What do you think?

Thanks David. Sure. Will update.
