Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB50571219
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiGLGGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLGGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:06:53 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A170A7CB47;
        Mon, 11 Jul 2022 23:06:51 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8A0F6C021; Tue, 12 Jul 2022 08:06:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657606009; bh=Oei6nGCRVDIFiTLCYzG4olbX/seA/soTnXGc+IcXkbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nw8anNgxe4VAdmnH1L9hXpyoFSiGLVvs7e6r0fUnWdSCtAwWO49kyYCUBj6Y5/Kd4
         HOzYdqtsh/OjGKF8YNOuvTS8sFALGHGN+CYX1utKfW5KfNpinJP1jx2DKZvioj2k6w
         /u7U8OASYLOh0ciXsOvg0KPI6gqado33BkmDHVUvybydEe/lXFgwAzs4u5rSmkl6hA
         qjwUbT6BsaTiBnPViMBGHTxiVJzAtx5s7RON7OdK2zqFMqcEKzity2cEHSBoufBq0B
         U8PNJjR1Y1MyveOi1EBsrNWNuY1phpt6Ks/vCJrXt7Qm/0RLQ4DNiiE96eqMNI2v3v
         432JnLmF6XyYw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 5F191C009;
        Tue, 12 Jul 2022 08:06:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657606008; bh=Oei6nGCRVDIFiTLCYzG4olbX/seA/soTnXGc+IcXkbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=3B3RrEAEVAJkX7uuNdvc44x4wrAh3AA7NTxwiPicFYXICpCTUE22X7JCfauJZ+J2y
         ZM66sIDqK5U52pMU1OTYhUyqXk6whOc5pnHKl6lrQP71VU8aavtp8P0f/dDGIEzTTR
         NPINWN90iNavo0XGruqu1qeyxPT1CTl5BEiTU0KzOK3xs+HoWt8y46z9k7X1xe2Q+h
         7XybKi8tFU+P5N9nFxgXfs0+tdALfH/aWA607NUUpTQIGVUYEAi4f26llYSFGru4Ly
         sl0yFFSTnrlUtw7OeIHnWN5iuHFmALG9kUNqdUUsnxzgs0uWvQqy6UvrntrIvxzs+g
         pT9ZJi0Bm1ZAA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f581a640;
        Tue, 12 Jul 2022 06:06:40 +0000 (UTC)
Date:   Tue, 12 Jul 2022 15:06:25 +0900
From:   asmadeus@codewreck.org
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: fix possible refcount leak in p9_read_work()
 and recv_done()
Message-ID: <Ys0PYaD7x7InUpc+@codewreck.org>
References: <20220711065907.23105-1-hbh25y@gmail.com>
 <YsvTvalrwd4bxO75@codewreck.org>
 <f68df7cf-4b72-4c01-9492-103fa67c5e99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f68df7cf-4b72-4c01-9492-103fa67c5e99@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua wrote on Tue, Jul 12, 2022 at 11:24:36AM +0800:
> That's a little weird. If you are right, the three return paths of this
> function are inconsistent with the handling of refcount.
> 
> static void p9_read_work(struct work_struct *work)
> {
> ...
> 	if ((m->rreq) && (m->rc.offset == m->rc.capacity)) {
> 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
> 		m->rreq->rc.size = m->rc.offset;
> 		spin_lock(&m->client->lock);
> 		if (m->rreq->status == REQ_STATUS_SENT) {
> 			list_del(&m->rreq->req_list);
> 			p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);	<---- [1]
> 		} else if (m->rreq->status == REQ_STATUS_FLSHD) {
> 			/* Ignore replies associated with a cancelled request. */
> 			p9_debug(P9_DEBUG_TRANS,
> 				 "Ignore replies associated with a cancelled request\n");	<---- [2]
> 		} else {
> 			spin_unlock(&m->client->lock);
> 			p9_debug(P9_DEBUG_ERROR,
> 				 "Request tag %d errored out while we were reading the reply\n",
> 				 m->rc.tag);
> 			err = -EIO;
> 			goto error;	<---- [3]
> 		}
> 		spin_unlock(&m->client->lock);
> 		m->rc.sdata = NULL;
> 		m->rc.offset = 0;
> 		m->rc.capacity = 0;
> 		p9_req_put(m->rreq);	<---- [4]
> 		m->rreq = NULL;
> 	}
> ...
> error:
> 	p9_conn_cancel(m, err);		<---- [5]
> 	clear_bit(Rworksched, &m->wsched);
> }
> 
> There are three return paths here, [1] and [2] and [3].
> [1]: m->rreq will be put twice in [1] and [4]. And m->rreq will be deleted
> from the m->req_list in [1].
> 
> [2]: m->rreq will be put in [4]. And m->rreq will not be deleted from
> m->req_list.

when req status got put to FLUSHD the req was dropped from the list
already and put in p9_fd_cancel, so we shouldn't put it here.

> [3]: m->rreq will be put in [5]. And m->rreq will be deleted from the
> m->req_list in [5].

On this error case I really can't say anything: it depends on how the
req got in this state in the first place -- more precisely is it still
in req_list or not?

But even if it is and we leak it here, we return an error here, so the
connection will be marked as disconnected and won't be usable anymore.
The memory will be freed when the user umounts after that.

If we took the time to re-init the rreq->req_list everytime we could
check if it's empty (don't think we can rely on it being poisoned), but
I just don't think it's worth it: it's better to consume a bit more
memory until umount than to risk a UAF.

(note: while writing this I noticed p9_tag_cleanup() in
p9_client_destroy() only tracks requests still in the idr, so doesn't
work for requests that went through p9_tag_remove().
We don't need p9_tag_remove() anymore so I've just gotten rid of it and
we will catch these now)


> If p9_tag_lookup keep the refcount of req which is in m->req_list. There
> will be a double put in return path [1] and a potential UAF in return path
> [2]. And this also means a req in m->req_list without getting refcount
> before p9_tag_lookup.

That is the nominal path, we'd notice immediately if there are too many
puts there.
A request is initialized with two refs so that we can have one for the
transport ((a), for fd, "is the request tracked in a list?") and one for
the main thread ((b), p9_client_rpc which will put it at the end)
Then you get a third ref from p9_tag_lookup that I was forgetting about,
(c).

Going through [1] removes it from the list, and removes the associated
ref (a), then through p9_client_cb which removes ref (c) and wakes up
p9_client_rpc which takes the last ref (b), freeing the request.


Now you were correct on one of these error paths not described in your
last mail: we -are- missing a p9_req_ut in the "No recv fcall for tag
%d" error path shortly after p9_tag_lookup, for the ref obtained from
p9_tag_lookup itself -- feel free to resend a patch with just that one.
But once again the connection is now unusable and it'll be caught on
umount so it's not the end of the world...

(I'd appreciate if you base the new patch on top of
https://github.com/martinetd/linux/commits/9p-next )

> 
> static void p9_write_work(struct work_struct *work)
> {
> ...
> 		list_move_tail(&req->req_list, &m->req_list);
> 
> 		m->wbuf = req->tc.sdata;
> 		m->wsize = req->tc.size;
> 		m->wpos = 0;
> 		p9_req_get(req);
> ...
> }
> 
> But if you check out p9_write_work, a refcount already get after
> list_move_tail. We don't need to rely on p9_tag_lookup to keep a list's
> refcount.

This refcount is because we are keeping a ref in m->wreq, and is freed
when m->wreq is set back to null when the packet is done writing a few
lines below (but possibly in another call of the function).

refs don't have to come from p9_tag_lookup, they're managing pointers
lifecycle: we're making a copy of the pointer, so we should increment
the refcount so another thread can't free the req under us. In this case
the p9_req_get() is under the trans fd m->client->lock where we got the
req from the list, so req can't be freed between its obtention from the
list and then; once the lock is dropped the req is protected by the ref.


> Whatsmore, code comments in p9_tag_alloc also proves that the
> refcount get by p9_tag_lookup is a temporary refcount.

comments don't prove anything, but yes I forgot p9_tag_alloc takes a ref
when I commented earlier, sorry.

> > This one isn't as clear cut, I see that they put the client in a
> > FLUSHING state but nothing seems to acton on it... But if this happens
> > we're already in the use after free realm -- it means rc.sdata was
> > already set so the other thread could be calling p9_client_cb anytime if
> > it already hasn't, and yet another thread will then do the final ref put
> > and free this.
> > We shouldn't free this here as that would also be an overflow. The best
> > possible thing to do at this point is just to stop using that pointer.
> > 
> 
> But p9_tag_lookup have a lock inside. Doesn't this mean p9_tag_lookup won't
> return a freed req? Otherwise we should fix the lock to avoid falling into
> the use after free realm.

Right, that falls into the p9_tag_lookup ref, I had implemented this
better than I thought I did...

I agree that one is also more correct to add, although I'd really want
to make some rdma setup and trigger a few errors to test.

--
Dominique
