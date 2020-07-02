Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C6212644
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgGBO3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:29:05 -0400
Received: from mail.efficios.com ([167.114.26.124]:48968 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbgGBO3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:29:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 378542D6FE7;
        Thu,  2 Jul 2020 10:29:04 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 16wex3xvqnFK; Thu,  2 Jul 2020 10:29:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id DACC32D6FE6;
        Thu,  2 Jul 2020 10:29:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com DACC32D6FE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593700143;
        bh=UzT2Ee3iLDLbSoOdnu33l5Ys12GhSDKJvLSq2vPadho=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=NyEek19B0VrIploDVsjX70UuEI9E/95zHT5Q5KdqIDA3/87aQo8u0X+YJndJA8cvo
         KuJJxJ6FlEmONYcJCRTP03mJRQXqNo634A36TGOieiXApI+5k0XfbVWvPXZxh97EUC
         0J/N83qAW7SMj6aylGUtYIax0Uf+2XctzYG1RUB7JVUt7XoOAbkF/WiqYsznN0zmC3
         m1TX6YdEc0XXq437aO4ym/YIim3y6HcIQ6Acztbw6lK6H6IcZTbMPg9X6R7II1nHFp
         mJI9y3A9K+OsVRmOTmxjXL4DE6ZASVyNzoBs1LxS3fgiFORA5hwhqQ5g7WRCfoFeVg
         3PnspnaedLQWg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rF8FRh_vHhWo; Thu,  2 Jul 2020 10:29:03 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id CF54B2D6FE5;
        Thu,  2 Jul 2020 10:29:03 -0400 (EDT)
Date:   Thu, 2 Jul 2020 10:29:03 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <708841049.20220.1593700143737.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200702013933.4157053-1-edumazet@google.com>
References: <20200702013933.4157053-1-edumazet@google.com>
Subject: Re: [PATCH net] tcp: md5: allow changing MD5 keys in all socket
 states
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: allow changing MD5 keys in all socket states
Thread-Index: 3pm5iCzB4TPUE3dXL0iOs+CLnAsxmQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jul 1, 2020, at 9:39 PM, Eric Dumazet edumazet@google.com wrote:

> This essentially reverts commit 721230326891 ("tcp: md5: reject TCP_MD5SIG
> or TCP_MD5SIG_EXT on established sockets")
> 
> Mathieu reported that many vendors BGP implementations can
> actually switch TCP MD5 on established flows.
> 
> Quoting Mathieu :
>   Here is a list of a few network vendors along with their behavior
>   with respect to TCP MD5:
> 
>   - Cisco: Allows for password to be changed, but within the hold-down
>     timer (~180 seconds).
>   - Juniper: When password is initially set on active connection it will
>     reset, but after that any subsequent password changes no network
>     resets.
>   - Nokia: No notes on if they flap the tcp connection or not.
>   - Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
>     both sides are ok with new passwords.
>   - Meta-Switch: Expects the password to be set before a connection is
>     attempted, but no further info on whether they reset the TCP
>     connection on a change.
>   - Avaya: Disable the neighbor, then set password, then re-enable.
>   - Zebos: Would normally allow the change when socket connected.
> 
> We can revert my prior change because commit 9424e2e7ad93 ("tcp: md5: fix
> potential
> overestimation of TCP option space") removed the leak of 4 kernel bytes to
> the wire that was the main reason for my patch.

Hi Eric,

This is excellent news! Thanks for looking into it.

As this revert re-enables all ABI scenarios previously supported, I suspect
this means knowing whether transitions of live TCP sockets from no-md5 to
enabled-md5 is often used in practice is now irrelevant ?

Thanks,

Mathieu


> 
> While doing my investigations, I found a bug when a MD5 key is changed, leading
> to these commits that stable teams want to consider before backporting this
> revert :
> 
> Commit 6a2febec338d ("tcp: md5: add missing memory barriers in
> tcp_md5_do_add()/tcp_md5_hash_key()")
> Commit e6ced831ef11 ("tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key()
> barriers")
> 
> Fixes: 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on
> established sockets"
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
> net/ipv4/tcp.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index
> c33f7c6aff8eea81d374644cd251bd2b96292651..861fbd84c9cf58af4126c80a27925cd6f70f300d
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3246,10 +3246,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
> #ifdef CONFIG_TCP_MD5SIG
> 	case TCP_MD5SIG:
> 	case TCP_MD5SIG_EXT:
> -		if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
> -			err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
> -		else
> -			err = -EINVAL;
> +		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
> 		break;
> #endif
> 	case TCP_USER_TIMEOUT:
> --
> 2.27.0.212.ge8ba1cc988-goog

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
