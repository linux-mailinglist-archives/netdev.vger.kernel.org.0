Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEB138270
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 03:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfFGByX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 21:54:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFGByX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 21:54:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2179F87621;
        Fri,  7 Jun 2019 01:54:23 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9EF4784B3;
        Fri,  7 Jun 2019 01:54:20 +0000 (UTC)
Date:   Fri, 7 Jun 2019 03:54:16 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190607035416.299f8f4b@redhat.com>
In-Reply-To: <b77803b0-3d9e-6d1e-54a3-8c4eac49ca2c@gmail.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
        <20190607001747.4ced02c7@redhat.com>
        <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
        <b77803b0-3d9e-6d1e-54a3-8c4eac49ca2c@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 07 Jun 2019 01:54:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 16:48:51 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/6/19 4:37 PM, Martin Lau wrote:
> >> I don't think that can happen in practice, or at least I haven't found a
> >> way to create enough valid exceptions for the same node.  
> > That I am not sure.  It is not unusual to have many pmtu exceptions in
> > a gateway node.
> >   
> 
> yes.
> 
> Stefano: you could generalize this test script
>    http://patchwork.ozlabs.org/patch/1110802/
> to have N-remote hosts

Right, thanks for the pointer. I ended up doing something like that in
pmtu.sh, and it turns out that, starting from 25 exceptions in the same
node, iproute2 doesn't actually retry with a larger buffer. As Martin
predicted (thanks!) the dump doesn't terminate.

I tested a version that counts the number of routes in a partial dump
and skips them on the next one with 10,000 entries, dump terminates and
entries count is consistent (at some point, the buckets are just full,
and number of entries doesn't increase any longer).

Unfortunately, the setup of the test takes a few minutes, so I wouldn't
include it (at least as it is) in the selftest.

I'll post that as v2 soon.

-- 
Stefano
