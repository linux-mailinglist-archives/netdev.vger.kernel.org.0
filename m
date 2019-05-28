Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B4F2CBFB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfE1Qas convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 May 2019 12:30:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfE1Qas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 12:30:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 092193087948;
        Tue, 28 May 2019 16:30:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-173.rdu2.redhat.com [10.10.120.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCFFE5D9CD;
        Tue, 28 May 2019 16:30:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190528142424.19626-3-geert@linux-m68k.org>
References: <20190528142424.19626-3-geert@linux-m68k.org> <20190528142424.19626-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     dhowells@redhat.com, Igor Konopko <igor.j.konopko@intel.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4653.1559061019.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 28 May 2019 17:30:19 +0100
Message-ID: <4654.1559061019@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 28 May 2019 16:30:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> While this is not a real false-positive, I believe it cannot cause harm
> in practice, as AF_RXRPC cannot be used with other transport families
> than IPv4 and IPv6.

Agreed.

> ---
>  net/rxrpc/output.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
> index 004c762c2e8d063c..1473d774d67100c5 100644
> --- a/net/rxrpc/output.c
> +++ b/net/rxrpc/output.c
> @@ -403,8 +403,10 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
>  
>  	/* send the packet with the don't fragment bit set if we currently
>  	 * think it's small enough */
> -	if (iov[1].iov_len >= call->peer->maxdata)
> +	if (iov[1].iov_len >= call->peer->maxdata) {
> +		ret = 0;
>  		goto send_fragmentable;
> +	}
>  
>  	down_read(&conn->params.local->defrag_sem);
>  

Simply setting 0 is wrong.  That would give the impression that the thing
worked if support for a new transport address family was added and came
through this function without full modification (say AF_INET7 becomes a
thing).

A better way to do things would be to add a default case into the
send_fragmentable switch statement that either BUG's or sets -EAFNOSUPPORT.

David
