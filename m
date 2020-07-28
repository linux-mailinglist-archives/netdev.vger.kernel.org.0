Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68925230E5C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgG1Prt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730842AbgG1Prt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:47:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778682065E;
        Tue, 28 Jul 2020 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595951268;
        bh=OupWXseUQlQcvkUuzQz9fU8bHfZdR+BlUJ5mPXy3q3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sRkcOHDTdQIFMCji/m271eOdEW9f8YINHCo5V6/RmMkmocNmAbJgGsjjUibjYUaay
         +S8jkgUFBuNlq1xIRfDEnPwBsyrKxkJlik5oGLOgpg+nXIoz3JdrHklSA9yOKsZVbz
         8rZ84FA5omZKwoYQudG+PvC0IsOKlmKDeOBKvKeE=
Date:   Tue, 28 Jul 2020 08:47:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jan Engelhardt <jengelh@inai.de>,
        Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Message-ID: <20200728084746.06f52878@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728063643.396100-5-hch@lst.de>
References: <20200728063643.396100-1-hch@lst.de>
        <20200728063643.396100-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 08:36:43 +0200 Christoph Hellwig wrote:
> Make sure not just the pointer itself but the whole range lies in
> the user address space.  For that pass the length and then use
> the access_ok helper to do the check.
> 
> Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
> Reported-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
> index 94f18d2352d007..8b132c52045973 100644
> --- a/net/ipv4/bpfilter/sockopt.c
> +++ b/net/ipv4/bpfilter/sockopt.c
> @@ -65,7 +65,7 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
>  
>  	if (get_user(len, optlen))
>  		return -EFAULT;
> -	err = init_user_sockptr(&optval, user_optval);
> +	err = init_user_sockptr(&optval, user_optval, *optlen);
>  	if (err)
>  		return err;
>  	return bpfilter_mbox_request(sk, optname, optval, len, false);

Appears to cause these two new warnings, sadly:

net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression
net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression
