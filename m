Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88514E025
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgA3RpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:45:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgA3RpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 12:45:01 -0500
Received: from cakuba (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A634620661;
        Thu, 30 Jan 2020 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580406300;
        bh=0lGHFh39aCiLxW2RkEr9d95aaqsr5RGhb2aZy9Yz9QU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lvAZGC7LHmMj1JVSphBSawb8W9+gmxIGvTM8DWDONViTi7o4TvjjyyRKbXeIVm9qT
         z1QVnaCNtKurLeIDKPGAjyVIEMJLLWlNNfklvceMfrAxpuSsHkb1EFR+uplVbYCbPJ
         eBEUAI4eDCZ8txjHUJBZaizYCxVLSaNEyVgQ0tvg=
Date:   Thu, 30 Jan 2020 09:44:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 1/6] netdevsim: fix race conditions in netdevsim
 operations
Message-ID: <20200130094459.22649bb8@cakuba>
In-Reply-To: <CAMArcTV9bt7SEo2010JBUj3DQAakFmkHD3hWTiMj-0kW+RVXDQ@mail.gmail.com>
References: <20200127142957.1177-1-ap420073@gmail.com>
        <20200127065755.12cf7eb6@cakuba>
        <CAMArcTV9bt7SEo2010JBUj3DQAakFmkHD3hWTiMj-0kW+RVXDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 00:09:43 +0900, Taehee Yoo wrote:
> > > @@ -99,6 +100,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
> > >       unsigned int port_index;
> > >       int ret;
> > >
> > > +     if (!nsim_bus_dev->init)
> > > +             return -EBUSY;  
> >
> > I think we should use the acquire/release semantics on those variables.
> > The init should be smp_store_release() and the read in ops should use
> > smp_load_acquire().
> 
> Okay, I will use a barrier for the 'init' variable.
> Should a barrier be used for 'enable' variable too?
> Although this value is protected by nsim_bus_dev_list_lock,
> I didn't use the lock for this value in the nsim_bus_init()
> because I thought it's enough.

To be clear I think the code as you wrote it would behave correctly
(it's reasonable to expect that the call to driver_register() implies
a barrier).

> How do you think about this? Should lock or barrier is needed?

IMO having both of the flag variables have the load/store semantics
(that's both 'init' and 'enable') is just less error prone and easier
to understand.

And then the locks can go back to only protecting the lists, I think.
