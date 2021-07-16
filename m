Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E13CB99C
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhGPPXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:23:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240845AbhGPPXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 11:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+OysL5c8lmZRG64sZoX1J1K8zinYFiO2rvQrX1ZbCWs=; b=A/NZT2E769dhviv4kHLez1dynx
        +Pxl/K1I6GlidVUBIJOkobnassWbC/UfYlAs+ztAiUmTPkIdk9hS6l2qGxW9NUrYOGrhdB19qJ8q6
        XI+629ipGG0ip+k+Ac33TKg1QG7ZLGEZeVp7hB1Q0/azAJJzWK0RZfrKF2h3VYnDbf64=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m4Pd8-00Dd6L-Dg; Fri, 16 Jul 2021 17:19:58 +0200
Date:   Fri, 16 Jul 2021 17:19:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Message-ID: <YPGjnvB92ajEBKGJ@lunn.ch>
References: <20210716141142.12710-1-iivanov@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716141142.12710-1-iivanov@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 05:11:42PM +0300, Ivan T. Ivanov wrote:
> This prevents "No phy led trigger registered for speed(-1)"
> alert message which is coused by phy_led_trigger_chage_speed()
> being called during attaching phy to net_device where phy device
> speed could be still unknown.

Hi Ivan

It seems odd that when attaching the PHY we have link, but not the
speed. What PHY is this?

> -	if (phy->speed == 0)
> +	if (phy->speed == 0 || phy->speed == SPEED_UNKNOWN)
>  		return;

This change makes sense. But i'm wondering if the original logic is
sound. We have link, but no speed information. So the LED trigger is
left in an indeterminate state. Rather than a plain return, maybe
phy_led_trigger_no_link(phy) should be called?

     Andrew
