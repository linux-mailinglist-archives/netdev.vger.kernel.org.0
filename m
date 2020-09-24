Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D41277B61
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgIXV5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgIXV5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 17:57:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CDC23A82;
        Thu, 24 Sep 2020 21:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600984636;
        bh=dz+70HgZBKM9ejrD/TEkpPH2CFUVTmKBDkgzQZhdzUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zs1Xl06NstQhbZuSzzUq+jbqT4tmLHL2znJW+MTxvQ2gUZzMLakKHff3oByyUhS40
         Qy+/MYZft5oRi1NMsYn9UjiJtuO35vOme3W8WGHDhXGaCqIZ0zh3mYg+ZV7JJlzM17
         MqlaaOHRXjJRgR8N35EWWBXERhi3NV8to6T/3MDU=
Date:   Thu, 24 Sep 2020 14:57:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vakul.garg@nxp.com,
        secdev@chelsio.com
Subject: Re: [PATCH net] net/tls: sendfile fails with ktls offload
Message-ID: <20200924145714.761f7c6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924075025.11626-1-rohitm@chelsio.com>
References: <20200924075025.11626-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 13:20:25 +0530 Rohit Maheshwari wrote:
> At first when sendpage gets called, if there is more data, 'more' in
> tls_push_data() gets set which later sets pending_open_record_frags, but
> when there is no more data in file left, and last time tls_push_data()
> gets called, pending_open_record_frags doesn't get reset. And later when
> 2 bytes of encrypted alert comes as sendmsg, it first checks for
> pending_open_record_frags, and since this is set, it creates a record with
> 0 data bytes to encrypt, meaning record length is prepend_size + tag_size
> only, which causes problem.

Agreed, looks like the value in pending_open_record_frags may be stale.

>  We should set/reset pending_open_record_frags based on more bit.

I think you implementation happens to work because there is always left
over data when more is set, but I don't think that has to be the case.

Also shouldn't we update this field or destroy the record before the
break on line 478?

> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  net/tls/tls_device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index b74e2741f74f..a02aadefd86e 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -492,11 +492,11 @@ static int tls_push_data(struct sock *sk,
>  		if (!size) {
>  last_record:
>  			tls_push_record_flags = flags;
> -			if (more) {
> -				tls_ctx->pending_open_record_frags =
> -						!!record->num_frags;
> +			/* set/clear pending_open_record_frags based on more */
> +			tls_ctx->pending_open_record_frags = !!more;
> +
> +			if (more)
>  				break;
> -			}
>  
>  			done = true;
>  		}

