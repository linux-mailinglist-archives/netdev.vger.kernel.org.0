Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E78845F62F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbhKZVTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:19:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47038 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241141AbhKZVRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 16:17:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8147C6238B
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 21:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD510C004E1;
        Fri, 26 Nov 2021 21:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637961229;
        bh=TtaG26R/6FPIY4UEY2Mnz+yWQ45d3qFyNzXe/ukMnm8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AvPE+xE3keTSy5hnR0qwxfH05mSjPrQM1RF2WlQn2R/R6Og/t9nXpo/PdjWnrgdu7
         UEJbi9FcQk7mo9/LwIe4J4oy0pIFK7zSiaHaqB+gbOIZJeDwj7JGgqL8m3pLjSHdbc
         T4ItibmebiYHstW3eLTBRZkCawjis/PDWgYRyVewDVJ9keKlXiRUz5zsYghtBxFs9z
         96obdLouberkGsSNFRG9Dg7TvVrsYLZX0peNI5QBkNMu+7Oh6+ytSfik/dmcNBENJ7
         8EeFbCLUej+vml+rPbLJh0lCwGZJMsGqePxhCxlX9vZ9MoUz3wIKxFy46Jm2Aqm5ki
         zPbuuim3xmQPQ==
Date:   Fri, 26 Nov 2021 22:13:45 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211126221345.5e17e48d@thinkpad>
In-Reply-To: <YaFHAbXbEH1fokkx@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
        <20211126154249.2958-2-holger.brunck@hitachienergy.com>
        <20211126205625.5c0e38c5@thinkpad>
        <YaFHAbXbEH1fokkx@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 21:43:45 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > > +	if (chip->info->ops->serdes_set_out_amplitude && np) {
> > > +		if (!of_property_read_u32(np, "serdes-output-amplitude",  
> > 
> > Hmm. Andrew, why don't we use <linux/property.h> instead of
> > <linux/of*.h> stuff in this dirver? Is there a reason or is this just
> > because it wasn't converted yet?  
> 
> The problem with device_property_read is that it takes a device. But
> this is not actually a device scoped property, it should be considered
> a port scoped property. And the port is not a device. DSA is not
> likely to convert to the device API because the device API is too
> limiting.

You're right, device_property_read() needs a device, and this seems
like a port-specific property. But from the patch it seems Holger is
using the switch device node:

  struct device_node *np = chip->dev->of_node;

so either this is wrong or he could use device_property API. Of course
that would need a complete conversion, with device_* or fwnode_*.
functions. I was wondering if device_* + fwnode_* functions are
preferred instead of of_* functions (since they can be used also with
ACPI, for example).

Marek
