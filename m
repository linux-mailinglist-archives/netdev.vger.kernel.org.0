Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25E64535C1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbhKPPai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238169AbhKPPad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:30:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A5061BFB;
        Tue, 16 Nov 2021 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637076456;
        bh=hGjitaOre+GF8CGMATWoLP20/qBbY5JDKdIz/lIf95s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tuwLk3y2dHWx+HMoj9zEV6XBOm0Njg5haJ4cy/D7MIDjq0w/gNfXREIHPHySpZynj
         cWjq3ju3Eb3aawgJFfby9yCHHFrwfGFMBI6kX49T74+QzgY8m7JeUFtQs4BeD+dsH1
         J+ts5yfOdMZwOeyFD50kVxjPJtD4SzeQ6cangayIogqGwflCzVI1yI3YMyypDk2DVk
         n5Mlh290xpvVgfd33o0X7M7AG1vg/WFu+vbFYLGpmvVBKObpIRnG0daQASxZZ2nr45
         CCQKCx0NVnov67c8821yptsoCLOdyHI14rh8whvlrG1AsSg/Wry6oTZ0aLl/+jG1Xq
         adnlqT7VEaUnw==
Date:   Tue, 16 Nov 2021 07:27:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
Message-ID: <20211116072735.68c104ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
        <20211115190249.3936899-18-eric.dumazet@gmail.com>
        <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
        <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 07:22:02 -0800 Eric Dumazet wrote:
> Here is the perf top profile on cpu used by user thread doing the
> recvmsg(), at 96 Gbit/s
> 
> We no longer see skb freeing related costs, but we still see costs of
> having to process the backlog.
> 
>    81.06%  [kernel]       [k] copy_user_enhanced_fast_string
>      2.50%  [kernel]       [k] __skb_datagram_iter
>      2.25%  [kernel]       [k] _copy_to_iter
>      1.45%  [kernel]       [k] tcp_recvmsg_locked
>      1.39%  [kernel]       [k] tcp_rcv_established

Huh, somehow I assumed your 4k MTU numbers were with zero-copy :o

Out of curiosity - what's the softirq load with 4k? Do you have an 
idea what the load is on the CPU consuming the data vs the softirq
processing with 1500B ?
