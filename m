Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E673533DFBA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhCPVCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhCPVCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E269464F8C;
        Tue, 16 Mar 2021 21:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615928524;
        bh=JabW6V+JpL9pQaNpNRb0IG759fPR+7+Gv+pQSojDt34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOk9a5TPgHzTAN5ehOWPg8HuwPQrH0q3mHqJ37unDnf1PG40sZpnvwxU0T71BAchP
         hFOCtYBamTnnDN8DKucrMp3+1m+zX0yKiENOlLQ5rhTpz0ZAs5WQUmnNnDoWeV8dYO
         vaz0OjRFROztRXqg5zRMktFltLTYjih7InXGuqaloONOH1JqpaZHzO3J+Y0fEXWxVb
         dHDbX9DC8B96C+NvnXBkeKm9VMCExKXNHI3G4dFi1HIPBAGNwoncDrLuF/RkBzZtfS
         uPoSY6JW+5yhuSk3iT7ZaWnHEBiVPWKbzOgDyBPYKu5pKU/bIrVHdz++B0lMxRqB0G
         /BhHwJErBjG5A==
Date:   Tue, 16 Mar 2021 14:02:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <20210316140203.0d5ddf33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOFY-A2q4otqu=pD60tUiD0GTDZnpcm+zajFp6SRDh4VixbV2Q@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
        <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com>
        <CALvZod7hgtdrN_KXD_5JdB2vzJzTc8tVz_5YFN53-xZjpHLLRw@mail.gmail.com>
        <CAOFY-A0v2BEwRinhPXspjL_3dvyw2kDSyzQgUiJxc+P-3OLP8g@mail.gmail.com>
        <CAOFY-A2q4otqu=pD60tUiD0GTDZnpcm+zajFp6SRDh4VixbV2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 23:28:08 -0700 Arjun Roy wrote:
> On Mon, Mar 15, 2021 at 11:22 PM Arjun Roy <arjunroy@google.com> wrote:
> >
> > On Mon, Mar 15, 2021 at 9:29 PM Shakeel Butt <shakeelb@google.com> wrote:  
> > >
> > > On Mon, Mar 15, 2021 at 9:20 PM Arjun Roy <arjunroy@google.com> wrote:  
>  [...]  
> > > [...]  
>  [...]  
>  [...]  
> > >
> > > It is due to "mm: page-writeback: simplify memcg handling in
> > > test_clear_page_writeback()" patch in the mm tree. You would need to
> > > reintroduce the lock_page_memcg() which returns the memcg and make
> > > __unlock_page_memcg() non-static.  
> >
> > To clarify, Shakeel - the tag "tag: v5.12-rc2-mmots-2021-03-11-21-49"
> > fails to build on a clean checkout, without this patch, due to a
> > compilation failure in mm/shmem.c, for reference:
> > https://pastebin.com/raw/12eSGdGD
> > (and that's why I'm basing this patch off of net-next in this email).
> >
> > -Arjun  
> 
> Another seeming anomaly - the patch sent out passes
> scripts/checkpatch.pl but netdev/checkpatch finds plenty of actionable
> fixes here: https://patchwork.kernel.org/project/netdevbpf/patch/20210316041645.144249-1-arjunroy.kdev@gmail.com/
> 
> Is netdev using some other automated checker instead of scripts/checkpatch.pl?

--strict --max-line-length=80
