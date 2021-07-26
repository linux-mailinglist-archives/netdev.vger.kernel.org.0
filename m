Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46E93D68AC
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhGZUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhGZUuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B8C60F6B;
        Mon, 26 Jul 2021 21:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627335045;
        bh=10sumWN6KbuT6Bm4qG/cts13R1eLADJ18/WfByzAeGs=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Qnm4bnw50azM1D1dMwCqm5ptC3S/j1h5Z0cBjmlIcP5NPuh+X9gt4fF9/ABBZV6D+
         2nEaKThLrbUKediyIMqJxAn6iUblKyjXsZaVlP27lt0Yd1WDcY+AYHsbc+qKd1Fn9P
         HjT8TsxDJBw2WE4+f33fSnw66hvdPKEARchNVDuwYY51Tuwzh6xPceTNMSlj0lPwuK
         Tcxy+IGN1VoV1haxQF40g/uNJ5HWgG7rCHR9ZJKucSfkMx+PYEeLIISWffeLlikCOU
         iLjUZi2+DjiC7yH2c+JGyB+dGWAzcfMWrNOX8b/vPLNrEbzRDEnWiBEdVBL0WgtYTI
         iVss8A5X/hBBQ==
Date:   Mon, 26 Jul 2021 14:30:44 -0700 (PDT)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@sstabellini-ThinkPad-T480s
To:     asmadeus@codewreck.org
cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p/xen: Fix end of loop tests for list_for_each_entry
In-Reply-To: <YP3NqQ5NGF7phCQh@codewreck.org>
Message-ID: <alpine.DEB.2.21.2107261357210.10122@sstabellini-ThinkPad-T480s>
References: <20210725175103.56731-1-harshvardhan.jha@oracle.com> <YP3NqQ5NGF7phCQh@codewreck.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Jul 2021, asmadeus@codewreck.org wrote:
> Harshvardhan Jha wrote on Sun, Jul 25, 2021 at 11:21:03PM +0530:
> > The list_for_each_entry() iterator, "priv" in this code, can never be
> > NULL so the warning would never be printed.
> 
> hm? priv won't be NULL but priv->client won't be client, so it will
> return -EINVAL alright in practice?
> 
> This does fix an invalid read after the list head, so there's a real
> bug, but the commit message needs fixing.

Agreed


> > Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
> > ---
> > From static analysis.  Not tested.
> 
> +Stefano in To - I also can't test xen right now :/
> This looks functional to me but if you have a bit of time to spare just
> a mount test can't hurt.

Yes, I did test it successfully. Aside from the commit messaged to be
reworded:

Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Tested-by: Stefano Stabellini <sstabellini@kernel.org>


> > ---
> >  net/9p/trans_xen.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> > index f4fea28e05da..3ec1a51a6944 100644
> > --- a/net/9p/trans_xen.c
> > +++ b/net/9p/trans_xen.c
> > @@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)
> >  
> >  static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
> >  {
> > -	struct xen_9pfs_front_priv *priv = NULL;
> > +	struct xen_9pfs_front_priv *priv;
> >  	RING_IDX cons, prod, masked_cons, masked_prod;
> >  	unsigned long flags;
> >  	u32 size = p9_req->tc.size;
> > @@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
> >  			break;
> >  	}
> >  	read_unlock(&xen_9pfs_lock);
> > -	if (!priv || priv->client != client)
> > +	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
> >  		return -EINVAL;
> >  
> >  	num = p9_req->tc.tag % priv->num_rings;
