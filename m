Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF39E2582E4
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgHaUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgHaUja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 16:39:30 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34AD2078B;
        Mon, 31 Aug 2020 20:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598906369;
        bh=l8jxjn/rMeXl1xTr/TAWKe9Rt5YZz1pcuYU7jXMBbv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1PeMevtCw8CwCifvJ+s/HCFOsVW6OEn1CN4vDyCxy7fJ09pcDHkwV1YalcP96rJbM
         ZYR+njDjdonzAHaP5oueE7DhWIPojdgPv0Yxmuc12QeCYBfFeRaBVHOMhpfFI10dUk
         MbhctG9Szz4x0xuPgoeEycNr3YSspt3ftfZkb5e8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kCqaN-0086VA-S6; Mon, 31 Aug 2020 21:39:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 31 Aug 2020 21:39:27 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     syzbot <syzbot+e24baf53dc389927a7c3@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in sock_close
In-Reply-To: <20200831200328.GX1236603@ZenIV.linux.org.uk>
References: <000000000000dc862405ae31ae9b@google.com>
 <20200831200328.GX1236603@ZenIV.linux.org.uk>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <82748fc422a64d70c706951954a2dcfa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: viro@zeniv.linux.org.uk, syzbot+e24baf53dc389927a7c3@syzkaller.appspotmail.com, davem@davemloft.net, kuba@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-31 21:03, Al Viro wrote:
> On Mon, Aug 31, 2020 at 12:48:13PM -0700, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    15bc20c6 Merge tag 'tty-5.9-rc3' of 
>> git://git.kernel.org/p..
>> git tree:       upstream
>> console output: 
>> https://syzkaller.appspot.com/x/log.txt?x=16a85669900000
>> kernel config:  
>> https://syzkaller.appspot.com/x/.config?x=891ca5711a9f1650
>> dashboard link: 
>> https://syzkaller.appspot.com/bug?extid=e24baf53dc389927a7c3
>> compiler:       clang version 10.0.0 
>> (https://github.com/llvm/llvm-project/ 
>> c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>> syz repro:      
>> https://syzkaller.appspot.com/x/repro.syz?x=127d3c99900000
> 
>> The issue was bisected to:
>> 
>> commit a9ed4a6560b8562b7e2e2bed9527e88001f7b682
>> Author: Marc Zyngier <maz@kernel.org>
>> Date:   Wed Aug 19 16:12:17 2020 +0000
>> 
>>     epoll: Keep a reference on files added to the check list
> 
> All of those are essentially duplicates.
> 
> The minimal fix is below; I'm not happy with it long-term, but I'm 
> still
> digging through the eventpoll locking, and there's a good chance that 
> this
> is the least intrusive variant for -stable.  Folks, could you check if 
> the
> following patch fixes those suckers?  Again, all reports bisected to 
> that
> commit are essentially the same.
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index e0decff22ae2..8107e06d7f6f 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1995,9 +1995,9 @@ static int ep_loop_check_proc(void *priv, void
> *cookie, int call_nests)
>  			 * during ep_insert().
>  			 */
>  			if (list_empty(&epi->ffd.file->f_tfile_llink)) {
> -				get_file(epi->ffd.file);
> -				list_add(&epi->ffd.file->f_tfile_llink,
> -					 &tfile_check_list);
> +				if (get_file_rcu(epi->ffd.file))
> +					list_add(&epi->ffd.file->f_tfile_llink,
> +						 &tfile_check_list);
>  			}
>  		}
>  	}

I've managed to reproduce the issue using [1] (throw a few in a VM,
see things explode like clockwork).

With this patch on top of -rc3, the VM keep ticking away. FWIW:

Tested-by: Marc Zyngier <maz@kernel.org>
Fixes: a9ed4a6560b8 ("epoll: Keep a reference on files added to the 
check list")

Thanks,

         M.

[1] https://syzkaller.appspot.com/x/repro.c?x=140a19a9900000
-- 
Jazz is not dead. It just smells funny...
