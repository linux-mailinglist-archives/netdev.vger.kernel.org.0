Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296C3281760
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbgJBQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJBQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 12:04:09 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7ABC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 09:04:09 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b17so1066270pji.1
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WYE7qOumuHoGWLxQ1fL6NQ8Aquzr+6oo4MYk/NamAMM=;
        b=RBYMGSfsJFMHOJ0iMZErvrtXp+y0VoGB+0S5/2C3qWp7T+hrlnAzSO62ID39y2L+39
         R2/lSsace/5y3LeJzfFN3+cM6knbnl46i1DSAjMiBFoaQA9hS3WRPQXK9KDKwtBHoJKe
         dcJdwg4ZXPLsH0mu7N3r6UjxyyfoHFJ6IuGpwvbWNuMm+lBMeVa4pVH0PlczV1fe9MfX
         YJT39roiLiwSkt/XWRRevC497TguH2pXm6eOwkupeppMuzinODtnh72e7mIHrVS1R9ws
         esBVjbo4tbgcpZk1yFocJRVoPim3K7esycJkKSv8qILc2UiS9/wHKrGKbxJ5xyIt1Scb
         ciJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WYE7qOumuHoGWLxQ1fL6NQ8Aquzr+6oo4MYk/NamAMM=;
        b=fInJnYO0G0G4wVloXRo5rZHHbB1E4+csWPpnPpI/C//M0rrfEI49wLxCQ8XhJbygch
         WrMOfPIXOp15UCeNhuKRfMBduFSbI0vGG94suVPwsinRQ6OFEFGlL0kbGvjop7pXoBlC
         4mIcihZSxf8rLkDMt/78QEkgMSpVjh4n1sN429Pe1TbAej5VT8M4hYagMKAIlRA3zfSm
         l83buqQJrpFU7nviiz/uMfsfFqjPYMm1pMKUA9bo7245RbQm0fjJqBEbZpSK2+qHHoxW
         3gpWaEENoKvHF6rzwxXDaqvwMFvLL1ZBPnV5nlzuf0wWqx6wedqsptX6SFhFcxkhI1nf
         i5+Q==
X-Gm-Message-State: AOAM531KXuetXjRnczW8v1DZEam4WnSKOLnqz8VqtSRGY5D+3KBNAxc7
        hjKkEwOfqti2FkoUpH+vD1sh
X-Google-Smtp-Source: ABdhPJyBB4U7uMDgh7U75IXiY1vjffjJfsn+2zioaI9cuzIOMCs+F8jFpvZFKRu5Ra4ZXGmw8GhNrQ==
X-Received: by 2002:a17:90a:ca82:: with SMTP id y2mr3440616pjt.233.1601654649305;
        Fri, 02 Oct 2020 09:04:09 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:648b:81b4:b1f8:3dc1:c168:1411])
        by smtp.gmail.com with ESMTPSA id z22sm3087632pjq.2.2020.10.02.09.04.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Oct 2020 09:04:08 -0700 (PDT)
Date:   Fri, 2 Oct 2020 21:34:02 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@linaro.org>
Subject: Re: [PATCH] net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()
Message-ID: <20201002160401.GB7178@Mani-XPS-13-9360>
References: <20201002141531.7081-1-manivannan.sadhasivam@linaro.org>
 <CAD=FV=V3WHgE5hqgRtPayGB1PTcdJge-32wJOgs84=4h3owtsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=V3WHgE5hqgRtPayGB1PTcdJge-32wJOgs84=4h3owtsA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug,

On Fri, Oct 02, 2020 at 08:28:51AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Fri, Oct 2, 2020 at 7:15 AM Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> >
> > The rcu_read_lock() is not supposed to lock the kernel_sendmsg() API
> > since it has the lock_sock() in qrtr_sendmsg() which will sleep. Hence,
> > fix it by excluding the locking for kernel_sendmsg().
> >
> > Fixes: a7809ff90ce6 ("net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks")
> > Reported-by: Doug Anderson <dianders@chromium.org>
> > Tested-by: Alex Elder <elder@linaro.org>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  net/qrtr/ns.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> > index 934999b56d60..0515433de922 100644
> > --- a/net/qrtr/ns.c
> > +++ b/net/qrtr/ns.c
> > @@ -203,15 +203,17 @@ static int announce_servers(struct sockaddr_qrtr *sq)
> >         /* Announce the list of servers registered in this node */
> >         radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
> >                 srv = radix_tree_deref_slot(slot);
> > +               rcu_read_unlock();
> 
> My RCU-fu is mediocre at best and my radix-tree knowledge is
> non-existent.  However:
> 
> => Reading through radix_tree_deref_slot() it says that if you are
> only holding the read lock that you need to be calling
> radix_tree_deref_retry().  Why don't I see that here?
> 

Well, I drew inspiration from peer drivers and didn't look into the API
documentation properly, my bad :(

> => Without any real knowledge, it seems super sketchy to drop the lock
> while iterating over the tree.  Somehow that feels unsafe.  Hrm, there
> seems to be a function radix_tree_iter_resume() that might be exactly
> what you want, but I'm not totally sure.  The only user I can see
> in-tree (other than radix tree regression testing) is btrfs-tests.c
> but it's using it together with radix_tree_deref_slot_protected().
> 
> In any case, my totally untested and totally knowedge-free proposal
> would look something like this:
> 
>   rcu_read_lock();
>   /* Announce the list of servers registered in this node */
>   radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
>     srv = radix_tree_deref_slot(slot);
>     if (!srv)
>       continue;
>     if (radix_tree_deref_retry(srv)) {
>       slot = radix_tree_iter_retry(&iter);
>       continue;
>     }
>     slot = radix_tree_iter_resume(slot, &iter);
>     rcu_read_unlock();
> 
>     ret = service_announce_new(sq, srv);
>     if (ret < 0) {
>       pr_err("failed to announce new service\n");
>       return ret;
>     }
> 
>     rcu_read_lock();
>   }
> 
>   rcu_read_unlock();
> 
> What a beast!  Given that this doesn't seem to be what anyone else in
> the kernel is doing exactly, it makes me suspect that there's a more
> fundamental design issue here, though...
> 

That's how it is supposed to be. So I'm going to roll out next revision with
your suggestion for the rest of the deref_slot() calls also.

Thanks for your time looking into this.

Regards,
Mani

> -Doug
