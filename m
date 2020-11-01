Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D075B2A1D88
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 12:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgKALKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 06:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgKALKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 06:10:12 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD76C0617A6;
        Sun,  1 Nov 2020 03:10:12 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id za3so14619891ejb.5;
        Sun, 01 Nov 2020 03:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MPHqIH/d7+mpoPui6Qu3n2BCl3vKtro3QMwJNOOF6Y=;
        b=pUV26Mbdnut4NYCl5svB+rmihuMr1B9EBpwt0Y8qRGfxaVbkLGLJfuB7SjL1xH/EdB
         c3/VuLoiZAvP1h7In+K6r3TUWr0QuQb/bHQTmHnkQqmOSbVUmKk1zNd1PVWfaysk84Fi
         Ds2YlbRgRRZeyv2Gwsma1FmmTSieSFw3jrFsFmS5xmMcmASnQjkfuEergezbam1JTzTA
         wG6Hhm7e6TZXAQdXt85XHPt1n9HE/hnFSidB4bSog+D67ObrjandvD1hTSlNQ2AwCi5v
         omocvyIuRaUu9VdUVo7IdHO/bxTgLuFaREfasYlLAzyejHuBeTp6LF+ZM2cvWkL03oVa
         cncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MPHqIH/d7+mpoPui6Qu3n2BCl3vKtro3QMwJNOOF6Y=;
        b=kiw1ntZ/obJW9CGEubKUxX9O5N4FWlTYRivwIjBJt2dC6avN2dBj0joacE29/mba/p
         ktdhpzWtK2kHmT/QAtTtYXauqTDA8YKbiynEQ4BM1uBBJvyslPstGcDN3by06bj36r+5
         uKnkKLtPMZJAYug7V0Y8+hyB1GoVZoQ6oLzBnzhsnOT60b11IOLzS4K5LcN9FH95DC9M
         mzJasc+xwOkzzTomBYaa3MI4hMVL2thWEldtUhNdUO/6G4BMHx/U4AAN4iS/evPoyi0C
         Gt9ca5M62Bt9zLkbcD58y1H4EV4MBwjq+M549peoSKCUIUK0Eg3MWPxqxDqqOqeXMtoR
         ZcLQ==
X-Gm-Message-State: AOAM531580EZsCtSid3VPhVqiWduuF7Oh4rDVbD915qPeuQcZn1s6jeM
        qGCoW8joj1rUZFph/1rhC9A=
X-Google-Smtp-Source: ABdhPJxDKhAdeZ/N5kbfYECBf2Jn3mowe9drqvhc7P21N8c31cl0v7hI7pE1dJnR3PNYVpfPpl2WhQ==
X-Received: by 2002:a17:906:14db:: with SMTP id y27mr11185684ejc.148.1604229010649;
        Sun, 01 Nov 2020 03:10:10 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l20sm3648191eja.40.2020.11.01.03.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 03:10:10 -0800 (PST)
Date:   Sun, 1 Nov 2020 13:10:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201101111008.vl4lj4iqmqjdpbyg@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <1680734.pGj3N1mgWS@n95hx1g2>
 <20201030182447.2day7x3vad7xgcah@skbuf>
 <4928494.XgmExmOR0V@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4928494.XgmExmOR0V@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 10:35:01AM +0100, Christian Eggers wrote:
> Hi Vladimir,
> 
> On Friday, 30 October 2020, 19:24:47 CET, Vladimir Oltean wrote:
> > On Thu, Oct 22, 2020 at 12:17:48PM +0200, Christian Eggers wrote:
> > > I tried to study the effect of setting the ocmode bit on the KSZ either to
> > > master or to slave. The main visible change is, that some PTP message
> > > types
> > > are be filtered out on RX:
> > > - in "master" mode, "Sync" messages from other nodes will not be received
> > > (but everything else like "Announce" seem to work)
> > > - in "slave" mode, "Delay_Req" messages from other nodes will not be
> > > received
> > Could you dump the contents of your REG_PTP_MSG_CONF2 register?
> runtime register value is 0x1004 (matches default value from the data sheet).
> The Linux driver doesn't touch this register. Below is a dump of all PTP
> related (global) registers.

So the bit 5 ("Enable Dropping of Sync/Follow_Up and Delay_Req PTP
Messages") is not set. When the PTP messages are dropped, do you know
which error counter in ethtool -S is increasing?
