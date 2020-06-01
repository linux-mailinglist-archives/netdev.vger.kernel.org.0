Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873301EB1DB
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFAWsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAWsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:48:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA70C061A0E;
        Mon,  1 Jun 2020 15:48:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2E7D11F5F667;
        Mon,  1 Jun 2020 15:48:01 -0700 (PDT)
Date:   Mon, 01 Jun 2020 15:48:00 -0700 (PDT)
Message-Id: <20200601.154800.618496062435048134.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, john.haxby@oracle.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] ipv6: fix IPV6_ADDRFORM operation logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601035503.3594635-1-liuhangbin@gmail.com>
References: <20200601035503.3594635-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 15:48:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon,  1 Jun 2020 11:55:03 +0800

> Socket option IPV6_ADDRFORM supports UDP/UDPLITE and TCP at present.
> Previously the checking logic looks like:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
> 	do_some_check;
> else if (sk->sk_protocol != IPPROTO_TCP)
> 	break;
> 
> After commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation"), TCP
> was blocked as the logic changed to:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
> 	do_some_check;
> else if (sk->sk_protocol == IPPROTO_TCP)
> 	do_some_check;
> 	break;
> else
> 	break;
> 
> Then after commit 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
> UDP/UDPLITE were blocked as the logic changed to:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
> 	do_some_check;
> if (sk->sk_protocol == IPPROTO_TCP)
> 	do_some_check;
> 
> if (sk->sk_protocol != IPPROTO_TCP)
> 	break;
> 
> Fix it by using Eric's code and simply remove the break in TCP check, which
> looks like:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
> 	do_some_check;
> else if (sk->sk_protocol == IPPROTO_TCP)
> 	do_some_check;
> else
> 	break;
> 
> Fixes: 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thank you.
