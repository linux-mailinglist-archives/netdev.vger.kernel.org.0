Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4398B163A86
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 03:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgBSCuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 21:50:23 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:58348 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbgBSCuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 21:50:22 -0500
Received: from utente-Aspire-V3-572G (wireless-130-133.net.uniroma2.it [160.80.133.130])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with SMTP id 01J2nOYa002713;
        Wed, 19 Feb 2020 03:49:29 +0100
Date:   Wed, 19 Feb 2020 03:49:24 +0100
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ahmed.abdelsalam@gssi.it,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it, hiroki.shirokura@linecorp.com
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB
 table
Message-Id: <20200219034924.272d991505ee68d95566ff8d@uniroma2.it>
In-Reply-To: <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
        <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
        <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
        <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
        <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
Thanks for the reply.

The problem is not related to the table lookup. Calling fib_table_lookup and then rt_dst_alloc from seg6_local.c is good.

But after the lookup we need to forward the packet according the matched table entry. This requires to perform all the steps already implemented by ip_route_input_slow function. So we need to call the following functions (defined in route.c):
- rt_cache_valid
- find_exception
- rt_dst_alloc
- rt_set_nexthop
- rt_cache_route

Some of these functions are not exported and so we cannot call them from seg6_local.c
Consequently, we are not able to support all the functionalities implemented by IPv4 routing subsystem.

We are not harming the IPv4 FIB lookup. We introduce a new flag that allows us to re-use all the non exported functions. 

If the flag is not set, the normal IPv4 FIB lookup is the same with no change. 

Thanks,
Carmine


On Tue, 18 Feb 2020 18:05:58 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 2/18/20 4:50 PM, Carmine Scarpitta wrote:
> > Indeed both call fib_table_lookup and rt_dst_alloc are exported for modules. 
> > However, several functions defined in route.c are not exported:
> > - the two functions rt_cache_valid and rt_cache_route required to handle the routing cache
> > - find_exception, required to support fib exceptions.
> > This would require duplicating a lot of the IPv4 routing code. 
> > The reason behind this change is really to reuse the IPv4 routing code instead of doing a duplication. 
> > 
> > For the fi member of the struct fib_result, we will fix it by initializing before "if (!tbl_known)"
> 
> The route.c code does not need to know about the fib table or fib
> policy. Why do all of the existing policy options (mark, L3 domains,
> uid) to direct the lookup to the table of interest not work for this use
> case?


-- 
Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
