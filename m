Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E922CA5FB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391669AbgLAOnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:43:23 -0500
Received: from correo.us.es ([193.147.175.20]:55930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbgLAOnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 09:43:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 290F11E2C7E
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 15:42:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1823BDA86C
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 15:42:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0A679DA850; Tue,  1 Dec 2020 15:42:40 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C760ADA7B6;
        Tue,  1 Dec 2020 15:42:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 01 Dec 2020 15:42:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9B63E4265A5A;
        Tue,  1 Dec 2020 15:42:37 +0100 (CET)
Date:   Tue, 1 Dec 2020 15:42:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, fw@strlen.de
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201201144238.GA5970@salvia>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201130184828.x56bwxxiwydsxt3k@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 08:48:28PM +0200, Vladimir Oltean wrote:
[...]
> There are 2 separate classes of problems:
> - We already have two ways of protecting pure readers: via RCU and via
>   the rwlock. It doesn't help if we also add a second way of locking out
>   pure writers. We need to first clean up what we have. That's the
>   reason why I started the discussion about the rwlock.
> - Some callers appear to not use any sort of protection at all. Does
>   this code path look ok to you?
> 
> nfnetlink_rcv_batch
> -> NFT_MSG_NEWCHAIN

This path holds the nft commit mutex.

>    -> nf_tables_addchain
>       -> nft_chain_parse_hook
>          -> nft_chain_parse_netdev
>             -> nf_tables_parse_netdev_hooks
>                -> nft_netdev_hook_alloc
>                   -> __dev_get_by_name
>                      -> netdev_name_node_lookup: must be under RTNL mutex or dev_base_lock protection

The nf_tables_netdev_event() notifier holds the nft commit mutex too.
Assuming worst case, race between __dev_get_by_name() and device
removal, the notifier waits for the NFT_MSG_NEWCHAIN path to finish.
If the nf_tables_netdev_event() notifier wins race, then
__dev_get_by_name() hits ENOENT.

The idea is explained here:

commit 90d2723c6d4cb2ace50fc3b932a2bcc77710450b
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Mar 20 17:00:19 2018 +0100

    netfilter: nf_tables: do not hold reference on netdevice from preparation phase

    The netfilter netdevice event handler hold the nfnl_lock mutex, this
    avoids races with a device going away while such device is being
    attached to hooks from the netlink control plane. Therefore, either
    control plane bails out with ENOENT or netdevice event path waits until
    the hook that is attached to net_device is registered.

I can submit a patch adding a comment so anyone else does not get
confused :-)
