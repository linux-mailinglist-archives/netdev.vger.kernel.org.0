Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3134E2B812B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgKRPua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgKRPua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 10:50:30 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1296247A7;
        Wed, 18 Nov 2020 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605714629;
        bh=Yo6sgm3/oVDnxAfTnq6e5gCNuPqh+2emIPWFYlwhGqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VH8oIO/j4mWTpk4EDah65F4S3YHfWS5i0UHsxNXKM8HSgO8q4OaKUTBepivjyt36W
         Fyj56OvOuMTaKIqiUMWgsccxZx1PoB8MwbQjMBLb+r3eJ0BWWmhZeuCgwybd1tUlBu
         H/5y1988557KuNncf6FSOSvgwNdAvTCmjpobasPQ=
Date:   Wed, 18 Nov 2020 07:50:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V5] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201118075027.18083d19@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <175db965378.e5454e1c360034.2264030307026794920@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175db965378.e5454e1c360034.2264030307026794920@shytyi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 14:41:03 +0100 Dmytro Shytyi wrote:
>  > > @@ -2576,9 +2590,42 @@ int addrconf_prefix_rcv_add_addr(struct 
>  > >                   u32 addr_flags, bool sllao, bool tokenized, 
>  > >                   __u32 valid_lft, u32 prefered_lft) 
>  > >  { 
>  > > -    struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1); 
>  > > +    struct inet6_ifaddr *ifp = NULL; 
>  > >      int create = 0; 
>  > > 
>  > > +    if ((in6_dev->if_flags & IF_RA_VAR_PLEN) == IF_RA_VAR_PLEN && 
>  > > +        in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY) { 
>  > > +        struct inet6_ifaddr *result = NULL; 
>  > > +        struct inet6_ifaddr *result_base = NULL; 
>  > > +        struct in6_addr curr_net_prfx; 
>  > > +        struct in6_addr net_prfx; 
>  > > +        bool prfxs_equal; 
>  > > + 
>  > > +        result_base = result; 
>  > > +        rcu_read_lock(); 
>  > > +        list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) { 
>  > > +            if (!net_eq(dev_net(ifp->idev->dev), net)) 
>  > > +                continue; 
>  > > +            ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo->prefix_len); 
>  > > +            ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinfo->prefix_len); 
>  > > +            prfxs_equal = 
>  > > +                ipv6_prefix_equal(&net_prfx, &curr_net_prfx, pinfo->prefix_len); 
>  > > + 
>  > > +            if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) { 
>  > > +                result = ifp; 
>  > > +                in6_ifa_hold(ifp); 
>  > > +                break; 
>  > > +            } 
>  > > +        } 
>  > > +        rcu_read_unlock(); 
>  > > +        if (result_base != result) 
>  > > +            ifp = result; 
>  > > +        else 
>  > > +            ifp = NULL;   
>  >  
>  > Could this be a helper of its own?   
> 
> Explain the thought please. It is not clear for me.

At the look of it the code under this if statement looks relatively
self-contained, and has quite a few local variables. Rather than making
the surrounding function longer would it be possible to factor it out
into a helper function?
