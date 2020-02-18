Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2B163526
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBRVf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:35:28 -0500
Received: from correo.us.es ([193.147.175.20]:45842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbgBRVf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 16:35:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DC4327F8B5
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 22:35:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C52AFB378
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 22:35:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8ADEC59A; Tue, 18 Feb 2020 22:35:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1DE0DA3A8;
        Tue, 18 Feb 2020 22:35:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 22:35:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8ED5242EE38E;
        Tue, 18 Feb 2020 22:35:24 +0100 (CET)
Date:   Tue, 18 Feb 2020 22:35:24 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org,
        syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
Subject: Re: [Patch nf] netfilter: xt_hashlimit: unregister proc file before
 releasing mutex
Message-ID: <20200218213524.5yuccwnl2eie6p6x@salvia>
References: <20200213065352.6310-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213065352.6310-1-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:53:52PM -0800, Cong Wang wrote:
> Before releasing the global mutex, we only unlink the hashtable
> from the hash list, its proc file is still not unregistered at
> this point. So syzbot could trigger a race condition where a
> parallel htable_create() could register the same file immediately
> after the mutex is released.
> 
> Move htable_remove_proc_entry() back to mutex protection to
> fix this. And, fold htable_destroy() into htable_put() to make
> the code slightly easier to understand.

Probably revert previous one?
