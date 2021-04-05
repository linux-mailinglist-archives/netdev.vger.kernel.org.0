Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1822B354844
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbhDEVqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:46:18 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:42975 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbhDEVqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 17:46:13 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 638C022205;
        Mon,  5 Apr 2021 23:46:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1617659164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGc6+pNwUIEJINUyeKfGxDfR2I85aCG9F5OErf5tqgU=;
        b=uT3dbgyROQHGQCGeMVAnXIsXA2chGRheWy8mIezVELYVzX197iRh8GUNslhH2UVZ8KrVRv
        9BWqdJSw9wcrhnTOlrBHEJjBJZ+ZVCRxVATDj7QoWBQQA8X6QT2U/dg+kr1YotfZQULdCb
        0n7FHH/Ci6cnGAooiRQ5KeWKnrWWDdY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 05 Apr 2021 23:46:04 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] of: net: fix of_get_mac_addr_nvmem() for PCI and DSA
 nodes
In-Reply-To: <YGuCblk9vvmD0NiH@lunn.ch>
References: <20210405164643.21130-1-michael@walle.cc>
 <20210405164643.21130-3-michael@walle.cc> <YGuCblk9vvmD0NiH@lunn.ch>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <2d6eef78762562bcbb732179b32f0fd9@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 2021-04-05 23:34, schrieb Andrew Lunn:
>> -static int of_get_mac_addr_nvmem(struct device_node *np, u8 addr)
>> +static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
>>  {
>>  	struct platform_device *pdev = of_find_device_by_node(np);
>> +	struct nvmem_cell *cell;
>> +	const void *mac;
>> +	size_t len;
>>  	int ret;
>> 
>> -	if (!pdev)
>> -		return -ENODEV;
>> +	/* Try lookup by device first, there might be a nvmem_cell_lookup
>> +	 * associated with a given device.
>> +	 */
>> +	if (pdev) {
>> +		ret = nvmem_get_mac_address(&pdev->dev, addr);
>> +		put_device(&pdev->dev);
>> +		return ret;
>> +	}
> 
> Can you think of any odd corner case where nvmem_get_mac_address()
> would fail, but of_nvmem_cell_get(np, "mac-address") would work?

You mean, it might make sense to just return here when
nvmem_get_mac_address() will succeed and fall back to the
of_nvmem_cell_get() in case of an error?

nvmem_get_mac_address() will first try to do the lookup by the
of_node of pdev->dev; and because np is used to find the pdev, it should
work for the same cases where of_nvmem_cell_get(np) will work.

I'm fine with either, maybe the fallback to of_nvmem_cell_get()
is clearer.

-michael
