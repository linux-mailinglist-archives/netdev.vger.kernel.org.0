Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6B3818E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfFFXHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfFFXHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 19:07:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B27881F31;
        Thu,  6 Jun 2019 23:07:48 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ADEE895BC;
        Thu,  6 Jun 2019 23:07:43 +0000 (UTC)
Date:   Fri, 7 Jun 2019 01:07:39 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190607010739.323502cc@redhat.com>
In-Reply-To: <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
        <20190606231834.72182c33@redhat.com>
        <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 06 Jun 2019 23:07:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 16:47:00 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/6/19 3:18 PM, Stefano Brivio wrote:
> > On Thu, 6 Jun 2019 14:57:33 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> >   
> >>> This will cause a non-trivial conflict with commit cc5c073a693f
> >>> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
> >>> an equivalent patch against net-next, if it helps.
> >>>     
> >>
> >> Thanks for doing this. It is on my to-do list.
> >>
> >> Can you do the same for IPv4?  
> > 
> > You mean this same fix? On IPv4, for flushing, iproute2
> > uses /proc/sys/net/ipv4/route/flush in iproute_flush_cache(), and that
> > works.
> > 
> > Listing doesn't work instead, for some different reason I haven't
> > looked into yet. That doesn't look as critical as the situation on IPv6
> > where one can't even flush the cache: exceptions can also be fetched
> > with 'ip route get', and that works.
> > 
> > Still, it's bad, I can look into it within a few days.
> >   
> 
> I meant the ability to dump the exception cache.
> 
> Currently, we do not get the exceptions in a fib dump. There is a flag
> to only show cloned (cached) entries, but no way to say 'no cloned
> entries'. Maybe these should only be dumped if the cloned flag is set.
> That's the use case I was targeting:
> 1. fib dumps - RTM_F_CLONED not set
> 2. exception dump - RTM_F_CLONED set

I think it would make a lot of sense. But don't we risk breaking
userspace even further, by skipping exceptions if RTM_F_CLONED is not
set? On the other hand, this was broken for almost two years, maybe
it's not too bad after all.

-- 
Stefano
