Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A561272AF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLTBLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:11:30 -0500
Received: from correo.us.es ([193.147.175.20]:48106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfLTBLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 20:11:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7689F25A9
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 02:11:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8A3CDA70F
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 02:11:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ADE42DA709; Fri, 20 Dec 2019 02:11:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93F60DA70A;
        Fri, 20 Dec 2019 02:11:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Dec 2019 02:11:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 76C9A4265A5A;
        Fri, 20 Dec 2019 02:11:24 +0100 (CET)
Date:   Fri, 20 Dec 2019 02:11:24 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH nf] netfilter: ebtables: compat: reject all padding in
 matches/watchers
Message-ID: <20191220011124.addyezhijttukqw5@salvia>
References: <000000000000cd9e600599b051e5@google.com>
 <20191215024925.10872-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215024925.10872-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 03:49:25AM +0100, Florian Westphal wrote:
> syzbot reported following splat:
> 
> BUG: KASAN: vmalloc-out-of-bounds in size_entry_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in compat_copy_entries+0x128b/0x1380 net/bridge/netfilter/ebtables.c:2155
> Read of size 4 at addr ffffc900004461f4 by task syz-executor267/7937
> 
> CPU: 1 PID: 7937 Comm: syz-executor267 Not tainted 5.5.0-rc1-syzkaller #0
>  size_entry_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
>  compat_copy_entries+0x128b/0x1380 net/bridge/netfilter/ebtables.c:2155
>  compat_do_replace+0x344/0x720 net/bridge/netfilter/ebtables.c:2249
>  compat_do_ebt_set_ctl+0x22f/0x27e net/bridge/netfilter/ebtables.c:2333
>  [..]
> 
> Because padding isn't considered during computation of ->buf_user_offset,
> "total" is decremented by fewer bytes than it should.
> 
> Therefore, the first part of
> 
> if (*total < sizeof(*entry) || entry->next_offset < sizeof(*entry))
> 
> will pass, -- it should not have.  This causes oob access:
> entry->next_offset is past the vmalloced size.
> 
> Reject padding and check that computed user offset (sum of ebt_entry
> structure plus all individual matches/watchers/targets) is same
> value that userspace gave us as the offset of the next entry.

Applied, thanks.
