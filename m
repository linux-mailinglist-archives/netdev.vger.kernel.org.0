Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF812472EE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391662AbgHQStD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403858AbgHQStA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:49:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F9C061389;
        Mon, 17 Aug 2020 11:49:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8468B14CF4D59;
        Mon, 17 Aug 2020 11:32:13 -0700 (PDT)
Date:   Mon, 17 Aug 2020 11:48:58 -0700 (PDT)
Message-Id: <20200817.114858.1800576333370707414.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: xdp: pull ethernet header off packet after
 computing skb->protocol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9ojV+6xgvmEPYV+_oGjzykDG+ZpOe5kct+DG87A+YyLvQ@mail.gmail.com>
References: <20200816.152937.1107786737475087036.davem@davemloft.net>
        <20200817080102.61e109cf@carbon>
        <CAHmME9ojV+6xgvmEPYV+_oGjzykDG+ZpOe5kct+DG87A+YyLvQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 11:32:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 17 Aug 2020 09:48:10 +0200

> On 8/17/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> On Sun, 16 Aug 2020 15:29:37 -0700 (PDT)
>> David Miller <davem@davemloft.net> wrote:
>>
>>> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>>> Date: Sat, 15 Aug 2020 09:29:30 +0200
>>>
>>> > When an XDP program changes the ethernet header protocol field,
>>> > eth_type_trans is used to recalculate skb->protocol. In order for
>>> > eth_type_trans to work correctly, the ethernet header must actually be
>>> > part of the skb data segment, so the code first pushes that onto the
>>> > head of the skb. However, it subsequently forgets to pull it back off,
>>> > making the behavior of the passed-on packet inconsistent between the
>>> > protocol modifying case and the static protocol case. This patch fixes
>>> > the issue by simply pulling the ethernet header back off of the skb
>>> > head.
>>> >
>>> > Fixes: 297249569932 ("net: fix generic XDP to handle if eth header was
>>> > mangled")
>>> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>> > Cc: David S. Miller <davem@davemloft.net>
>>> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>>>
>>> Applied and queued up for -stable, thanks.
>>>
>>> Jesper, I wonder how your original patch was tested because it pushes a
>>> packet
>>> with skb->data pointing at the ethernet header into the stack.  That
>>> should be
>>> popped at this point as per this fix here.
>>
>> I think this patch is wrong, because eth_type_trans() also does a
>> skb_pull_inline(skb, ETH_HLEN).
> 
> Huh, wow. That's one unusual and confusing function. But indeed it
> seems like I'm the one who needs to reevaluate testing methodology
> here. I'm very sorry for the noise and hassle.

I've reverted this change from my tree.
