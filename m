Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8345618A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhKRRgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232058AbhKRRgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 12:36:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D05D161A4E;
        Thu, 18 Nov 2021 17:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637256795;
        bh=5A3tq8DYT9yuj187AD/pOVW/Pm9IyItmt4CU+qubtqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nsdKbIMCRgFEgZKhaXzlPmE8mHw+IIMHOxvT50csEAK0fqUAUil7ksgeVQ0+vGtGV
         M51yepCgsyxcc7IaYo1kSL8ZO9m6uLcvhUycAmgkqnS29Zc0MtwBhScuAkhpsNrJzv
         NujM5+nEf8Zl9OWunOR7hDCp5ItLqaHhEzQtxUrFip8lq+LhebHn2pNyAtxB43GJES
         cglO6g+dl6ap8/KBiRin7jYWT+iyguGjDYkYuXiV8RVZrVltFf2S45ZaRk4u/mcuhp
         oX4QIKa2HJFAIMWzLEJ0XVkM8NqqSmRBCTzQzmJfkRiwWogeXDJGv9fltY1TWzfAz0
         JIuXKcHo12Pow==
Date:   Thu, 18 Nov 2021 18:33:01 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: phylink: update supported_interfaces
 with modes from fwnode
Message-ID: <20211118183301.50dab085@thinkpad>
In-Reply-To: <YZaIeiOyhqyVNG8D@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
        <20211117225050.18395-5-kabel@kernel.org>
        <YZYXctnC168PrV18@shell.armlinux.org.uk>
        <YZaAXadMIduFZr08@lunn.ch>
        <YZaIeiOyhqyVNG8D@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 17:08:10 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> I'm quite certain that as we try to develop phylink, such as adding
> extra facilities like specifying the interface modes, we're going to
> end up running into these kinds of problems that we can't solve, and
> we are going to have to keep compatibility for the old ways of doing
> stuff going for years to come - which is just going to get more and
> more painful.

One way to move this forward would be to check compatible of the
corresponding MAC in this new function. If it belongs to an unconverted
driver, we can ensure the old behaviour. This would require to add a
comment to the driver saying "if you convert this, please drop the
exception in phylink_update_phy_modes()".

Yes, it is an ugly solution, but it would work and this function
already is meant to be solving backward compatibility problems by such
mechanisms. The comment says:

+	 * Nonetheless it is possible that a device may support only one mode,
+	 * for example 1000base-x, due to strapping pins or some other reasons.
+	 * If a specific device supports only the mode mentioned in DT, the
+	 * exception should be made here with of_machine_is_compatible().

BTW, I now realize that of_machine_is_compatible() is not the best
solution. I will change the comment in v2.

Marek
