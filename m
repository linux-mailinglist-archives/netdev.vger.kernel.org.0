Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0927226E637
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgIQUFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgIQUFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:05:30 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A108214D8;
        Thu, 17 Sep 2020 19:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600371510;
        bh=SWCezRcFBAKbTENW+NhWNgPHMNVasnG2fyA52V/uTV0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Si7rqX8L5Kh3+0UWXib0sMJvuepujPpJqtFpJ2Qq+XQYVz8QW+4BzMwKXQ/kNZdXJ
         tXyi0HNeZ6t2gwAgov7mACzZqC7Zag5f3NA0Bjqq/8HRG8RLLVag8zSgHzg+xIUfGl
         tr80NFpKsC9q5CdWWY6jZF/a0rjzd/CcA7q/dpRU=
Message-ID: <339bb56eebdddbefb5da87d4f97b7bbe74e9f4b4.camel@kernel.org>
Subject: Re: [PATCH V1 net-next 2/8] net: ena: Add device distinct log
 prefix to files
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, sameehj@amazon.com, ndagan@amazon.com,
        amitbern@amazon.com
Date:   Thu, 17 Sep 2020 12:38:28 -0700
In-Reply-To: <pj41zlk0wsdyy7.fsf@u68c7b5b1d2d758.ant.amazon.com>
References: <20200913081640.19560-1-shayagr@amazon.com>
         <20200913081640.19560-3-shayagr@amazon.com>
         <20200913.143022.1949357995189636518.davem@davemloft.net>
         <pj41zlk0wsdyy7.fsf@u68c7b5b1d2d758.ant.amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 21:45 +0300, Shay Agroskin wrote:
> David Miller <davem@davemloft.net> writes:
> 
> > From: Shay Agroskin <shayagr@amazon.com>
> > Date: Sun, 13 Sep 2020 11:16:34 +0300
> > 
> > > ENA logs are adjusted to display the full ENA representation to
> > > distinct each ENA device in case of multiple interfaces.
> > > Using dev_err/warn/info function family for logging provides 
> > > uniform
> > > printing with clear distinction of the driver and device.
> > > 
> > > This patch changes all printing in ena_com files to use dev_* 
> > > logging
> > > messages. It also adds some log messages to make driver 
> > > debugging
> > > easier.
> > > 
> > > Signed-off-by: Amit Bernstein <amitbern@amazon.com>
> > > Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> > 
> > This device prefix is so much less useful than printing the 
> > actual
> > networking adapter that the ena_com operations are for.
> > 
> > So if you are going to do this, go all the way and pass the 
> > ena_adapter
> > or the netdev down into these ena_com routines so that you can 
> > use
> > the netdev_*() message helpers.
> > 
> > Thank you.
> 
> Hi David, I researched the possibility to use netdev_* functions 
> in this patch. Currently our driver initializes the net_device 
> only after calling some functions in ena_com files.
> Although netdev_* log family functions can be used before 
> allocating a net_device struct, the print it produces in such a 
> case is less informative than the dev_* log print (which at least 
> specifies what pcie device made the print).
> 
> I would rather change the allocation order for the net_device 
> struct in our driver, so that when calling ena_com device it would 
> always be allocated (and this way all ena_com prints could be 
> transformed into netdev/netif_* log family).
> This change seems doable, but requires us to do some internal 
> testing before sending it. I could remove this whole patch, but 
> then our driver would be left with pr_err() functions in it which 
> is even less informative than dev_err().
> 

allocated but unregistered netdevices also do not help much as the name
of the netdev is not assigned yet.

why don't use dev_info(pci_dev) macors  for low level functions when
netdev is not available or not allocated yet.

> Can we go through with this patch, and send a future patch which 
> changes all dev_* functions into netif/netdev_* along with the 
> change in the allocation order of the net_device struct ? I know 
> it sounds like a procrastination attempt, but I would really 
> prefer not to drop the patch and leave the driver with pr_* log 
> prints.
> 
> Thanks,
> Shay

