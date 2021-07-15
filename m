Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433183CA0CC
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhGOOjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhGOOjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:39:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C932C06175F;
        Thu, 15 Jul 2021 07:36:52 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i94so8109104wri.4;
        Thu, 15 Jul 2021 07:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5I8dvoJTHfibl8G4N48dj56/eRuc+F3xlgjM6R2cRNE=;
        b=tSsEMo/VpnwDndL+zh6480+ZPKV9QP+OHVdelRqOo6YdPbbTf9aOl6A2YkIOfgWsw5
         k9bmq/Tj04fbb76/RAavjDjt2u8/56bLc2D1W5aBK7fy5v+34WB8vOw5OA1XxqGeworP
         T2cI5UDlu9KteHwUv3Eka0A9yo6xkGaB2CZMkys60sr5Gbh18ihf4You+l4cKrGPQH3w
         iHiKnd1aQx3hXNVXJifb8+Q3eq0StN7BMnI57aoOZ4ag4VgLFWOThat1fChVD3rXU92a
         X+AKfCwOS2AF5Qoe/45UslFpzt5+KQyyaaYuJWljXSs22tsKyk2m2gOCA6Ep0DQNhyIB
         61Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5I8dvoJTHfibl8G4N48dj56/eRuc+F3xlgjM6R2cRNE=;
        b=uMckZNxUMnAQkFzuTmtZDPb0fWMnAiLjmWEPEkGlIVPOAE8srbdelraJJKRuK9GkeV
         QORWIsjtcZqJ7B0nHq9tBLQ4HULdQ7NdGTbbgOFYSnmx9nOHeVQcx2kqwJh0GwohQUop
         U6E9FiIr6unyITjAxSPNUiYMhCH5jvAoVHywnqES764cRVOI7cboyWAzwdQz1tHiAdTF
         x7u6d4TyZ+piqOa4ArCE//UweD8NXHT6ug5KsgNSZV0H8C7F8mtIMOfcMHappN2q4dmj
         gygli/u3JGR4x6rgsg8OoFzZEv4Yce6YhcZwPfETr6tpnnFppwa46DRZA4GNIJJ7oqJQ
         bAyw==
X-Gm-Message-State: AOAM532Z9qLwE7kwKZsDL7B+dpnmA1qn2f7Js3OYmO0NLarr9ycy60hE
        uUxi1yLcxoW/NG/tDrdZeY0=
X-Google-Smtp-Source: ABdhPJwPiU7Hkvsh3nYh8wva4PpZwB+HzgSKWPvk6Ynkg1DyiWH0Cn3w9PI52PC/An0AbK7acRZimQ==
X-Received: by 2002:a5d:66d1:: with SMTP id k17mr6096381wrw.110.1626359810274;
        Thu, 15 Jul 2021 07:36:50 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id v11sm6536724wrs.4.2021.07.15.07.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 07:36:49 -0700 (PDT)
Date:   Thu, 15 Jul 2021 17:36:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <20210715143648.yutq6vceoblnhhfp@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <YPAzZXaC/En3s4ly@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPAzZXaC/En3s4ly@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 03:08:53PM +0200, Andrew Lunn wrote:
> > - If we inherit NETIF_F_HW_CSUM from the master for tail taggers, it is
> >   actively detrimential to keep this feature enabled, as proven my Lino.
> >   As for header taggers, I fail to see how this would be helpful, since
> >   the DSA master would always fail to see the real IP header (it has
> >   been pushed to the right by the DSA tag), and therefore, the DSA
> >   master offload would be effectively bypassed.
>
> The Marvell MACs know about DSA and should be able to perform hardware
> checksumming. It is a long time since i looked at how this works, but
> i think there is a field in the descriptor which gets set with the
> offset to the IP header, so it work for DSA as well as EDSA.
>
> I _think_ Broadcom MACs also know about Broadcom tags and can do the
> right thing.
>
> So we need to be a bit careful here to prevent performance regressions
> for same vendor MAC+Switch combinations.

Tell me more (show me some code). Do Marvell Ethernet controllers which
support TX checksumming with Marvell switches do different things
depending on whether DSA or EDSA is used? Because we can currently
toggle between DSA and EDSA at runtime.

This new information means we can only accept Lino's patch 2/2 as-is for
the "net" tree, otherwise we will introduce regressions one way or
another. It will only be a partial fix for the particular case of KSZ
switches which probably have no DSA master counterpart to support TX
checksumming.

I expect Marvell switches to be equally broken on the Broadcom genet
controller? No one will provide the TX checksum in that case. And that
is not even "fixable" without devising a system where custom code can be
run per {tagger, DSA master} pair, and this includes the case where the
tagging protocol changes at runtime.
