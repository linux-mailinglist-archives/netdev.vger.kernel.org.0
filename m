Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8233D6A6C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 01:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhGZXOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233809AbhGZXOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 19:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F31A60F94;
        Mon, 26 Jul 2021 23:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627343670;
        bh=iv+ATOSmwiwNnLSQnmZrL8/5KkfaAq/A3X/tsBD9WHo=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=XrdBfjd+bjwD4/0PhyJb6mCaEEXRj94JnYjShRENPJ+i3K7BviN0W/BdTMoM7fMZE
         vv4ow0zW74MUmAF6RfCSJuC/ROSQtXN28ThJopcNl44LakLmlmBz0LVG3ZjTXYYCuI
         aLxNGi2KA6R3MNmd+7oWSb4TFMXH+FiWyhNJRUcqDJuYuaSTrcfv4uSeXid0qy0Bzt
         l9IgKTo3L4J9ua3xKCToQ/k9zBRz6wPhAZ+3YMu2ijRWtEu95gMMRw8CVfjp+7+mS2
         15nZ7NODNRZKIUV8nSZzCscTdaltslCtORrxOJHXdRBabS5ZKKqklTtggUi437eDNV
         NXNcK1ampO7Cw==
Date:   Mon, 26 Jul 2021 16:54:29 -0700 (PDT)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@sstabellini-ThinkPad-T480s
To:     Harshvardhan Jha <harshvardhan.jha@oracle.com>
cc:     Stefano Stabellini <sstabellini@kernel.org>,
        asmadeus@codewreck.org, ericvh@gmail.com, lucho@ionkov.net,
        davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [External] : Re: [PATCH] 9p/xen: Fix end of loop tests for
 list_for_each_entry
In-Reply-To: <d956e0f2-546e-ddfd-86eb-9afb8549b40d@oracle.com>
Message-ID: <alpine.DEB.2.21.2107261654130.10122@sstabellini-ThinkPad-T480s>
References: <20210725175103.56731-1-harshvardhan.jha@oracle.com> <YP3NqQ5NGF7phCQh@codewreck.org> <alpine.DEB.2.21.2107261357210.10122@sstabellini-ThinkPad-T480s> <d956e0f2-546e-ddfd-86eb-9afb8549b40d@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Jul 2021, Harshvardhan Jha wrote:
> On 27/07/21 3:00 am, Stefano Stabellini wrote:
> > On Mon, 26 Jul 2021, asmadeus@codewreck.org wrote:
> > > Harshvardhan Jha wrote on Sun, Jul 25, 2021 at 11:21:03PM +0530:
> > > > The list_for_each_entry() iterator, "priv" in this code, can never be
> > > > NULL so the warning would never be printed.
> > > 
> > > hm? priv won't be NULL but priv->client won't be client, so it will
> > > return -EINVAL alright in practice?
> > > 
> > > This does fix an invalid read after the list head, so there's a real
> > > bug, but the commit message needs fixing.
> > 
> > Agreed
> > 
> > 
> > > > Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
> > > > ---
> > > >  From static analysis.  Not tested.
> > > 
> > > +Stefano in To - I also can't test xen right now :/
> > > This looks functional to me but if you have a bit of time to spare just
> > > a mount test can't hurt.
> > 
> > Yes, I did test it successfully. Aside from the commit messaged to be
> > reworded:
> How's this?
> ===========================BEGIN========================================
> 9p/xen: Fix end of loop tests for list_for_each_entry
> 
> This patch addresses the following problems:
>  - priv can never be NULL, so this part of the check is useless
>  - if the loop ran through the whole list, priv->client is invalid and
> it is more appropriate and sufficient to check for the end of
> list_for_each_entry loop condition.
> 
> Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>

That's fine


> ---
> From static analysis. Not tested.
> ===========================END==========================================
> > 
> > Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
> > Tested-by: Stefano Stabellini <sstabellini@kernel.org>
> > 
> > 
> > > > ---
> > > >   net/9p/trans_xen.c | 4 ++--
> > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> > > > index f4fea28e05da..3ec1a51a6944 100644
> > > > --- a/net/9p/trans_xen.c
> > > > +++ b/net/9p/trans_xen.c
> > > > @@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct
> > > > xen_9pfs_dataring *ring, RING_IDX size)
> > > >     static int p9_xen_request(struct p9_client *client, struct p9_req_t
> > > > *p9_req)
> > > >   {
> > > > -	struct xen_9pfs_front_priv *priv = NULL;
> > > > +	struct xen_9pfs_front_priv *priv;
> > > >   	RING_IDX cons, prod, masked_cons, masked_prod;
> > > >   	unsigned long flags;
> > > >   	u32 size = p9_req->tc.size;
> > > > @@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_client *client,
> > > > struct p9_req_t *p9_req)
> > > >   			break;
> > > >   	}
> > > >   	read_unlock(&xen_9pfs_lock);
> > > > -	if (!priv || priv->client != client)
> > > > +	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
> > > >   		return -EINVAL;
> > > >     	num = p9_req->tc.tag % priv->num_rings;
> 
