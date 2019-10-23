Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A4BE1800
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404502AbfJWKbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:31:20 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55872 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404089AbfJWKbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:31:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNDvB-00027r-EX; Wed, 23 Oct 2019 12:31:17 +0200
Date:   Wed, 23 Oct 2019 12:31:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     xiangxia.m.yue@gmail.com
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_conntrack: introduce conntrack
 limit per-zone
Message-ID: <20191023103117.GL25052@breakpoint.cc>
References: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xiangxia.m.yue@gmail.com <xiangxia.m.yue@gmail.com> wrote:
> nf_conntrack_max is used to limit the maximum number of
> conntrack entries in the conntrack table for every network
> namespace. For the containers that reside in the same namespace,
> they share the same conntrack table, and the total # of conntrack
> entries for all containers are limited by nf_conntrack_max.
> In this case, if one of the container abuses the usage the
> conntrack entries, it blocks the others from committing valid
> conntrack entries into the conntrack table.
> 
> To address the issue, this patch adds conntrack counter for zones
> and max count which zone wanted, So that any zone can't consume
> all conntrack entries in the conntrack table.
>
> This feature can be used for openvswitch or iptables.

Your approach adds cost for everyone, plus a 256kbyte 'struct net'
increase.

openvswitch supports per zone limits already, using nf_conncount
infrastructure.

nftables supports it using ruleset (via 'ct count').

If you need support for iptables, consider extending xt_connlimit.c
instead -- looking at the code it might already do all that is needed
if userspace passes a 0-length mask for the ip address, i.e.

iptables -t mangle -A PREROUTING -m conntrack --ctstate NEW -m connlimit \
   --connlimit-above 1000 --connlimit-mask 0 -j REJECT
