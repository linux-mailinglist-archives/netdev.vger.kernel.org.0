Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A611A460
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 07:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfLKGRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 01:17:10 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:46284 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfLKGRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 01:17:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CE3712019C;
        Wed, 11 Dec 2019 07:17:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sPwbxyKzNNMX; Wed, 11 Dec 2019 07:17:07 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E90BC2009B;
        Wed, 11 Dec 2019 07:17:07 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 07:17:07 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 79B193180449;
 Wed, 11 Dec 2019 07:17:07 +0100 (CET)
Date:   Wed, 11 Dec 2019 07:17:07 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH ipsec-next v7 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20191211061707.GA8621@gauss3.secunet.de>
References: <cover.1574685542.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1574685542.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 02:48:56PM +0100, Sabrina Dubroca wrote:
> This patchset introduces support for TCP encapsulation of IKE and ESP
> messages, as defined by RFC 8229 [0]. It is an evolution of what
> Herbert Xu proposed in January 2018 [1] that addresses the main
> criticism against it, by not interfering with the TCP implementation
> at all. The networking stack now has infrastructure for this: TCP ULPs
> and Stream Parsers.
> 
> The first patches are preparation and refactoring, and the final patch
> adds the feature.
> 
> The main omission in this submission is IPv6 support. ESP
> encapsulation over UDP with IPv6 is currently not supported in the
> kernel either, as UDP encapsulation is aimed at NAT traversal, and NAT
> is not frequently used with IPv6.
> 
> Some of the code is taken directly, or slightly modified, from Herbert
> Xu's original submission [1]. The ULP and strparser pieces are
> new. This work was presented and discussed at the IPsec workshop and
> netdev 0x13 conference [2] in Prague, last March.
> 
> [0] https://tools.ietf.org/html/rfc8229
> [1] https://patchwork.ozlabs.org/patch/859107/
> [2] https://netdevconf.org/0x13/session.html?talk-ipsec-encap
> 
> Changes since v6:
>  - fix sparse warning in patch 6/6
> 
> Changes since v5:
>  - rebase patch 1/6 on top of ipsec-next (conflict with commits
>    7c422d0ce975 ("net: add READ_ONCE() annotation in
>    __skb_wait_for_more_packets()") and 3f926af3f4d6 ("net: use
>    skb_queue_empty_lockless() in busy poll contexts"))
> 
> Changes since v4:
>  - prevent combining sockmap with espintcp, as this does not work
>    properly and I can't see a use case for it
> 
> Changes since v3:
>  - fix sparse warning related to RCU tag on icsk_ulp_data
> 
> Changes since v2:
>  - rename config option to INET_ESPINTCP and move it to
>    net/ipv4/Kconfig (patch 6/6)
> 
> Changes since v1:
>  - drop patch 1, already present in the tree as commit bd95e678e0f6
>    ("bpf: sockmap, fix use after free from sleep in psock backlog
>    workqueue")
>  - patch 1/6: fix doc error reported by kbuild test robot <lkp@intel.com>
>  - patch 6/6, fix things reported by Steffen Klassert:
>    - remove unneeded goto and improve error handling in
>      esp_output_tcp_finish
>    - clean up the ifdefs by providing dummy implementations of those
>      functions
>    - fix Kconfig select, missing NET_SOCK_MSG
> 
> Sabrina Dubroca (6):
>   net: add queue argument to __skb_wait_for_more_packets and
>     __skb_{,try_}recv_datagram
>   xfrm: introduce xfrm_trans_queue_net
>   xfrm: add route lookup to xfrm4_rcv_encap
>   esp4: prepare esp_input_done2 for non-UDP encapsulation
>   esp4: split esp_output_udp_encap and introduce esp_output_encap
>   xfrm: add espintcp (RFC 8229)

All applied to ipsec-next, thanks a lot Sabrina!
