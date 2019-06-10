Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1433BF94
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390400AbfFJWsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390139AbfFJWsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 18:48:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE30E81E00;
        Mon, 10 Jun 2019 22:48:08 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32B5360C18;
        Mon, 10 Jun 2019 22:48:02 +0000 (UTC)
Date:   Tue, 11 Jun 2019 00:47:58 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Martin KaFai Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached
 route exceptions
Message-ID: <20190611004758.1e302288@redhat.com>
In-Reply-To: <20190610235315.46faca79@redhat.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
        <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
        <20190610235315.46faca79@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 10 Jun 2019 22:48:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 23:53:15 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Mon, 10 Jun 2019 15:38:06 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
> > in dot releases of stable trees, I think it would be better to converge
> > on consistent behavior between v4 and v6. By that I mean without the
> > CLONED flag, no exceptions are returned (default FIB dump). With the
> > CLONED flag only exceptions are returned.  
> 
> Again, this needs a change in iproute2, because RTM_F_CLONED is *not*
> passed on 'flush'. And sure, let's *also* do that, but not everybody
> runs recent versions of iproute2.

One thing that sounds a bit more acceptable to me is:

- dump (in IPv4 and IPv6):
  - regular routes only, if !RTM_F_CLONED and NLM_F_MATCH
  - exceptions only, if RTM_F_CLONED and NLM_F_MATCH
  - everything if !NLM_F_MATCH

- fix iproute2 so that RTM_F_CLONED is passed on 'flush cache', or
  don't pass NLM_F_MATCH in that case

this way, the kernel respects the intended semantics of flags, and we
fix a bug in iproute2 (that was always present).

I think it's not ideal, because the kernel unexpectedly changed the
behaviour and we're not guaranteeing that older iproute2 works. The
fact it was broken for two years is probably a partial excuse for this,
though.

What do you think? I'll prepare a v4 for net-next if we all agree.

I'm not entirely sure which trees I should target. I guess this
introduces a feature in the kernel, so net-next, and fixes a bug in
iproute2, so iproute2.git?

-- 
Stefano
