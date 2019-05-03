Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934A612A4A
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfECJPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:15:48 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:51917 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfECJPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 05:15:47 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 423283970;
        Fri,  3 May 2019 11:15:44 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 3fe29465;
        Fri, 3 May 2019 11:15:42 +0200 (CEST)
Date:   Fri, 3 May 2019 11:15:42 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/10] of_net: add NVMEM support to of_get_mac_address
Message-ID: <20190503091542.GE346@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
 <1556870168-26864-2-git-send-email-ynezz@true.cz>
 <2a5fcdec-c661-6dc5-6741-7d6675457b9b@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5fcdec-c661-6dc5-6741-7d6675457b9b@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> [2019-05-03 11:44:54]:

Hi Sergei,

> > diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> > index d820f3e..258ceb8 100644
> > --- a/drivers/of/of_net.c
> > +++ b/drivers/of/of_net.c
> [...]
> > @@ -64,6 +113,9 @@ static const void *of_get_mac_addr(struct device_node *np, const char *name)
> >    * addresses.  Some older U-Boots only initialized 'local-mac-address'.  In
> >    * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
> >    * but is all zeros.
> > + *
> > + * Return: Will be a valid pointer on success, NULL in case there wasn't
> > + *         'mac-address' nvmem cell node found, and ERR_PTR in case of error.
> 
>    Returning both NULL and error codes on failure is usually a sign of a
> misdesigned API. 

well, then there's a lot of misdesigned APIs in the tree already, as I've just
grepped for IS_ERR_OR_NULL usage and found this pointer/NULL/ERR_PTR usage
pretty legit.

> Why not always return an error code?

I've received following comment[1] from Andrew:

 "What you have to be careful of, is the return value from your new code
  looking in NVMEM. It should only return EPROBE_DEFER, or another error
  if there really is expected to be a value in NVMEM, or getting it from
  NVMEM resulted in an error."

So in order to fullfil this remark, I can't simply use ENOENT instead of
current NULL, as the caller couldn't distinguish between ENOENT from
of_get_mac_address or ENOENT from NVMEM subsystem.

1. https://patchwork.ozlabs.org/patch/1092243/#2161764

-- ynezz
