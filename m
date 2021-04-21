Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79827366504
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhDUFvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:51:10 -0400
Received: from verein.lst.de ([213.95.11.211]:52980 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbhDUFvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 01:51:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7324868BFE; Wed, 21 Apr 2021 07:50:28 +0200 (CEST)
Date:   Wed, 21 Apr 2021 07:50:28 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Matthew Wilcox <willy@infradead.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210421055028.GA28910@lst.de>
References: <20210416230724.2519198-1-willy@infradead.org> <20210416230724.2519198-2-willy@infradead.org> <20210417024522.GP2531743@casper.infradead.org> <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com> <20210420031029.GI2531743@casper.infradead.org> <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com> <8d0fce1c-be7c-1c9b-bf5c-0c531db496ac@synopsys.com> <CAK8P3a3rzz1gfNLoGC8aZJiAC-tgZYD6P8pQsoEfgCAmQK=FAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3rzz1gfNLoGC8aZJiAC-tgZYD6P8pQsoEfgCAmQK=FAw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 11:20:19PM +0200, Arnd Bergmann wrote:
> In that case, there should be no problem for you.
> 
> The main issue is with system calls and ioctls that contain a misaligned
> struct member like
> 
> struct s {
>        u32 a;
>        u64 b;
> };
> 
> Passing this structure by reference from a 32-bit user space application
> to a 64-bit kernel with different alignment constraints means that the
> kernel has to convert the structure layout. See
> compat_ioctl_preallocate() in fs/ioctl.c for one such example.

We've also had this problem with some on-disk structures in the past,
but hopefully people desining those have learnt the lesson by now.
