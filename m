Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39C1D1C66
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389811AbgEMRjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:39:07 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:54324 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732694AbgEMRjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:39:06 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 213E41802912F;
        Wed, 13 May 2020 17:39:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3874:4030:4321:4605:5007:6742:6743:7875:8603:8660:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12679:12740:12760:12895:13019:13069:13146:13148:13156:13228:13230:13311:13357:13439:14040:14659:14721:21080:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: watch82_4eccc56996d20
X-Filterd-Recvd-Size: 2964
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Wed, 13 May 2020 17:39:01 +0000 (UTC)
Message-ID: <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
Subject: Re: remove kernel_setsockopt and kernel_getsockopt
From:   Joe Perches <joe@perches.com>
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Date:   Wed, 13 May 2020 10:38:59 -0700
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-13 at 08:26 +0200, Christoph Hellwig wrote:
> this series removes the kernel_setsockopt and kernel_getsockopt
> functions, and instead switches their users to small functions that
> implement setting (or in one case getting) a sockopt directly using
> a normal kernel function call with type safety and all the other
> benefits of not having a function call.
> 
> In some cases these functions seem pretty heavy handed as they do
> a lock_sock even for just setting a single variable, but this mirrors
> the real setsockopt implementation - counter to that a few kernel
> drivers just set the fields directly already.
> 
> Nevertheless the diffstat looks quite promising:
> 
>  42 files changed, 721 insertions(+), 799 deletions(-)

trivia:

It might be useful to show overall object size change.

More EXPORT_SYMBOL uses increase object size a little.

And not sure it matters much except it reduces overall object
size, but these patches remove (unnecessary) logging on error
and that could be mentioned in the cover letter too.

e.g.:

-       ret = kernel_setsockopt(queue->sock, SOL_SOCKET, SO_LINGER,
-                       (char *)&sol, sizeof(sol));
-       if (ret) {
-               dev_err(nctrl->device,
-                       "failed to set SO_LINGER sock opt %d\n", ret);
-               goto err_sock;
-       }
+       sock_set_linger(queue->sock->sk, true, 0);



