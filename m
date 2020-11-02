Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45F72A3648
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKBWIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgKBWIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:08:11 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D161B206E5;
        Mon,  2 Nov 2020 22:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604354890;
        bh=x1SA2yrIMA2Ej7d8Z/mRNvwdoy9ycudvV6MTd+itmpg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pP8jCzpIE1mUttn+/AVxC3K2GYLkcgjC9IEQLbd8syQOHFDIjnqZKR3b3PsFw26SW
         XzPzDq5SE5YJ/k/ynD0yTdAKoGucRGJrpfSPdrL6bqDNKzOxtooGpm1dVjf8WagUta
         U56D+cgNF5OScaD0E35OvPdK0hG+tgq5Qp5frJyU=
Date:   Mon, 2 Nov 2020 14:08:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Pujin Shi <shipujin.t@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: mscc: fix missing brace warning for old
 compilers
Message-ID: <20201102140808.54c156fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102135654.gs2fa7q2y3i3sc5k@skbuf>
References: <20201102134136.2565-1-shipujin.t@gmail.com>
        <20201102135654.gs2fa7q2y3i3sc5k@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 13:56:55 +0000 Vladimir Oltean wrote:
> On Mon, Nov 02, 2020 at 09:41:36PM +0800, Pujin Shi wrote:
> > For older versions of gcc, the array = {0}; will cause warnings:
> > 
> > drivers/net/ethernet/mscc/ocelot_vcap.c: In function 'is1_entry_set':
> > drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: missing braces around initializer [-Wmissing-braces]
> >     struct ocelot_vcap_u16 etype = {0};
> >            ^
> > drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: (near initialization for 'etype.value') [-Wmissing-braces]
> > 
> > 1 warnings generated
> > 
> > Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
> > Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
> > index d8c778ee6f1b..b96eab4583e7 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> > @@ -752,7 +752,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
> >  					     dport);
> >  		} else {
> >  			/* IPv4 "other" frame */
> > -			struct ocelot_vcap_u16 etype = {0};
> > +			struct ocelot_vcap_u16 etype = {};
> >  
> 
> Sorry, I don't understand what the problem is, or why your patch fixes
> it. What version of gcc are you testing with?

Old GCC does not like the 0, if the members of struct are not scalars.

struct ocelot_vcap_u16 {                                                        
        u8 value[2];                                                            
        u8 mask[2];                                                             
};

In this case the first member is an array.

It wants us to add another curly brace:

struct ocelot_vcap_u16 etype = {{0}};

... or we can just skip the 0.

That's just FWIW. I don't remember which versions of GCC behave like
that, I just know we get a constant stream of this sort of fixes.
I think clang may generate a similar warning.

Pujin, please specify the version of GCC you're using and repost.
