Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A9284C56
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgJFNNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:13:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD4DC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:12:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FEA9127C6C37;
        Tue,  6 Oct 2020 05:56:11 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:12:58 -0700 (PDT)
Message-Id: <20201006.061258.2191845903557820470.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, soheil@google.com, ncardwell@google.com,
        ycheng@google.com, edumazet@google.com,
        alexandre.ferrieux@orange.com
Subject: Re: [PATCH net] tcp: fix receive window update in tcp_add_backlog()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005134813.2051883-1-eric.dumazet@gmail.com>
References: <20201005134813.2051883-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:56:11 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon,  5 Oct 2020 06:48:13 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> We got reports from GKE customers flows being reset by netfilter
> conntrack unless nf_conntrack_tcp_be_liberal is set to 1.
> 
> Traces seemed to suggest ACK packet being dropped by the
> packet capture, or more likely that ACK were received in the
> wrong order.
> 
>  wscale=7, SYN and SYNACK not shown here.
> 
>  This ACK allows the sender to send 1871*128 bytes from seq 51359321 :
>  New right edge of the window -> 51359321+1871*128=51598809
 ...
>  Now imagine ACK were delivered out of order and tcp_add_backlog() sets window based on wrong packet.
>  New right edge of the window -> 51521241+859*128=51631193
> 
> Normally TCP stack handles OOO packets just fine, but it
> turns out tcp_add_backlog() does not. It can update the window
> field of the aggregated packet even if the ACK sequence
> of the last received packet is too old.
> 
> Many thanks to Alexandre Ferrieux for independently reporting the issue
> and suggesting a fix.
> 
> Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>

Applied and queued up for -stable, thank you.
