Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019162F243C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405492AbhALAZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404256AbhALAQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:16:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C80922C7E;
        Tue, 12 Jan 2021 00:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610410547;
        bh=97Pv/SPOh7LTbMDeepoAS9okjWD7GizcM0m0GQ8GNTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qgj4RP/8DKmeR6t7A9CtFtMmDaJ8QZ/6MNFOLOfj+JDHlX+HB9OXvGKktl5rxJmIz
         lk2rQqaeeJlAF5+b80KyrDG96vuWh3dwMzdFqnOvoAja+ds5K6uEDGp3FxAoFLrUGT
         ZQO8f5Z4B6a4U5A9b1xFUJ9gMu/pH+DU2FaESW6IJg1UiIEZ3IDMcXOJdpRBsr5NYJ
         ezR4CxY5En9GPVzHJ5sVe5a8/THci+9K69rKz7+/G1bSwtcJzW9MW1RSc32YY2bBSw
         LmyCNEehoHvuThIiyorRnCKtLAx6+euHh4STR+5+/wwLvovzvjWdGBhe1XhrIAb1sv
         sVqa59N/D2M4Q==
Date:   Mon, 11 Jan 2021 16:15:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v2 06/11] selftests: Use separate stdout and
 stderr buffers in nettest
Message-ID: <20210111161546.1310e9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210110001852.35653-7-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
        <20210110001852.35653-7-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 Jan 2021 17:18:47 -0700 David Ahern wrote:
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
> index 0e4196027d63..13c74774e357 100644
> --- a/tools/testing/selftests/net/nettest.c
> +++ b/tools/testing/selftests/net/nettest.c
> @@ -1705,9 +1705,27 @@ static char *random_msg(int len)
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

that's a memleak, rc = 1, goto free; ?

Also there's a few uses of fprintf(stderr, .. instead of log_error()
is there a reason for it?

I don't think this is a big deal, I'll apply unless you object in time.

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

