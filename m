Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701E3202C77
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 21:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgFUTpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 15:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgFUTpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 15:45:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15319C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 12:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UYvVtsBPfCIcEvW/lZrMDH7BKzR5W3jcQZqmJvpcKuI=; b=i9oR0b39WFv+j0GRKJv/IGCQc
        FGSEAUhmE5p42eX/exVwjecvU18CXvTX1WWwl4+rvMKnrUIUBFHUM4LpCvBB+E/tJga/8wrH4Gx14
        vAqSC5MONsETnIeY5HK47oXRfvH9KhicO1ficitcNtjrikl1CuKI7N5VHv3WBAIZGuIzuP+qWetnJ
        B4SFuxXt4FVe0C91uIBVjy263NLr8iyfYtVSOTbEF8rlU0VP0ek6FPDVu0fdK5TMoHiThdUb1iuzl
        44PJB5N716TyZBSB4s80H2unuCqliwrId1YmIlWzcrBaXrMdyJ18gVqNICCXRorgjyu4NGb3PhDI/
        LAML4uzNg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58914)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jn5u1-00086Y-KE; Sun, 21 Jun 2020 20:45:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jn5ty-0007nC-5M; Sun, 21 Jun 2020 20:45:14 +0100
Date:   Sun, 21 Jun 2020 20:45:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfiler: ipset: fix unaligned atomic access
Message-ID: <20200621194514.GW1551@shell.armlinux.org.uk>
References: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle ping...

This patch fixes a remotely triggerable kernel oops, and as such can
be viewed as a remote denial of service attack depending on the
netfilter rule setup.

On Wed, Jun 10, 2020 at 09:51:11PM +0100, Russell King wrote:
> When using ip_set with counters and comment, traffic causes the kernel
> to panic on 32-bit ARM:
> 
> Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
> Unhandled fault: alignment exception (0x221) at 0xea08133c
> PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]
> 
> The problem occurs when we try to update the 64-bit counters - the
> faulting address above is not 64-bit aligned.  The problem occurs
> due to the way elements are allocated, for example:
> 
> 	set->dsize = ip_set_elem_len(set, tb, 0, 0);
> 	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);
> 
> If the element has a requirement for a member to be 64-bit aligned,
> and set->dsize is not a multiple of 8, but is a multiple of four,
> then every odd numbered elements will be misaligned - and hitting
> an atomic64_add() on that element will cause the kernel to panic.
> 
> ip_set_elem_len() must return a size that is rounded to the maximum
> alignment of any extension field stored in the element.  This change
> ensures that is the case.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> Patch against v5.6, where I tripped over this bug.  This bug has
> caused a kernel panic on my new router twice today.
> 
>  net/netfilter/ipset/ip_set_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 8dd17589217d..be9cd6a500fb 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -459,6 +459,8 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len,
>  	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
>  		if (!add_extension(id, cadt_flags, tb))
>  			continue;
> +		if (align < ip_set_extensions[id].align)
> +			align = ip_set_extensions[id].align;
>  		len = ALIGN(len, ip_set_extensions[id].align);
>  		set->offset[id] = len;
>  		set->extensions |= ip_set_extensions[id].type;
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
