Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CAD43078
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388470AbfFLTzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:55:52 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51210 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387605AbfFLTzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:55:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hb9LU-0000SS-4B; Wed, 12 Jun 2019 21:55:44 +0200
Date:   Wed, 12 Jun 2019 21:55:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Message-ID: <20190612195544.zouhfq7xd56fqyhm@breakpoint.cc>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560259713-25603-2-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Blakey <paulb@mellanox.com> wrote:
> +	/* The conntrack module expects to be working at L3. */

It also expects that IP stack has validated ip(v6)
headers and has pulled the ip header into linear area.

What are your plans wrt. IP fragments? AFAICS right now they will
not match which means they won't be NATed either.  Is that ok?

For offloading connection tracking and NAT, I think the flowtable
infrastructure is much better: it will allow any device to push packets
that it can't deal with (fragmented, too large mtu, changed route, etc)
to the software path and conntrack will be aware its dealing with a flow
that was offloaded, e.g. it will elide sequence number checks.

For connection tracking on L2, Pablo recently added conntrack for
classic bridge (without the 'call-iptables' infrastructure), see
net/bridge/netfilter/nf_conntrack_bridge.c (especially the defrag/refrag
and header validation its doing).

I suspect parts of that are also needed in the conntrack action (you
might be able to reuse/export some of the functionality I think).
