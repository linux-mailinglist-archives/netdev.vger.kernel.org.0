Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A795ACD5
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfF2SRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:17:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfF2SRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:17:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC38714B8D0F7;
        Sat, 29 Jun 2019 11:17:20 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:17:20 -0700 (PDT)
Message-Id: <20190629.111720.426281750197769692.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        liuhangbin@gmail.com,
        syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com
Subject: Re: [PATCH net] igmp: fix memory leak in igmpv3_del_delrec()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627082701.226711-1-edumazet@google.com>
References: <20190627082701.226711-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 11:17:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 27 Jun 2019 01:27:01 -0700

> im->tomb and/or im->sources might not be NULL, but we
> currently overwrite their values blindly.
> 
> Using swap() will make sure the following call to kfree_pmc(pmc)
> will properly free the psf structures.
> 
> Tested with the C repro provided by syzbot, which basically does :
> 
>  socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
>  setsockopt(3, SOL_IP, IP_ADD_MEMBERSHIP, "\340\0\0\2\177\0\0\1\0\0\0\0", 12) = 0
>  ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=0}) = 0
>  setsockopt(3, SOL_IP, IP_MSFILTER, "\340\0\0\2\177\0\0\1\1\0\0\0\1\0\0\0\377\377\377\377", 20) = 0
>  ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=IFF_UP}) = 0
>  exit_group(0)                    = ?
> 
> BUG: memory leak
> unreferenced object 0xffff88811450f140 (size 64):
 ...
> Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info when set link down")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks.
