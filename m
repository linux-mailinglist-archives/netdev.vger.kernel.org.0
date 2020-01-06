Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B35131121
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 12:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgAFLE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 06:04:58 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:49782 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgAFLE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 06:04:57 -0500
Received: from fsav103.sakura.ne.jp (fsav103.sakura.ne.jp [27.133.134.230])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 006B4ntG070905;
        Mon, 6 Jan 2020 20:04:49 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav103.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav103.sakura.ne.jp);
 Mon, 06 Jan 2020 20:04:49 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav103.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 006B4ieM070892
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 6 Jan 2020 20:04:49 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     David Ahern <dsahern@gmail.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
Date:   Mon, 6 Jan 2020 20:04:42 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/06 13:20, David Ahern wrote:
> Hi:
> 
> The failure is the connect function, not the bind.

Oops, I missed it.

> 
> This change seems more appropriate to me (and fixes the failure):
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index ecea41ce919b..ce5e3be7c111 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2854,7 +2854,7 @@ static int smack_socket_connect(struct socket
> *sock, struct sockaddr *sap,
>                 rc = smack_netlabel_send(sock->sk, (struct sockaddr_in
> *)sap);
>                 break;
>         case PF_INET6:
> -               if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family !=
> AF_INET6)
> +               if (addrlen < SIN6_LEN_RFC2133)
>                         return -EINVAL;

This is called upon connect(), isn't it? Then, it is possible that a socket's
protocol family is PF_INET6 but address given is AF_INET, isn't it? For example,
__ip6_datagram_connect() checks for AF_INET before checking addrlen is at least
SIN6_LEN_RFC2133 bytes. Thus, I think that we need to return 0 if address given
is AF_INET even if socket is PF_INET6.

>  #ifdef SMACK_IPV6_SECMARK_LABELING
>                 rsp = smack_ipv6host_label(sip);
> 
> 
> ie., if the socket family is AF_INET6 the address length should be an
> IPv6 address. The family in the sockaddr is not as important.
> 

Commit b9ef5513c99b was wrong, but we need to also fix commit c673944347ed ?
