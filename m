Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2C339994
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 23:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhCLWRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 17:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbhCLWQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 17:16:49 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3895CC061574;
        Fri, 12 Mar 2021 14:16:49 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id y20so9051822iot.4;
        Fri, 12 Mar 2021 14:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ow2p0xO1hotn6RJOItrtDiyN/JeHanAbeq4vQ3SfL3Q=;
        b=ca8qSuxHMylJkf9hpLyRjp/Lol2CkO36rE6egf5H5JN5eI3b6iTEL/fbQnmfD7v8RO
         yZWhE84LScpT7GbGaqCoAaP0WaoREHhGnBmlZN5HTtwRcQL5uQ4U1b86yAr7SHM7AKtl
         ZtRUX0KButFkQukRno//Ub+D781me/+qZ7nlmeqE+By32gH/DPuRaX5hBoNJOYYGOTPf
         AlM+aytVEXO0CdK/7+6/r4TmJj+k85QG/VGkdEdCPfxaI6y9ZkBLiO8MV3FnzitzfrZA
         tMg6yZWfvr8ee8xR6PYOYlKUJtiPIxMMUaFdoJ4wlgDr/U+OtXRtd2Bomtnt+BwF6t0S
         bYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ow2p0xO1hotn6RJOItrtDiyN/JeHanAbeq4vQ3SfL3Q=;
        b=E14bB5zfSUp3BnUsG7cSCl4ty9p6LVQEacHeb/HRNW1BsXWM998rCDJpvFOsYaJXGl
         osdbD4ZnFXtv3D+a6FnbLfEAZyHFBvtJdpwQJCEWHzYSgbjG9ubHD6DNq2LxBVxEXiP1
         zn5Y7z3BHhnWeWZLgxqw9Dz8PSrNqZsi+eIBMrKaHBsKDOGsFnDqH113zjy02gBBQivQ
         zb3uV5sysPgBiAbozDE16oMVckEofmbOp79mea7Hd3cYgnUYB5fSqoDReTM5Dki5fNnP
         AnZH+pECqJt9UZ3y+ooNDgqD2XBi/nHi2xfsAjlZLhxKmT5wZ5i25+SX91uvapPLE7Kg
         sgRg==
X-Gm-Message-State: AOAM530yhkK1cxoxAk9pNIEzy8XG+oPtEzoUimSiWGIVUCYfBv3fqtmW
        tHTXbcnoH1ktEsnExIt/DFN0bMiSg4nogdJVoico9zN2g6E=
X-Google-Smtp-Source: ABdhPJw4pENv2yhmlx0fcfNkJOaKYdFrSOwU7MnjJ4DmsXBoc7adHRZNZlntn33952ydymnXbYqzCKVZOzwv+b1gXE8=
X-Received: by 2002:a02:53:: with SMTP id 80mr1335477jaa.96.1615587408621;
 Fri, 12 Mar 2021 14:16:48 -0800 (PST)
MIME-Version: 1.0
References: <161558613209.1366.1492710238067504151.stgit@klimt.1015granger.net>
In-Reply-To: <161558613209.1366.1492710238067504151.stgit@klimt.1015granger.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Mar 2021 14:16:37 -0800
Message-ID: <CAKgT0UdzgsfhNMDMYcAt3xR4U0=LOeMWO3+3tt0_omxu1OupaA@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Refresh rq_pages using a bulk page allocator
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 1:57 PM Chuck Lever <chuck.lever@oracle.com> wrote:
>
> Reduce the rate at which nfsd threads hammer on the page allocator.
> This improves throughput scalability by enabling the threads to run
> more independently of each other.
>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
> Hi Mel-
>
> This patch replaces patch 5/7 in v4 of your alloc_pages_bulk()
> series. It implements code clean-ups suggested by Alexander Duyck.
> It builds and has seen some light testing.
>
>
>  net/sunrpc/svc_xprt.c |   39 +++++++++++++++++++++++++++------------
>  1 file changed, 27 insertions(+), 12 deletions(-)

The updated patch looks good to me. I am good with having my
Reviewed-by added for patches 1-6. I think the only one that still
needs work is patch 7.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
