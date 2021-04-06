Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137A8354F48
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbhDFJAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:00:01 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:49029 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240027AbhDFJAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 05:00:01 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8D3C222235;
        Tue,  6 Apr 2021 10:59:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1617699592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbwVJsNYcsSYWXReorOYmMOoVZ4sVmZ9fSelanLzWis=;
        b=E9Aqv7RBETzefJJWhBOmDJpuL4LEfbgvQ7mqXsmegJZeDNSscz8rcg1/HHzT32tvBey5Ot
        EGq3bRjeR54TD5n5ZTcbiX0JzAJCZ64+ihr4Ce1T8PwOaLrjG5ZEzykuSiEa5z8pP/SVqr
        J20h5Qplf9hKQNoB+SMLZwo6yId7FHE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Apr 2021 10:59:52 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] of: net: fix of_get_mac_addr_nvmem() for PCI and DSA
 nodes
In-Reply-To: <YGuLjiozGIxsGYQy@lunn.ch>
References: <20210405164643.21130-1-michael@walle.cc>
 <20210405164643.21130-3-michael@walle.cc> <YGuCblk9vvmD0NiH@lunn.ch>
 <2d6eef78762562bcbb732179b32f0fd9@walle.cc> <YGuLjiozGIxsGYQy@lunn.ch>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <1b7e58ba2ec798ddda77a9a3ab72338c@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-04-06 00:13, schrieb Andrew Lunn:
> On Mon, Apr 05, 2021 at 11:46:04PM +0200, Michael Walle wrote:
>> Hi Andrew,
>> 
>> Am 2021-04-05 23:34, schrieb Andrew Lunn:
>> > > -static int of_get_mac_addr_nvmem(struct device_node *np, u8 addr)
>> > > +static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
>> > >  {
>> > >  	struct platform_device *pdev = of_find_device_by_node(np);
>> > > +	struct nvmem_cell *cell;
>> > > +	const void *mac;
>> > > +	size_t len;
>> > >  	int ret;
>> > >
>> > > -	if (!pdev)
>> > > -		return -ENODEV;
>> > > +	/* Try lookup by device first, there might be a nvmem_cell_lookup
>> > > +	 * associated with a given device.
>> > > +	 */
>> > > +	if (pdev) {
>> > > +		ret = nvmem_get_mac_address(&pdev->dev, addr);
>> > > +		put_device(&pdev->dev);
>> > > +		return ret;
>> > > +	}
>> >
>> > Can you think of any odd corner case where nvmem_get_mac_address()
>> > would fail, but of_nvmem_cell_get(np, "mac-address") would work?
>> 
>> You mean, it might make sense to just return here when
>> nvmem_get_mac_address() will succeed and fall back to the
>> of_nvmem_cell_get() in case of an error?
> 
> I've not read the documentation for nvmem_get_mac_address(). I was
> thinking we might want to return real errors, and -EPROBE_DEFER.

I can't follow, nvmem_get_mac_address() should already return those.

> But maybe with -ENODEV we should try of_nvmem_cell_get()?

And if this happens - that is nvmem_get_mac_address(&pdev->dev) returns
-ENODEV - then of_nvmem_cell_get(np) will also return -ENODEV.

Because pdev->dev.of_node == np and nvmem_get_mac_address(&pdev->dev)
tries of_nvmem_cell_get(pdev->dev.of_node) first.

> But i'm not sure if there are any real use cases? The only thing i can
> think of is if np points to something deeper inside the device tree
> than what pdev does?

But then pdev will be NULL and nvmem_get_mac_address() won't be called
at all, no?

-michael
