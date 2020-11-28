Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005842C6E69
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgK1CRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgK1CP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 21:15:28 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB879206DF;
        Sat, 28 Nov 2020 02:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606529727;
        bh=xXT3LkBPbrcZYd6wpq94vwauy2b5H4Nh2r2UlZm1XlE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WeNye7B1OuFfq7B1hOtk56pDS4eYJCv9fTl4DnwW2niG6j1df2aBCqhMlevVIac1G
         /ehfqz1vZXBfpf7KNtXBnoFs8sGN42tn9lhzN5qilDx+u+WT3DUf5eA7i0kvcrfq42
         wqFfDbMNFuEBMy5Kr4tHS4JO+knblYlPB8G10R1E=
Date:   Fri, 27 Nov 2020 18:15:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127181525.2fe6205d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201128014106.lcqi6btkudbnj3mc@skbuf>
References: <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
        <20201127195057.ac56bimc6z3kpygs@skbuf>
        <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
        <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127233048.GB2073444@lunn.ch>
        <20201127233916.bmhvcep6sjs5so2e@skbuf>
        <20201128000234.hwd5zo2d4giiikjc@skbuf>
        <20201128003912.GA2191767@lunn.ch>
        <20201128014106.lcqi6btkudbnj3mc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 03:41:06 +0200 Vladimir Oltean wrote:
> Jakub, I would like to hear more from you. I would still like to try
> this patch out. You clearly have a lot more background with the code.

Well, I've seen people run into the problem of this NDO not being able
to sleep, but I don't have much background or knowledge of what impact
the locking will have on real systems.

We will need to bring this up with Eric (probably best after the turkey
weekend is over).

In the meantime if you feel like it you may want to add some tracing /
printing to check which processes are accessing /proc/net/dev on your
platforms of interest, see if there is anything surprising.

> You said in an earlier reply that you should have also documented that
> ndo_get_stats64 is one of the few NDOs that does not take the RTNL. Is
> there a particular reason for that being so, and a reason why it can't
> change?

I just meant that as a way of documenting the status quo. I'm not aware
of any other place reading stats under RCU (which doesn't mean it
doesn't exist :)).

That said it is a little tempting to add a new per-netdev mutex here,
instead of congesting RTNL lock further, since today no correct driver
should depend on the RTNL lock.
