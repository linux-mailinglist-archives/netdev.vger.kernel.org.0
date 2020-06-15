Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FF71F9DB2
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbgFOQlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgFOQlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:41:50 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8ADC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:41:50 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id er17so8043952qvb.8
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GiKBA0Yhba1TI03GaAPY7BkOWgJVPjHL3sAxzmKYpk=;
        b=Rwy0WzcH61XLCenE33ke+EInFA6layi0G4vtRVPwec4HQx1IZl1dDsWvrv2iNirxZo
         u+MxABZ9Bj7lD2MKmY+7alFcTYbxsi86spc0fR3oyPZarOiBBZCQFl6RQzFACAvc2eee
         V+8V3tJpMRNXoTf8MyrH63hvhKjj2B6kMBg81CywSqQXbMBamD65uKvFiEUUJ8vtzHfx
         sO+cIIeceS8+ZekeFylI+hmkiWkqqQWf+h2XPdxvLa7e9fO3/BO+b3N3sUBtEGfOQ6DH
         wU9YeT78do697MmBI85BoMwni23GJIRKRm0hJvj0nx0ADIVklsfTtKbF9b/ZHPVmqlc8
         GJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GiKBA0Yhba1TI03GaAPY7BkOWgJVPjHL3sAxzmKYpk=;
        b=KELtpElQYMemptd0pZdoASDOwjvvqM/s19ZIcmU4PNGe/tPNP5WWQuYhT+BgXH0TdD
         epdQHCyTqsKKY+YCk997g/7Prl2qGbzjKcuKlGp4dV1peSWGRw/tZBk+1YAQ074/NTzd
         iO/zWZKF5H42gXy+QW6Yk3+yCQOTX5/sXX1Z/wXCDS+Lyk4zrvmJ8h1QpLACxfk0zSJf
         bVdSe3NFGBiBfiYfj/UYFnODKHKWR85eZ4sybUM5SBK+t4JRItZavRmKMfaunaDZMI6f
         qrYKfUIGV56ovJgW4iWyeetHXUTnyqIsf2839RL5it0LWYBGqUIUJk0IGvYcXwebvwIS
         UIHg==
X-Gm-Message-State: AOAM533aeFptGdkFp7gMZmEpn3UNaOPpKV5BVpru87LLyjHuy1p1pLNX
        XL9O1/wMLdBxjLsPXWv/9azJpxahON+3e3I/3U/sIGQT
X-Google-Smtp-Source: ABdhPJyTf9MxpzxwGxlkjLiriktRyuTpJGqoFyBlJLkFmk78sb8FdtJykzGOumVYFxDcXTsdVoYqqSe3MmZ+CVgR2tU=
X-Received: by 2002:ad4:5512:: with SMTP id az18mr25620752qvb.51.1592239309534;
 Mon, 15 Jun 2020 09:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200608182748.6998-1-sdf@google.com> <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
 <CAKH8qBuJpks_ny-8MDzzZ5axobn=35P3krVbyz2mtBBtR8Uv+A@mail.gmail.com> <20200613035038.qmoxtf5mn3g3aiqe@ast-mbp>
In-Reply-To: <20200613035038.qmoxtf5mn3g3aiqe@ast-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 15 Jun 2020 09:41:38 -0700
Message-ID: <CAKH8qBvUv_OwjFA70JQfL-rET662okH87QYyeivbybCPwCEJEQ@mail.gmail.com>
Subject: Re: [PATCH bpf v3 1/2] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 8:50 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
[ .. ]
> > > It's probably ok, but makes me uneasy about verifier consequences.
> > > ctx->optval is PTR_TO_PACKET and it's a valid pointer from verifier pov.
> > > Do we have cases already where PTR_TO_PACKET == PTR_TO_PACKET_END ?
> > > I don't think we have such tests. I guess bpf prog won't be able to read
> > > anything and nothing will crash, but having PTR_TO_PACKET that is
> > > actually NULL would be an odd special case to keep in mind for everyone
> > > who will work on the verifier from now on.
> > >
> > > Also consider bpf prog that simply reads something small like 4 bytes.
> > > IP_FREEBIND sockopt (like your selftest in the patch 2) will have
> > > those 4 bytes, so it's natural for the prog to assume that it can read it.
> > > It will have
> > > p = ctx->optval;
> > > if (p + 4 > ctx->optval_end)
> > >  /* goto out and don't bother logging, since that never happens */
> > > *(u32*)p;
> > >
> > > but 'clever' user space would pass long optlen and prog suddenly
> > > 'not seeing' the sockopt. It didn't crash, but debugging would be
> > > surprising.
> > >
> > > I feel it's better to copy the first 4k and let the program see it.
> > Agreed with the IP_FREEBIND example wrt observability, however it's
> > not clear what to do with the cropped buffer if the bpf program
> > modifies it.
> >
> > Consider that huge iptables setsockopts where the usespace passes
> > PAGE_SIZE*10 optlen with real data and bpf prog sees only part of it.
> > Now, if the bpf program modifies the buffer (say, flips some byte), we
> > are back to square one. We either have to silently discard that buffer
> > or reallocate/merge. My reasoning with data == NULL, is that at least
> > there is a clear signal that the program can't access the data (and
> > can look at optlen to see if the original buffer is indeed non-zero
> > and maybe deny such requests?).
> > At this point I'm really starting to think that maybe we should just
> > vmalloc everything that is >PAGE_SIZE and add a sysclt to limit an
> > upper bound :-/
> > I'll try to think about this a bit more over the weekend.
>
> Yeah. Tough choices.
> We can also detect in the verifier whether program accessed ctx->optval
> and skip alloc/copy if program didn't touch it, but I suspect in most
> case the program would want to read it.
> I think vmallocing what optlen said is DoS-able. It's better to
> stick with single page.
> Let's keep brainstorming.
Btw, can we use sleepable bpf for that? As in, do whatever I suggested
in these patches (don't expose optval>PAGE_SIZE via context), but add
a new helper where you can say 'copy x bytes from y offset of the
original optval' (the helper will do sleepable copy_form_user).
That way we have a clean signal to the BPF that the value is too big
(optval==optval_end==NULL) and the user can fallback to the helper to
inspect the value. We can also provide another helper to export new
value for this case.
WDYT?
