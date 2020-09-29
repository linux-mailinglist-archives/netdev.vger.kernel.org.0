Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA98F27BA6B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgI2Bn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgI2Bn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:43:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8830C061755;
        Mon, 28 Sep 2020 18:43:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E92F127A2A44;
        Mon, 28 Sep 2020 18:26:39 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:43:26 -0700 (PDT)
Message-Id: <20200928.184326.1754311969939569006.davem@davemloft.net>
To:     ms@dev.tdt.de
Cc:     andrew.hendry@gmail.com, kuba@kernel.org, edumazet@google.com,
        xiyuyang19@fudan.edu.cn, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/x25: Fix null-ptr-deref in x25_connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928092327.329-1-ms@dev.tdt.de>
References: <20200928092327.329-1-ms@dev.tdt.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:26:39 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>
Date: Mon, 28 Sep 2020 11:23:27 +0200

> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index 0bbb283f23c9..0524a5530b91 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -820,7 +820,7 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
>  
>  	rc = x25_wait_for_connection_establishment(sk);
>  	if (rc)
> -		goto out_put_neigh;
> +		goto out;

If x25_wait_for_connection_establishment() returns because of an interrupting
signal, we are not going to call x25_disconnect().

The case you are fixing only applies _sometimes_ when
x25_wait_for_connection_establishment() returns.  But not always.

That neighbour has to be released at this spot otherwise.
