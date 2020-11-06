Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EB72A9602
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 13:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgKFMLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 07:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgKFMLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 07:11:33 -0500
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A2E32100A;
        Fri,  6 Nov 2020 12:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604664692;
        bh=uEOhfTfCBXqrs13X3avrkvywnW2eWiyf1LB3yk8KXlE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pv6U9ZZ7FthqDuJGcOYZ3uv+NlHL7YPJjaJly0QyPBb+CvohysudBdVK/3dVc7eiy
         1DDVZJ8uqTHjuJNySIwJUf8zYTYE4OFMxVwqBjvlzfl9cjk6ljfMGZ+vYNJvWGUsTb
         unVEBtel6WTxhRmHpw1ZFIvjzszjPgofJAxipo+A=
Received: by mail-wm1-f52.google.com with SMTP id s13so1119853wmh.4;
        Fri, 06 Nov 2020 04:11:32 -0800 (PST)
X-Gm-Message-State: AOAM532OzHlTPfLMLrCPzsZyHkU8ehV7xK3bGwe9dpdeBHhuvAy3Eo2C
        4RwuCiUZduEUzoRxOEOwFA1RHCRwUzyqJI6dJ5M=
X-Google-Smtp-Source: ABdhPJzv2EmRP8CYUYmU3H3MT9wpk8xr+uYi4DIu4bJTYIGgo1Vpv9woMA6d2Gldiu9Bnsvu9XMUY+Db9OR7x/ZBtT0=
X-Received: by 2002:a05:600c:256:: with SMTP id 22mr2121841wmj.120.1604664689730;
 Fri, 06 Nov 2020 04:11:29 -0800 (PST)
MIME-Version: 1.0
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com> <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com>
In-Reply-To: <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 6 Nov 2020 13:11:13 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0Dce3dYER0oJ+2FcV8UbJqCaAv7zSS6JZBdb6ewfnE7g@mail.gmail.com>
Message-ID: <CAK8P3a0Dce3dYER0oJ+2FcV8UbJqCaAv7zSS6JZBdb6ewfnE7g@mail.gmail.com>
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 12:35 PM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 06/11/2020 09:56, Wang Qing wrote:

> > +++ b/drivers/net/ethernet/ti/am65-cpts.c
> > @@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>
> there is
>         cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);
>
>
> >       if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
>
> And ptp_clock_register() can return NULL only if PTP support is disabled.
> In which case, we should not even get here.
>
> So, I'd propose to s/IS_ERR_OR_NULL/IS_ERR above,
> and just assign ret = PTR_ERR(cpts->ptp_clock) here.

Right, using IS_ERR_OR_NULL() is almost ever a mistake, either
from misunderstanding the interface, or from a badly designed
interface that needs to be changed.

     Arnd
