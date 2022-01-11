Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB448A6F1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 05:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiAKE4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 23:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiAKE4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 23:56:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E0EC06173F;
        Mon, 10 Jan 2022 20:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB9BFB818AD;
        Tue, 11 Jan 2022 04:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C17C36AE9;
        Tue, 11 Jan 2022 04:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641876964;
        bh=ZtbHei9hz8oON8dszReT8Cgs/y24l8HsmyySBpqXfMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PdGI9hCOqKuKfWSwo/fBTloxdenVxgZLapHMXZFSxpC9FJnYmh7p4eeaqRd9vVOsH
         WyBzKE9GmzOrentqoOvVq4haFGC5PMCvuqSg2Kktjw1mfWLAt+7+zrqD26oR0jlfS/
         UpBcjvA61BjUxmKhhBJfLvdHrYt/6PqHvZB6XS+wCxtejbU7cHJKZKogbRu8N/abYV
         JizzQqAs0XCu8fl2rj7q2556glzwStcTADwvAcvyVfGus5wY+wmkK/Ib/buOEQSCeN
         NAphdHkw276sAsfnnPNfhxbQNgCgdtDflHpinyt2t28UyBE5Rr91R9WZqT5g63X0Pp
         fj4P5yDI55OWA==
Date:   Mon, 10 Jan 2022 20:56:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Networking for 5.17
Message-ID: <20220110205603.6bc9b680@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
References: <20220110025203.2545903-1-kuba@kernel.org>
        <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 19:31:30 -0800 Linus Torvalds wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/5.17-net-next  
> 
> Merged. But I now note that this actually triggers an error when
> building with clang:
> 
>   net/netfilter/nf_tables_api.c:8278:4: error: variable 'data_size' is
> uninitialized when used here [-Werror,-Wuninitialized]
>                           data_size += sizeof(*prule) + rule->dlen;
>                           ^~~~~~~~~
> 
> and I think clang is entirely right.
> 
> Sadly, I didn't actually notice that before having done the merge, so
> I'll have to do the fixup as a separate commit.

Damn it :/ Sorry.
 
> I really wish we had more automation doing clang builds. Yes, some
> parts of the kernel are still broken with clang, but a lot isn't, and
> this isn't the first time my clang build setup has found issues.

We have clang W=1 running on patchwork but the PR this came thru didn't
register right. I'll build test with clang going forward.

> I also notice that NET_VENDOR_VERTEXCOM defaults to 'n'. That's fine
> by me, but it seems unusual. Normally the 'enable vendor XYZ' tend to
> default to 'y'. But for unusual (and new) vendors, maybe that 'n' is
> the right thing to avoid unnecessary questions.
> 
> And maybe that NET_VENDOR_xyz thing has happened many times before,
> and I just haven't happened to notice...

There is a patch posted to flip it back to 'y' already, I didn't think
it was worth waiting for. That said I don't actually know why vendors
default to y. The only explanation I can come up with it's that it was
done so that people running olddefconfig right after the per-vendor
split was introduced wouldn't lose all drivers. We'll fix vertexcom
for consistency but may flip all the vendors' default to 'n' for 
the next merge window.
