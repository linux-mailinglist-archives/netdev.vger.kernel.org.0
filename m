Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89577351E6
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFDVaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:30:00 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:42357 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFDV37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:29:59 -0400
Received: by mail-ed1-f48.google.com with SMTP id z25so2528331edq.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iZrlmE5fDIdGIHyXm+dIJxW0y6eIc6HYsjDzQ5wlgMM=;
        b=PFXvRfv5MdKvFzR5nwHWnzZ2aMx5nUofkVQftwG1520NE12W8FvYd1BXUNjrhRKF/T
         S5mFBTvXxj2Pk+dwna1iazBldcKZ+/cTeZjdJtxeres4A1YYVUgrQcR3WiB4aTDWTXy4
         IRa5hPFoUCAOlhHp9MuO8lMX4RucXR7EFgZNZ8ldy48YFZDHayS7Hh/yGDf63fIqC9H8
         6QfbIWkC0koinVIxeDTFxS9HJJGN4fWx1lCMSa/pvhbNvwU+AocKefGEklH9iqdHjxBU
         qOvKwwcYoEkBv/9pK6x4ffgVxDyxfrK3EtaZ/i857cRaiejv/cEzytEj+UFCnGC1ee50
         deBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iZrlmE5fDIdGIHyXm+dIJxW0y6eIc6HYsjDzQ5wlgMM=;
        b=B1NJvNrMVhCgC6E61NaGn2FhWnld+wfe3S0TvvZhj/lOQUPFm130zhVcuu133PQiA3
         DUsksvWCS2SRxBPZU4ArnVI3h/YKIOZepLC5zDI0k5QSIAxx5b7LkNzn0JSLZLV9QQzy
         hokM2fjXEiypz1sMpcgrm4jLkmLEune3zQvod4mQEHshEPGiyEi6bF6urdueEiW07Jie
         cWTztg5I3izPj5MuVueOynvVTJJbki4sf5HrDXF/h/eeh6OMek1QCInNnVyYGWPBAtf3
         KDLGSEXlcNxFblTvtF2EMjiApTn21CnFudI6qIWFfXKMdn/t9ZVbdtnnWYU/ZQMUs4NA
         miSA==
X-Gm-Message-State: APjAAAUdsbQWYGcWHJYxT630Fx3TTlgYRgEzyy7z5FvSSVt8wqPPOYja
        dZAIwadOI24HcnSfFY4QwgSBN+DVmPkZuIY1Si4=
X-Google-Smtp-Source: APXvYqxe/05oMJDRXKDpd6sqbydXkgNlLDrkNP+F3qtH7Rn3gsuZq3JsimmQQLk8PsKStgSkttdQRVWiFlfRen0fSJs=
X-Received: by 2002:a17:906:259a:: with SMTP id m26mr32324788ejb.230.1559683798161;
 Tue, 04 Jun 2019 14:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch> <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
In-Reply-To: <20190604211221.GW19627@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 00:29:47 +0300
Message-ID: <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 00:12, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > But now the second question: between a phy_connect and a phy_start,
> > shouldn't the PHY be suspended too? Experimentally it looks like it
> > still isn't.
>
> This is not always clear cut. Doing auto-neg is slow. Some systems
> want to get networking going as fast as possible. The PHY can be
> strapped so that on power up it starts autoneg. That can be finished
> by the time linux takes control of the PHY, and it can take over the
> results, rather than triggering another auto-neg, which will add
> another 3 seconds before the network is up.
>
> If we power the PHY down, between connect and start, we loose all
> this.
>
> I don't remember anybody submitting patches because the PHY passed
> frames to the MAC too early. So i don't think there is much danger
> there.
>
>         Andrew

Hi Andrew,

Call me paranoid, but I think the assumption you're making is that
every time you have an Ethernet link, you want it.
Consider the case where you have an Ethernet switch brought up by
U-boot (where it does dumb switching, with no STP, nothing) and the
system power-cycles in a network with loops.
If the operating system has no way to control whether the Ethernet
ports are administratively up, anything can happen... I don't think
it's a bad idea to err on the safe side here. Even in the case of a
regular NIC, packets can go up quite a bit in the MAC, possibly even
triggering interrupts on the cores, when the interface should have
been otherwise "down".

Regards,
-Vladimir
