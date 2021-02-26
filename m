Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4343C3265D4
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhBZQrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZQr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 11:47:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C48A464F0E;
        Fri, 26 Feb 2021 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614358006;
        bh=nipL5QNlQrS3dNd+bMjxQ5l9Be1ozMV7qdeitZLPUTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qI7/+AfpHaWrKtA9pVaiwiAQEpOlARQuhfbhPC5tsMAbp4KYXIWO7q9VsV3NBs6bY
         dHb5XUpI9btDsdL3IzeSOWOpsHMEyEql9/9NW2REe/OJ+QcFJcA33v2VBkDv0A/ltH
         HNfBAyEEqtInsahV8BYYC05nqQHLxBjDmmgRCrwHQqGUGm7zRUjs3U35HGsN+SAk/C
         LgXJE3u7w/Rgi5mqMONP2bPjyZLyju5sHRaRk9YJJ8/byID05/Z8zxetDYR3aanFey
         g4epV9e2m0sh9uwJZghM2QcsO67uVUtPnrz4G/YSvl3iHJVudObUYdGakKgTWeUDkw
         chvNcLJnDHNSw==
Date:   Fri, 26 Feb 2021 08:46:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
Message-ID: <20210226084644.37496374@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iL8KO5KLqCRdGbGJg5cZj7zVBUjrStFv7A_wqnLusQQ_Q@mail.gmail.com>
References: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJwfXFKnSAQpwaBnfrrE01PXyxLUieBxaB0RzyOajCzLQ@mail.gmail.com>
        <CANn89iL7XCLBxsUnV3c_5AD8eSJ=jXs6o_KJUjmZAGo6_6sqUg@mail.gmail.com>
        <20210226080918.03617088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iL8KO5KLqCRdGbGJg5cZj7zVBUjrStFv7A_wqnLusQQ_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 17:35:11 +0100 Eric Dumazet wrote:
> On Fri, Feb 26, 2021 at 5:09 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 26 Feb 2021 11:41:22 +0100 Eric Dumazet wrote:  
> > > Yes, this packetdrill test confirms TCP INFO stuff seems correct .  
> >
> > Looks like it's TcpExtTCPSpuriousRtxHostQueues - the TFO fails as it
> > might, but at the time the syn is still not kfree_skb()d because of
> > the IRQ coalescing settings, so __tcp_retransmit_skb() returns -EBUSY
> > and we have to wait for a timeout.
> >
> > Credit to Neil Spring @FB for figuring it out.  
> 
> Yes, this makes sense.
> 
> Presumably tcp_send_syn_data() could allocate a regular (non fclone)
> skb, to avoid this.
> 
> But if skb_still_in_host_queue() returns true, __tcp_retransmit_skb()
> should return -EBUSY
> and your tracepoint should not be called ?

Right, looking at the stack trace the call I was tracing comes later
from the RTO timer.

> In anycase, the bytes_acked should not be 742 as mentioned in your
> email, if only the SYN was acked ?

You're right, it's 1. I did a braino in the trace print yesterday.
