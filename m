Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D204B2405D
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfETSbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfETSbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 14:31:16 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49F42173E;
        Mon, 20 May 2019 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558377075;
        bh=PQJAtzYWkZBV79B9CamjOX53afOeT02SXR9XY57tnss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APk5CsC2lFx6Zmn/LEA/IZtyQ3r4cMhD2CGaqBqfsCKNQWxyJSGgw6PTkP92lxtXx
         +kT5JiKBHnejv2cx3ncd882bWZpXj3rkB2S5ybckWXMnU1yJ6Y8tCyCnJJor61jxXK
         tFt+OZ9ztvzU8MceJ9gzl7bTjWfJFUtXqaOHUuoo=
Date:   Mon, 20 May 2019 21:31:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Glenn Streiff <gstreiff@neteffect.com>,
        Steve Wise <swise@opengridcomputing.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH rdma-next 01/15] rds: Don't check return value from
 destroy CQ
Message-ID: <20190520183112.GT4573@mtr-leonro.mtl.com>
References: <20190520065433.8734-1-leon@kernel.org>
 <20190520065433.8734-2-leon@kernel.org>
 <9db089b4-d088-9b2a-c6ce-350e11fb5460@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9db089b4-d088-9b2a-c6ce-350e11fb5460@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 10:17:43AM -0700, Santosh Shilimkar wrote:
> On 5/19/2019 11:54 PM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > There is no value in checking ib_destroy_cq() result and skipping
> > to clear struct ic fields. This connection needs to be reinitialized
> > anyway.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >   net/rds/ib_cm.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> > index 66c6eb56072b..5a42ebb892cd 100644
> > --- a/net/rds/ib_cm.c
> > +++ b/net/rds/ib_cm.c
> > @@ -611,11 +611,11 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
> >   qp_out:
> >   	rdma_destroy_qp(ic->i_cm_id);
> >   recv_cq_out:
> > -	if (!ib_destroy_cq(ic->i_recv_cq))
> > -		ic->i_recv_cq = NULL;
> > +	ib_destroy_cq(ic->i_recv_cq);
> > +	ic->i_recv_cq = NULL;
> >   send_cq_out:
> > -	if (!ib_destroy_cq(ic->i_send_cq))
> > -		ic->i_send_cq = NULL;
> > +	ib_destroy_cq(ic->i_send_cq);
> > +	ic->i_send_cq = NULL;
> This was done to ensure, you still don't get ISR delivering
> the CQEs while we are in shutdown path. Your patch
> is fine though since you don't change that behavior.
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Thanks

>
>
