Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0CA22129C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGOQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:46 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33599 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgGOQkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:36 -0400
Received: by mail-ed1-f68.google.com with SMTP id h28so2106348edz.0;
        Wed, 15 Jul 2020 09:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mkYMsiSKEyTRllQWaVCWr/1Tzi9Mh4OsE2TArv0QPE4=;
        b=GpWMlkg2pG8vm7YvFAaQ5PN9iyjgJxBcHxfNP3RKeR7O6FdGk1AWMu9tK1zV5eem+d
         +3ywLdxKa2B4/7UcNFoR/rj8856HLeOS7aqKO3rtOUCCJx+VN8gFqLdwyrczkxVvhzMF
         kUS2AUrtz7GfMWFVDCd+wSk1pdoYBlsDvGuEuKWky/VIMFHcf8DQGye/cvjTHVGtXInc
         ESF3JIhZWxuvi/EQ510MnBXavtcfz8WWXUh0vcrRsFvMp/02uKdELXy7qCHmqDs85vXg
         eeZC9uKDLkSgJ59UwzNh9u85l6yjwwDva5mxgFi6hYJayxAMGTXIZcl94LkNhKafxw07
         S3YA==
X-Gm-Message-State: AOAM532ucAZU1HpiMKFGguksDMocNJZ/WPlOgDL+tElPcyvcx8WWofbq
        TTmpCIZAXjgA7SvH5SyFBcNKVoyMcwXSD6gAvU18LA==
X-Google-Smtp-Source: ABdhPJxL2C4dTVVKrNN4e+F8ARVR16RmQ+W2KY1F0ucI6oh6+0b4B0E4YcDIV44fX0Geoxf4yVkiP3FmOGIrLSi9TeA=
X-Received: by 2002:a50:ab5c:: with SMTP id t28mr436194edc.209.1594831234383;
 Wed, 15 Jul 2020 09:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200715162604.1080552-1-colin.king@canonical.com> <eb5d2ead-807b-3435-5024-b8cc4a1311f3@canonical.com>
In-Reply-To: <eb5d2ead-807b-3435-5024-b8cc4a1311f3@canonical.com>
From:   Anna Schumaker <anna.schumaker@netapp.com>
Date:   Wed, 15 Jul 2020 12:40:18 -0400
Message-ID: <CAFX2Jfn75a8XENoqvztVnUe0aR9S2KGjpcGp3zyLeFS-h--9ag@mail.gmail.com>
Subject: Re: [PATCH] xprtrdma: fix incorrect header size calcations
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need for a v2, I can fix it up!


On Wed, Jul 15, 2020 at 12:32 PM Colin Ian King
<colin.king@canonical.com> wrote:
>
> Bah, $SUBJECT typo "calcations" -> "calculations". can that be fixed up
> when it's applied, or shall I send a V2?
>
> On 15/07/2020 17:26, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Currently the header size calculations are using an assignment
> > operator instead of a += operator when accumulating the header
> > size leading to incorrect sizes.  Fix this by using the correct
> > operator.
> >
> > Addresses-Coverity: ("Unused value")
> > Fixes: 302d3deb2068 ("xprtrdma: Prevent inline overflow")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  net/sunrpc/xprtrdma/rpc_rdma.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
> > index 935bbef2f7be..453bacc99907 100644
> > --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> > +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> > @@ -71,7 +71,7 @@ static unsigned int rpcrdma_max_call_header_size(unsigned int maxsegs)
> >       size = RPCRDMA_HDRLEN_MIN;
> >
> >       /* Maximum Read list size */
> > -     size = maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
> > +     size += maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
> >
> >       /* Minimal Read chunk size */
> >       size += sizeof(__be32); /* segment count */
> > @@ -94,7 +94,7 @@ static unsigned int rpcrdma_max_reply_header_size(unsigned int maxsegs)
> >       size = RPCRDMA_HDRLEN_MIN;
> >
> >       /* Maximum Write list size */
> > -     size = sizeof(__be32);          /* segment count */
> > +     size += sizeof(__be32);         /* segment count */
> >       size += maxsegs * rpcrdma_segment_maxsz * sizeof(__be32);
> >       size += sizeof(__be32); /* list discriminator */
> >
> >
>
