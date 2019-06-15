Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3201246DF8
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfFODNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfFODNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 23:13:49 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D47F30821BE;
        Sat, 15 Jun 2019 03:13:49 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9266F60469;
        Sat, 15 Jun 2019 03:13:46 +0000 (UTC)
Date:   Sat, 15 Jun 2019 05:13:42 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
Message-ID: <20190615051342.7e32c2bb@redhat.com>
In-Reply-To: <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
        <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
        <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sat, 15 Jun 2019 03:13:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 20:54:49 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/14/19 7:32 PM, Stefano Brivio wrote:
> > ip_valid_fib_dump_req() does two things: performs strict checking on
> > netlink attributes for dump requests, and sets a dump filter if netlink
> > attributes require it.
> > 
> > We might want to just set a filter, without performing strict validation.
> > 
> > Rename it to ip_filter_fib_dump_req(), and add a 'strict' boolean
> > argument that must be set if strict validation is requested.
> > 
> > This patch doesn't introduce any functional changes.
> > 
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> > v4: New patch
> >   
> 
> Can you explain why this patch is needed? The existing function requires
> strict mode and is needed to enable any of the kernel side filtering
> beyond the RTM_F_CLONED setting in rtm_flags.

It's mostly to have proper NLM_F_MATCH support. Let's pick an iproute2
version without strict checking support (< 5.0), that sets NLM_F_MATCH
though. Then we need this check:

	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm)))

and to set filter parameters not just based on flags (i.e. RTM_F_CLONED),
but also on table, protocol, etc.

For example one might want to: 'ip route list cache table main', and this
is then taken into account in fn_trie_dump_leaf() and rt6_dump_route().

Reusing this function avoids a nice amount of duplicated code and allows
to have an almost common path with strict checking.

-- 
Stefano
