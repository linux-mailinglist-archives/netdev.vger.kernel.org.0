Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD43BEF2
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfFJVxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbfFJVxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:53:30 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E2D5307D84F;
        Mon, 10 Jun 2019 21:53:25 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B53F10013D9;
        Mon, 10 Jun 2019 21:53:19 +0000 (UTC)
Date:   Mon, 10 Jun 2019 23:53:15 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached
 route exceptions
Message-ID: <20190610235315.46faca79@redhat.com>
In-Reply-To: <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
        <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 10 Jun 2019 21:53:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 15:38:06 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/8/19 12:12 PM, Stefano Brivio wrote:
> > The commands 'ip -6 route list cache' and 'ip -6 route flush cache'
> > don't work at all after route exceptions have been moved to a separate
> > hash table in commit 2b760fcf5cfb ("ipv6: hook up exception table to store
> > dst cache"). Fix that.  
> 
> The breakage is the limited ability to remove exceptions. Yes, you can
> delete a v6 exception route if you know it exists. Without the ability
> to list them, you have to guess.
> 
> The ability to list exceptions was deleted 2 years ago with 4.15. So far
> no one has complained that exceptions do not show up in route dumps.

I am doing it right now...

> Rather than perturb the system again and worse with different behaviors,

Well, I'm just trying to restore the behaviour before 2b760fcf5cfb
it's not "different".

I don't think 2b760fcf5cfb intended to break iproute2 like that.

> in dot releases of stable trees, I think it would be better to converge
> on consistent behavior between v4 and v6. By that I mean without the
> CLONED flag, no exceptions are returned (default FIB dump). With the
> CLONED flag only exceptions are returned.

Again, this needs a change in iproute2, because RTM_F_CLONED is *not*
passed on 'flush'. And sure, let's *also* do that, but not everybody
runs recent versions of iproute2.

-- 
Stefano
