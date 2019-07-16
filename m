Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12EC6B24D
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 01:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387623AbfGPXU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 19:20:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43346 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbfGPXU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 19:20:59 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-1ff7.dyn6.twc.com ([2606:a000:111b:405a::1ff7] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hnWkc-0005IF-0o; Tue, 16 Jul 2019 19:20:56 -0400
Date:   Tue, 16 Jul 2019 19:20:21 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     vyasevich@gmail.com, marcelo.leitner@gmail.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: OOM triggered by SCTP
Message-ID: <20190716232021.GA12469@localhost.localdomain>
References: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:47:40PM +0200, Marek Majkowski wrote:
> Morning,
> 
> My poor man's fuzzer found something interesting in SCTP. It seems
> like creating large number of SCTP sockets + some magic dance, upsets
> a memory subsystem related to SCTP. The sequence:
> 
>  - create SCTP socket
>  - call setsockopts (SCTP_EVENTS)
>  - call bind(::1, port)
>  - call sendmsg(long buffer, MSG_CONFIRM, ::1, port)
>  - close SCTP socket
>  - repeat couple thousand times
> 
> Full code:
> https://gist.github.com/majek/bd083dae769804d39134ce01f4f802bb#file-test_sctp-c
> 
> I'm running it on virtme the simplest way:
> $ virtme-run --show-boot-console --rw --pwd --kimg bzImage --memory
> 512M --script-sh ./test_sctp
> 
> Originally I was running it inside net namespace, and just having a
> localhost interface is sufficient to trigger the problem.
> 
> Kernel is 5.2.1 (with KASAN and such, but that shouldn't be a factor).
> In some tests I saw a message that might indicate something funny
> hitting neighbor table:
> 
> neighbour: ndisc_cache: neighbor table overflow!
> 
> I'm not addr-decoding the stack trace, since it seems unrelated to the
> root cause.
> 
Why would you have to decode anything, the decoded stack trace should be
available in your demsg log.  Cant you just attach that here?

Neil

> Cheers,
>     Marek
> 
