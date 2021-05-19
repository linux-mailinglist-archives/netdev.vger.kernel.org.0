Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C88C38997D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhESWzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 18:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhESWzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 18:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7911660FEF;
        Wed, 19 May 2021 22:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621464835;
        bh=s7sa+JprgdBvQ1TTBk/wVSZdNKM1mjSnAFpxw7k51fc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hQJI7tFZKxZdg+PDwsMQ5V3Ejq/9/oxtN4PUGdWfUSZQWXpykbTgFLzD5uS99rxzm
         BWLGObvm1W6T+q+Yoxr0aK3w9Dg0omCvkWD1WK9YTcoNZ2oh8favsVLvUH3PAcjkji
         NUHbwM1RXm68VGDlDpNLChFxhRweqeuK7lJt32+m/eeYBi8j98o6dvpZGrjiGFMMeL
         qeulZGeZoYN89tefc50Fd/LMepg8uXPHIWRU8ShbBA0YDD3wLiMriXS1VFX3f6SyBs
         7Rd/JnP5iSqUvWisl9WHhiN7ana9mahi3yWlC68Bwj8n2WdPQChNnfeA7lz44+D45n
         a1QTC+MMC77Vg==
Date:   Wed, 19 May 2021 15:53:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        bloat <bloat@lists.bufferbloat.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bloat] virtio_net: BQL?
Message-ID: <20210519155354.4438565e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <a11eee78-b2a1-3dbc-4821-b5f4bfaae819@gmail.com>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
        <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
        <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
        <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
        <20210517160036.4093d3f2@hermes.local>
        <a11eee78-b2a1-3dbc-4821-b5f4bfaae819@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 16:31:10 +0200 Eric Dumazet wrote:
> On 5/18/21 1:00 AM, Stephen Hemminger wrote:
> > The Azure network driver (netvsc) also does not have BQL. Several years ago
> > I tried adding it but it benchmarked worse and there is the added complexity
> > of handling the accelerated networking VF path.
> 
> Note that NIC with many TX queues make BQL almost useless, only adding extra
> overhead.
> 
> We should probably make BQL something that can be manually turned on/off.

Ah, I've been pondering this. Are you thinking of a bit in
dev_queue->state? Not perfect, because with a careful driver design 
one can avoid most dev_queue accesses from the completion path.
It's still much better than recompiling the kernel to set BQL=n, tho.
