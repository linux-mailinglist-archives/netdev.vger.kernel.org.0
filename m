Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3668562414
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389240AbfGHPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:40:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40466 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389237AbfGHP2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:28:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hkVYj-0001pK-2F; Mon, 08 Jul 2019 17:28:05 +0200
Date:   Mon, 8 Jul 2019 17:28:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v5 1/4] net/sched: Introduce action ct
Message-ID: <20190708152805.dul3kgu4csr64fqk@breakpoint.cc>
References: <1562575880-30891-1-git-send-email-paulb@mellanox.com>
 <1562575880-30891-2-git-send-email-paulb@mellanox.com>
 <20190708134208.GD3390@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708134208.GD3390@localhost.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > +	} else { /* NFPROTO_IPV6 */
> > +		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
> > +
> > +		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
> > +		err = nf_ct_frag6_gather(net, skb, user);
> 
> This doesn't build without IPv6 enabled.
> ERROR: "nf_ct_frag6_gather" [net/sched/act_ct.ko] undefined!
> 
> We need to (copy and pasted):
> 
> @@ -179,7 +179,9 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
>                 local_bh_enable();
>                 if (err && err != -EINPROGRESS)
>                         goto out_free;
> -       } else { /* NFPROTO_IPV6 */
> +       }
> +#if IS_ENABLED(IPV6)
> +       else { /* NFPROTO_IPV6 */
>                 enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;

Good catch, but it should be
#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
just like ovs conntrack.c ,
