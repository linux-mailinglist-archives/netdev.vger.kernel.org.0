Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08273BE56E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhGGJUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:20:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53930 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGGJUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:20:50 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 29B716165A;
        Wed,  7 Jul 2021 11:17:58 +0200 (CEST)
Date:   Wed, 7 Jul 2021 11:18:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     iLifetruth <yixiaonn@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu <cyruscyliu@gmail.com>, yajin@vm-kernel.org
Subject: Re: netfilter: Use netlink_ns_capable to verify the permisions of
 netlink messages
Message-ID: <20210707091807.GA16039@salvia>
References: <CABv53a97_5iaAdOcoVdQDxNyyTxgXHx=mHm0Sfo4UJVLHoxosg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABv53a97_5iaAdOcoVdQDxNyyTxgXHx=mHm0Sfo4UJVLHoxosg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 04:05:33PM +0800, iLifetruth wrote:
> Hi, we have found that the same fix pattern of CVE-2014-0181 may not
> forward ported to some netlink-related places in the latest linux
> kernel(v5.13)
> 
> =============
> Here is the description of CVE-2014-0181:
> 
> The Netlink implementation in the Linux kernel through 3.14.1 does not
> provide a mechanism for authorizing socket operations based on the opener
> of a socket, which allows local users to bypass intended access
> restrictions and modify network configurations by using a Netlink socket
> for the (1) stdout or (2) stderr of a setuid program.
> 
> ==========
> And here is the solution to CVE-2014-0181:
> 
> To keep this from happening, replace bare capable and ns_capable calls with
> netlink_capable, netlink_net_calls and netlink_ns_capable calls. Which act
> the same as the previous calls *except they verify that the opener of the
> socket had the desired permissions as well.*
> 
> ==========
> The upstream patch commit of this vulnerability described in CVE-2014-0181
> is:
>     90f62cf30a78721641e08737bda787552428061e (committed about 7 years ago)
> 
> =========
> Capable() checks were added to these netlink-related places listed below
> in netfilter by another upstream commit:
> 4b380c42f7d00a395feede754f0bc2292eebe6e5(committed about 4 years ago)
> 
> In kernel v5.13:
>     File_1: linux/net/netfilter/nfnetlink_cthelper.c
>                        in line 424, line 623 and line 691
>     File_2: linux/net/netfilter/nfnetlink_osf.c
>                        in line 305 and line 351

These subsystems depend on nfnetlink.

nfnetlink_rcv() is called before passing the message to the
corresponding backend, e.g. nfnetlink_osf.

static void nfnetlink_rcv(struct sk_buff *skb)
{
        struct nlmsghdr *nlh = nlmsg_hdr(skb);

        if (skb->len < NLMSG_HDRLEN ||
            nlh->nlmsg_len < NLMSG_HDRLEN ||
            skb->len < nlh->nlmsg_len)
                return;

        if (!netlink_net_capable(skb, CAP_NET_ADMIN)) {
                netlink_ack(skb, nlh, -EPERM, NULL);
                return;
        }
        [...]

which is calling netlink_net_capable().

> But these checkers are still using bare capable instead of netlink_capable
> calls. So this is likely to trigger the vulnerability described in the
> CVE-2014-0181 without checking the desired permissions of the socket
> opener. Now, shall we forward port the fix pattern from the patch of
> CVE-2014-0181?
> 
> We would like to contact you to confirm this problem.

I think these capable() calls in nfnetlink_cthelper and nfnetlink_osf
are dead code that can be removed. As I explained these subsystems
stay behind nfnetlink.
