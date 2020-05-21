Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D51DC8E6
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 10:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgEUImb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 04:42:31 -0400
Received: from verein.lst.de ([213.95.11.211]:53697 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgEUIma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 04:42:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1D9C368BEB; Thu, 21 May 2020 10:42:25 +0200 (CEST)
Date:   Thu, 21 May 2020 10:42:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 32/33] net: add a new bind_add method
Message-ID: <20200521084224.GA7859@lst.de>
References: <20200520195509.2215098-1-hch@lst.de> <20200520195509.2215098-33-hch@lst.de> <20200520230025.GT2491@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520230025.GT2491@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 08:00:25PM -0300, Marcelo Ricardo Leitner wrote:
> > +	if (err)
> > +		return err;
> > +
> > +	lock_sock(sk);
> > +	err = sctp_do_bind(sk, (union sctp_addr *)addr, af->sockaddr_len);
> > +	if (!err)
> > +		err = sctp_send_asconf_add_ip(sk, addr, 1);
> 
> Some problems here.
> - addr may contain a list of addresses
> - the addresses, then, are not being validated
> - sctp_do_bind may fail, on which it requires some undoing
>   (like sctp_bindx_add does)
> - code duplication with sctp_setsockopt_bindx.

sctp_do_bind and thus this function only support a single address, as
that is the only thing that the DLM code requires.  I could move the
user copy out of sctp_setsockopt_bindx and reuse that, but it is a
rather rcane API.

> 
> This patch will conflict with David's one,
> [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.

Do you have a link?  A quick google search just finds your mail that
I'm replying to.

> (I'll finish reviewing it in the sequence)
> 
> AFAICT, this patch could reuse/build on his work in there. The goal is
> pretty much the same and would avoid the issues above.
> 
> This patch could, then, point the new bind_add proto op to the updated
> sctp_setsockopt_bindx almost directly.
> 
> Question then is: dlm never removes an addr from the bind list. Do we
> want to add ops for both? Or one that handles both operations?
> Anyhow, having the add operation but not the del seems very weird to
> me.

We generally only add operations for things that we actually use.
bind_del is another logical op, but we can trivially add that when we
need it.
