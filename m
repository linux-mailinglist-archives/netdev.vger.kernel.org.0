Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B0E366177
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 23:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhDTVVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 17:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233724AbhDTVVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 17:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5654D613FD;
        Tue, 20 Apr 2021 21:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618953637;
        bh=D/HoBu+aWo6sy7+88V9ZJnpot0ZpiBRBCM4AzeXp6I8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pArvFq3Bg0eznwDb5FJ1AJDg4uGehP2ZXKHtXg7aSehY89wKEHnhCX/mVatOV6ryT
         nDf/2gvwWh2BDXh18chg97cOw9UActFB0apxymDDRvGmAtrI+L2MxaIEWgzX7jpw9/
         I6JLRl8kn9AQ6J9IvmQAviE14HNt8N/LqXSJX6Yc8z5xS4zHK7FHiFEETtVwkWVrGB
         ni8KvuVndFviPLslG4RxcSW6KHg6Ja1EsEaatvDzQRx4T0hna0qzuUDlgNWehOQjdA
         mm7h1tAH/Yrc26ZqgFuXReHd0eXJu3ggmg3bvbxA6/Qfv+QEPBu4PF73L18ZgMJocn
         /MnvOs1utGgKw==
Received: by mail-wm1-f43.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so115272wmf.3;
        Tue, 20 Apr 2021 14:20:37 -0700 (PDT)
X-Gm-Message-State: AOAM5312J0QYU+bOC90W0DFl9gFz8T+LnEYF+cEW0ihhc70CIoOM4GHc
        eqcfnT+1H3Xsbpk105GPXqYrmh8K2m6ju7cgPpI=
X-Google-Smtp-Source: ABdhPJwrEit0y72qRaTuoH/3wg/uStL6F0tnFo57QDj1Zmqkrq7O3+IN+SwFnfTQrVplKgk1AFIl7KVtwhj1AIi6XmY=
X-Received: by 2002:a05:600c:4149:: with SMTP id h9mr6135531wmm.43.1618953635407;
 Tue, 20 Apr 2021 14:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210416230724.2519198-1-willy@infradead.org> <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org> <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
 <20210420031029.GI2531743@casper.infradead.org> <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com>
 <8d0fce1c-be7c-1c9b-bf5c-0c531db496ac@synopsys.com>
In-Reply-To: <8d0fce1c-be7c-1c9b-bf5c-0c531db496ac@synopsys.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 20 Apr 2021 23:20:19 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3rzz1gfNLoGC8aZJiAC-tgZYD6P8pQsoEfgCAmQK=FAw@mail.gmail.com>
Message-ID: <CAK8P3a3rzz1gfNLoGC8aZJiAC-tgZYD6P8pQsoEfgCAmQK=FAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
To:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 11:14 PM Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> On 4/20/21 12:07 AM, Arnd Bergmann wrote:

> >
> > which means that half the 32-bit architectures do this. This may
> > cause more problems when arc and/or microblaze want to support
> > 64-bit kernels and compat mode in the future on their latest hardware,
> > as that means duplicating the x86 specific hacks we have for compat.
> >
> > What is alignof(u64) on 64-bit arc?
>
> $ echo 'int a = __alignof__(long long);' | arc64-linux-gnu-gcc -xc -
> -Wall -S -o - | grep -A1 a: | tail -n 1 | cut -f 3
> 8

Ok, good.

> Yeah ARCv2 alignment of 4 for 64-bit data was a bit of surprise finding
> for me as well. When 64-bit load/stores were initially targeted by the
> internal Metaware compiler (llvm based) they decided to keep alignment
> to 4 still (granted hardware allowed this) and then gcc guys decided to
> follow the same ABI. I only found this by accident :-)
>
> Can you point me to some specifics on the compat issue. For better of
> worse, arc64 does''t have a compat 32-bit mode, so everything is
> 64-on-64 or 32-on-32 (ARC32 flavor of ARCv3)

In that case, there should be no problem for you.

The main issue is with system calls and ioctls that contain a misaligned
struct member like

struct s {
       u32 a;
       u64 b;
};

Passing this structure by reference from a 32-bit user space application
to a 64-bit kernel with different alignment constraints means that the
kernel has to convert the structure layout. See
compat_ioctl_preallocate() in fs/ioctl.c for one such example.

       Arnd
