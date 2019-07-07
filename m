Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B85614DD
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 14:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfGGMFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 08:05:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35320 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfGGMFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 08:05:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hk5uZ-0003Jp-Tj; Sun, 07 Jul 2019 14:04:55 +0200
Date:   Sun, 7 Jul 2019 14:04:55 +0200
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
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v4 1/4] net/sched: Introduce action ct
Message-ID: <20190707120455.6li4tfb5ppht4xy7@breakpoint.cc>
References: <1562486612-22770-1-git-send-email-paulb@mellanox.com>
 <1562486612-22770-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562486612-22770-2-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Blakey <paulb@mellanox.com> wrote:
> +/* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
> +static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
> +				   u16 zone_id, bool force)
> +{
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct)
> +		return false;
> +	if (!net_eq(net, read_pnet(&ct->ct_net)))
> +		return false;
> +	if (nf_ct_zone(ct)->id != zone_id)
> +		return false;
> +
> +	/* Force conntrack entry direction. */
> +	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
> +		nf_conntrack_put(&ct->ct_general);
> +		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
> +
> +		if (nf_ct_is_confirmed(ct))
> +			nf_ct_kill(ct);

This looks like a possible UAF:
nf_conntrack_put() may free the conntrack entry.

It seems better to do do:
	if (nf_ct_is_confirmed(ct))
		nf_ct_kill(ct);

	nf_conntrack_put(&ct->ct_general);
	nf_ct_set(skb, ...

