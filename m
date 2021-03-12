Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C373396D7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhCLSoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbhCLSoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 13:44:20 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF244C061574;
        Fri, 12 Mar 2021 10:44:19 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id a7so26760641iok.12;
        Fri, 12 Mar 2021 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKiouv1eprFdp8cyqZbRKzdDF1BxO+8+7O6XRnUPNYY=;
        b=apzg0DwmUzO8SKLb5mJMXEkdpERbz/o+0p4zJ/+93T75wCBwPVy7VVGAn7h3QAmD6U
         kdEHEkuOnL5rpIacy84CgysLBndGwQgXq7K2w5oWtFZ54CHLb6nth+vIAweDJsX7b3Y7
         7HquDgx/uM0KNxpZZkbE29i5A0Pt6fqBVLTY76caC1aSeeyojSXFyyMzL3Vo28usY8KV
         453csxQrhI72HlQDbt8bDQFgjuLxiv3mHWXJ1w8JenSmJgBO+ud+DqNt0E6OIZOZpFrU
         UaecoLJ8OT7o+jQ8BpGXkRZQRUZgSjCP0i8wxn3+wbyc92ZAG8O7HfpnBaC/S+cfmV8+
         GmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKiouv1eprFdp8cyqZbRKzdDF1BxO+8+7O6XRnUPNYY=;
        b=LUwFX5/cChGkUoaOO6skBckPsIpAhxCi4xqv4TCrEovlBJ5/ZnnYlt3PDZlTlmdzC1
         YiRm9jkyYT55btRpv471b5+qR+gYRH3ZlILbar8T8v1gMbdmd/bf7ind7F9Twpr9lnOW
         iBOLYxMuPDcF34ZCWvF1ltjJ4HOC/csSZ5fH+C4fk+zESCrHGr8oC6Te/2nMbHUu7pyo
         e3yW/WVdqRkoYXwgGU3pRenqtzphtFVjiCtTwBG+UTCB+/7RxtktcUbIIr85ZCMj6Jlh
         pUYv8mMa9FjP1JqB1FtWnVZP64jxTT+37CdknQIwiK4kFY4hkeZLJmu+JnMEjZ33DIMD
         I2Ng==
X-Gm-Message-State: AOAM530UAk12ne79+8KRF/eEx+OPiZtuaR5rCska+lqIaRQQch6EwYwP
        awex+M8RnopdnmvbJPrFSESBs0RlTPge2dptfyI=
X-Google-Smtp-Source: ABdhPJzzYYT+IyN0pKKJoq1taE+f0eHNQJxNOErzOxE4nio01xX99ngiJyCGxOys+4cKS/Jo0K6MDTD2lNH45Swj7/0=
X-Received: by 2002:a5e:8e41:: with SMTP id r1mr461266ioo.5.1615574659362;
 Fri, 12 Mar 2021 10:44:19 -0800 (PST)
MIME-Version: 1.0
References: <20210312154331.32229-1-mgorman@techsingularity.net> <20210312154331.32229-6-mgorman@techsingularity.net>
In-Reply-To: <20210312154331.32229-6-mgorman@techsingularity.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Mar 2021 10:44:08 -0800
Message-ID: <CAKgT0Uf-4CY=wU079Y87xwzz_UDm8AqGBdt_6OuVtADR8AN0hA@mail.gmail.com>
Subject: Re: [PATCH 5/7] SUNRPC: Refresh rq_pages using a bulk page allocator
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 7:43 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> From: Chuck Lever <chuck.lever@oracle.com>
>
> Reduce the rate at which nfsd threads hammer on the page allocator.
> This improves throughput scalability by enabling the threads to run
> more independently of each other.
>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>  net/sunrpc/svc_xprt.c | 43 +++++++++++++++++++++++++++++++------------
>  1 file changed, 31 insertions(+), 12 deletions(-)
>
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index cfa7e4776d0e..38a8d6283801 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -642,11 +642,12 @@ static void svc_check_conn_limits(struct svc_serv *serv)
>  static int svc_alloc_arg(struct svc_rqst *rqstp)
>  {
>         struct svc_serv *serv = rqstp->rq_server;
> +       unsigned long needed;
>         struct xdr_buf *arg;
> +       struct page *page;
>         int pages;
>         int i;
>
> -       /* now allocate needed pages.  If we get a failure, sleep briefly */
>         pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
>         if (pages > RPCSVC_MAXPAGES) {
>                 pr_warn_once("svc: warning: pages=%u > RPCSVC_MAXPAGES=%lu\n",
> @@ -654,19 +655,28 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
>                 /* use as many pages as possible */
>                 pages = RPCSVC_MAXPAGES;
>         }
> -       for (i = 0; i < pages ; i++)
> -               while (rqstp->rq_pages[i] == NULL) {
> -                       struct page *p = alloc_page(GFP_KERNEL);
> -                       if (!p) {
> -                               set_current_state(TASK_INTERRUPTIBLE);
> -                               if (signalled() || kthread_should_stop()) {
> -                                       set_current_state(TASK_RUNNING);
> -                                       return -EINTR;
> -                               }
> -                               schedule_timeout(msecs_to_jiffies(500));
> +

> +       for (needed = 0, i = 0; i < pages ; i++)
> +               if (!rqstp->rq_pages[i])
> +                       needed++;

I would use an opening and closing braces for the for loop since
technically the if is a multiline statement. It will make this more
readable.

> +       if (needed) {
> +               LIST_HEAD(list);
> +
> +retry:

Rather than kind of open code a while loop why not just make this
"while (needed)"? Then all you have to do is break out of the for loop
and you will automatically return here instead of having to jump to
two different labels.

> +               alloc_pages_bulk(GFP_KERNEL, needed, &list);

Rather than not using the return value would it make sense here to
perhaps subtract it from needed? Then you would know if any of the
allocation requests weren't fulfilled.

> +               for (i = 0; i < pages; i++) {

It is probably optimizing for the exception case, but I don't think
you want the "i = 0" here. If you are having to stop because the list
is empty it probably makes sense to resume where you left off. So you
should probably be initializing i to 0 before we check for needed.

> +                       if (!rqstp->rq_pages[i]) {

It might be cleaner here to just do a "continue" if rq_pages[i] is populated.

> +                               page = list_first_entry_or_null(&list,
> +                                                               struct page,
> +                                                               lru);
> +                               if (unlikely(!page))
> +                                       goto empty_list;

I think I preferred the original code that wasn't jumping away from
the loop here. With the change I suggested above that would switch the
if(needed) to while(needed) you could have it just break out of the
for loop to place itself back in the while loop.

> +                               list_del(&page->lru);
> +                               rqstp->rq_pages[i] = page;
> +                               needed--;
>                         }
> -                       rqstp->rq_pages[i] = p;
>                 }
> +       }
>         rqstp->rq_page_end = &rqstp->rq_pages[pages];
>         rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
>
> @@ -681,6 +691,15 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
>         arg->len = (pages-1)*PAGE_SIZE;
>         arg->tail[0].iov_len = 0;
>         return 0;
> +
> +empty_list:
> +       set_current_state(TASK_INTERRUPTIBLE);
> +       if (signalled() || kthread_should_stop()) {
> +               set_current_state(TASK_RUNNING);
> +               return -EINTR;
> +       }
> +       schedule_timeout(msecs_to_jiffies(500));
> +       goto retry;
>  }
>
>  static bool
> --
> 2.26.2
>
