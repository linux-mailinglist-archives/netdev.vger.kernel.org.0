Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8970D2A8F6C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKFGXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:23:17 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:38517 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKFGXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 01:23:17 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kav9Q-0003pc-FY; Fri, 06 Nov 2020 07:23:08 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kav9P-0004R8-13; Fri, 06 Nov 2020 07:23:07 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1128724004B;
        Fri,  6 Nov 2020 07:23:06 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 79F50240049;
        Fri,  6 Nov 2020 07:23:05 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 12439205F3;
        Fri,  6 Nov 2020 07:23:05 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Nov 2020 07:23:05 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, xiyuyang19@fudan.edu.cn
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/x25: Fix null-ptr-deref in x25_connect
Organization: TDT AG
In-Reply-To: <20201006054558.19453-1-ms@dev.tdt.de>
References: <20201006054558.19453-1-ms@dev.tdt.de>
Message-ID: <9751fc51170c9bf776e03d079a3e92e3@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1604643787-000074F7-2FECC0C1/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-06 07:45, Martin Schiller wrote:
> This fixes a regression for blocking connects introduced by commit
> 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 
> disconnect").
> 
> The x25->neighbour is already set to "NULL" by x25_disconnect() now,
> while a blocking connect is waiting in
> x25_wait_for_connection_establishment(). Therefore x25->neighbour must
> not be accessed here again and x25->state is also already set to
> X25_STATE_0 by x25_disconnect().
> 
> Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 
> disconnect")
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> ---
> 
> Change from v1:
> also handle interrupting signals correctly
> 
> ---
>  net/x25/af_x25.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index 0bbb283f23c9..046d3fee66a9 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -825,7 +825,7 @@ static int x25_connect(struct socket *sock, struct
> sockaddr *uaddr,
>  	sock->state = SS_CONNECTED;
>  	rc = 0;
>  out_put_neigh:
> -	if (rc) {
> +	if (rc && x25->neighbour) {
>  		read_lock_bh(&x25_list_lock);
>  		x25_neigh_put(x25->neighbour);
>  		x25->neighbour = NULL;

@David
Is there anything left I need to do, to get this fix merged?

