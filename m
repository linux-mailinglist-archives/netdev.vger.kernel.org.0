Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9C483682
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiACSAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:00:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56358 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiACSAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:00:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3DF8B81068
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 18:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4B5C36AEB;
        Mon,  3 Jan 2022 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641232813;
        bh=KEbQMtLpeTWu259lzC85m6it1ah+JbLqs+nc/XmlqHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8JDkJzHpYKjpHrDcTIznAX/I6q/Hx6Nq2LAYVvh0DoDrNgbQYkGVGMn1rcA87qvA
         BJymE50xZIcWx1ZbnBC5nWH9SXo0NFBry9/hAUio/q9z+Zsnx2vtrqXr8Dku+H6kYB
         v88ua4mNQMxomyyjBIvHCZI5I67CUmcNjjGjan/Kcj6Q2i4gkUZ3dOKaf4pTBWnptQ
         qxNFEIUpUx4pjZNCyViE1J4Ilp9H0fsqA2zLaA8Dk4UayFKUQXYICDNZjIdsV7+f8S
         tyG3fo174V37AvU4aP1lsILxbwnA/BJd4HIJSlA6IR2Fv1zbVXeFDxNb/3EXCTpPEc
         PlOvAyxsd43MQ==
Date:   Mon, 3 Jan 2022 10:00:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     vitalif@yourcmc.ru
Cc:     edumazet@google.com, netdev@vger.kernel.org
Subject: Re: How to test TCP zero-copy receive with real NICs?
Message-ID: <20220103100012.7507e0e1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <ec7ee6bfa737e3f87774555feac13923@yourcmc.ru>
References: <ec7ee6bfa737e3f87774555feac13923@yourcmc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 01 Jan 2022 20:49:49 +0000 vitalif@yourcmc.ru wrote:
> Hi!
> 
> Happy new year netdev mailing list :-)
> 
> I have questions about your Linux TCP zero-copy support which is
> described in these articles https://lwn.net/Articles/752046/ and
> presentation:
> https://legacy.netdevconf.info/0x14/pub/slides/62/Implementing%20TCP%20RX%20zero%20copy.pdf
> 
> First of all, how to test it with real NICs?
> 
> The presentation says it requires "collaboration" from the NIC and it
> also mentions some NICs you used at Google. Which are these NICs? Was
> the standard driver used or did it require custom patches to the
> drivers?..
> 
> I tried to test zerocopy with Mellanox ConnectX-4 and also with Intel
> X520-DA2 (82599) and had no luck. I tried to find something like
> "header-data split" or "packet split" in the drivers code, and as far
> as I understood the support for header-data split in ixgbe was there
> until 2012, but was removed in commit
> f800326dca7bc158f4c886aa92f222de37993c80 ("ixgbe: Replace standard
> receive path with a page based receive"). For Mellanox (again, as I
> understand) it's not present at all...

Try a Broadcom NIC that uses the bnxt driver. It seems to work pretty
well, just need to enable GRO-HW or MTU > 4k and you'll get header-data
split automatically. Doesn't even have to be a very recent NIC, 
I believe it's supported for a number of generations now.

> The second question is more about my attempts to test it on loopback
> - test tcp_mmap program (tools/testing/selftests/net/tcp_mmap.c from
> the kernel source) works fine on loopback, but my examples with
> TCP_NODELAY enabled are very brittle and only manage to sometimes use
> zero-copy successfully (i.e. get something non-zero from getsockopt
> TCP_ZEROCOPY_RECEIVE) with tcp_rmem=16384 16384 16384 AND 4 kb packet
> size. And even in that case it only performs zerocopy on 30-50% of
> packets. But that's at least something... And if I try to send larger
> portions of data it breaks... And if I try to change buffers to
> default it also breaks... And if I send 128 byte packets before 4096+
> byte packets it also breaks... I tried to dump traffic and everything
> looks good there, all packets are 40 bytes + payload(4096 or more), I
> set MSS manually to 4096 and so on. Even tcp window sizes look good -
> if I shift them by wscale they are always page-aligned.
> 
> tcp_mmap, at the same time, works fine and I don't see any serious
> difference between it and my test examples except TCP_NODELAY.
> 
> So the second question is - how to make it stable with TCP_NODELAY,
> even on loopback?)
> 

