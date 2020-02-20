Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C612166A69
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 23:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgBTWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 17:38:37 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:58786 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729006AbgBTWih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 17:38:37 -0500
Received: from utente-Aspire-V3-572G ([160.80.225.138])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with SMTP id 01KMXax2031786;
        Thu, 20 Feb 2020 23:33:41 +0100
Date:   Thu, 20 Feb 2020 23:33:36 +0100
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ahmed.abdelsalam@gssi.it,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it, hiroki.shirokura@linecorp.com
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB
 table
Message-Id: <20200220233336.53eda87e7a76ed24317e0165@uniroma2.it>
In-Reply-To: <a39867b0-c40f-e588-6cf9-1524581bb145@gmail.com>
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
        <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
        <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
        <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
        <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
        <20200219034924.272d991505ee68d95566ff8d@uniroma2.it>
        <a39867b0-c40f-e588-6cf9-1524581bb145@gmail.com>
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

Regarding your question. 

Our use-case is more than doing lookup into a VRF. 

What we are working on a multi-tenant automated DC fabric that supports 
overlay, traffic engineering (TE) and service function chaining (SFC). 
We are leveraging the SRv6 implementation in Linux. 
 
For the overlay we leverage: 
- SRv6 T.Encaps to encapsulate both IPv4 and IPv6 traffic of the tenant 
   (T.Encaps is supported since kernel 4.10) 
- SRv6 End.DT4 to decapsulate the overlay encapsulation and does the 
lookup inside the tenants VRF (this is the only missing piece)

For TE we leverage: 
- SRv6 End and End.X functions to steer traffic through one or more midpoints
to avoid congested links, etc. (End and End.X are supported since kernel 4.14)

For SFC we leverage some network functions that supports SRv6: 
- iptables already supports matching SRv6 header since kernel 4.16. 
- There is some work in progress of adding support to nftables as well. 

On top of that we are using BGP as a control plane to advertise the VPN/Egress 
tunnel endpoints. 

Part of this is already running in production at LINE corporation [1]. 

As you can see, what is missing is having SRv6 End.DT4 supported to do 
decapsulation and VRF lookup.  

We introduced this flag to avoid duplicating the IPv4 FIB lookup code. 

For the "tbl_known" flag, we can wrap the check of the flag inside 
a "#ifdef CONFIG_IP_MULTIPLE_TABLES" directive. 
If CONFIG_IP_MULTIPLE_TABLES is not set, we won't do any check.  

Thanks, 
Carmine 


[1] https://speakerdeck.com/line_developers/line-data-center-networking-with-srv6


On Tue, 18 Feb 2020 21:29:31 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 2/18/20 7:49 PM, Carmine Scarpitta wrote:
> > Hi David,
> > Thanks for the reply.
> > 
> > The problem is not related to the table lookup. Calling fib_table_lookup and then rt_dst_alloc from seg6_local.c is good.
> > 
> 
> you did not answer my question. Why do all of the existing policy
> options (mark, L3 domains, uid) to direct the lookup to the table of
> interest not work for this use case?
> 
> What you want is not unique. There are many ways to make it happen.
> Bleeding policy details to route.c and adding a flag that is always
> present and checked even when not needed (e.g.,
> CONFIG_IP_MULTIPLE_TABLES is disabled) is not the right way to do it.


-- 
Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
