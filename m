Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAAB28E8F0
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 00:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbgJNWyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 18:54:24 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:47737 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730189AbgJNWyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 18:54:24 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 23c1002f;
        Wed, 14 Oct 2020 22:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=XHEkKwOSP573OP70L/G1jZ0zw04=; b=PQ2llu
        cr3zGJ+52nI/pqkMngSSZZ9wZNWDMwBl6uKh+xy690cAQFpDU38IrclZZMvbhEEg
        TlC3A7FeHR3m2FywHbaFSemG19VZW66w+bo/wnTN0D58Eps2+KSlKPNf2UEPPXjO
        9cOi4gXE1aZeGmSVMySaKCU2DlRGkPHcnwpmLfota4omz+72DlgVJwxGcBVAQKSd
        nWZQb1Qe4Wz7lPSgRRulRxJ09QcEvoyw4SKiRi1f3F5xaTbTPiKKdeQ6eFY7l15G
        2FjDC53qpvnU1robvQLw+aNvysJk0x4ECz/wLC1MGxBkD4v+TW3NI8mGhyLw9vtR
        T+oq8TX5x64CJrUg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ee2c4fb9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 14 Oct 2020 22:20:44 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id k21so1675067ioa.9;
        Wed, 14 Oct 2020 15:54:19 -0700 (PDT)
X-Gm-Message-State: AOAM530D2a2hbEvi3efQYP2heNl1xGxuRZcWqRSYOsXiFoYYysiMy78s
        +NVAbC4w9ww4Y4wtbIvvwzlK3keHOlCe1AFl2cI=
X-Google-Smtp-Source: ABdhPJx7nd6uZrd5MITcpSjRtd7mzZC+L8JBlUV/DELdqVqYoh9IsAgj+V2g9lJeL+rJRWYAJRljcfDWts9sMse3T8Q=
X-Received: by 2002:a5e:d606:: with SMTP id w6mr1206594iom.67.1602716059144;
 Wed, 14 Oct 2020 15:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200724012512.GK2786714@ZenIV.linux.org.uk> <20200724012546.302155-1-viro@ZenIV.linux.org.uk>
 <20200724012546.302155-20-viro@ZenIV.linux.org.uk> <20201014222650.GA390346@zx2c4.com>
 <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com> <CAHk-=wj_rmS+kQvC9DccZy=UiUFJVFG9=fQajtfSCSP1h0Rofw@mail.gmail.com>
In-Reply-To: <CAHk-=wj_rmS+kQvC9DccZy=UiUFJVFG9=fQajtfSCSP1h0Rofw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 15 Oct 2020 00:54:08 +0200
X-Gmail-Original-Message-ID: <CAHmME9r-tC_RvYFiUKKS-5Z6z9Egd5NCWupv9FVpYt+khKR+7Q@mail.gmail.com>
Message-ID: <CAHmME9r-tC_RvYFiUKKS-5Z6z9Egd5NCWupv9FVpYt+khKR+7Q@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] ppc: propagate the calling conventions change
 down to csum_partial_copy_generic()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 12:53 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Oct 14, 2020 at 3:51 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I think it's this instruction:
> >
> >         addi    r1,r1,16
> >
> > that should be removed from the function exit, because Al removed the
> >
> > -       stwu    r1,-16(r1)
> >
> > on function entry.
> >
> > So I think you end up with a corrupt stack pointer and basically
> > random behavior.
> >
> > Mind trying that? (This is obviously all in
> > arch/powerpc/lib/checksum_32.S, the csum_partial_copy_generic()
> > function).
>
> Patch attached to make it easier to test.
>
> NOTE! This is ENTIRELY untested. My ppc asm is so rusty that I might
> be barking entirely up the wrong tree, and I just made things much
> worse.

Indeed - exactly the same thing that's in my tree. Writing a commit
message for it now.

Jason
