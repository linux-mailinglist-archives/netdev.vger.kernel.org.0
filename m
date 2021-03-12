Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E420338241
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhCLA1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhCLA04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:26:56 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB36C061574;
        Thu, 11 Mar 2021 16:26:56 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id a9so22650587qkn.13;
        Thu, 11 Mar 2021 16:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbmokgZymiS3iblK7SguwZRYnWpNx1j40+buPp7T5hI=;
        b=Whz4MyDX/Z4x61M2IOu46yFDNbrBy9hxI40mUilWmBGYlA6KNkDz/vz3svNyBHzQWQ
         gLeaU5E2C4JDURV0Ro3lWaIi7CZzig33rNWCj6r1XmNNZeowmF0drcd3o1ADJTATwwGH
         iP65fPEnz//mgxSwPRetyM1YEmdYAMC9np278=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbmokgZymiS3iblK7SguwZRYnWpNx1j40+buPp7T5hI=;
        b=eLFGSILP/XQj3j7In2f96CBD/rBFVUePfy/+wav4rxdcCFIf7skROvotnFMCzvdV2s
         tbAM7ZG/zy+bMikTu0YZtdbqFvkV2My7nK9sRin1UW0PNtF9IqGDVNCqvM16MCoybeJN
         4feF2ZzHpfuR1i9C6nO3R/Se0+pc/78q5MPVan4epsffBEFMvtEfLkLsdGIFyOY+secL
         ul7GI7o1SvxXwVkpaZj/UBOuueoOIP562PKaBZ8ADty6zKrQIeewUCrgRspWOx7OygQs
         IvNZ9m0fwf5oKUgat05wU9yrGOEY2eOeN/dM+6UkVQ5Fg2mZaiPSD+FpiR2fa425tBA8
         DVWA==
X-Gm-Message-State: AOAM5308YVWNvVX+t5qL25QYPNwmHdlIXXLuGfb3szTeY3gwyhtnxYvL
        rkn+En21Ey9cpQVS8XF6eA/C4mYINMyXebO60Qg=
X-Google-Smtp-Source: ABdhPJzQy1fZxNI+jlTTtWmDGQKTLadDYa40QFao7q89di04GjVYULBfHmtP6r+/2GRiITO90WaY0pQIh8Gx0mHD8xQ=
X-Received: by 2002:a37:a147:: with SMTP id k68mr10400285qke.66.1615508815554;
 Thu, 11 Mar 2021 16:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
 <20201019085717.32413-5-dylan_hung@aspeedtech.com> <CACPK8Xc8NSBzN+LnZ=b5t7ODjLg9B6m2WDdR-C9SRWaDEXwOtQ@mail.gmail.com>
In-Reply-To: <CACPK8Xc8NSBzN+LnZ=b5t7ODjLg9B6m2WDdR-C9SRWaDEXwOtQ@mail.gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Fri, 12 Mar 2021 00:26:43 +0000
Message-ID: <CACPK8XfMEy2o39v3CG4Zzj9H_kqSFBOddL3SC-_OryMqVXEjOw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ftgmac100: Restart MAC HW once
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 at 04:14, Joel Stanley <joel@jms.id.au> wrote:
>
> On Mon, 19 Oct 2020 at 08:57, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
> >
> > The interrupt handler may set the flag to reset the mac in the future,
> > but that flag is not cleared once the reset has occured.
> >
> > Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
> > Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
>
> Reviewed-by: Joel Stanley <joel@jms.id.au>

net maintainers, this one never made it into the tree. Do you need me
to re-send it?

Cheers,

Joel

>
> > ---
> >  drivers/net/ethernet/faraday/ftgmac100.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 0c67fc3e27df..57736b049de3 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -1326,6 +1326,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
> >          */
> >         if (unlikely(priv->need_mac_restart)) {
> >                 ftgmac100_start_hw(priv);
> > +               priv->need_mac_restart = false;
> >
> >                 /* Re-enable "bad" interrupts */
> >                 ftgmac100_write(FTGMAC100_INT_BAD, priv->base + FTGMAC100_OFFSET_IER);
> > --
> > 2.17.1
> >
