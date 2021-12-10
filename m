Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5C0470A8A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343662AbhLJTmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:42:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36054 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343661AbhLJTmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:42:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66C7DCE2D26
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 19:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBFCC00446;
        Fri, 10 Dec 2021 19:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639165103;
        bh=aoOA0pMHAABLa1W3yYm9uarwooXzNi/jwYwWfmI/kHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uo4Ycg+mUUsohs7TJTCdYdEyaRkqxmsbjAFfGQ4IKMLr0tmMREgW2lXQM7smL4f2T
         KolNGkP5qEupdbJCagxMSrWLAgjIhmASfyWtHqYDIczIP/KwzUZxXgkVesQojzEwZF
         2lbWJwKwgZ2ZCjmTg6ZN/CoWPu6aYZQ0HS27Z01DowTnICZBGLWZ+bLVnJadM9e4cb
         d3C6Ah/3Iu8Ajz3gAUBxl6/0kaDpvStEUEjbb3tbvIwTxVz254wQiJd6iHEPt+spxN
         JCF71KrafhvlPccQqw9A8ndIW5yYEeR/AHhzHXJGGy61ylZOdtf4Hp1TqkoAGf4yR8
         adLRymFZPFQMA==
Date:   Fri, 10 Dec 2021 11:38:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Amritha Nambiar <amritha.nambiar@intel.com>
Subject: Re: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Message-ID: <20211210113821.522b7c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210115730.bcdh7jvwt24u5em3@skbuf>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
        <20211210115730.bcdh7jvwt24u5em3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 13:57:30 +0200 Vladimir Oltean wrote:
> Is it the canonical approach to perform flow steering via tc-flower hw_tc,
> as opposed to ethtool --config-nfc? My understanding from reading the
> documentation is that tc-flower hw_tc only selects the hardware traffic
> class for a packet, and that this has to do with prioritization
> (although the concept in itself is a bit ill-defined as far as I
> understand it, how does it relate to things like offloaded skbedit priority?).
> But selecting a traffic class, in itself, doesn't (directly or
> necessarily) select a ring per se, as ethtool does? Just like ethtool
> doesn't select packet priority, just RX queue. When the RX queue
> priority is configurable (see the "snps,priority" device tree property
> in stmmac_mtl_setup) and more RX queues have the same priority, I'm not
> sure what hw_tc is supposed to do in terms of RX queue selection?

You didn't mention the mqprio, but I think that's the piece that maps
TCs to queue pairs. You can have multiple queues in a TC.

Obviously that's still pretty weird what the flow rules should select
is an RSS context. mqprio is a qdisc, which means Tx, not Rx.

Adding Amritha who I believe added the concept of selecting Rx queues
via hw_tc. Can you comment?
