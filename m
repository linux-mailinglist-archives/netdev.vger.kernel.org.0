Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723A22032D6
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgFVJGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgFVJGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:06:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1904C061794;
        Mon, 22 Jun 2020 02:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1PN9BmIl02yr2MOImBWBYlt3OCU+CLnoaLRpCoCXZj8=; b=UqDZYDsTJeNXbR3ME1QqH6NeA
        53qISaaeFxTI8mIMGGkg9sBPCGO1JZycpvXKhFEETpHf5vN52b8UYF+UBU4bKGSHMYcXEQuRB51Jn
        G5wsJQWALUvV40dApWdI/LkhgKQhTFY5ajp5EVvqhUsLBYmTjmTAppb9LumowRp+9HH4KpIxLnxVZ
        DgEpqiIBxyWpjuOOJHBzzj0L6GygopE2y/mH/QwRv4HfDGbUbNZVIqxZ5e57Fv5mmXhgB8JQjbNvd
        DutJP9cu+QutYI3deHGWctM1O/JzfciYeb5Af6kR5i7d5f1i68T1b3X4Jkhgf5eVZtQNwUPwTpKsi
        DK5RJrUfw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58942)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnIPM-0008Ow-3A; Mon, 22 Jun 2020 10:06:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnIPJ-0008Mq-S5; Mon, 22 Jun 2020 10:06:25 +0100
Date:   Mon, 22 Jun 2020 10:06:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfiler: ipset: fix unaligned atomic access
Message-ID: <20200622090625.GA1551@shell.armlinux.org.uk>
References: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
 <20200622082633.GA4512@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622082633.GA4512@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 10:26:33AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 10, 2020 at 09:51:11PM +0100, Russell King wrote:
> > When using ip_set with counters and comment, traffic causes the kernel
> > to panic on 32-bit ARM:
> > 
> > Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
> > Unhandled fault: alignment exception (0x221) at 0xea08133c
> > PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]
> > 
> > The problem occurs when we try to update the 64-bit counters - the
> > faulting address above is not 64-bit aligned.  The problem occurs
> > due to the way elements are allocated, for example:
> > 
> > 	set->dsize = ip_set_elem_len(set, tb, 0, 0);
> > 	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);
> > 
> > If the element has a requirement for a member to be 64-bit aligned,
> > and set->dsize is not a multiple of 8, but is a multiple of four,
> > then every odd numbered elements will be misaligned - and hitting
> > an atomic64_add() on that element will cause the kernel to panic.
> > 
> > ip_set_elem_len() must return a size that is rounded to the maximum
> > alignment of any extension field stored in the element.  This change
> > ensures that is the case.
> 
> Applied, thanks.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
