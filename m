Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4785C56D6F6
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 09:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiGKHkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 03:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKHkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 03:40:08 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1266577;
        Mon, 11 Jul 2022 00:40:07 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3DF6FC009; Mon, 11 Jul 2022 09:40:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657525205; bh=4znMRb8yNMIL2ImNXJHHakTw5e86CC6v8rfhTcy+ZYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Hp+pjZdW6nvsDpQMwtbcZJsXG4UaF+GS8rGC4AeCNlM/agyHrpB3s+OyC4XivVD+
         zCrblT85F8a97htBCZ7V6w6XacakGklghoTZqzqUc7ZNuiy+y1Bu0yd5JHSwgtdpBy
         TXrWkJlk89SEWozd0l91LgwGLBfPlNMVy1PeQk6TzJWzpR60QMBDqqQWPgRsiMOPsb
         3QC5RbGHhn9f4fe1pIkWBD7JCV4pBjHqRKfoBiPgYYY/uEtJSMwMw8U02LuZiHsWgn
         vaGV70wkJZT2xLQba66jPV/BE/CCG4KWnTFH8AxdsDykNzB70URPLFpJSQyvwuHyId
         jUUwEAkXOMwtw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id A6C79C009;
        Mon, 11 Jul 2022 09:40:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657525204; bh=4znMRb8yNMIL2ImNXJHHakTw5e86CC6v8rfhTcy+ZYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APOSJV0WYbmBOmerpJvPFt0U+eh10sL0i+zdv7vzmc+EW0jRxUGJacQN7/3Rr/9iW
         Qt6ZNPhVMYkoXX0VXV2Om/asntBOqpgLoTH2CRKEQdF6VjL3qog2JLbGasmTzZ5l85
         tNG45gtzUEjVx6pBM6wrryisuqFJXXZSFA4p/ZTuO2pg7T/Szs6JjCnWaY7Oqtyna7
         fZhNEKYR4J764OWtaHk3wHhCk5Ze5s3ct67tfhdvX5hLxAkUKUFQ77OqDssV+EQK49
         yPohvHCZ4xhb9Pw3F0DQY5DyZ9+zfK53vJ4WsFSRv91L1hgyRtamHOPYB4bjcgpCnr
         Rnylswyj3je0Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id d9434db7;
        Mon, 11 Jul 2022 07:39:56 +0000 (UTC)
Date:   Mon, 11 Jul 2022 16:39:41 +0900
From:   asmadeus@codewreck.org
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: fix possible refcount leak in p9_read_work()
 and recv_done()
Message-ID: <YsvTvalrwd4bxO75@codewreck.org>
References: <20220711065907.23105-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220711065907.23105-1-hbh25y@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua wrote on Mon, Jul 11, 2022 at 02:59:07PM +0800:
> A ref got in p9_tag_lookup needs to be put when functions enter the
> error path.
> 
> Fix this by adding p9_req_put in error path.

I wish it was that simple.

Did you actually observe a leak?

> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index 8f8f95e39b03..c4ccb7b9e1bf 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -343,6 +343,7 @@ static void p9_read_work(struct work_struct *work)
>  			p9_debug(P9_DEBUG_ERROR,
>  				 "No recv fcall for tag %d (req %p), disconnecting!\n",
>  				 m->rc.tag, m->rreq);
> +			p9_req_put(m->rreq);
>  			m->rreq = NULL;
>  			err = -EIO;
>  			goto error;
> @@ -372,6 +373,8 @@ static void p9_read_work(struct work_struct *work)
>  				 "Request tag %d errored out while we were reading the reply\n",
>  				 m->rc.tag);
>  			err = -EIO;
> +			p9_req_put(m->rreq);
> +			m->rreq = NULL;
>  			goto error;
>  		}
>  		spin_unlock(&m->client->lock);


for tcp, we still have that request in m->req_list, so we should be
calling p9_client_cb which will do the p9_req_put in p9_conn_cancel.

If you do it here, you'll get a refcount overflow and use after free.

> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index 88e563826674..82b5d6894ee2 100644
> --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -317,6 +317,7 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  	/* Check that we have not yet received a reply for this request.
>  	 */
>  	if (unlikely(req->rc.sdata)) {
> +		p9_req_put(req);
>  		pr_err("Duplicate reply for request %d", tag);
>  		goto err_out;
>  	}

This one isn't as clear cut, I see that they put the client in a
FLUSHING state but nothing seems to acton on it... But if this happens
we're already in the use after free realm -- it means rc.sdata was
already set so the other thread could be calling p9_client_cb anytime if
it already hasn't, and yet another thread will then do the final ref put
and free this.
We shouldn't free this here as that would also be an overflow. The best
possible thing to do at this point is just to stop using that pointer.


If you actually run into a problem with these refcounts (should get a
warning on umount that something didn't get freed) then by all mean
let's look further into it, but please don't send such patches without
testing the error paths you're "fixing" -- I'm pretty sure a reproducer
to hit these paths would bark errors in dmesg as refcount has an
overflow check.

--
Dominique
