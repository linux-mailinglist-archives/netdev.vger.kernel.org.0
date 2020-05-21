Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9064E1DC983
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 11:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgEUJL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 05:11:58 -0400
Received: from verein.lst.de ([213.95.11.211]:53831 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbgEUJL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 05:11:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DBA5368C4E; Thu, 21 May 2020 11:11:50 +0200 (CEST)
Date:   Thu, 21 May 2020 11:11:50 +0200
From:   'Christoph Hellwig' <hch@lst.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: remove kernel_setsockopt and kernel_getsockopt v2
Message-ID: <20200521091150.GA8401@lst.de>
References: <20200520195509.2215098-1-hch@lst.de> <138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 08:01:33AM +0000, David Laight wrote:
> How much does this increase the kernel code by?

 44 files changed, 660 insertions(+), 843 deletions(-)


> You are also replicating a lot of code making it more
> difficult to maintain.

No, I specifically don't.

> I don't think the performance of an socket option code
> really matters - it is usually done once when a socket
> is initialised and the other costs of establishing a
> connection will dominate.
> 
> Pulling the user copies outside the [gs]etsocksopt switch
> statement not only reduces the code size (source and object)
> and trivially allows kernel_[sg]sockopt() to me added to
> the list of socket calls.
> 
> It probably isn't possible to pull the usercopies right
> out into the syscall wrapper because of some broken
> requests.

Please read through the previous discussion of the rationale and the
options.  We've been there before.

> I worried about whether getsockopt() should read the entire
> user buffer first. SCTP needs the some of it often (including a
> sockaddr_storage in one case), TCP needs it once.
> However the cost of reading a few words is small, and a big
> buffer probably needs setting to avoid leaking kernel
> memory if the structure has holes or fields that don't get set.
> Reading from userspace solves both issues.

As mention in the thread on the last series:  That was my first idea, but
we have way to many sockopts, especially in obscure protocols that just
hard code the size.  The chance of breaking userspace in a way that can't
be fixed without going back to passing user pointers to get/setsockopt
is way to high to commit to such a change unfortunately.
