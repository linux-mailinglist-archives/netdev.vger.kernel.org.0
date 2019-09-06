Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29FBABCCC
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394894AbfIFPm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:42:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41274 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390317AbfIFPm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:42:57 -0400
Received: by mail-io1-f65.google.com with SMTP id r26so13670302ioh.8
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 08:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5U1Ox+MsOd+Z4Ee8r/1hBKVH7HQBdNn2ZJGK4oLwh3U=;
        b=h6NK55WCqwCrFgwCUq9R2uqoK0L37q8PEzxt61RWP3d9tQM1rgzC7hqMDekH/Zypnz
         2GSAuzwlhBb9Db1bHDNWSgx5FhLIJ/7PZ45MDHijtND4OAjO9cmmVgH44Y/1tYvZq2Je
         7n7PN8MrcIky59Lpsd86pZgkpBktwzl6XkzszswTfm+VBsZIiSomwmVjKTbtm8VKpDk/
         LToNQEVrAODnysxPqBiM+k9JpdvuGPPBEhEJGNedk6TAuXnRiWqOwvb37fiPVesrwSMr
         tspIFPyzoyG7Z+VDHUeHXv2p6aN0uT0i9/kwwtEDm0LPM9BIF8wDj0zSP41zy8rmQScL
         F6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5U1Ox+MsOd+Z4Ee8r/1hBKVH7HQBdNn2ZJGK4oLwh3U=;
        b=KvXBqLRVOajRKOJdEFH3qPu0DntMeCoX8gjOh0UfMs1eLFnQ8SiJWYjT6eQrSDeXr4
         O1pQ/AgS2wOC5Nxrvy3dC1cvlxNGSoh6I9n6nusL7VqYFmbHJiaCm78WWZBalnR5dPYh
         OfYAaw0Rb7vamGrsbLBXx1wiLBKkeVNNWIYe883440WyaEfGOpLz3bX1g4ntX7hwnAfG
         J3oUDphUTl8zGUT7xTQOg0uo1JoJGokfAwUEZBdK1pxlrYuyxfGFJU9ePy6sffTkFbeG
         l7WM2W1MueeSmuTzE4p4ZoSflOfW1FPjWXRTc1vhCwGHvnqR1mNMPFqSOHYAdvvbDztB
         mdmg==
X-Gm-Message-State: APjAAAUfFefX6WH/9z8St0hgT/HtI0yAoq14+lXKhPEITqgqDXnZJ6r0
        gIc70b6Sco/aVn0j8aJMJwqPEFCBbzWx1d7PYqve/w==
X-Google-Smtp-Source: APXvYqz+X+qWivRnoSXnLrjZqh8wNDlPkEU+mXjSfvMtsP9zNCNrLKlc4JHagqHlKny+ANsUOQXCFrDSjtQ2GZVTAyE=
X-Received: by 2002:a02:948c:: with SMTP id x12mr10555582jah.96.1567784576609;
 Fri, 06 Sep 2019 08:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
 <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
 <20190906094744.345d9442@pixies> <CAF=yD-JB6TMQuyaxzLX8=9CZZF+Zk5EmniSkx_F81bVc87XqJw@mail.gmail.com>
 <20190906183707.3eaacd79@pixies>
In-Reply-To: <20190906183707.3eaacd79@pixies>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 Sep 2019 08:42:45 -0700
Message-ID: <CAKgT0Ufd40gmaW7eLu3sRHd=4CeY9WNmgRBUzNt5_+0tEKEMvA@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 8:37 AM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
>
> On Fri, 6 Sep 2019 10:49:55 -0400
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > But I wonder whether it is a given that head_skb has headlen.
>
> This is what I observed for GRO packets that do have headlen frag_list
> members: the 'head_skb' itself had a headlen too, and its head was
> built using the original gso_size (similar to the frag_list members).
>
> Maybe Eric can comment better.
>
> > Btw, it seems slightly odd to me tot test head_frag before testing
> > headlen in the v2 patch.
>
> Requested by Alexander. I'm fine either way.

Yeah, my thought on that was "do we care about the length if the data
is stored in a head_frag?". I suppose you could flip the logic and
make it "do we care about it being a head_frag if there is no data
there?". The reason I had suggested the head_frag test first was
because it was a single test bit whereas the length requires reading
two fields and doing a comparison.

For either ordering it is fine by me. So if we need to feel free to
swap those two tests for a v3.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
