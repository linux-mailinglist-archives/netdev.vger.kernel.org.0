Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A497444CCA5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhKJW14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:27:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233552AbhKJW1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 17:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6c7O9hvf//7ub1+0PLLd9pZ0Zd9X3mBxwS7SrJoaOIw=; b=aQMlY2ZIhrflITkxdfmcBwng62
        wFM9qpYp8HuEJd6lyYIrJXjB3i4EPMasctvzVpUopFvVd5a1dywemthxZO5ivY0/UomxgPdqFOZpy
        grMYLlM87sH6DmRsfZHkYh7S/TeX0cr24HjK/VdzLAuR70oJz7ok54yDgvktn+eviZLk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkw1a-00D937-Nb; Wed, 10 Nov 2021 23:24:58 +0100
Date:   Wed, 10 Nov 2021 23:24:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/8] leds: add function to configure hardware
 controlled LED
Message-ID: <YYxGuloRkpsCI1oJ@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-3-ansuelsmth@gmail.com>
 <20211109040103.7b56bf82@thinkpad>
 <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
 <YYre31rVDcs8OWre@lunn.ch>
 <YYwisR8XLL7TnwCB@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYwisR8XLL7TnwCB@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If we should reuse blink_set to control hw blink I need to understand 2
> thing.
> 
> The idea to implement the function hw_control_configure was to provide
> the triggers some way to configure the various blink_mode. (and by using
> the cmd enum provide different info based on the return value)
> 
> The advised path from Marek is to make the changes in the trigger_data
> and the LED driver will then use that to configure blink mode.
> 
> I need to call an example to explain my concern:
> qca8k switch. Can both run in hardware mode and software mode (by
> controlling the reg to trigger manual blink) and also there is an extra
> mode to blink permanently at 4hz.
> 
> Now someone would declare the brightness_set to control the led
> manually and blink_set (for the permanent 4hz blink feature)
> So that's where my idea comes about introducting another function and
> the fact that it wouldn't match that well with blink_set with some LED.
> 
> I mean if we really want to use blink_set also for this(hw_control), we
> can consider adding a bool to understand when hw_control is active or not.
> So blink_set can be used for both feature.

I don't see why we need the bool. The driver should know that speeds
it supports. If asked to do something it cannot do in the current mode
it should return either -EINVAL, or maybe -EOPNOTSUPP. Depending on
how to the trigger works, we might want -EOPNOTSUPP when in a hardware
offload mode, which gets returned to user space. If we are in a
software blinking mode -EINVAL, so that the trigger does the blinking
in software.

   Andrew
