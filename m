Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8827E364D8A
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhDSWNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhDSWNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:13:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DF0C06174A;
        Mon, 19 Apr 2021 15:13:17 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYc8Z-006f9S-EQ; Mon, 19 Apr 2021 22:12:59 +0000
Date:   Mon, 19 Apr 2021 22:12:59 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <YH4Aa1zFAWkITsNK@zeniv-ca.linux.org.uk>
References: <20210407000913.2207831-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407000913.2207831-1-pakki001@umn.edu>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:09:12PM -0500, Aditya Pakki wrote:

> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
>  unlock_and_drop:
>  		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
>  		rds_message_put(rm);
> -		if (was_on_sock)
> +		if (was_on_sock && rm)
>  			rds_message_put(rm);

	Look at the code immediately prior to the site of your "fix".
Think for a second what will happen if we *could* get there with rm
equal to NULL (with your patch applied, that is).  Now, try to construct
the sequence of events that would lead to that situation.  Either you
will arrive at a real bug (in which case your fix does not actually
fix anything) *OR* you will get closer to realization that "defensive
programming" tends to be worthless garbage.  In both case the result
would be useful...

	Incidentally, locate the place where that variable is
last modified and find the precondition required for rm == NULL
downstream of that.

	Plainly put, the patch demonstrates either complete lack of
understanding or somebody not acting in good faith.  If it's the latter[1],
may I suggest the esteemed sociologists to fuck off and stop
testing the reviewers with deliberately spewed excrements?

[1] https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf
