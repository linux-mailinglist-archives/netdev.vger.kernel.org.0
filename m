Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347DE2DF87
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfE2OU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:20:26 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37985 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfE2OUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:20:25 -0400
Received: by mail-yb1-f196.google.com with SMTP id x7so852186ybg.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 07:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mUy0z4iSw34EaGviaEu3i8ULKI62dWY3xWhXEM5Or4o=;
        b=nX8vkcdpQ250rHdvswa6gSnnyCCuekV8Y/Xr/b1Ri+6EQz6pcC8HEhm20DkF2803/V
         6h4uIWinRWCh1BLMcqyteNi4gUowgMqyaN9NNPmqciBKaKI8vh1ZpBzv6uMJxsgecn+j
         vQFdeX2+iCimufwEDA5tgOWlK106FwR2egiV1Dy+xm+Kw7mH+o4FraKUgNUZSUOgdsCN
         DJgLZ4t/ICEO/KVZwe+PALiCzoWeOzrFY+fIlzSQZy7Nstf97VU24MORsPYPuMhihveb
         yMhjcKftyqHLorJrSLOpvXLQG21/Idq4GwHtM+djB/XebFWT2bd+oF/F0aXQViFD0RAE
         plpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mUy0z4iSw34EaGviaEu3i8ULKI62dWY3xWhXEM5Or4o=;
        b=DhQAVgPZ00f+LTM03kWOv8UUhV/QhTDi3i87xwrJUk0tVg6T1k6JumprtppDMDXVSJ
         n/8T9Skcof3QPo3vHw9ZYijo+qfG7nM6dPJmjOgXkvzL4LbzUbTf22pImFGOD/OqKPnj
         RPfk+easj34SgYaJMBwBm7tYsW9DbFZBRB58je9vxIwT/wxfbh5rQ/jmY8X5PPRMYiVv
         vhZPQWJ+rUSSnwgFcxj7myD9PsrmP4wMRGm55QW7nH7i7CIwZglB6hJUW0iqSACwr0+s
         8w9N8XHFg3XQBExAbXHRUm1vUVb6RteKlJ5GcrOaQQHaN7L8j5LDOFiKte4pcl8aiRwA
         BgwA==
X-Gm-Message-State: APjAAAUohC0E5VYw2XNw6keyAYnmM4uZMvK7rfeqKVD2/lUkrLC8/g3S
        uKdv7zeIcRp+vkn9mkYnJmcjb789/YbvRQiQ0VfJJg==
X-Google-Smtp-Source: APXvYqzuGn7f+/A1+DvTXLL0+G25nRQoJzz2tfgcamvslvVhXbiLT1ISami0iRSa6tkNePNALyPbKXpwvT+5t8QFdjg=
X-Received: by 2002:a25:7642:: with SMTP id r63mr31031362ybc.253.1559139624452;
 Wed, 29 May 2019 07:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <1559117459-27353-1-git-send-email-92siuyang@gmail.com>
In-Reply-To: <1559117459-27353-1-git-send-email-92siuyang@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 May 2019 07:20:12 -0700
Message-ID: <CANn89iLxxiX+4E7EURNKb=xRkk97rPaKTkpSc6Yu7fZbiwPT6w@mail.gmail.com>
Subject: Re: [PATCH] ipv4: tcp_input: fix stack out of bounds when parsing TCP options.
To:     Young Xiao <92siuyang@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 1:10 AM Young Xiao <92siuyang@gmail.com> wrote:
>
> The TCP option parsing routines in tcp_parse_options function could
> read one byte out of the buffer of the TCP options.
>
> 1         while (length > 0) {
> 2                 int opcode = *ptr++;
> 3                 int opsize;
> 4
> 5                 switch (opcode) {
> 6                 case TCPOPT_EOL:
> 7                         return;
> 8                 case TCPOPT_NOP:        /* Ref: RFC 793 section 3.1 */
> 9                         length--;
> 10                        continue;
> 11                default:
> 12                        opsize = *ptr++; //out of bound access
>
> If length = 1, then there is an access in line2.
> And another access is occurred in line 12.
> This would lead to out-of-bound access.
>
> Therefore, in the patch we check that the available data length is
> larger enough to pase both TCP option code and size.
>
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/ipv4/tcp_input.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 20f6fac..9775825 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3791,6 +3791,8 @@ void tcp_parse_options(const struct net *net,
>                         length--;
>                         continue;
>                 default:
> +                       if (length < 2)
> +                               return;
>                         opsize = *ptr++;
>                         if (opsize < 2) /* "silly options" */
>                                 return;

In practice we are good, since we have at least 320 bytes of room there,
and the test done later catches silly options.

if (opsize < 2) /* "silly options" */
    return;
if (opsize > length)   /* remember, opsize >= 2 here */
     return; /* don't parse partial options */

I guess adding yet another conditional will make this code obviously
correct for all eyes
and various tools.

Thanks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
