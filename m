Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FFD2AFDE7
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgKLFcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLBa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 20:30:58 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF091C0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 17:30:57 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id z13so60903qvs.4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 17:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jF5hbWDxBXsLJUtOsoUMyN35uLz16rgYVNifER95Wro=;
        b=lKJOGf+SESEkzrvkJBkIEA/KmlEDMmwd5GEBqWhGNz0MhJOj9H3EHkIMX0V7wWD23F
         pE3ToWvjbCjaPWWY6dMxrOoxDDebs9QR+v/uC67jzaVEmSgEFEvweXsaC4jPcbGod9H6
         tx+Tl7Ok/hDm5crEGbNHmQi6LIwZAsjA02hGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jF5hbWDxBXsLJUtOsoUMyN35uLz16rgYVNifER95Wro=;
        b=JMO2sBAfinoo+LVcAkkGE7kmNFl72ZAosWUwDO38s5VcX2JzKdukJKglFN4XP6Cj4j
         6e1RG4nBVYeWmcehNJ5yHdmL/PFqWWPeqLeoEXK4kDEOPNgF+Q7KgFGlcg19yAg5j1UD
         SBucsd7tjxrk6E0WJeDpf0bmaSa7FLDixPID86JXDQ9FGLKh2cmwouYdjxU7R/sbdBT2
         FwAHdPAIfVzPeVWxOiAbvLPLuDctN0WKFxj2NmwP75mX8AzhbDckdb8Ja+ZkY9Ad1eQv
         jeZ3krCCwQfjrxNGiiQMWzlpkbNfog2oEe2d0IBmsXtAFL3jYwg4PZquMctMFaYXfhtX
         wx7Q==
X-Gm-Message-State: AOAM531T05a7+JT309kyYPdA0L0QNXPrY5dfaGW5M5eJQnY0FiGBtaa9
        QObXJ9kNfxLQgjb9gg3GFDh1Laxs01eUJkk6QgQ=
X-Google-Smtp-Source: ABdhPJzF3F957mhU6f+rOXZYfozXSGcXD8nu7YiaJAiBZ2/6iroDA965T4RcWctNFqAoCRwKrGrI0l4NNHSBSSeRfeU=
X-Received: by 2002:a0c:8ecf:: with SMTP id y15mr28462008qvb.18.1605144656218;
 Wed, 11 Nov 2020 17:30:56 -0800 (PST)
MIME-Version: 1.0
References: <20201112004021.834673-1-joel@jms.id.au> <20201111165716.760829aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACPK8Xd3MfTbp2184e6Hp7D4U40ku0vqw=pb5E7mamddMGnj3A@mail.gmail.com> <20201111172051.28e70e7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111172051.28e70e7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 12 Nov 2020 01:30:43 +0000
Message-ID: <CACPK8Xf2aR8wXOQK4byj_UOQUqvd8uMVTBh8UMKZn8uT6cqdOQ@mail.gmail.com>
Subject: Re: [PATCH] net/ncsi: Fix re-registering ncsi device
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 at 01:20, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 12 Nov 2020 01:11:04 +0000 Joel Stanley wrote:
> > On Thu, 12 Nov 2020 at 00:57, Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 12 Nov 2020 11:10:21 +1030 Joel Stanley wrote:
> > > > If a user unbinds and re-binds a ncsi aware driver, the kernel will
> > > > attempt to register the netlink interface at runtime. The structure is
> > > > marked __ro_after_init so this fails at this point.
> > >
> > > netlink family should be registered at module init and unregistered at
> > > unload. That's a better fix IMO.
> >
> > I don't follow, isn't that what is implemented already?
> >
> > Perhaps I'm getting confused because the systems that use this code
> > build the drivers in. The bug I'm seeing is when we unbind and re-bind
> > the driver without any module loading or unloading.
>
> It's registered from ncsi_register_dev(), which is obviously broken,
> because there is only one family so it would never work if there was
> more than one ncsi netdev.
>
> Looks like NCSI can only be built in, so instead of module init it
> should be a subsys_initcall().
>
> Basically remove ncsi_unregister_netlink(), remove the dev parameter
> from ncsi_init_netlink() and add:
>
> subsys_initcall(ncsi_init_netlink);
>
> at the end of ncsi-netlink.c

Thanks for the explanation, I'll do that.
