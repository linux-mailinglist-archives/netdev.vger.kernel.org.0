Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D642B30F5
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 22:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKNVRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 16:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgKNVRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 16:17:06 -0500
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A7022450;
        Sat, 14 Nov 2020 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605388626;
        bh=fLMkFVoa5bkRy30uzWhJQnvABvcL1eCRrjTgBznA7wk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c3aPOwd949G0htINM2Xl/y3kMEAdo0dy6MVlD8C2P4RTndmota9lSUheO25R4D9JP
         PZepkZ41DJV5UnRpoozbfOFm1z/5kR77lYbnY44RmIvUXe2PceBHh6OcMEEDCFEVEG
         +REc6FyccNOr/v0GXCjqmBD4ufZ6SzCKUxt4DLlA=
Received: by mail-oo1-f52.google.com with SMTP id g4so2992811oom.9;
        Sat, 14 Nov 2020 13:17:06 -0800 (PST)
X-Gm-Message-State: AOAM532ndHcgrkGhTaktG+Xfoz89whQCuFB/yjENi8+aLKjKu1XkyK+p
        YedFFCaBZmlmFpUcAYfWgrfHweqI3b1LPE8WW04=
X-Google-Smtp-Source: ABdhPJyo8YPzSUlO6AoSi1Kv1ILm/1CWn6QdP9AIC2THwom4/6n31+HYcUBMHN70yE7IAQF6GJ4MYtc9RUeiu7QcI5M=
X-Received: by 2002:a4a:7055:: with SMTP id b21mr5829636oof.66.1605388625527;
 Sat, 14 Nov 2020 13:17:05 -0800 (PST)
MIME-Version: 1.0
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
 <20201112181954.GD21010@hoboy.vegasvil.org> <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
 <20201112232735.GA26605@hoboy.vegasvil.org> <CAK8P3a3V98x3s7DvHtutiz97Q=5QjfS6Xn4kH2r2iamY3dzwkw@mail.gmail.com>
 <20201114151410.GA24250@hoboy.vegasvil.org>
In-Reply-To: <20201114151410.GA24250@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 14 Nov 2020 22:16:49 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3mM3CF889Fi4COr1A9LDDi74_93xnwt9rZkky5Zd5www@mail.gmail.com>
Message-ID: <CAK8P3a3mM3CF889Fi4COr1A9LDDi74_93xnwt9rZkky5Zd5www@mail.gmail.com>
Subject: Re: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when
 ptp_clock is ERROR
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 4:14 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Fri, Nov 13, 2020 at 05:21:43PM +0100, Arnd Bergmann wrote:
> > I've prototyped a patch that I think makes this more sensible
> > again: https://pastebin.com/AQ5nWS9e
>
> I like the behavior described in the text.
>
> Instead of this ...
>
>      - if a built-in driver calls PTP interface functions but fails
>        to select HAVE_PTP_1588_CLOCK or depend on PTP_1588_CLOCK,
>        and PTP support is a loadable module, we get a link error
>        instead of having an unusable clock.
>
> how about simply deleting the #else clause of
>
>     --- a/include/linux/ptp_clock_kernel.h
>     +++ b/include/linux/ptp_clock_kernel.h
>     @@ -173,7 +173,7 @@ struct ptp_clock_event {
>       };
>      };
>
>     -#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
>     +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
>
> so that invalid configurations throw a compile time error instead?

I was trying to still allow PTP clocks to be disabled, either when
building a kernel that doesn't need it, or when posix timers are
disabled. Leaving out the #else path would break all drivers that
have PTP support in the main ethernet driver file rather than
conditionally compiling it based on a Kconfig symbol that depends
on CONFIG_PTP_1588_CLOCK.

       Arnd
