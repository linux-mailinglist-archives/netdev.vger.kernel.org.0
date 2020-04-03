Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AEB19D7B5
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390901AbgDCNgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:36:42 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42491 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390892AbgDCNgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:36:42 -0400
Received: by mail-yb1-f193.google.com with SMTP id c13so4222166ybp.9;
        Fri, 03 Apr 2020 06:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l1XFoW1CdqWqDnln9s/MFzf+07ncPFrbjj53bimt6iA=;
        b=j3MuJboeAjWjLzCBr8aA/Nz1nJ0wXIVTFddVOBIRc0LwkHXZjJEPvZ4TmvXz7oqAAw
         hYgL5fRmcVB3Uw5BBeBOPpG16ct13k0XwLElliMPdrHspHFrc1xa+Iy626E1alR5vrIU
         ZoXGCKzXhJ2voM65YAF4dyCvkRa+Pl1MepEz/qWlQ72mQpRpF+s8PA7xpCUeT+OSy1MY
         Cs//KhuO6e4UR0zQYd8/lumPHstxE05/uwfdE7gQXs0Mi8osuAW1Exzjn1DzHtTZdPch
         Iysf27AkjgVkITo5fevCEMLzsVPRkTqFesJRvfu6djoJZvLS2Sm4wPpBovzcrixzxcwn
         wNAA==
X-Gm-Message-State: AGi0PuafDh4pf7eCSmeuGMblJJYAlCO93TX3MHDgjRqsS2n6TAZ5Vr1H
        GeI3StccIT3B3nTI9hzLDJbvn45Nk9nDzjvl1D0=
X-Google-Smtp-Source: APiQypKvW041oSol63Gq6mnIxoDINqtJ7TABuWSw3zE7IZFxtUPRl30sOyfCv0NPhXkCVc+cMFJbGTe8xusIF7Y0N+o=
X-Received: by 2002:a25:3d41:: with SMTP id k62mr13561452yba.460.1585920999643;
 Fri, 03 Apr 2020 06:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585917191.git.nicolas.ferre@microchip.com>
In-Reply-To: <cover.1585917191.git.nicolas.ferre@microchip.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Fri, 3 Apr 2020 19:06:28 +0530
Message-ID: <CAFcVECLkPxN0nk=jr9AxJoV3i1jHBoY4s3yeodHDO2uOZspQPg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] net: macb: Wake-on-Lan magic packet fixes
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rafal Ozieblo <rafalo@cadence.com>,
        sergio.prado@e-labworks.com, antoine.tenart@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>, linux@armlinux.org.uk,
        Andrew Lunn <andrew@lunn.ch>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Fri, Apr 3, 2020 at 6:45 PM <nicolas.ferre@microchip.com> wrote:
>
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>
> Hi,
> Here are some of my early patches in order to fix WoL magic-packet on the
> current macb driver.
> Addition of this feature to GEM types of IPs is yet to come. I would like to
> have your feedback on these little patches first so that I can continue
> investigating the addition of GEM WoL magic-packet.
>
> Harini, I know that you have patches for GEM in order to integrate WoL ARP
> mode [1]. I'll try to integrate some of your work but would need that this feature
> is better integrated in current code. For instance, the choice of "magic
> packet" or "ARP" should be done by ethtool options and DT properties. For
> matching with mainline users, MACB and GEM code must co-exist.

Agree. I'll try to test this series and get back to you next week.

> The use of dumb buffers for RX seems also fairly platform specific and we would
> need to think more about it.

I know that the IP versions from r1p10 have a mechanism to disable DMA queues
(bit 0 of the queue pointer register) which is cleaner. But for
earlier IP versions,
I remember discussing with Cadence and there is no way to keep RX
enabled for WOL
with RX DMA disabled. I'm afraid that means there should be a bare
minimum memory
region with a dummy descriptor if you do not want to process the
packets. That memory
should also be accessible while the rest of the system is powered
down. Please let me
know if you think of any other solution.

Regards,
Harini
