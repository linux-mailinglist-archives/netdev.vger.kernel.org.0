Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48EF2B101E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgKLVVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgKLVVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 16:21:41 -0500
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A6302222F;
        Thu, 12 Nov 2020 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605216100;
        bh=aNzlXeKDeO/FWCYy+g3S3nGSWQBqBxHvUVIXEM+dZps=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e7w8M0MRTPxNspmPyUL1EqtTOopZyHn17Pb6t6P6R4hJBgpejfhf+KkJRbgBsDyDN
         Ag7ZiS0kmrQ2eSAHi4FrqJxdshtEUTpvvk/D+JQZAvE1QBK/SmIAk0s7ckIRmGXnFO
         8SKFvylmFFo97YVOG9r5jWLEMfOk+FLpnlaawrEk=
Received: by mail-oi1-f173.google.com with SMTP id c80so8057269oib.2;
        Thu, 12 Nov 2020 13:21:39 -0800 (PST)
X-Gm-Message-State: AOAM531Y7zL0ZpMeAxnvSzIxSC25yVvEFic/om/772xmyk5hMENxeatV
        igJuKocdwdBwoD+uTjzvGhgZ8O/Ofgzbj7f4dm8=
X-Google-Smtp-Source: ABdhPJzTCyUFP4Pr0r8PK5Kd4T1weSDX9B6TSm7WEKViy/jdps/YNBAzxgF+L20H5WKH/aeqr3yjWZ6vULQiwTx9pH8=
X-Received: by 2002:a54:4597:: with SMTP id z23mr458428oib.0.1605216099110;
 Thu, 12 Nov 2020 13:21:39 -0800 (PST)
MIME-Version: 1.0
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com> <20201112181954.GD21010@hoboy.vegasvil.org>
In-Reply-To: <20201112181954.GD21010@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 12 Nov 2020 22:21:21 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
Message-ID: <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
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

On Thu, Nov 12, 2020 at 7:19 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Thu, Nov 12, 2020 at 09:25:12AM +0100, Arnd Bergmann wrote:
> > This is not really getting any better. If Richard is worried about
> > Kconfig getting changed here, I would suggest handling the
> > case of PTP being disabled by returning an error early on in the
> > function, like
> >
> > struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
> >                                    struct device_node *node)
> > {
> >         struct am65_cpts *cpts;
> >         int ret, i;
> >
> >         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
> >                  return -ENODEV;
>
> No, please, no.  That only adds confusion.  The NULL return value
> already signals that the compile time support was missing.  That was
> the entire point of this...
>
>  * ptp_clock_register() - register a PTP hardware clock driver
>  *
>  * @info:   Structure describing the new clock.
>  * @parent: Pointer to the parent device of the new clock.
>  *
>  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>  * support is missing at the configuration level, this function
>  * returns NULL, and drivers are expected to gracefully handle that
>  * case separately.

The problem is that the caller doesn't handle that case gracefully,
but it instead wants to return an error after all. I don't see a good
solution either; as far as I'm concerned we should never be building
code that fails if PTP_1588_CLOCK is disabled when it cannot
do anything sensible in that configuration.

I agree that the 'imply' keyword in Kconfig is what made this a
lot worse, and it would be best to replace that with normal
dependencies.

It would be possible to have a ptp_clock_register_optional()
interface in addition to ptp_clock_register(), which could then
be changed to return an error. Some other subsystems follow
this pattern, but it's not any less confusing either.

     Arnd
