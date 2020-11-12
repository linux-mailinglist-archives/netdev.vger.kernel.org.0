Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40052B012E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKLIZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgKLIZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 03:25:30 -0500
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9338120870;
        Thu, 12 Nov 2020 08:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605169529;
        bh=RSxRn949MZY6y93oLiWvaHo+7PnxlV/84Tkc2P1zhVw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tO17eFmb3xudHqBlDEqyUUkKeDSsgeNziWe/m51IO1GH/IZoPcO2LjFvmjjnZchdB
         0H9r9N+/ZRYDDaMyLDQbc6Qs0Hu3if+b0WoAKIXHdQZh7+NWuWlyCDX42VjTNRfEx9
         hfsoBAMnC36NnN45z4JENm+b25aNSh+ioLEIKQBo=
Received: by mail-oo1-f49.google.com with SMTP id r11so1105881oos.12;
        Thu, 12 Nov 2020 00:25:29 -0800 (PST)
X-Gm-Message-State: AOAM532sCj9PX8i1sKb7KcBJqfXCTEYXdPi/RIHMRvD9OjgzhZ4mPPdZ
        BPuD9JPvyQXgfhymNmIx6m7cFA2yWdfbipYn2GU=
X-Google-Smtp-Source: ABdhPJwQKAqzE4KEEJzpIcaTlOL5BCn/ntfBu542Xwz6PPXPtsstp7C1oZaaWIcmlsq7Ivqbes8hXylKk4bDrf7rjrI=
X-Received: by 2002:a4a:7055:: with SMTP id b21mr780781oof.66.1605169528807;
 Thu, 12 Nov 2020 00:25:28 -0800 (PST)
MIME-Version: 1.0
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
In-Reply-To: <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 12 Nov 2020 09:25:12 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
Message-ID: <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
Subject: Re: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when
 ptp_clock is ERROR
To:     =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 2:48 AM =E7=8E=8B=E6=93=8E <wangqing@vivo.com> wrot=
e:
> >> On Wed, Nov 11, 2020 at 03:24:33PM +0200, Grygorii Strashko wrote:
> >
> >I don't think v1 builds cleanly folks (not 100% sure, cpts is not
> >compiled on x86):
> >
> >               ret =3D cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);
> >
> >ptp_clock is a pointer, ret is an integer, right?
>
> yeah, I will modify like: ret =3D cpts->ptp_clock ? PTR_ERR(cpts->ptp_clo=
ck) : -ENODEV;

This is not really getting any better. If Richard is worried about
Kconfig getting changed here, I would suggest handling the
case of PTP being disabled by returning an error early on in the
function, like

struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
                                   struct device_node *node)
{
        struct am65_cpts *cpts;
        int ret, i;

        if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
                 return -ENODEV;

Then you can replace the broken IS_ERR_OR_NULL() path with
a simpler IS_ERR() case and keep the rest of the function readable.

> >Grygorii, would you mind sending a correct patch in so Wang Qing can
> >see how it's done? I've been asking for a fixes tag multiple times
> >already :(
>
> I still don't quite understand what a fixes tag means=EF=BC=8C
> can you tell me how to do this, thanks.

This identifies which patch introduced the problem you are fixing
originally. If you add an alias in your ~/.gitconfig such as

[alias]
        fixes =3D show --format=3D'Fixes: %h (\"%s\")' -s

then running

$ git fixes f6bd59526c
produces this line:

Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common
platform time sync driver")

which you can add to the changelog, just above the Signed-off-by
lines.

      Arnd
