Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C08F6A1E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKJQaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:30:05 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45600 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKJQaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:30:05 -0500
Received: by mail-ed1-f67.google.com with SMTP id b5so9972644eds.12
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 08:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0TUMPUp3339KR/pgz9a6XtdA5sRCKin0tKa5Y7s/JHo=;
        b=uU3xew3fndi3iUPJyj23KENKm6Rn+gJWucfrtWA9RO7IbQ93CLVGEFyNrGSyzcNhEj
         onEbuDS7J5GyBYtPunql0LvdOKevxUQW1UN/k+sPnGL1ZZDQ0LOeLNwu1WsNkiqADX5o
         V6nv8I4wpPm7e3BQarqI6TWJYY73PwYB3SdTU11cPcA2SM94seZ70Xubab7s3Q4edxOD
         LcoRgCLcdF97+u4I2Mf3HBs3pNCop5tMNDmTqaZ4eGI/ff6fvPDg7X/1f92b/dRktHSX
         ca4UWfJ4LU+wT1I6C76X6YswA2jo6B3KpgBJkbUJtOGwgdLcuy+2Ztx+ISrf9t9khllY
         UZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0TUMPUp3339KR/pgz9a6XtdA5sRCKin0tKa5Y7s/JHo=;
        b=aWK2PulNqACREc69VCnpKj9X1bwbdzgZblaO+NCAWXcypbHTmjKl9rVG/w+nO38S0H
         VPGhvyIK596yGaiwxQSLf1r7aBI9jGTdyBPagK48hga4jTNlEI+x19jIjQyAgN9YoKuH
         wLGGck5cyj7KsFr7Ek9X6yrqNtglJ2kOozTDx8lJOXsHDM/JCV6UC1zeAUhe/Placybe
         4CjWs2axFj6tmxyPHsa0EA/wM0WkMTdA7QeJMhkNRVge4hoRoIZBk4ts+OKFHnQeQBUw
         /Paj3qIQQ5yp0HUKvs3sZPyCITk0LrxcYwbjgWelpb/RMAo290Jn/wP5mh7tJOG2W126
         B9rg==
X-Gm-Message-State: APjAAAVxQN19EIkeQRzl0CqVB73tCTSAfWZDdJH2jTz2BDaDTCdavwNr
        025rqyMBaFNDCL0vYT6TcWhd4NDoi8koVzPEUa8=
X-Google-Smtp-Source: APXvYqw56jHnYByrhWVRv99AbgAADFpMlxvCTekyxBvYS4uOclQHTK3F/5ZNsw+t2CO2FWirC376JqCJzf0p1jvPThM=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr18627571ejq.133.1573403403781;
 Sun, 10 Nov 2019 08:30:03 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191109130301.13716-10-olteanv@gmail.com>
 <20191110162559.GD25889@lunn.ch>
In-Reply-To: <20191110162559.GD25889@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 10 Nov 2019 18:29:52 +0200
Message-ID: <CA+h21hq=Vm+2D+0r7cgMc7T1RR4tQuBw+jTh9SdsbjNHnqcNZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: mscc: ocelot: limit vlan ingress
 filtering to actual number of ports
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 at 18:26, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Nov 09, 2019 at 03:02:55PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The VSC7514 switch (Ocelot) is a 10-port device, while VSC9959 (Felix)
> > is 6-port. Therefore the VLAN filtering mask would be out of bounds when
> > calling for this new switch. Fix that.
>
> Hi Vladimir
>
> Is this a real fix? Should it be posted to net?
>
> Thanks
>         Andrew

Hi Andrew,

Felix is not supported by the mainline ocelot driver yet, so there's
no bug per se: ocelot->num_phys_ports can only be 10 at the moment.

Thanks,
-Vladimir
