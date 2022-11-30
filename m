Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8110463D5D7
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiK3Mnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiK3Mng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:43:36 -0500
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42532C664;
        Wed, 30 Nov 2022 04:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=/BlcjrhlqFewCWUJrrIEfdV+ZSjxYvhgiyJGvIdAx+w=; b=bpjDeNkppxzTtMyTUxjxhx0xQh
        EWKf76ISQ7SoDJ0EOpicgmCOEREw5IHvO653wvxSVqfCsoyjv87MzjvGiTej4MQfOCmLx1x3kdnuD
        OumJcs7i/XH0vslJ9seiobfgQmmHnCK80GE1XM13w6PHTOmzqI18HEQo2O2wRYzoCJ1R51gBjjrtl
        Dif7dAIxl5BhbmmOqr7Lpc94+2gOP3MmEGUJ6d72tJsbnqKAzKIiZ9eaaoYjVV37cS8fNW42C8r+v
        NcEfnn9durihatI+ZxjmdDFlJ0b4HsxQQlmQZHoQ9ludbQJObFoch5RwjKdXg8ASlfns1m1S39a2c
        Ltmf1QMp7P6atn6OJG8lOC69LNVMlHnEeHhI+Orfdri134X4fa11hX/FHDVJodMk3vG4dYAVE5XnO
        uMvvXabkcdpip95UufW4LqU1l4tzLXEcR67N62bBWKkXAKU6/wpO846Do6CMRRd+He13JAjXo9O1f
        t1xU5+fXophHji8FycSiBTiIL71wTwQR/rzyIngTffoGUf436lNQGK+zvQTpTDJ6IVJleV8PhPa0J
        UQ9FANkrfNtSxzxk3yFASZaGpvD+1HxXNfAgGc8U3RE1rrj3bQVIwYfq6r4xqpzEWBBj2H5iCVeDu
        SeE7oIWwV8uowKRZB/GoE9zkf/CnLhgGMb2X/DaKI=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Schspa Shi <schspa@gmail.com>, asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Wed, 30 Nov 2022 13:43:20 +0100
Message-ID: <2356667.R3SNuAaExM@silver>
In-Reply-To: <Y4c5N/SAuszTLiEA@codewreck.org>
References: <20221129162251.90790-1-schspa@gmail.com> <m2o7sowzas.fsf@gmail.com>
 <Y4c5N/SAuszTLiEA@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, November 30, 2022 12:06:31 PM CET asmadeus@codewreck.org wrote:
> Schspa Shi wrote on Wed, Nov 30, 2022 at 04:14:32PM +0800:
> > >  - reqs are alloced in a kmem_cache created with SLAB_TYPESAFE_BY_RCU.
> > >  This means that if we get a req from idr_find, even if it has just been
> > >  freed, it either is still in the state it was freed at (hence refcount
> > >  0, we ignore it) or is another req coming from the same cache (if
> > 
> > If the req was newly alloced(It was at a new page), refcount maybe not
> > 0, there will be problem in this case. It seems we can't relay on this.
> > 
> > We need to set the refcount to zero before add it to idr in p9_tag_alloc.
> 
> Hmm, if it's reused then it's zero by definition, but if it's a new
> allocation (uninitialized) then anything goes; that lookup could find
> and increase it before the refcount_set, and we'd have an off by one
> leading to use after free. Good catch!
> 
> Initializing it to zero will lead to the client busy-looping until after
> the refcount is properly set, which should work.
> Setting refcount early might have us use an re-used req before the tag
> has been changed so that one cannot move.
> 
> Could you test with just that changed if syzbot still reproduces this
> bug? (perhaps add a comment if you send this)
> 
> ------
> diff --git a/net/9p/client.c b/net/9p/client.c
> index aaa37b07e30a..aa64724f6a69 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -297,6 +297,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
>  	p9pdu_reset(&req->rc);
>  	req->t_err = 0;
>  	req->status = REQ_STATUS_ALLOC;
> +	refcount_set(&req->refcount, 0);
>  	init_waitqueue_head(&req->wq);
>  	INIT_LIST_HEAD(&req->req_list);
> 
> ----- 
> 
> > >  refcount isn't zero, we can check its tag)
> > 
> > As for the release case, the next request will have the same tag with
> > high probability. It's better to make the tag value to be an increase
> > sequence, thus will avoid very much possible req reuse.
> 
> I'd love to be able to do this, but it would break some servers that
> assume tags are small (e.g. using it as an index for a tag array)
> ... I thought nfs-ganesha was doing this but they properly put in in
> buckets, so that's one less server to worry about, but I wouldn't put
> it past some simple servers to do that; having a way to lookup a given
> tag for flush is an implementation requirement.

I really think it's time to emit tag number sequentially. If it turns out that
it's a server that is broken, we could then simply ignore replies with old/
unknown tag number. It would also help a lot when debugging 9p issues in
general when you know tag numbers are not re-used (in near future).

A 9p server must not make any assumptions how tag numbers are generated by
client, whether dense or sparse, or whatever. If it does then server is
broken, which is much easier to fix than synchronization issues we have to
deal with like this one.

> That shouldn't be a problem though as that will just lead to either fail
> the guard check after lookup (m->rreq->status != REQ_STATUS_SENT) or be
> processed as a normal reply if it's already been sent by the other
> thread at this point.
> OTOH, that m->rreq->status isn't protected by m->req_lock in trans_fd,
> and that is probably another bug...



