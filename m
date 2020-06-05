Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D461EFFA3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 20:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgFESIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgFESIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 14:08:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DB6C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 11:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C1WaD4u8dSWiD2OTqxYUX1JCHGsuLkwhAIOFAnwRrdc=; b=tsXZDblMeJCX7uNPaQ9txmjsRZ
        EVkLWftqLYzfCxfuiXBk1lqe5wvV94+8w5OyCgPrwYEu/Erioc0JpOO1LufoF5r9WEo8KV1xrvRLf
        QlYCoiNcjvSuVH1rhJX1n7J6bhG7Q/OiRZfs+4yy2C/y4AtrZQ6flWspjJ6mR6mmonSrVtNO9duHa
        tFdnIl7yMWiGk0s/4M/NflN1wkTv1oGuu69CxWSkSjV/YZ/utpy6x/2DnMHv3AhFCXdzhMgnI/fQ7
        1OESG7WoGVns2P7evomrG1DymR+yGHPISoKZNChAWX/EW+xIyVxgC5LqDLwmvfx15o5NkxMSusIHW
        NTho/qOA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jhGlR-0001TK-3x; Fri, 05 Jun 2020 18:08:21 +0000
Date:   Fri, 5 Jun 2020 11:08:21 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     netdev@vger.kernel.org
Subject: Re: Use of RCU in qrtr
Message-ID: <20200605180821.GA5421@bombadil.infradead.org>
References: <20200605121205.GE19604@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605121205.GE19604@bombadil.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[I meant to cc netdev on this originally.  Added now, preserving entire
message below for context]

On Fri, Jun 05, 2020 at 05:12:05AM -0700, Matthew Wilcox wrote:
> While doing the XArray conversion, I came across your commit
> f16a4b26f31f95dddb12cf3c2390906a735203ae
> 
> synchronize_rcu() is kind of expensive on larger systems.  Is there a
> reason to call it instead of using RCU to free the socket?
> 
> I don't know whether I've set the flag in the right place, but maybe
> something like this would be a good idea?
> 
> @@ -663,13 +663,8 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
>         if (port == QRTR_PORT_CTRL)
>                 port = 0;
>  
> -       __sock_put(&ipc->sk);
> -
>         xa_erase(&qrtr_ports, port);
> -
> -       /* Ensure that if qrtr_port_lookup() did enter the RCU read section we
> -        * wait for it to up increment the refcount */
> -       synchronize_rcu();
> +       __sock_put(&ipc->sk);
>  }
>  
>  /* Assign port number to socket.
> @@ -749,6 +744,7 @@ static int __qrtr_bind(struct socket *sock,
>                 qrtr_port_remove(ipc);
>         ipc->us.sq_port = port;
>  
> +       sock_set_flag(sk, SOCK_RCU_FREE);
>         sock_reset_flag(sk, SOCK_ZAPPED);
>  
>         /* Notify all open ports about the new controller */

I realised this isn't sufficient.  If we want to eliminate the
synchronize_rcu() call, we need to have a 'try' variant of sock_hold().
It would look something like this:

static inline __must_check bool sock_try_get(struct sock *sk)
{
	return refcount_inc_not_zero(&sk->sk_refcnt);
}

and then ...

        rcu_read_lock();
        ipc = xa_load(&qrtr_ports, port);
        if (ipc && !sock_try_get(&ipc->sk))
		ipc = NULL;
        rcu_read_unlock();

If we wanted to be able to atomically replace a pointer in the qrtr_ports
array with another without ever seeing NULL in between, we'd want to
make this:

	rcu_read_lock():
	do {
		ipc = xa_load(&qrtr_ports, port);
	} while (ipc && !sock_try_get(&ipc->sk));
	rcu_read_unlock();

but as far as I can tell, we don't need to do that for qrtr.
