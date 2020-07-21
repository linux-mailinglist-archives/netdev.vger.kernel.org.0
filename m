Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856BE228CAC
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgGUXXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:23:32 -0400
Received: from correo.us.es ([193.147.175.20]:56116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgGUXXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 19:23:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E936A2EFEAA
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:23:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA75DDA78B
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:23:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD4CADA792; Wed, 22 Jul 2020 01:23:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 635D4DA722;
        Wed, 22 Jul 2020 01:23:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 Jul 2020 01:23:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 299974265A2F;
        Wed, 22 Jul 2020 01:23:28 +0200 (CEST)
Date:   Wed, 22 Jul 2020 01:23:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     guodeqing <geffrey.guo@huawei.com>, wensong@linux-vs.org,
        horms@verge.net.au, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH,v2] ipvs: fix the connection sync failed in some cases
Message-ID: <20200721232327.GA6430@salvia>
References: <1594887128-7453-1-git-send-email-geffrey.guo@huawei.com>
 <alpine.LFD.2.23.451.2007190837120.3463@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.23.451.2007190837120.3463@ja.home.ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 09:08:39AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 16 Jul 2020, guodeqing wrote:
> 
> > The sync_thread_backup only checks sk_receive_queue is empty or not,
> > there is a situation which cannot sync the connection entries when
> > sk_receive_queue is empty and sk_rmem_alloc is larger than sk_rcvbuf,
> > the sync packets are dropped in __udp_enqueue_schedule_skb, this is
> > because the packets in reader_queue is not read, so the rmem is
> > not reclaimed.
> > 
> > Here I add the check of whether the reader_queue of the udp sock is
> > empty or not to solve this problem.
> > 
> > Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
> > Reported-by: zhouxudong <zhouxudong8@huawei.com>
> > Signed-off-by: guodeqing <geffrey.guo@huawei.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> 	Simon, Pablo, this patch should be applied to the nf tree.

Applied, thanks.

> As the reader_queue appears in 4.13, this patch can be backported
> to 4.14, 4.19, 5.4, etc, they all have skb_queue_empty_lockless.

The Fixes: tag should help -stable maintainer pull this into the next
batch. Otherwise, feel free to drop a line to stable@vger.kernel.org
to request inclusion after this patch hits Linus' tree.

Thanks.
