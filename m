Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78774134F6B
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 23:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgAHWc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 17:32:28 -0500
Received: from correo.us.es ([193.147.175.20]:55706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgAHWc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 17:32:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BD6CC5152
        for <netdev@vger.kernel.org>; Wed,  8 Jan 2020 23:32:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FED0DA703
        for <netdev@vger.kernel.org>; Wed,  8 Jan 2020 23:32:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 42F6ADA70F; Wed,  8 Jan 2020 23:32:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EA19DA701;
        Wed,  8 Jan 2020 23:32:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jan 2020 23:32:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0E9BB426CCB9;
        Wed,  8 Jan 2020 23:32:24 +0100 (CET)
Date:   Wed, 8 Jan 2020 23:32:23 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: ipset: avoid null deref when
 IPSET_ATTR_LINENO is present
Message-ID: <20200108223223.bvyvyy6il664whtb@salvia>
References: <000000000000a347ef059b8ee979@google.com>
 <20200108095938.3704-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108095938.3704-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 10:59:38AM +0100, Florian Westphal wrote:
> The set uadt functions assume lineno is never NULL, but it is in
> case of ip_set_utest().
> 
> syzkaller managed to generate a netlink message that calls this with
> LINENO attr present:
> 
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> RIP: 0010:hash_mac4_uadt+0x1bc/0x470 net/netfilter/ipset/ip_set_hash_mac.c:104
> Call Trace:
>  ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
>  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
> 
> pass a dummy lineno storage, its easier than patching all set
> implementations.
> 
> This seems to be a day-0 bug.

Also applied, thanks.
