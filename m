Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036AA188FE1
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCQU4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:56:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53258 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgCQU4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:56:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id 25so834875wmk.3;
        Tue, 17 Mar 2020 13:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FEKnVDxyBC9ZlonFYbDTDfp7q0thhaySUYzcO5Plhs=;
        b=rNnIOSEiDEHYLAFIC5nv85oBwmdLSyT9O2RLbJhHiHwNCNE74i3PA/2uH5iu+b9a43
         3a85kMDa6wRSb9gp/NSP6ZkpthTFbNd8fR2vBiSm9wguyJDdct2ch6HwzYI/7JX2ij2D
         /hJ/hYW2mS6VvdIE7a7KUjHMTeFFbaxGRHUaZJUP4C2DgJ/V+nd6NKM5pnlb2k0yKd+M
         GN/PDawFvYsMkYkwqdgmplCW0E1k01L6JuejSqb/NTWP+IDktUBZ4OoPVrNLVnV7bNAw
         cfgSdmvenShuTZad4ut/SLk9p0H9J+gHo87eHlJbVOs63kSD0HzZIJ/pxUHsQaA37ylp
         pilA==
X-Gm-Message-State: ANhLgQ2sSD8s7PEoji6co3tVJ6/E87LiTIWCpDVsEc2VqMWoeEMHmpvx
        QWv1dC4fjRf2iMIGOeOX2Vx4YHy9cAzquuh5ZUo=
X-Google-Smtp-Source: ADFU+vu7edJpkkTIs7GHSis4k97jkv9UyDrGmidkARgAlfZwmdUsM20wjxLnUB9tTPJikbhlTtkpoOjPW5SaK5j8doU=
X-Received: by 2002:a7b:cb50:: with SMTP id v16mr906245wmj.74.1584478583562;
 Tue, 17 Mar 2020 13:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-6-joe@wand.net.nz>
 <20200317063044.l4csdcag7l74ehut@kafai-mbp>
In-Reply-To: <20200317063044.l4csdcag7l74ehut@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Tue, 17 Mar 2020 13:56:12 -0700
Message-ID: <CAOftzPjBo6r2nymjUn4qr=N4Zd7rF=03=n45HDvyXfSXfDnBtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests: bpf: add test for sk_assign
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 12:31 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 12, 2020 at 04:36:46PM -0700, Joe Stringer wrote:
> > From: Lorenz Bauer <lmb@cloudflare.com>
> >
> > Attach a tc direct-action classifier to lo in a fresh network
> > namespace, and rewrite all connection attempts to localhost:4321
> > to localhost:1234.
> >
> > Keep in mind that both client to server and server to client traffic
> > passes the classifier.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> >  tools/testing/selftests/bpf/.gitignore        |   1 +
> >  tools/testing/selftests/bpf/Makefile          |   3 +-
> >  .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++++++
> >  tools/testing/selftests/bpf/test_sk_assign.c  | 176 ++++++++++++++++++
> Can this test be put under the test_progs.c framework?

I'm not sure, how does the test_progs.c framework handle the logic in
"tools/testing/selftests/bpf/test_sk_assign.sh"?

Specifically I'm looking for:
* Unique netns to avoid messing with host networking stack configuration
* Control over routes
* Attaching loaded bpf programs to ingress qdisc of a device

These are each trivial one-liners in the supplied shell script
(admittedly building on existing shell infrastructure in the tests dir
and iproute2 package). Seems like maybe the netns parts aren't so bad
looking at flow_dissector_reattach.c but anything involving netlink
configuration would either require pulling in a netlink library
dependency somewhere or shelling out to the existing binaries. At that
point I wonder if we're trying to achieve integration of this test
into some automated prog runner, is there a simpler way like a place I
can just add a one-liner to run the test_sk_assign.sh script?

> >  tools/testing/selftests/bpf/test_sk_assign.sh |  19 ++
