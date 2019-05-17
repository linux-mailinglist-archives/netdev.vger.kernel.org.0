Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC2219AD
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfEQORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 10:17:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:56284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728396AbfEQORL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 10:17:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BFF3ACEF;
        Fri, 17 May 2019 14:17:10 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 26832E0184; Fri, 17 May 2019 16:17:09 +0200 (CEST)
Date:   Fri, 17 May 2019 16:17:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        emersonbernier@tutanota.com, dsahern@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
Subject: Re: 5.1 `ip route get addr/cidr` regression
Message-ID: <20190517141709.GA25473@unicorn.suse.cz>
References: <LaeckvP--3-1@tutanota.com>
 <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 12:22:41PM +0200, Jason A. Donenfeld wrote:
> Hi,
> 
> I'm back now and catching up with a lot of things. A few people have
> mentioned to me that wg-quick(8), a bash script that makes a bunch of
> iproute2 invocations, appears to be broken on 5.1. I've distilled the
> behavior change down to the following.
> 
> Behavior on 5.0:
> 
> + ip link add wg0 type dummy
> + ip address add 192.168.50.2/24 dev wg0
> + ip link set mtu 1420 up dev wg0
> + ip route get 192.168.50.0/24
> broadcast 192.168.50.0 dev wg0 src 192.168.50.2 uid 0
>    cache <local,brd>
> 
> Behavior on 5.1:
> 
> + ip link add wg0 type dummy
> + ip address add 192.168.50.2/24 dev wg0
> + ip link set mtu 1420 up dev wg0
> + ip route get 192.168.50.0/24
> RTNETLINK answers: Invalid argument

With recent kernel and iproute2 5.1, I get

  alaris:~ # ip route get 172.17.1.2/24
  Error: ipv4: Invalid values in header for route get request.

This message comes from kernel commit a00302b60777 ("net: ipv4: route:
perform strict checks also for doit handlers") which only considers the
range valid if the prefix is /32 (a single address).

But these checks are only performed when userspace requests strict
validation which iproute2 does since (iproute2) commit aea41afcfd6d ("ip
bridge: Set NETLINK_GET_STRICT_CHK on socket"). So I would say the
change is a result of the combination of kernel (5.1) commit
a00302b60777 and iproute2 (5.0) commit aea41afcfd6d.

> Upon investigating, I'm not sure that `ip route get` was ever suitable
> for getting details on a particular route. So I'll adjust the
> wg-quick(8) code accordingly. But FYI, this is unexpected userspace
> breakage.

AFAIK the purpose of 'ip route get' always was to let the user check
the result of a route lookup, i.e. "what route would be used if I sent
a packet to an address". To be honest I would have to check how exactly
was "ip route get <addr>/<prefixlen>" implemented before.

Michal Kubecek
