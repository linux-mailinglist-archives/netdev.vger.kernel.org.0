Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CFA449DCE
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbhKHVVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239938AbhKHVU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 16:20:59 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67EEC061570;
        Mon,  8 Nov 2021 13:18:14 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id f4so67703557edx.12;
        Mon, 08 Nov 2021 13:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=73vuYE9yYoLEy9iSrAl/rTu+PZTNJ9VdX48Xg8l11Dg=;
        b=n+MYiZYy9nfxUhIu1n9FMmStmoZk3i6UH1eL4C+N/pEViVc3RiCQ4cAzkfVEgMEzcQ
         SHzxBuYErbLwi0L18Tr9dTCN8yerCevpw9NLT8SfjddiX/arSvW/+fDSHmSpEEI04eJW
         HkwswVi84klSx3TaXpJnmAPpax94mGIPrSoqgOPvipHgZi2aJOCxN6gnezdQXsSt211L
         ifCHEcR+ogsc040LOwNLGl8a85KvUB4iKaxYh881xkllucDPTS3y1jZy4YohScQTxjb4
         j4ztaVObPY4BBot8QZEOwnz5JBMwr7d7IVdsx5xvcj18Z8THhcNYG1quTSVVBr0BHmde
         5XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=73vuYE9yYoLEy9iSrAl/rTu+PZTNJ9VdX48Xg8l11Dg=;
        b=VnFU4o3IzfLIj5kfbxTZauhdw0aBRxh21ZwQlKDenhxROuff5abwaLxsWK/Uh5w/gd
         vDdWMmOh40Ru4aO2akLai7NMIswrU9bLRobboyNFeV1M/SqWTBOY51qm4aD/yOzvXSEY
         XXQtrqtuXERJrGS4/hTDpfaaWI0opRZeteR4rBy/NsVBcr6DOTerXBPSxarZCsxqFlyy
         oTJFoDA+kUJUO/lpZhOL9yH5Gde+hzaxUwbEg3/OTbRPQNU+LAgdPoAm3izXiHDZnf0y
         TMQnlal5NAQwdA9HOcugZDQ+ZKO6iq68i7elz7XLkns5W45XbM1xAEerlRVj7E3nrK9o
         5fzQ==
X-Gm-Message-State: AOAM531Nze4sVWSA/oZDC1IW+Yiyf7Hav+Xu/Qiu0NAC19r3YjhxiEd7
        5kF6gCrVqRwCST9rZKBilEo=
X-Google-Smtp-Source: ABdhPJxElJYjUS/m0XnOrttdBBhOkph3caesijCsfQ7Tv9Vlstoo75Raixe7jzdIR+zX3ebxdj9Jgg==
X-Received: by 2002:a17:907:3da6:: with SMTP id he38mr2668303ejc.151.1636406293258;
        Mon, 08 Nov 2021 13:18:13 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id gs15sm8901663ejc.42.2021.11.08.13.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:18:12 -0800 (PST)
Date:   Mon, 8 Nov 2021 23:18:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabor Juhos <j4g8y7@gmail.com>, John Crispin <john@phrozen.org>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
Message-ID: <20211108211811.qukts37eufgfj4sc@skbuf>
References: <20211104124927.364683-1-robert.marko@sartura.hr>
 <20211108202058.th7vjq4sjca3encz@skbuf>
 <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:10:19PM +0100, Robert Marko wrote:
> On Mon, Nov 8, 2021 at 9:21 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Timed out waiting for ACK/NACK from John.
> >
> > On Thu, Nov 04, 2021 at 01:49:27PM +0100, Robert Marko wrote:
> > > From: Gabor Juhos <j4g8y7@gmail.com>
> > >
> > > The MIB module needs to be enabled in the MODULE_EN register in
> > > order to make it to counting. This is done in the qca8k_mib_init()
> > > function. However instead of only changing the MIB module enable
> > > bit, the function writes the whole register. As a side effect other
> > > internal modules gets disabled.
> >
> > Please be more specific.
> > The MODULE_EN register contains these other bits:
> > BIT(0): MIB_EN
> > BIT(1): ACL_EN (ACL module enable)
> > BIT(2): L3_EN (Layer 3 offload enable)
> > BIT(10): SPECIAL_DIP_EN (Enable special DIP (224.0.0.x or ff02::1) broadcast
> > 0 = Use multicast DP
> > 1 = Use broadcast DP)
> >
> > >
> > > Fix up the code to only change the MIB module specific bit.
> >
> > Clearing which one of the above bits bothers you? The driver for the
> > qca8k switch supports neither layer 3 offloading nor ACLs, and I don't
> > really know what this special DIP packet/header is).
> >
> > Generally the assumption for OF-based drivers is that one should not
> > rely on any configuration done by prior boot stages, so please explain
> > what should have worked but doesn't.
> 
> Hi,
> I think that the commit message wasn't clear enough and that's my fault for not
> fixing it up before sending.

Yes, it is not. If things turn out to need changing, you should resend
with an updated commit message.

> MODULE_EN register has 3 more bits that aren't documented in the QCA8337
> datasheet but only in the IPQ4019 one but they are there.
> Those are:
> BIT(31) S17C_INT (This one is IPQ4019 specific)
> BIT(9) LOOKUP_ERR_RST_EN
> BIT(10) QM_ERR_RST_EN

Are you sure that BIT(10) is QM_ERR_RST_EN on IPQ4019? Because in the
QCA8334 document I'm looking at, it is SPECIAL_DIP_EN.

> Lookup and QM bits as well as the DIP default to 1 while the INT bit is 0.
> 
> Clearing the QM and Lookup bits is what is bothering me, why should we clear HW
> default bits without mentioning that they are being cleared and for what reason?

To be fair, BIT(9) is marked as RESERVED and documented as being set to 1,
so writing a zero is probably not very smart.

> We aren't depending on the bootloader or whatever configuring the switch, we are
> even invoking the HW reset before doing anything to make sure that the
> whole networking
> subsystem in IPQ4019 is back to HW defaults to get rid of various
> bootloader hackery.
> 
> Gabor found this while working on IPQ4019 support and to him and to me it looks
> like a bug.

A bug with what impact? I don't have a description of those bits that
get unset. What do they do, what doesn't work?

> I hope this clears up things a bit.
> Regards,
> Robert
> >
> > >
> > > Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
> > > Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
> > > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > > ---
> > >  drivers/net/dsa/qca8k.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > index a984f06f6f04..a229776924f8 100644
> > > --- a/drivers/net/dsa/qca8k.c
> > > +++ b/drivers/net/dsa/qca8k.c
> > > @@ -583,7 +583,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
> > >       if (ret)
> > >               goto exit;
> > >
> > > -     ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
> > > +     ret = qca8k_reg_set(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
> > >
> > >  exit:
> > >       mutex_unlock(&priv->reg_mutex);
> > > --
> > > 2.33.1
> > >
> 
> 
> 
> -- 
> Robert Marko
> Staff Embedded Linux Engineer
> Sartura Ltd.
> Lendavska ulica 16a
> 10000 Zagreb, Croatia
> Email: robert.marko@sartura.hr
> Web: www.sartura.hr
