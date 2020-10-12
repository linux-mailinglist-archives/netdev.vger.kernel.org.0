Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2946A28AF7D
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgJLH7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgJLH7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:59:31 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B8DC0613CE
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 00:59:30 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id B3EDCC009; Mon, 12 Oct 2020 09:59:25 +0200 (CEST)
Date:   Mon, 12 Oct 2020 09:59:10 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: 9p: initialize sun_server.sun_path to have
 addr's value only when addr is valid
Message-ID: <20201012075910.GA17745@nautica>
References: <20201012042404.2508-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201012042404.2508-1-anant.thazhemadam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anant Thazhemadam wrote on Mon, Oct 12, 2020:
> In p9_fd_create_unix, checking is performed to see if the addr (passed
> as an argument) is NULL or not.
> However, no check is performed to see if addr is a valid address, i.e.,
> it doesn't entirely consist of only 0's.
> The initialization of sun_server.sun_path to be equal to this faulty
> addr value leads to an uninitialized variable, as detected by KMSAN.
> Checking for this (faulty addr) and returning a negative error number
> appropriately, resolves this issue.

I'm not sure I agree a fully zeroed address is faulty but I agree we can
probably refuse it given userspace can't pass useful abstract addresses
here.

Just one nitpick but this is otherwise fine - good catch!

> Reported-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
> Tested-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> ---
>  net/9p/trans_fd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index c0762a302162..8f528e783a6c 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -1023,7 +1023,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
>  
>  	csocket = NULL;
>  
> -	if (addr == NULL)
> +	if (!addr || !strlen(addr))

Since we don't care about the actual length here, how about checking for
addr[0] directly?
That'll spare a strlen() call in the valid case.

Well, I guess it doesn't really matter -- I'll queue this up anyway and
update if you resend.


Thanks,
-- 
Dominique
