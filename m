Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F2F194D6A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgCZXkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:40:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35784 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgCZXkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:40:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id m3so10420643wmi.0;
        Thu, 26 Mar 2020 16:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CVALNZ4DH6smS5VGTWJWkPRe60hQEpwhHv89SpCkxEc=;
        b=ImLGpAIP/KY0Kn4ral2udC4zEsHoYihzWvkFPLSSO9/HMlkrpArkH0ibrKY8aQsbmE
         LCR5eJMVPdKgyAjjyATG5yohsrDGxUU+UB8sBu6dI5O9MjNHLY4GhP/EYaXLjClGp68m
         kA87dEmB3GjC/fvZ4fUS8pQJZtPFzFhi4o8pQR/iMAk/Hp9qaae7iCq8spQvxSnSa3k0
         YjJblVrBeH0KNTJ4jVlksku1rfRo+z4T6GW+WOWcdEQLBk2OyvJmw9ldajhVbNTNpXyn
         /mCl6CZ/lh1mZYNbtUXNyWaNYm2BfpORE2D3OLHNmaLUqd2ijkEXjSmfen94u+CGMMY3
         6xsw==
X-Gm-Message-State: ANhLgQ1W7cZb2gx0Z1XrHtSHbJaNv8fNw4a/KTAjnqwuuGs0G0gY2ihh
        v5BwcxanjAoO10f2tgmVLug1b2VwV3XgXf7HDo8Ftyw1
X-Google-Smtp-Source: ADFU+vvaFtB6sRjtwBgEPsFtHzA8WTJ6lLirZyCCQ5lQ5DxGVqqAaL2vXI6PYkV6uFh4g6F9UvxzsgeNWEp59fnB4sU=
X-Received: by 2002:adf:e584:: with SMTP id l4mr7260815wrm.388.1585266020734;
 Thu, 26 Mar 2020 16:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <CACAyw9-jJiAAci8dNsGGH7gf6QQCsybC2RAaSq18qsQDgaR4CQ@mail.gmail.com>
 <CAOftzPiDk0C+fCo9L5CWPvVR3RRLeLykQSMKAO4mOc=n8UNYpA@mail.gmail.com>
 <20200326062514.lc7f6xbg5sg4hhjj@kafai-mbp> <CAOftzPhGs90Ni391ir+1ZZqxrvhbyawsDS9SVCufvD1SbewiXw@mail.gmail.com>
In-Reply-To: <CAOftzPhGs90Ni391ir+1ZZqxrvhbyawsDS9SVCufvD1SbewiXw@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 26 Mar 2020 16:39:55 -0700
Message-ID: <CAOftzPg9msjF7aky6M7OvN+6YbxVdBpuwM78ETpFJ_YGfwe63w@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Martin KaFai Lau <kafai@fb.com>, Lorenz Bauer <lmb@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:38 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> On Wed, Mar 25, 2020 at 11:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Mar 25, 2020 at 01:55:59PM -0700, Joe Stringer wrote:
> > > On Wed, Mar 25, 2020 at 3:35 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
> > > > >
> > > > > From: Lorenz Bauer <lmb@cloudflare.com>
> > > > >
> > > > > Attach a tc direct-action classifier to lo in a fresh network
> > > > > namespace, and rewrite all connection attempts to localhost:4321
> > > > > to localhost:1234 (for port tests) and connections to unreachable
> > > > > IPv4/IPv6 IPs to the local socket (for address tests).
> > > >
> > > > Can you extend this to cover UDP as well?
> > >
> > > I'm working on a follow-up series for UDP, we need this too.
> > Other than selftests, what are the changes for UDP in patch 1 - 4?
>
> Nothing in those patches, I have refactoring of all of the socket
> helpers, skc_lookup_udp() and adding flags to the socket lookup
> functions to support only looking for a certain type of sockets -
> established or listen. This helps to avoid multiple lookups in these
> cases where you really just want to look up established sockets with
> the packet tuple first then look up the listener socket with the
> unrelated/tproxy tuple. For UDP it makes it easier to find the correct
> socket and in general (including TCP) helps to avoid up to two socket
> hashtable lookups for this use case. This part is because the current
> helpers all look up the established socket first then the listener
> socket, so for the first packet that hits these we perform both of
> these lookups for the packet tuple (which finds nothing), then look up
> an established socket for the target tuple (which finds nothing) then
> finally a listen socket for the target tuple. It's about another 300+
> / 250- changes overall, of which a large chunk is one patch that
> refactors the code into macros. I haven't narrowed down for sure
> whether the lookup flags patch is required for UDP cases yet.

FWIW I did some more testing and it was not apparent that
skc_lookup_udp is at all necessary, I was able to roll in UDP support
in the next revision of this series with no special extra patches.

I'll keep working on those other optimizations in the background though.
