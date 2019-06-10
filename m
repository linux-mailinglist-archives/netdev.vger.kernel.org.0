Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90413BEDC
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389047AbfFJVpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:45:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387661AbfFJVpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:45:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC5BA3082133;
        Mon, 10 Jun 2019 21:45:13 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30AAB5C219;
        Mon, 10 Jun 2019 21:45:06 +0000 (UTC)
Date:   Mon, 10 Jun 2019 23:45:02 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190610234502.41949c97@redhat.com>
In-Reply-To: <35689c52-0969-0103-663b-c9f909f4c727@gmail.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
        <f5ca22e91017e90842ee00aa4fd41dcdf7a6e99b.1560016091.git.sbrivio@redhat.com>
        <35689c52-0969-0103-663b-c9f909f4c727@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 10 Jun 2019 21:45:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 15:31:37 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/8/19 12:12 PM, Stefano Brivio wrote:
> > To avoid dumping exceptions if not requested, we can, in the future, add
> > support for NLM_F_MATCH as described by RFC 3549. This would also require
> > some changes in iproute2: whenever a 'cache' argument is given,
> > RTM_F_CLONED should be set in the dump request and, when filtering in the
> > kernel is desired, NLM_F_MATCH should be also passed. We can then signal
> > filtering with the NLM_F_DUMP_FILTERED whenever a NLM_F_MATCH flag caused
> > it.  
> 
> NLM_F_MATCH is set today. iproute2 for example uses NLM_F_DUMP for dump
> requests and NLM_F_DUMP is defined as:
> 
> #define NLM_F_DUMP      (NLM_F_ROOT|NLM_F_MATCH)
> 
> further, the kernel already supports kernel side filtering now for
> routes. See ip_valid_fib_dump_req.

Indeed, we don't have to add much: just make this work for IPv4 too,
honour NLM_F_MATCH, and skip filtering (further optimisation) on
NLM_F_DUMP_FILTERED in iproute2 (ip neigh already uses that).

-- 
Stefano
