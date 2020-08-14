Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9D244791
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 11:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHNJ7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 05:59:50 -0400
Received: from correo.us.es ([193.147.175.20]:39790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgHNJ7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 05:59:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B47CC22E5
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 11:59:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C93DDA840
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 11:59:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 81DD9DA84F; Fri, 14 Aug 2020 11:59:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68C3BDA840;
        Fri, 14 Aug 2020 11:59:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Aug 2020 11:59:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (170.pool85-48-185.static.orange.es [85.48.185.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F1C6842EF42A;
        Fri, 14 Aug 2020 11:59:45 +0200 (CEST)
Date:   Fri, 14 Aug 2020 11:59:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, hch@lst.de,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter/ebtables: reject bogus getopt len value
Message-ID: <20200814095943.GC5816@salvia>
References: <000000000000ece9db05ac4054e8@google.com>
 <20200813074611.281558-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813074611.281558-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 09:46:11AM +0200, Florian Westphal wrote:
> syzkaller reports splat:
> ------------[ cut here ]------------
> Buffer overflow detected (80 < 137)!
> Call Trace:
>  do_ebt_get_ctl+0x2b4/0x790 net/bridge/netfilter/ebtables.c:2317
>  nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
>  ip_getsockopt net/ipv4/ip_sockglue.c:1778 [inline]
> 
> caused by a copy-to-user with a too-large "*len" value.
> This adds a argument check on *len just like in the non-compat version
> of the handler.
> 
> Before the "Fixes" commit, the reproducer fails with -EINVAL as
> expected:
> 1. core calls the "compat" getsockopt version
> 2. compat getsockopt version detects the *len value is possibly
>    in 64-bit layout (*len != compat_len)
> 3. compat getsockopt version delegates everything to native getsockopt
>    version
> 4. native getsockopt rejects invalid *len
> 
> -> compat handler only sees len == sizeof(compat_struct) for GET_ENTRIES.
> 
> After the refactor, event sequence is:
> 1. getsockopt calls "compat" version (len != native_len)
> 2. compat version attempts to copy *len bytes, where *len is random
>    value from userspace

Applied, thanks.
