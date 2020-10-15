Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2428EC90
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 07:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgJOFMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 01:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgJOFMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 01:12:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360CE206C1;
        Thu, 15 Oct 2020 05:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602738747;
        bh=l66933Qijvlma2H2mJiGIE31Bp4WgAXHjUxLzCCBTQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=17sdWbGEA46Tkwiolaxdp1AEB0ed3BVPASRr7PQB4SPbC5gviCBCQVkxMp2I8Zaj8
         cTftTKMrS7wDdGimIej8j9dznomg+fIQ8Yl6YrS0kF4XQaFGZScTtthPbSw/8cG+CA
         t+NsxnIW58q3s74WKBIBdgvWVV4i+zD6TwYbe7/g=
Date:   Thu, 15 Oct 2020 07:12:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH] net: rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201015051225.GA404970@kroah.com>
References: <20201015001712.72976-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015001712.72976-1-anmol.karan123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 05:47:12AM +0530, Anmol Karn wrote:
> In rose_send_frame(), when comparing two ax.25 addresses, it assigns rose_call to 
> either global ROSE callsign or default port, but when the former block triggers and 
> rose_call is assigned by (ax25_address *)neigh->dev->dev_addr, a NULL pointer is 
> dereferenced by 'neigh' when dereferencing 'dev'.
> 
> - net/rose/rose_link.c
> This bug seems to get triggered in this line:
> 
> rose_call = (ax25_address *)neigh->dev->dev_addr;
> 
> Prevent it by checking NULL condition for neigh->dev before comparing addressed for 
> rose_call initialization.
> 
> Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
> Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> ---
> I am bit sceptical about the error return code, please suggest if anything else is 
> appropriate in place of '-ENODEV'.
> 
>  net/rose/rose_link.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> index f6102e6f5161..92ea6a31d575 100644
> --- a/net/rose/rose_link.c
> +++ b/net/rose/rose_link.c
> @@ -97,6 +97,9 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
>  	ax25_address *rose_call;
>  	ax25_cb *ax25s;
>  
> +	if (!neigh->dev)
> +		return -ENODEV;

How can ->dev not be set at this point in time?  Shouldn't that be
fixed, because it could change right after you check this, right?

thanks,

greg k-h
