Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436562AA65E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgKGPj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgKGPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 10:39:26 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45474C0613CF;
        Sat,  7 Nov 2020 07:39:26 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 626651C25; Sat,  7 Nov 2020 10:39:24 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 626651C25
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1604763564;
        bh=OiHzKhgk2PHE2aqJryJ2eHQ/6HtBN1HOJxiFjEz+G58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OE6vvBgMUKsWV4o3GwYIaw+zzlbayVgcaz8/V1JxixZ+R8at8OKDpAjvs2bd29PQe
         yv+TwtVVLHKk6XDMnjTClLZNARa+gsff1QV7OEi0Q6ubLUSz8S73q42gFxqsPv82+b
         6WfhvmKolD6wBBTtiYU1/zwk5+WGkAOgaLQCCWTw=
Date:   Sat, 7 Nov 2020 10:39:24 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Artur Molchanov <arturmolchanov@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc: Fix return value from proc_do_xprt()
Message-ID: <20201107153924.GA16447@fieldses.org>
References: <20201024145240.23245-1-alex.dewar90@gmail.com>
 <20201106220721.GE26028@fieldses.org>
 <20201107134940.c2hmfpcx743bqc5o@medion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107134940.c2hmfpcx743bqc5o@medion>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 07, 2020 at 01:49:40PM +0000, Alex Dewar wrote:
> On Fri, Nov 06, 2020 at 05:07:21PM -0500, J. Bruce Fields wrote:
> > Whoops, got 3 independent patches for this and overlooked this one.  See
> > https://lore.kernel.org/linux-nfs/20201106205959.GB26028@fieldses.org/T/#t
> > 
> > --b.
> 
> That looks like a cleaner fix. Thanks for looking anyhow and sorry for
> the noise!

Not noise, all these efforts are appreciated.---b.

> 
> > 
> > On Sat, Oct 24, 2020 at 03:52:40PM +0100, Alex Dewar wrote:
> > > Commit c09f56b8f68d ("net/sunrpc: Fix return value for sysctl
> > > sunrpc.transports") attempted to add error checking for the call to
> > > memory_read_from_buffer(), however its return value was assigned to a
> > > size_t variable, so any negative values would be lost in the cast. Fix
> > > this.
> > > 
> > > Addresses-Coverity-ID: 1498033: Control flow issues (NO_EFFECT)
> > > Fixes: c09f56b8f68d ("net/sunrpc: Fix return value for sysctl sunrpc.transports")
> > > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > > ---
> > >  net/sunrpc/sysctl.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
> > > index a18b36b5422d..c95a2b84dd95 100644
> > > --- a/net/sunrpc/sysctl.c
> > > +++ b/net/sunrpc/sysctl.c
> > > @@ -62,6 +62,7 @@ rpc_unregister_sysctl(void)
> > >  static int proc_do_xprt(struct ctl_table *table, int write,
> > >  			void *buffer, size_t *lenp, loff_t *ppos)
> > >  {
> > > +	ssize_t bytes_read;
> > >  	char tmpbuf[256];
> > >  	size_t len;
> > >  
> > > @@ -70,12 +71,14 @@ static int proc_do_xprt(struct ctl_table *table, int write,
> > >  		return 0;
> > >  	}
> > >  	len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
> > > -	*lenp = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
> > > +	bytes_read = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
> > >  
> > > -	if (*lenp < 0) {
> > > +	if (bytes_read < 0) {
> > >  		*lenp = 0;
> > >  		return -EINVAL;
> > >  	}
> > > +
> > > +	*lenp = bytes_read;
> > >  	return 0;
> > >  }
> > >  
> > > -- 
> > > 2.29.1
