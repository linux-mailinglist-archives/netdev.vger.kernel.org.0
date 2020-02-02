Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A04B14FF1B
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 21:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBBU1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 15:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbgBBU1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 15:27:36 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD63D20658;
        Sun,  2 Feb 2020 20:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580675256;
        bh=RS07e3Qlj1ZE6hT/yNk/el9AIRQKLw4CMrmg2qCg/60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mIPiQLt75OcS5pTPQNLZx59Z0lqL6H64LQyCZQ98NAFNg7AKYOUa0brVUY209GSUN
         jzlpVS9hpS178mm3k/pWhWt0Kaw5oXIhR2WZ9v9prdm+Vc3k5pA5D4xOxE1zPeOeop
         G6IG0Rkd4V4ubK5pQCt45OMEzfWJMY4lHKcpO0Vs=
Date:   Sun, 2 Feb 2020 12:27:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/4] rxrpc: Fix missing active use pinning of
 rxrpc_local object
Message-ID: <20200202122735.157d8b44@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <158047737679.133127.13567286503234295.stgit@warthog.procyon.org.uk>
References: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
        <158047737679.133127.13567286503234295.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 13:29:36 +0000, David Howells wrote:
> diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
> index 808a4723f868..abfff3e0921c 100644
> --- a/net/rxrpc/conn_event.c
> +++ b/net/rxrpc/conn_event.c
> @@ -133,6 +133,8 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
>  		break;
>  	}
>  
> +	BUG_ON(!conn->params.local);
> +	BUG_ON(!conn->params.local->socket);

Is this really, really not possible to convert those into a WARN_ON()
and return?

>  	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, ioc, len);
>  	conn->params.peer->last_tx_at = ktime_get_seconds();
>  	if (ret < 0)

