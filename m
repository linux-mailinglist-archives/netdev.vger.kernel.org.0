Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD12B200C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgKMQWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgKMQWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:22:06 -0500
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDFCE22242;
        Fri, 13 Nov 2020 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605284526;
        bh=fX3xdiQYb5V89YurUlsRm+iMzpkNmQF2yX7rst7Fbh4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WECKDcoS7vsSMa1RJbr3KW7rRxPJVn2QAgXKdbwZ8PcOrJuFf7qIa1T/Kf8dNJBNG
         ggYdFjJ7ZbB4EBQvz5UGIMLtKb+UqvpKphx3fB9LnnNcgV9Iq/+xbfbbTkgZZ3eeQ4
         kibQFbgOWd/ZwH5PYob1piGQUSZ9Aamr/29psL4M=
Received: by mail-ot1-f43.google.com with SMTP id n89so9412911otn.3;
        Fri, 13 Nov 2020 08:22:05 -0800 (PST)
X-Gm-Message-State: AOAM532wbToRWGkYM82yH7oxfeKJ7DVaAKp/BvCfVhpOwboCaRLNSXwA
        X7hZOTGWkU823Nif/dH6CIGTdB/jBS06xJgiVmk=
X-Google-Smtp-Source: ABdhPJwCqtSzy85fgpXARAdUrW5t6a29ygecNGNheUBP2KcmHoZih3Ml3ZyBmBqHbIBYjhjlwcBzoLfz9bK1yx5HaDE=
X-Received: by 2002:a9d:65d5:: with SMTP id z21mr1927181oth.251.1605284520141;
 Fri, 13 Nov 2020 08:22:00 -0800 (PST)
MIME-Version: 1.0
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
 <20201112181954.GD21010@hoboy.vegasvil.org> <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
 <20201112232735.GA26605@hoboy.vegasvil.org>
In-Reply-To: <20201112232735.GA26605@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 13 Nov 2020 17:21:43 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3V98x3s7DvHtutiz97Q=5QjfS6Xn4kH2r2iamY3dzwkw@mail.gmail.com>
Message-ID: <CAK8P3a3V98x3s7DvHtutiz97Q=5QjfS6Xn4kH2r2iamY3dzwkw@mail.gmail.com>
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

On Fri, Nov 13, 2020 at 12:27 AM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Thu, Nov 12, 2020 at 10:21:21PM +0100, Arnd Bergmann wrote:
> > I agree that the 'imply' keyword in Kconfig is what made this a
> > lot worse, and it would be best to replace that with normal
> > dependencies.
>
> IIRC, this all started with tinification and wanting dynamic posix
> clocks to be optional at compile time.
>
> I would like to simplify this whole mess:
>
> - restore dynamic posix clocks to be always included
>
> - make PHC always included when the MAC has that feature (by saying
>   "select" in the MAC Kconfig) -- I think this is what davem had
>   wanted back in the day ...
>
> I'm not against tinification in principle, but I believe it is a lost
> cause.

My preference would be to avoid both 'select' and 'imply' here,
both of them cause their own set of problems. The main downside
of 'select' is that you can't mix it with 'depends on' without risking
running into circular dependencies and impossible configurations,
while the main problem with 'imply' is that the behavior is close to
unpredictable. The original definition still made some sense to me,
but the new definition of 'imply' seems completely meaningless.

I've prototyped a patch that I think makes this more sensible
again: https://pastebin.com/AQ5nWS9e

This needs testing, but if you think the approach makes sense,
I can give it a few randconfig builds and submit for wider review.

       Arnd
