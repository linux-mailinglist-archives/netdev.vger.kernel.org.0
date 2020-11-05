Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10A12A832A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbgKEQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKEQNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:13:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84020206B7;
        Thu,  5 Nov 2020 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604592781;
        bh=EGZD2xVzdxFBONZBov4FBPIXr8C38Hi/M+WKt0XRBdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mkPhgOnbtXVFVLLRDBPsgy2YEOqAuOBusTXLSNqsGOVxELwSOyrx305cV1L/caBcX
         XC5Q7cC5OM1oOZis34EL3UPplSeQkJoDfWNTBElpflK6MB+nflUhrW/ypqYkMQ+WAz
         neI/57VcUi22TLA/MmTyBMjsisEwTueWC+V+qQ5k=
Date:   Thu, 5 Nov 2020 08:13:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Plotnikov <wgh@torlan.ru>
Subject: Re: [PATCH net] r8169: work around short packet hw bug on RTL8125
Message-ID: <20201105081300.111a974b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4bd669af-847f-020e-9c80-51ff325b4cbc@gmail.com>
References: <8002c31a-60b9-58f1-f0dd-8fd07239917f@gmail.com>
        <20201104174521.2a902678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4bd669af-847f-020e-9c80-51ff325b4cbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 11:31:48 +0100 Heiner Kallweit wrote:
> >> @@ -4125,7 +4133,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
> >>  
> >>  		opts[1] |= transport_offset << TCPHO_SHIFT;
> >>  	} else {
> >> -		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
> >> +		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
> >>  			return !eth_skb_pad(skb);
> >>  	}  
> > 
> > But looks like we may have another bug here - looks like this function
> > treas skb_cow_head() and eth_skb_pad() failures the same, but former
> > doesn't free the skb on error, while the latter does.
> >   
> Thanks for the hint, indeed we have an issue. The caller of
> rtl8169_tso_csum_v2() also frees the skb if false is returned, therefore
> we have a double free if eth_skb_pad() fails.
> 
> When checking eth_skb_pad() I saw that it uses kfree_skb() to free
> the skb on error. Kernel documentation say about ndo_start_xmit context:
> 
> Process with BHs disabled or BH (timer),
> will be called with interrupts disabled by netconsole.
> 
> Is it safe to use kfree_skb() if interrupts are disabled?
> I'm asking because dev_kfree_skb_any() uses the irq path if
> irqs_disabled() is true.

It is not, although in practice it only matters if skb has a socket
attached, and AFAIR netconsole doesn't, so no-one has ever seen the
WARN() trigger. But yes, I think it's best if we fix it.
