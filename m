Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF01C8D9F
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgEGOHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:07:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49883 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727903AbgEGOHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588860467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1AoI+9FyMu82WK4bZhrAK5V8JQ6RWrNZsFQbYJw2lb8=;
        b=FFapW094jQ9WBDEl0IojAueYo/At3cqKBXNx+ggioYK0N1wECr+W7CvagYXDfYV/RxBq2a
        1t5FV7ro3HNaLGv0zzo1dNu91HhOyjwC1SdU0w9z+r+x8I0Nj1g6pVZyx8rU5W3CZFW0oJ
        fcKk0XLGdIFo+uPrwh39S8wIBICDAEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-vKGhe_kQMd-SMc6q1mPVXw-1; Thu, 07 May 2020 10:07:39 -0400
X-MC-Unique: vKGhe_kQMd-SMc6q1mPVXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 422AA460;
        Thu,  7 May 2020 14:07:37 +0000 (UTC)
Received: from treble (ovpn-115-96.rdu2.redhat.com [10.10.115.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 059E670545;
        Thu,  7 May 2020 14:07:35 +0000 (UTC)
Date:   Thu, 7 May 2020 09:07:33 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200507140733.v4xlzjogtnpgu5lc@treble>
References: <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
 <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
 <20200505202823.zkmq6t55fxspqazk@treble>
 <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
 <20200506155343.7x3slq3uasponb6w@treble>
 <CAADnVQJZ1rj1DB-Y=85itvfcHxnXVKjhJXpzqs6zZ6ZLpexhCQ@mail.gmail.com>
 <20200506211945.4qhrxqplzmt4ul66@treble>
 <20200507000357.grprluieqa324v5c@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507000357.grprluieqa324v5c@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 05:03:57PM -0700, Alexei Starovoitov wrote:
> > > > > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > > > > index d7ee4c6bad48..05104c3cc033 100644
> > > > > --- a/include/linux/compiler-gcc.h
> > > > > +++ b/include/linux/compiler-gcc.h
> > > > > @@ -171,4 +171,4 @@
> > > > >  #define __diag_GCC_8(s)
> > > > >  #endif
> > > > >
> > > > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > > > > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > > > > --
> > > > > 2.23.0
> > > > >
> > > > > I've tested it with gcc 8,9,10 and clang 11 with FP=y and with ORC=y.
> > > > > All works.
> > > > > I think it's safer to go with frame pointers even for ORC=y considering
> > > > > all the pain this issue had caused. Even if objtool gets confused again
> > > > > in the future __bpf_prog_run() will have frame pointers and kernel stack
> > > > > unwinding can fall back from ORC to FP for that frame.
> > > > > wdyt?
> > > >
> > > > It seems dangerous to me.  The GCC manual recommends against it.
> > > 
> > > The manual can says that it's broken. That won't stop the world from using it.
> > > Just google projects that are using it. For example: qt, lz4, unreal engine, etc
> > > Telling compiler to disable gcse via flag is a guaranteed way to avoid
> > > that optimization that breaks objtool whereas messing with C code is nothing
> > > but guess work. gcc can still do gcse.
> > 
> > But the manual's right, it is broken.  How do you know other important
> > flags won't also be stripped?
> 
> What flags are you worried about?
> I've checked that important things like -mno-red-zone, -fsanitize are preserved.

It's not any specific flags I'm worried about, it's all of them.  There
are a lot of possibilities, with all the different configs, and arches.
Flags are usually added for a good reason, so one randomly missing flag
could have unforeseen results.

And I don't have any visibility into how GCC decides which flags to
drop, and when.  But the docs aren't comforting.

Even if things seem to work now, that could (silently) change at any
point in time.  This time objtool warned about the missing frame
pointer, but that's not necessarily going to happen for other flags.

If we go this route, I would much rather do -fno-gcse on a file-wide
basis.

-- 
Josh

