Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7085315106A
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 20:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgBCTmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 14:42:01 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51433 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgBCTmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 14:42:01 -0500
Received: by mail-pj1-f66.google.com with SMTP id fa20so207150pjb.1;
        Mon, 03 Feb 2020 11:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YGczli9kRu4G0EE9ppK/ZW7lnNhHOnn2KrgcFZjo3F4=;
        b=blwMci7mz2N1tkDktCs7E8urYt8dkZzBulEzDjpsEAoBCH5Tr6zzMpRIR/HoARACOm
         IG0wWVpsEohRwVOfHGozsf5HfwkcTNg1U37D+ur6vAtJCBa1auwM8OQMrWQk5nrBXUrC
         9ynCssqpweEyHNU4HKfBZqZD+3jNIODCwtiEwXjMw8rU8I5UhSjWaUGQ1ZfCpPr52B/H
         YoJCEDGrgrb/NHwfdEJuqBPnN6E/Q1W/1uvwyTkf5Arp4kxLo5djNwsXPjvzWaBlOza3
         H8EetcxskLdns/GY62bKN9LDERXs/kWH8QxaNtKW9+4/XEYkYiGTQMyN85f0Eheb2cFg
         Yrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YGczli9kRu4G0EE9ppK/ZW7lnNhHOnn2KrgcFZjo3F4=;
        b=CWzFbdeLf5EOdY+Py2HzNOWZ7KHO6zcRFBFErdRL+M1rHAqDvU0wPuYMAa2NJIT1ls
         CvNIhzhGMAjDbFyjiPjm4J3Ybai+qvYueGDxHBeMAaBHUvln1xetmkbtLj/OAN2y14/A
         Si5taOJ2MVNwCsx2eZxFnw7V+i//aqSw4/BDKAgi5H4kOtjBqfVt3+7M1CFgH5WbXORL
         tzIzmxhjTtOXpSKh9tgpiZ0Brh+xwBw0EYaxFCnUf+uzMKaYaZD5yY2/sP/FKJ4b54aW
         sGmnu+7H+YaIwQvPK15UN3jEl+0efPWAVXTjb+uk9W+AqfFxH4bTOGkQ2KH27UqA5Ycp
         dn1Q==
X-Gm-Message-State: APjAAAX3B5BvGXngky7IpzaRXK9w741hFfe/I6J2fnbzcSTXEMz4HPdD
        1kp/k1Xeiiro4Cn79kGdjBH1Ts8p
X-Google-Smtp-Source: APXvYqyHBg00+skHe0SQxFojfwHROIQ+ILJSjqjBWz4Bl8u6mjcuR+1vYWCWIwAOx63W1quZyKt4mg==
X-Received: by 2002:a17:902:7d93:: with SMTP id a19mr24912115plm.283.1580758920688;
        Mon, 03 Feb 2020 11:42:00 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id x21sm20686309pfn.164.2020.02.03.11.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 11:42:00 -0800 (PST)
Subject: Re: [PATCH] skbuff: fix a data race in skb_queue_len()
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     kuba@kernel.org, elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1580756190-3541-1-git-send-email-cai@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <648d6673-bbd8-6634-0174-f9b77194ecfd@gmail.com>
Date:   Mon, 3 Feb 2020 11:41:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1580756190-3541-1-git-send-email-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/20 10:56 AM, Qian Cai wrote:
> sk_buff.qlen can be accessed concurrently as noticed by KCSAN,
> 
>  BUG: KCSAN: data-race in __skb_try_recv_from_queue / unix_dgram_sendmsg
> 
>  read to 0xffff8a1b1d8a81c0 of 4 bytes by task 5371 on cpu 96:
>   unix_dgram_sendmsg+0x9a9/0xb70 include/linux/skbuff.h:1821
> 				 net/unix/af_unix.c:1761
>   ____sys_sendmsg+0x33e/0x370
>   ___sys_sendmsg+0xa6/0xf0
>   __sys_sendmsg+0x69/0xf0
>   __x64_sys_sendmsg+0x51/0x70
>   do_syscall_64+0x91/0xb47
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
>  write to 0xffff8a1b1d8a81c0 of 4 bytes by task 1 on cpu 99:
>   __skb_try_recv_from_queue+0x327/0x410 include/linux/skbuff.h:2029
>   __skb_try_recv_datagram+0xbe/0x220
>   unix_dgram_recvmsg+0xee/0x850
>   ____sys_recvmsg+0x1fb/0x210
>   ___sys_recvmsg+0xa2/0xf0
>   __sys_recvmsg+0x66/0xf0
>   __x64_sys_recvmsg+0x51/0x70
>   do_syscall_64+0x91/0xb47
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Since only the read is operating as lockless, it could introduce a logic
> bug in unix_recvq_full() due to the load tearing. Fix it by adding
> a READ_ONCE() there.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  include/linux/skbuff.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3d13a4b717e9..4b5157164f3e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1818,7 +1818,7 @@ static inline struct sk_buff *skb_peek_tail(const struct sk_buff_head *list_)
>   */
>  static inline __u32 skb_queue_len(const struct sk_buff_head *list_)
>  {
> -	return list_->qlen;
> +	return READ_ONCE(list_->qlen);
>  }

We do not want to add READ_ONCE() for all uses of skb_queue_len()

This could hide some real bugs, and could generate slightly less
efficient code in the cases we have the lock held.



