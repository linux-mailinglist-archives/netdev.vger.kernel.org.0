Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364902193A9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgGHWk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgGHWkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:40:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AC6C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 15:40:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 852921277ED6B;
        Wed,  8 Jul 2020 15:40:50 -0700 (PDT)
Date:   Wed, 08 Jul 2020 15:40:49 -0700 (PDT)
Message-Id: <20200708.154049.1832973173513393256.davem@davemloft.net>
To:     hamish.martin@alliedtelesis.co.nz
Cc:     kuba@kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        tuong.t.lien@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, chris.packham@alliedtelesis.co.nz,
        john.thompson@alliedtelesis.co.nz
Subject: Re: [PATCH v2] tipc: fix retransmission on unicast links
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708210644.27161-1-hamish.martin@alliedtelesis.co.nz>
References: <20200708210644.27161-1-hamish.martin@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 15:40:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Date: Thu,  9 Jul 2020 09:06:44 +1200

> A scenario has been observed where a 'bc_init' message for a link is not
> retransmitted if it fails to be received by the peer. This leads to the
> peer never establishing the link fully and it discarding all other data
> received on the link. In this scenario the message is lost in transit to
> the peer.
> 
> The issue is traced to the 'nxt_retr' field of the skb not being
> initialised for links that aren't a bc_sndlink. This leads to the
> comparison in tipc_link_advance_transmq() that gates whether to attempt
> retransmission of a message performing in an undesirable way.
> Depending on the relative value of 'jiffies', this comparison:
>     time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr)
> may return true or false given that 'nxt_retr' remains at the
> uninitialised value of 0 for non bc_sndlinks.
> 
> This is most noticeable shortly after boot when jiffies is initialised
> to a high value (to flush out rollover bugs) and we compare a jiffies of,
> say, 4294940189 to zero. In that case time_before returns 'true' leading
> to the skb not being retransmitted.
> 
> The fix is to ensure that all skbs have a valid 'nxt_retr' time set for
> them and this is achieved by refactoring the setting of this value into
> a central function.
> With this fix, transmission losses of 'bc_init' messages do not stall
> the link establishment forever because the 'bc_init' message is
> retransmitted and the link eventually establishes correctly.
> 
> Fixes: 382f598fb66b ("tipc: reduce duplicate packets for unicast traffic")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

Applied and queued up for -stable, thank you.
