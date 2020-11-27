Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86D92C6DD0
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgK0Xw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbgK0Xvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 18:51:37 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1102223D;
        Fri, 27 Nov 2020 23:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606521096;
        bh=e/WynABSR586Xm3TdqRpd1/YrC3UavYSw87KE0bTKbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bVqJ68ub5AVU/BHyxtSmH7/oIw2yGBovbukPJKqdSS7FpGr8plK65VcT1l+RGOxOx
         awjhLm1j3pURB3jvm5YcBVB5+ZjhVqPuOR/blKcrB/NUHU6Gl9aA1UwOfVaMRDnepY
         0bnBXY6W25JbSvPPCzFHgPreC7l/YvYmn4FKlTbM=
Date:   Fri, 27 Nov 2020 15:51:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127155135.5beb3106@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127232140.g6ylpsovaj2tcutr@skbuf>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
        <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
        <20201127195057.ac56bimc6z3kpygs@skbuf>
        <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
        <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127232140.g6ylpsovaj2tcutr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 01:21:40 +0200 Vladimir Oltean wrote:
> On Fri, Nov 27, 2020 at 01:37:53PM -0800, Jakub Kicinski wrote:
> > High speed systems are often eventually consistent. Either because
> > stats are gathered from HW periodically by the FW, or RCU grace period
> > has to expire, or workqueue has to run, etc. etc. I know it's annoying
> > for writing tests but it's manageable.  
> 
> Out of curiosity, what does a test writer need to do to get out of the
> "eventual consistency" conundrum in a portable way and answer the
> question "has my packet not been received by the interface or has the
> counter just not updated"?

Retry for a reasonable amount of time for the system state to converge.
E.g. bpftool_prog_list_wait() in selftests/bpf/test_offloads.py, or
check_tables() in selftests/drivers/net/udp_tunnel_nic.sh.

Sadly I was too lazy to open source the driver tests we built at
Netronome.
