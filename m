Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4335B1938BA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgCZGij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37068 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbgCZGih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:38:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so6359161wrm.4;
        Wed, 25 Mar 2020 23:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtUcOU+hDl2pe+N65kN8jrN1QscIN/CTHShJYFT3a3w=;
        b=LxjckWLTvX4DUPX+8or7v5SdHTPXUgR5o/sZCbikbEv6mhDrI0XJSARPDcr05xXTgo
         WoBKTqn/6DrKSWVW3aDMX7hKCNCz25G5TIdV9bIF5icNUmauLeuoSG7k1NKiidAqECVc
         zv8lfVM8/rORbP/6+U+m9SW5hnAGd70O8UHvrL1dx44GpV4tU4X+oV4MuSqCA0v7U5Dn
         EM+wVVqjGofmIqShwohKta+Hi2WM44QzEGrXD3UM7wzyzHD20gcKiy700Skr2pkEmbAk
         Y/lQ1kWFk+JF9QD2yUe/u3LWmg+xI/N55wfDm42iW7wEKJSXKve8JonG2mgiZLRT9O8V
         6oGA==
X-Gm-Message-State: ANhLgQ2Vrs7mwb5TkT/8u4++ZvkVZgGbhei0WPUFofU+ecJeBCQ/hHkV
        rfbl2wEazGHK8LeNTZTZUvVGT2PiDcXItsJDJiI=
X-Google-Smtp-Source: ADFU+vtDPsqR/AvvKYilDzU/20vKOKaNMo9s7EaUdYaswnBaPAJXRt96ylA+YkFRuVD2ehIg8H+fdtQL9UjxXKuc0g0=
X-Received: by 2002:adf:fe03:: with SMTP id n3mr7642285wrr.266.1585204714794;
 Wed, 25 Mar 2020 23:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <CACAyw9-jJiAAci8dNsGGH7gf6QQCsybC2RAaSq18qsQDgaR4CQ@mail.gmail.com>
 <CAOftzPiDk0C+fCo9L5CWPvVR3RRLeLykQSMKAO4mOc=n8UNYpA@mail.gmail.com> <20200326062514.lc7f6xbg5sg4hhjj@kafai-mbp>
In-Reply-To: <20200326062514.lc7f6xbg5sg4hhjj@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 23:38:23 -0700
Message-ID: <CAOftzPhGs90Ni391ir+1ZZqxrvhbyawsDS9SVCufvD1SbewiXw@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, Lorenz Bauer <lmb@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Mar 25, 2020 at 01:55:59PM -0700, Joe Stringer wrote:
> > On Wed, Mar 25, 2020 at 3:35 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
> > > >
> > > > From: Lorenz Bauer <lmb@cloudflare.com>
> > > >
> > > > Attach a tc direct-action classifier to lo in a fresh network
> > > > namespace, and rewrite all connection attempts to localhost:4321
> > > > to localhost:1234 (for port tests) and connections to unreachable
> > > > IPv4/IPv6 IPs to the local socket (for address tests).
> > >
> > > Can you extend this to cover UDP as well?
> >
> > I'm working on a follow-up series for UDP, we need this too.
> Other than selftests, what are the changes for UDP in patch 1 - 4?

Nothing in those patches, I have refactoring of all of the socket
helpers, skc_lookup_udp() and adding flags to the socket lookup
functions to support only looking for a certain type of sockets -
established or listen. This helps to avoid multiple lookups in these
cases where you really just want to look up established sockets with
the packet tuple first then look up the listener socket with the
unrelated/tproxy tuple. For UDP it makes it easier to find the correct
socket and in general (including TCP) helps to avoid up to two socket
hashtable lookups for this use case. This part is because the current
helpers all look up the established socket first then the listener
socket, so for the first packet that hits these we perform both of
these lookups for the packet tuple (which finds nothing), then look up
an established socket for the target tuple (which finds nothing) then
finally a listen socket for the target tuple. It's about another 300+
/ 250- changes overall, of which a large chunk is one patch that
refactors the code into macros. I haven't narrowed down for sure
whether the lookup flags patch is required for UDP cases yet.
