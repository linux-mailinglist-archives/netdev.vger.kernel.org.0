Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63F1319831
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBLCJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:09:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhBLCJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:09:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 119BB64D9C;
        Fri, 12 Feb 2021 02:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613095734;
        bh=7td3voo4j13agaFAYjTo1aZNgDIVPSlwFPSl756m6Ic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=burtCUXk6OGVcqB6yxSD4wdn6BmCRSyOin1mIv7Wk0sJt3qjdp7o5NkoDQpFucyUK
         lag12Vpw/Hyqfl5UUAql/P6yNUJiSIvL17tPD3F3DTRgtfriQ504YwM8rZodHIg0ip
         cZOViLuv8I6LTvVcu7sTMIggA5VtcCSIcLgWdU2HN12ZAHyHHWhdXKYWaGNgNVnDoj
         ZRnu4Nz9wlxiNeKq1sa+6v+lqn/1iVEcBLKS9/TkvuYXUaLMqL+JH+KZ/Ny6fF66ra
         5X+YWm3Qn7aJOVVLC6RI+csSjMy3A5wBxDBAR9ZOWcs3BdQExhGTysw7GbaeYnnItF
         t1cmuePcZBi1g==
Date:   Thu, 11 Feb 2021 18:08:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [net-next] tcp: Sanitize CMSG flags and reserved args in
 tcp_zerocopy_receive.
Message-ID: <20210211180853.1044fabc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210211212107.662291-1-arjunroy.kdev@gmail.com>
References: <20210211212107.662291-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 13:21:07 -0800 Arjun Roy wrote:
> +		if (unlikely(len > sizeof(zc))) {
> +			err = check_zeroed_user(optval + sizeof(zc),
> +						len - sizeof(zc));
> +			if (err < 1)
> +				return err == 0 ? -EINVAL : err;

nit: return err ? : -EINVAL;

>  			len = sizeof(zc);
>  			if (put_user(len, optlen))
>  				return -EFAULT;
>  		}
>  		if (copy_from_user(&zc, optval, len))
>  			return -EFAULT;
> +		if (zc.reserved)
> +			return -EINVAL;
> +		if (zc.msg_flags &  ~(TCP_VALID_ZC_MSG_FLAGS))

nit: parens unnecessary

But neither is a big deal:

Acked-by: Jakub Kicinski <kuba@kernel.org>
