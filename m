Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE330B6A3
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhBBEnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231758AbhBBEnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5092864ED3;
        Tue,  2 Feb 2021 04:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612240945;
        bh=tYCsOmxa9vAOxS56RR54t3aluwDqJ5tlt5Hhdw54r8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fOdk9Y5SuX9ktsk46981mYflp1qJKiAokcln8Q/J3wVTJnutGlKVsy1EnDPRJlUBP
         X3o3M6Iv3wKxVgi5crlhoLWj8OuCLg0XieRBmSYOgyuvG8X/oMKZMM02DE4oyH382Z
         yeGJcKqcmcf9/IkeM+cgkPJoMeEQwDltqkV56JgFocaCdAn1CK63SaOlxtIn1XFPW/
         NFIyibw9DbmGrOci2/mKRjZLg8WmY+GZVE7u69C5o/Ad7lLirYGRkKMQnH1m3tpVXj
         0UHVuh19Yb5t3LIFQ2ZSJukhafQKV3CBfAWbnN06DNwsBMxPk2AFoe4kqBi/ZWHnDw
         idPLMeS3faKsg==
Date:   Mon, 1 Feb 2021 20:42:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
Message-ID: <20210201204224.4872ce23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
        <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com>
        <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 08:14:31 -0800 Xie He wrote:
> On Mon, Feb 1, 2021 at 6:10 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
> > This sounds a bit like you want skb_cow_head() ... ?  
> 
> Calling "skb_cow_head" before we call "skb_clone" would indeed solve
> the problem of writes to our clones affecting clones in other parts of
> the system. But since we are still writing to the skb after
> "skb_clone", it'd still be better to replace "skb_clone" with
> "skb_copy" to avoid interference between our own clones.

Why call skb_cow_head() before skb_clone()? skb_cow_head should be
called before the data in skb head is modified. I'm assuming you're only
modifying "front" of the frame, right? skb_cow_head() should do nicely
in that case.
