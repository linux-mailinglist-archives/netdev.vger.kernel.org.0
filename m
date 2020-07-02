Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7410A211741
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgGBAiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGBAiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:38:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93C1C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:38:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58E0114E50EA7;
        Wed,  1 Jul 2020 17:38:01 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:38:00 -0700 (PDT)
Message-Id: <20200701.173800.2165846049133064726.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ncardwell@google.com, ycheng@google.com, fw@strlen.de,
        mathieu.desnoyers@efficios.com
Subject: Re: [PATCH net] tcp: md5: do not send silly options in SYNCOOKIES
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701194123.3720996-1-edumazet@google.com>
References: <20200701194123.3720996-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:38:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  1 Jul 2020 12:41:23 -0700

> Whenever cookie_init_timestamp() has been used to encode
> ECN,SACK,WSCALE options, we can not remove the TS option in the SYNACK.
> 
> Otherwise, tcp_synack_options() will still advertize options like WSCALE
> that we can not deduce later when receiving the packet from the client
> to complete 3WHS.
> 
> Note that modern linux TCP stacks wont use MD5+TS+SACK in a SYN packet,
> but we can not know for sure that all TCP stacks have the same logic.
> 
> Before the fix a tcpdump would exhibit this wrong exchange :
> 
> 10:12:15.464591 IP C > S: Flags [S], seq 4202415601, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 456965269 ecr 0,nop,wscale 8], length 0
> 10:12:15.464602 IP S > C: Flags [S.], seq 253516766, ack 4202415602, win 65535, options [nop,nop,md5 valid,mss 1400,nop,nop,sackOK,nop,wscale 8], length 0
> 10:12:15.464611 IP C > S: Flags [.], ack 1, win 256, options [nop,nop,md5 valid], length 0
> 10:12:15.464678 IP C > S: Flags [P.], seq 1:13, ack 1, win 256, options [nop,nop,md5 valid], length 12
> 10:12:15.464685 IP S > C: Flags [.], ack 13, win 65535, options [nop,nop,md5 valid], length 0
> 
> After this patch the exchange looks saner :
> 
> 11:59:59.882990 IP C > S: Flags [S], seq 517075944, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 1751508483 ecr 0,nop,wscale 8], length 0
> 11:59:59.883002 IP S > C: Flags [S.], seq 1902939253, ack 517075945, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 1751508479 ecr 1751508483,nop,wscale 8], length 0
> 11:59:59.883012 IP C > S: Flags [.], ack 1, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508479], length 0
> 11:59:59.883114 IP C > S: Flags [P.], seq 1:13, ack 1, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508479], length 12
> 11:59:59.883122 IP S > C: Flags [.], ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508483], length 0
> 11:59:59.883152 IP S > C: Flags [P.], seq 1:13, ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508484 ecr 1751508483], length 12
> 11:59:59.883170 IP C > S: Flags [.], ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508484 ecr 1751508484], length 0
> 
> Of course, no SACK block will ever be added later, but nothing should break.
> Technically, we could remove the 4 nops included in MD5+TS options,
> but again some stacks could break seeing not conventional alignment.
> 
> Fixes: 4957faade11b ("TCPCT part 1g: Responder Cookie => Initiator")

I really love the archaeology of such artifacts :-)

> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks.
