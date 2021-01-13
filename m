Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9564E2F55EC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbhANAA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 19:00:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729675AbhAMX5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C46121734;
        Wed, 13 Jan 2021 23:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610582213;
        bh=V0652LK2rYvFrQLQilK2ZsEoQfHwxsO6hZ2J1HXl7pA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WA1VVGs1ziZwejLJIaBT45VPD8gLLvuRhUlMTXtWhIY8hODuh8bRcZxQ0NHfT63ef
         TVlH59IjBJoXTBtA4ARgKPxWRdbFEcFbLXATsC4nJ+kVZFbPJAg0vV+E8bZFbBwBk6
         1bSGtGTMS21kcXJm0WTY/Jp3pRn+/1wTg1H157OK/0lDMHdi7EqFpBeVmkKEPC/uea
         pifPm/UzCI+JNJVb1hbpaqo/90QRn1UlVmnF5P1ztlEDOaJ7sE5FiRSfU8eQEzlvuz
         +uHAsKFMvVLZYtyDhcQrfGoV7tOIU/8bxP0YVLyXJ2HjV8CowH/UvYjFufkRSKLYuN
         haZ3zNwHV+pDA==
Date:   Wed, 13 Jan 2021 15:56:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v3 06/13] selftests: Use separate stdout and
 stderr buffers in nettest
Message-ID: <20210113155652.5fd41775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113040040.50813-7-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
        <20210113040040.50813-7-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 21:00:33 -0700 David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> When a single instance of nettest is doing both client and
> server modes, stdout and stderr messages can get interlaced
> and become unreadable. Allocate a new set of buffers for the
> child process handling server mode.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/testing/selftests/net/nettest.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
> index 685cbe8933de..9114bc823092 100644
> --- a/tools/testing/selftests/net/nettest.c
> +++ b/tools/testing/selftests/net/nettest.c
> @@ -1707,9 +1707,27 @@ static char *random_msg(int len)
>  
>  static int ipc_child(int fd, struct sock_args *args)
>  {
> +	char *outbuf, *errbuf;
> +	int rc;
> +
> +	outbuf = malloc(4096);
> +	errbuf = malloc(4096);
> +	if (!outbuf || !errbuf) {
> +		fprintf(stderr, "server: Failed to allocate buffers for stdout and stderr\n");
> +		return 1;

So this patch did not change? Did you send the wrong version,
or am I missing something?

> +	}
> +
> +	setbuffer(stdout, outbuf, 4096);
> +	setbuffer(stderr, errbuf, 4096);
> +
>  	server_mode = 1; /* to tell log_msg in case we are in both_mode */
>  
> -	return do_server(args, fd);
> +	rc = do_server(args, fd);
> +
> +	free(outbuf);
> +	free(errbuf);
> +
> +	return rc;
>  }
>  
>  static int ipc_parent(int cpid, int fd, struct sock_args *args)

