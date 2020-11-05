Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201122A8A0E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgKEWrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKEWrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:47:13 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C17206CA;
        Thu,  5 Nov 2020 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604616433;
        bh=lo0qvpNqTeAP2Fp45UArIPD/pd830raxQiD/NBJ10R0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wblvq+BaW+NzyZN49DiroXl+Vd2hlyS+8kJzkOr3dypLRV3Jgttb5m99PLu3+iG4b
         v8ZyDeyBwlYP8iYEYQ5KQFTaVyAL4MYJulJw8S6tfr0zrO8mIS72k20GB6hA+bO1Sp
         G4FDhz65Ru0pfb4XkUdPGM/OqhabyUhYWCHESlsE=
Date:   Thu, 5 Nov 2020 14:47:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH net-next v2 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
Message-ID: <20201105144711.40a2f8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104154858.1247725-7-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
        <20201104154858.1247725-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 16:48:57 +0100 Andrew Lunn wrote:
> -	buf = (char*)((u32)skb->data & ~0x3);
> -	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
> -	cmdA = (((u32)skb->data & 0x3) << 16) |
> +	offset = (unsigned long)skb->data & 3;
> +	buf = skb->data - offset;
> +	len = skb->len + offset;
> +	cmdA = (offset << 16) |

The len calculation is wrong, you trusted people on the mailing list 
too much ;)

This is better:

-	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
+	len = round_up(skb->len, 4);

You can also do PTR_ALIGN_DOWN() for the skb->data if you want.
And give the same treatment to the other side of the #if statement.
