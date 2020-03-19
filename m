Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1118AC6D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCSFqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:46:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51108 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSFqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 01:46:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id z13so628405wml.0;
        Wed, 18 Mar 2020 22:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5vd53o8Bhbj83gVxusGt4kiAUbgdOP3qtnG2UsNxDF4=;
        b=OGLfZbGGMrFQZxG/JSvCk1gDKrS5XHDKS2f/Yo6reab+fG4B9AI/kI41gURWNh6Lgu
         If8jt18Ptj6nPs51X0gtXoHbES9w5/p8P6c2fvBeg9fTbu9uUq5HRw+StL4kHYvGVqJk
         ygNGh2Nhz8es/hG04Fq3KqFDIOcRJM21uH5/5AJIHFZX3D0eFwXWUjH0bW0Z0idn7MBy
         ZHSdf0IjpZo3a8yKceckJWVauntvashOpnhJfWQQNpmyz0M2L3//1RcV3BOZDIaKK6nb
         MDb6Kxra8T5Fe+UXoumMCTnWSdpF1+W0XuP/wWlW4pp4xfWD3X41HjJJfX1+WFNdNW3M
         LqyA==
X-Gm-Message-State: ANhLgQ148wsulSsIemwe6MwQUvANl3In9hLXxM/DvcHzgY88/cc3fGWr
        FP2a4Xln4VqmI6x9pljF1xo/MKHeB1weScvCVhlHTQ==
X-Google-Smtp-Source: ADFU+vuZVCbYQ5OfSlkrUhqZ0STc5kGaqqzN96nHoR2DbKCFV3IcgaR56Y7o70rCfsgAF62D8p3wHxw/fbJJbnvgQ2o=
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr1571712wme.185.1584596779992;
 Wed, 18 Mar 2020 22:46:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-6-joe@wand.net.nz>
 <20200317063044.l4csdcag7l74ehut@kafai-mbp> <CAOftzPjBo6r2nymjUn4qr=N4Zd7rF=03=n45HDvyXfSXfDnBtg@mail.gmail.com>
 <20200318172735.kxwuvccegquupkwh@kafai-mbp>
In-Reply-To: <20200318172735.kxwuvccegquupkwh@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 18 Mar 2020 22:45:58 -0700
Message-ID: <CAOftzPguUws6sVKg0PQ4pQNhOQL5Q14XiwpHb60=271Jcw+pnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests: bpf: add test for sk_assign
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:28 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Mar 17, 2020 at 01:56:12PM -0700, Joe Stringer wrote:
> > On Tue, Mar 17, 2020 at 12:31 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Mar 12, 2020 at 04:36:46PM -0700, Joe Stringer wrote:
> > > > From: Lorenz Bauer <lmb@cloudflare.com>
> > > >
> > > > Attach a tc direct-action classifier to lo in a fresh network
> > > > namespace, and rewrite all connection attempts to localhost:4321
> > > > to localhost:1234.
> > > >
> > > > Keep in mind that both client to server and server to client traffic
> > > > passes the classifier.
> > > >
> > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > > ---
> > > >  tools/testing/selftests/bpf/.gitignore        |   1 +
> > > >  tools/testing/selftests/bpf/Makefile          |   3 +-
> > > >  .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++++++
> > > >  tools/testing/selftests/bpf/test_sk_assign.c  | 176 ++++++++++++++++++
> > > Can this test be put under the test_progs.c framework?
> >
> > I'm not sure, how does the test_progs.c framework handle the logic in
> > "tools/testing/selftests/bpf/test_sk_assign.sh"?
> >
> > Specifically I'm looking for:
> > * Unique netns to avoid messing with host networking stack configuration
> > * Control over routes
> > * Attaching loaded bpf programs to ingress qdisc of a device
> >
> > These are each trivial one-liners in the supplied shell script
> > (admittedly building on existing shell infrastructure in the tests dir
> > and iproute2 package). Seems like maybe the netns parts aren't so bad
> > looking at flow_dissector_reattach.c but anything involving netlink
> > configuration would either require pulling in a netlink library
> > dependency somewhere or shelling out to the existing binaries. At that
> > point I wonder if we're trying to achieve integration of this test
> > into some automated prog runner, is there a simpler way like a place I
> > can just add a one-liner to run the test_sk_assign.sh script?
> I think running a system(cmd) in test_progs is fine, as long as it cleans
> up everything when it is done.  There is some pieces of netlink
> in tools/lib/bpf/netlink.c that may be reuseable also.
>
> Other than test_progs.c, I am not aware there is a script to run
> all *.sh.  I usually only run test_progs.
>
> Cc: Andrii who has fixed many selftest issues recently.

OK, unless I get some other guidance I'll take a stab at this.
