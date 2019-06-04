Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8C3347CA
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfFDNOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:14:00 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:55601 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbfFDNOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 09:14:00 -0400
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id BAA8C200CC;
        Tue,  4 Jun 2019 15:13:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1559654031; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uuat3jEUgV8d8Ls/g6U2agD8YFGq9VD0MoYpCf6RTtE=;
        b=jbJA1LoMy6ZCrN+Yt7gIMk/+5Jeb1t7lbzGGwwakeH3JdRsN51rsO47xUy2PvFva9lwLUb
        lLykpLmrMnIIwKNyFtk7ZJS/oEvge4iO6O+2PRd9o2lJtMPKb34xkQq5WOPrzBsEJd585J
        g7WiJMjlrwqyfNy9nkH7CypdTokQJgR4It37Oq9YyP0CVqEZaIXTLK2G60XF3Fbtih0r6g
        EZxwPmTpYnuP0i1+JdFnadHY98R8jRmYZcPtAVWGuAHo5X2Nq4eM58zSkWkX6FTHvW++5o
        AipUvdLe1rM0SKWdvVgUidigbKTpUUOzyhBpTEibLMCSjWLOLb9P5EIrtTOtxA==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id C7BAFBEEBD;
        Tue,  4 Jun 2019 15:13:50 +0200 (CEST)
Message-ID: <5CF66E8E.1050100@bfs.de>
Date:   Tue, 04 Jun 2019 15:13:50 +0200
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Young Xiao <92siuyang@gmail.com>
CC:     ralf@linux-mips.org, davem@davemloft.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rose: af_rose: avoid overflows in rose_setsockopt()
References: <1559650290-17054-1-git-send-email-92siuyang@gmail.com>
In-Reply-To: <1559650290-17054-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.10
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-3.10 / 7.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         MIME_GOOD(-0.10)[text/plain];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         RCPT_COUNT_FIVE(0.00)[6];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM(-0.00)[-0.999,0];
         FREEMAIL_TO(0.00)[gmail.com];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_TLS_ALL(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 04.06.2019 14:11, schrieb Young Xiao:
> Check setsockopt arguments to avoid overflows and return -EINVAL for
> too large arguments.
> 
> See commit 32288eb4d940 ("netrom: avoid overflows in nr_setsockopt()")
> for details.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/rose/af_rose.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index e274bc6..af831ee9 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -372,15 +372,15 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
>  {
>  	struct sock *sk = sock->sk;
>  	struct rose_sock *rose = rose_sk(sk);
> -	int opt;
> +	unsigned long opt;
>  
>  	if (level != SOL_ROSE)
>  		return -ENOPROTOOPT;
>  
> -	if (optlen < sizeof(int))
> +	if (optlen < sizeof(unsigned int))
>  		return -EINVAL;

I do not thing that this will change much,
but maybe you would like to check against the sizeof (opt) here ?


>  
> -	if (get_user(opt, (int __user *)optval))
> +	if (get_user(opt, (unsigned int __user *)optval))
>  		return -EFAULT;
>  
>  	switch (optname) {
> @@ -389,31 +389,31 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
>  		return 0;
>  


>  	case ROSE_T1:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->t1 = opt * HZ;
>  		return 0;
>  
>  	case ROSE_T2:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->t2 = opt * HZ;
>  		return 0;
>  
>  	case ROSE_T3:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->t3 = opt * HZ;
>  		return 0;
>  
>  	case ROSE_HOLDBACK:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->hb = opt * HZ;
>  		return 0;

 you can simplify this jungle by checking and calculation first
 and then set the correct rose->XX

>  
>  	case ROSE_IDLE:
> -		if (opt < 0)
> +		if (opt < 0 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;

You made opt unsigned or ?

>  		rose->idle = opt * 60 * HZ;
>  		return 0;

my 2 cents,

re,
 wh
