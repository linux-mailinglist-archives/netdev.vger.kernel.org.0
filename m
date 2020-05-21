Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F99A1DC8B9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 10:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgEUIer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 04:34:47 -0400
Received: from verein.lst.de ([213.95.11.211]:53663 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbgEUIer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 04:34:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2946668BEB; Thu, 21 May 2020 10:34:43 +0200 (CEST)
Date:   Thu, 21 May 2020 10:34:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Miller <davem@davemloft.net>, hch@lst.de, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, jmaloy@redhat.com,
        ying.xue@windriver.com, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Message-ID: <20200521083442.GA7771@lst.de>
References: <20200520195509.2215098-1-hch@lst.de> <20200520195509.2215098-32-hch@lst.de> <20200520231001.GU2491@localhost.localdomain> <20200520.162355.2212209708127373208.davem@davemloft.net> <20200520233913.GV2491@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520233913.GV2491@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 08:39:13PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, May 20, 2020 at 04:23:55PM -0700, David Miller wrote:
> > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Date: Wed, 20 May 2020 20:10:01 -0300
> > 
> > > The duplication with sctp_setsockopt_nodelay() is quite silly/bad.
> > > Also, why have the 'true' hardcoded? It's what dlm uses, yes, but the
> > > API could be a bit more complete than that.
> > 
> > The APIs are being designed based upon what in-tree users actually
> > make use of.  We can expand things later if necessary.
> 
> Sometimes expanding things later can be though, thus why the worry.
> But ok, I get it. Thanks.
> 
> The comment still applies, though. (re the duplication)

Where do you see duplication?

sctp_setsockopt_nodelay does the following things:

 - verifies optlen, returns -EINVAL if it doesn't match
 - calls get_user, returns -EFAULT on error
 - converts the value from get_user to a boolean and assigns it
   to sctp_sk(sk)->nodelay
 - returns 0.

sctp_sock_set_nodelay does:

 - call lock_sock
 - assign true to sctp_sk(sk)->nodelay
 - call release_sock
 - does not return an error code
