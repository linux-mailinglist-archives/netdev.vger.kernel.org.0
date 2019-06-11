Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEB63CA05
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389557AbfFKLat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:30:49 -0400
Received: from mail1.ugh.no ([178.79.162.34]:52304 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389269AbfFKLas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 07:30:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 7D38624C90D;
        Tue, 11 Jun 2019 13:30:47 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at catastrophix.ugh.no
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8FsIYINXlXhs; Tue, 11 Jun 2019 13:30:47 +0200 (CEST)
Received: from [10.255.96.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id E656F24C8FB;
        Tue, 11 Jun 2019 13:30:46 +0200 (CEST)
Subject: Re: [net PATCH] net: tls, correctly account for copied bytes with
 multiple sk_msgs
To:     John Fastabend <john.fastabend@gmail.com>,
        steinar+kernel@gunderson.no, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org
References: <156023370286.5966.10762957456071886488.stgit@ubuntu-kvm1>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <369d7445-6502-9e97-1d25-8d261967c1ab@tomt.net>
Date:   Tue, 11 Jun 2019 13:30:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <156023370286.5966.10762957456071886488.stgit@ubuntu-kvm1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.06.2019 08:15, John Fastabend wrote:
> tls_sw_do_sendpage needs to return the total number of bytes sent
> regardless of how many sk_msgs are allocatedt. Unfortunately, copied
                                      ^ typo
> (the value we return up the stack) is zero'd before each new sk_msg
> is alloced so we only return the copied size of the last sk_msg used.
> 
> The application will then believe only part of its data was sent and
> send the missing chunks again. However, because the data actually was
> sent the receiver will get multiple copies of the same data.

This description doesnt make sense to me as in my testing corruption 
occurs even when sendfile is always returning that it sent all the bytes 
requested. So all this resending(?) likely happens within the kernel.

The fix does appear to work just fine however.

Tested-by: Andre Tomt <andre@tomt.net>

> To reproduce this do multiple copies close to the max record size to
> force the above scenario. Andre created a C program that can easily
> generate this case so we will push a similar selftest for this to
> bpf-next shortly.
> 
> The fix is to _not_ zero the copied field so that the total sent
> bytes is returned.
> 
> Reported-by: Steinar H. Gunderson <steinar+kernel@gunderson.no>
> Reported-by: Andre Tomt <andre@tomt.net>
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   net/tls/tls_sw.c |    1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index d93f83f77864..5fe3dfa2c5e3 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1143,7 +1143,6 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
>   
>   		full_record = false;
>   		record_room = TLS_MAX_PAYLOAD_SIZE - msg_pl->sg.size;
> -		copied = 0;
>   		copy = size;
>   		if (copy >= record_room) {
>   			copy = record_room;
> 

